//
//  SeachBarController.m
//  poem_self
//
//  Created by spare on 15/7/9.
//  Copyright (c) 2015年 duyong_july. All rights reserved.
//

#import "SeachBarController.h"
#import "Poem.h"
#import "poemViewController.h"
#import "MyFav.h"

@interface SeachBarController ()

@end

@implementation SeachBarController
-(NSArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    
    
    self.tableView.tableFooterView = [UIView new];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
    }
   
      Poem* pm= self.resultArray[indexPath.row];
    cell.textLabel.text = pm.title;
    cell.detailTextLabel.text =pm.author;
     cell.accessoryType = UITableViewCellStyleSubtitle;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView reloadData];
    poemViewController* pvc= [[poemViewController alloc]init];
    UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:pvc];
    pvc.poem = self.resultArray[indexPath.row];
    pvc.poem.isSave =[MyFav poemFromLike:self.resultArray[indexPath.row]];
    //NSLog(@"indexPath:%ld",indexPath.row);
   // self.hidesBottomBarWhenPushed =YES;
    [self presentViewController:navi animated:YES completion:nil];
//    [self.navigationController pushViewController:pvc animated:YES];
}
@end
