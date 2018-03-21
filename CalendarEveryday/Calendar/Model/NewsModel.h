//
//  NewsModel.h
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/25.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
//编号
@property(nonatomic,copy)NSString* news_url;

@property(nonatomic,copy)NSString* id;

//发布时间
@property(nonatomic,copy)NSString* publish_time;
//看过人数
@property(nonatomic,copy)NSString* show_num;
//显示类型 1无图,2一张大图,3一张小图,4三张图
@property(nonatomic,copy)NSString* show_type;
//来源
@property(nonatomic,copy)NSString* source;
//缩略图
@property(nonatomic,copy)NSString* thumbnail_pic_s1;
@property(nonatomic,copy)NSString* thumbnail_pic_s2;
@property(nonatomic,copy)NSString* thumbnail_pic_s3;

//类型
@property(nonatomic,copy)NSString* type;

//图片json数据
@property(nonatomic,strong)NSArray* pics;


#pragma mark - 新增
//新闻唯一id
@property(nonatomic,copy)NSString* ni_id;
@property(nonatomic,copy)NSString* news_id;
//标题
@property(nonatomic,copy)NSString* title;
//图片url（多个url以“|”分开）
@property(nonatomic,copy)NSString* image_urls;

//图片url集合（拆分号了的url集合）
@property(nonatomic,strong)NSArray* imageArray;
//作者
@property(nonatomic,copy)NSString* author;
//评论数
@property(nonatomic,copy)NSString* comment_count;

//发布时间
@property(nonatomic,copy)NSString* publishTimeStr;
//查看数
@property(nonatomic,copy)NSString* query_count;






@end
