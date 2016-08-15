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
@property (nonatomic,weak) UIImageView *iconImage;
@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UILabel *phoneNumLabel;
@property(nonatomic,weak)UIView *myRepView;
@property (nonatomic,weak)UIView *line;
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
    [_iconImage removeFromSuperview];
    [_nickNameLabel removeFromSuperview];
    [_phoneNumLabel removeFromSuperview];
    [_redImageView removeFromSuperview];
    [_line removeFromSuperview];
    
    CGFloat myRepLabelH = PX_TO_PT(99);
    UIView *myRepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, myRepLabelH)];
    self.myRepView = myRepView;
    myRepView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:myRepView];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(29), PX_TO_PT(43), PX_TO_PT(43))];
    iconImage.image = model.sex?[UIImage imageNamed:@"girl1-ico-0"]:[UIImage imageNamed:@"boy1-ico"];
    self.iconImage = iconImage;
    [_myRepView addSubview:iconImage];
    
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+PX_TO_PT(28),PX_TO_PT(30) , PX_TO_PT(300), PX_TO_PT(40))];
    nickNameLabel.textColor = R_G_B_16(0x323232);
    nickNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.nickNameLabel = nickNameLabel;
    [_myRepView addSubview:nickNameLabel];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(480), PX_TO_PT(40), PX_TO_PT(230), PX_TO_PT(26))];
    phoneNumLabel.textColor = R_G_B_16(0x323232);
    phoneNumLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.phoneNumLabel = phoneNumLabel;
    [_myRepView addSubview:phoneNumLabel];
    
    // 小红点
    UIImageView *redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)-PX_TO_PT(10), PX_TO_PT(19), PX_TO_PT(20), PX_TO_PT(20))];
    redImageView.backgroundColor = [UIColor redColor];
    redImageView.layer.cornerRadius = PX_TO_PT(10);
    redImageView.layer.masksToBounds = YES;
    self.redImageView = redImageView;
    [_myRepView addSubview:redImageView];
    
//    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
//    topLineView.backgroundColor = R_G_B_16(0xe0e0e0);
//    [myRepView addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, PX_TO_PT(1))];
    bottomLineView.backgroundColor = R_G_B_16(0xe0e0e0);
    self.line = bottomLineView;
    [myRepView addSubview:bottomLineView];
    

    
    if (model.name && model.name.length>0) {
        self.nickNameLabel.text = model.name;

    }else{
        self.nickNameLabel.text = @"好友未填姓名";
    }
    
    if (model.newOrdersNumber == 0) {
        self.redImageView.hidden = YES;
    }else{
        self.redImageView.hidden = NO;
    }

    self.phoneNumLabel.text = model.account;

}



//- (void)drawRect:(CGRect)rect {
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    //    //上分割线，
//    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor);
//    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
//    //
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, R_G_B_16(0xe0e0e0).CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, 1, rect.size.width, PX_TO_PT(1)));
//
//}

@end
