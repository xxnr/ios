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
@property (nonatomic,weak)UIView *line;

@end
@implementation XNRSelPro_Cell

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
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(24), ScreenWidth, PX_TO_PT(40))];
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    
    self.proName = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(87), ScreenWidth-PX_TO_PT(32), 1)];
    self.line = line;
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [self.contentView addSubview:line];
}


-(void)setName:(NSString *)name
{
    [self.proName removeFromSuperview];
    [self.line removeFromSuperview];
    [self creatCell];
    self.proName.text = name;
}
@end
