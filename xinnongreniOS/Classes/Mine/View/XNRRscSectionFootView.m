//
//  XNRRscSectionFootView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/25.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscSectionFootView.h"

@interface XNRRscSectionFootView()

@property (nonatomic, weak) UIView *footView;
@property (nonatomic, weak) UIButton *footButton;
@property (nonatomic, weak) UIView *marginView;
@property (nonatomic, weak) UIView *middleLineView;
@property (nonatomic, weak) UIView *bottomLineView;

@property (nonatomic, weak) UILabel *deliverStyleLabel;

@property (nonatomic, weak) UILabel *totalPriceLabel;

@property (nonatomic, strong) XNRRscOrderModel * model;

@end

@implementation XNRRscSectionFootView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)crateView:(XNRRscOrderModel *)model{
    if ([model.type integerValue] == 2||[model.type integerValue] == 4) {
        [self createHaveButtonView:model];
    }else if ([model.type integerValue] == 5 || [model.type integerValue] == 6){
        for (XNRRscSkusModel *skuModel in model.SKUs) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                [self createHaveButtonView:model];
            }else{
                [self createNoButtonView];
            }
        }
    }else{
        [self createNoButtonView];
    }
    
}

-(void)createHaveButtonView:(XNRRscOrderModel *)model
{
    UIView *footView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(196))];
    footView.backgroundColor = R_G_B_16(0xffffff);
    self.footView = footView;
    [self addSubview:footView];
    
    CGFloat deliverStyleLabelX = PX_TO_PT(30);
    CGFloat deliverStyleLabelY = PX_TO_PT(0);
    CGFloat deliverStyleLabelW = ScreenWidth/2;
    CGFloat deliverStyleLabelH = PX_TO_PT(88);
    UILabel *deliverStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(deliverStyleLabelX, deliverStyleLabelY, deliverStyleLabelW, deliverStyleLabelH)];
    deliverStyleLabel.textColor = R_G_B_16(0x323232);
    deliverStyleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    deliverStyleLabel.textAlignment = NSTextAlignmentLeft;
    self.deliverStyleLabel = deliverStyleLabel;
    [footView addSubview:deliverStyleLabel];
                                  
    CGFloat totalPriceLabelX = ScreenWidth/2;
    CGFloat totalPriceLabelY = PX_TO_PT(0);
    CGFloat totalPriceLabelW = ScreenWidth/2-PX_TO_PT(30);
    CGFloat totalPriceLabelH = PX_TO_PT(88);
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalPriceLabelX, totalPriceLabelY, totalPriceLabelW, totalPriceLabelH)];
    totalPriceLabel.textColor = R_G_B_16(0x323232);
    totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    self.totalPriceLabel = totalPriceLabel;
    [footView addSubview:totalPriceLabel];
    
    CGFloat middleLineViewX = 0;
    CGFloat middleLineViewY = PX_TO_PT(88);
    CGFloat middleLineViewW = ScreenWidth;
    CGFloat middleLineViewH = PX_TO_PT(1);
    UIView *middleLineView = [[UIView alloc] initWithFrame:CGRectMake(middleLineViewX, middleLineViewY, middleLineViewW, middleLineViewH)];
    middleLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    self.middleLineView = middleLineView;
    [footView addSubview:middleLineView];

    CGFloat footButtonX = ScreenWidth-PX_TO_PT(170);
    CGFloat footButtonY = CGRectGetMaxY(middleLineView.frame)+PX_TO_PT(14);
    CGFloat footButtonW = PX_TO_PT(140);
    CGFloat footButtonH = PX_TO_PT(60);
    UIButton *footButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footButton.frame = CGRectMake(footButtonX, footButtonY, footButtonW, footButtonH);
    footButton.layer.cornerRadius = 5.0;
    footButton.layer.masksToBounds = YES;
    footButton.backgroundColor = R_G_B_16(0xfe9b00);
    footButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [footButton addTarget:self action:@selector(footButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.footButton = footButton;
    [footView addSubview:footButton];
    
    CGFloat marginViewX = 0;
    CGFloat marginViewY = PX_TO_PT(176);
    CGFloat marginViewW = ScreenWidth;
    CGFloat marginViewH = PX_TO_PT(20);
    
    UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(marginViewX, marginViewY, marginViewW, marginViewH)];
    marginView.backgroundColor = R_G_B_16(0xf4f4f4);
    self.marginView = marginView;
    [footView addSubview:marginView];
    
    CGFloat bottomLineViewX = 0;
    CGFloat bottomLineViewY = PX_TO_PT(176);
    CGFloat bottomLineViewW = ScreenWidth;
    CGFloat bottomLineViewH = PX_TO_PT(1);
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(bottomLineViewX, bottomLineViewY, bottomLineViewW, bottomLineViewH)];
    bottomLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    self.bottomLineView = bottomLineView;
    [footView addSubview:bottomLineView];

}

-(void)createNoButtonView
{

    UIView *footView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(108))];
    footView.backgroundColor = R_G_B_16(0xffffff);
    self.footView = footView;
    [self addSubview:footView];
    
    CGFloat deliverStyleLabelX = PX_TO_PT(30);
    CGFloat deliverStyleLabelY = PX_TO_PT(0);
    CGFloat deliverStyleLabelW = ScreenWidth/2;
    CGFloat deliverStyleLabelH = PX_TO_PT(88);
    
    UILabel *deliverStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(deliverStyleLabelX, deliverStyleLabelY, deliverStyleLabelW, deliverStyleLabelH)];
    deliverStyleLabel.textColor = R_G_B_16(0x323232);
    deliverStyleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    deliverStyleLabel.textAlignment = NSTextAlignmentLeft;
    self.deliverStyleLabel = deliverStyleLabel;
    [footView addSubview:deliverStyleLabel];
    
    CGFloat totalPriceLabelX = ScreenWidth/2;
    CGFloat totalPriceLabelY = PX_TO_PT(0);
    CGFloat totalPriceLabelW = ScreenWidth/2-PX_TO_PT(30);
    CGFloat totalPriceLabelH = PX_TO_PT(88);
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalPriceLabelX, totalPriceLabelY, totalPriceLabelW, totalPriceLabelH)];
    totalPriceLabel.textColor = R_G_B_16(0x323232);
    totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    self.totalPriceLabel = totalPriceLabel;
    [footView addSubview:totalPriceLabel];
    
    CGFloat marginViewX = 0;
    CGFloat marginViewY = PX_TO_PT(88);
    CGFloat marginViewW = ScreenWidth;
    CGFloat marginViewH = PX_TO_PT(20);
    UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(marginViewX, marginViewY, marginViewW, marginViewH)];
    marginView.backgroundColor = R_G_B_16(0xf4f4f4);
    self.marginView = marginView;
    [footView addSubview:marginView];
    
    CGFloat middleLineViewX = 0;
    CGFloat middleLineViewY = PX_TO_PT(88);
    CGFloat middleLineViewW = ScreenWidth;
    CGFloat middleLineViewH = PX_TO_PT(1);
    UIView *middleLineView = [[UIView alloc] initWithFrame:CGRectMake(middleLineViewX, middleLineViewY, middleLineViewW, middleLineViewH)];
    middleLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    self.middleLineView = middleLineView;
    [footView addSubview:middleLineView];
}


-(void)footButtonClick
{
    if (self.com) {
        self.com();
    }

}

-(void)upDataHeadViewWithModel:(XNRRscOrderModel *)model
{
    _model = model;
    [self crateView:model];
    self.deliverStyleLabel.text = model.deliverValue;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计：¥ %.2f",[model.price doubleValue]];
    
    NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:self.totalPriceLabel.text];
    NSDictionary *priceStr=@{
                             
                             NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                             NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                             
                             };
    
    [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
    
    [self.totalPriceLabel setAttributedText:AttributedStringPrice];
    
    if ([model.type integerValue] == 2) {
        [self.footButton setTitle:@"审核付款" forState:UIControlStateNormal];
    }else if ([model.type integerValue] == 4 ){
        [self.footButton setTitle:@"开始配送" forState:UIControlStateNormal];
    }else if ([model.type integerValue] == 5){
        for (XNRRscSkusModel *skuModel in model.SKUs) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                [self.footButton setTitle:@"客户自提" forState:UIControlStateNormal];
            }
        }
    }else if ([model.type integerValue] == 6){
        for (XNRRscSkusModel *skuModel in model.SKUs) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                [self.footButton setTitle:@"开始配送" forState:UIControlStateNormal];
            }
        }
    }



}

@end
