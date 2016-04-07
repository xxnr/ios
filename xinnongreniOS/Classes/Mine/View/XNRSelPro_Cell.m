//
//  XNRSelPro_Cell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSelPro_Cell.h"
#import "XNRBtn.h"
@interface XNRSelPro_Cell()
@property (nonatomic,weak)UIImageView *icon;
@property (nonatomic,weak)UILabel *proName;
@end
@implementation XNRSelPro_Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatCell];
    }
    return self;
}
//-(void)setAccessoryView:(UIView *)accessoryView
//{
//    accessoryView.frame = CGRectMake(0, 0, PX_TO_PT(40), PX_TO_PT(40));
//    UIButton *icon = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(24), PX_TO_PT(40), PX_TO_PT(40))];
//    [icon setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
//    [icon setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
//    [accessoryView addSubview:icon];
//    [self.contentView addSubview:accessoryView];
//}
-(void)creatCell
{
//    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(24), PX_TO_PT(40), PX_TO_PT(40))];
//    icon.image = [UIImage imageNamed:@"address_circle"];
//    self.icon = icon;
//    [self.contentView addSubview:icon];

    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(102), PX_TO_PT(24), ScreenWidth, PX_TO_PT(40))];
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.proName = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xc7c7c7);
    [self.contentView addSubview:line];
    
}
-(void)setName:(NSString *)name
{
    self.proName.text = name;
}
@end
