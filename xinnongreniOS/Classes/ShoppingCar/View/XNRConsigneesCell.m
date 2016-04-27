//
//  XNRConsigneesCell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/20.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRConsigneesCell.h"
@interface XNRConsigneesCell()
@property (nonatomic,weak)UILabel *nameLabel;
@property (nonatomic,weak)UILabel *phoneLabel;
@property (nonatomic,weak)UIView *line;
@end
@implementation XNRConsigneesCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
-(void)setModel:(XNRConsigneeModel *)model
{
    [self.nameLabel removeFromSuperview];
    [self.phoneLabel removeFromSuperview];
    [self.line removeFromSuperview];
    
    CGSize size = [model.consigneeName sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(32)] constrainedToSize:CGSizeMake(ScreenWidth, PX_TO_PT(34))];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(100), PX_TO_PT(36), size.width, PX_TO_PT(34))];
    nameLabel.text = model.consigneeName;
    nameLabel.textColor = R_G_B_16(0x646464);
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:_nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+PX_TO_PT(20), PX_TO_PT(36), ScreenWidth, PX_TO_PT(34))];
    phoneLabel.text = model.consigneePhone;
    phoneLabel.textColor = R_G_B_16(0x646464);
    phoneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.phoneLabel = phoneLabel;
    [self.contentView addSubview:_phoneLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(97), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xc7c7c7);
    self.line = line;
    [self.contentView addSubview:_line];
}
@end
