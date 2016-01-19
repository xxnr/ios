//
//  UILabel+create.m
//  ibabyMap
//
//  Created by 柏杨 on 15/9/14.
//  Copyright (c) 2015年 柏杨. All rights reserved.
//

#import "UILabel+create.h"



@implementation UILabel (create)
+(UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment superView:(UIView *)superView
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = textColor ;
    label.font = font;
    if (alignment) {
        label.textAlignment = alignment ;
    }
    if (superView != nil) {
        [superView addSubview:label];
    }
    
    return label;
}

+(UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment superView:(UIView *)superView lineSpacing:(CGFloat)spacing firstLineHeadIndent:(CGFloat)headIndent
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = textColor ;
    label.font = font;
    if (alignment) {
        label.textAlignment = alignment ;
    }
    label.numberOfLines = 0;
    //设置首行缩紧，行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:spacing];
    [paragraphStyle setFirstLineHeadIndent:headIndent];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    label.attributedText = attributedString;
    
    [label sizeToFit];
    
    [superView addSubview:label];
    return label;
    
}

-(void)setTextColor:(UIColor *)textColor font:(UIFont *)font textAligment:(NSTextAlignment)textAligment
{
    self.textColor = textColor;
    self.font = font;
    self.textAlignment = textAligment;
}

-(void)setDifferentColor:(UIColor *)color font:(UIFont *)font atRange:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    [str addAttribute:NSFontAttributeName value:font range:range];
   
    self.attributedText = str;
}


@end
