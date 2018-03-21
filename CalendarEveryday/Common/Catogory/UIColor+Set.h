//
//  UIColor+Set.h
//  挑食商家版
//
//  Created by duyong_july on 16/6/6.
//  Copyright © 2016年 挑食科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Set)

#define PayOderBtnColor  [UIColor colorWithHex:[UIColor hexWithString:@"df0d0d"] andAlpha:0.7]
#define PayOderBtnUnable  [UIColor colorWithHex:[UIColor hexWithString:@"df0d0d"] andAlpha:0.3]
#define CoupBackgroundColor  [UIColor colorwithHexString:@"f59600"]

//两种颜色的比较 http://stackoverflow.com/a/8899384/1931781
- (BOOL)isEqualToColor:(UIColor *)otherColor ;

+(UIColor *)colorWith255Red:(NSInteger)red greed:(NSInteger)greed blue:(NSInteger )blue alpha:(CGFloat)alpha;

//16进制字符转 long
+(long)hexWithString:(NSString*)string;
+(UIColor *)colorWithHex:(long)hex andAlpha:(CGFloat )alpha;


+(UIColor *)colorWithCGFloatRed:(CGFloat)red greed:(CGFloat)greed blue:(CGFloat)blue alpha:(CGFloat)alpha;

//葡萄字符串 转16进制
+ (NSString *)hexStringFromString:(NSString *)string;


/**
 *  十六进制的颜色转换为UIColor
  *  @return   UIColor
 */
+ (UIColor *)colorwithHexString:(NSString *)color;

@end
