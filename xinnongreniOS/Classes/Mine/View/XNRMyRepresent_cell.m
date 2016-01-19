//
//  XNRMyRepresent_cell.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/15.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyRepresent_cell.h"

@interface XNRMyRepresent_cell ()
@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UILabel *phoneNumLabel;
@property (nonatomic ,weak) UIImageView *redImageView;
@end


@implementation XNRMyRepresent_cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;


}

-(void)createUI{
    CGFloat myRepLabelH = PX_TO_PT(96);
    UIView *myRepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, myRepLabelH)];
    myRepView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:myRepView];
    
    CGFloat nickNameLabelY = (myRepLabelH - PX_TO_PT(60))*0.5;
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32),nickNameLabelY , PX_TO_PT(200), PX_TO_PT(60))];
    nickNameLabel.backgroundColor = R_G_B_16(0x00b38a);
    nickNameLabel.layer.cornerRadius = 5.0;
    nickNameLabel.layer.masksToBounds = YES;
    nickNameLabel.textColor = R_G_B_16(0xffffff);
    nickNameLabel.font = [UIFont systemFontOfSize:16];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel = nickNameLabel;
    [myRepView addSubview:nickNameLabel];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, nickNameLabelY, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(60))];
    phoneNumLabel.textAlignment = NSTextAlignmentRight;
    phoneNumLabel.textColor = R_G_B_16(0x00b38a);
    phoneNumLabel.font = [UIFont systemFontOfSize:18];
    self.phoneNumLabel = phoneNumLabel;
    [myRepView addSubview:phoneNumLabel];
    
    // 小红点
    UIImageView *redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(188), PX_TO_PT(2), PX_TO_PT(10), PX_TO_PT(10))];
    redImageView.backgroundColor = [UIColor redColor];
    redImageView.layer.cornerRadius = PX_TO_PT(5);
    redImageView.layer.masksToBounds = YES;
    self.redImageView = redImageView;
    [nickNameLabel addSubview:redImageView];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    topLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [myRepView addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(96), ScreenWidth, PX_TO_PT(1))];
    bottomLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [myRepView addSubview:bottomLineView];


}

- (void)setModel:(XNRMyRepresentModel *)model {
    _model = model;
    if (model.name && model.name.length>0) {
        self.nickNameLabel.text = model.name;
    }else{
        self.nickNameLabel.text = @"该好友未填姓名";
        self.nickNameLabel.backgroundColor = R_G_B_16(0xf0f0f0);
        self.nickNameLabel.textColor = R_G_B_16(0xa2a2a2);

    }
    if (model.newOrdersNumber == 0) {
        self.redImageView.hidden = YES;
    }else{
        self.redImageView.hidden = NO;
    }

    self.phoneNumLabel.text = model.account;

}
@end
