//
//  mainSearchTableViewController.m
//  poem_self
//
//  Created by spare on 15/7/9.
//  Copyright (c) 2015年 duyong_july. All rights reserved.
//

#import "mainSearchTableViewController.h"
#import "Poem.h"
#import "SeachBarController.h"
#import "poemViewController.h"
#import "MyFav.h"

@interface mainSearchTableViewController ()<UISearchBarDelegate,UISearchResultsUpdating>
@property(nonatomic,strong)NSArray* allPoems;

@property(nonatomic,strong)UISearchController* searchController;

@property(nonatomic,strong)SeachBarController* showResultController;


@property(nonatomic,strong)Poem* reloadPoem;
@end

@implementation mainSearchTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
      self.showResultController = [[SeachBarController alloc]init];
    self.searchController =[[UISearchController alloc]initWithSearchResultsController:self.showResultController];
    //设置搜索结果的更新 有谁负责
    self.searchController.searchResultsUpdater = self;
//    设置搜索栏自适应大小
    [self.searchController.searchBar  sizeToFit];
//    设置搜索栏上的文字
    self.searchController.searchBar.scopeButtonTitles =@[@"author",@"title",@"其他"];
//    将搜索栏添加到tableView上
    self.tableView.tableHeaderView =self.searchController.searchBar;
    //设置 数据发生变更时 允许切换 控制器
    self.definesPresentationContext = YES;
//    设置搜素栏的代理
    self.searchController.searchBar.delegate = self;
    
    self.tabBarItem.title = NSLocalizedString(@"search", nil);
    DDLog(@"Main:%ld",self.searchArray.count);

}
-(NSArray *)allPoems{
    if (!_allPoems) {
        _allPoems = [Poem PoemFromDB];
        [self.tableView reloadData];
    }
    return _allPoems;
}
-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [self.allPoems mutableCopy];
    }
    return _searchArray;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allPoems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
       Poem* pm= self.allPoems[indexPath.row];
    cell.textLabel.text = pm.title;
    cell.detailTextLabel.text = pm.author;
  
    return cell;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString* text = searchController.searchBar.text;
    NSInteger selectedIndex = searchController.searchBar.selectedScopeButtonIndex;
    
    NSMutableArray* temp = [NSMutableArray array];
    if (selectedIndex == 0) {
        for (Poem* pm in self.allPoems) {
            NSRange authorRange = [pm.author rangeOfString:text];
            if (authorRange.length > 0) {
                
                [temp addObject:pm];
            }
        }

    }else if(selectedIndex == 1){
        for (Poem* pm in self.allPoems) {
            NSRange titlrRange = [pm.title rangeOfString:text];
            if (titlrRange.length > 0) {
                
          [temp addObject:pm];
            }
        }
    }else{
        for (Poem* pm in self.allPoems) {
            NSRange kindRange = [pm.kind rangeOfString:text];
            NSRange contentRange =[pm.content rangeOfString:text];
            NSRange introRange = [pm.intro rangeOfString:text];
            if (kindRange.length > 0 || contentRange.length > 0 || introRange.length > 0) {
               
                [temp addObject:pm];
            }
        }
    }
    //NSArray* scopeTitle = searchController.searchBar.scopeButtonTitles;
 
    //[scopeTitle[selectedIndex] isEqualToString:pm.kind]
    self.showResultController.resultArray = [temp copy];
    NSLog(@"showArray:%ld",self.showResultController.resultArray.count);
    NSLog(@"Main:%ld",self.searchArray.count);
    
    [self.showResultController.tableView reloadData];
    
}
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.showResultController.tableView reloadData];
    
    poemViewController* pvc =[[poemViewController alloc]init];
    
    //UINavigationController* navi= [[UINavigationController alloc]initWithRootViewController:pvc];
    pvc.poem = self.searchArray[indexPath.row];
    pvc.poem.isSave = [MyFav poemFromLike:self.searchArray[indexPath.row]];
    NSLog(@"index:%ld",indexPath.row);
    pvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pvc animated:YES];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.showResultController.tableView reloadData];

    
}
@end
