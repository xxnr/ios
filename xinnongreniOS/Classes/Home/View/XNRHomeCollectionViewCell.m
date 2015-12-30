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
//    picImageView.layer.cornerRadius=10.0;
    picImageView.layer.borderWidth=PX_TO_PT(2);
    picImageView.layer.borderColor=R_G_B_16(0xc7c7c7).CGColor;
//    picImageView.layer.shadowColor=[UIColor blackColor].CGColor;
//    picImageView.layer.shadowOpacity=.5;//透明度
//    picImageView.layer.shadowOffset=CGSizeMake(10, 10);//偏移量

    self.picImageView = picImageView;
    [self.contentView addSubview:self.picImageView];
}

#pragma mark - 商品名
- (void)createGoodNameLabel
{
    UILabel *goodNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.picImageView.frame),PX_TO_PT(330), PX_TO_PT(90))];
    goodNameLabel.textColor = R_G_B_16(0x32323);
    goodNameLabel.font = XNRFont(12);
    goodNameLabel.numberOfLines = 0;
    goodNameLabel.adjustsFontSizeToFitWidth = YES;
    [goodNameLabel fitTextHeight_Ext];
    
    self.goodNameLabel = goodNameLabel;
    [self.contentView addSubview:self.goodNameLabel];
}

#pragma mark - 现价
- (void)createPresentPriceLabel
{
    UILabel *presentPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodNameLabel.frame), PX_TO_PT(316), PX_TO_PT(60))];
    presentPriceLabel.textColor = R_G_B_16(0xff4e00);
    presentPriceLabel.font = XNRFont(18);
    presentPriceLabel.adjustsFontSizeToFitWidth = YES;
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
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl]] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    
    //商品名
    self.goodNameLabel.text = self.model.goodsName;
    
    
    //现价
    if (self.model.unitPrice>1) {
        self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.f",self.model.unitPrice];
    }else{
        self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.unitPrice];
    }
    if ([self.model.presale integerValue] == 1) {
        self.presentPriceLabel.text = @"即将上线";
        self.presentPriceLabel.textColor = R_G_B_16(0xc7c7c7);
    }else{
        self.presentPriceLabel.textColor = R_G_B_16(0xff4e00);
    }
    
    
}
@end
