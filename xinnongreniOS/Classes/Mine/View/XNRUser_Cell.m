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
@property (nonatomic,weak)UIImageView *registerImage;
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
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(29), PX_TO_PT(43), PX_TO_PT(43))];
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+PX_TO_PT(27), PX_TO_PT(36), PX_TO_PT(250), PX_TO_PT(35))];
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    nameLabel.textColor = R_G_B_16(0x323232);
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];

    UIImageView *registerImage = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(495), PX_TO_PT(31), PX_TO_PT(37), PX_TO_PT(37))];
    [registerImage setImage:[UIImage imageNamed:@"registered_icon-0"]];
    self.registerImage = registerImage;
    self.registerImage.hidden = YES;
    [self.contentView addSubview:registerImage];
    
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(registerImage.frame)+PX_TO_PT(13), PX_TO_PT(35), PX_TO_PT(100), PX_TO_PT(30))];
    registerLabel.text = @"已注册 ";
    registerLabel.textColor = R_G_B_16(0xD5D5D5);
    registerLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    registerLabel.hidden = YES;
    self.registerLabel = registerLabel;
    [self.contentView addSubview:registerLabel];
    
<<<<<<< HEAD
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(76), ScreenWidth, PX_TO_PT(1))];
=======
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, PX_TO_PT(1))];
>>>>>>> ynn_ios
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [self.contentView addSubview:line];
}
-(void)setModel:(XNRBookUser *)model
{
    self.registerLabel.hidden = YES;
    self.registerImage.hidden = YES;
    
    self.nameLabel.text = model.name;
    if ([model.sex integerValue] == 0) {
        [self.icon setImage:[UIImage imageNamed:@"boy1-icon"]];
    }
    else
    {
        [self.icon setImage:[UIImage imageNamed:@"girl1-ico"]];
    }
    if ([model.isRegistered integerValue] == 1) {
        self.registerImage.hidden = NO;
        self.registerLabel.hidden = NO;
    }
    
}
@end
