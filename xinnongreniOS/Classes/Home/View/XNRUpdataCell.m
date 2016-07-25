//
//  XNRUpdataCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/7/25.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRUpdataCell.h"

@interface XNRUpdataCell()

@property (nonatomic, weak) UILabel *messageLabel;

@end

@implementation XNRUpdataCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellID";
    XNRUpdataCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XNRUpdataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(void)createUI
{
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PX_TO_PT(530), PX_TO_PT(500))];
    messageLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    messageLabel.textColor = R_G_B_16(0x323232);
    messageLabel.numberOfLines = 0;
    self.messageLabel = messageLabel;
    [self.contentView addSubview:messageLabel];

}

-(void)upDataWithData:(NSMutableArray *)messageArray{
    
    self.messageLabel.text = [messageArray firstObject];
    CGSize messageSize = [self.messageLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(24)]}];
    self.messageLabel.frame = CGRectMake(0, 0, PX_TO_PT(530), messageSize.height);
}



@end
