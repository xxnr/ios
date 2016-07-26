//
//  XNROrderEmptyView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/17.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNROrderEmptyView.h"
@interface XNROrderEmptyView()

@property (nonatomic ,weak) UIButton *buyFerBtn;

@property (nonatomic ,weak) UIButton *buyCarBtn;

@end

@implementation XNROrderEmptyView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createView];
    }
    return self;
}

-(void)createView{

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(92), PX_TO_PT(170), PX_TO_PT(148), PX_TO_PT(200))];
    [imageView setImage:[UIImage imageNamed:@"blank-space"]];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(92), PX_TO_PT(170), PX_TO_PT(184), PX_TO_PT(214))];
//    [imageView setImage:[UIImage imageNamed:@"orderInfo_space"]];

    [self addSubview:imageView];
    
    UILabel *noOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + PX_TO_PT(32), ScreenWidth, PX_TO_PT(36))];
    noOrderLabel.textColor = R_G_B_16(0x646464);
    noOrderLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    noOrderLabel.text = @"您还没有订单";
    noOrderLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noOrderLabel];
    
    UILabel *selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noOrderLabel.frame) + PX_TO_PT(28), ScreenWidth, PX_TO_PT(32))];
    selectedLabel.textColor = R_G_B_16(0x646464);
    selectedLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    selectedLabel.textAlignment = NSTextAlignmentCenter;
    selectedLabel.text = @"快去挑选心仪的商品吧~";
    [self addSubview:selectedLabel];
    
    UIButton *buyFerBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - PX_TO_PT(184), CGRectGetMaxY(selectedLabel.frame) + PX_TO_PT(32), PX_TO_PT(160), PX_TO_PT(60))];
    buyFerBtn.layer.borderWidth = PX_TO_PT(1);
    buyFerBtn.layer.borderColor = R_G_B_16(0x00b38a).CGColor;
    buyFerBtn.layer.cornerRadius = 5.0;
    buyFerBtn.layer.masksToBounds = YES;
    [buyFerBtn setTitle:@"去买化肥" forState:UIControlStateNormal];
    buyFerBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [buyFerBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];
    [buyFerBtn setTitleColor:R_G_B_16(0xfafafa) forState:UIControlStateHighlighted];
    [buyFerBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fafafa"]] forState:UIControlStateNormal];
    [buyFerBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateHighlighted];
    [buyFerBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    self.buyFerBtn = buyFerBtn;
    [self addSubview:buyFerBtn];
    
    UIButton *buyCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buyFerBtn.frame) + PX_TO_PT(48), CGRectGetMaxY(selectedLabel.frame) + PX_TO_PT(32), PX_TO_PT(160), PX_TO_PT(60))];
    buyCarBtn.layer.borderWidth = PX_TO_PT(1);
    buyCarBtn.layer.borderColor = R_G_B_16(0x00b38a).CGColor;
    buyCarBtn.layer.cornerRadius = 5.0;
    buyCarBtn.layer.masksToBounds = YES;
    [buyCarBtn setTitle:@"去买汽车" forState:UIControlStateNormal];
    buyCarBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [buyCarBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];
    [buyCarBtn setTitleColor:R_G_B_16(0xfafafa) forState:UIControlStateHighlighted];
    [buyCarBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fafafa"]] forState:UIControlStateNormal];
    [buyCarBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateHighlighted];
    [buyCarBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    self.buyCarBtn = buyCarBtn;
    [self addSubview:buyCarBtn];
    
}

-(void)buyClick:(UIButton *)button
{
    
    if ([self.delegate performSelector:@selector(XNROrderEmptyView:)]) {
        XNROrderEmptyViewbuySort type;
        if (button == self.buyFerBtn) {
            type = XNROrderEmptyView_buyFer;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushFerVC" object:self];
            
        }else{
            type = XNROrderEmptyView_buyCar;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushCarVC" object:self];
            
        }
        [self.delegate XNROrderEmptyView:type];
    }
}


@end
