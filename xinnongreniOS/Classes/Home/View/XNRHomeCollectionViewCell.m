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
    picImageView.layer.borderColor=R_G_B_16(0xe0e0e0).CGColor;
    self.picImageView = picImageView;
    [self.contentView addSubview:self.picImageView];
}

#pragma mark - 商品名
- (void)createGoodNameLabel
{
    UILabel *goodNameLabel = [[UILabel alloc]init];
    goodNameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.picImageView.frame)+PX_TO_PT(10), PX_TO_PT(330), PX_TO_PT(80));
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
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl]] placeholderImage:[UIImage imageNamed:@"icon_placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    if (self.model.imgUrl == nil || [self.model.imgUrl isEqualToString:@""]) {
        [self.picImageView setImage:[UIImage imageNamed:@"icon_placehold"]];
    }else{
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl]] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    }
    }];

    self.goodNameLabel.text = self.model.goodsName;
    [self.goodNameLabel verticalUpAlignmentWithText:self.model.goodsName maxHeight:PX_TO_PT(80)];

    
    //现价
    self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.unitPrice];

//    NSString *str = [NSString stringWithFormat:@"%@",self.model.unitPrice];
//    if ([str rangeOfString:@"."].location != NSNotFound) {
//        self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.unitPrice.doubleValue];
//    }else{
//        self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.f",self.model.unitPrice.doubleValue];
//    }
    
//     if ([self.presentPriceLabel.text rangeOfString:@".00"].length == 3) {
//        self.presentPriceLabel.text = [self.presentPriceLabel.text substringToIndex:self.presentPriceLabel.text.length-3];
//    }
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
