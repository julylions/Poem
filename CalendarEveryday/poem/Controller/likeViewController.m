//
//  likeViewController.m
//  poem_self
//
//  Created by spare on 15/7/12.
//  Copyright (c) 2015年 duyong_july. All rights reserved.
//

#import "likeViewController.h"
#import "MyFav.h"
#import "poemViewController.h"
#import "Poem.h"


@interface likeViewController ()

@property(nonatomic,strong)NSArray *allPoems;
@end

@implementation likeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"favorite", nil);
    
    self.tabBarItem.title = NSLocalizedString(@"favorite", nil);
    self.tableView.tableFooterView = [UIView new];

  
}

-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:YES];
     self.allPoems = [MyFav PoemFromDB];
    NSLog(@"%@",self.allPoems);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allPoems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    Poem* poem = self.allPoems[indexPath.row];
    poem.isSave =YES;
    cell.textLabel.text = poem.title;
    cell.detailTextLabel.text = poem.author;
    
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    poemViewController* pvc =[[poemViewController alloc]init];
    
    pvc.poem =self.allPoems[indexPath.row];
    pvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pvc animated:YES];
}



//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    [self.tableView reloadData];
//}

@end
