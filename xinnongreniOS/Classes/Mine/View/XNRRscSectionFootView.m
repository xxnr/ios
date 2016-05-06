//
//  XNRRscSectionFootView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/25.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscSectionFootView.h"
#import "XNRRscFootFrameModel.h"

@interface XNRRscSectionFootView()

@property (nonatomic, weak) UIView *footView;
@property (nonatomic, weak) UIButton *footButton;
@property (nonatomic, weak) UIView *marginView;
@property (nonatomic, weak) UIView *middleLineView;
@property (nonatomic, weak) UIView *bottomLineView;

@property (nonatomic, weak) UILabel *deliverStyleLabel;

@property (nonatomic, weak) UILabel *totalPriceLabel;

@property (nonatomic, strong) XNRRscFootFrameModel * frameModel;

@end

@implementation XNRRscSectionFootView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self crateView];
    }
    return self;
}

-(void)crateView
{
    UIView *footView= [[UIView alloc] init];
    footView.backgroundColor = R_G_B_16(0xffffff);
    self.footView = footView;
    [self addSubview:footView];
    
   
    UILabel *deliverStyleLabel = [[UILabel alloc] init];
    deliverStyleLabel.textColor = R_G_B_16(0x323232);
    deliverStyleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    deliverStyleLabel.textAlignment = NSTextAlignmentLeft;
    self.deliverStyleLabel = deliverStyleLabel;
    [footView addSubview:deliverStyleLabel];

    UILabel *totalPriceLabel = [[UILabel alloc] init];
    totalPriceLabel.textColor = R_G_B_16(0x323232);
    totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    self.totalPriceLabel = totalPriceLabel;
    [footView addSubview:totalPriceLabel];
    
    UIButton *footButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footButton.layer.cornerRadius = 5.0;
    footButton.layer.masksToBounds = YES;
    footButton.backgroundColor = R_G_B_16(0xfe9b00);
    footButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [footButton addTarget:self action:@selector(footButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.footButton = footButton;
    [footView addSubview:footButton];
    
    UIView *marginView = [[UIView alloc] init];
    marginView.backgroundColor = R_G_B_16(0xf4f4f4);
    self.marginView = marginView;
    [footView addSubview:marginView];
    
    UIView *middleLineView = [[UIView alloc] init];
    middleLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    self.middleLineView = middleLineView;
    [footView addSubview:middleLineView];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    self.bottomLineView = bottomLineView;
    [footView addSubview:bottomLineView];
}


-(void)footButtonClick
{
    if (self.com) {
        self.com();
    }
}

-(void)upDataFootViewWithModel:(XNRRscFootFrameModel *)frameModel
{
    _frameModel = frameModel;
    [self setupFrame];
    
    self.deliverStyleLabel.text =  frameModel.model.deliverValue;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计：¥ %.2f",[frameModel.model.price doubleValue]];
    
    NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:self.totalPriceLabel.text];
    NSDictionary *priceStr=@{
                             
                             NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                             NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                             
                             };
    
    [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
    
    [self.totalPriceLabel setAttributedText:AttributedStringPrice];
    
    if ([frameModel.model.type integerValue] == 2) {
        [self.footButton setTitle:@"审核付款" forState:UIControlStateNormal];
    }else if ([frameModel.model.type integerValue] == 4 ){
        [self.footButton setTitle:@"开始配送" forState:UIControlStateNormal];
    }else if ([frameModel.model.type integerValue] == 5){
        for (XNRRscSkusModel *skuModel in frameModel.model.SKUs) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                [self.footButton setTitle:@"客户自提" forState:UIControlStateNormal];
            }
        }
    }else if ([frameModel.model.type integerValue] == 6){
        for (XNRRscSkusModel *skuModel in frameModel.model.SKUs) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                [self.footButton setTitle:@"开始配送" forState:UIControlStateNormal];
            }
        }
    }
}

-(void)setupFrame
{
    self.footView.frame = self.frameModel.footViewF;
    self.deliverStyleLabel.frame = self.frameModel.deliverStyleLabelF;
    self.totalPriceLabel.frame = self.frameModel.totalPriceLabelF;
    self.middleLineView.frame = self.frameModel.middleLineViewF;
    self.footButton.frame = self.frameModel.footButtonF;
    self.bottomLineView.frame = self.frameModel.bottomLineViewF;
    self.marginView.frame = self.frameModel.marginViewF;
}

@end
