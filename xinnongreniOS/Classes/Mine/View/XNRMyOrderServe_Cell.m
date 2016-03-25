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

@property (nonatomic ,weak) UIView *noDepositView;
@property (nonatomic ,weak) UILabel *payStyleLabel;
@property (nonatomic ,weak) UILabel *totalPriceLabel;

@property (nonatomic ,weak) UIView *bgView;
@property (nonatomic ,weak) UILabel *depositLabel;
@property (nonatomic ,weak) UILabel *remainPriceLabel;

@property (nonatomic ,weak) UILabel *attributesLabel;
@property (nonatomic ,weak) UILabel *addtionsLabel;
@property (nonatomic ,weak) UILabel *addtionPriceLabel;

@property (nonatomic ,weak) UIView *topView;

@end
@implementation XNRMyOrderServe_Cell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"attributesArrayattributesArray%@",_attributesArray);
//        [self createUI];
        [self createTopView];
        [self createBottomView];
    }
    return self;
}

- (void)createTopView
{
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(350))];
        topView.backgroundColor=[UIColor whiteColor];
        self.topView = topView;
        [self.contentView addSubview:topView];

    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(32), PX_TO_PT(180), PX_TO_PT(180))];
    iconImageView.layer.borderWidth = 1.0;
    iconImageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    self.iconImageView = iconImageView;
    [self.topView addSubview:iconImageView];
    
    UILabel *goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + PX_TO_PT(32), PX_TO_PT(32), ScreenWidth - CGRectGetMaxX(iconImageView.frame) -PX_TO_PT(64), PX_TO_PT(100))];
    goodsNameLabel.textColor = R_G_B_16(0x323232);
    goodsNameLabel.numberOfLines = 0;
    goodsNameLabel.font = [UIFont systemFontOfSize:16];
    self.goodsNameLabel = goodsNameLabel;
    [self.topView addSubview:goodsNameLabel];
    
    UILabel *attributesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + PX_TO_PT(20), CGRectGetMaxY(self.goodsNameLabel.frame)-PX_TO_PT(20), ScreenWidth-CGRectGetMaxX(self.iconImageView.frame) - PX_TO_PT(52), PX_TO_PT(120))];
    //    introduceLabel.backgroundColor = [UIColor redColor];
    attributesLabel.textColor = R_G_B_16(0x909090);
    attributesLabel.numberOfLines = 0;
    attributesLabel.font = [UIFont systemFontOfSize:14];
    self.attributesLabel = attributesLabel;
    [self.contentView addSubview:attributesLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetMaxY(iconImageView.frame) + PX_TO_PT(32),ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(36))];
    priceLabel.textColor = R_G_B_16(0xff4e00);
    priceLabel.font = [UIFont systemFontOfSize:16];
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    [self.topView addSubview:priceLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(iconImageView.frame) + PX_TO_PT(34), ScreenWidth/2, PX_TO_PT(36))];
    numLabel.textColor = R_G_B_16(0x323232);
    numLabel.font = [UIFont systemFontOfSize:18];
    numLabel.textAlignment = NSTextAlignmentLeft;
    self.numLabel = numLabel;
    [self.topView addSubview:numLabel];
    
    
    UILabel *addtionsLabel = [MyControl createLabelWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.numLabel.frame), ScreenWidth-PX_TO_PT(300), PX_TO_PT(50)) Font:14 Text:nil];
    addtionsLabel.textAlignment = NSTextAlignmentLeft;
    addtionsLabel.textColor = R_G_B_16(0x323232);
//    addtionsLabel.backgroundColor = [UIColor redColor];
    //    addtionsLabel.numberOfLines = 0;
    self.addtionsLabel = addtionsLabel;
    [self.topView addSubview:addtionsLabel];
    
    UILabel *addtionPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2,CGRectGetMaxY(self.numLabel.frame),ScreenWidth/2-PX_TO_PT(32),PX_TO_PT(50))];
    addtionPriceLabel.textColor = R_G_B_16(0x323232);
    addtionPriceLabel.textAlignment = NSTextAlignmentRight;
    addtionPriceLabel.font = [UIFont systemFontOfSize:16];
    self.addtionPriceLabel = addtionPriceLabel;
    [self.topView addSubview:self.addtionPriceLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(350), ScreenWidth, PX_TO_PT(1))];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [self.topView addSubview:lineView];

    
 }

-(void)createBottomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, PX_TO_PT(160))];
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    
    UILabel *sectionOne = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
    sectionOne.textColor = R_G_B_16(0x323232);
    sectionOne.font = [UIFont systemFontOfSize:14];
    sectionOne.text = @"阶段一: 订金";
    [bgView addSubview:sectionOne];
    
    UILabel *sectionTwo = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(80), ScreenWidth/2, PX_TO_PT(80))];
    sectionTwo.textColor = R_G_B_16(0x323232);
    sectionTwo.font = [UIFont systemFontOfSize:14];
    sectionTwo.text = @"阶段二: 尾款";
    [bgView addSubview:sectionTwo];
    
    UILabel *depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
    depositLabel.textColor = R_G_B_16(0x323232);
    depositLabel.font = [UIFont systemFontOfSize:16];
    depositLabel.textAlignment = NSTextAlignmentRight;
    self.depositLabel = depositLabel;
//    depositLabel.text = [NSString stringWithFormat:@"￥%.2f",sectionModel.deposit.floatValue];
    [bgView addSubview:depositLabel];
    
    UILabel *remainPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(80), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
    remainPriceLabel.textColor = R_G_B_16(0x323232);
    remainPriceLabel.font = [UIFont systemFontOfSize:16];
    remainPriceLabel.textAlignment = NSTextAlignmentRight;
    self.remainPriceLabel = remainPriceLabel;
//    remainPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",sectionModel.totalPrice.floatValue - sectionModel.deposit.floatValue];
    [bgView addSubview:remainPriceLabel];
    
    for (int i = 0; i<3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [bgView addSubview:lineView];
    }

}

-(void)setOrderFrame:(XNRMyAllOrderFrame *)orderFrame
{
    

}

#pragma mark - 设置model数据模型的数据
- (void)setCellDataWithShoppingCartModel:(XNRMyOrderModel *)info
{
    _info = info;
    [self setSubViews];
}

#pragma mark - 设置现在的数据
- (void)setSubViews
{
//    [self createTopView:_addtionsArray];
    if (_addtionsArray.count == 0) {
        self.addtionsLabel.hidden = YES;
        self.addtionPriceLabel.hidden = YES;
    }
    
    NSLog(@"attributesArray%@",_attributesArray);
    
    // 图片
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,_info.thumbnail];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    // 商品名
    self.goodsNameLabel.text = _info.name;
    
    // 属性
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in _attributesArray) {
        [displayStr appendString:[NSString stringWithFormat:@" %@:%@;",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
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

    
    // 价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_info.price.floatValue];
    
    // 数量
    self.numLabel.text = [NSString stringWithFormat:@"x %@",_info.count];
    
    NSInteger count = [_info.count integerValue];
    // 订金
    self.depositLabel.text = [NSString stringWithFormat:@"¥%.2f",_info.deposit.floatValue * count];
    
    // 尾款
    self.remainPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",(_info.price.floatValue + totalPrice - _info.deposit.floatValue) * count];
    
    if (_info.deposit && [_info.deposit floatValue]>0) {
        self.bgView.hidden = NO;
    }else{
        self.bgView.hidden = YES;
    }
    
    

//    NSMutableAttributedString*Attributed_orderNum=[[NSMutableAttributedString alloc]initWithString:self.orderNum.text];
//    NSDictionary*att_order=@{
//                             NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
//                             NSForegroundColorAttributeName:R_G_B_16(0x31b1be),
//                             
//                             };
//    
//    [Attributed_orderNum addAttributes:att_order range:NSMakeRange(4, Attributed_orderNum.length-4)];
//    
//    [self.orderNum setAttributedText:Attributed_orderNum];
    
    
    
//    NSMutableAttributedString*Attributed_allPrice=[[NSMutableAttributedString alloc]initWithString: self.allPrice.text];
//    [Attributed_allPrice addAttribute:NSFontAttributeName value:XNRFont(10) range:NSMakeRange(3, Attributed_allPrice.length-3)];
//    [Attributed_allPrice addAttribute:NSForegroundColorAttributeName value:R_G_B_16(0x0da014) range:NSMakeRange(3, Attributed_allPrice.length-3)];
//    
//    [self.allPrice setAttributedText:Attributed_allPrice];
    
    
    
}
@end
