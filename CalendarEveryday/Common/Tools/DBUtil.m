#import "DBUtil.h"

@implementation DBUtil
+ (NSString *)utilGetSanboxPath{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"poem.db"];
}
@end
