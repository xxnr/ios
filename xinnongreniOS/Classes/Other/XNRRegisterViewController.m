//
//  XNRRegisterViewController.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//
#import "RSA.h"
#import "XNRRegisterViewController.h"
#import "YMHProtoclViewController.h"
#import "KSHttpRequest.h"
#import "XNRLoginViewController.h"
#import "XNRFinishMineDataController.h"
#define kRegisterBtn 1000
#define kProtocolBtn 2000
@interface XNRRegisterViewController ()<UITextFieldDelegate>
{
    int _timeCount;      //定时器计数
    NSTimer *_timer;     //定时器
    UIView *_phoneNumBg;
    UIView *_verifyBg;
    UIView *_newPasswordBg;
    UIView *_againPasswordBg;
}
@property (nonatomic, weak) UIImageView *mainView;
@property (nonatomic,weak) UIView *midView;
@property(nonatomic,weak) UITextField *phoneNumTextField;     //手机号
@property(nonatomic,weak) UITextField *verifyNumTextField;    //验证码
@property(nonatomic,weak) UITextField *newpasswordTextField;   //新密码
@property(nonatomic,weak) UITextField *againPasswordTextField;    //确认密码
@property(nonatomic,weak) UIButton *registerButton;         //注册
@property(nonatomic,weak) UIButton *getVerifyButton;        //获取验证码
@property(nonatomic,weak) UIButton *protocolBtn;            //协议
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic ,weak) UIButton *admireBtn;
@property (nonatomic, copy) NSString *pubKey;

@end

@implementation XNRRegisterViewController

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
    [self createRegisterButton];
    [self createProtocolBtn];
    [self createLoginBtn];
    
}

#pragma mark - 创建中部视图
-(void)createMidView
{
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(90), ScreenWidth-PX_TO_PT(64), PX_TO_PT(480))];
    midView.backgroundColor = [UIColor whiteColor];
    self.midView = midView;
    [self.mainView addSubview:midView];
    

}
#pragma mark - 创建手机号
- (void)createPhoneNumTextField
{
    UIButton *phoneNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneNumBtn.frame = CGRectMake(PX_TO_PT(20), PX_TO_PT(34), PX_TO_PT(52), PX_TO_PT(52));
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

#pragma mark - 创建密码
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
        
        [UILabel showMessage:@"请输入正确的手机号"];
        
    }else{
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"GBVerifyEnterAgainRegister"]==NO){
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GBVerifyEnterAgainRegister"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            //第一次点击直接读秒
            [KSHttpRequest get:KUserSms parameters:@{@"bizcode":@"register",@"tel":self.phoneNumTextField.text} success:^(id result) {
                
                NSLog(@"%@",result);
                
                if([result[@"code"] isEqualToString:@"1000"]){
                    //请求成功读秒
                    [self readSecond];
                    
                }else{
                    
                    [UILabel showMessage:result[@"message"]];
                    
                }
                
                
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                
                
            }];
            //读秒开始记录时间
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];
            [[NSUserDefaults standardUserDefaults] setObject:timeSp forKey:@"getMessageTimeRegister"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            }else{
            //第二次点击，先进行时间对比
            NSString*signTime=[[NSUserDefaults standardUserDefaults]objectForKey:@"getMessageTimeRegister"];
            int signTime_NUM=[signTime intValue];
            /**
             获取获取验证码的时间
             */
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:signTime_NUM];
            NSTimeInterval interval=[[NSDate date]timeIntervalSinceDate:confromTimesp];
            
            NSLog(@"%d",(int)interval );
            //如果时间间隔大于60秒，点击允许下次点击，重新记录获取时间
                NSLog(@"获取验证码");
                NSDate *datenow = [NSDate date];
                NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];
                [[NSUserDefaults standardUserDefaults] setObject:timeSp forKey:@"getMessageTimeRegister"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [KSHttpRequest get:KUserSms parameters:@{@"bizcode":@"register",@"tel":self.phoneNumTextField.text} success:^(id result) {
                    if([result[@"code"] isEqualToString:@"1000"]){
                        //请求成功读秒
                        [self readSecond];
                        
                    }else{
                        
                        [UILabel showMessage:result[@"message"]];
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                    [UILabel showMessage:@"网络错误"];
                    
                    
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
    
    [self.getVerifyButton setTitle:[NSString stringWithFormat:@"(%d)秒后重试",_timeCount] forState:UIControlStateNormal];
   
    _timeCount=_timeCount-1;
    if(_timeCount== -1){
        _timer.fireDate=[NSDate distantFuture]; //暂停定时器
        self.getVerifyButton.enabled = YES;
        self.getVerifyButton.backgroundColor = R_G_B_16(0x00b38a);
        [self.getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

#pragma mark - 创建线条
-(void)createLineView
{
    for (int i = 1; i<4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(20), PX_TO_PT(120)*i, ScreenWidth-PX_TO_PT(104), 1)];
        lineView.backgroundColor = R_G_B_16(0xe2e2e2);
        [self.midView addSubview:lineView];
    }

}

#pragma mark - 创建注册按钮
- (void)createRegisterButton
{
    UIButton *registerButton = [MyControl createButtonWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.midView.frame) + PX_TO_PT(120), ScreenWidth-PX_TO_PT(64), PX_TO_PT(96)) ImageName:nil Target:self Action:@selector(btnClick:) Title:nil];
    registerButton.tag = kRegisterBtn;
    [registerButton setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#66d1b9"]] forState:UIControlStateHighlighted];
    [registerButton setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateNormal];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:R_G_B_16(0xfbfffe) forState:UIControlStateNormal];
    registerButton.layer.masksToBounds = YES;
    registerButton.layer.cornerRadius = 5;
    registerButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    self.registerButton = registerButton;
    [self.mainView addSubview:registerButton];
}

#pragma mark - 创建协议按钮
- (void)createProtocolBtn
{
    UIButton *protocolBtn = [[UIButton alloc] initWithFrame:CGRectMake(PX_TO_PT(64), CGRectGetMaxY(self.midView.frame) + PX_TO_PT(72), ScreenWidth, 30)];
    [protocolBtn addTarget:self action:@selector(proBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.protocolBtn = protocolBtn;
    [self.mainView addSubview:protocolBtn];
    
    UILabel *protocolLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(64),CGRectGetMaxY(self.midView.frame) + PX_TO_PT(72), ScreenWidth-PX_TO_PT(64), PX_TO_PT(24))];
    protocolLabel.text = @"我已阅读并同意《新新农人用户协议》";
    protocolLabel.textAlignment = NSTextAlignmentLeft;
    protocolLabel.textColor = R_G_B_16(0xfbfffe);
    protocolLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [self.mainView addSubview:protocolLabel];
  
    //设定内容样式
    NSMutableAttributedString * attributedString =
    [[NSMutableAttributedString alloc] initWithString:protocolLabel.text];
    NSDictionary*dic=@{
                       NSForegroundColorAttributeName:R_G_B_16(0x00ffc3),
                       };
    [attributedString addAttributes:dic range:NSMakeRange(7, 10)];
    [protocolLabel setAttributedText:attributedString];
    
    UIButton *admireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    admireBtn.frame = CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.midView.frame) + PX_TO_PT(72), PX_TO_PT(24), PX_TO_PT(24));
    admireBtn.adjustsImageWhenHighlighted = NO;

    [admireBtn setImage:[UIImage imageNamed:@"login_square"] forState:UIControlStateNormal];
    [admireBtn setImage:[UIImage imageNamed:@"login_square_selected"] forState:UIControlStateSelected];
    [admireBtn addTarget:self action:@selector(admireBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    admireBtn.selected = YES;
    self.admireBtn = admireBtn;
    [self.mainView addSubview:admireBtn];
}
-(void)admireBtnClick:(UIButton *)admireBtn
{
    admireBtn.selected = !admireBtn.isSelected;

}


#pragma mark - 按钮响应事件
- (void)btnClick:(UIButton *)button
{
    [[NSUserDefaults standardUserDefaults]setValue:self.newpasswordTextField.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]setValue:self.phoneNumTextField.text forKey:@"userName"];
        NSLog(@"注册");
        if(self.phoneNumTextField.text.length==0||self.verifyNumTextField.text.length==0||self.newpasswordTextField.text.length==0||self.againPasswordTextField.text.length==0){
            
            [UILabel showMessage:@"请完善您要填写的资料"];
            
        }else if ([self.newpasswordTextField.text isEqualToString:self.againPasswordTextField.text]==NO){
            
    
            [UILabel showMessage:@"两次填写的密码不一致请认真核对"];
            
        }else if ([self validateMobile:self.phoneNumTextField.text]==NO){
            
            [UILabel showMessage:@"手机格式错误"];
        }else if(self.admireBtn.selected == NO){
            
            [UILabel showMessage:@"您需要同意注册协议才可继续注册哦~"];
        
        }else{
            
            [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
            [KSHttpRequest get:KUserPubkey parameters:nil success:^(id result) {
                if ([result[@"code"] integerValue] == 1000) {
                    NSString *pubKey = result[@"public_key"];
                    self.pubKey = pubKey;
                    [self getNetwork];
                }
            } failure:^(NSError *error) {
                
            }];
    }
}

-(void)proBtnClick
{
    YMHProtoclViewController *protocol = [[YMHProtoclViewController alloc]init];
    protocol.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:protocol animated:YES];
}
-(void)getNetwork
{
    NSString *passWord = self.newpasswordTextField.text;
    NSString *encryptPassword = [GBAlipayManager encryptString:passWord publicKey:self.pubKey];
    
    NSString *encodeValue = [KUserRegister stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [KSHttpRequest post:encodeValue parameters:@{@"account":_phoneNumTextField.text, @"password":encryptPassword,@"smsCode":_verifyNumTextField.text,@"nickname":@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        NSLog(@"result-->%@",result);
        NSLog(@"%@",result[@"message"]);
        
        [BMProgressView LoadViewDisappear:self.view];
        NSDictionary *datasDic = result[@"datas"];
        if([result[@"code"] isEqualToString:@"1000"]){
            
        XNRLoginViewController *loginVC = [[XNRLoginViewController alloc]init];
        loginVC.loginName = datasDic[@"loginName"];
        [self.navigationController pushViewController:loginVC animated:YES];
            
        }else{
            
        [UILabel showMessage:result[@"message"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];


}
#pragma mark - 正则表达式判断手机号格式
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[6-8]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark - 创建登录按钮
-(void)createLoginBtn
{
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, CGRectGetMaxY(self.registerButton.frame) + PX_TO_PT(92), ScreenWidth, PX_TO_PT(60));
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    [self.mainView addSubview:loginBtn];
    
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.registerButton.frame) + PX_TO_PT(92), ScreenWidth, PX_TO_PT(60))];
    loginLabel.text = @"已有账号?登录";
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.textColor = R_G_B_16(0xfbfffe);
    loginLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [self.mainView addSubview:loginLabel];
    //设定内容样式
    NSMutableAttributedString * attributedString =
    [[NSMutableAttributedString alloc] initWithString:loginLabel.text];
    NSDictionary*dic=@{
                       NSForegroundColorAttributeName:R_G_B_16(0x00ffc3),
                       };
    
    [attributedString addAttributes:dic range:NSMakeRange(5, 2)];
    [loginLabel setAttributedText:attributedString];
}

-(void)loginBtnClick{
    XNRLoginViewController *loginVC = [[XNRLoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"注册";
    
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

#pragma mark - textField代理方法

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //计算插入之后的字符串
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:textField.text];
    [mstr insertString:string atIndex:range.location];
    if(mstr.length > 20)
    {
        return NO;
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
