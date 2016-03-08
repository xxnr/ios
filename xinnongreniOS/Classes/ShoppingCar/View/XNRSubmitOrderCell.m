//
//  XNRSubmitOrderCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/8.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSubmitOrderCell.h"
#import "UIImageView+WebCache.h"
#import "XNRAddtionsModel.h"

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

@property (nonatomic, weak) UILabel *numLabel;

@property (nonatomic ,weak) UIView *addtionView;

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
    
//    [self createTopView];
//    [self createMidView];
//    [self createBottomView];
  
}

-(void)createTopView:(XNRShoppingCartModel *)addtionsModel{
    
    UIView *topView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(300))];
    self.topView = topView;
    [self.contentView addSubview:topView];
    
    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(30), PX_TO_PT(180), PX_TO_PT(180))];
    goodsImageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    goodsImageView.layer.borderWidth = 1.0;
    self.goodsImageView = goodsImageView;
    [topView addSubview:goodsImageView];
    
    UILabel *brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImageView.frame) + PX_TO_PT(20), PX_TO_PT(40), ScreenWidth - CGRectGetMaxX(goodsImageView.frame) - PX_TO_PT(52), PX_TO_PT(100))];
    brandNameLabel.textColor = R_G_B_16(0x323232);
    brandNameLabel.font = XNRFont(14);
    brandNameLabel.numberOfLines = 0;
    
    self.brandNameLabel = brandNameLabel;
    [topView addSubview:brandNameLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImageView.frame) + PX_TO_PT(20), CGRectGetMaxY(brandNameLabel.frame), ScreenWidth - CGRectGetMaxX(goodsImageView.frame) - PX_TO_PT(52), PX_TO_PT(70))];
    detailLabel.font = XNRFont(12);
    detailLabel.textColor = R_G_B_16(0x909090);
    detailLabel.numberOfLines = 0;
    self.detailLabel = detailLabel;
    [topView addSubview:detailLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(goodsImageView.frame) + PX_TO_PT(20), ScreenWidth, PX_TO_PT(70))];
    self.numLabel = numLabel;
    numLabel.font = XNRFont(14);
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.textColor = R_G_B_16(0x323232);
    [topView addSubview:numLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetMaxY(goodsImageView.frame) + PX_TO_PT(20), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(70))];
    priceLabel.font = XNRFont(14);
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textColor = R_G_B_16(0x323232);
    self.priceLabel = priceLabel;
    [topView addSubview:priceLabel];
    
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [topView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,PX_TO_PT(300), ScreenWidth, PX_TO_PT(1))];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
//    [topView addSubview:bottomLine];
    if (addtionsModel.additions.count>0) {
        
        UIView *addtionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth, addtionsModel.additions.count*PX_TO_PT(45))];
        self.addtionView = addtionView;
//        addtionView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:addtionView];
        
        for (int i = 0; i<addtionsModel.additions.count; i++) {
            UILabel *addtionLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(45)*i, ScreenWidth-PX_TO_PT(64), PX_TO_PT(45))];
            addtionLabel.backgroundColor = R_G_B_16(0xe0e0e0);
            addtionLabel.layer.cornerRadius = 5.0;
            addtionLabel.layer.masksToBounds = YES;
            [addtionView addSubview:addtionLabel];
            
            NSDictionary *subDic = addtionsModel.additions[i];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, PX_TO_PT(45))];
            nameLabel.textColor = R_G_B_16(0x323232);
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.text = [NSString stringWithFormat:@"%@",subDic[@"name"]];
            [addtionLabel addSubview:nameLabel];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(64), PX_TO_PT(45))];
            priceLabel.textColor = R_G_B_16(0x323232);
            priceLabel.font = [UIFont systemFontOfSize:14];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.text = [NSString stringWithFormat:@"¥:%@",subDic[@"price"]];
            [addtionLabel addSubview:priceLabel];
            
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(45)+i*PX_TO_PT(45), ScreenWidth-PX_TO_PT(64), PX_TO_PT(3))];
//            lineView.backgroundColor = [UIColor redColor];
//            [addtionView addSubview:lineView];

        }
    }
}
-(void)createMidView:(XNRShoppingCartModel *)addtionsArray{
    
    if (addtionsArray.additions.count == 0) {
        UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, PX_TO_PT(160))];
        self.midView = midView;
//        midView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:midView];

    }else{
        UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addtionView.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(160))];
//        midView.backgroundColor = [UIColor redColor];
        self.midView = midView;
        [self.contentView addSubview:midView];
        
    }
    
    
    UILabel *sectionOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
    sectionOneLabel.text = @"阶段一: 订金";
    sectionOneLabel.font = [UIFont systemFontOfSize:14];
    sectionOneLabel.textColor = R_G_B_16(0x323232);
    [self.midView addSubview:sectionOneLabel];
    
    UILabel *depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
    depositLabel.textAlignment = NSTextAlignmentRight;
    depositLabel.textColor = R_G_B_16(0xff4e00);
    depositLabel.font = [UIFont systemFontOfSize:14];
    self.depositLabel = depositLabel;
    [self.midView addSubview:depositLabel];
    
    
    UILabel *sectionTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(80), ScreenWidth/2, PX_TO_PT(80))];
    sectionTwoLabel.text = @"阶段二: 尾款";
    sectionTwoLabel.font = [UIFont systemFontOfSize:14];
    sectionTwoLabel.textColor = R_G_B_16(0x323232);
    [self.midView addSubview:sectionTwoLabel];
    
    UILabel *remainPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(80), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
    remainPriceLabel.textAlignment = NSTextAlignmentRight;
    remainPriceLabel.font = [UIFont systemFontOfSize:14];
    remainPriceLabel.textColor = R_G_B_16(0x323232);
    self.remainPriceLabel = remainPriceLabel;
    [self.midView addSubview:remainPriceLabel];
    
    
    // 合计
    UILabel *goodsTotalLabelMid = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(160), ScreenWidth/2, PX_TO_PT(80))];
    goodsTotalLabelMid.textColor = R_G_B_16(0x323232);
    goodsTotalLabelMid.font = [UIFont systemFontOfSize:14];
    self.goodsTotalLabelMid = goodsTotalLabelMid;
    [self.midView addSubview:goodsTotalLabelMid];
    
    UILabel *totoalPriceLabelMid = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(160), ScreenWidth/2 - PX_TO_PT(32), PX_TO_PT(80))];
    totoalPriceLabelMid.textAlignment = NSTextAlignmentRight;
    totoalPriceLabelMid.font = [UIFont systemFontOfSize:14];
    self.totoalPriceLabelMid = totoalPriceLabelMid;
//    [midView addSubview:totoalPriceLabelMid];
    
    for (int i = 0; i<3; i++) {
        if (addtionsArray.additions.count == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
            lineView.backgroundColor = R_G_B_16(0xc7c7c7);
            [self.midView addSubview:lineView];
        }else{
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
            lineView.backgroundColor = R_G_B_16(0xc7c7c7);
            [self.midView addSubview:lineView];
        }
    }
    
}

-(void)createBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, PX_TO_PT(80))];
    self.bottomView = bottomView;
    [self.contentView addSubview:bottomView];
    
    UILabel *goodsTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
    goodsTotalLabel.textColor = R_G_B_16(0x323232);
    goodsTotalLabel.font = [UIFont systemFontOfSize:14];
    self.goodsTotalLabel = goodsTotalLabel;
    [bottomView addSubview:goodsTotalLabel];
    
    UILabel *totoalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2 - PX_TO_PT(32), PX_TO_PT(80))];
    totoalPriceLabel.textAlignment = NSTextAlignmentRight;
    totoalPriceLabel.font = [UIFont systemFontOfSize:14];
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
//    if (_model.additions.count == 0) {
//        [self createTopView:nil];
//    }else
//    {
//        [self createTopView:model];
    if (_model.additions.count == 0) {
        [self createTopView:nil];
    }else
    {
        [self createTopView:_model];
    }

    if (_model.deposit && [_model.deposit floatValue] > 0) {
        
        self.bottomView.hidden = YES;
        if (_model.additions.count == 0) {
            [self createMidView:nil];
            
        }else{
            [self createMidView:_model];
        }
        
    }else{
        self.midView.hidden = YES;
        
    }

//    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl];
    //图片
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    NSLog(@"-----------%@",self.model.goodsName);
    
    //商品名
    self.brandNameLabel.text = self.model.productName;

    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in self.model.attributes) {
        [displayStr appendString:[NSString stringWithFormat:@"%@:%@ ",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
    }
    self.detailLabel.text = displayStr;
    
    NSString *price;
    CGFloat totalPrice = 0;
    for (NSDictionary *subDic in self.model.additions) {
        price = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"price"]];
        totalPrice = totalPrice + [price floatValue];
    }

    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.price.floatValue];
    self.numLabel.text = [NSString stringWithFormat:@"x %@",self.model.count];
    // 订金
    self.depositLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.deposit.floatValue];
    
    // 尾款
    self.remainPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.price.floatValue+totalPrice - self.model.deposit.floatValue];
//    // 商品件数
//    self.goodsTotalLabel.text = [NSString stringWithFormat:@"共%@件商品",self.model.goodsCount];
//    self.goodsTotalLabelMid.text = [NSString stringWithFormat:@"共%@件商品",self.model.goodsCount];
//    _totalPrice = 0;
//        // 合计
//        if (self.model.deposit &&[self.model.deposit floatValue] > 0) {
//            
//            _totalPrice = _totalPrice + model.goodsCount.intValue *[[NSString stringWithFormat:@"%@",model.deposit] floatValue];
//
//        }else{
//            _totalPrice = _totalPrice + model.goodsCount.intValue*[[NSString stringWithFormat:@"%@",self.model.unitPrice] floatValue];
//        }
//        NSLog(@"totalPrice === %.2f",_totalPrice);
//
//     // 价格合计
//    self.totoalPriceLabel.text = [NSString stringWithFormat:@"价格合计: ￥%.2f",_totalPrice];
//    self.totoalPriceLabelMid.text = [NSString stringWithFormat:@"价格合计: ￥%.2f",_totalPrice];

//    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.totoalPriceLabel.text];
//    NSDictionary *depositStr=@{
//                               
//                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
////                               NSFontAttributeName:[UIFont systemFontOfSize:18]
//                               
//                               };
//    
//    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(5,AttributedStringDeposit.length-5)];
//    
//    [self.totoalPriceLabel setAttributedText:AttributedStringDeposit];
//    
//    NSMutableAttributedString *AttributedStringDepositMid = [[NSMutableAttributedString alloc]initWithString:self.totoalPriceLabelMid.text];
//    NSDictionary *depositStrMid=@{
//                               
//                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
////                               NSFontAttributeName:[UIFont systemFontOfSize:18]
//                               
//                               };
//    
//    [AttributedStringDepositMid addAttributes:depositStrMid range:NSMakeRange(5,AttributedStringDepositMid.length-5)];
//    
//    [self.totoalPriceLabelMid setAttributedText:AttributedStringDepositMid];


    
    

    
    




}


@end
