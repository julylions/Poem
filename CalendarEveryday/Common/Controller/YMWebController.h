//
//  YMWebController.h
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMWebProgressLayer.h"

@interface YMWebController : UIViewController

@property(nonatomic,strong)YMWebProgressLayer *progressLayer; ///< 网页加载进度条
@property(nonatomic,copy)void(^agreeBlock)(NSString* isAgree);

@property(nonatomic,copy)NSString* urlStr;
//类型id
@property(nonatomic,copy)NSString* typeId;
@end
