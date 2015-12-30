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
    userNameTF.font = XNRFont(18);
    userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTF.textAlignment = NSTextAlignmentLeft;
    userNameTF.delegate = self;
//    [userNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (![KSHttpRequest isBlankString:[DataCenter account].name]) {
        userNameTF.text = [NSString stringWithFormat:@"%@",[DataCenter account].name];
    }
    self.userNameTF = userNameTF;
    [bgView addSubview:userNameTF];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [bgView addSubview:topLine];
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.bgView.frame)+PX_TO_PT(24), ScreenWidth, PX_TO_PT(20))];
    warnLabel.text = @"限6个汉字或12个英文字符";
    warnLabel.font = XNRFont(10);
    warnLabel.textColor = R_G_B_16(0x323232);
    self.warnLabel = warnLabel;
    [self.view addSubview:warnLabel];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, PX_TO_PT(1))];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
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
    if ([self.userNameTF.text isEqualToString:@""] || self.userNameTF.text == nil) {
        NSString *str = @"您还没有填写姓名哦";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        
        [alert show];
        
    }else{
        [KSHttpRequest post:KUserModify parameters:@{@"userId":[DataCenter account].userid,@"userName":self.userNameTF.text} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                //更新成功保存本地
                UserInfo *info = [DataCenter account];
                info.name = self.userNameTF.text;
                [DataCenter saveAccount:info];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyAccount" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:result[@"message"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [al show];

            
            }
        } failure:^(NSError *error) {
            
        }];

    
    }
    
}
//- (void)textFieldDidChange:(UITextField *)textField {
//    NSString *toBeString = textField.text;
//    NSArray *currentar = [UITextInputMode activeInputModes];
//    UITextInputMode *current = [currentar firstObject];
//    
//    //下面的方法是iOS7被废弃的，注释
//    //    NSString *lang = [[UITextInputMode currentInputMode] PRimaryLanguage]; // 键盘输入模式
//    
//    if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > 6) {
//                textField.text = [toBeString substringToIndex:6];
//            }
//        }
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//            
//        }
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else{
//        if (toBeString.length > 12) {
//            textField.text = [toBeString substringToIndex:12];
//        }
//    }
//    NSLog(@"%@",textField.text);
//}

#pragma mark -- textField代理

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.finishBtn.backgroundColor = R_G_B_16(0x00b38a);
    
    NSString * mstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (mstr.length>12) {
        textField.text = [mstr substringFromIndex:12];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.finishBtn.backgroundColor = R_G_B_16(0xe0e0e0);
    return YES;
}


//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    self.finishBtn.backgroundColor = R_G_B_16(0x00b38a);
//    NSMutableString *mstr = [[NSMutableString alloc] initWithString:textField.text];
//    [mstr insertString:string atIndex:range.location];
//    if (mstr.length>12) {
//        return NO;
//    }
//    return YES;
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{


}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}



-(void)createNav{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"修改姓名";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 44);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backBtn addTarget: self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

