//
//  NoServerViewController.m
//  jikedai
//
//  Created by jikedai on 2018/3/7.
//  Copyright © 2018年 jikedai. All rights reserved.
//

#import "NoServerViewController.h"
#import "YMWebController.h"
#import "NSString+Catogory.h"

@interface NoServerViewController ()
@property (nonatomic, strong)AFNetworkReachabilityManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *freshBtn;

@end

@implementation NoServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)loadUIData{
    //创建导航
    
    _freshBtn.backgroundColor = TabBarTintColor;
    
    //[YMTool viewLayerWithView:_freshBtn cornerRadius:8 boredColor:kClearColor borderWidth:1];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 提示：要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    __weak AFNetworkReachabilityManager *weakManager = manager;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == -1) {
            NSLog(@"未识别网络");
        }
        if (status == 0) {
            NSLog(@"未连接网络");
        }
        if (status == 1) {
            NSLog(@"3G/4G网络");
            [self refresh:nil];
        }
        if (status == 2) {
            [self refresh:nil];
            NSLog(@"Wifi网络");
        }
    }];
    self.manager = manager;
}
- (IBAction)refresh:(id)sender {
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
        if (![NSString isNull:dataDic]) {
            if ([dataDic[@"show_url"] integerValue] == 1 ) {
                // [self pushToLauch];
                //加载网页
//                YMWebController * wvc = [[YMWebController alloc]init];
//                wvc.urlStr = dataDic[@"url"];
//                kUIWindow.rootViewController = wvc;
                
            }else{
                
            }
        }else{
            
        }
        if (self.bolck_getServer) {
            self.bolck_getServer(dataDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showFail:@"未连接到网络" view:kUIWindow];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
