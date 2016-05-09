//
//  XNRRscSectionHeadView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/23.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscSectionHeadView.h"

@interface XNRRscSectionHeadView()

@property (nonatomic, weak) UILabel *dataLabel;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *orderStateLabel;

@property (nonatomic, strong) XNRRscOrderModel *model;

@end

@implementation XNRRscSectionHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self crateView];
    }
    return self;
}

-(void)crateView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
    headView.backgroundColor = R_G_B_16(0xffffff);
    [self addSubview:headView];
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth/2-PX_TO_PT(100), PX_TO_PT(88))];
    dataLabel.textColor = R_G_B_16(0x323232);
    dataLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.dataLabel = dataLabel;
    [headView addSubview:dataLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dataLabel.frame), 0, PX_TO_PT(200), PX_TO_PT(88))];
    nameLabel.textColor = R_G_B_16(0x323232);
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel = nameLabel;
    [headView addSubview:nameLabel];
    
    UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(30), PX_TO_PT(88))];
    orderStateLabel.textColor = R_G_B_16(0xfe9b00);
    orderStateLabel.textAlignment = NSTextAlignmentRight;
    orderStateLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.orderStateLabel = orderStateLabel;
    [headView addSubview:orderStateLabel];
    
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(88)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView];
    }

}

-(void)upDataHeadViewWithModel:(XNRRscOrderModel *)model
{
    _model = model;
    self.dataLabel.text = _model.dateCreated;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *dateFormatted = [dateFormatter dateFromString:model.dateCreated];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *locationTimeString=[dateFormatter stringFromDate:dateFormatted];
    self.dataLabel.text = locationTimeString;
    self.nameLabel.text = _model.consigneeName;
    self.orderStateLabel.text = _model.value;
    
}

@end
