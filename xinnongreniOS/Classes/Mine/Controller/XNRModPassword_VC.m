//
//  XNRModPassword_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/9.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRModPassword_VC.h"
#import "CoreTFManagerVC.h"
#import "KSHttpRequest.h"
#import "DataCenter.h"
#import "XNRLoginViewController.h"
#import "XNRMineController.h"

@interface XNRModPassword_VC ()<UITextFieldDelegate>{

    UIView *_newPasswordBg;
    UIView *_againPasswordBg;
    UIView*_makeSurePasswordBg;

}


@property(nonatomic,strong) UITextField *newpasswordTextField;     //旧密码
@property(nonatomic,strong) UITextField *againPasswordTextField;                          //新密码
@property(nonatomic,strong) UITextField *makeSurePasswordTextField; //确认密码
@property(nonatomic,strong) UIButton *finishButton;             //完成
@property(nonatomic,strong) UIButton *getVerifyButton;         //获取验证码
@property(nonatomic, copy) NSString *pubKey;

@end

@implementation XNRModPassword_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];
    [self createNewpasswordTextField];
    [self createAgainPasswordTextField];
    [self createMakePasswordTextField];
    [self createFinishButton];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToView) name:@"popToView" object:nil];
}

-(void)popToView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UserInfo *infos = [[UserInfo alloc]init];
    infos.loginState = NO;
    [DataCenter saveAccount:infos];
}
#pragma mark-创建确认新密码
-(void)createMakePasswordTextField{
    
    _makeSurePasswordBg =[[UIView alloc]initWithFrame:CGRectMake(10, _againPasswordBg.frame.origin.y+_againPasswordBg.frame.size.height+10, ScreenWidth-20, 45)];
    _makeSurePasswordBg.backgroundColor=[UIColor whiteColor];
    _makeSurePasswordBg.clipsToBounds=YES;
    _makeSurePasswordBg.layer.cornerRadius=5;
    _makeSurePasswordBg.layer.borderColor=[R_G_B_16(0xdcdcdc)CGColor];
    _makeSurePasswordBg.layer.borderWidth=.5;
    [self.view addSubview:_makeSurePasswordBg];
    
    self.makeSurePasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, _newPasswordBg.frame.size.width-10, _newPasswordBg.frame.size.height)];
    self.makeSurePasswordTextField.borderStyle = UITextBorderStyleNone;
    self.makeSurePasswordTextField.placeholder = @"确认新密码";
    self.makeSurePasswordTextField.font = XNRFont(18);
    self.makeSurePasswordTextField.delegate = self;
    self.makeSurePasswordTextField.secureTextEntry = YES;
    //设置键盘类型
    self.makeSurePasswordTextField.keyboardType=UIKeyboardTypeDefault;
    self.makeSurePasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.makeSurePasswordTextField.textAlignment = NSTextAlignmentLeft;
    [_makeSurePasswordBg  addSubview:self.makeSurePasswordTextField];
    
    
}

#pragma mark - 创建新密码
- (void)createNewpasswordTextField
{
    //新密码背景
    _newPasswordBg =[[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 45)];
    _newPasswordBg.backgroundColor=[UIColor whiteColor];
    _newPasswordBg.clipsToBounds=YES;
    _newPasswordBg.layer.cornerRadius=5;
    _newPasswordBg.layer.borderColor=[R_G_B_16(0xdcdcdc)CGColor];
    _newPasswordBg.layer.borderWidth=.5;
    [self.view addSubview:_newPasswordBg];
    
    self.newpasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, _newPasswordBg.frame.size.width-10, _newPasswordBg.frame.size.height)];
    self.newpasswordTextField.borderStyle = UITextBorderStyleNone;
    self.newpasswordTextField.placeholder = @"请输入旧密码";
    self.newpasswordTextField.font = XNRFont(18);
    self.newpasswordTextField.delegate = self;
    self.newpasswordTextField.secureTextEntry = YES;
    //设置键盘类型
    self.newpasswordTextField.keyboardType=UIKeyboardTypeDefault;
    self.newpasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.newpasswordTextField.textAlignment = NSTextAlignmentLeft;
    [_newPasswordBg  addSubview:self.newpasswordTextField];
}

#pragma mark - 创建确认密码
- (void)createAgainPasswordTextField
{
    //新密码背景
    _againPasswordBg =[[UIView alloc]initWithFrame:CGRectMake(10, _newPasswordBg.frame.origin.y+_newPasswordBg.frame.size.height+10, ScreenWidth-20, 45)];
    _againPasswordBg.backgroundColor=[UIColor whiteColor];
    _againPasswordBg.clipsToBounds=YES;
    _againPasswordBg.layer.cornerRadius=5;
    _againPasswordBg.layer.borderColor=[R_G_B_16(0xdcdcdc)CGColor];
    _againPasswordBg.layer.borderWidth=.5;
    [self.view addSubview:_againPasswordBg];
    
    self.againPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, _newPasswordBg.frame.size.width-10, _newPasswordBg.frame.size.height)];
    self.againPasswordTextField.borderStyle = UITextBorderStyleNone;
    self.againPasswordTextField.placeholder = @"请输入新密码";
    self.againPasswordTextField.font = XNRFont(18);
    self.againPasswordTextField.secureTextEntry=YES;
    self.againPasswordTextField.delegate = self;
    //设置键盘类型
    self.againPasswordTextField.keyboardType=UIKeyboardTypeDefault;
    self.againPasswordTextField.secureTextEntry = YES;
    self.againPasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.againPasswordTextField.textAlignment = NSTextAlignmentLeft;
    [_againPasswordBg  addSubview:self.againPasswordTextField];
}

#pragma mark - 创建完成
- (void)createFinishButton
{
    self.finishButton = [MyControl createButtonWithFrame:CGRectMake(PX_TO_PT(32),  CGRectGetMaxY(_makeSurePasswordBg.frame)+PX_TO_PT(88), ScreenWidth-PX_TO_PT(32)*2, PX_TO_PT(88)) ImageName:nil Target:self Action:@selector(finishClick:) Title:nil];
    self.finishButton.backgroundColor = R_G_B_16(0x00b38a);
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.finishButton.layer.masksToBounds = YES;
    self.finishButton.layer.cornerRadius = 5;
    self.finishButton.titleLabel.font = XNRFont(18);
    [self.view addSubview:self.finishButton];
}
//完成
- (void)finishClick:(UIButton *)button
{
    
    if(self.newpasswordTextField.text.length==0||self.againPasswordTextField.text.length==0 || self.makeSurePasswordTextField.text.length==0)
    {
        
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"请完善您要填写的资料" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [al show];
        
    }
    else if (![self.againPasswordTextField.text isEqualToString:self.makeSurePasswordTextField.text]){
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"新密码与确认密码不同" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [al show];
    }
    else{
        
        // 加密
        [KSHttpRequest get:KUserPubkey parameters:@{@"user-agent":@"IOS-v2.0"} success:^(id result) {
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
    // 加密
    NSString *oldPwd = self.newpasswordTextField.text;
    NSString *newPwd = self.againPasswordTextField.text;
    NSString *oldPassword = [GBAlipayManager encryptString:oldPwd publicKey:self.pubKey];
    NSString *newPassword = [GBAlipayManager encryptString:newPwd publicKey:self.pubKey];
    

    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *userID = [DataCenter account].userid;
    
    [KSHttpRequest post:KUserModifypwd parameters:@{@"userId":userID, @"oldPwd":oldPassword,@"newPwd":newPassword,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        NSLog(@"%@",result[@"message"]);
        
        if([result[@"code"] isEqualToString:@"1000"]){
            
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            
//            [self.navigationController popToRootViewControllerAnimated:YES];
            
            XNRLoginViewController *login = [[XNRLoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
//            [self.navigationController presentViewController:login animated:YES completion:nil];
//            XNRTabBarController *tab = (XNRTabBarController *)self.tabBarController;
//            tab.selectedIndex = 3;
//            [UIApplication sharedApplication].keyWindow.rootViewController = tab;

            
        }else{
    
            [SVProgressHUD dismiss];
            UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:result[@"message"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [al show];
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络失败"];
        
    }];


}

#pragma mark - 正则表达式判断手机号格式
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13，15，18开头，八个 \d 数字字符
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


#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"修改密码";
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame=CGRectMake(0, 0, 80, 44);
     backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchDown];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

- (void)backClick:(UIButton *)btn
{
   
 
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 键盘躲避
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
       
        TFModel *tfm2=[TFModel modelWithTextFiled:self.makeSurePasswordTextField inputView:nil name:@"" insetBottom:0];
        TFModel *tfm3=[TFModel modelWithTextFiled:self.newpasswordTextField inputView:nil name:@"" insetBottom:0];
        TFModel *tfm4=[TFModel modelWithTextFiled:self.againPasswordTextField inputView:nil name:@"" insetBottom:0];
        return @[tfm2,tfm3,tfm4];
        
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}

//消失时回收键盘
- (void)viewWillDisappear:(BOOL)animated
{
    
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
