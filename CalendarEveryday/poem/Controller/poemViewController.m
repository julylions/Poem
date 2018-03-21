//
//  poemViewController.m
//  poem_self
//
//  Created by spare on 15/7/9.
//  Copyright (c) 2015年 duyong_july. All rights reserved.
//

#import "poemViewController.h"
#import "FMDB.h"
#import "DBUtil.h"
#import "MyFav.h"

@interface poemViewController ()
//诗名字
@property (strong, nonatomic)  UILabel *name;
//作者
@property (strong, nonatomic)  UILabel *anthor;
//介绍
@property (strong, nonatomic)  UIButton *introduce;

//内容
@property (strong, nonatomic)  UITextView *content;

//头部
@property(strong,nonatomic)UIView* titleView;
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation poemViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"like", nil) style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
   
    if (self.poem.isSave) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
     self.view.backgroundColor = WhiteColor;
    //给对象赋值
    self.title = self.poem.kind;
    //    创建视图控件
    self.titleView=[[UIView alloc]init];
    //    把视图添加到父视图中
    [self.view addSubview:self.titleView];
 self.titleView.sd_layout.topEqualToView(self.view).rightEqualToView(self.view).leftEqualToView(self.view).heightIs(140);
    self.titleView.backgroundColor = [UIColor colorWithRed:0.6 green:0.5 blue:0.5 alpha:1];
    
   
    self.name = [[UILabel alloc]init];
    self.anthor= [[UILabel alloc]init];
    self.content = [[UITextView alloc]init];
    self.introduce = [[UIButton alloc]init];
    [self.introduce addTarget:self action:@selector(introduce:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleView addSubview:self.name];
    [self.titleView addSubview:self.anthor];
    [self.titleView addSubview:self.introduce];
    
    [self.view addSubview:self.content];
    
    self.anthor.textAlignment = NSTextAlignmentCenter;
    self.introduce.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.name.textAlignment = NSTextAlignmentCenter;
    self.content.textAlignment= NSTextAlignmentCenter;
    self.name.font = Font(18);
    self.name.numberOfLines = 0;
    self.content.font = Font(20);
   
    self.name.text = self.poem.title;
    self.anthor.text = self.poem.author;
    self.content.text = self.poem.content;
    
    self.name.textColor = BlackColor;
    self.content.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.5 alpha:1];
    
    self.introduce.enabled = YES;
    [self.introduce setTitle:NSLocalizedString(@"detail", nil) forState:UIControlStateNormal];
    self.introduce.titleLabel.font = Font(14);
    

    self.name.sd_layout.centerXEqualToView(self.titleView).topSpaceToView(self.titleView, 10).widthIs(SCREEN_WIDTH).heightIs(60);
    //作者
    self.anthor.sd_layout.centerXEqualToView(self.titleView).topSpaceToView(self.name, 10).widthIs(80).heightIs(26);
    
    self.introduce.sd_layout.rightEqualToView(self.titleView).topEqualToView(self.anthor).bottomEqualToView(self.anthor).leftSpaceToView(_anthor, 10);
    self.introduce.titleLabel.textAlignment = NSTextAlignmentLeft;
    //介绍
   // self.introduce.frame = CGRectMake(CGRectGetMaxX(_anthor.frame), CGRectGetMinY(_anthor.frame), 80, 26);
    
    self.content.sd_layout.topSpaceToView(self.titleView, 0).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(SCREEN_HEGIHT - self.titleView.height - 64);
    

//    添加事件
     self.content.editable = NO;

}
//导航返回按钮方法
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//详细介绍按钮方法
- (void)introduce:(UIButton *)sender {
    sender.selected =!sender.selected;
    if (sender.selected) {
        [sender setTitle:NSLocalizedString(@"poem body", nil) forState:UIControlStateSelected];
        sender.titleLabel.font = Font(14);
        self.content.text =self.poem.intro;
        self.content.textAlignment = NO;
        self.content.font = [UIFont systemFontOfSize:12];
    }else{
        sender.titleLabel.font = Font(12);
        self.content.text = self.poem.content;
        self.content.textAlignment = YES;
        self.content.font = [UIFont systemFontOfSize:20];
        
          }

}
#pragma mark - life Cycle
- (FMDatabase *)db {
    if (!_db) {
        _db = [[FMDatabase alloc]initWithPath:[DBUtil utilGetSanboxPath]];
        [_db open];
        //开始一个事务
        [_db beginTransaction];
        
        BOOL res= [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS like(D_SHI text,D_INTROSHI text,D_AUTHOR text,D_KIND text,D_TITLE text)"];
        //如果在执行某条SQL语句时出现问题，由于我们处在一个事务中，所以执行成功的SQL会自动回滚(恢复以前的数据)
        if (res) {
            NSLog(@"建表成功");
        }else {
            NSLog(@"建表失败！%@",[self.db lastError]);
        }
        //提交一个事务
        [_db commit];
        
    }
    return _db;
}

-(void)add:(UIBarButtonItem *)item {
    item.enabled = NO;
    self.poem.isSave = YES;
    
    //2开启数据库
    [self.db open];
    //执行sql 语句
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO like (D_SHI,D_INTROSHI,D_AUTHOR,D_KIND,D_TITLE) VALUES ('%@','%@','%@','%@','%@')",self.poem.content,self.poem.intro,self.poem.author,self.poem.kind,self.poem.title ];
    //开始一个事务
    [self.db beginTransaction];
    
    BOOL res = [self.db executeUpdate:sql];
    //如果在执行某条SQL语句时出现问题，由于我们处在一个事务中，所以执行成功的SQL会自动回滚(恢复以前的数据)
    if (!res) {
        NSLog(@"插入数据失败%@",[self.db lastError]);
    }
    //提交一个事务
    [_db commit];
    
}


@end
