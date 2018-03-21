//
//  LauchViewController.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/9/4.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "LauchViewController.h"
#import "YMTool.h"
#import "NSString+Catogory.h"
#import "YMWebController.h"


@interface LauchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation LauchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [YMTool addTapGestureOnView:_imgView target:self selector:@selector(pushURL:) viewController:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)pushURL:(UITapGestureRecognizer* )tap{
    DDLog(@"跳转");
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
        DDLog(@" resObj == %@",resObj);
        NSDictionary* dataDic = resObj[@"data"];
        if (![NSString isEmptyString:dataDic]) {
            if ([dataDic[@"show_url"] integerValue] == 1 ) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dataDic[@"url"]]];
            }
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLog(@"error == %@",error);
    }];
}

@end
