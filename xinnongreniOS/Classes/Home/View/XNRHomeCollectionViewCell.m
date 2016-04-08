  //
//  XNRHomeCollectionViewCell.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/27.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRHomeCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZSCLabel.h"
#import "UIFont+BSExt.h"
#import "UILabel+ZSC.h"
@interface XNRHomeCollectionViewCell ()
{
    NSString *prasale;
}

@property (nonatomic,weak)XNRShoppingCartModel *model;
@property (nonatomic,weak) UIImageView *picImageView;   //图片
@property (nonatomic,weak) UILabel *goodNameLabel;      //商品
@property (nonatomic,weak) UILabel *presentPriceLabel;  //现价格
@end

@implementation XNRHomeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self createPicImageView];
    [self createGoodNameLabel];
    [self createPresentPriceLabel];
}
#pragma mark - 图片
- (void)createPicImageView
{
     UIImageView *picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, PX_TO_PT(330), PX_TO_PT(330))];
    picImageView.contentMode = UIViewContentModeScaleAspectFit;
    picImageView.layer.masksToBounds=YES;
    picImageView.layer.borderWidth=PX_TO_PT(2);
    picImageView.layer.borderColor=R_G_B_16(0xc7c7c7).CGColor;
    self.picImageView = picImageView;
    [self.contentView addSubview:self.picImageView];
}

#pragma mark - 商品名
- (void)createGoodNameLabel
{
    UILabel *goodNameLabel = [[UILabel alloc]init];
    goodNameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.picImageView.frame)+PX_TO_PT(10), PX_TO_PT(330), PX_TO_PT(80));
//    goodNameLabel.backgroundColor = [UIColor redColor];
    goodNameLabel.textColor = R_G_B_16(0x323232);
    goodNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    goodNameLabel.numberOfLines = 0;
    self.goodNameLabel = goodNameLabel;
    [self.contentView addSubview:self.goodNameLabel];
}

#pragma mark - 现价
- (void)createPresentPriceLabel
{
    UILabel *presentPriceLabel = [[UILabel alloc]init];
    presentPriceLabel.textColor = R_G_B_16(0xff4e00);
    presentPriceLabel.font = [UIFont  systemFontOfSize:PX_TO_PT(36)];
    presentPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.presentPriceLabel = presentPriceLabel;
    [self.contentView addSubview:self.presentPriceLabel];
}


#pragma mark - 设置model数据模型的数据
- (void)setCellDataWithShoppingCartModel:(XNRShoppingCartModel *)model
{
    self.model = model;
    [self resetSubViews];
    [self setSubViews];
}

#pragma mark - 清空以前的数据
- (void)resetSubViews
{
    self.picImageView.image = nil;
}

#pragma mark - 设置现在的数据
- (void)setSubViews
{
    //图片
    
    if (self.model.imgUrl == nil || [self.model.imgUrl isEqualToString:@""]) {
        [self.picImageView setImage:[UIImage imageNamed:@"icon_placehold"]];
    }else{
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl]] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    }

    
    //商品名
//    CGSize maxSize = CGSizeMake(PX_TO_PT(330), MAXFLOAT);
//    CGSize nameSize = [self.model.goodsName sizeWithFont_BSExt:self.goodNameLabel.font maxSize:maxSize];
//    self.goodNameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.picImageView.frame) + PX_TO_PT(20),nameSize.width, nameSize.height);
    
    self.goodNameLabel.text = self.model.goodsName;
    
    
    //现价
    if (self.model.unitPrice.floatValue>1) {
        self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.f",self.model.unitPrice.floatValue];
    }else{
        self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.unitPrice.floatValue];
    }
    if ([self.model.presale integerValue] == 1) {
        self.presentPriceLabel.text = @"即将上线";
        self.presentPriceLabel.textColor = R_G_B_16(0xc7c7c7);
    }else{
        self.presentPriceLabel.textColor = R_G_B_16(0xff4e00);
    }
    CGSize priceSize = [self.presentPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(36)]}];
    self.presentPriceLabel.frame = CGRectMake(0, CGRectGetMaxY(self.picImageView.frame)+PX_TO_PT(90), priceSize.width, priceSize.height);
}
@end
