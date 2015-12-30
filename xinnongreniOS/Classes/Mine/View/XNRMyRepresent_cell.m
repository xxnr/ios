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
    CGFloat myRepLabelH = 60;
    UIView *myRepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, myRepLabelH)];
    myRepView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:myRepView];
    
    CGFloat nickNameLabelY = (myRepLabelH - 20)*0.5;
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,nickNameLabelY , ScreenWidth/2, 20)];
    nickNameLabel.textColor = R_G_B_16(0x646464);
    nickNameLabel.font = [UIFont systemFontOfSize:18];
    self.nickNameLabel = nickNameLabel;
    [myRepView addSubview:nickNameLabel];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+10, nickNameLabelY, ScreenWidth/2, 20)];
//    phoneNumLabel.text = self.model.account;
    phoneNumLabel.textColor = R_G_B_16(0x20b2aa);
    phoneNumLabel.font = [UIFont systemFontOfSize:18];
    self.phoneNumLabel = phoneNumLabel;
    [myRepView addSubview:phoneNumLabel];


}

- (void)setModel:(XNRMyRepresentModel *)model {
    _model = model;
    if (model.nickname && model.nickname.length>0) {
        self.nickNameLabel.text = model.nickname;
    }else{
        self.nickNameLabel.text = @"好友未设置昵称";

    }

    self.phoneNumLabel.text = model.account;

}
@end
