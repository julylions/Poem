//
//  CalendarView.h
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView

@property(nonatomic,strong)DAYCalendarView* calenderView;

-(instancetype)initWithFrame:(CGRect)frame;
@end
