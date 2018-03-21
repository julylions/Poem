#import <Foundation/Foundation.h>

@interface PoemKind : NSObject
@property (nonatomic,strong) NSString *kind;//类型
@property (nonatomic,strong) NSString *intro1;
@property (nonatomic,strong) NSString *intro2;
//读取所有诗的类型
+ (NSArray *)poemKindWithDB;
@end




