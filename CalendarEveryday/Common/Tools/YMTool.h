//
//  YMTool.h
//  CloudPush
//
//  Created by APPLE on 17/2/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMTool : NSObject<UIGestureRecognizerDelegate>

//用属性字符串修改label 上字体的颜色和大小
+ (void)labelColorWithLabel:(UILabel* )label  font:(id)font range:(NSRange)range color:(UIColor* )color;

//设置layer
+ (void)viewLayerWithView:(UIView* )view  cornerRadius:(CGFloat)cornerRadius boredColor:(UIColor* )boredColor borderWidth:(CGFloat)borderWidth;

//afn判断是否联网
+ (BOOL)connectedToNetwork;

//用AFN 获取网络状态
+(NSInteger)getNetTypeByAFN;

//系统方法判断网络情况
+ (NSString *)getNetWorkStates;

//这个是用第三方RealReachability监听
+(BOOL)isNetConnect;

//是否开启了定位权限
+ (BOOL)isOnLocation;


//添加手势
+ (void)addTapGestureOnView:(UIView*)view target:(id)target selector:(SEL)selector viewController:(UIViewController* )viewController;

//判断大小写 是否相同 -- 验证码
+(BOOL)isEquailWithStr:(NSString* )str otherStr:(NSString* )otherStr;

//推出提示框
+ (void)presentAlertViewWithTitle:(NSString* )title message:(NSString*)message cancelTitle:(NSString* )cancelTitle cancelHandle:(void (^ __nullable)(UIAlertAction *action))cancelhandler sureTitle:(NSString* _Nullable )sureTitle  sureHandle:(void (^ __nullable)(UIAlertAction * _Nullable action))surehandler controller:(UIViewController* _Nullable )viewController;
@end
