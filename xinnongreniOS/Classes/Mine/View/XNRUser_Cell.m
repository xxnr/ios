//
//  XNRUser_Cell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/31.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRUser_Cell.h"
@interface XNRUser_Cell()
@property (nonatomic,weak)UILabel *nameLabel;
@property (nonatomic,weak)UIImageView *icon;
@property (nonatomic,weak)UILabel *registerLabel;
@end
@implementation XNRUser_Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatContent];
    }
    return self;
}
-(void)creatContent
{
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(25), PX_TO_PT(140), PX_TO_PT(30))];
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    nameLabel.textColor = R_G_B_16(0x646464);
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + PX_TO_PT(9), PX_TO_PT(25), PX_TO_PT(31), PX_TO_PT(31))];
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(32)-PX_TO_PT(111), PX_TO_PT(25), PX_TO_PT(111), PX_TO_PT(42))];
    registerLabel.text = @"已注册";
    registerLabel.textAlignment = NSTextAlignmentCenter;
    registerLabel.textColor = R_G_B_16(0x00B38A);
    registerLabel.backgroundColor = [UIColor whiteColor];
    registerLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    registerLabel.layer.cornerRadius = 10;
    registerLabel.layer.masksToBounds = YES;
    registerLabel.hidden = YES;
    self.registerLabel = registerLabel;
    [self.contentView addSubview:registerLabel];
    
<<<<<<< HEAD
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(76), ScreenWidth, 1)];
    line.backgroundColor = R_G_B_16(0xf0f0f0);
=======
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(76), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xc7c7c7);
>>>>>>> ynn_ios
    [self.contentView addSubview:line];
}
-(void)setModel:(XNRBookUser *)model
{
    self.registerLabel.hidden = YES;
    self.nameLabel.text = model.name;
    if ([model.sex integerValue] == 0) {
        [self.icon setImage:[UIImage imageNamed:@"boy1-ico"]];
    }
    else
    {
        [self.icon setImage:[UIImage imageNamed:@"girl1-ico"]];
    }
    if ([model.isRegistered integerValue]== 1) {
        self.registerLabel.hidden = NO;
    }
    
}
@end
