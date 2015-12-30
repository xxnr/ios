//
//  GuideView.m
//  xinnongreniOS
//
//  Created by ZSC on 15/6/10.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "GuideView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface GuideView ()
{
    UIScrollView *_mainScrollView;
}
@end

@implementation GuideView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{

    _mainScrollView = [MyControl createUIScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth*2, ScreenHeight) pagingEnabled:YES showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO delegate:self];
    _mainScrollView.bounces = NO;
    [self addSubview:_mainScrollView];
    
    for (int i = 0; i<2; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        imageView.backgroundColor=RandomColor;
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"yindaoye%d.png",i+1]]];
        [_mainScrollView addSubview:imageView];
        
    }
    _mainScrollView.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"1秒后添加到队列");
        [_mainScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        _mainScrollView.userInteractionEnabled=YES;
        
    });
    
    UIButton *button = [MyControl createButtonWithFrame:CGRectMake(0, 0, 150*SCALE, 40*SCALE)ImageName:@"JXup" Target:self Action:@selector(btnClick:) Title:nil];
    [button setBackgroundImage:[UIImage imageNamed:@"JXdown"] forState:UIControlStateSelected];
    button.center=CGPointMake(1.5*ScreenWidth, ScreenHeight-110*SCALE);
    [_mainScrollView addSubview:button];
    
    UIButton *button2 = [MyControl createButtonWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)ImageName:@"" Target:self Action:@selector(btnClick:) Title:nil];
    button2.center=CGPointMake(1.5*ScreenWidth, ScreenHeight/2.0);
    [_mainScrollView addSubview:button2];

}

- (void)btnClick:(UIButton *)button
{
    self.startBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
