//
//  NSString+Catogory.h
//  挑食
//
//  Created by duyong_july on 16/3/24.
//  Copyright © 2016年 youmeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface NSString (Catogory)

//获取设备 IP 地址
+ (NSString *)getIPAddress;
//银行卡验证
+ (BOOL)isBankCard:(NSString *)cardNo;
//传递一个单位 M 距离
+ (NSString *)showDistance:(NSString *)str;
//返回中文的 时间
+ (NSString *)timeChineseFormatFromSeconds:(long long)seconds;

//判断空字符串
+(BOOL)isEmptyString:(id)string;

//重写model  get方法 防止出现null  nil 等字眼
+(BOOL)isNull:(id)obj;

//转化空的字符等
+(NSString*)convertNull:(id)object;
//判断字符串是否全部为数字
+ (BOOL)isAllNum:(NSString *)string;

//正则表达式验证 判断邮箱格式是否正确
+ (BOOL)isAvailableEmail:(NSString *)email;

//判断字符串中是否含有中文
+ (BOOL)isHaveChineseInString:(NSString *)string;

//判断字符串中是否含有某个字符串string1
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2;

//判断字符串中是否含有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string;

//将字符串数字 转换成保留两位小数的字符串数字
+(NSString*)numberStringWithnumberString:(NSString*)numberStr;

//是否是手机号码
+ (BOOL)isMobileNum:(NSString *)num;
//是否是有效身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;

//家庭地址正则表达式
+ (BOOL)validateAddress:(NSString *)address;
//姓名正则表达式
+ (BOOL)validatePeopleName:(NSString *)peopleName;

//处理四舍五入  只舍不入
+ (NSString *)notRounding:(float)orginalNum afterPoint:(int)position;

//根据 url 获取 推送 的前缀
+ (NSString* )prefixStrByBaseUrlStr:(NSString* )baseUrlStr;
//根据类型 返回 中文名
+ (NSString* )couponTypeByType:(NSString* )type;

//替换字符串例如用 *** 代替 数字
+(NSString* )string:(NSString *)str replaceStrInRange:(NSRange)range withString:(NSString*)placeStr;

//中文国际化
+(NSString*)stringEncodingWithStr:(NSString* )str CFStringEncoding:(CFStringEncoding )encoding;

//中文字符串 转 base64
+ (NSString *)base64StringFromText:(NSString *)text;
#pragma mark - 如何通过一个整型的变量来控制数值保留的小数点位数。以往我们通类似@"%.2f"来指定保留2位小数位，现在我想通过一个变量来控制保留的位数
+(NSString *)newFloat:(float)value withNumber:(int)numberOfPlace;

#pragma mark - 去除float后面无效的0
+(NSString *)changeFloatWithFloat:(CGFloat)floatValue;

#pragma mark - 使用subString去除float后面无效的0
+(NSString *)changeFloatWithString:(NSString *)stringFloat;


@end
