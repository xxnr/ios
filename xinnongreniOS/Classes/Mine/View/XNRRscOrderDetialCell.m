//
//  XNRRscOrderDetialCell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscOrderDetialCell.h"
#import "XNRRscOrderModel.h"
#import "XNRRscOrderDetialFrameModel.h"
#import "UIImageView+WebCache.h"

@interface XNRRscOrderDetialCell()

@property (nonatomic, weak) UIImageView *goodsImageView;
@property (nonatomic, strong) XNRRscSkusModel *model;
@property (nonatomic, weak) UILabel *goodsNameLabel;
@property (nonatomic, weak) UILabel *goodsNumberLabel;
@property (nonatomic, weak) UILabel *attributesLabel;
@property (nonatomic, weak) UILabel *addtionsLabel;

@property (nonatomic, weak) UIView *lineView;
@end

@implementation XNRRscOrderDetialCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"RscCell";
    XNRRscOrderDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XNRRscOrderDetialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        
    }
    return self;
}

-(void)createView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.borderWidth = PX_TO_PT(1);
    imageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    self.goodsImageView = imageView;
    [self.contentView addSubview:imageView];
    
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    goodsNameLabel.textColor = R_G_B_16(0x323232);
    goodsNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    goodsNameLabel.numberOfLines = 0;
    self.goodsNameLabel = goodsNameLabel;
    [self.contentView addSubview:goodsNameLabel];
    
    UILabel *goodsNumberLabel = [[UILabel alloc] init];
    goodsNumberLabel.textColor = R_G_B_16(0x323232);
    goodsNumberLabel.textAlignment = NSTextAlignmentRight;
    goodsNumberLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    self.goodsNumberLabel = goodsNumberLabel;
    [self.contentView addSubview:goodsNumberLabel];
    
    UILabel *attributesLabel = [[UILabel alloc] init];
    attributesLabel.textColor = R_G_B_16(0x909090);
    attributesLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    attributesLabel.numberOfLines = 0;
    self.attributesLabel = attributesLabel;
    [self.contentView addSubview:attributesLabel];
    
    UILabel *addtionsLabel = [[UILabel alloc] init];
    addtionsLabel.textColor = R_G_B_16(0x323232);
    addtionsLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    addtionsLabel.numberOfLines = 0;
    self.addtionsLabel = addtionsLabel;
    [self.contentView addSubview:addtionsLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
    
    
}

-(void)setFrameModel:(XNRRscOrderDetialFrameModel *)frameModel
{
    _frameModel = frameModel;
    // 1.设置数据
    [self setupData];
    
    // 2.设置frame
    [self setupFrame];
}

-(void)setupFrame
{
    self.goodsImageView.frame = self.frameModel.imageViewF;
    self.goodsNameLabel.frame = self.frameModel.goodsNameLabelF;
    self.goodsNumberLabel.frame = self.frameModel.goodsNumberLabelF;
    self.attributesLabel.frame = self.frameModel.attributesLabelF;
    self.addtionsLabel.frame = self.frameModel.addtionsLabelF;
    self.lineView.frame = self.frameModel.bottomLineF;
}

-(void)setupData
{
    XNRRscSkusModel *model = self.frameModel.model;
    _model = model;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,model.thumbnail];
    //图片
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (urlStr == nil || [urlStr isEqualToString:@""]) {
            [self.goodsImageView setImage:[UIImage imageNamed:@"icon_placehold"]];
        }else{
            [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
        }}];
    self.goodsNameLabel.text = model.name;
    self.goodsNumberLabel.text = [NSString stringWithFormat:@"x %@",model.count];
    
    // 属性
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in model.attributes) {
        [displayStr appendString:[NSString stringWithFormat:@"%@:%@;",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
    }
    self.attributesLabel.text = displayStr;
    
    // 附加选项
    NSMutableString *addtionStr = [[NSMutableString alloc] initWithString:@""];
    NSString *price;
    CGFloat totalPrice = 0;
    for (NSDictionary *subDic in model.additions) {
        [addtionStr appendString:[NSString stringWithFormat:@"%@;",[subDic objectForKey:@"name"]]];
        price = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"price"]];
        totalPrice = totalPrice + [price doubleValue];
    }
    // 附加选项
    self.addtionsLabel.text = [NSString stringWithFormat:@"附加项目:%@",addtionStr];
}


@end
