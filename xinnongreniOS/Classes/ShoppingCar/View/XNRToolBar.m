//
//  XNRToolBar.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRToolBar.h"
@interface XNRToolBar()

@property (nonatomic, weak) UIButton *button;
@end

@implementation XNRToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置背景
        self.backgroundColor = R_G_B_16(0xf4f4f4);
        
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
        
        self.button = button;
        [self addSubview:button];
        
        }
    return self;
}


/**
 *  监听按钮点击
 */
- (void)buttonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(XNRToolBarBtnClick)]) {
        [self.delegate XNRToolBarBtnClick];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonW = self.width/5;
    CGFloat buttonH = self.height;
    CGFloat buttonX = buttonW*4 ;
    self.button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
}


@end
