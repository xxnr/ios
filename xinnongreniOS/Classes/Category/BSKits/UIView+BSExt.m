//
//  UIView+BSExt.m
//  BigStrongExtKit
//
//  Created by 董富强 on 15/8/19.
//  Copyright (c) 2015年 董富强. All rights reserved.
//

#import "UIView+BSExt.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (BSExt)

- (CGFloat)frameX_Ext; {
    return self.frame.origin.x;
}
- (CGFloat)frameY_Ext {
    return self.frame.origin.y;
}
- (CGFloat)frameWidth_Ext {
    return self.frame.size.width;
}

- (CGFloat)frameHeight_Ext {
    return self.frame.size.height;
}




- (UIImage *)screenshot_Ext {
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenshot;
    } else {
        UIGraphicsBeginImageContext(self.bounds.size);
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}


- (UIView *)currentFirstResponderView_Ext {
    
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView currentFirstResponderView_Ext];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

-(UIView *)setWarnViewTitle:(NSString *)titleLabel{
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.3;
    
    UIView *warnView = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(180), PX_TO_PT(450), PX_TO_PT(360), PX_TO_PT(280))];
    warnView.layer.cornerRadius = PX_TO_PT(20);
    warnView.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(119), PX_TO_PT(51), PX_TO_PT(121), PX_TO_PT(121))];
    imageView.image = [UIImage imageNamed:@"success"];
    [warnView addSubview:imageView];
    
    UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(129), CGRectGetMaxY(imageView.frame)+PX_TO_PT(30), PX_TO_PT(120), PX_TO_PT(30))];
    successLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    successLabel.text = titleLabel;
    successLabel.textColor = [UIColor whiteColor];
    [warnView addSubview:successLabel];
    
    [coverView addSubview:warnView];
    
    [UIView animateWithDuration:1.5f animations:^{
        warnView.alpha = 0;
        
    }];
    return coverView;
}



@end
