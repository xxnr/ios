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


@end

@implementation XNRMyRepresentView

-(id)init {
    if (self = [super init]) {
        self.backgroundColor = R_G_B_16(0xf0f0f0);
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}

-(void)createUI {
    UILabel  *noRepresentLabel = [[UILabel alloc] init];
    noRepresentLabel.font = [UIFont systemFontOfSize:18];
    noRepresentLabel.text = @"您还没有设置新农代表";
    noRepresentLabel.textAlignment = NSTextAlignmentCenter;
    noRepresentLabel.textColor = R_G_B_16(0x323232);
    self.noRepresentLabel = noRepresentLabel;
    [self addSubview:noRepresentLabel];
    
    UITextField *phoneText = [[UITextField alloc] init];
    phoneText.placeholder = @"请输入对方手机号添加";
    phoneText.textAlignment = NSTextAlignmentCenter;
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    phoneText.alpha = 1.0;
    self.phoneText = phoneText;
    [self addSubview:phoneText];
    
    UIImageView *inputImage = [[UIImageView alloc] init];
    inputImage.image = [UIImage imageNamed:@"输入"];
    self.inputImage = inputImage;
    [self addSubview:inputImage];
    
    UILabel *addRepresentLabel = [[UILabel alloc] init];
    addRepresentLabel.text = @"邀请人添加后不可修改";
    addRepresentLabel.textColor = R_G_B_16(0x323232);
    addRepresentLabel.font = [UIFont systemFontOfSize:14];
    addRepresentLabel.textAlignment = NSTextAlignmentCenter;
    self.addRepresentLabel = addRepresentLabel;
    [self addSubview:addRepresentLabel];
    
    UIButton *addRepresentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addRepresentBtn.frame = CGRectMake((ScreenWidth - 100)/2, CGRectGetMaxY(self.addRepresentLabel.frame), 100, 32);
    [addRepresentBtn setTitle:@"添加代表人"forState:UIControlStateNormal];
    [addRepresentBtn setTintColor:R_G_B_16(0xffffff)];
    [addRepresentBtn setBackgroundColor:R_G_B_16(0x26ca22)];
    [addRepresentBtn addTarget:self action:@selector(addRepresent:) forControlEvents:UIControlEventTouchUpInside];
    addRepresentBtn.layer.cornerRadius = 5.0;
    addRepresentBtn.layer.masksToBounds = YES;
    self.addRepresentBtn = addRepresentBtn;
    [self addSubview:addRepresentBtn];
}

- (void)setViewF:(XNRMyRepresentViewFrame *)viewF {
    _viewF = viewF;
    
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
    CGFloat margin = 20;
    
    CGFloat noX = 0;
    CGFloat noY = margin;
    CGFloat noH = 20.0;
    _noRepresentLabelF = CGRectMake(noX, noY, labelW, noH);
    
    CGFloat pW = labelW * 0.618;
    CGFloat pX = (labelW - pW)*0.5;
    CGFloat pY = CGRectGetMaxY(_noRepresentLabelF) + margin * 1.5;
    CGFloat pH = 20.0;
    _phoneTextF = CGRectMake(pX, pY, pW, pH);
    
    CGFloat imgX = pX-10;
    CGFloat imgY = CGRectGetMaxY(_phoneTextF);
    CGFloat imgW = pW+20;
    CGFloat imgH = 8.0;
    _inputImageF = CGRectMake(imgX, imgY, imgW, imgH);
    
    CGFloat addLX = 0;
    CGFloat addLY = CGRectGetMaxY(_inputImageF)+margin;
    CGFloat addLW = labelW;
    CGFloat addLH = 20.0;
    _addRepresentLabelF = CGRectMake(addLX, addLY, addLW, addLH);
    
    CGFloat addBtnW = 100;
    CGFloat addBtnY = CGRectGetMaxY(_addRepresentLabelF)+2*margin;
    CGFloat addBtnX = (labelW - addBtnW)*0.5;
    CGFloat addBtnH = addBtnW * 0.25;
    _addRepresentBtnF = CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH);
    
    _viewH = CGRectGetMaxY(_addRepresentBtnF);
}

@end



@implementation XNRMyRepresentViewDataModel


@end