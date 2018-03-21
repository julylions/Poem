//
//  YMTopNewsController.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTopNewsController.h"
#import "UICalender.h"
#import "LunarCore.h"

#import "LLSegmentBarVC.h"
#import "YMCalendarController.h"

#import "YMTitleModel.h"
#import "YMNewsController.h"


@interface YMTopNewsController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) LLSegmentBarVC * segmentVC;

//标题数组
@property(nonatomic,strong)NSMutableArray* titlesArr;

@end

@implementation YMTopNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求数据
    [self requestDataWithApi:NewsHeadListURL Param:nil];
    //创建界面
    //    [self creatUI];
    
}
-(void)creatUIWithTitlesArr:(NSMutableArray* )titlesArr{
    DDLog(@"titlsArr == %@",titlesArr);
    // 1 设置segmentBar的frame
    self.segmentVC.segmentBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
    self.navigationItem.titleView = self.segmentVC.segmentBar;
    
    // 2 添加控制器的View
    self.segmentVC.view.frame = self.view.bounds;
    [self.view addSubview:self.segmentVC.view];
    
    NSMutableArray* titles = [[NSMutableArray alloc]init];
    NSMutableArray* childVcs = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < titlesArr.count ; i ++ ) {
        YMTitleModel* model = titlesArr[i];
        YMNewsController* yvc = [[YMNewsController alloc]init];
        yvc.type = model.key;
        [titles addObject:model.name];
        [childVcs addObject:yvc];
    }
    DDLog(@"childViewControllers == %@  childVcs == %@",self.childViewControllers,childVcs);
    // 3 添加标题数组和控住器数组
    [self.segmentVC setUpWithItems:titles childVCs:childVcs];
    
    // 4  配置基本设置  可采用链式编程模式进行设置
    [self.segmentVC.segmentBar updateWithConfig:^(LLSegmentBarConfig *config) {
       
        config.itemNormalColor([UIColor blackColor]).itemSelectColor([UIColor redColor]).indicatorColor([UIColor greenColor]);
    }];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg_64"] forBarMetrics:UIBarMetricsDefault];

}
// lazy init
- (LLSegmentBarVC *)segmentVC{
    if (!_segmentVC) {
        LLSegmentBarVC *vc = [[LLSegmentBarVC alloc]init];
        // 添加到到控制器
        [self addChildViewController:vc];
        _segmentVC = vc;
    }
    return _segmentVC;
}
-(NSMutableArray *)titlesArr{
    if (!_titlesArr) {
        _titlesArr = [[NSMutableArray alloc] init];
    }
    return _titlesArr;
}

#pragma mark - 网络请求
// 网络请求
-(void)requestDataWithApi:(NSString* )api Param:(NSMutableDictionary* )param {
    
    [[HttpManger sharedInstance]callHTTPReqAPI:api params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
       
        self.titlesArr = [YMTitleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self creatUIWithTitlesArr:self.titlesArr];
    }];
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
