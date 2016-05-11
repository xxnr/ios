//
//  XNRRscNoOrderView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/5/9.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscNoOrderView.h"

@interface XNRRscNoOrderView()

@property (nonatomic, weak) UIView *orderView;


@end

@implementation XNRRscNoOrderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView{

    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    orderView.backgroundColor = [UIColor whiteColor];
    self.orderView = orderView;
    [self addSubview:orderView];
    
    UIImageView *orderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PX_TO_PT(148), PX_TO_PT(200))];
    orderImageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/4);
    orderImageView.image = [UIImage imageNamed:@"the-order_icon"];
    [orderView addSubview:orderImageView];
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(orderImageView.frame) + PX_TO_PT(60), ScreenWidth, PX_TO_PT(36))];
    orderLabel.text = @"您还没有订单哦";
    orderLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    orderLabel.textAlignment = NSTextAlignmentCenter;
    orderLabel.textColor = R_G_B_16(0x909090);
    [orderView addSubview:orderLabel];
}

@end
