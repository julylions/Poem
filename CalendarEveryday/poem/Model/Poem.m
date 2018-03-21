#import "Poem.h"
#import "DBUtil.h"
#import "FMDB.h"


@implementation Poem
+(NSArray *)PoemFromDB{
    NSString* peomPath = [DBUtil utilGetSanboxPath];
    //1 创建fmdb对象
    FMDatabase* fm =[ FMDatabase databaseWithPath:peomPath];
    //2开启数据库
    [fm open];
    //执行sql 语句
    NSString* sql = @"select * from T_SHI";
    //获得结果集
    FMResultSet* resultSet = [fm executeQuery:sql];
    //便历结果集 把是数据放到模型 模型放到数组
    NSMutableArray* peomSet = [NSMutableArray array];
    //如果有下一个数据 继续循环
    while ([resultSet next]) {
        Poem * peom =[[Poem alloc]init];
      //从数据库中取出数据给模型的属性赋值；
        peom.content =[resultSet stringForColumn:@"D_SHI"];
        peom.intro = [resultSet stringForColumn:@"D_INTROSHI"];
        peom.author =[resultSet stringForColumn:@"D_AUTHOR"];
        peom.title =[ resultSet stringForColumn:@"D_TITLE"];
        peom.kind =[resultSet stringForColumn:@"D_KIND"];
        peom.isSave = NO;
        //把 诗 对象添加到数组
        [peomSet addObject:peom];
    }
    
//    Poem *p1 = [[Poem alloc]init];
//    p1.title = @"aaa";
//    p1.kind = @"wuyan";
//    p1.author = @"222";
//    p1.content = @"helloFriend";
//    p1.intro = @"GoodFriend";
//    
//    Poem *p2 = [[Poem alloc]init];
//    p2.title = @"bbb";
//    p2.kind = @"qiyan";
//    p2.author = @"111";
//    p2.content = @"helloLover";
//    p2.intro = @"AreYouReady";
//
//    Poem *p3 = [[Poem alloc]init];
//    p3.title = @"bbb";
//    p3.kind = @"wuyan";
//    p3.author = @"111";
//    p3.content = @"helloWorld";
//    p3.intro = @"failure";
//    
//    Poem *p4 = [[Poem alloc]init];
//    p4.title = @"aaa";
//    p4.kind = @"qiyan";
//    p4.author = @"123";
//    p4.content = @"hellokitty";
//    p4.intro = @"success";
//    [peomSet addObject:p1];
//    [peomSet addObject:p2];
//    [peomSet addObject:p3];
//    [peomSet addObject:p4];
    return peomSet;
    
}

+ (NSArray *)poemWithKind:(NSString *)kind {
    NSMutableArray *arr = [NSMutableArray array];
    for (Poem *pm in [self PoemFromDB]) {
        if ([pm.kind isEqualToString:kind]) {
            [arr addObject:pm];
        }
    }
    return arr;
    
}

+ (NSArray *)poemWithAuthor:(NSString *)author{
    NSMutableArray* temp = [NSMutableArray array];
    for (Poem* pm in [self PoemFromDB]) {
        if ([pm.author isEqualToString:author]) {
            [temp addObject:pm];
            
        }
    }
    return temp;
}


- (NSComparisonResult)compareTitle:(Poem *)otherPoem{
    return [self.title compare:otherPoem.title];
}

- (NSComparisonResult)copareAuthor:(Poem *)otherPoem{
    return [self.author compare:otherPoem.author];
}
@end
