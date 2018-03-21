//
//  YMWelcomeController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWelcomeController.h"
#import "YMTabBarController.h"

@interface YMWelcomeController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UICollectionView* collectView;
@property(nonatomic,strong)NSArray* imgsArr;

//分页控件
@property(nonatomic,strong)UIPageControl* pageControl;

//登录按钮
@property(nonatomic,strong)UIButton* loginBtn;
@end

@implementation YMWelcomeController

NSString *const kCellIdentify = @"UICollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建collectView
    [self creatCollectView];
    
    //设置分页 控件
    [self setUpPageControl];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 分页器
- (void)setUpPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2 / 5, SCREEN_HEGIHT - 50 , SCREEN_WIDTH / 5, 10)];
    pageControl.numberOfPages = 3;
    pageControl.currentPageIndicatorTintColor = HEX(@"ef5316");
    pageControl.pageIndicatorTintColor = WhiteColor;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
}
-(void)creatCollectView {
    //UICollectionView的布局 都要依赖于 layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //所有的cell 的大小 屏幕大小
    layout.itemSize = kScreenSize;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    //创建
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEGIHT) collectionViewLayout:layout];
    self.collectView.dataSource = self;
    self.collectView.delegate = self;
    self.collectView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectView];
    //注册 cell 需要注册
    [self.collectView registerClass:[UICollectionViewCell  class] forCellWithReuseIdentifier:kCellIdentify];
    //分页滚动
    self.collectView.pagingEnabled = YES;
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgsArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify forIndexPath:indexPath];
    //设置背景 --- 不会缓存 占内存少
   // NSString *path = [[NSBundle mainBundle] pathForResource:self.imgsArr[indexPath.row] ofType:nil];//@"png"
    //UIImage *image = [UIImage imageWithContentsOfFile:path];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imgsArr[indexPath.row]]];
    
    //都会缓存
    // cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imgsArr[indexPath.row]]];
  
    //背景图片最后一个 添加注册  和 登陆 按钮
    if (indexPath.row == self.imgsArr.count - 1) {
        _pageControl.hidden = YES;
        [self cell:cell modifyViewWithIndexPath:indexPath];
    }
    return cell;
}

-(void)cell:(UICollectionViewCell *)cell modifyViewWithIndexPath:(NSIndexPath* )indexpath
{
    [cell addSubview:self.loginBtn];
    self.loginBtn.sd_layout.bottomSpaceToView(cell,80).heightIs(44).widthIs(175).centerXEqualToView(cell);
}
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        UIButton * loginBtn = [[UIButton alloc]init];
        [loginBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [loginBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        loginBtn.backgroundColor = RGBA(255, 255, 255, 0.2);
        [YMTool viewLayerWithView:loginBtn cornerRadius:4 boredColor:WhiteColor borderWidth:1];
        [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn = loginBtn;
    }
    return _loginBtn;
}


-(void)loginBtnClick:(UIButton* )btn{
    DDLog(@"点击了登陆");
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    YMTabBarController* rvc = [[YMTabBarController alloc]init];
    window.rootViewController = rvc;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //最后一页点击跳转
    if (indexPath.row == self.imgsArr.count - 1) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        YMTabBarController* rvc = [[YMTabBarController alloc]init];
        window.rootViewController = rvc;
    }
}
/**
 *  scrolView代理方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = (int)(self.collectView.contentOffset.x / self.collectView.width + 0.5);
    
    if ( self.pageControl.currentPage == 2) {
       self.loginBtn.hidden = NO;
    }else{
        self.pageControl.hidden = NO;
        self.loginBtn.hidden = YES;
    }
}
#pragma mark - lazy
-(NSArray *)imgsArr{
    if (!_imgsArr) {
        _imgsArr = @[@"guide_page_1",@"guide_page_2",@"guide_page_3"];
    }
    return _imgsArr;
}
@end
