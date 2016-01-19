//
//  UILabel+create.h
//  ibabyMap
//
//  Created by 柏杨 on 15/9/14.
//  Copyright (c) 2015年 柏杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (create)
+(UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment superView:(UIView *)superView;

+(UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment superView:(UIView *)superView lineSpacing:(CGFloat)spacing firstLineHeadIndent:(CGFloat)headIndent;

-(void)setTextColor:(UIColor *)textColor font:(UIFont *)font textAligment:(NSTextAlignment)textAligment;
-(void)setDifferentColor:(UIColor *)color font:(UIFont *)font atRange:(NSRange)range;
@end