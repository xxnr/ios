//
//  BMAlertView.m
//  ibabyMap
//
//  Created by 柏杨 on 15/10/13.
//  Copyright © 2015年 柏杨. All rights reserved.
//

#import "BMAlertView.h"
#import "DetailSize.h"
#import "UILabel+create.h"
#import "UIButton+create.h"
#import "BMCover.h"
#import "UIView+Frame.h"
#define alertGap 20
#define BYWindow [UIApplication sharedApplication].keyWindow
#define alertWidth (BYWindow.width - 80)

@implementation BMAlertView

-(instancetype)initCustomAlertWithTitle:(NSString *)title view:(UIView *)customView chooseBtns:(NSArray *)btns
{
    if (self = [super init]) {

        self.userInteractionEnabled = YES;
        [self setUpAlertWithTitle:title view:customView chooseBtns:btns];
        
    }
    return self;
}
-(instancetype)initTextAlertWithTitle:(NSString *)title content:(NSString *)content chooseBtns:(NSArray *)btns
{
    if (self = [super init]) {

        UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, alertWidth, 0)];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(25, 16, alertWidth, 0) font:[UIFont systemFontOfSize:PX_TO_PT(36)] text:content textColor:R_G_B_16(0x323232) alignment:NSTextAlignmentCenter superView:view lineSpacing:7.0 firstLineHeadIndent:0];
        label.center = CGPointMake(view.width/2, label.center.y);
        view.height = 50;
        
        [self setUpAlertWithTitle:title view:view chooseBtns:btns];
    }
    return self;
}

-(void)setUpAlertWithTitle:(NSString *)title view:(UIView *)view chooseBtns:(NSArray *)btns
{
    self.backgroundColor = [UIColor whiteColor];

    self.width = alertWidth;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;

    CGFloat maxY = 0;
    if (title.length) {
        
        UIButton *titleView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, alertWidth, 90)];

        //标题
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 14, alertWidth, 16) font:[UIFont boldSystemFontOfSize:16] text:title textColor:AlertFontColor alignment:NSTextAlignmentCenter superView:titleView ];
        label.center = CGPointMake(label.center.x, titleView.height/2);

        //取消按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(titleView.width - 45, 0, 45, 45);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
        imageView.image = [UIImage imageNamed:@"alert_close_"];
        
        [btn addSubview:imageView];
        
        [btn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];

        [titleView addSubview:btn];
        
        
        
        UIView *bottomEdging = [[UIView alloc]initWithFrame:CGRectMake(0, 44, titleView.width, 1)];
        bottomEdging.backgroundColor = edgingColor;
        [titleView addSubview:bottomEdging];
        
        UIView *leftEdging = [[UIView alloc]initWithFrame:CGRectMake(btn.x, 10, 1, titleView.height-20)];
        leftEdging.backgroundColor = edgingColor;
        [titleView addSubview:leftEdging];
        
        maxY = 45;
        [self addSubview:titleView];
        
    }
    view.y = maxY;
    [self addSubview:view];
    maxY = CGRectGetMaxY(view.frame);
    
    if (btns.count) {
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, maxY, alertWidth, 45)];
        CGFloat btnWidth = alertWidth/2;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, 0, 1, 45)];
        lineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [btnView addSubview:lineView];
        for (int i = 0; i < btns.count; i++) {
            UIButton *btn = [UIButton textBtnWithTitle:btns[i] titleColor:R_G_B_16(0x00b38a) font:[UIFont systemFontOfSize:PX_TO_PT(36)] frame:CGRectMake(btnWidth*i, 0, btnWidth, 45) target:self action:@selector(chooseBtnClicked:)];
            btn.tag = i+ 10;
            if (i == btns.count - 1) {
            }
            
            [btnView addSubview:btn];
            
        }
        
        UIView *bottomEdging = [[UIView alloc]initWithFrame:CGRectMake(0, 0, btnView.width, 1)];
        bottomEdging.backgroundColor = edgingColor;
        [btnView addSubview:bottomEdging];

        [self addSubview:btnView];
        maxY = CGRectGetMaxY(btnView.frame);
    }
    self.height = maxY;
    
}

-(instancetype)initErrorViewWithHeight:(CGFloat)height
{
    if (self = [super init]) {
        
    }
    return self;
}
-(instancetype)initEmptyViewWithHeight:(CGFloat)height
{
    if (self = [super init]) {
        
    }
    return self;
}



-(void)chooseBtnClicked:(UIButton *)btn
{
    self.chooseBlock(btn);
    [UIView animateWithDuration:0.5 animations:^{
        _cover.alpha = 0;
    } completion:^(BOOL finished) {
        [_cover removeFromSuperview];
    }];
}

-(void)cancelClicked
{
    [_cover removeFromSuperview];

}

-(void)BMAlertShow
{
    BMCover *cover = [BMCover coverShowWithView:self];
    _cover = cover;
    self.center = CGPointMake(BYWindow.width/2, BYWindow.height/2);
    [cover addSubview:self];
    
    [BYWindow addSubview:cover];

}
-(void)BmAlertDisappear
{
    [_cover removeFromSuperview];
}
@end
