//
//  XNRDeliveryCell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRDeliveryCell.h"
#import "XNRMyOrderModel.h"
//#import "XNRCarryVC.h"
@interface XNRDeliveryCell()
@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,weak)UILabel *detailLabel;

@property (nonatomic,weak)UILabel *numLabel;
@property (nonatomic,weak)UIView *line;
@end
@implementation XNRDeliveryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self createCell];
    }
    return self;
}
-(void)createCell
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(23), PX_TO_PT(502), PX_TO_PT(32))];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.titleLabel = titleLabel;
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.textColor = R_G_B_16(0x909090);
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.detailLabel = detailLabel;
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+PX_TO_PT(22), PX_TO_PT(23), ScreenWidth - CGRectGetMaxX(titleLabel.frame)-PX_TO_PT(22)-PX_TO_PT(23), PX_TO_PT(32))];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    self.numLabel = numLabel;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = R_G_B_16(0xE0E0E0);
    self.line = line;

}
-(void)setModel:(XNRMyOrderModel *)model
{
    [self.titleLabel removeFromSuperview];
    [self.detailLabel removeFromSuperview];
    [self.numLabel removeFromSuperview];
    [self.line removeFromSuperview];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(23), PX_TO_PT(502), PX_TO_PT(32))];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.titleLabel = titleLabel;
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.titleLabel.frame)+PX_TO_PT(16), PX_TO_PT(653), PX_TO_PT(32))];
    detailLabel.textColor = R_G_B_16(0x909090);
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel = detailLabel;
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+PX_TO_PT(22), PX_TO_PT(23), ScreenWidth - CGRectGetMaxX(titleLabel.frame)-PX_TO_PT(22)-PX_TO_PT(23), PX_TO_PT(32))];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    self.numLabel = numLabel;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = R_G_B_16(0xE0E0E0);
    self.line = line;

    self.titleLabel.text = model.productName;
    [self.contentView addSubview:self.titleLabel];
    
    NSMutableString *str = [[NSMutableString alloc]init];
    for (NSDictionary *dic in model.attributes) {
        [str appendString:[NSString stringWithFormat:@"%@:%@;",dic[@"name"],dic[@"value"]]];
    }
    if (model.additions.count > 0) {
        [str appendString:@"\n"];
        [str appendString:@"附加项目："];
        
    }

    //    self.detailLabel.text = str;

    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(28)] constrainedToSize:CGSizeMake(PX_TO_PT(653), MAXFLOAT)];
    
    self.detailLabel.frame = CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.titleLabel.frame)+PX_TO_PT(16), PX_TO_PT(653), size.height);
    self.detailLabel.numberOfLines = 0;
    
    for (NSDictionary *dic in model.additions) {
        [str appendString:[NSString stringWithFormat:@"%@;",dic[@"name"]]];
    }
    self.detailLabel.text = str;

    [self.contentView addSubview:self.detailLabel];
    
    
    
    self.numLabel.text = [NSString stringWithFormat:@"x%@",model.count];
    [self.contentView addSubview:self.numLabel];
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.detailLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(2));
    [self.contentView addSubview:self.line];
    
    self.height = CGRectGetMaxY(self.line.frame);
}
@end