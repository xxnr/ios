//
//  XNRMySetterCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRMySetterCell.h"
#import "XNRMainItem.h"
#import "XNRMainArrowItem.h"
@interface XNRMySetterCell()
/**
 *  箭头
 */
@property (strong, nonatomic) UIImageView *rightArrow;

@end


@implementation XNRMySetterCell

#pragma mark - 懒加载右边的view
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-1"]];
    }
    return _rightArrow;
}


#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    XNRMySetterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XNRMySetterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        self.textLabel.textColor = R_G_B_16(0x323232);
        self.detailTextLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        self.detailTextLabel.textColor = R_G_B_16(0x323232);
        
//        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
//        lineView1.backgroundColor = R_G_B_16(0xc7c7c7);
//        [self.contentView addSubview:lineView1];

        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(86), ScreenWidth, PX_TO_PT(1))];
        lineView2.backgroundColor = R_G_B_16(0xc7c7c7);
        [self.contentView addSubview:lineView2];
        

        
        
    }
    return self;
}

-(void)setItem:(XNRMainItem *)item
{
    _item = item;
    // 1.设置基本数据
    self.imageView.image = [UIImage imageNamed:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    
    if ([item isKindOfClass:[XNRMainArrowItem class]]) {
        self.accessoryView = self.rightArrow;
    }
}


@end
