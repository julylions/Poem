#import "PoemKind.h"
#import "DBUtil.h"
#import "FMDB.h"

@implementation PoemKind

+ (NSArray *)poemKindWithDB{
    //1.创建FMDB对象
    FMDatabase *fm = [FMDatabase databaseWithPath:[DBUtil utilGetSanboxPath]];
    //2.开启数据库
    [fm open];
    //3.执行sql语句
    NSString *sql = @"select * from T_KIND";
    //4.获得结果集
    FMResultSet * resultSet = [fm executeQuery:sql];
    //5.遍历结果集,把数据方到模型,模型放到数组
    NSMutableArray *poemKinds = [NSMutableArray array];
    //如果有下一个数据,继续执行循环
    while ([resultSet next]) {
        PoemKind *pKind = [[PoemKind alloc] init];
        //5.1从数据库中取出数据给模型的属性赋值
        pKind.kind = [resultSet stringForColumn:@"D_KIND"];
        pKind.intro1 = [resultSet stringForColumn:@"D_INTROKIND"];
        pKind.intro2 = [resultSet stringForColumn:@"D_INTROKIND2"];
        //NSLog(@"%@",pKind.kind);
        //5.2 将对象添加到数组
        [poemKinds addObject:pKind];
    }
    
//    PoemKind *p1 = [[PoemKind alloc]init];
//    p1.kind = @"wuyan";
//    p1.intro1 = @"haoshi";
//    p1.intro2 = @"good";
//    
//    PoemKind *p2 = [[PoemKind alloc]init];
//    p2.kind = @"qiyan";
//    p2.intro1 = @"better";
//    p2.intro2 = @"best";
//    
//    [poemKinds addObject:p1];
//    [poemKinds addObject:p2];
    
    return poemKinds;
}
@end




