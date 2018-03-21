//
//  WeatherModel.h
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/25.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
//当前温度
@property(nonatomic,copy)NSString* tmp;
//当前天气
@property(nonatomic,copy)NSString* txt;
//紫外线
@property(nonatomic,copy)NSString* tip;
//风向
@property(nonatomic,copy)NSString* wind;
//最小温度
@property(nonatomic,copy)NSString* min;
//最大温度
@property(nonatomic,copy)NSString* max;


@end
