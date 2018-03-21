//
//  NSString+Catogory.m
//  挑食
//
//  Created by duyong_july on 16/3/24.
//  Copyright © 2016年 youmeng. All rights reserved.
//

#import "NSString+Catogory.h"
#import <UIKit/UIKit.h>


@implementation NSString (Catogory)
//获取设备 IP 地址
+ (NSString *)getIPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}
//银行卡验证
+ (BOOL)isBankCard:(NSString *)cardNo
{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
    

//    if(cardNumber.length==0)
//    {
//        return NO;
//    }
//    NSString *digitsOnly = @"";
//    char c;
//    for (int i = 0; i < cardNumber.length; i++)
//    {
//        c = [cardNumber characterAtIndex:i];
//        if (isdigit(c))
//        {
//            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
//        }
//    }
//    int sum = 0;
//    int digit = 0;
//    int addend = 0;
//    BOOL timesTwo = false;
//    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
//    {
//        digit = [digitsOnly characterAtIndex:i] - '0';
//        if (timesTwo)
//        {
//            addend = digit * 2;
//            if (addend > 9) {
//                addend -= 9;
//            }
//        }
//        else {
//            addend = digit;
//        }
//        sum += addend;
//        timesTwo = !timesTwo;
//    }
//    int modulus = sum % 10;
//    return modulus == 0;
}

+ (NSString *)showDistance:(NSString *)str
{
    NSString *distanceStr=nil;
    float distance=[str floatValue];
    if (distance > 0 && distance < 1000) {
        distanceStr=[NSString stringWithFormat:@"%d%@",(int)distance,@"m"];
    }
    else if( distance > 1000 && distance < 1000 * 100){
        
        NSMutableString *muterStr=[NSMutableString stringWithString:str];
        CGFloat distance = [muterStr floatValue] / 1000;
        
        if (distance > 1 && distance < 100) {
            distanceStr=[NSString stringWithFormat:@"%.2f%@",distance,@"Km"];
        }else{
            NSString *str=[NSString stringWithFormat:@"%d",(int)distance];
            distanceStr=[NSString stringWithFormat:@"%@%@",str,@"Km"];
        }
    }else if(distance == 0){
        distanceStr = @"0 m";
    }else {
        
        distanceStr = [NSString stringWithFormat:@"%.0fkm",(distance/1000)];
    }
    return distanceStr;
}



+ (NSString *)timeChineseFormatFromSeconds:(long long)seconds{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps =[calendar components:(NSCalendarUnitWeekday | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal)  fromDate:date];
    NSLog(@"comps == %d",[comps weekday]);
    ;
    
    NSString* datestring = [dateFormatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@ %@",datestring,[NSString starsNumberByNumber:[comps weekday]]];
}
+ (NSString *)starsNumberByNumber:(NSUInteger)number{
    switch (number) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            return nil;
            break;
    }
}

+(BOOL)isEmptyString:(id)string{
    if ([string isEqual:[NSNull null]]  ||
        [string isEqual:[NSNull class]] ||
        string == nil                   ||
        string == NULL
        ) {
        return YES;
    }else if([string isKindOfClass:[NSString class]]){
        if ([string isEqualToString:@""]    ||
            [string isEqualToString:@"#"]   ||
            [string isEqualToString:@" "]   ||
            [string isEqualToString:@"\n"]   ||
            [string isEqualToString:@"(null)"]) {
            return YES;
        }
        return NO;
    }else if([string isEqual:@"(null)"]){
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)isNull:(id)obj{
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }else if ([obj isEqual:[NSNull null]]){
        return YES;
    }else if (obj == nil){
        return YES;
    }else{
        return NO;
    }
}

+(NSString*)convertNull:(id)object{
    if ([object isEqual:[NSNull null]]) {
        return @" ";
    }else if ([object isKindOfClass:[NSNull class]]){
        return @" ";
    }else if (object == nil){
        return @" ";
    }else{
        return object;
    }
}
 //判断字符串是否全部为数字
+ (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

//判断字符串中是否含有中文
+ (BOOL)isHaveChineseInString:(NSString *)string{
    for(NSInteger i = 0; i < [string length]; i++){
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

//正则表达式验证 判断邮箱格式是否正确
+ (BOOL)isAvailableEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2{
    NSRange _range = [string2 rangeOfString:string1];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}
//判断字符串中是否含有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string{
    NSRange _range = [string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}
+(NSString*)numberStringWithnumberString:(NSString*)numberStr{
    NSArray *strArr = [numberStr componentsSeparatedByString:@"."];
    if (strArr.count > 1) {
        NSMutableString * mutStr;
        if ([strArr[1] length] > 2) {
            mutStr = [[NSString stringWithFormat:@"%.2f",numberStr.floatValue]mutableCopy];
            numberStr = mutStr;
            DDLog(@"numberStr == %@",numberStr);
        }
    }
    return numberStr;
}


+ (BOOL)isMobileNum:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         * 联通号段: 130,131,132,155,156,185,186,145,176,1709
         * 电信号段: 133,153,180,181,189,177,1700  170-179
         */
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[0-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";//173
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
#pragma mark - 身份证号码验证
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - 姓名正则表达式
+ (BOOL)validatePeopleName:(NSString *)peopleName
{
    BOOL flag;
    if (peopleName.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([\u4e00-\u9fa5]+|([a-zA-Z]+\\s?)+)$";
    NSPredicate *peopleNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [peopleNamePredicate evaluateWithObject:peopleName];
}

#pragma mark - 家庭地址正则表达式
+ (BOOL)validateAddress:(NSString *)address
{
    BOOL flag;
    if (address.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"([^\x00-\xff]|[A-Za-z0-9_])+";
    NSPredicate *addressPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [addressPredicate evaluateWithObject:addressPredicate];
}

// Original
//    value 1.2  1.21  1.25  1.35  1.27
// Plain    1.2  1.2   1.3   1.4   1.3
// Down     1.2  1.2   1.2   1.3   1.2
// Up       1.2  1.3   1.3   1.4   1.3
// Bankers  1.2  1.2   1.2 ？ 1.4   1.3
//处理 四舍五入  只舍不入
+ (NSString *)notRounding:(float)orginalNum afterPoint:(int)position{
    //NSRoundPlain  -- 四舍五入
    //NSRoundDown   -- 舍弃最后一位
    //NSRoundUp     -- 最后一位有值 向前进一位
    //NSRoundBankers --类似 四舍五入
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:orginalNum];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //    [ouncesDecimal release];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString* )prefixStrByBaseUrlStr:(NSString* )baseUrlStr{
    if ([baseUrlStr containsString:@"api"]) {
        return @"API";
    }else if([baseUrlStr containsString:@"demo"]) {
        return @"DEMO";
    }else if ([baseUrlStr containsString:@"test"]) {
        return @"TEST";
    }else{
        return @"API";
    }
}

//根据类型 返回 中文名
+ (NSString* )couponTypeByType:(NSString* )type{
    if ([type isEqualToString:@"CASH"]) {
        return @"代金券";
    }
    else if ([type isEqualToString:@"DISCOUNT"]) {
        return @"折扣券"; // 打几折
    }
    else if ([type isEqualToString:@"GIFT"]) {
        return @"兑换券";
    }
    else if ([type isEqualToString:@"GROUPON"]) {
        return @"团购券";
    }
    else if ([type isEqualToString:@"GENERAL_COUPON"]) {
        return @"优惠券";
    }
    else {
        return @"优惠券";
    }
}

+(NSString* )string:(NSString *)str replaceStrInRange:(NSRange)range withString:(NSString*)placeStr{
    NSMutableString* newStr = str.mutableCopy;
    NSArray* strArr = [newStr componentsSeparatedByString:@"@"];
    NSMutableString* firstStr;
    if (strArr.count > 1) {
        firstStr = strArr[0];
        if (firstStr.length > 3) {
            NSRange newRange = NSMakeRange(range.location, firstStr.length - 3);
            [newStr replaceCharactersInRange:newRange withString:placeStr];
           // newStr = [[NSString stringWithFormat:@"%@%@",firstStr,strArr[1]] mutableCopy];
            return newStr;
        }else{
            return newStr;
        }
    }else{
         [newStr replaceCharactersInRange:range withString:placeStr];
    }
    return newStr;
}
//汉字转化为国际码
+(NSString*)stringEncodingWithStr:(NSString* )str CFStringEncoding:(CFStringEncoding )encoding
{
    //得到的国标码（GB2312-80）字符串编码
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(encoding);//kCFStringEncodingGB_18030_2000
    //下面是转化示例
    NSData *dataString = [str dataUsingEncoding:enc];
    
    return  [[NSString alloc] initWithData:dataString encoding:enc];
    
}

#pragma mark - 如何通过一个整型的变量来控制数值保留的小数点位数。以往我们通类似@"%.2f"来指定保留2位小数位，现在我想通过一个变量来控制保留的位数
+(NSString *)newFloat:(float)value withNumber:(int)numberOfPlace
{
    NSString *formatStr = @"%0.";
    formatStr = [formatStr stringByAppendingFormat:@"%df", numberOfPlace];
    NSLog(@"____%@",formatStr);
    
    formatStr = [NSString stringWithFormat:formatStr, value];
    NSLog(@"____%@",formatStr);
    
    printf("formatStr %s\n", [formatStr UTF8String]);
    return formatStr;
}
#pragma mark - 使用subString去除float后面无效的0
+(NSString *)changeFloatWithString:(NSString *)stringFloat

{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    NSInteger i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0') {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

#pragma mark - 去除float后面无效的0
+(NSString *)changeFloatWithFloat:(CGFloat)floatValue

{
    return [self changeFloatWithString:[NSString stringWithFormat:@"%f",floatValue]];
}

+ (NSString *)base64StringFromText:(NSString *)text {
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    DDLog(@"text == %@  data == %@  base64String == %@",text,data,base64String);
    return base64String;
}
@end
