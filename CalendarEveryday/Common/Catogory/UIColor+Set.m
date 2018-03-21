//
//  UIColor+Set.m
//  挑食商家版
//
//  Created by duyong_july on 16/6/6.
//  Copyright © 2016年 挑食科技. All rights reserved.
//

#import "UIColor+Set.h"

@implementation UIColor (Set)

//两种颜色的比较 http://stackoverflow.com/a/8899384/1931781
- (BOOL)isEqualToColor:(UIColor *)otherColor {
    
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor *) = ^(UIColor *color) {
        if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            return [UIColor colorWithCGColor:CGColorCreate(colorSpaceRGB, components)];
        } else {
            return color;
        }
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}

//使用十进制设置背景颜色
+(UIColor *)colorWith255Red:(NSInteger)red greed:(NSInteger)greed blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    
    return [UIColor colorWithRed:red/255.0 green:greed/255.0 blue:blue/255.0 alpha:alpha];
}
//使用16进制设置颜色
+(UIColor *)colorWithHex:(long)hex andAlpha:(CGFloat)alpha
{
    
    float red= (float)((hex & 0xff0000) >> 16 )/255.0;
    float greed= (float)((hex & 0x00ff00) >> 8 )/255.0;
    float blue= (float)(hex & 0x0000ff )/255.0;
    return [UIColor colorWithRed:red green:greed blue:blue alpha:alpha];
}

+(UIColor *)colorWithCGFloatRed:(CGFloat)red greed:(CGFloat)greed blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    
    return [UIColor colorWithRed:red/255.0 green:greed/255.0 blue:blue/255.0 alpha:alpha];
}

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
//16进制字符转 long
+(long)hexWithString:(NSString*)string{
    
   // NSString *str = @"0xff055008";
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    unsigned long hex = strtoul([string UTF8String],0,16);
    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
   // unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
  //  NSLog(@"转换完的数字为：%lx",red);
  // NSLog(@"hex=================== %ld",hex);
    return hex;
}

+ (UIColor *)colorwithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}



@end
