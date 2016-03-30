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
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(260))];
    orderView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:orderView];
    
//    UILabel *brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(32), (ScreenWidth/3)*2, PX_TO_PT(100))];
    UILabel *brandNameLabel = [[UILabel alloc] init];
    brandNameLabel.textColor = R_G_B_16(0x323232);
    brandNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [brandNameLabel fitTextHeight_Ext];
    brandNameLabel.numberOfLines = 0;
    self.brandNameLabel = brandNameLabel;
    [orderView addSubview:brandNameLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth/3)*2, PX_TO_PT(32), ScreenWidth/3-PX_TO_PT(32), PX_TO_PT(80))];
    numLabel.textColor = R_G_B_16(0xc7c7c7);
    numLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    numLabel.textAlignment = NSTextAlignmentRight;
    self.numLabel = numLabel;
    [orderView addSubview:numLabel];
    
    UILabel *orderPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(180), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
    orderPriceLabel.textAlignment = NSTextAlignmentRight;
    orderPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.orderPriceLabel = orderPriceLabel;
    [orderView addSubview:orderPriceLabel];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    topLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [orderView addSubview:topLineView];
    
    UIView *midLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(180), ScreenWidth, PX_TO_PT(1))];
    midLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [orderView addSubview:midLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(260), ScreenWidth, PX_TO_PT(1))];
    bottomLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [orderView addSubview:bottomLineView];
    
}

#pragma mark  - 数据源

-(void)setCellDataWithCustomerOrderModel:(XNRCustomerOrderModel *)model
{
    _model = model;
    NSLog(@"%@===%@===%@",model.name,model.price,model.count);
    //商品名
    CGSize maxSize = CGSizeMake(ScreenWidth-PX_TO_PT(120), MAXFLOAT);
    CGSize nameSize = [self.model.name sizeWithFont_BSExt:self.brandNameLabel.font maxSize:maxSize];
    self.brandNameLabel.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(32),nameSize.width, nameSize.height);
    self.brandNameLabel.text = model.name;
    // 数量
    self.numLabel.text = [NSString stringWithFormat:@"X %@",model.count];
    // 订单金额
    self.orderPriceLabel.text = [NSString stringWithFormat:@"订单金额：￥%@",model.price];
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:_orderPriceLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(36)]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(5,AttributedStringDeposit.length-5)];
    
    [_orderPriceLabel setAttributedText:AttributedStringDeposit];


}

@end
