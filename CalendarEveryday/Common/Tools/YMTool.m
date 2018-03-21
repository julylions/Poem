//
//  YMTool.m
//  CloudPush
//
//  Created by APPLE on 17/2/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTool.h"
//#import "RealReachability.h"
#import <CoreLocation/CoreLocation.h>


@implementation YMTool
#pragma mark - 判断设备是否联网--- 基于AfnetWorking
+ (BOOL)connectedToNetwork{
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;   //是否已经链接
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;  //是否需要连接
    return (isReachable&&!needsConnection) ? YES : NO;
}
//这个是用第三方RealReachability监听
//+(BOOL)isNetConnect{
//    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
//    if (status == RealStatusNotReachable)
//    {
//        return NO;
//    }
//    if (status == RealStatusViaWiFi)
//    {
//       return YES;
//    }
//    if (status == RealStatusViaWWAN)
//    {
//         return YES;
//    }
//    //可能会有未知网络情况
//    else{
//        return YES;
//    }
//}

+(NSInteger)getNetTypeByAFN{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    __block NSInteger status = 0;
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                // 当网络状态改变了, 就会调用这个block
                switch (status) {
                    case AFNetworkReachabilityStatusUnknown: // 未知网络
                        NSLog(@"未知网络");
                        status = AFNetworkReachabilityStatusUnknown;
                        break;
        
                    case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                         status = AFNetworkReachabilityStatusNotReachable;
                        NSLog(@"没有网络(断网)");
                        
                        break;
        
                    case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                        status = AFNetworkReachabilityStatusReachableViaWWAN;
                        NSLog(@"手机自带网络");
                        break;
        
                    case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                        status = AFNetworkReachabilityStatusReachableViaWiFi;
                        NSLog(@"WIFI");
                        break;
                }
    }];
    // 3.开始监控
    [mgr startMonitoring];
    return status;
}
//（三）从状态栏中获取网络类型，
//基本原理是从UIApplication类型中通过valueForKey获取内部属性 statusBar。然后筛选一个内部类型
//（UIStatusBarDataNetworkItemView），最后返回他的 dataNetworkType属性，根据状态栏获取网络
//状态，可以区分2G、3G、4G、WIFI，系统的方法，比较快捷，不好的是万一连接的WIFI 没有联网的话，
//识别不到。
+ (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            DDLog(@"网络情况  netType === %d",netType);
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                    break;
                default:
                    break;
                }
            }
        }
        //根据状态选择
    }
    DDLog(@"网络情况==== %@",state);
    return state;
}


+ (void)labelColorWithLabel:(UILabel* )label  font:(id)font range:(NSRange)range color:(UIColor* )color{
    
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [mutStr addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [mutStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    label.attributedText = mutStr;
    
}
//设置layer
+ (void)viewLayerWithView:(UIView* )view  cornerRadius:(CGFloat)cornerRadius boredColor:(UIColor* )boredColor borderWidth:(CGFloat)borderWidth{
    
    if (boredColor == nil) {
        boredColor = [UIColor clearColor];
    }
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderColor = boredColor.CGColor;
    view.layer.borderWidth = borderWidth;
    view.clipsToBounds = cornerRadius;
    
}
//是否定位授权开启
+ (BOOL)isOnLocation
{
    BOOL isOn = false;
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        DDLog(@"定位已经开启");
        isOn = YES;
    } else {
        DDLog(@"定位未开启");
        isOn = NO;
    }
    return isOn;
}

//添加手势
+ (void)addTapGestureOnView:(UIView*)view target:(id)target selector:(SEL)selector viewController:(UIViewController* )viewController{
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    if (view.userInteractionEnabled == NO) {
        view.userInteractionEnabled = YES;
    }
    gest.numberOfTapsRequired = 1;
    gest.numberOfTouchesRequired = 1;
    gest.delegate = viewController;
    [view addGestureRecognizer:gest];
}


+(BOOL)isEquailWithStr:(NSString* )str otherStr:(NSString* )otherStr{
    BOOL flag = NO;
    //小写的字符串
    //大写的字符串
  
    if ([[str lowercaseString] isEqualToString:otherStr] ||
        [[str uppercaseString] isEqualToString:otherStr] ||
        [str isEqualToString:otherStr]) {
        flag = YES;
    }
    //
    flag = [str compare:otherStr options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame;
    return flag;
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
+ (NSInteger)getRandomNumber:(NSInteger)from
                          to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

// 获取牌照号
+ (NSString *)getRandomChar
{
    int NUMBER_OF_CHARS = 1;
    char data[NUMBER_OF_CHARS];
    data[0] = (char)('A' + (arc4random_uniform(26)));
    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}

+ (void)presentAlertViewWithTitle:(NSString* )title message:(NSString*)message cancelTitle:(NSString* )cancelTitle cancelHandle:(void (^ __nullable)(UIAlertAction *action))cancelhandler sureTitle:(NSString* )sureTitle  sureHandle:(void (^ __nullable)(UIAlertAction *action))surehandler controller:(UIViewController* )viewController{
    
    UIAlertController* alerC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelhandler];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:surehandler];
    [alerC addAction:cancelAction];
    [alerC addAction:sureAction];
    [viewController presentViewController:alerC animated:YES completion:nil];
}

@end
