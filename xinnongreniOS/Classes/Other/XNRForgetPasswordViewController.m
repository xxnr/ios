//
//  XNRForgetPasswordViewController.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRForgetPasswordViewController.h"
#import "KSHttpRequest.h"
#import "XNRLoginViewController.h"
#import "RSA.h"
@interface XNRForgetPasswordViewController ()<UITextFieldDelegate>
{
    int _timeCount;      //定时器计数
    NSTimer *_timer;     //定时器
    UIView *_phoneNumBg; //手机号背景
    UIView *_verifyBg;
    UIView *_newPasswordBg;
    UIView *_againPasswordBg;
}
@property (nonatomic, weak) UIImageView *mainView;
@property (nonatomic,weak) UIView *midView;

@property(nonatomic,weak) UITextField *phoneNumTextField;      //手机号
@property(nonatomic,weak) UITextField *verifyNumTextField;     //验证码
@property(nonatomic,weak) UITextField *newpasswordTextField;   //新密码
@property(nonatomic,weak) UITextField *againPasswordTextField; //确认密码
@property(nonatomic,weak) UIButton *finishButton;              //完成
@property(nonatomic,weak) UIButton *getVerifyButton;        //获取验证码
@property (nonatomic, copy) NSString *pubKey;

@end

@implementation XNRForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *mainView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    [mainView setImage:[UIImage imageNamed:@"login_bgView"]];
    mainView.userInteractionEnabled = YES;
    self.mainView = mainView;
    [self.view addSubview:mainView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];
    [self createMidView];
    [self createPhoneNumTextField];
    [self createVerifyNumTextField];
    [self createGetVerifyButton];
    [self createNewpasswordTextField];
    [self createAgainPasswordTextField];
    [self createLineView];
    [self createFinishButton];
    
//    // 接受登陆界面的跳转
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToView) name:@"popToView" object:nil];
}

//-(void)popToView{
//        XNRTabBarController *tab = (XNRTabBarController *)self.tabBarController;
//        tab.selectedIndex = 0;
//        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
//}
#pragma mark - 创建手机号

-(void)createMidView
{
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(90), ScreenWidth-PX_TO_PT(64), PX_TO_PT(480))];
    midView.backgroundColor = [UIColor whiteColor];
    self.midView = midView;
    [self.mainView addSubview:midView];


}
- (void)createPhoneNumTextField
{
    UIButton *phoneNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneNumBtn.frame = CGRectMake(PX_TO_PT(20),PX_TO_PT(34), PX_TO_PT(52), PX_TO_PT(52));
    [phoneNumBtn setImage:[UIImage imageNamed:@"login_phoneNum"] forState:UIControlStateNormal];
    [self.midView addSubview:phoneNumBtn];
    
    UITextField *phoneNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(PX_TO_PT(96), PX_TO_PT(34),ScreenWidth-PX_TO_PT(160),PX_TO_PT(52))];
    phoneNumTextField.borderStyle = UITextBorderStyleNone;
    phoneNumTextField.placeholder = @"请输入您的手机号";
    phoneNumTextField.alpha = 1;
    phoneNumTextField.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    phoneNumTextField.delegate = self;
    //设置键盘类型
    phoneNumTextField.returnKeyType = UIReturnKeyDone;
    phoneNumTextField.keyboardType=UIKeyboardTypeNumberPad;
    phoneNumTextField.clearButtonMode = UITextFieldViewModeAlways;
    phoneNumTextField.textAlignment = NSTextAlignmentLeft;
    self.phoneNumTextField = phoneNumTextField;
    [self.midView  addSubview:phoneNumTextField];
}

#pragma mark - 创建验证码
- (void)createVerifyNumTextField
{
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyBtn.frame = CGRectMake(PX_TO_PT(20), PX_TO_PT(154), PX_TO_PT(52), PX_TO_PT(52));
    [verifyBtn setImage:[UIImage imageNamed:@"login_message"] forState:UIControlStateNormal];
    [self.midView addSubview:verifyBtn];
    
    UITextField *verifyNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(PX_TO_PT(96), PX_TO_PT(154), ScreenWidth-PX_TO_PT(160), PX_TO_PT(52))];
    verifyNumTextField.borderStyle = UITextBorderStyleNone;
    verifyNumTextField.placeholder = @"请输入短信验证码";
    verifyNumTextField.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    verifyNumTextField.delegate = self;
    //设置键盘类型
    verifyNumTextField.returnKeyType = UIReturnKeyDone;
    verifyNumTextField.keyboardType=UIKeyboardTypeNumberPad;
//    verifyNumTextField.clearButtonMode = UITextFieldViewModeAlways;
    verifyNumTextField.textAlignment = NSTextAlignmentLeft;
    self.verifyNumTextField = verifyNumTextField;
    [self.midView  addSubview:verifyNumTextField];
}

#pragma mark - 获取验证码
- (void)createGetVerifyButton
{
    UIButton *getVerifyButton = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(280),PX_TO_PT(150),PX_TO_PT(200),PX_TO_PT(52)) ImageName:nil Target:self Action:@selector(verifyClick:) Title:nil];
    getVerifyButton.backgroundColor = R_G_B_16(0x00b38a);
    [getVerifyButton setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    [getVerifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getVerifyButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(20)];
    getVerifyButton.layer.masksToBounds = YES;
    getVerifyButton.layer.cornerRadius = 5;
    self.getVerifyButton = getVerifyButton;
    [self.midView addSubview:getVerifyButton];

}

#pragma mark - 验证按钮
- (void)verifyClick:(UIButton *)button
{
    [self.phoneNumTextField resignFirstResponder];
    [self.verifyNumTextField resignFirstResponder];

    [self.newpasswordTextField resignFirstResponder];

    [self.againPasswordTextField resignFirstResponder];

    if(self.phoneNumTextField.text.length==0){
        
        [UILabel showMessage:@"请输入手机号"];
        
    }else if ([self validateMobile:self.phoneNumTextField.text]==NO){
    
        [UILabel showMessage:@"手机号格式错误"];

        
    }else{
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"GBVerifyEnterAgainForgetPassword"] == NO){
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GBVerifyEnterAgainForgetPassword"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            //第一次点击直接读秒
            [KSHttpRequest post:KUserSms parameters:@{@"bizcode":@"resetpwd",@"tel":self.phoneNumTextField.text,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                
                NSLog(@"%@",result);
                
                if([result[@"code"] integerValue] == 1000){
                    //请求成功读秒
                   [self readSecond];
                    [UILabel showMessage:@"成功获取短信，请注意查收"];
                    
                }else{
                    
                    [UILabel showMessage:result[@"message"]];

                    
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            //读秒开始记录时间
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];
            [[NSUserDefaults standardUserDefaults] setObject:timeSp forKey:@"getMessageTimeForgetPassword"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            
            
            //第二次点击，先进行时间对比
            NSString*signTime=[[NSUserDefaults standardUserDefaults]objectForKey:@"getMessageTimeForgetPassword"];
            int signTime_NUM=[signTime intValue];
            /**
             获取验证码的时间
             */
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:signTime_NUM];
            NSTimeInterval interval=[[NSDate date]timeIntervalSinceDate:confromTimesp];
            
            NSLog(@"%d",(int)interval );
            //如果时间间隔大于60秒，点击允许下次点击，重新记录获取时间
                NSLog(@"获取验证码");
                NSDate *datenow = [NSDate date];
                NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];
                [[NSUserDefaults standardUserDefaults] setObject:timeSp forKey:@"getMessageTimeForgetPassword"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [KSHttpRequest get:KUserSms parameters:@{@"bizcode":@"resetpwd",@"tel":self.phoneNumTextField.text,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                    
                    
                    if([result[@"code"] integerValue] == 1000){
                        //请求成功读秒
                        [self readSecond];
                        [UILabel showMessage:@"成功获取短信，请注意查收"];
                        
                    }else{
                        
                        [UILabel showMessage:result[@"message"]];

                        
                    }
                    
                } failure:^(NSError *error) {
                    
                    
            }];
            
        }
        
    }
}

#pragma mark - 读秒开始
-(void)readSecond{
    
    _timeCount=60;
    self.getVerifyButton.enabled = NO;
    self.getVerifyButton.backgroundColor = [UIColor lightGrayColor];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dealTimer) userInfo:nil repeats:YES];
    _timer.fireDate=[NSDate distantPast]; //恢复定时器
}

#pragma mark - 跑秒操作
-(void)dealTimer{
    
    [self.getVerifyButton setTitle:[NSString stringWithFormat:@"%ds后重新获取",_timeCount] forState:UIControlStateNormal];
    _timeCount=_timeCount-1;
    if(_timeCount== -1){
        _timer.fireDate=[NSDate distantFuture]; //暂停定时器
        self.getVerifyButton.enabled = YES;
        self.getVerifyButton.backgroundColor = R_G_B_16(0x00b38a);
        [self.getVerifyButton setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    }
}

#pragma mark - 创建新密码
- (void)createNewpasswordTextField
{
    //新密码背景
    UIButton *passWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passWordBtn.frame = CGRectMake(PX_TO_PT(20), PX_TO_PT(274), PX_TO_PT(52), PX_TO_PT(52));
    [passWordBtn setImage:[UIImage imageNamed:@"login_pwd"] forState:UIControlStateNormal];
    passWordBtn.backgroundColor = [UIColor whiteColor];
    [self.midView addSubview:passWordBtn];
    
    UITextField *newpasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(PX_TO_PT(96),PX_TO_PT(274), ScreenWidth-PX_TO_PT(160), PX_TO_PT(52))];
    newpasswordTextField.borderStyle = UITextBorderStyleNone;
    newpasswordTextField.secureTextEntry=YES;
    newpasswordTextField.placeholder = @"请设置您的密码";
    newpasswordTextField.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    newpasswordTextField.delegate = self;
    //设置键盘类型
    newpasswordTextField.keyboardType=UIKeyboardTypeDefault;
    newpasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    newpasswordTextField.textAlignment = NSTextAlignmentLeft;
    self.newpasswordTextField = newpasswordTextField;
    [self.midView  addSubview:newpasswordTextField];

}

#pragma mark - 创建确认密码
- (void)createAgainPasswordTextField
{
    //新密码背景
    UIButton *againPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    againPasswordBtn.frame = CGRectMake(PX_TO_PT(20), PX_TO_PT(394), PX_TO_PT(52), PX_TO_PT(52));
    againPasswordBtn.backgroundColor = [UIColor whiteColor];
    [againPasswordBtn setImage:[UIImage imageNamed:@"login_pwd"] forState:UIControlStateNormal];
    [self.midView addSubview:againPasswordBtn];
    
    UITextField *againPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(PX_TO_PT(96), PX_TO_PT(394),ScreenWidth-PX_TO_PT(160),PX_TO_PT(52))];
    againPasswordTextField.borderStyle = UITextBorderStyleNone;
    againPasswordTextField.secureTextEntry=YES;
    againPasswordTextField.placeholder = @"请输入您的确认密码";
    againPasswordTextField.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    againPasswordTextField.delegate = self;
    //设置键盘类型
    againPasswordTextField.keyboardType=UIKeyboardTypeDefault;
    againPasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    againPasswordTextField.textAlignment = NSTextAlignmentLeft;
    self.againPasswordTextField = againPasswordTextField;
    [self.midView addSubview:againPasswordTextField];
}

#pragma mark - 创建分割线
-(void)createLineView
{
    for (int i = 1; i<4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(20), PX_TO_PT(120)*i, ScreenWidth-PX_TO_PT(104), 1)];
        lineView.backgroundColor = R_G_B_16(0xe2e2e2);
        [self.midView addSubview:lineView];
    }
}

#pragma mark - 创建完成
- (void)createFinishButton
{
    UIButton *finishButton = [MyControl createButtonWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.midView.frame) + PX_TO_PT(120), ScreenWidth-PX_TO_PT(64), PX_TO_PT(96)) ImageName:nil Target:self Action:@selector(finishClick:) Title:nil];
    finishButton.backgroundColor = R_G_B_16(0x00b38a);
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:R_G_B_16(0xfbfffe) forState:UIControlStateNormal];
    finishButton.layer.masksToBounds = YES;
    finishButton.layer.cornerRadius = 5;
    finishButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    self.finishButton = finishButton;
    [self.mainView addSubview:finishButton];
}
//完成
- (void)finishClick:(UIButton *)button
{
    
    if(self.phoneNumTextField.text.length==0){
        
    [UILabel showMessage:@"请输入手机号"];

    }else if ([self validateMobile:self.phoneNumTextField.text]==NO){

    [UILabel showMessage:@"手机格式错误"];

    }else if (self.verifyNumTextField.text.length==0){
        [UILabel showMessage:@"请输入验证码"];
    
    }else if (self.newpasswordTextField.text.length==0){
        [UILabel showMessage:@"请输入密码"];

    
    }else if (self.againPasswordTextField.text.length==0){
        [UILabel showMessage:@"请输入确认密码"];

    
    }else if ([self.newpasswordTextField.text isEqualToString:self.againPasswordTextField.text]==NO){
        
        [UILabel showMessage:@"两次填写的密码不一致请认真核对"];
        
    }else{
        
        [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
        [KSHttpRequest get:KUserPubkey parameters:nil success:^(id result) {
                NSLog(@"======%@",result);
                if ([result[@"code"] integerValue] == 1000) {
                    NSString *pubKey = result[@"public_key"];
                    self.pubKey = pubKey;
                    [self getNetwork];
                }
        
            } failure:^(NSError *error) {
                
            }];
        
    }
}
-(void)getNetwork
{
    NSString *newPassWord = self.newpasswordTextField.text;
    NSString *encry = [GBAlipayManager encryptString:newPassWord publicKey:self.pubKey];
    [KSHttpRequest post:KUserResetpwd parameters:@{@"account":_phoneNumTextField.text, @"newPwd":encry,@"smsCode":_verifyNumTextField.text,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        NSLog(@"%@",result[@"message"]);
        
        [BMProgressView LoadViewDisappear:self.view];
        if([result[@"code"] integerValue] == 1000){
            
            XNRLoginViewController *vc=[[XNRLoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.loginFrom = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            
            [UILabel showMessage:result[@"message"]];
            
        }
    } failure:^(NSError *error) {
        
        
    }];


}

#pragma mark - 正则表达式判断手机号格式
- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - textField代理方法

#pragma mark - 键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //计算插入之后的字符串
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:textField.text];
    [mstr insertString:string atIndex:range.location];
    if (textField == self.phoneNumTextField) {
        if(mstr.length > 11)
        {
            return NO;
        }
    }
    else if (textField == self.verifyNumTextField){
        if(mstr.length > 6)
        {
            return NO;
        }
    }
    else{
        if(mstr.length > 20)
        {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //验证手机号输入是否正确
    if (textField == self.phoneNumTextField) {
        BOOL flag = [self validateMobile:textField.text];
        if (!flag) {

            [UILabel showMessage:@"手机号输入格式不正确"];


        }
    }
}

#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"忘记密码";
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame=CGRectMake(0, 0, 30, 44);
    
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchDown];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

- (void)backClick:(UIButton *)btn
{
    //停止定时器
    //在invalidate之前最好先用isValid先判断是否还在线程中：
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 键盘躲避
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

//消失时回收键盘
- (void)viewWillDisappear:(BOOL)animated
{
    [self.phoneNumTextField resignFirstResponder];
    [self.verifyNumTextField resignFirstResponder];
    [self.newpasswordTextField resignFirstResponder];
    [self.againPasswordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
