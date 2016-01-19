//
//  BMCover.m
//  ibabyMap
//
//  Created by 柏杨 on 15/9/7.
//  Copyright (c) 2015年 柏杨. All rights reserved.
//

#import "BMCover.h"
#import "UIView+Frame.h"
#define BYWindow [UIApplication sharedApplication].keyWindow

@implementation BMCover

+(BMCover *)coverShowWithView:(UIView *)view andTarget:(id)target
{


    BMCover *cover = [[BMCover alloc]initWithFrame:BYWindow.bounds];
    cover.delegate = target;

    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

        UIViewController *vc = (UIViewController *)target;
        [vc.view insertSubview:cover belowSubview:view];
        

    return cover;

}

+(BMCover *)coverShowWithView:(UIView *)view
{
    BMCover *cover = [[BMCover alloc]initWithFrame:BYWindow.bounds];
    
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    return cover;
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if ([self.delegate respondsToSelector:@selector(coverDidClicked:)]) {
        [self.delegate coverDidClicked:self];
    }
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];


}



@end
