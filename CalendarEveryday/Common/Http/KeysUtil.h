//
//  KeysUtil.h
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#ifndef KeysUtil_h
#define KeysUtil_h

//typedef NS_ENUM(NSInteger, CustomTypeStatus) {
//   // CustomTypeStatusUP     = -1,
//    CustomTypeStatusUP     =  0,
//    CustomTypeStatusDown   =  1
//    
//};
//
//typedef NS_ENUM(NSInteger, TaskTypeStatus) {
//    TaskTypeStatusWait         = 0,
//    TaskTypeStatusChecking     = 1,
//    TaskTypeStatusDone         = 2,
//    TaskTypeStatusInvalid      = 3
//};
//
//typedef NS_ENUM(NSInteger, PasswordType) {
//    PasswordTypeModify         = 0,       //修改密码
//    PasswordTypeForget         = 1        //忘记密码
//};
//typedef NS_ENUM(NSInteger,SetType) {
//    SetTypePayWordUnSet       = 0,
//    SetTypePayWordModify,      //设置支付密码
//    SetTypePayWordModifyTwice,  //设置支付密码 第二步
//    
//    SetTypeZhiFuBaoUnSet,      //设置支付宝账户
//    SetTypeZhiFuBaoModify,     //修改支付宝账户 第一步
//    SetTypeZhiFuBaoModifyTwice,//修改支付宝账户 第二步
//    
//    SetTypeBankCardUnSet,      //设置银联卡账户
//    SetTypeBankCardModify,     //修改银联卡 第一步
//    SetTypeBankCardModifyTwice //修改银联卡 第二步
//    
//};
//
//typedef NS_ENUM(NSInteger,DetailListType) {
//    DetailListTypeBalance       = 1, //余额明细
//    DetailListTypeWaitIssue,         //待发明细
//    DetailListTypeWithdraw,          //提现明细
//};
//
//
//typedef NS_ENUM(NSInteger,WithDrawCrashStyle) {
//    WithDrawCrashStyleZfb       = 1,// 提现方式支付宝
//    WithDrawCrashStyleBankCard      // 提现方式 银行卡
//};

#define kJPushAppKey    @"4c5acdf235e563c51c78f622"
//新的  Master Secret : @"d0cd72c507688a11df718249"
#define kChannel              @"App Store"
#define kIsProduct            YES
#define kIsAudit              @"isAudit"


#define kUMAppKey       @"58b3ea40c62dca548d0023b4"
#define kBaiduKey       @"0GQKawZkRIxTNjLLUQGNzYfX"

//appleID
#define kAppleId       @"1279244655" // @"1278741051"  //@"1274894153"

#define kFirstOpen   @"firstOpen"
#define kAutoLogin   @"kAutoLogin"


#define WeChat_AppId      @"wxdcc23700247f2571"  // wx1705d06974c1200e//wxd930ea5d5a258f4f
#define WeChatAppSecrect  @"1851a8f91573e7e32700b88b1f1b2832"


#define QQ_AppId       @"1105799657"      //@"1106103020"   @"1105155505"      //   1105935609
#define QQ_Secrect     @"Uls5vAKp01O8JNhR"// @"uRGnHjSuLpuHtb0t"   //   bUfLXNbJWYH5PgLf @"KYJZQznciNcbiAs4"


#define kNotification_PartAct   @"kNotificationPartActs"

#define kNotification_Login     @"kNotificationLogin"
#define kNotification_LoginOut  @"kNotificationLoginOut"
#define kNotification_LoginStatusChanged  @"kNotificationLoginStatusChanged"

#define kNotification_UserDataChanged     @"kNotification_UserDataChanged"
#define kUserDefaults         [NSUserDefaults standardUserDefaults]

#define kPublicKey         @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCYYnvi6O8mOJxcRTsBRukgZ/b4KcCHKK4sTxV/7MZOkaU26jutR9MLgQe9vwiIkzmY8bC80YBpjT0griFJxub2ok7bCLxyLDwsNkooqv6j5qKPMKnsHtHex7J46zHO+pdhbQ4xyUqMoVGdJoDmMCIoOJPMiDQOC0ieh/NFcuBtmQIDAQAB"
//系统的颜色
#define BlackColor      [UIColor blackColor]
#define WhiteColor      [UIColor whiteColor]
#define RedColor        [UIColor redColor]
#define BlueColor       [UIColor blueColor]
#define OrangeColor     [UIColor orangeColor]
#define LightGrayColor  [UIColor lightGrayColor]
#define LightTextColor  [UIColor lightTextColor]
#define ClearColor      [UIColor clearColor]
//背景色
#define BackGroundColor       HEX(@"F0F0F0")// RGBA(239, 239, 244, 1)
//按钮的颜色 --- tabBar 选中的颜色
#define NavBarTintColor       HEX(@"ef5316")//RGBA(90, 162, 238, 1)  HEX(@"2196F3")
//不可点击颜色
#define NavBar_UnabelColor    HEX(@"bebebe")

//导航栏背景颜色
#define DefaultNavBarColor    HEX(@"414b4d")

#define TabBarTintColor       HEX(@"ef5316")

//国际化赋值
#define CustomLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:@"Localizable"]

//传入RGB三个参数，得到颜色
#define RGB(r,g,b) RGBA(r,g,b,1.f)
//那我们就让美工给出的 参数/255 得到一个0-1之间的数
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEX(a)         [UIColor colorwithHexString:[NSString stringWithFormat:@"%@",a]]

//取得随机颜色
#define RandomColor RGB(arc4random()%256,arc4random()%256,arc4random()%256)
//字体大小
#define Font(a)        [UIFont systemFontOfSize:a]

//屏幕宽度
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEGIHT  ([UIScreen mainScreen].bounds.size.height)

#define KeyWindow      [UIApplication sharedApplication].keyWindow
//获取屏幕大小
#define kScreenSize [UIScreen mainScreen].bounds.size

#define NavBarHeight      44
#define StatusHeight      20
#define NavBarTotalHeight 64
#define TabBarHeigh       48
#define TitleViewHeigh    40

#define kSessionCookie      @"sessionCookies"
#define kUserDefaults            [NSUserDefaults standardUserDefaults]
#define kYMUserInstance          [YMUserManager shareInstance]
#define kWidthRate               SCREEN_WIDTH / 375

//用户相关的key
#define kPhone       @"phone"
#define kToken       @"token"
#define kUid         @"uid"
#define kUsername    @"username"
#define kDate        @"date"
#define kZfb_realName        @"zfb_realName"
#define kZfb_accountName     @"zfb_accountName"
#define kCard_realName       @"isCard_realName"
#define kCard_accountName    @"isCard_accountName"
#define kPayStyle            @"payStyle"
#define kisRefresh           @"isRefresh"

//支付密码
#define kPasswd      @"passwd"

//static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";//授权域
////static NSString *kAuthOpenID = @"0c806938e2413ce73eef92cc3";
//static NSString *kAuthState = @"xxx";

//7.0以上的系统
#define IOS7      ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)
//ios 7 一下的系统
#define IOS_7    ([UIDevice currentDevice].systemVersion.doubleValue < 7.0)

#endif /* KeysUtil_h */
