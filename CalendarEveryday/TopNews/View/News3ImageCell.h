//
//  News3ImageCell.h
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface News3ImageCell : UITableViewCell

@property(nonatomic,strong)NewsModel* model;

+(instancetype)shareCell;
@end
