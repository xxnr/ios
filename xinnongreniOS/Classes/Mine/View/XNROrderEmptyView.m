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

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
        
    }
    return self;
}

-(void)createView{

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(92), PX_TO_PT(170), PX_TO_PT(184), PX_TO_PT(214))];
    [imageView setImage:[UIImage imageNamed:@"orderInfo_space"]];
    [self addSubview:imageView];
    
    UILabel *noOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + PX_TO_PT(32), ScreenWidth, PX_TO_PT(36))];
    noOrderLabel.textColor = R_G_B_16(0x323232);
    noOrderLabel.font = [UIFont systemFontOfSize:18];
    noOrderLabel.text = @"您还没有订单";
    noOrderLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noOrderLabel];
    
    UILabel *selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noOrderLabel.frame) + PX_TO_PT(28), ScreenWidth, PX_TO_PT(32))];
    selectedLabel.textColor = R_G_B_16(0xcdcdcd);
    selectedLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    selectedLabel.textAlignment = NSTextAlignmentCenter;
    selectedLabel.text = @"快去挑选心仪的商品吧~";
    [self addSubview:selectedLabel];
    
    UIButton *buyFerBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - PX_TO_PT(184), CGRectGetMaxY(selectedLabel.frame) + PX_TO_PT(32), PX_TO_PT(160), PX_TO_PT(60))];
    buyFerBtn.layer.borderWidth = 1.0;
    buyFerBtn.layer.borderColor = R_G_B_16(0x00b38a).CGColor;
    buyFerBtn.layer.cornerRadius = 5.0;
    buyFerBtn.layer.masksToBounds = YES;
    [buyFerBtn setTitle:@"去买化肥" forState:UIControlStateNormal];
    [buyFerBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];;
    [buyFerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.buyFerBtn = buyFerBtn;
    [self addSubview:buyFerBtn];
    
    UIButton *buyCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buyFerBtn.frame) + PX_TO_PT(48), CGRectGetMaxY(selectedLabel.frame) + PX_TO_PT(32), PX_TO_PT(160), PX_TO_PT(60))];
    buyCarBtn.layer.borderWidth = 1.0;
    buyCarBtn.layer.borderColor = R_G_B_16(0x00b38a).CGColor;
    buyCarBtn.layer.cornerRadius = 5.0;
    buyCarBtn.layer.masksToBounds = YES;
    [buyCarBtn setTitle:@"去买汽车" forState:UIControlStateNormal];
    [buyCarBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];;
    [buyCarBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.buyCarBtn = buyCarBtn;
    [self addSubview:buyCarBtn];
}

-(void)btnClick:(UIButton *)button
{
    if ([self.delegate performSelector:@selector(XNROrderEmptyView:)]) {
        XNROrderEmptyViewbuySort type;
        if (button == self.buyFerBtn) {
            type = XNROrderEmptyView_buyFer;
        }else{
            type = XNROrderEmptyView_buyCar;
        
        }
        [self.delegate XNROrderEmptyView:type];
    }

}

-(void)show
{
//    self.frame = CGRectMake(0, 64+PX_TO_PT(100), ScreenWidth, ScreenHeight - 64 - PX_TO_PT(100));
}

@end
