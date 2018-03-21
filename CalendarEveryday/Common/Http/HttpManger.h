//
//  HttpManger.h
//  121Order
//
//  Created by duyong_july on 16/5/3.
//  Copyright © 2016年 tiaoshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpManger : NSObject

//单例对象
+ (HttpManger *) sharedInstance ;
//返回拼接好的字符串
- (NSString *)httpReqURL:(NSString *)key;
//根据param 生成token
-(NSString* )getTokenWithParam:(NSDictionary* )params;

//带刷新tableView网络请求接口
- (void)callHTTPReqAPI:(NSString *)api
                params:(NSDictionary *)params
                  view:(UIView* )view
               loading:(BOOL)loading
             tableView:(UITableView *)tableview
     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion;

//带刷新 可编辑请求接口
- (void)callHTTPReqAPI:(NSString *)api
                params:(NSDictionary *)params
                  view:(UIView* )view
                isEdit:(BOOL)isEdit
               loading:(BOOL)loading
             tableView:(UITableView *)tableview
     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion;

//可编辑 get 请求
- (void)getHTTPReqAPI:(NSString *)api
               params:(NSDictionary *)params
                 view:(UIView* )view
                isEdit:(BOOL)isEdit
              loading:(BOOL)loading
            tableView:(UITableView *)tableview
    completionHandler:(void (^)(id task, id responseObject, NSError *error))completion;


//上传多文件 网络请求接口
- (void)postFileHTTPReqAPI:(NSString *)api
                params:(NSDictionary *)params
               imgsArr:(NSMutableArray*)imgsArr
                  view:(UIView* )view
               loading:(BOOL)loading
     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion;

//上传多文件 网络请求接口
- (void)postFileHTTPReqAPI:(NSString *)api
                    params:(NSDictionary *)params
                   imgsArr:(NSMutableArray*)imgsArr
                   imgsKey:(NSString* )imgsKey
                      view:(UIView* )view
                   loading:(BOOL)loading
         completionHandler:(void (^)(id task, id responseObject, NSError *error))completion;


////需要处理 failure error 判断的网络请求接口
//- (void)callHTTPReqAPI:(NSString *)api
//                params:(NSDictionary *)params
//                  view:(UIView* )view
//             tableView:(UITableView *)tableView
//               loading:(BOOL)loading
//                isEdit:(BOOL)isEdit
//     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion;


////网页登陆
//- (void)callWebHTTPReqAPI:(NSString *)api
//                params:(NSDictionary *)params
//                  view:(UIView* )view
//               loading:(BOOL)loading
//             tableView:(UITableView *)tableview
//     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion;

////带刷新tableView网络请求get接口
//- (void)getHTTPReqAPI:(NSString *)api
//                params:(NSDictionary *)params
//                  view:(UIView* )view
//               loading:(BOOL)loading
//             tableView:(UITableView *)tableview
//     completionHandler:(void (^)(id task, id responseObject, NSError *error))completion;


@end
