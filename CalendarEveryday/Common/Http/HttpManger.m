//
//  HttpManger.m
//  121Order
//
//  Created by duyong_july on 16/5/3.
//  Copyright © 2016年 tiaoshi. All rights reserved.
//

#import "HttpManger.h"
#import "NSString+Hash.h"
#import "NSString+Catogory.h"
#import "YMLoginController.h"
#import "YMNavigationController.h"
#import "YMTool.h"
#import "UIImage+Extension.h"


#define kCookie     @"cookie"
#define PrivalStr   @"89cda86a12b6e3106ab161a19a504a7f"

@interface HttpManger ()

@property(nonatomic,strong)MBProgressHUD* HUD;
@end
@implementation HttpManger

/*
 单实例
 */
static  HttpManger* _sharedInstance;

static dispatch_queue_t serialQueue;
//单例对象
+ (HttpManger *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HttpManger alloc] init];
    });
    return _sharedInstance;
}

//返回拼接好的字符串
- (NSString *)httpReqURL:(NSString *)key{
    NSString *result = [NSString stringWithFormat:@"%@%@",BaseApi,key];
    return result;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        serialQueue = dispatch_queue_create("com.121Order.HttpManger.SerialQueue", NULL);
        if (_sharedInstance == nil) {
            _sharedInstance = [[super allocWithZone:zone]init];
        }
    });
    return _sharedInstance;
}
//根据param 生成token
-(NSString* )getTokenWithParam:(NSDictionary* )params{
    //获取参数中所有的key 按字母顺序进行排序
    NSMutableArray *sortKeyArr = [[NSMutableArray alloc]initWithArray:[params allKeys]];
    //a按照首位排序
    sortKeyArr = [[NSMutableArray alloc] initWithArray:[sortKeyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //  return [obj1 compare:obj2 options:NSNumericSearch]; // 按数字排序
        return [obj1 compare:obj2 options:NSForcedOrderingSearch];
    }]];
    DDLog(@"sortKeyArr============ %@",sortKeyArr);
    //签名字符串
    NSMutableString* tmpSignStr = [[NSMutableString alloc]init];
    for (int i = 0 ;i < sortKeyArr.count ; i ++) {
        
        NSString *tmpStr = sortKeyArr[i];
        //最后一个
        if (i == sortKeyArr.count - 1) {
            tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",tmpStr,[params valueForKey:tmpStr]]]mutableCopy];
        }else{
            tmpSignStr = [[tmpSignStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",tmpStr,[params valueForKey:tmpStr]]]mutableCopy];
        }
    }
    DDLog(@"排序后拼接的参数 == %@",tmpSignStr);

    NSString* token = [NSString stringWithFormat:@"%@%@",tmpSignStr,PrivalStr].base64Endcode. md5String;
    return token;
}


- (void)callHTTPReqAPI:(NSString *)api
                params:(NSDictionary *)params
                  view:(UIView* )view
               loading:(BOOL)loading
             tableView:(UITableView *)tableview
     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion {
    //生成新的参数字典
    NSMutableDictionary* newParamDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    [newParamDic setObject:Version forKey:@"v"];
    
    NSString* sign = [[HttpManger sharedInstance]getTokenWithParam:newParamDic];
    [newParamDic setObject:sign forKey:@"sign"];
    DDLog(@"最终的token == %@",newParamDic);

    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
      hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
     DDLog(@"url === %@  newparam == %@",api,newParamDic);
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //AFN设置请求头方法
    [httpMgr.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    [httpMgr POST:api parameters:newParamDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud removeFromSuperview];
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@" resObj == %@",resObj);
        NSString *respStatus = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"code"]];
        //返回信息
        NSString* msg = resObj[@"msg"];
        //成功 200 成功
        if ([respStatus intValue] == 200) {
            completion(task, resObj, nil);
        }else{
            // token token 失效
            if ([TOKEN_TIMEOUT isEqualToString:respStatus] ) {
                YMLoginController* lvc = [[YMLoginController alloc]init];
                YMNavigationController* nav = [[YMNavigationController alloc] initWithRootViewController:lvc];
                //递归 找到app的根控制器
                UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                while (topRootViewController.presentedViewController)
                {
                    topRootViewController = topRootViewController.presentedViewController;
                }
                DDLog(@"topRootViewController == %@",topRootViewController);
                if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
                    [topRootViewController presentViewController:nav animated:YES completion:nil];
                }
            }else{
                [MBProgressHUD showFail: msg view:view];
            }
            DDLog(@"调试失败信息 %@ = \n",[NSString stringWithFormat:@"%@",resObj[@"msg"]]);
        }
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //DDLog(@"最后的参数＝＝＝＝＝＝＝＝ %@  \n  请求接口 api＝＝＝＝=== %@",newParamDic,api);
            DDLog(@"请求失败 task == %@   error === %@",task,error);
            [hud removeFromSuperview];
            [MBProgressHUD showNetErrorInView:view];
            if (tableview != nil) {
                [tableview.mj_header endRefreshing];
                [tableview.mj_footer endRefreshing];
            }
    }];
}
//带刷新 可编辑请求接口
- (void)callHTTPReqAPI:(NSString *)api
                params:(NSDictionary *)params
                  view:(UIView* )view
                isEdit:(BOOL)isEdit
               loading:(BOOL)loading
             tableView:(UITableView *)tableview
     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion{
  
    //生成新的参数字典
    NSMutableDictionary* newParamDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    [newParamDic setObject:Version forKey:@"v"];

    NSString* sign = [[HttpManger sharedInstance]getTokenWithParam:params];
    [newParamDic setObject:sign forKey:@"sign"];
    
    DDLog(@"最终的token == %@",newParamDic);
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
        hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
    DDLog(@"url === %@  newparam == %@",api,newParamDic);
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //AFN设置请求头方法
    [httpMgr.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    [httpMgr POST:api parameters:newParamDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud removeFromSuperview];
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@" resObj == %@",resObj);
//        NSString *respStatus = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"status"]];
//        //返回信息
//        NSString* msg = resObj[@"msg"];
        //成功 1 2
        if (isEdit == YES) {
            completion(task, resObj, nil);
        }
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //DDLog(@"最后的参数＝＝＝＝＝＝＝＝ %@  \n  请求接口 api＝＝＝＝=== %@",newParamDic,api);
        DDLog(@"请求失败 task == %@   error === %@",task,error);
        [hud removeFromSuperview];
        [MBProgressHUD showNetErrorInView:view];
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    }];
}
//上传多文件 网络请求接口
- (void)postFileHTTPReqAPI:(NSString *)api
                    params:(NSDictionary *)params
                   imgsArr:(NSMutableArray*)imgsArr
                      view:(UIView* )view
                   loading:(BOOL)loading
         completionHandler:(void (^)(id task, id responseObject, NSError *error))completion{
    //生成新的参数字典
    NSMutableDictionary* newParamDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    [newParamDic setObject:Version forKey:@"v"];
    
    NSString* sign = [[HttpManger sharedInstance]getTokenWithParam:params];
    [newParamDic setObject:sign forKey:@"sign"];
    DDLog(@"最终的token == %@",newParamDic);
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
        hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
    DDLog(@"url === %@  newparam == %@",api,newParamDic);
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //AFN设置请求头方法
    [httpMgr.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    httpMgr.requestSerializer.timeoutInterval = 20;
    httpMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [httpMgr POST:api parameters:newParamDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       // 利用for循环上传多张图片
        int i = 1;
        for (UIImage * image in imgsArr) {
            //把图片转换为二进制流
            NSData* imgData = [UIImage imgDataByImage:image];
            DDLog(@" 压缩 图片 前 data == %lu  kb ",imgData.length/1000);
            if (imgData.length/1000 > 2 * 1000) {
                imgData = [UIImage compressOriginalImage:image toMaxDataSizeKBytes:0.5 * 1024];
                DDLog(@" 压缩 图片 后 文件大小 == %lu kb ",imgData.length/1000);
            }
           // NSData *imageData = UIImagePNGRepresentation(image);
            //按照表单格式把二进制文件写入formData表单
            [formData appendPartWithFileData:imgData name:@"upfile" fileName:[NSString stringWithFormat:@"%d.png", i] mimeType:@"image/png"];
            i++;
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        [hud removeFromSuperview];
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@" resObj == %@",resObj);
        NSString *respStatus = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"code"]];
        //返回信息
        NSString* msg = resObj[@"msg"];
        if ([respStatus isEqualToString:SUCCESS]) {
            completion(task, resObj, nil);
        }else{
            // token token 失效
            if ([TOKEN_TIMEOUT isEqualToString:respStatus] ) {
                YMLoginController* lvc = [[YMLoginController alloc]init];
                YMNavigationController* nav = [[YMNavigationController alloc] initWithRootViewController:lvc];
                //递归 找到app的根控制器
                UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                while (topRootViewController.presentedViewController)
                {
                    topRootViewController = topRootViewController.presentedViewController;
                }
                DDLog(@"topRootViewController == %@",topRootViewController);
                if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
                    [topRootViewController presentViewController:nav animated:YES completion:nil];
                }
            }else{
                [MBProgressHUD showFail: msg view:view];
            }
            DDLog(@"调试失败信息 %@ = \n",[NSString stringWithFormat:@"%@",resObj[@"msg"]]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLog(@"请求失败 task == %@   error === %@",task,error);
        [hud removeFromSuperview];
        [MBProgressHUD showNetErrorInView:view];
    }];
}
//上传多文件 网络请求接口
- (void)postFileHTTPReqAPI:(NSString *)api
                    params:(NSDictionary *)params
                   imgsArr:(NSMutableArray*)imgsArr
                   imgsKey:(NSString* )imgsKey
                      view:(UIView* )view
                   loading:(BOOL)loading
         completionHandler:(void (^)(id task, id responseObject, NSError *error))completion
{
    //生成新的参数字典
    NSMutableDictionary* newParamDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    [newParamDic setObject:Version forKey:@"v"];
    
    NSString* sign = [[HttpManger sharedInstance]getTokenWithParam:params];
    [newParamDic setObject:sign forKey:@"sign"];
    DDLog(@"最终的token == %@",newParamDic);
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
        hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
    DDLog(@"url === %@  newparam == %@",api,newParamDic);
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //AFN设置请求头方法
    [httpMgr.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    httpMgr.requestSerializer.timeoutInterval = 20;
    httpMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [httpMgr POST:api parameters:newParamDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 利用for循环上传多张图片
        int i = 0;
       // NSString* imgName;
        for (UIImage * image in imgsArr) {
            //把图片转换为二进制流
            NSData* imgData = [UIImage imgDataByImage:image];
            DDLog(@" 原始 图片文件大小 == %lu kb",imgData.length/1000);
            if (imgData.length/1000 > 2 * 1000) {
                DDLog(@" 压缩 图片 前 data == %lu  kb ",imgData.length/1000);
                imgData = [UIImage compressOriginalImage:image toMaxDataSizeKBytes:0.5 * 1024];
                DDLog(@" 压缩 图片 后 文件大小 == %lu kb ",imgData.length/1000);
            }
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"%@%d",imgsKey,i] fileName:[NSString stringWithFormat:@"%d.png", i] mimeType:@"image/png"];
            [params setValue:formData forKey:[NSString stringWithFormat:@"%@%d",imgsKey,i]];
            DDLog(@"formData == %@",formData);
            i++;
             DDLog(@"上传。param == %@",params);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud removeFromSuperview];
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@" resObj == %@",resObj);
       // NSString *respStatus = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"status"]];
        //返回信息
       // NSString* msg = resObj[@"msg"];
       // if ([respStatus isEqualToString:SUCCESS]) {
            completion(task, resObj, nil);
//        }else{
//            // token token 失效
//            if ([TOKEN_TIMEOUT isEqualToString:respStatus] ) {
//                YMLoginController* lvc = [[YMLoginController alloc]init];
//                YMNavigationController* nav = [[YMNavigationController alloc] initWithRootViewController:lvc];
//                //递归 找到app的根控制器
//                UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//                while (topRootViewController.presentedViewController)
//                {
//                    topRootViewController = topRootViewController.presentedViewController;
//                }
//                DDLog(@"topRootViewController == %@",topRootViewController);
//                if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
//                    [topRootViewController presentViewController:nav animated:YES completion:nil];
//                }
//            }else{
//                [MBProgressHUD showFail: msg view:view];
//            }
//            DDLog(@"调试失败信息 %@ = \n",[NSString stringWithFormat:@"%@",resObj[@"msg"]]);
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLog(@"请求失败 task == %@   error === %@",task,error);
        [hud removeFromSuperview];
        [MBProgressHUD showNetErrorInView:view];
    }];
}

//可编辑 get 请求
- (void)getHTTPReqAPI:(NSString *)api
               params:(NSDictionary *)params
                 view:(UIView* )view
               isEdit:(BOOL)isEdit
              loading:(BOOL)loading
            tableView:(UITableView *)tableview
    completionHandler:(void (^)(id task, id responseObject, NSError *error))completion{
    
    DDLog(@"api  ==  %@  \n param == %@",api,params);
    //生成新的参数字典
    NSMutableDictionary* newParamDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    [newParamDic setObject:Version forKey:@"v"];
    
    NSString* sign = [[HttpManger sharedInstance]getTokenWithParam:params];
    [newParamDic setObject:sign forKey:@"sign"];
    
    DDLog(@"最终的token == %@",newParamDic);
    NSString* newApi = [NSString stringWithFormat:@"%@&token=%@",api,sign];
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
        hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpMgr GET:newApi parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud removeFromSuperview];
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"url === %@",newApi);
        DDLog(@" resObj == %@",resObj);
        NSString *respStatus = [NSString stringWithFormat:@"%@",[resObj objectForKey:@"code"]];
        //返回信息
        NSString* msg = resObj[@"msg"];
        //成功 1 2
        if (isEdit == YES) {
            completion(task, resObj, nil);
        }else{
            if ([respStatus intValue] == 1) {
                completion(task, resObj, nil);
            }else{
                // token token 失效
                if ([TOKEN_TIMEOUT isEqualToString:respStatus] ) {
                    YMLoginController* lvc = [[YMLoginController alloc]init];
                    YMNavigationController* nav = [[YMNavigationController alloc] initWithRootViewController:lvc];
                    //递归 找到app的根控制器
                    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                    while (topRootViewController.presentedViewController)
                    {
                        topRootViewController = topRootViewController.presentedViewController;
                    }
                    DDLog(@"topRootViewController == %@",topRootViewController);
                    if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
                        [topRootViewController presentViewController:nav animated:YES completion:nil];
                    }
                }else{
                    [MBProgressHUD showFail: msg view:view];
                }
                DDLog(@"调试失败信息 %@ = \n",[NSString stringWithFormat:@"%@",resObj[@"msg"]]);
            }        }
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLog(@"最后的参数＝＝＝＝＝＝＝＝ %@  \n  请求接口 api＝＝＝＝=== %@ \n  error === %@",newParamDic,api,error);
        [hud removeFromSuperview];
        [MBProgressHUD showNetErrorInView:view];
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    }];
}
//网页登陆
- (void)callWebHTTPReqAPI:(NSString *)api
                   params:(NSDictionary *)params
                     view:(UIView* )view
                  loading:(BOOL)loading
                tableView:(UITableView *)tableview
        completionHandler:(void (^)(id task, id responseObject, NSError *error))completion{
    
    DDLog(@"param == %@",params);
    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    if (loading) {
        hud = [MBProgressHUD showMessag:@"加载中" toView:view];
    }
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpMgr POST:api parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [hud removeFromSuperview];
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"newParams == %@  \n api == %@ ",params,api);
        DDLog(@" resObj == %@",resObj);
        completion(task, resObj, nil);
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //DDLog(@"最后的参数＝＝＝＝＝＝＝＝ %@  \n  请求接口 api＝＝＝＝=== %@",newParamDic,api);
        DDLog(@"请求失败 task == %@   error === %@",task,error);
        [hud removeFromSuperview];
        [MBProgressHUD showNetErrorInView:view];
        if (tableview != nil) {
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
        }
    }];
}

//- (MBProgressHUD *)HUD{
//    if (!_HUD) {
//        MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:KeyWindow];
//        [KeyWindow addSubview:hud];
//        hud.labelText = @"努力上传中";
//        hud.labelFont = [UIFont systemFontOfSize:12];
//        hud.mode = MBProgressHUDModeAnnularDeterminate;
//        hud.progress = 0;
//        _HUD = hud;
//    }
//    return _HUD;
//}
@end
