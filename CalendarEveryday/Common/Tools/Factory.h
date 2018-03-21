//
//  Factory.h
//  StopWatchDemo
//
//  Created by Hailong.wang on 15/7/28.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Factory : NSObject

//创建Button的工厂，将特殊的元素传入，生产相对应的Button
+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector;

+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame titleFont:(CGFloat)size textColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor target:(id)target selector:(SEL)selector;

//带标题和图片的自定义导航按钮
+ (UIButton *)createNavBarButtonWithTitle:(NSString*)titile frame:(CGRect)frame titlefont:(CGFloat)size textColor:(UIColor* )textColor backgroundColor:(UIColor* )bgColor imageStr:(NSString* )imageStr target:(id)target selector:(SEL)selector;

//只带图片的 自定义导航按钮
+ (UIButton *)createNavBarButtonWithImageStr:(NSString* )imageStr target:(id)target selector:(SEL)selector;

//创建Label的工厂，将特殊的元素传入，生产相对应的Label
+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame;
+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color;
+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame fontSize:(CGFloat)size;
+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color fontSize:(CGFloat)size;

//创建View的工厂，将特殊的元素传入，生产相应的View
+ (UIView *)createViewWithBackgroundColor:(UIColor *)color frame:(CGRect)frame;

//创建textField的工厂，将特殊的元素传入，生产响应的textField
+ (UITextField *)createViewWithText:(NSString *)text frame:(CGRect)frame placeholder:(NSString *)placeholder textColor:(UIColor *)color borderStyle:(UITextBorderStyle)borderStyle;


//工厂方法 创建圆形的 Label
+ (UILabel *)createCircleLabelWithFrame:(CGRect)frame text:(NSString *)text  textColor:(UIColor *)textColor fontSize:(CGFloat)size bgColor:(UIColor *)bgColor borderColor:(UIColor* )borderColor borderWidth:(CGFloat)borderWidth;
@end
