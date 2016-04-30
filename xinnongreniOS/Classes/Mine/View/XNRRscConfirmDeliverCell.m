//
//  XNRRscConfirmDeliverCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/27.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscConfirmDeliverCell.h"
#import "XNRRscDeliverFrameModel.h"
#import "XNRRscOrderModel.h"
@interface XNRRscConfirmDeliverCell()
@property (nonatomic, strong) XNRRscSkusModel *model;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UILabel *goodsNameLabel;
@property (nonatomic, weak) UILabel *goodsNumberLabel;
@property (nonatomic, weak) UILabel *attributesLabel;
@property (nonatomic, weak) UILabel *addtionsLabel;

@property (nonatomic, weak) UIView *lineView;


@end

@implementation XNRRscConfirmDeliverCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"RscCell";
    XNRRscConfirmDeliverCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XNRRscConfirmDeliverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedBtn setImage:[UIImage imageNamed:@"arrow-circle"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"arrow_the_circle"] forState:UIControlStateSelected];
    self.selectedBtn = selectedBtn;
    [self.contentView addSubview:selectedBtn];
    
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    goodsNameLabel.textColor = R_G_B_16(0x323232);
    goodsNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
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
    addtionsLabel.textColor = R_G_B_16(0x909090);
    addtionsLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    addtionsLabel.numberOfLines = 0;
    self.addtionsLabel = addtionsLabel;
    [self.contentView addSubview:addtionsLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    self.lineView = lineView;
    [self.contentView addSubview:lineView];

}


-(void)setFrameModel:(XNRRscDeliverFrameModel *)frameModel
{
    _frameModel = frameModel;
    // 1.设置数据
    [self setupData];
    
    // 2.设置frame
    [self setupFrame];


}
-(void)setupFrame
{
    self.selectedBtn.frame = self.frameModel.imageViewF;
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
    self.selectedBtn.selected = model.isSelected;
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
