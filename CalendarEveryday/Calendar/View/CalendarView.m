//
//  CalendarView.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "CalendarView.h"

@implementation CalendarView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.calenderView = [[DAYCalendarView alloc]initWithFrame:frame];
        
        [self.calenderView addTarget:self action:@selector(calendarViewDidChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.calenderView];
    
    }
    return self;
}

- (void)calendarViewDidChange:(DAYCalendarView* )sender {
    DDLog(@"sender == %@  %@",sender,self.calenderView.selectedDate);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSLog(@"%@", [formatter stringFromDate:self.calenderView.selectedDate]);
    
    
}

@end
