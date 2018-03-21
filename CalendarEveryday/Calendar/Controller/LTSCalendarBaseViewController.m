//
//  LTSCalendarBaseViewController.m
//  LTSCalendar
//
//  Created by 李棠松 on 2016/12/28.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSCalendarBaseViewController.h"
#import "LunarCore.h"


@interface LTSCalendarBaseViewController ()<UITableViewDataSource,UITableViewDelegate,LTSCalendarEventSource>

@property(nonatomic,strong)NSMutableDictionary *eventsByDate;

@end

@implementation LTSCalendarBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化界面
    [self lts_InitUI];
    
    //测试首页数据
   //  NSDictionary* param = @{@"prov":@"上海",@"city":@"上海",@"area" : @"上海"};
   // [self requestDataWithApi:HomeDataURL Param:param.mutableCopy];
    
    //请求宜忌
    [self requestDataWithApi:AlmanacURL Param:@{@"date" : @"20170726"}.mutableCopy];
    
    //请求新闻导航菜单
    [self requestDataWithApi:NewsHeadListURL Param:nil];
    //获取新闻
    [self requestDataWithApi:NewsListURL Param:@{@"type":@"shehui",@"p":@"1"}.mutableCopy];
    
}

-(void)requestDataWithApi:(NSString* )api Param:(NSMutableDictionary* )param{
    [[HttpManger sharedInstance]callHTTPReqAPI:api params:param view:self.view loading:YES tableView:self.calendarView.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        
    }];
}
#pragma mark - 初始化界面
- (void)lts_InitUI{
    
    self.calendarView = [[LTSCalendarView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEGIHT - 64 - 58)];
    [self.view addSubview:self.calendarView];
    
    self.calendarView.tableView.delegate = self;
    self.calendarView.tableView.dataSource = self;
    self.calendarView.tableView.backgroundColor = [UIColor greenColor];
    self.calendarView.calendar.eventSource = self;
    
    //显示农历
    self.calendarView.calendar.calendarAppearance.isShowLunarCalender = YES;
    //周日开始
    self.calendarView.calendar.calendarAppearance.firstWeekday = 1;
    //显示一个数字
    self.calendarView.calendar.calendarAppearance.weekDayFormat = LTSCalendarWeekDayFormatSingle;
    //外观高度  文字大小
    self.calendarView.calendar.calendarAppearance.weekDayHeight = 40;
    self.calendarView.calendar.calendarAppearance.weekDayTextFont = [UIFont systemFontOfSize:14];
    self.calendarView.calendar.currentDateSelected = [NSDate date];
    [self.calendarView.calendar reloadAppearance];
    
    //头部weekView
    self.calendarView.calendar.weekDayView.backgroundColor = [UIColor redColor];
    self.calendarView.contentView.backgroundColor = [UIColor brownColor];
    //日历组建
    self.calendarView.calendar.contentView.backgroundColor = [UIColor blueColor];
    // headView -- 日历组建
    self.calendarView.headerView.backgroundColor = [UIColor orangeColor];

}


#pragma mark -- LTSCalendarEventSource --
- (void)calendarDidLoadPage:(LTSCalendarManager *)calendar{
    NSLog(@"加载日历");
    
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
    NSLog(@"日历选中");
    NSString *key = [[self dateFormatter] stringFromDate:date];
    NSLog(@"key ===== %@",key);
    NSArray *events = _eventsByDate[key];
    if (events.count > 0) {
        
        // 该日期有事件    tableView 加载数据
    }

}
//创建随机事件
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

#pragma mark - UIScrollViewDelegate
//当tableView 滚动完后  判断位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     NSLog(@"滚动将要结束拖拽");
    CGFloat startSingleOriginY = self.calendarView.calendar.calendarAppearance.weekDayHeight*5;
    self.calendarView.dragEndOffectY  = scrollView.contentOffset.y;
    //<0方向向上 >0 方向向下
    //用于判断滑动方向
    CGFloat distance = self.calendarView.dragStartOffectY - self.calendarView.dragEndOffectY;
    
    if (self.calendarView.tableView.contentOffset.y > CriticalHeight ) {
        if (self.calendarView.tableView.contentOffset.y < startSingleOriginY) {
            if (self.calendarView.tableView.contentOffset.y > startSingleOriginY - CriticalHeight) {
                [self.calendarView showSingleWeekView:YES];
                return;
            }
            //向下滑动
            if (distance < 0) {
                [self.calendarView showSingleWeekView:YES];
            }
            
            else [self.calendarView showAllView:YES];
        }
    }
    else if (self.calendarView.tableView.contentOffset.y > 0)
        [self.calendarView showAllView:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
     NSLog(@"滚动将要结束");
    self.calendarView.containerView.backgroundColor = self.calendarView.calendar.calendarAppearance.backgroundColor;
    
    CGFloat startSingleOriginY = self.calendarView.calendar.calendarAppearance.weekDayHeight*5;
    
    self.calendarView.dragEndOffectY  = scrollView.contentOffset.y;
    //<0方向向上 >0 方向向下
    CGFloat distance = self.calendarView.dragStartOffectY - self.calendarView.dragEndOffectY;
    
    if (self.calendarView.tableView.contentOffset.y > CriticalHeight ) {
        if (self.calendarView.tableView.contentOffset.y<startSingleOriginY) {
            if (self.calendarView.tableView.contentOffset.y>startSingleOriginY - CriticalHeight) {
                [self.calendarView showSingleWeekView:YES];
                return;
            }
            if (distance < 0) {
                [self.calendarView showSingleWeekView:YES];
            }
            else [self.calendarView showAllView:YES];
        }
    }
    else if (self.calendarView.tableView.contentOffset.y > 0)
        [self.calendarView showAllView:YES];
}

//当手指 触摸 滚动 就 设置 上一次选择的 跟当前选择的 周 的index 相等
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"滚动将要开始拖拽");
    self.calendarView.dragStartOffectY  = scrollView.contentOffset.y;
    
    self.calendarView.calendar.lastSelectedWeekOfMonth = self.calendarView.calendar.currentSelectedWeekOfMonth;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offectY = scrollView.contentOffset.y;
    CGRect contentFrame = self.calendarView.calendar.contentView.frame;
    DDLog(@"这个是tableView 滚动啦  offSetY == %f",offectY);
    //  当 offectY 大于 滚动到要悬浮的位置
    if ( offectY > self.calendarView.calendar.startFrontViewOriginY) {
        
        self.calendarView.containerView.backgroundColor = [UIColor whiteColor];
        contentFrame.origin.y = - self.calendarView.calendar.startFrontViewOriginY;
        
        self.calendarView.calendar.contentView.frame = contentFrame;
        
        //把 selectedView 插入到 containerView 的最上面
        [self.calendarView.containerView insertSubview:self.calendarView.calendar.selectedWeekView atIndex:999];
        // 把tableView 里的 日历视图 插入到 表底部
        [self.calendarView.containerView insertSubview:self.calendarView.calendar.contentView atIndex:0];
        //这里有个bug。YES ---> NO
        [self.calendarView.calendar setWeekViewHidden:NO toIndex:self.calendarView.calendar.currentSelectedWeekOfMonth-1];
        
    }else{
        
        self.calendarView.containerView.backgroundColor = self.calendarView.calendar.calendarAppearance.backgroundColor;
        contentFrame.origin.y = 0;
        self.calendarView.calendar.contentView.frame = contentFrame;
        [self.calendarView.calendar setWeekViewHidden:NO toIndex:self.calendarView.calendar.currentSelectedWeekOfMonth-1];
        
        //变成周历显示，改变headerView
        [self.calendarView.headerView insertSubview:self.calendarView.calendar.selectedWeekView atIndex:1];
        [self.calendarView.headerView insertSubview:self.calendarView.calendar.contentView atIndex:0];
    }
}

-(NSMutableDictionary *)eventsByDate{
    if (!_eventsByDate) {
        _eventsByDate = [[NSMutableDictionary alloc]init];
    }
    return _eventsByDate;
}
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    return dateFormatter;
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){
        return 20;
    }else{
        return 100;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell =[UITableViewCell new];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

@end
