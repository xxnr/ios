//
//  XNRSelWebSiteCell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSelWebSiteCell.h"
#import "XNRBtn.h"
#import "XNRCompanyAddressModel.h"
@interface XNRSelWebSiteCell()
@property (nonatomic,weak)UILabel *nameLabel;
@property (nonatomic,weak)UILabel *phoneLabel;
@property (nonatomic,weak)UILabel *addressLabel;
@property (nonatomic,weak)UIView *line;
@end
@implementation XNRSelWebSiteCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self creatCell];
    }
    return self;
}
-(void)creatCell
{
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(86), PX_TO_PT(24), PX_TO_PT(603), PX_TO_PT(35))];
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    nameLabel.tintColor = R_G_B_16(0x323232);
    self.nameLabel = nameLabel;
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(86),CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(15), PX_TO_PT(603), PX_TO_PT(40))];
    addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    addressLabel.tintColor = R_G_B_16(0x646464);
    self.addressLabel = addressLabel;
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(86), CGRectGetMaxY(addressLabel.frame)+ PX_TO_PT(15), PX_TO_PT(603), PX_TO_PT(40))];
    phoneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    phoneLabel.tintColor = R_G_B_16(0x646464);
    self.phoneLabel = phoneLabel;

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneLabel.frame)+PX_TO_PT(15), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xc7c7c7);
    self.line = line;
    
}
-(void)setModel:(XNRRSCDetailModel *)model
{
    [_nameLabel removeFromSuperview];
    [_addressLabel removeFromSuperview];
    [_phoneLabel removeFromSuperview];
    [_line removeFromSuperview];
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(86), PX_TO_PT(24), PX_TO_PT(603), PX_TO_PT(35))];
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    nameLabel.tintColor = R_G_B_16(0x323232);
    self.nameLabel = nameLabel;
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(86),CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(15), PX_TO_PT(603), PX_TO_PT(40))];
    addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    addressLabel.tintColor = R_G_B_16(0x646464);
    self.addressLabel = addressLabel;
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(86), CGRectGetMaxY(addressLabel.frame)+ PX_TO_PT(15), PX_TO_PT(603), PX_TO_PT(40))];
    phoneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    phoneLabel.tintColor = R_G_B_16(0x646464);
    self.phoneLabel = phoneLabel;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneLabel.frame)+PX_TO_PT(15), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xc7c7c7);
    self.line = line;
    
    
    self.nameLabel.text = model.name;
    
    XNRCompanyAddressModel *addressModel = [XNRCompanyAddressModel objectWithKeyValues:model.companyAddress];
    
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"地址："];
    if (addressModel.province.count > 0) {
        [str appendString:addressModel.province[@"name"]];
    }
    if (addressModel.city.count > 0) {
        [str appendString:@" "];
        [str appendString:addressModel.city[@"name"]];
    }
    if (addressModel.county.count > 0) {
        [str appendString:@" "];
        [str appendString:addressModel.county[@"name"]];
    }
    if (addressModel.town.count > 0) {
        [str appendString:@" "];
        [str appendString:addressModel.town[@"name"]];
    }
    
    [str appendString:@" "];
    [str appendString:addressModel.details];
 
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(28)] constrainedToSize:CGSizeMake(PX_TO_PT(603), MAXFLOAT)];
    self.addressLabel.frame = CGRectMake(PX_TO_PT(86),CGRectGetMaxY(_nameLabel.frame) + PX_TO_PT(15), size.width, size.height);
    self.addressLabel.text = str;
    self.addressLabel.numberOfLines = 0;
    
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",model.phone];
    self.phoneLabel.frame = CGRectMake(PX_TO_PT(86), CGRectGetMaxY(_addressLabel.frame)+ PX_TO_PT(15), PX_TO_PT(603), PX_TO_PT(40));
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(_phoneLabel.frame)+PX_TO_PT(15), ScreenWidth, PX_TO_PT(1));
    
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_addressLabel];
    [self.contentView addSubview:_phoneLabel];
    [self.contentView addSubview:_line];
    
    self.height = CGRectGetMaxY(_line.frame);
}

@end