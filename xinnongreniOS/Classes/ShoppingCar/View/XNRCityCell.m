//
//  XNRCityCell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/20.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCityCell.h"
@interface XNRCityCell()
@property (nonatomic,weak)UIView *line;
@end
@implementation XNRCityCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)setName:(NSString *)name
{
    [self.nameLabel removeFromSuperview];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(25), ScreenWidth, PX_TO_PT(36))];
    nameLabel.textColor = R_G_B_16(0x323232);
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    nameLabel.text = name;
    self.nameLabel = nameLabel;
    [self.contentView addSubview:_nameLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xc7c7c7);
    self.line = line;
    [self.contentView addSubview:_line];
}

@end
