//
//  XNRMyOrderServe_Cell.m
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyOrderServe_Cell.h"
#import "UIImageView+WebCache.h"
#import "XNRMyAllOrderFrame.h"


@interface XNRMyOrderServe_Cell ()

@property (nonatomic,strong) XNRMyOrderModel*info;

@property (nonatomic ,weak) UIImageView *iconImageView;
@property (nonatomic ,weak) UILabel *goodsNameLabel;

@property (nonatomic ,weak) UILabel *priceLabel;
@property (nonatomic ,weak) UILabel *numLabel;

@property (nonatomic ,weak) UILabel *totalPriceLabel;

@property (nonatomic ,weak) UILabel *sectionOne;
@property (nonatomic ,weak) UILabel *sectionTwo;
@property (nonatomic ,weak) UILabel *depositLabel;
@property (nonatomic ,weak) UILabel *remainPriceLabel;

@property (nonatomic ,weak) UILabel *attributesLabel;
@property (nonatomic ,weak) UILabel *addtionsLabel;
@property (nonatomic ,weak) UILabel *addtionPriceLabel;

@property (nonatomic ,weak) UIView *topLine;
@property (nonatomic ,weak) UIView *middleLine;
@property (nonatomic ,weak) UIView *bottomLine;


@end
@implementation XNRMyOrderServe_Cell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"attributesArrayattributesArray%@",_attributesArray);
        [self createTopView];
        [self createBottomView];
    }
    return self;
}

- (void)createTopView
{

    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.borderWidth = 1.0;
    iconImageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    self.iconImageView = iconImageView;
    [self.contentView addSubview:iconImageView];
    
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    goodsNameLabel.textColor = R_G_B_16(0x323232);
    goodsNameLabel.numberOfLines = 0;
    goodsNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.goodsNameLabel = goodsNameLabel;
    [self.contentView addSubview:goodsNameLabel];
    
    UILabel *attributesLabel = [[UILabel alloc] init];
    attributesLabel.textColor = R_G_B_16(0x909090);
    attributesLabel.numberOfLines = 0;
    attributesLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.attributesLabel = attributesLabel;
    [self.contentView addSubview:attributesLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = R_G_B_16(0xff4e00);
    priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textColor = R_G_B_16(0x323232);
    numLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    numLabel.textAlignment = NSTextAlignmentLeft;
    self.numLabel = numLabel;
    [self.contentView addSubview:numLabel];
    
    
    UILabel *addtionsLabel = [[UILabel alloc] init];
    addtionsLabel.textAlignment = NSTextAlignmentLeft;
    addtionsLabel.textColor = R_G_B_16(0x323232);
    addtionsLabel.numberOfLines = 0;
    addtionsLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    self.addtionsLabel = addtionsLabel;
    [self.contentView addSubview:addtionsLabel];
    
    UILabel *addtionPriceLabel = [[UILabel alloc]init];
    addtionPriceLabel.textColor = R_G_B_16(0x323232);
    addtionPriceLabel.textAlignment = NSTextAlignmentRight;
    addtionPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.addtionPriceLabel = addtionPriceLabel;
    [self.contentView addSubview:self.addtionPriceLabel];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    self.topLine = topLine;
    [self.contentView addSubview:topLine];
    
    UIView *middleLine = [[UIView alloc] init];
    middleLine.backgroundColor = R_G_B_16(0xc7c7c7);
    self.middleLine = middleLine;
    [self.contentView addSubview:middleLine];

    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    self.bottomLine = bottomLine;
    [self.contentView addSubview:bottomLine];

 }

-(void)createBottomView
{
    
    UILabel *sectionOne = [[UILabel alloc] init];
    sectionOne.textColor = R_G_B_16(0x323232);
    sectionOne.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    sectionOne.text = @"阶段一: 订金";
    self.sectionOne = sectionOne;
    [self.contentView addSubview:sectionOne];
    
    UILabel *sectionTwo = [[UILabel alloc] init];
    sectionTwo.textColor = R_G_B_16(0x323232);
    sectionTwo.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    sectionTwo.text = @"阶段二: 尾款";
    self.sectionTwo = sectionTwo;
    [self.contentView addSubview:sectionTwo];
    
    UILabel *depositLabel = [[UILabel alloc] init];
    depositLabel.textColor = R_G_B_16(0x323232);
    depositLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    depositLabel.textAlignment = NSTextAlignmentRight;
    self.depositLabel = depositLabel;
    [self.contentView addSubview:depositLabel];
    
    UILabel *remainPriceLabel = [[UILabel alloc] init];
    remainPriceLabel.textColor = R_G_B_16(0x323232);
    remainPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    remainPriceLabel.textAlignment = NSTextAlignmentRight;
    self.remainPriceLabel = remainPriceLabel;
    [self.contentView addSubview:remainPriceLabel];
    
}
#pragma mark - 设置model数据模型的数据
-(void)setOrderFrame:(XNRMyAllOrderFrame *)orderFrame
{
    _orderFrame = orderFrame;
    [self setupData];

    [self setupFrame];

    
    
}

-(void)setupFrame
{
    self.iconImageView.frame = self.orderFrame.picImageViewF;
    self.goodsNameLabel.frame = self.orderFrame.productNameLabelF;
    self.attributesLabel.frame = self.orderFrame.attributesLabelF;
    self.numLabel.frame = self.orderFrame.productNumLabelF;
    self.priceLabel.frame = self.orderFrame.priceLabelF;
    self.addtionsLabel.frame = self.orderFrame.addtionLabelF;
    self.addtionPriceLabel.frame = self.orderFrame.addtionPriceLabelF;
    self.sectionOne.frame = self.orderFrame.sectionOneLabelF;
    self.sectionTwo.frame = self.orderFrame.sectionTwoLabelF;
    self.depositLabel.frame = self.orderFrame.depositLabelF;
    self.remainPriceLabel.frame  = self.orderFrame.remainPriceLabelF;
    
    self.topLine.frame = self.orderFrame.topLineF;
    self.middleLine.frame = self.orderFrame.middleLineF;
    self.bottomLine.frame = self.orderFrame.bottomLineF;

}


#pragma mark - 设置现在的数据
- (void)setupData
{
    XNRMyOrderModel *model = self.orderFrame.orderModel;
    _info = model;
    
    
    NSLog(@"attributesArray%@",_attributesArray);
    
    // 图片
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,_info.thumbnail];
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        image = [UIImage imageNamed:@"icon_loading_wrong"];
    }];

    // 商品名
    if (_info.productName) {
        self.goodsNameLabel.text = _info.productName;

    }else{
        self.goodsNameLabel.text = _info.name;
    }
    
    // 属性
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in _attributesArray) {
        [displayStr appendString:[NSString stringWithFormat:@"%@:%@;",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
    }
    self.attributesLabel.text = displayStr;
    
    // 附加选项
    NSMutableString *addtionStr = [[NSMutableString alloc] initWithString:@""];
    NSString *price;
    CGFloat totalPrice = 0;
    for (NSDictionary *subDic in _addtionsArray) {
        [addtionStr appendString:[NSString stringWithFormat:@"%@;",[subDic objectForKey:@"name"]]];
        price = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"price"]];
        totalPrice = totalPrice + [price floatValue];
    }
    // 附加选项
    self.addtionsLabel.text = [NSString stringWithFormat:@"附加项目:%@",addtionStr];
    
    // 附加选项价格
    self.addtionPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];

//    if ([self.addtionsLabel.text isEqualToString:@"附加项目:"]) {
//        self.addtionsLabel.hidden = YES;
//        self.addtionPriceLabel.hidden = YES;
//
//    }
    // 价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_info.price.floatValue];
    
    // 数量
    self.numLabel.text = [NSString stringWithFormat:@"x %@",_info.count];
    
    NSInteger count = [_info.count integerValue];
    // 订金
    self.depositLabel.text = [NSString stringWithFormat:@"¥%.2f",_info.deposit.floatValue * count];
    
    // 尾款
    self.remainPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",(_info.price.floatValue + totalPrice - _info.deposit.floatValue) * count];
    
}
@end
