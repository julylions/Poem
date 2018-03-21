//
//  MyFav.h
//  poem_self
//
//  Created by spare on 15/7/13.
//  Copyright (c) 2015年 duyong_july. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poem.h"

@interface MyFav : NSObject
@property (nonatomic,strong) NSString *content;//内容
@property (nonatomic,strong) NSString *intro;//介绍
@property (nonatomic,strong) NSString *author;//作者
@property (nonatomic,strong) NSString *kind;//类型
@property (nonatomic,strong) NSString *title;//标题

@property(nonatomic)BOOL isSave;

+ (NSArray*)PoemFromDB;

+(BOOL)poemFromLike:(Poem *)poem;

@end
