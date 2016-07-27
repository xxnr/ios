//
//  UILabel+showMessage.m
//  XNRUILabel
//
//  Created by xxnr on 16/1/22.
//  Copyright © 2016年 xxnr. All rights reserved.
//

#import "UILabel+showMessage.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@implementation UILabel (showMessage)

+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc] init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = CGSizeZero;
    if ([message isKindOfClass:[NSString class]]) {
        
        LabelSize = [message sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(30)] maxSize:CGSizeMake(ScreenWidth-PX_TO_PT(40), MAXFLOAT)];

    }
    label.frame = CGRectMake(PX_TO_PT(20), PX_TO_PT(10), LabelSize.width+PX_TO_PT(8), LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:PX_TO_PT(30)];
    [showview addSubview:label];
    showview.frame = CGRectMake((ScreenWidth - LabelSize.width - PX_TO_PT(40))/2, ScreenHeight - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:4.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
    
    
}

+(void)showShareMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    //    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    CGSize LabelSize;
    if ([message isKindOfClass:[NSString class]]) {
        
        LabelSize = [message sizeWithFont_BSExt:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(290, MAXFLOAT)];
        
    }
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width - 20)/2, SCREEN_HEIGHT - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:3.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
    
    
}


@end
