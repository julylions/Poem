#import "PoemMainController.h"
#import "PoemKind.h"
#import "Poem.h"
#import "poemViewController.h"
#import "likeViewController.h"
#import "MyFav.h"
#import "NSString+Catogory.h"
#import "YMWebController.h"


@interface PoemMainController ()
@property(nonatomic,strong)UIPageControl* pageControl;
@property(nonatomic,strong)NSArray* allImages;
//诗的类型
@property (nonatomic,strong)NSArray *poemKinds;
@property (nonatomic,strong)NSArray *kinds;
//诗集
@property(nonatomic,strong)NSArray *peomSet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property(nonatomic,strong)Poem * releodPoem;
@property(nonatomic)NSInteger count;
@end

@implementation PoemMainController

-(void)viewDidLoad{
    
     self.tabBarItem.title = NSLocalizedString(@"poem", nil);
   
     [self.segment setTitle:NSLocalizedString(@"poem", nil) forSegmentAtIndex:0];
     [self.segment setTitle:NSLocalizedString(@"author", nil) forSegmentAtIndex:1];
    
        self.count = 0;
     UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.5)];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width* self.allImages.count, scrollView.frame.size.height);
    for (int i =0; i< self.allImages.count; i++) {
        UIImage* image = [UIImage imageNamed:self.allImages[i]];
        UIImageView* imageView =[[UIImageView alloc]initWithImage:image];
        CGRect imageFrame =CGRectZero;
        imageFrame.size = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
        imageFrame.origin =CGPointMake(i* scrollView.frame.size.width , 0);
        imageView.frame = imageFrame;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.userInteractionEnabled = YES;
         [YMTool addTapGestureOnView:imageView target:self selector:@selector(pushToURL:) viewController:self];
        [scrollView addSubview:imageView];
        
       
    }
    self.tableView.tableHeaderView =scrollView;

//    [self.tableView.tableHeaderView addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.bounces =NO;
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.frame =CGRectMake(0,  SCREEN_WIDTH * 0.5 - 30, SCREEN_WIDTH, 15);
    
    self.pageControl.pageIndicatorTintColor = RGBA(0, 0, 0, 0.5);
    self.pageControl.currentPageIndicatorTintColor = NavBarTintColor;
    
    self.pageControl.numberOfPages = self.allImages.count;
    self.pageControl.currentPage = 0;
    
    [self.tableView addSubview:self.pageControl];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
}
-(void)pushToURL:(UITapGestureRecognizer* )tap{
    DDLog(@"跳转");
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //AFN设置请求头方法
    [httpMgr.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary* param  = @{
                             @"type":@"ios",
                             @"appid":kAppleId
                             };
    
    [httpMgr GET:[NSString stringWithFormat:@"http://apns.push0001.com/getApi.jbm?app_id=%@",kAppleId] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@" resObj == %@",resObj);
        NSDictionary* dataDic = resObj[@"result"];
        if (![NSString isEmptyString:dataDic]) {
            if ([dataDic[@"is_show_tip"] integerValue] == 1 ) {
                YMWebController* wvc = [[YMWebController alloc]init];
                wvc.urlStr = dataDic[@"url"];
                wvc.hidesBottomBarWhenPushed = YES;

                [self.navigationController pushViewController:wvc animated:YES];
            }
        }else{
//            YMWebController* wvc = [[YMWebController alloc]init];
//            wvc.urlStr = @"http://www.baidu.com";
//            wvc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:wvc animated:YES];
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DDLog(@"error == %@",error);
        
    }];
}

- (IBAction)changeType:(UISegmentedControl *)sender {
        [self.tableView reloadData];
}
-(NSArray *)allImages{
    if (!_allImages) {
        _allImages =@[@"1.jpeg",@"2.jpeg",@"3.jpeg",@"4.jpeg",@"5.jpeg"];
    }
    return _allImages;
}

-(void)changeImage{
    if (self.count > self.allImages.count-1) {
        self.count = 0;
    }
    self.pageControl.currentPage = self.count;
    CGRect bounds = self.tableView.tableHeaderView.bounds;
    bounds.origin.x = self.count *bounds.size.width;
    self.tableView.tableHeaderView.bounds = bounds;
    
    self.count ++;
}


//根据诗类型 对象 获取诗的种类 字符串 数组
- (NSArray *)kinds{
    if (!_kinds) {
        NSMutableArray *temp = [NSMutableArray array];
        for (PoemKind *pk in self.poemKinds) {
            [temp addObject:pk.kind];
        }
        _kinds = temp;
    }
    return _kinds;
}

//获取诗的类型对象
- (NSArray *)poemKinds{
    if (!_poemKinds) {
        _poemKinds = [PoemKind poemKindWithDB];
    }
    return _poemKinds;
}
//数据库中全部的诗
-(NSArray *)peomSet{
    if (!_peomSet) {
        _peomSet = [Poem PoemFromDB];
    }
    return _peomSet;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.poemKinds.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSMutableArray* temp =[NSMutableArray array];
    for (Poem* poem in self.peomSet) {
        if ([poem.kind isEqualToString:self.kinds[section]]) {
            
            [temp addObject:poem];
        }

    }
    return temp.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *kind = self.kinds[indexPath.section];
    NSArray *poems = [Poem poemWithKind:kind];
    if (self.segment.selectedSegmentIndex == 0) {
       
        NSArray* newArray = [poems sortedArrayUsingSelector:@selector(compareTitle:)];
        Poem* pm = newArray[indexPath.row];
        cell.textLabel.text = [[pm.title stringByAppendingString:@"  "] stringByAppendingString:pm.kind];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.text = pm.author;
        
    }else{
        NSArray* newArray = [poems sortedArrayUsingSelector:@selector(copareAuthor:)];
        Poem* pm = newArray[indexPath.row];
        cell.textLabel.text = [[pm.author stringByAppendingString:@"  "] stringByAppendingString:pm.title];
        cell.detailTextLabel.text =pm.kind;
           }
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    poemViewController* pvc = [[poemViewController alloc]init];
    NSString *kind = self.kinds[indexPath.section];
    NSArray *poems = [Poem poemWithKind:kind];
    if (self.segment.selectedSegmentIndex == 0) {
        
        NSArray* newArray = [poems sortedArrayUsingSelector:@selector(compareTitle:)];
        Poem* pm = newArray[indexPath.row];
        self.releodPoem=pm;
        
    }else{
        NSArray* newArray = [poems sortedArrayUsingSelector:@selector(copareAuthor:)];
        Poem* pm = newArray[indexPath.row];
        self.releodPoem = pm;
    }

    pvc.poem = self.releodPoem;
    pvc.poem.isSave = [MyFav poemFromLike:pvc.poem];
    pvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pvc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  50;
}

//分区的头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return  self.kinds[section];
}

//右边的导航栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    //更改索引的背景颜色
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //更改索引的背景颜色:
    tableView.sectionIndexColor = [UIColor orangeColor];
    return self.kinds;
}


@end




