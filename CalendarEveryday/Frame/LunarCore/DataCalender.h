//
//  DataCalendar.h
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DeviceWidth [UIScreen mainScreen].bounds.size.width

@protocol DataCalenderItemDelegate;

@interface DataCalender : UIView
@property (strong ,nonatomic) NSDate *date;
@property (weak ,nonatomic) id<DataCalenderItemDelegate> delegate;
@property (strong ,nonatomic) NSString *day;
@property (strong ,nonatomic) NSString *chineseWeatherDay;
- (NSDate *) nextMonthDate;
- (NSDate *) previousMonthDate;


@end
@protocol DataCalenderItemDelegate <NSObject>

- (void)calendarItem:(DataCalender *)item didSelectedDate:(NSDate *)date;

@end
