//
//  XNRSubmitOrderCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/8.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSubmitOrderCell.h"
#import "UIImageView+WebCache.h"

@interface XNRSubmitOrderCell()

{
    CGFloat _totalPrice;
}

@property (nonatomic ,weak) UIView *topView;

@property (nonatomic ,weak) UIView *midView;

@property (nonatomic ,weak) UIView *bottomView;

@property (nonatomic ,weak) UIImageView *goodsImageView;

@property (nonatomic ,weak) UILabel *brandNameLabel;

@property (nonatomic ,weak) UILabel *detailLabel;

@property (nonatomic ,weak) UILabel *priceLabel;

@property (nonatomic ,weak) UILabel *depositLabel;

@property (nonatomic ,weak) UILabel *remainPriceLabel;

@property (nonatomic ,weak) UILabel *goodsTotalLabel;

@property (nonatomic ,weak) UILabel *totoalPriceLabel;

@property (nonatomic ,weak) UILabel *goodsTotalLabelMid;

@property (nonatomic ,weak) UILabel *totoalPriceLabelMid;




@property (nonatomic ,strong) XNRShoppingCartModel *model;

@end

@implementation XNRSubmitOrderCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}

-(void)createView{
    
    [self createTopView];
    [self createMidView];
    [self createBottomView];
}

-(void)createTopView{
    UIView *topView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(300))];
    self.topView = topView;
    [self.contentView addSubview:topView];
    
    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(30), PX_TO_PT(180), PX_TO_PT(180))];
    goodsImageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    goodsImageView.layer.borderWidth = 1.0;
    self.goodsImageView = goodsImageView;
    [topView addSubview:goodsImageView];
    
    UILabel *brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImageView.frame) + PX_TO_PT(20), PX_TO_PT(40), ScreenWidth - CGRectGetMaxX(goodsImageView.frame) - PX_TO_PT(52), PX_TO_PT(80))];
    brandNameLabel.textColor = R_G_B_16(0x323232);
    brandNameLabel.font = XNRFont(14);
    brandNameLabel.numberOfLines = 0;
    self.brandNameLabel = brandNameLabel;
    [topView addSubview:brandNameLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImageView.frame) + PX_TO_PT(20), CGRectGetMaxY(brandNameLabel.frame) + PX_TO_PT(20), ScreenWidth - CGRectGetMaxX(goodsImageView.frame) - PX_TO_PT(52), PX_TO_PT(30))];
    detailLabel.font = XNRFont(12);
    detailLabel.textColor = R_G_B_16(0x909090);
    self.detailLabel = detailLabel;
//    [topView addSubview:detailLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(goodsImageView.frame) + PX_TO_PT(20), ScreenWidth, PX_TO_PT(70))];
    self.priceLabel = priceLabel;
    priceLabel.font = XNRFont(16);
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.textColor = R_G_B_16(0x323232);
    [topView addSubview:priceLabel];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(300), ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [topView addSubview:topLine];

}
-(void)createMidView{
    
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, PX_TO_PT(240))];
    self.midView = midView;
    [self.contentView addSubview:midView];
    
    UILabel *sectionOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
    sectionOneLabel.text = @"阶段一: 定金";
    sectionOneLabel.textColor = R_G_B_16(0x323232);
    [midView addSubview:sectionOneLabel];
    
    UILabel *depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
    depositLabel.textAlignment = NSTextAlignmentRight;
    depositLabel.textColor = R_G_B_16(0xff4e00);
    self.depositLabel = depositLabel;
    [midView addSubview:depositLabel];
    
    
    
    
    UILabel *sectionTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(80), ScreenWidth/2, PX_TO_PT(80))];
    sectionTwoLabel.text = @"阶段二: 尾款";
    sectionTwoLabel.textColor = R_G_B_16(0x323232);
    [midView addSubview:sectionTwoLabel];
    
    UILabel *remainPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(80), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
    remainPriceLabel.textAlignment = NSTextAlignmentRight;
    remainPriceLabel.textColor = R_G_B_16(0x323232);
    self.remainPriceLabel = remainPriceLabel;
    [midView addSubview:remainPriceLabel];
    
    
    // 合计
    UILabel *goodsTotalLabelMid = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(160), ScreenWidth/2, PX_TO_PT(80))];
    goodsTotalLabelMid.textColor = R_G_B_16(0x323232);
    self.goodsTotalLabelMid = goodsTotalLabelMid;
    [midView addSubview:goodsTotalLabelMid];
    
    UILabel *totoalPriceLabelMid = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(160), ScreenWidth/2 - PX_TO_PT(32), PX_TO_PT(80))];
    totoalPriceLabelMid.textAlignment = NSTextAlignmentRight;
    self.totoalPriceLabelMid = totoalPriceLabelMid;
    [midView addSubview:totoalPriceLabelMid];
    
    for (int i = 0; i<3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80) + PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [midView addSubview:lineView];
    }
    
}

-(void)createBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, PX_TO_PT(80))];
    self.bottomView = bottomView;
    [self.contentView addSubview:bottomView];
    
    UILabel *goodsTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
    goodsTotalLabel.textColor = R_G_B_16(0x323232);
    self.goodsTotalLabel = goodsTotalLabel;
    [bottomView addSubview:goodsTotalLabel];
    
    UILabel *totoalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2 - PX_TO_PT(32), PX_TO_PT(80))];
    totoalPriceLabel.textAlignment = NSTextAlignmentRight;
    self.totoalPriceLabel = totoalPriceLabel;
    [bottomView addSubview:totoalPriceLabel];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [bottomView addSubview:topLine];
    
    
    UIView *bottonLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(1))];
    bottonLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [bottomView addSubview:bottonLine];

    
}

-(void)setCellDataWithModel:(XNRShoppingCartModel *)model
{
    _model = model;
    
    
    if (self.model.deposit && [self.model.deposit floatValue] > 0) {
        
//        self.midView.hidden = NO;
        self.bottomView.hidden = YES;

    }else{
        self.midView.hidden = YES;
        
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl];
    //图片
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    NSLog(@"-----------%@",self.model.goodsName);
    
    //商品名
    self.brandNameLabel.text = self.model.goodsName;

    self.detailLabel.text = self.model.productDesc;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.unitPrice.floatValue];
    // 订金
    self.depositLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.deposit.floatValue];
    
    // 尾款
    self.remainPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.unitPrice.floatValue - self.model.deposit.floatValue];
    // 商品件数
    self.goodsTotalLabel.text = [NSString stringWithFormat:@"共%@件商品",self.model.goodsCount];
    self.goodsTotalLabelMid.text = [NSString stringWithFormat:@"共%@件商品",self.model.goodsCount];
    _totalPrice = 0;
        // 合计
        if (self.model.deposit &&[self.model.deposit floatValue] > 0) {
            
            _totalPrice = _totalPrice + model.goodsCount.intValue *[[NSString stringWithFormat:@"%@",model.deposit] floatValue];

        }else{
            _totalPrice = _totalPrice + model.goodsCount.intValue*[[NSString stringWithFormat:@"%@",self.model.unitPrice] floatValue];
        }
        NSLog(@"totalPrice === %.2f",_totalPrice);

     // 价格合计
    self.totoalPriceLabel.text = [NSString stringWithFormat:@"价格合计: ￥%.2f",_totalPrice];
    self.totoalPriceLabelMid.text = [NSString stringWithFormat:@"价格合计: ￥%.2f",_totalPrice];

    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.totoalPriceLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
//                               NSFontAttributeName:[UIFont systemFontOfSize:18]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(5,AttributedStringDeposit.length-5)];
    
    [self.totoalPriceLabel setAttributedText:AttributedStringDeposit];
    
    NSMutableAttributedString *AttributedStringDepositMid = [[NSMutableAttributedString alloc]initWithString:self.totoalPriceLabelMid.text];
    NSDictionary *depositStrMid=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
//                               NSFontAttributeName:[UIFont systemFontOfSize:18]
                               
                               };
    
    [AttributedStringDepositMid addAttributes:depositStrMid range:NSMakeRange(5,AttributedStringDepositMid.length-5)];
    
    [self.totoalPriceLabelMid setAttributedText:AttributedStringDepositMid];


    
    

    
    




}


@end
