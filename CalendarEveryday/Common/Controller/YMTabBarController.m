//
//  YMTabBarController.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTabBarController.h"

//#import "YMCalendarController.h"
#import "YMTopNewsController.h"
#import "YMWeatherController.h"
#import "YMConstellationController.h"

#import "LTSCalendarBaseViewController.h"

#import "UIImage+Extension.h"


@interface YMTabBarController ()

@end

@implementation YMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self setTabbarView];
       // 添加所有的子控制器
   // [self addChildVCs];
      self.tabBar.tintColor = DefaultNavBarColor;
}

-(void)setTabbarView{
    
    for (UITabBarItem *item in self.tabBar.items) {
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]];
        
        //设置tabBarItem的字体大小
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateNormal];
        //设置tabBarItem的字体点击颜色
        UIColor *titleHighlightedColor = DefaultNavBarColor;
      
        //[UIColor colorWithRed:0x09/255.0 green:0xbb/255.0 blue:0x07/255.0 alpha:1.0];
        //UIColor *titleHighlightedColor = [UIColor blueColor];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
        
        //设置颜色
        //        [self.tabBarController.tabBar setSelectedImageTintColor:DefaultNavBarColor];
        //        self.tabBarController.tabBar.tintColor = DefaultNavBarColor;
        
        
        //item.title
    }

    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
     [self setTabbarView];
//    //利用systemLayoutSizeFittingSize:计算出真实高度
//    CGFloat height = [self.tableView.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    CGRect headerFrame = self.tableView.tableHeaderView.frame;
//    headerFrame.size.height = height;
//    //修改tableHeaderView的frame
//    self.tableView.tableHeaderView.frame = headerFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 *  添加所有的子控制器
 */
- (void)addChildVCs{
    //日历
    [self setUpChildViewController:[[LTSCalendarBaseViewController alloc]init] title:@"日历" imageNamed:@"日历"];
    //头条
    [self setUpChildViewController:[[YMTopNewsController alloc]init] title:@"头条" imageNamed:@"头条"];
    //天气
    [self setUpChildViewController:[[YMWeatherController alloc]init] title:@"天气" imageNamed:@"天气"];
    //星座
    [self setUpChildViewController:[[YMConstellationController alloc]init] title:@"星座" imageNamed:@"星座"];
}

//创建子控制的方法
-(void)setUpChildViewController:(UIViewController *)vc title:(NSString *)title imageNamed:(NSString *)imageName{
    //精华
    YMNavigationController * naVc = [[YMNavigationController alloc]initWithRootViewController:vc];
    vc.title = title;//相当于上面两句
    if ([title isEqualToString:@"首页"]) {
        vc.title = @"赏多多";
        vc.tabBarItem.title = title;
    }
    if ([title isEqualToString:@"合伙人"]) {
        vc.title = @"我的合伙人";
        vc.tabBarItem.title = title;
    }
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    NSString * selectImageName = [imageName stringByAppendingString:@"选中"];
    vc.tabBarItem.selectedImage = [UIImage originarImageNamed:selectImageName];
    //给TabBarController 添加子控制器
    [self addChildViewController:naVc];
}



@end
