//
//  XNRMyRepresentView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/14.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyRepresentView.h"

@interface XNRMyRepresentView()

@property (nonatomic, weak) UILabel *noRepresentLabel;

@property (nonatomic, weak) UITextField *phoneText;

@property (nonatomic, weak) UIImageView *inputImage;

@property (nonatomic, weak) UILabel *addRepresentLabel;

@property (nonatomic, weak) UIButton *addRepresentBtn;

@property (nonatomic ,weak) UIImageView *iconImageView;

@end

@implementation XNRMyRepresentView

-(id)init {
    if (self = [super init]) {
        self.backgroundColor = R_G_B_16(0xfafafa);
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}

-(void)createUI {
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [iconImageView setImage:[UIImage imageNamed:@"mine_represent"]];
    self.iconImageView = iconImageView;
    [self addSubview:iconImageView];
    
    UILabel  *noRepresentLabel = [[UILabel alloc] init];
    noRepresentLabel.font = [UIFont systemFontOfSize:16];
    noRepresentLabel.text = @"您还没有设置新农代表";
    noRepresentLabel.textAlignment = NSTextAlignmentCenter;
    noRepresentLabel.textColor = R_G_B_16(0x646464);
    self.noRepresentLabel = noRepresentLabel;
    [self addSubview:noRepresentLabel];
    
    UITextField *phoneText = [[UITextField alloc] init];
    phoneText.placeholder = @"请输入对方手机号添加";
    phoneText.layer.borderWidth = 1.0;
    phoneText.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    phoneText.layer.cornerRadius = 5.0;
    phoneText.layer.masksToBounds = YES;
    phoneText.font = [UIFont systemFontOfSize:16];
    phoneText.textAlignment = NSTextAlignmentCenter;
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    phoneText.alpha = 1.0;
    self.phoneText = phoneText;
    [self addSubview:phoneText];
    
    UILabel *addRepresentLabel = [[UILabel alloc] init];
    addRepresentLabel.text = @"邀请人添加后不可修改";
    addRepresentLabel.textColor = R_G_B_16(0xc7c7c7);
    addRepresentLabel.font = [UIFont systemFontOfSize:14];
    addRepresentLabel.textAlignment = NSTextAlignmentCenter;
    self.addRepresentLabel = addRepresentLabel;
    [self addSubview:addRepresentLabel];
    
    UIButton *addRepresentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addRepresentBtn.frame = CGRectMake((ScreenWidth - 100)/2, CGRectGetMaxY(self.addRepresentLabel.frame), 100, 32);
    [addRepresentBtn setTitle:@"添加代表人"forState:UIControlStateNormal];
    [addRepresentBtn setTintColor:R_G_B_16(0xffffff)];
    addRepresentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addRepresentBtn setBackgroundColor:R_G_B_16(0x00b38a)];
    [addRepresentBtn addTarget:self action:@selector(addRepresent:) forControlEvents:UIControlEventTouchUpInside];
    addRepresentBtn.layer.cornerRadius = 5.0;
    addRepresentBtn.layer.masksToBounds = YES;
    self.addRepresentBtn = addRepresentBtn;
    [self addSubview:addRepresentBtn];
}

- (void)setViewF:(XNRMyRepresentViewFrame *)viewF {
    _viewF = viewF;
    self.iconImageView.frame = viewF.iconImageViewF;
    self.noRepresentLabel.frame = viewF.noRepresentLabelF;
    self.phoneText.frame = viewF.phoneTextF;
    
    self.inputImage.frame = viewF.inputImageF;
    
    self.addRepresentLabel.frame = viewF.addRepresentLabelF;
    self.addRepresentBtn.frame = viewF.addRepresentBtnF;
    
}



-(void)addRepresent:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(myRepresentViewWith:and:)]) {
        [self.delegate myRepresentViewWith:self and:self.phoneText.text];
    }
}


@end

@implementation XNRMyRepresentViewFrame
- (void)setModel:(XNRMyRepresentViewDataModel *)model {
    
    
    CGFloat labelW = ScreenWidth;
    
    CGFloat imageX = ScreenWidth/2-PX_TO_PT(70);
    CGFloat imageY = 0;
    CGFloat imageW = PX_TO_PT(140);
    CGFloat imageH = PX_TO_PT(140);
    _iconImageViewF = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat noX = 0;
    CGFloat noY = CGRectGetMaxY(_iconImageViewF) + PX_TO_PT(30);
    CGFloat noH = 20.0;
    _noRepresentLabelF = CGRectMake(noX, noY, labelW, noH);
    
    CGFloat pW = labelW * 0.618;
    CGFloat pX = (labelW - pW)*0.5;
    CGFloat pY = CGRectGetMaxY(_noRepresentLabelF) + PX_TO_PT(90);
    CGFloat pH = PX_TO_PT(80);
    _phoneTextF = CGRectMake(pX, pY, pW, pH);
    
    CGFloat addLX = 0;
    CGFloat addLY = CGRectGetMaxY(_phoneTextF)+PX_TO_PT(24);
    CGFloat addLW = labelW;
    CGFloat addLH = 20.0;
    _addRepresentLabelF = CGRectMake(addLX, addLY, addLW, addLH);
    
    CGFloat addBtnW = PX_TO_PT(180);
    CGFloat addBtnY = CGRectGetMaxY(_addRepresentLabelF)+PX_TO_PT(38);
    CGFloat addBtnX = (labelW - addBtnW)*0.5;
    CGFloat addBtnH = PX_TO_PT(60);
    _addRepresentBtnF = CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH);
    
    _viewH = CGRectGetMaxY(_addRepresentBtnF);
}

@end



@implementation XNRMyRepresentViewDataModel


@end