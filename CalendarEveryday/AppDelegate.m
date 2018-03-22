//
//  AppDelegate.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "AppDelegate.h"
#import "YMTabBarController.h"
#import "YMWelcomeController.h"
#import <AVFoundation/AVFoundation.h>
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "NSString+Catogory.h"
#import "HttpManger.h"
#import "YMWebController.h"
#import "LauchViewController.h"
#import "TabBarController.h"
#import "YMTool.h"
#import "YMTopNewsController.h"
#import "YMTabBarController.h"
#import "CommandTool.h"


@interface AppDelegate ()<UIAlertViewDelegate>

@property (strong, nonatomic) UIView *splashView;
@property(nonatomic,assign)BOOL isShow;
@end

@implementation AppDelegate
//打开wifi
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {//prefs:root=General&path=About
        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            NSLog(@"can not open");  
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      DDLog(@"didFinishLaunchingWithOptions");
    // 实例化UIWindow，特殊的UIView
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置窗口的背景颜色
    self.window.backgroundColor = [UIColor whiteColor];
    
    //注册极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            DDLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            DDLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    //    如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:kChannel
                 apsForProduction:kIsProduct
            advertisingIdentifier:nil];
    
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *currentLanguage = languages.firstObject;
    NSLog(@"模拟器当前语言：%@",currentLanguage);
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hans-CN"] ||[currentLanguage isEqualToString:@"zh-Hant"] ||[currentLanguage isEqualToString:@"zh-Hant-CN"] ||[currentLanguage hasPrefix:@"zh"]) {
          //中文情况下请求数据
        DDLog(@"跳转");
        //监听网络情况
//        if (![YMTool connectedToNetwork]) {
//            UIViewController* vc = [[UIViewController alloc]init];
//            vc.view.backgroundColor = WhiteColor;
//            self.window.rootViewController = vc;
//            [self.window makeKeyAndVisible];
        
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请连接网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
//
//            return YES;
//        }
        //加载数据前在显示启动图
        self.window.rootViewController =  [[UIStoryboard storyboardWithName:@"LaunchScreen-Chinese" bundle:nil] instantiateInitialViewController];
        // 让窗口变成主窗口并且可见
        [self.window makeKeyAndVisible];
//        UIViewController* vc = [[UIViewController alloc]init];
//        vc.view.backgroundColor = WhiteColor;
//        self.window.rootViewController = vc;
//        [self.window makeKeyAndVisible];
        
        [self pushURL:nil];
        
    }else{
        [self pushToPoem];
    }
     return YES;
}
-(void)pushURL:(UITapGestureRecognizer* )tap{
    RACSubject *subject_init = [[RACSubject alloc] init];
    CommandTool * command = [[CommandTool alloc] init];
    [[[subject_init flattenMap:^RACStream *(id value) {
        // 检查是否在审核
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[command.command_Audit.executionSignals switchToLatest] subscribeNext:^(NSDictionary * x) {
//                [kUserDefaults setBool:[x boolValue] forKey:kIsAudit];
//                [kUserDefaults synchronize];
                [subscriber sendNext:x];
                [subscriber sendCompleted];
            }];
            [command.command_Audit execute:@YES];
            return nil;
        }];
    }] flattenMap:^RACStream *(NSDictionary* value){
        NSLog(@"value == %@",value);
        if ([value[@"show_url"] integerValue] == 1) {
            YMWebController * wvc = [[YMWebController alloc]init];
            wvc.urlStr = value[@"url"];
            kUIWindow.rootViewController = wvc;
        }else{
          [self pushToPoem];
        }
        return nil;
    }] subscribeNext:^(id x) {
        
    }];
    [subject_init sendNext:@1];
//    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
//    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    //AFN设置请求头方法
//    [httpMgr.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
//    NSDictionary* param  = @{
//                             @"type":@"ios",
//                             @"appid":kAppleId
//                             };
//    [httpMgr GET:[NSString stringWithFormat:@"http://app.412988.com/Lottery_server/check_and_get_url.php?type=ios&appid=%@",kAppleId] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        DDLog(@" resObj == %@",resObj);
//        NSDictionary* dataDic = resObj[@"data"];
//        if (![NSString isEmptyString:dataDic]) {
//            if ([dataDic[@"show_url"] integerValue] == 1 ) {
//               // [self pushToLauch];
//                //加载网页
//                YMWebController * wvc = [[YMWebController alloc]init];
//                wvc.urlStr = dataDic[@"url"];
//                self.window.rootViewController = wvc;
//
//            }else{
//                [self pushToPoem];
//            }
//        }else{
//            [self pushToPoem];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self pushToPoem];
//    }];
}

-(BOOL)pushToPoem{
    [[UINavigationBar appearance] setTintColor:HEX(@"ef5316")];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:HEX(@"ef5316")}];
    
    //1.从本地获取poem.db
    NSString *loaclPath = [[NSBundle mainBundle] pathForResource:@"poem.db" ofType:nil];
    //NSLog(@"%@",loaclPath);
    //2.把poem.db放到沙盒
    //2.1 获取沙盒路径
    NSString *sanboxPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"poem.db"];
    NSLog(@"%@",sanboxPath);
    //2.2 拷贝文件到沙盒中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:sanboxPath]) {
        [fileManager copyItemAtPath:loaclPath toPath:sanboxPath error:nil];
    }
    self.window.rootViewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    // 让窗口变成主窗口并且可见
    [self.window makeKeyAndVisible];
    
    return YES;
}

//-(BOOL)pushToLauch{
//    //设置导航栏按钮的颜色
////    [[UINavigationBar appearance]setTintColor:NavBarTintColor];
////    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    // 实例化UIWindow，特殊的UIView
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    // 设置窗口的背景颜色
//    self.window.backgroundColor = [UIColor whiteColor];
//    if(![YMTool connectedToNetwork]){
//
//        self.window.rootViewController =  [[UIStoryboard storyboardWithName:@"LaunchScreen-Chinese" bundle:nil] instantiateInitialViewController];
//        // 让窗口变成主窗口并且可见
//        [self.window makeKeyAndVisible];
//    }else{
//        
//        LauchViewController* lvc = [[LauchViewController alloc]init];
//        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:lvc];
//        
//        self.window.rootViewController = nav;
//        // 让窗口变成主窗口并且可见
//        [self.window makeKeyAndVisible];
//    }
//    
//    return YES;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    DDLog(@"ResignActive");
}
//进入后台 显示多少条  消息
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DDLog(@"willEnterForeground");
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - 注册极光推送 上报 deviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DDLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
#pragma mark -  点开会响应这个
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    //设置badge值，本地仍须调用UIApplication:setApplicationIconBadgeNumber函数
//    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//小红点清0操作
//    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);  // 系统要求执行这个方法
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    //设置badge值，本地仍须调用UIApplication:setApplicationIconBadgeNumber函数
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//小红点清0操作
    
    //ios10 收到消息通知
    NSDictionary * userInfo = notification.request.content.userInfo;
    DDLog(@"ios 10 收到推送 %@",userInfo);
    if ([userInfo[@"redirectUrl"] isEqualToString:@"message"]) {
        DDLog(@"系统消息列表");
    }
    if ([userInfo[@"redirectUrl"] isEqualToString:@"redpaper"]) {
        DDLog(@"红包列表");
    }
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    //本地通知
    else{
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
    //如果应用在前台，在这里执行
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息" message:notification.request.content.userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil,nil];
    [alertView show];
    //播放语音
    // [self readMsgWithMessage:userInfo[@"aps"][@"alert"]];
}

//如果 App状态为正在前台或者点击通知栏的通知消息，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行
//基于iOS 7 及以上的系统版本，如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
//    [JPUSHService resetBadge];
//    [application setApplicationIconBadgeNumber:0];//小红点清0操作
    DDLog(@"ios7 收到消息推送 == %@",userInfo);
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //判断程序是否在前台运行
    if (application.applicationState == UIApplicationStateActive) {
        //如果应用在前台，在这里执行
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息" message:content delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil,nil];
        
        [alertView show];
        
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
        return;
    }
    DDLog(@"收到推送 userInfo == %@",userInfo);
    // iOS 7 Support Required,处理收到的APNS信息
    //如果应用在后台，在这里执行
    //ios10 收到消息通知
    if ([userInfo[@"redirectUrl"] isEqualToString:@"message"]) {
        DDLog(@"系统消息列表");
        [self pushToMsgListController];
    }
    if ([userInfo[@"redirectUrl"] isEqualToString:@"redpaper"]) {
        DDLog(@"红包列表");
        [self pushToRedListController];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    //播放语音
    // [self readMsgWithMessage:userInfo[@"aps"][@"alert"]];
    
}
#pragma mark - 收到消息跳转
-(void)pushToMsgListController{
}

-(void)pushToRedListController{
   
}
#pragma mark - 收到消息播放语音
-(void)readMsgWithMessage:(NSString* )msg{
    //语音播报文件
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:msg];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
    utterance.voice = voice;
    //    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    utterance.volume= 1;  //设置音量（0.0~1.0）默认为1.0
    utterance.rate= AVSpeechUtteranceDefaultSpeechRate;  //设置语速
    utterance.pitchMultiplier= 1;  //设置语调
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    [synth speakUtterance:utterance];
    
}
@end
