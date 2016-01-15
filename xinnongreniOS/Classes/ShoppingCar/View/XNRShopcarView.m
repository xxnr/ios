//
//  XNRShopcarView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/4.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRShopcarView.h"

@interface XNRShopcarView ()

@property (nonatomic, weak) UIImageView *imgView;

@property (nonatomic, weak) UILabel *titleLabel1;
@property (nonatomic, weak) UILabel *titleLabel2;

@property (nonatomic, weak) UIButton *ferBtn;

@property (nonatomic, weak) UIButton *carBtn;

@end

@implementation XNRShopcarView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}

-(void)createUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49)];
    bgView.backgroundColor = R_G_B_16(0xfafafa);
    [self addSubview:bgView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(240))*0.5, PX_TO_PT(180), PX_TO_PT(240), PX_TO_PT(240))];
    [imgView setImage:[UIImage imageNamed:@"icon_shopcar_empty"]];
    self.imgView = imgView;
    [bgView addSubview:imgView];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(420))*0.5, CGRectGetMaxY(self.imgView.frame) + PX_TO_PT(80), PX_TO_PT(420), PX_TO_PT(50))];
    titleLabel1.text = @"您的购物车还是空空的哦";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.textColor = R_G_B_16(0x757575);
    titleLabel1.font = [UIFont systemFontOfSize:16];
    titleLabel1.numberOfLines = NO;
    self.titleLabel1 = titleLabel1;
    [bgView addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(420))*0.5, CGRectGetMaxY(self.titleLabel1.frame), PX_TO_PT(440), PX_TO_PT(50))];
    titleLabel2.text = @"赶快去挑选心仪的商品吧~";
    titleLabel2.textAlignment = NSTextAlignmentCenter;

    titleLabel2.textColor = R_G_B_16(0x757575);
    titleLabel2.font = [UIFont systemFontOfSize:16];
    titleLabel2.numberOfLines = NO;
    self.titleLabel2 = titleLabel2;
    [bgView addSubview:titleLabel2];
    
    // 去买化肥
    UIButton *ferBtn = [[UIButton alloc] initWithFrame:CGRectMake(PX_TO_PT(150),CGRectGetMaxY(self.titleLabel2.frame) + PX_TO_PT(60), PX_TO_PT(200), PX_TO_PT(80))];
    ferBtn.backgroundColor = [UIColor clearColor];
    [ferBtn setTitle:@"去买化肥" forState:UIControlStateNormal];
    [ferBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];
    [ferBtn setTitleColor:R_G_B_16(0xfafafa) forState:UIControlStateHighlighted];
    [ferBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fafafa"]] forState:UIControlStateNormal];
    [ferBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateHighlighted];
    ferBtn.titleLabel.font = XNRFont(16);
    ferBtn.layer.borderColor = R_G_B_16(0x00b38a).CGColor;
    ferBtn.layer.borderWidth = 2.0;
    ferBtn.layer.cornerRadius = 5;
    ferBtn.layer.masksToBounds = YES;
    [ferBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.ferBtn = ferBtn;
    [bgView addSubview:ferBtn];
    
    // 去买汽车
    UIButton *carBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.ferBtn.frame) + PX_TO_PT(50), CGRectGetMaxY(self.titleLabel2.frame) + PX_TO_PT(60), PX_TO_PT(200), PX_TO_PT(80))];
    carBtn.backgroundColor = [UIColor clearColor];
    [carBtn setTitle:@"去买汽车" forState:UIControlStateNormal];
    [carBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];
    [carBtn setTitleColor:R_G_B_16(0xfafafa) forState:UIControlStateHighlighted];
    [carBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fafafa"]] forState:UIControlStateNormal];
    [carBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateHighlighted];
    carBtn.titleLabel.font = XNRFont(16);
    carBtn.layer.borderColor = R_G_B_16(0x00b38a).CGColor;
    carBtn.layer.borderWidth = 2.0;
    carBtn.layer.cornerRadius = 5;
    carBtn.layer.masksToBounds = YES;
    [carBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.carBtn = carBtn;
    [bgView addSubview:carBtn];

}

- (void)BtnClick:(UIButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(ShopcarViewWith:)]) {
        XNRShopcarViewbuySort type;
        if (button == self.ferBtn) {
            type = XNRShopcarView_buyFer;
        }else{
            type = XNRShopcarView_buyCar;
        }
        [self.delegate ShopcarViewWith:type];
    }
       
}

- (void)show {
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49);
}
@end
