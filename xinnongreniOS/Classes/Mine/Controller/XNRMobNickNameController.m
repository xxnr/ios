//
//  XNRMobNickNameController.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/10.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRMobNickNameController.h"

@interface XNRMobNickNameController()<UITextFieldDelegate>

@property (nonatomic ,weak) UIView *bgView;
@property (nonatomic ,weak) UITextField *nickNameTF;

@property (nonatomic ,weak) UILabel *warnLabel;

@property (nonatomic ,weak) UIButton *finishBtn;

@end

@implementation XNRMobNickNameController

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
    
    UITextField *nickNameTF = [[UITextField alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth-PX_TO_PT(32)*2, PX_TO_PT(98))];
    nickNameTF.borderStyle = UITextBorderStyleNone;
    nickNameTF.backgroundColor = R_G_B_16(0xffffff);
    nickNameTF.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    nickNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nickNameTF.textAlignment = NSTextAlignmentLeft;
    nickNameTF.delegate = self;
    if (![KSHttpRequest isBlankString:[DataCenter account].nickname]) {
        nickNameTF.text = [NSString stringWithFormat:@"%@",[DataCenter account].nickname];

    }
    self.nickNameTF = nickNameTF;
    [bgView addSubview:nickNameTF];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [bgView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, PX_TO_PT(1))];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [bgView addSubview:bottomLine];
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.bgView.frame)+PX_TO_PT(24), ScreenWidth, PX_TO_PT(20))];
    warnLabel.text = @"限6个汉字或12个英文字符";
    warnLabel.font = XNRFont(10);
    warnLabel.textColor = R_G_B_16(0x323232);
    self.warnLabel = warnLabel;
    [self.view addSubview:warnLabel];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.warnLabel.frame) + PX_TO_PT(48), ScreenWidth-PX_TO_PT(32)*2, PX_TO_PT(89));
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTintColor:R_G_B_16(0xffffff)];
    [finishBtn setBackgroundColor:R_G_B_16(0xe0e0e0)];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.layer.cornerRadius = 5.0;
    finishBtn.layer.masksToBounds = YES;
    self.finishBtn = finishBtn;
    [self.view addSubview:finishBtn];
    
}
-(void)finishBtnClick{
    [self.nickNameTF resignFirstResponder];
    if ([self.nickNameTF.text isEqualToString:@""] || self.nickNameTF.text == nil) {
        [UILabel showMessage:@"请先输入昵称哦"];
    }else{
        [KSHttpRequest post:KUserModify parameters:@{@"userId":[DataCenter account].userid,@"nickName":self.nickNameTF.text,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                //更新成功保存本地
                UserInfo *info = [DataCenter account];
                info.nickname = self.nickNameTF.text;
                [DataCenter saveAccount:info];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyAccount" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
               
                [UILabel showMessage:@"昵称输入过长"];
                
            }
        } failure:^(NSError *error) {
            
        }];

    
    }
    
}

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
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"修改昵称";
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
