#import <Foundation/Foundation.h>

@interface Poem : NSObject
@property (nonatomic,strong) NSString *content;//内容
@property (nonatomic,strong) NSString *intro;//介绍
@property (nonatomic,strong) NSString *author;//作者
@property (nonatomic,strong) NSString *kind;//类型
@property (nonatomic,strong) NSString *title;//标题

@property(nonatomic)BOOL isSave;

+ (NSArray*)PoemFromDB;

+(NSArray *)poemWithKind:(NSString *)kind;

+(NSArray* )poemWithAuthor:(NSString*)author;

-(NSComparisonResult)compareTitle:(Poem* )otherPoem;

-(NSComparisonResult)copareAuthor:(Poem* )otherPoem;
@end




