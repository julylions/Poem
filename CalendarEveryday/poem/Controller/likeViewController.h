//
//  likeViewController.h
//  poem_self
//
//  Created by spare on 15/7/12.
//  Copyright (c) 2015年 duyong_july. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poem.h"

@interface likeViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray* likePoems;

@property(nonatomic,strong)Poem* poem;
@end
