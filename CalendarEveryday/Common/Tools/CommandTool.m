//
//  CommandTool.m
//  jikedai
//
//  Created by jikedai on 2018/1/2.
//  Copyright © 2018年 jikedai. All rights reserved.
//

#import "CommandTool.h"
#import "NoServerViewController.h"
#import "YMWebController.h"
#import "YMTool.h"
#import "NSString+Catogory.h"

@interface CommandTool ()


@end

@implementation CommandTool

- (instancetype)init {
    self = [super init];
    if (self) {
      
        [self initCommand];
    }
    return self;
}

- (void)initCommand {
    
    self.command_Audit = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
            httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
            //AFN设置请求头方法
            [httpMgr.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
            NSDictionary* param  = @{
                                     @"type":@"ios",
                                     @"appid":kAppleId
                                     };
            [httpMgr GET:[NSString stringWithFormat:@"http://app.412988.com/Lottery_server/check_and_get_url.php?type=ios&appid=%@",kAppleId] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                DDLog(@"GET show_url resObj == %@",resObj);
                NSDictionary* dataDic = resObj[@"data"];
//                dataDic = @{@"show_url":@"0",
//                            @"url":@"https://www.baidu.com"
//                            };
                if (![NSString isNull:dataDic]) {
                    if ([dataDic[@"show_url"] integerValue] == 1 ) {
                        // [self pushToLauch];
                        //加载网页
//                        YMWebController * wvc = [[YMWebController alloc]init];
//                        wvc.urlStr = dataDic[@"url"];
//                        kUIWindow.rootViewController = wvc;
                    }else{
                    
                    }
                }else{
                   
                }
                [subscriber sendNext:dataDic];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NoServerViewController *VC = [[NoServerViewController alloc] init];
                kUIWindow.rootViewController = VC;
                VC.bolck_getServer = ^(NSDictionary *dataDic){

                    [subscriber sendNext:dataDic];
                    [subscriber sendCompleted];
                };
            }];

            return nil;
        }];
    }];






    
}
@end
