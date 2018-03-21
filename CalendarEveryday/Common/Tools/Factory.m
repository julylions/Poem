//
//  Factory.m
//  StopWatchDemo
//
//  Created by Hailong.wang on 15/7/28.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "Factory.h"

@implementation Factory

+ (UIButton *)createButtonWithTitle:(NSString *)title
                              frame:(CGRect)frame
                             target:(id)target
                           selector:(SEL)selector {
    
    return [self createButtonWithTitle:title frame:frame titleFont:14.F textColor:[UIColor blackColor] backgroundColor:[UIColor colorWithRed:0.3f green:0.8f blue:1.f alpha:1.f] target:target selector:selector];
}

+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame titleFont:(CGFloat)size textColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor target:(id)target selector:(SEL)selector{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font=[UIFont systemFontOfSize:size];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    button.backgroundColor = bgColor;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
   
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)createNavBarButtonWithTitle:(NSString*)titile frame:(CGRect)frame titlefont:(CGFloat)size textColor:(UIColor* )textColor backgroundColor:(UIColor* )bgColor imageStr:(NSString* )imageStr target:(id)target selector:(SEL)selector{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    //button.layer.cornerRadius = 3.f;
   // button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    button.backgroundColor = bgColor;
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button setTitle:titile forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;

}

+ (UIButton *)createNavBarButtonWithImageStr:(NSString* )imageStr target:(id)target selector:(SEL)selector{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [button sizeToFit];

    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame {
    return [self createLabelWithTitle:title frame:frame fontSize:14.f];
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color {
    return [self createLabelWithTitle:title frame:frame textColor:color fontSize:14.f];
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame fontSize:(CGFloat)size {
    return [self createLabelWithTitle:title frame:frame textColor:[UIColor blackColor] fontSize:size];
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color fontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    //label.textAlignment=NSTextAlignmentCenter;
    //label.backgroundColor=[UIColor orangeColor];
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

+ (UIView *)createViewWithBackgroundColor:(UIColor *)color frame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UITextField *)createViewWithText:(NSString *)text frame:(CGRect)frame placeholder:(NSString *)placeholder textColor:(UIColor *)color borderStyle:(UITextBorderStyle)borderStyle {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.borderStyle = borderStyle;
    textField.text = text;
    textField.textColor = color;
    return textField;
}


+ (UILabel *)createCircleLabelWithFrame:(CGRect)frame text:(NSString *)text  textColor:(UIColor *)textColor fontSize:(CGFloat)size bgColor:(UIColor *)bgColor borderColor:(UIColor* )borderColor borderWidth:(CGFloat)borderWidth{
    UILabel* label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:size];
    
    label.backgroundColor = bgColor;
    label.layer.borderColor = borderColor.CGColor;
    label.layer.borderWidth = borderWidth;
    label.layer.cornerRadius = frame.size.width / 2;
    label.clipsToBounds = YES;
    
    return label;
}
@end







