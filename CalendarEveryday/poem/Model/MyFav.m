//
//  MyFav.m
//  poem_self
//
//  Created by spare on 15/7/13.
//  Copyright (c) 2015年 duyong_july. All rights reserved.
//

#import "MyFav.h"
#import "FMDB.h"
#import "DBUtil.h"


@implementation MyFav
+(NSArray *)PoemFromDB{
    NSString* peomPath = [DBUtil utilGetSanboxPath];
    //1 创建fmdb对象
    FMDatabase* fm =[ FMDatabase databaseWithPath:peomPath];
    //2开启数据库
    [fm open];
    //执行sql 语句
    NSString* sql = @"select * from like";
    //获得结果集
    FMResultSet* resultSet = [fm executeQuery:sql];
    //便历结果集 把是数据放到模型 模型放到数组
    NSMutableArray* peomSet = [NSMutableArray array];
    //如果有下一个数据 继续循环
    while ([resultSet next]) {
        MyFav * peom =[[MyFav alloc]init];
        //从数据库中取出数据给模型的属性赋值；
        peom.content =[resultSet stringForColumn:@"D_SHI"];
        peom.intro = [resultSet stringForColumn:@"D_INTROSHI"];
        peom.author =[resultSet stringForColumn:@"D_AUTHOR"];
        peom.title =[ resultSet stringForColumn:@"D_TITLE"];
        peom.kind =[resultSet stringForColumn:@"D_KIND"];

        //把 诗 对象添加到数组
        [peomSet addObject:peom];
    }
    NSLog(@"%ld",peomSet.count);
    return peomSet;
}

+(BOOL)poemFromLike:(Poem *)poem {
    NSArray *poems = [self PoemFromDB];
    for (Poem *pm in poems) {
        if ([poem.title isEqualToString:pm.title]) {
            return 1;
        }
    }
    return 0;
}

@end
