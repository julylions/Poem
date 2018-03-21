//
//  YMNewsController.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMNewsController.h"
#import "NewsModel.h"
#import "News1ImageCell.h"
#import "YMWebController.h"
#import "News3ImageCell.h"


@interface YMNewsController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray* newsArr;
@property(nonatomic,assign)NSInteger page;

@end

@implementation YMNewsController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    //获取新闻
    [self requestDataWithApi:NewsListURL Param:@{@"type":self.type,@"p":@"1"}.mutableCopy];
   
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestDataWithApi:NewsListURL Param:@{@"type":self.type,@"p":@"1"}.mutableCopy];

    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        _page ++;
         [self requestDataWithApi:NewsListURL Param:@{@"type":self.type,@"p":@(_page).stringValue}.mutableCopy];
    }];
    
}
-(NSMutableArray *)newsArr{
    if (!_newsArr) {
        _newsArr = [[NSMutableArray alloc]init];
    }
    return _newsArr;
}
-(void)requestDataWithApi:(NSString* )api Param:(NSMutableDictionary* )param{
    
    [[HttpManger sharedInstance]callHTTPReqAPI:api params:param view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        
        NSMutableArray* tmpAllArr = [[NSMutableArray alloc]init];
        if (_page == 1) {
            self.newsArr = [NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        }else{
            NSMutableArray* tmpArr = [NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [tmpAllArr addObjectsFromArray:self.newsArr];
            [tmpAllArr addObjectsFromArray:tmpArr];
            self.newsArr = tmpAllArr;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel* model = self.newsArr[indexPath.row];
    if (model.show_type.integerValue > 3) {
       CGRect rect = [model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : Font(16)} context:nil];
        
       
        return rect.size.height + 105;
    }
    return 80;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel* model = self.newsArr[indexPath.row];
    if (model.show_type.integerValue > 3) {
        News3ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"News3ImageCell"];
        if (cell == nil) {
            cell = [News3ImageCell shareCell];
            cell.model = self.newsArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        News1ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"News1ImageCell"];
        if (cell == nil) {
            cell = [News1ImageCell shareCell];
            cell.model = self.newsArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YMWebController* wvc = [[YMWebController alloc]init];
    NewsModel* model = self.newsArr[indexPath.row];
    wvc.urlStr = model.news_url;
    wvc.title = model.title;
    wvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wvc animated:YES];
    
}

@end
