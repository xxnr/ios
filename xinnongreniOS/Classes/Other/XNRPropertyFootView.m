//
//  XNRPropertyFootView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/2/23.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRPropertyFootView.h"
#import "XNRToolBar.h"

#define kLeftBtn 1000
#define kRightBtn 1001
@interface XNRPropertyFootView()<UITextFieldDelegate>

@property (nonatomic ,weak) XNRToolBar *toolBar;

@property (nonatomic ,weak) UIButton *leftBtn;

@property (nonatomic ,weak) UIButton *rightBtn;

@property (nonatomic ,weak) UITextField *numTextField;

@end

@implementation XNRPropertyFootView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor redColor];
        [self createView];
        // 注册消息通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_numTextField];
    }
    return self;
}


-(void)textFieldChanged:(NSNotification*)noti {
    
    if([self.numTextField.text isEqualToString:@"0"]){
        self.numTextField.text = @"1";
    }else{
        
    }
    if (self.numTextField.text.length>4) {
        self.numTextField.text = [self.numTextField.text substringToIndex:4];
    }
    if ([self.numTextField.text isEqualToString:@"9999"]) {
        self.rightBtn.enabled = NO;
    }else{
        self.rightBtn.enabled = YES;
    }
    

    if (self.com) {
        self.com (self.numTextField.text);
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([self.numTextField.text isEqualToString:@"0"] || [self.numTextField.text isEqualToString:@""]) {
        
        self.numTextField.text = @"1";
    }
    if (self.com) {
        self.com (self.numTextField.text);
    }

    
}

-(void)createView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(100))];
    bgView.backgroundColor=R_G_B_16(0xfafafa);
    [self addSubview:bgView];
    
    UILabel *numberLabel = [MyControl createLabelWithFrame:CGRectMake(0, PX_TO_PT(26), PX_TO_PT(80), PX_TO_PT(48)) Font:16 Text:@"数量"];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.textColor = R_G_B_16(0x646464);
    [bgView addSubview:numberLabel];
    
    UIButton *leftBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame) + PX_TO_PT(20), PX_TO_PT(26), PX_TO_PT(48),PX_TO_PT(48)) ImageName:nil Target:self Action:@selector(btnClick:) Title:nil];
    [leftBtn setImage:[UIImage imageNamed:@"icon_minus"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"icon_minus_selected2"] forState:UIControlStateSelected];
    [leftBtn setImage:[UIImage imageNamed:@"icon_minus_selected2"] forState:UIControlStateHighlighted];
    [leftBtn setHighlighted:NO];
    leftBtn.tag = kLeftBtn;
    self.leftBtn = leftBtn;
    [bgView addSubview:leftBtn];
    
    UITextField *numTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame),PX_TO_PT(26),PX_TO_PT(78),PX_TO_PT(48))];
    numTextField.textAlignment = NSTextAlignmentCenter;
    numTextField.borderStyle = UITextBorderStyleNone;
    numTextField.textColor = R_G_B_16(0x323232);
    
    numTextField.text = @"1";
    if (self.com) {
        self.com (numTextField.text);
        
    }

    numTextField.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    numTextField.delegate = self;
    numTextField.returnKeyType = UIReturnKeyDone;
        //设置键盘类型
    numTextField.keyboardType=UIKeyboardTypeNumberPad;
    numTextField.backgroundColor = [UIColor whiteColor];
//    numTextField.backgroundColor = [UIColor redColor];
    self.numTextField = numTextField;
    [bgView addSubview:numTextField];
    
    
    UIButton *rightBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.numTextField.frame), PX_TO_PT(26), PX_TO_PT(48),PX_TO_PT(48)) ImageName:nil Target:self Action:@selector(btnClick:) Title:nil];
    
    
    [rightBtn setImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"icon_plus_selected"] forState:UIControlStateSelected];
    [rightBtn setImage:[UIImage imageNamed:@"icon_plus_selected"] forState:UIControlStateHighlighted];
    [rightBtn setHighlighted:NO];
    rightBtn.tag = kRightBtn;
    self.rightBtn = rightBtn;
    [bgView addSubview:rightBtn];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame), PX_TO_PT(27), PX_TO_PT(79), PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [bgView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame), PX_TO_PT(72), PX_TO_PT(79), PX_TO_PT(1))];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [bgView addSubview:bottomLine];
    
}

#pragma 加减数量
-(void)btnClick:(UIButton*)button{
    if(button.tag == kLeftBtn){
        
        if([self.numTextField.text integerValue]>1){
            self.numTextField.text = [NSString stringWithFormat:@"%ld",(long)[self.numTextField.text floatValue]-1];
            
        }else{
            
            self.numTextField.text=@"1";
        }
        
        if([self.numTextField.text isEqualToString:@"1"]){
            
//            self.addBuyCarBtn.enabled=YES;
            
        }
        if (self.com) {
        self.com (self.numTextField.text);

        }

    }else if(button.tag == kRightBtn){
        
        if (self.numTextField.text.length >10) {
            return;
        }
        self.numTextField.text=[NSString stringWithFormat:@"%ld",(long)[self.numTextField.text floatValue]+1];
    }
    if (self.com) {
    self.com (self.numTextField.text);

    }
    
    if ([self.numTextField.text isEqualToString:@"9999"]) {
        self.rightBtn.enabled = NO;
    }else{
        self.rightBtn.enabled = YES;
    }


}


@end
