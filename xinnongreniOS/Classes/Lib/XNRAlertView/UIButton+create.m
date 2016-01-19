//
//  UIButton+create.m
//  ibabyMap
//
//  Created by 柏杨 on 15/8/18.
//  Copyright (c) 2015年 柏杨. All rights reserved.
//

#import "UIButton+create.h"

@implementation UIButton (create)
+(UIButton *)buttonWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action frame:(CGRect)frame type:(UIButtonType)type andTitle:(NSString *)title
{
    
    
    UIButton *btn = [UIButton buttonWithType:type];
    if (type != UIButtonTypeSystem) {
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:highImage forState:UIControlStateHighlighted];
    }
    

    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = frame;
    
    return btn;
}

+(UIButton *)imageButtonWithimage:(UIImage *)image target:(id)target action:(SEL)action frame:(CGRect)frame borderColor:(UIColor *)borderColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:image forState:UIControlStateNormal];
    
    btn.frame = frame;
    
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = borderColor.CGColor;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
+(UIButton *)textBtnWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font frame:(CGRect)frame target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.frame = frame;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //[btn sizeToFit];
    
    return btn;
}
@end
