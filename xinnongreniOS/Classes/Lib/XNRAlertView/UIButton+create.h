//
//  UIButton+create.h
//  ibabyMap
//
//  Created by 柏杨 on 15/8/18.
//  Copyright (c) 2015年 柏杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (create)
+ (UIButton *)buttonWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action frame:(CGRect)frame type:(UIButtonType)type andTitle:(NSString *)title;

+(UIButton *)imageButtonWithimage:(UIImage *)image target:(id)target action:(SEL)action frame:(CGRect)frame borderColor:(UIColor *)borderColor;

+(UIButton *)textBtnWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font frame:(CGRect)frame target:(id)target action:(SEL)action;
@end
