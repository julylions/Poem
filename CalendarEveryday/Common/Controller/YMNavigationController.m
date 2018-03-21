//
//  YMNavigationController.m
//  CloudPush
//
//  Created by APPLE on 17/2/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMNavigationController.h"

@interface YMNavigationController ()

@end

@implementation YMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = DefaultNavBarColor;
    //设置导航上 按钮 文字的颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置导航栏背景色
    [[UINavigationBar appearance] setBarTintColor:DefaultNavBarColor];
    self.navigationBar.translucent = NO;
    
    //背景色
    self.navigationController.view.backgroundColor = BackGroundColor;
}

//重写跳转方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //  不是第一个push进来的子控制器)
    if (self.childViewControllers.count >= 1) {
       UIButton *backButton = [Factory createNavBarButtonWithImageStr:@"back" target:self selector:@selector(back)];
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [backButton sizeToFit];
//        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.view.backgroundColor = BackGroundColor;
        //        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
