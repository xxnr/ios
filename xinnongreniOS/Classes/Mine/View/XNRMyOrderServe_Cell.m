//
//  XNRMyOrderServe_Cell.m
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyOrderServe_Cell.h"
#import "UIImageView+WebCache.h"

@interface XNRMyOrderServe_Cell ()

@property (nonatomic,strong) XNRMyOrderModel*info;


@property (nonatomic ,weak) UIImageView *iconImageView;

@property (nonatomic ,weak) UILabel *goodsNameLabel;

@property (nonatomic ,weak) UILabel *priceLabel;

@property (nonatomic ,weak) UILabel *numLabel;

@property (nonatomic ,weak) UIView *noDepositView;
@property (nonatomic ,weak) UILabel *payStyleLabel;
@property (nonatomic ,weak) UILabel *totalPriceLabel;




@end
@implementation XNRMyOrderServe_Cell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(300))];
    topView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:topView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(32), PX_TO_PT(180), PX_TO_PT(180))];
    iconImageView.layer.borderWidth = 1.0;
    iconImageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    self.iconImageView = iconImageView;
    [topView addSubview:iconImageView];
    
    UILabel *goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + PX_TO_PT(32), PX_TO_PT(32), ScreenWidth - CGRectGetMaxX(iconImageView.frame) -PX_TO_PT(64), PX_TO_PT(100))];
    goodsNameLabel.textColor = R_G_B_16(0x323232);
    goodsNameLabel.font = [UIFont systemFontOfSize:16];
    self.goodsNameLabel = goodsNameLabel;
    [topView addSubview:goodsNameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(iconImageView.frame) + PX_TO_PT(34), PX_TO_PT(200), PX_TO_PT(36))];
    priceLabel.textColor = R_G_B_16(0x323232);
    priceLabel.font = [UIFont systemFontOfSize:18];
    self.priceLabel = priceLabel;
    [topView addSubview:priceLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetMaxY(iconImageView.frame) + PX_TO_PT(32), ScreenWidth/2 - PX_TO_PT(32), PX_TO_PT(36))];
    numLabel.textColor = R_G_B_16(0x323232);
    numLabel.font = [UIFont systemFontOfSize:18];
    numLabel.textAlignment = NSTextAlignmentRight;
    self.numLabel = numLabel;
    [topView addSubview:numLabel];
    
    // 没有订金，没有去付款的视图
//    UIView *noDepositView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth, PX_TO_PT(80))];
//    noDepositView.backgroundColor = [UIColor whiteColor];
//    self.noDepositView = noDepositView;
//    [self.contentView addSubview:noDepositView];
//    
//    UILabel *payStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
//    payStyleLabel.textColor = R_G_B_16(0x323232);
//    payStyleLabel.backgroundColor = [UIColor redColor];
//    payStyleLabel.font = [UIFont systemFontOfSize:16];
//    self.payStyleLabel = payStyleLabel;
//    [noDepositView addSubview:payStyleLabel];
//    
//    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
//    totalPriceLabel.font = [UIFont systemFontOfSize:16];
//    self.totalPriceLabel = totalPriceLabel;
//    [noDepositView addSubview:totalPriceLabel];
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
    
    // 图片
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,_info.thumbnail];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    // 商品名
    self.goodsNameLabel.text = _info.name;
    
    // 价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_info.price.floatValue];
    
    // 数量
    self.numLabel.text = [NSString stringWithFormat:@"x %@",_info.count];
    
    
    self.payStyleLabel.text = _info.payType;
    
    

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
