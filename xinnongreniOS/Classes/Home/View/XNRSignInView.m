//
//  XNRSignInView.m
//  xinnongreniOS
//
//  Created by ZSC on 15/6/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRSignInView.h"
#import "POP.h"
#import "BeginImageContext.h" //屏幕截图
#import "ZSCLabel.h"

@interface XNRSignInView ()

@property (nonatomic,strong) UIImageView *signSucessImageView;

@end

@implementation XNRSignInView
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
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [AppKeyWindow addSubview:self];
}

- (void)createSignSucessImageView:(NSString *)pointNum
{
    UIImageView *tempImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 600, 600) ImageName:@"icon_signSuccess"];
    //截取显示图片2倍大小
    UIImage *image = [BeginImageContext beginImageContext:CGRectMake(0,0,600,600) View:tempImageView];
    
    self.signSucessImageView = [MyControl createImageViewWithFrame:CGRectMake(ScreenWidth/2.0, (ScreenHeight-300)/2.0-(IS_FourInch?50:60)+150, 0, 0) ImageName:@"icon_signSuccess"];
    self.signSucessImageView.image = image;
    self.signSucessImageView.layer.masksToBounds = YES;
    [self addSubview:self.signSucessImageView];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
    positionAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    positionAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(300, 300)];
    positionAnimation.springBounciness = 15.0f;
    positionAnimation.springSpeed = 20.0f;
    [self.signSucessImageView pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
    
}
#pragma mark - 轻击屏幕
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.deleteBlock();
}

@end
