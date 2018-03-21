//
//  YMCalendarController.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMCalendarController.h"
#import "HttpManger.h"

#import "CalendarView.h"
#import "CalendarCell.h"

#import "LTSCalendarView.h"


@interface YMCalendarController ()<UITableViewDataSource,UITableViewDelegate,LTSCalendarEventSource>

@property(nonatomic,strong)CalendarCell* calendarCell;
@property(nonatomic,strong)NSMutableDictionary *eventsByDate;

@end

@implementation YMCalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)lts_InitUI{
    [super lts_InitUI];
    
    // self.calendarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEGIHT - 200);
//     self.calendarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
}
// 该日期是否有事件
- (BOOL)calendarHaveEvent:(LTSCalendarManager *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(self.eventsByDate[key] && [_eventsByDate[key] count] > 0){
        
        return YES;
    }

    return NO;
}
//当前 选中的日期  执行的方法
- (void)calendarDidDateSelected:(LTSCalendarManager *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    NSLog(@"key ===== %@",key);
    NSArray *events = _eventsByDate[key];
    if (events.count > 0) {
        
        // 该日期有事件    tableView 加载数据
    }
}

-(NSMutableDictionary *)eventsByDate{
    if (!_eventsByDate) {
        _eventsByDate = [[NSMutableDictionary alloc]init];
    }
    return _eventsByDate;
}

- (void)createRandomEvents
{
    for(int i = 0; i < 30; ++i){
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!self.eventsByDate[key]){
            self.eventsByDate[key] = [NSMutableArray new];
        }
        
        [self.eventsByDate[key] addObject:randomDate];
    }
}

#pragma mark - UITableViewDataSource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 5;
//}
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    CalendarCell* cell = [CalendarCell shareCell];
//    if (indexPath.row == 0) {
//          self.calendarCell = cell;
//    }
//    
//    return cell;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 260;
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y == - 30) {
//        
//        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.72 initialSpringVelocity:0 options:kNilOptions animations:^{
//            [self.view layoutIfNeeded];
//            self.calendarCell.calendarView.singleRowMode = YES;
//        } completion:nil];
//        
//    }
//}

@end
