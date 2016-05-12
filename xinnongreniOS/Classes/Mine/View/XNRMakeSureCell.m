//
//  XNRMakeSureCell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRMakeSureCell.h"
@interface XNRMakeSureCell()
@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,weak)UILabel *detailLabel;
@property (nonatomic,weak)UILabel *numLabel;
@property (nonatomic,weak)UIView *line;
@end
@implementation XNRMakeSureCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)createCell
{

}
-(void)setModel:(XNRMyOrderModel *)model
{
    [self.titleLabel removeFromSuperview];
    [self.detailLabel removeFromSuperview];
    [self.numLabel removeFromSuperview];
    [self.line removeFromSuperview];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(96), PX_TO_PT(23), PX_TO_PT(502), PX_TO_PT(32))];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.titleLabel = titleLabel;
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(96), CGRectGetMaxY(self.titleLabel.frame)+PX_TO_PT(16), PX_TO_PT(597), PX_TO_PT(100))];
    detailLabel.textColor = R_G_B_16(0x909090);
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    detailLabel.numberOfLines = 0;
    self.detailLabel = detailLabel;
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+PX_TO_PT(22), PX_TO_PT(23), ScreenWidth - CGRectGetMaxX(titleLabel.frame)-PX_TO_PT(22)-PX_TO_PT(32), PX_TO_PT(32))];
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
        [str appendString:@"\n附加项目："];

    }
    
    for (NSDictionary *dic in model.additions) {
        [str appendString:[NSString stringWithFormat:@"%@;",dic[@"name"]]];
    }
    self.detailLabel.text = str;

    CGSize size = [self.detailLabel.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(28)] constrainedToSize:CGSizeMake(PX_TO_PT(597), MAXFLOAT)];
    
    self.detailLabel.frame = CGRectMake(PX_TO_PT(96), CGRectGetMaxY(self.titleLabel.frame)+PX_TO_PT(16), PX_TO_PT(597), size.height);
    
    [self.contentView addSubview:self.detailLabel];

    
    self.numLabel.text = [NSString stringWithFormat:@"x%@",model.count];
    [self.contentView addSubview:self.numLabel];
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.detailLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(2));
    [self.contentView addSubview:self.line];
    
    self.height = CGRectGetMaxY(self.line.frame);
}
@end