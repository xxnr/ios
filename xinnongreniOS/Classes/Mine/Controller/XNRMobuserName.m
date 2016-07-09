//
//  XNRMobuserName.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/11.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRMobuserName.h"

@interface XNRMobuserName()<UITextFieldDelegate>

@property (nonatomic ,weak) UIView *bgView;
@property (nonatomic ,weak) UITextField *userNameTF;
@property (nonatomic ,weak) UIButton *finishBtn;
@property (nonatomic ,weak) UILabel *warnLabel;
@property (nonatomic,assign) int nameLength;

@end
@implementation XNRMobuserName

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xfafafa);

    [self createNav];
    [self createView];
}

-(void)createView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(24), ScreenWidth, PX_TO_PT(98))];
    bgView.backgroundColor = R_G_B_16(0xffffff);
    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    UITextField *userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth-PX_TO_PT(32)*2, PX_TO_PT(98))];
    userNameTF.borderStyle = UITextBorderStyleNone;
    userNameTF.backgroundColor = R_G_B_16(0xffffff);
    userNameTF.placeholder = @"请输入您的真实姓名";
    userNameTF.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTF.textAlignment = NSTextAlignmentLeft;
    userNameTF.delegate = self;
//    [userNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (![KSHttpRequest isBlankString:[DataCenter account].name]) {
        userNameTF.text = [NSString stringWithFormat:@"%@",[DataCenter account].name];
    }
    self.userNameTF = userNameTF;
    [bgView addSubview:userNameTF];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    topLine.backgroundColor = R_G_B_16(0xe0e0e0);
    [bgView addSubview:topLine];
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.bgView.frame)+PX_TO_PT(24), ScreenWidth, PX_TO_PT(20))];
    warnLabel.text = @"限6个汉字或12个英文字符";
    warnLabel.font = [UIFont systemFontOfSize:PX_TO_PT(20)];
    warnLabel.textColor = R_G_B_16(0x323232);
    self.warnLabel = warnLabel;
    [self.view addSubview:warnLabel];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, 1)];
    bottomLine.backgroundColor = R_G_B_16(0xe0e0e0);
    [bgView addSubview:bottomLine];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.userNameTF.frame) + PX_TO_PT(100), ScreenWidth-PX_TO_PT(32)*2, PX_TO_PT(89));
    [finishBtn setTitle:@"保存" forState:UIControlStateNormal];
    [finishBtn setTintColor:R_G_B_16(0xffffff)];
    [finishBtn setBackgroundColor:R_G_B_16(0xe0e0e0)];
    finishBtn.layer.cornerRadius = 5.0;
    finishBtn.layer.masksToBounds = YES;
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.finishBtn = finishBtn;
    [self.view addSubview:finishBtn];
    
}
-(void)finishBtnClick{
    [self.userNameTF resignFirstResponder];
    if ([self.userNameTF.text isEqualToString:@""] || self.userNameTF.text == nil) {
        NSString *str = @"您还没有填写姓名哦";
        [UILabel showMessage:str];
        
    }
    else if(self.nameLength>12)
    {
        [UILabel showMessage:@"姓名限6个汉字或12个英文字符"];
    }
    else{
        [KSHttpRequest post:KUserModify parameters:@{@"userId":[DataCenter account].userid,@"userName":self.userNameTF.text,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                self.com(self.userNameTF.text);
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
                [UILabel showMessage:result[@"message"]];
            
            }
        } failure:^(NSError *error) {
            
        }];

    
    }
    
}

#pragma mark -- textField代理
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.userNameTF) {
        
        int strlength = 0;
        char* p = (char*)[textField.text cStringUsingEncoding:NSUnicodeStringEncoding];
        for (int i=0 ; i<[textField.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
            if (*p) {
                p++;
                strlength++;
            }
            else {
                p++;
            }
            
        }
        
        self.nameLength = strlength;
        
        if (strlength > 12) {
            [UILabel showMessage:[NSString stringWithFormat:@"姓名限6个汉字或12个英文字符"]];
        }
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        [self.finishBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#66d1b9"]] forState:UIControlStateHighlighted];
        [self.finishBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateNormal];

    if (textField == self.userNameTF) {
        
        int strlength = 0;
        char* p = (char*)[textField.text cStringUsingEncoding:NSUnicodeStringEncoding];
        for (int i=0 ; i<[textField.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
            if (*p) {
                p++;
                strlength++;
            }
            else {
                p++;
            }
            
        }
        
        self.nameLength = strlength;
    }
    return YES;
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//
//    NSString * mstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    CGSize textSize = [mstr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
//    
//    if (textSize.width>PX_TO_PT(210)&&![string isEqualToString:@""]) {
//        [textField resignFirstResponder];
//        mstr = [mstr substringWithRange:NSMakeRange(0, 6)];
//        [UILabel showMessage:[NSString stringWithFormat:@"不能超过%d个汉字",(int)mstr.length]];
//        return NO;
//    }
//    return YES;
//}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.finishBtn.backgroundColor = R_G_B_16(0xe0e0e0);
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{


}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}



-(void)createNav{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(48)];
    titleLabel.textColor = R_G_B_16(0xfbffff);

    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"修改姓名";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 44);
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backBtn addTarget: self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end

