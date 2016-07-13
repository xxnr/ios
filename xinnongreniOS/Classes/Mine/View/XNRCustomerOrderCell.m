//
//  XNRCustomerOrderCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCustomerOrderCell.h"

@interface XNRCustomerOrderCell()

@property (nonatomic, strong) XNRCustomerOrderModel *model;

@property (nonatomic ,weak) UILabel *brandNameLabel;

@property (nonatomic ,weak) UILabel *numLabel;

@property (nonatomic ,weak) UILabel *orderPriceLabel;



@end

@implementation XNRCustomerOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

#pragma mark - 创建一个View
-(void)createView{
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(100))];
    orderView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:orderView];
    
    UILabel *brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, (ScreenWidth/3)*2, PX_TO_PT(100))];
    brandNameLabel.textColor = R_G_B_16(0x646464);
    brandNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.brandNameLabel = brandNameLabel;
    [orderView addSubview:brandNameLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth/3)*2, 0, ScreenWidth/3-PX_TO_PT(32), PX_TO_PT(100))];
    numLabel.textColor = R_G_B_16(0x323232);
    numLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    numLabel.textAlignment = NSTextAlignmentRight;
    self.numLabel = numLabel;
    [orderView addSubview:numLabel];
        
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    topLineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [orderView addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(100), ScreenWidth, 1)];
    bottomLineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [orderView addSubview:bottomLineView];
    
}

#pragma mark  - 数据源

-(void)setCellDataWithCustomerOrderModel:(XNRCustomerOrderModel *)model
{
    _model = model;
    //商品名
    self.brandNameLabel.text = model.name;
    // 数量
    self.numLabel.text = [NSString stringWithFormat:@"x %@",model.count];
    // 订单金额

}

@end
