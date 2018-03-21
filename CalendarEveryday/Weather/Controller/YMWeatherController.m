//
//  YMWeatherController.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWeatherController.h"
#import "UICalender.h"

#import "LunarCore.h"

@interface YMWeatherController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView* tableView;

@property(nonatomic,strong) UICalender *calender;
@end

@implementation YMWeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate date];
    UICalender *calender = [[UICalender alloc] initWithCurrentDate:date];
    calender.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
    self.calender = calender;
    [self.view addSubview:calender];
    
    self.tableView.tableFooterView = [UIView new];
    
    //计算节气
    NSDictionary *lunarCalendar = calendar(2017, 4);
    NSLog(@"24 节气 == %@", lunarCalendar);
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEGIHT - 64 ) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //设置表头
        _tableView.tableHeaderView = self.calender;
        _tableView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
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
