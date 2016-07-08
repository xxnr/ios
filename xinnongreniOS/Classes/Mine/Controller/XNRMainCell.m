//
//  XNRMainCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRMainCell.h"
#import "XNRMainItem.h"

@interface XNRMainCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel  *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;


@end

@implementation XNRMainCell

-(UIView *)bgView
{
    if (_bgView == nil) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        // 图标
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(14), PX_TO_PT(60), PX_TO_PT(60))];
        [self.bgView addSubview:_imgView];
        
    }
    return _imgView;
}


- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        // 主题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(112), PX_TO_PT(14), ScreenWidth-PX_TO_PT(112), PX_TO_PT(60))];
        self.titleLabel.textColor = R_G_B_16(0x323232);
        self.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        [self.bgView addSubview:_titleLabel];

    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        // 主题
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(14), ScreenWidth/2-PX_TO_PT(30), PX_TO_PT(60))];
        self.detailLabel.textColor = R_G_B_16(0x00b38a);
        self.detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:_detailLabel];
        
    }
    return _detailLabel;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    XNRMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XNRMainCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.detailTextLabel.textColor = R_G_B_16(0x00b38a);
        self.detailTextLabel.font = [UIFont systemFontOfSize:PX_TO_PT(26)];

        
        
        UIView *lineLayer = [[UIView alloc] init];
        lineLayer.frame = CGRectMake(0, PX_TO_PT(88), ScreenWidth, 1);
        lineLayer.backgroundColor = R_G_B_16(0xc7c7c7);
        [self addSubview:lineLayer];

        
    }
    return self;
}

-(void)setItem:(XNRMainItem *)item
{
    _item = item;
    // 1.设置基本数据
    self.imgView.image = [UIImage imageNamed:item.icon];
    self.titleLabel.text = item.title;
    self.detailLabel.text = item.subtitle;


}

@end
