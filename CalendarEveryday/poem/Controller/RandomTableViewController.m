//
//  RandomTableViewController.m
//  poem_self
//
//  Created by spare on 15/7/15.
//  Copyright (c) 2015年 duyong_july. All rights reserved.
//

#import "RandomTableViewController.h"
#import "Poem.h"
#import "poemViewController.h"
#import "MyFav.h"

@interface RandomTableViewController ()

@property(nonatomic,strong)NSArray *allRandomPoems;
@end

@implementation RandomTableViewController

- (NSArray *)allRandomPoems {
    if (!_allRandomPoems) {
        _allRandomPoems = [Poem PoemFromDB];
    }
    return _allRandomPoems;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = NSLocalizedString(@"random", nil);
     self.tabBarItem.title = NSLocalizedString(@"random", nil);
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allRandomPoems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    Poem *pm = self.allRandomPoems[indexPath.row];
    cell.textLabel.text = pm.title;
    cell.detailTextLabel.text = pm.author;
   
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    poemViewController* pvc = [[poemViewController alloc]init];
    
    pvc.poem = self.allRandomPoems[indexPath.row];
    pvc.poem.isSave = [MyFav poemFromLike:self.allRandomPoems[indexPath.row]];
    pvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pvc  animated:YES];
    
}
@end
