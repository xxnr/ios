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
#import "XNROrderInfoFrame.h"
#import "XNRShoppingCartModel.h"
#define margin PX_TO_PT(20)

@interface XNRSubmitOrderCell()

{
    CGFloat _totalPrice;
}

@property (nonatomic ,weak) UIView *topLine;

@property (nonatomic ,weak) UIView *midLine;

@property (nonatomic ,weak) UIView *bottomLine;

@property (nonatomic ,weak) UIView *addtionsLine;

@property (nonatomic ,weak) UIImageView *goodsImageView;

@property (nonatomic ,weak) UILabel *brandNameLabel;

@property (nonatomic ,weak) UILabel *detailLabel;

@property (nonatomic ,weak) UILabel *priceLabel;

@property (nonatomic ,weak) UILabel *depositLabel;

@property (nonatomic ,weak) UILabel *remainPriceLabel;


@property (nonatomic, weak) UILabel *numLabel;

@property (nonatomic ,weak) UIView *addtionView;

@property (nonatomic,weak) UILabel *addtionLabel;
@property (nonatomic ,weak) UILabel *nameLabel;
@property (nonatomic ,weak) UILabel *addtionPriceLabel;


@property (nonatomic, weak) UILabel *sectionOneLabel;
@property (nonatomic, weak) UILabel *sectionTwoLabel;

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
    
//    [self createMidView];
    
    [self createBottomView];
  
}

-(void)createTopView{
    
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    goodsImageView.layer.borderColor = R_G_B_16(0xe0e0e0).CGColor;
    goodsImageView.layer.borderWidth = 1.0;
    self.goodsImageView = goodsImageView;
    [self.contentView addSubview:goodsImageView];
    
    UILabel *brandNameLabel = [[UILabel alloc] init];
    brandNameLabel.textColor = R_G_B_16(0x323232);
    brandNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    brandNameLabel.numberOfLines = 0;
    self.brandNameLabel = brandNameLabel;
    [self.contentView addSubview:brandNameLabel];
    
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    detailLabel.textColor = R_G_B_16(0x909090);
    detailLabel.numberOfLines = 0;
    self.detailLabel = detailLabel;
    [self.contentView addSubview:detailLabel];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.textColor = R_G_B_16(0x323232);
    self.numLabel = numLabel;
    [self.contentView addSubview:numLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textColor = R_G_B_16(0x323232);
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
}
-(void)createMidView{
    
    UIView *addtionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame), ScreenWidth, _model.additions.count*PX_TO_PT(44))];
    self.addtionView = addtionView;
    [self.contentView addSubview:addtionView];
    
    for (int i = 0; i<_model.additions.count; i++) {
        NSDictionary *subDic = _model.additions[i];

        CGFloat attributesLabelX = PX_TO_PT(30);
        CGFloat attributesLabelY = PX_TO_PT(44) * i;
        CGFloat attributesLabelW = ScreenWidth -PX_TO_PT(60);
        CGFloat  attributesLabelH = PX_TO_PT(44);
        UILabel *addtionLabel = [[UILabel alloc] init];
        addtionLabel.backgroundColor = R_G_B_16(0xf0f0f0);
        [addtionLabel.layer setMasksToBounds:YES];
        [addtionLabel.layer setCornerRadius:10.0];
        self.addtionLabel = addtionLabel;
         addtionLabel.frame = CGRectMake(attributesLabelX, attributesLabelY, attributesLabelW, attributesLabelH);
        [addtionView addSubview:addtionLabel];

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(8), 0, ScreenWidth/2, PX_TO_PT(44))];
        nameLabel.textColor = R_G_B_16(0x909090);
        nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel = nameLabel;
        nameLabel.text = [NSString stringWithFormat:@"%@",subDic[@"name"]];
        [addtionLabel addSubview:nameLabel];
        
        UILabel *addtionPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(70), PX_TO_PT(44))];
        addtionPriceLabel.textColor = R_G_B_16(0x323232);
        addtionPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
        addtionPriceLabel.textAlignment = NSTextAlignmentRight;
        addtionPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[subDic[@"price"] floatValue ]];
        self.addtionPriceLabel = addtionPriceLabel;
        [addtionLabel addSubview:addtionPriceLabel];
        
        
        CGFloat attributesLineViewX = PX_TO_PT(30);
        CGFloat attributesLineViewY = i*CGRectGetMaxY(nameLabel.frame);
        CGFloat attributesLineViewW = ScreenWidth - PX_TO_PT(60);
        CGFloat  attributesLineViewH = PX_TO_PT(3);
        UIView *addtionsLine = [[UIView alloc] init];
        addtionsLine.backgroundColor = [UIColor whiteColor];
        self.addtionsLine = addtionsLine;
        addtionsLine.frame = CGRectMake(attributesLineViewX, attributesLineViewY, attributesLineViewW, attributesLineViewH);
        [addtionView addSubview:addtionsLine];


    }
}

-(void)createBottomView{
    
    UILabel *sectionOneLabel = [[UILabel alloc] init];
    sectionOneLabel.text = @"阶段一: 订金";
    sectionOneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    sectionOneLabel.textColor = R_G_B_16(0x323232);
    self.sectionOneLabel = sectionOneLabel;
    [self.contentView addSubview:sectionOneLabel];
    
    UILabel *depositLabel = [[UILabel alloc] init];
    depositLabel.textAlignment = NSTextAlignmentRight;
    depositLabel.textColor = R_G_B_16(0xFF4E00);
    depositLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.depositLabel = depositLabel;
    [self.contentView addSubview:depositLabel];
    
    
    UILabel *sectionTwoLabel = [[UILabel alloc] init];
    sectionTwoLabel.text = @"阶段二: 尾款";
    sectionTwoLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    sectionTwoLabel.textColor = R_G_B_16(0x323232);
    self.sectionTwoLabel = sectionTwoLabel;
    [self.contentView addSubview:sectionTwoLabel];
    
    UILabel *remainPriceLabel = [[UILabel alloc] init];
    remainPriceLabel.textAlignment = NSTextAlignmentRight;
    remainPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    remainPriceLabel.textColor = R_G_B_16(0x323232);
    self.remainPriceLabel = remainPriceLabel;
    [self.contentView addSubview:remainPriceLabel];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = R_G_B_16(0xe0e0e0);
    self.topLine = topLine;
    [self.contentView addSubview:topLine];
    
    UIView *midLine = [[UIView alloc] init];
    midLine.backgroundColor = R_G_B_16(0xe0e0e0);
    self.midLine = midLine;
    [self.contentView addSubview:midLine];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = R_G_B_16(0xe0e0e0);
    self.bottomLine = bottomLine;
    [self.contentView addSubview:bottomLine];

}

-(void)setOrderFrame:(XNROrderInfoFrame *)orderFrame
{
    [self.addtionView removeFromSuperview];
    _orderFrame = orderFrame;
    [self setupFrame];
    [self setupData];
    [self createMidView];


}

-(void)setupFrame{
    
    self.goodsImageView.frame = _orderFrame.picImageViewF;
    self.brandNameLabel.frame = _orderFrame.goodNameLabelF;
    self.detailLabel.frame = _orderFrame.attributesLabelF;
    self.numLabel.frame = _orderFrame.numberLabelF;
    self.priceLabel.frame = _orderFrame.PriceLabelF;
    
//    self.addtionLabel.frame = _orderFrame.addtionsLabelF;
//    self.addtionsLine.frame = _orderFrame.addtionslineViewF;
   
    
    self.sectionOneLabel.frame = _orderFrame.sectionOneLabelF;
    self.sectionTwoLabel.frame = _orderFrame.sectionTwoLabelF;
    
    self.depositLabel.frame = _orderFrame.depositeLabelF;
    self.remainPriceLabel.frame = _orderFrame.finalPaymentLabelF;
    
    self.topLine.frame = _orderFrame.topLineF;
    self.midLine.frame = _orderFrame.middleLineF;
    self.bottomLine.frame = _orderFrame.bottomLineF;



}
-(void)setupData{
    
    XNRShoppingCartModel *model = self.orderFrame.shoppingCarModel;
    
    _model = model;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl];
    //图片
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    if (urlStr == nil || [urlStr isEqualToString:@""]) {
        [self.goodsImageView setImage:[UIImage imageNamed:@"icon_placehold"]];
    }else{
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    }}];


    NSLog(@"-----------%@",self.model.goodsName);
    
    //商品名
    self.brandNameLabel.text = self.model.productName;
    
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in self.model.attributes) {
        [displayStr appendString:[NSString stringWithFormat:@"%@:%@",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
        [displayStr appendString:@";"];
        
    }
    self.detailLabel.text = displayStr;
    
    NSString *price;
    CGFloat totalPrice = 0;
    for (NSDictionary *subDic in self.model.additions) {
        price = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"price"]];
        totalPrice = totalPrice + [price doubleValue];
    }

    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.price.doubleValue];

    self.numLabel.text = [NSString stringWithFormat:@"x %@",self.model.count];
    
    
    // 订金
    self.depositLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.deposit.doubleValue*[_model.count doubleValue]];
    
    // 尾款
    self.remainPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",(self.model.price.doubleValue+totalPrice - self.model.deposit.doubleValue) * [_model.count doubleValue]];

}


@end
