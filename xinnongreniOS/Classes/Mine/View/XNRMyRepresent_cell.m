//
//  XNRMyRepresent_cell.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/15.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyRepresent_cell.h"
#import "UIFont+BSExt.h"

@interface XNRMyRepresent_cell ()
@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UILabel *phoneNumLabel;
@property(nonatomic,weak)UIView *myRepView;
//@property (nonatomic ,weak) UIImageView *redImageView;
@end


@implementation XNRMyRepresent_cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self createUI];
        self.backgroundColor = [UIColor clearColor];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeRedPoint) name:@"removeRedPoint" object:nil];
    }
    return self;


}

- (void)setModel:(XNRMyRepresentModel *)model {
    _model = model;
 
    [_myRepView removeFromSuperview];
    [_nickNameLabel removeFromSuperview];
    [_phoneNumLabel removeFromSuperview];
    [_redImageView removeFromSuperview];
    
    CGFloat myRepLabelH = PX_TO_PT(96);
    UIView *myRepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, myRepLabelH)];
    self.myRepView = myRepView;
    myRepView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:myRepView];
    
    CGFloat nickNameLabelY = (myRepLabelH - PX_TO_PT(60))*0.5;
    //    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32),nickNameLabelY , PX_TO_PT(220), PX_TO_PT(60))];
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.backgroundColor = R_G_B_16(0x00b38a);
    nickNameLabel.layer.cornerRadius = 5.0;
    nickNameLabel.layer.masksToBounds = YES;
    nickNameLabel.adjustsFontSizeToFitWidth = YES;
    nickNameLabel.textColor = R_G_B_16(0xffffff);
    nickNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    [nickNameLabel fitTextWidth_Ext];
    self.nickNameLabel = nickNameLabel;
    [myRepView addSubview:nickNameLabel];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, nickNameLabelY, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(60))];
    phoneNumLabel.textAlignment = NSTextAlignmentRight;
    phoneNumLabel.textColor = R_G_B_16(0x00b38a);
    phoneNumLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [phoneNumLabel fitTextWidth_Ext];
    self.phoneNumLabel = phoneNumLabel;
    [myRepView addSubview:phoneNumLabel];
    
    // 小红点
    UIImageView *redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickNameLabel.frame)-PX_TO_PT(20), PX_TO_PT(2), PX_TO_PT(24), PX_TO_PT(24))];
    redImageView.backgroundColor = [UIColor redColor];
    redImageView.layer.cornerRadius = PX_TO_PT(12);
    redImageView.layer.masksToBounds = YES;
    self.redImageView = redImageView;
    [myRepView addSubview:redImageView];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    topLineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [myRepView addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(96), ScreenWidth, 1)];
    bottomLineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [myRepView addSubview:bottomLineView];
    

    
    if (model.name && model.name.length>0) {
        CGSize nickNameLabelSize = [model.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
        self.nickNameLabel.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(18), nickNameLabelSize.width+PX_TO_PT(24), PX_TO_PT(60));
        self.nickNameLabel.text = model.name;
        
    }else{
        self.nickNameLabel.text = @"该好友未填姓名";
        CGSize nickNameLabelSize = [self.nickNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
        self.nickNameLabel.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(18), nickNameLabelSize.width+PX_TO_PT(24), PX_TO_PT(60));
        self.nickNameLabel.backgroundColor = R_G_B_16(0xf0f0f0);
        self.nickNameLabel.textColor = R_G_B_16(0xa2a2a2);

    }
    if (model.newOrdersNumber == 0) {
        self.redImageView.hidden = YES;
    }else{
        self.redImageView.frame = CGRectMake(CGRectGetMaxX(self.nickNameLabel.frame)-PX_TO_PT(10), PX_TO_PT(8), PX_TO_PT(24), PX_TO_PT(24));
        self.redImageView.hidden = NO;
    }

    self.phoneNumLabel.text = model.account;

}
@end
