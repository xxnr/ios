////
////  XNROderInfo_Cell.m
////  xinnongreniOS
////
////  Created by 张国兵 on 15/6/5.
////  Copyright (c) 2015年 qxhiOS. All rights reserved.
////
//
//#import "XNROderInfo_Cell.h"
//#import "UIImageView+WebCache.h"
//
//@interface XNROderInfo_Cell ()
//
//@property (nonatomic ,weak) UIView *bgView;
//
//@property(nonatomic,strong)  XNRCheckOrderModel*model;
//
//@property (nonatomic ,weak) UIImageView *goodsImageView;
//
//@property (nonatomic ,weak) UILabel *goodsNameLabel;
//
//@property (nonatomic ,weak) UILabel *priceLabel;
//
//@property (nonatomic ,weak) UILabel *numLabel;
//
//@property (nonatomic ,weak) UIView *bgBottomView;
//@property (nonatomic ,weak) UILabel *depositLabel;
//@property (nonatomic ,weak) UILabel *remainPriceLabel;
//
//
//@end
//
//@implementation XNROderInfo_Cell
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//        [self createTopView];
//        [self createBottomView];
//    }
//    return self;
//}
//-(void)createTopView
//{
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(300))];
//    bgView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:bgView];
//    
//    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(32), PX_TO_PT(180), PX_TO_PT(180))];
//    goodsImageView.layer.borderWidth = 1.0;
//    goodsImageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
//    self.goodsImageView = goodsImageView;
//    [bgView addSubview:goodsImageView];
//    
//    UILabel *goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImageView.frame) + PX_TO_PT(20), PX_TO_PT(32), ScreenWidth-CGRectGetMaxX(goodsImageView.frame) - PX_TO_PT(52), PX_TO_PT(100))];
//    goodsNameLabel.textColor = R_G_B_16(0x323232);
//    goodsNameLabel.font = [UIFont systemFontOfSize:16];
//    goodsNameLabel.numberOfLines = 0;
//    self.goodsNameLabel = goodsNameLabel;
//    [bgView addSubview:goodsNameLabel];
//    
//    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetMaxY(goodsImageView.frame) + PX_TO_PT(32), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(36))];
//    priceLabel.textColor = R_G_B_16(0xff4e00);
//    priceLabel.font = [UIFont systemFontOfSize:16];
//    priceLabel.textAlignment = NSTextAlignmentRight;
//    self.priceLabel = priceLabel;
//    [bgView addSubview:priceLabel];
//    
//    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(goodsImageView.frame) + PX_TO_PT(34), ScreenWidth/2 - PX_TO_PT(32), PX_TO_PT(36))];
//    numLabel.textColor = R_G_B_16(0x323232);
//    numLabel.font = [UIFont systemFontOfSize:18];
//    numLabel.textAlignment = NSTextAlignmentLeft;
//    self.numLabel = numLabel;
//    [bgView addSubview:numLabel];
//
//    
//    for (int i = 0; i<2; i++) {
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(300)*i, ScreenWidth, PX_TO_PT(1))];
//        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
//        [bgView addSubview:lineView];
//    }
//
//
//}
//
//-(void)createBottomView
//
//{
//    
//    UIView *bgBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(300), ScreenWidth, PX_TO_PT(160))];
//    
//    bgBottomView.backgroundColor = [UIColor whiteColor];
//    
//    self.bgBottomView = bgBottomView;
//    
//    [self.contentView addSubview:bgBottomView];
//    
//    
//    
//    UILabel *sectionOne = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
//    
//    sectionOne.textColor = R_G_B_16(0x323232);
//    
//    sectionOne.font = [UIFont systemFontOfSize:14];
//    
//    sectionOne.text = @"阶段一: 订金";
//    
//    [bgBottomView addSubview:sectionOne];
//    
//    
//    
//    UILabel *sectionTwo = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(80), ScreenWidth/2, PX_TO_PT(80))];
//    
//    sectionTwo.textColor = R_G_B_16(0x323232);
//    
//    sectionTwo.font = [UIFont systemFontOfSize:14];
//    
//    sectionTwo.text = @"阶段二: 尾款";
//    
//    [bgBottomView addSubview:sectionTwo];
//    
//    
//    
//    UILabel *depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
//    
//    depositLabel.textColor = R_G_B_16(0x323232);
//    
//    depositLabel.font = [UIFont systemFontOfSize:16];
//    
//    depositLabel.textAlignment = NSTextAlignmentRight;
//    
//    self.depositLabel = depositLabel;
//    
//    //    depositLabel.text = [NSString stringWithFormat:@"￥%.2f",sectionModel.deposit.floatValue];
//    
//    [bgBottomView addSubview:depositLabel];
//    
//    
//    
//    UILabel *remainPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(80), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
//    
//    remainPriceLabel.textColor = R_G_B_16(0x323232);
//    
//    remainPriceLabel.font = [UIFont systemFontOfSize:16];
//    
//    remainPriceLabel.textAlignment = NSTextAlignmentRight;
//    
//    self.remainPriceLabel = remainPriceLabel;
//    
//    //    remainPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",sectionModel.totalPrice.floatValue - sectionModel.deposit.floatValue];
//    
//    [bgBottomView addSubview:remainPriceLabel];
//    
//    for (int i = 0; i<3; i++) {
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
//        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
//        [bgBottomView addSubview:lineView];
//    }
//}
//
//-(void)setCellDataWithModel:(XNRCheckOrderModel*)model{
//    
//    _model = model;
//    [self setSubViews];
//    
//    
//}
//#pragma mark - 设置现在的数据
//- (void)setSubViews {
//    
//    // 图片
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,_model.imgs];
//    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
//    // 商品名
//    self.goodsNameLabel.text = _model.goodsName;
//    
//    // 价格
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_model.unitPrice.floatValue];
//    
//    // 数量
//    self.numLabel.text = [NSString stringWithFormat:@"x %@",_model.goodsCount];
//    
//    // 订金
//    
//    self.depositLabel.text = [NSString stringWithFormat:@"¥%.2f",_model.deposit.floatValue];
//    
//    
//    
//    // 尾款
//    
//    self.remainPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",_model.unitPrice.floatValue - _model.deposit.floatValue];
//
//    if (_model.deposit && [_model.deposit floatValue]>0) {
//        
//        self.bgBottomView.hidden = NO;
//        
//    }else{
//        
//        self.bgBottomView.hidden = YES;
//        
//    }
//}
//
//@end
