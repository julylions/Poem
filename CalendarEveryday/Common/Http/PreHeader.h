//
//  PreHeader.h
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#ifndef PreHeader_h
#define PreHeader_h

#import "KeysUtil.h"
#import "URLs.h"

#import "YMNavigationController.h"
#import "YMLoginController.h"

#import "DAYCalendarView.h"
#import <AFNetworking.h>
#import "MBProgressHUD+Add.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SDAutoLayout.h"

#import "UIColor+Set.h"
#import "Factory.h"
#import "YMTool.h"

#import "HttpManger.h"

//调试 代码的宏
/*
 如果定义过宏DEBUG 那么 宏DDLog 表示NSLog函数 否则 表示空
 DDLog(...) ...表示 变参宏
 NSLog(__VA_ARGS__)  __VA_ARGS__ 表示接收宏中写的变参
 DEBUG  宏  在 调试模式(Debug)下会定义
 在发布模式(Release)不会定义
 */
#ifdef DEBUG
#define DDLog(...) NSLog(__VA_ARGS__)
#else
#define DDLog(...)
#endif

//安全释放宏
#define Release_Safe(_control) [_control release], _control = nil;
#define YMWeakSelf __weak typeof(self) weakSelf = self

#endif /* PreHeader_h */
