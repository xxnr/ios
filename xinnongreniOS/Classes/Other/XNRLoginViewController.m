//
//  XNRLoginViewController.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRLoginViewController.h"
#import "XNRRegisterViewController.h"
#import "XNRForgetPasswordViewController.h"
#import "CoreTFManagerVC.h"
#import "XNRTabBarController.h"
#import "QCheckBox.h"
#import "XNRTabBarController.h"
#import "KSHttpRequest.h"
#import "UserInfo.h"
#import "DataCenter.h"
#import "RSA.h"
#import "XNRProductInfo_VC.h"
#import "AppDelegate.h"
#import "XNRFinishMineDataController.h"
@interface XNRLoginViewController ()<UITextFieldDelegate,QCheckBoxDelegate>{
    
    BOOL isRemmeber;
    
}

@property (nonatomic,weak) UIImageView *mainView;
@property (nonatomic,weak) UIView *midView;
@property (nonatomic,weak) UITextField *usernameTextField;
@property (nonatomic,weak) UITextField *passwordTextField;
@property (nonatomic,weak) UIButton *registerBtn;
@property (nonatomic,weak) UIButton *forgetBtn;
@property (nonatomic,weak) UIButton *loginBtn;
@property (nonatomic, copy)  NSString *pubKey;

@property (nonatomic,strong)XNRShoppingCartModel *model;

@end

@implementation XNRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createMainView];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
}

#pragma mark - 创建主视图
- (void)createMainView
{
    UIImageView *mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    mainView.userInteractionEnabled = YES;
    self.mainView = mainView;
    [mainView setImage:[UIImage imageNamed:@"login_bgView"]];
    [self.view addSubview:mainView];
    [self setNavigationbarTitle];
    [self createMidView];
    [self createForgetBtn];
    [self createLoginBtn];
    [self createRegisterBtn];
}

#pragma mark - 键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)setNavigationbarTitle
{
    self.navigationItem.title = @"登录";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 80, 40);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

}

-(void)backBtnClick
{
    if (self.loginFrom) {
        XNRTabBarController *tab = (XNRTabBarController *)self.tabBarController;
        tab.selectedIndex = 0;
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    if (self.com) {
        self.com();
    }

}
#pragma mark - 创建中部视图(包含用户名和密码)
- (void)createMidView
{
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32),PX_TO_PT(90),ScreenWidth-PX_TO_PT(64),PX_TO_PT(240))];
    midView.backgroundColor = [UIColor whiteColor];
    self.midView = midView;
    [self.mainView addSubview:midView];
    
    [self createUsernameTextField];
    [self createLineView];
    [self createPasswordTextField];
}

#pragma mark - 创建用户名
- (void)createUsernameTextField
{
    UIButton *phoneNum = [MyControl createButtonWithFrame:CGRectMake(PX_TO_PT(20), PX_TO_PT(34), PX_TO_PT(52), PX_TO_PT(52)) ImageName:@"" Target:nil Action:nil Title:nil];
    [phoneNum setImage:[UIImage imageNamed:@"login_headView"] forState:UIControlStateNormal];
    phoneNum.adjustsImageWhenHighlighted = NO;
    [self.midView addSubview:phoneNum];
    
    UITextField *usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(PX_TO_PT(96), PX_TO_PT(34),ScreenWidth-PX_TO_PT(160) ,PX_TO_PT(52))];
    usernameTextField.borderStyle = UITextBorderStyleNone;
    usernameTextField.alpha = 1;
    usernameTextField.placeholder = @"请输入您的手机号";
    usernameTextField.font = XNRFont(14);
    usernameTextField.delegate = self;
    usernameTextField.returnKeyType = UIReturnKeyDone;
    usernameTextField.keyboardType = UIKeyboardTypePhonePad;
    usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
    usernameTextField.textAlignment = NSTextAlignmentLeft;
    self.usernameTextField = usernameTextField;
    [self.midView  addSubview:usernameTextField];
}

#pragma mark - 创建线
- (void)createLineView
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(20), PX_TO_PT(120), ScreenWidth-PX_TO_PT(104), 1)];
    lineView.backgroundColor = R_G_B_16(0xe2e2e2);
    [self.midView addSubview:lineView];
}

#pragma mark - 创建密码
- (void)createPasswordTextField
{
    UIButton *password = [MyControl createButtonWithFrame:CGRectMake(PX_TO_PT(20), PX_TO_PT(154), PX_TO_PT(54), PX_TO_PT(54)) ImageName:@"" Target:nil Action:nil Title:nil];
    [password setImage:[UIImage imageNamed:@"login_pwd"] forState:UIControlStateNormal];
    password.adjustsImageWhenHighlighted = NO;
    [self.midView addSubview:password];
    
    UITextField *passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(PX_TO_PT(96), PX_TO_PT(154), ScreenWidth-PX_TO_PT(160), PX_TO_PT(54))];
    passwordTextField.borderStyle = UITextBorderStyleNone;
    passwordTextField.alpha = 1;
    passwordTextField.placeholder = @"请输入您的密码";
    passwordTextField.font = XNRFont(14);
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    passwordTextField.textAlignment = NSTextAlignmentLeft;
    self.passwordTextField = passwordTextField;
    [self.midView addSubview:passwordTextField];
}

 #pragma mark-QCheckBoxDelegate
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    
    if(checked==NO){
        NSLog(@"选中");
        isRemmeber=YES;
        [USER setBool:isRemmeber forKey:@"isRemmeber"];
        [USER synchronize];
        
        if([USER boolForKey:@"Login"]==NO){
            NSLog(@"第一次进入");
      
            return;
            
        }
        NSString*Account =[USER objectForKey:@"Account"];
        NSString*Password=[USER objectForKey:@"password"];
        self.usernameTextField.text=Account;
        self.passwordTextField.text=Password;

    }else {
        
         NSLog(@"未选中");
        isRemmeber=NO;
        [USER setBool:isRemmeber forKey:@"isRemmeber"];
        [USER synchronize];
        self.usernameTextField.text=@"";
        self.passwordTextField.text=@"";
    }
    
    
}

#pragma mark - 忘记密码
- (void)createForgetBtn
{
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(ScreenWidth - 100, CGRectGetMaxY(self.midView.frame) + PX_TO_PT(32), 90, PX_TO_PT(32));
    [forgetBtn addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:R_G_B_16(0x00ffc3) forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = XNRFont(16);
    self.forgetBtn = forgetBtn;
    [self.mainView addSubview:forgetBtn];
}

- (void)forgetClick:(UIButton *)button
{
    if (self.com) {
        self.com();
    }
    XNRForgetPasswordViewController *vc = [[XNRForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 创建登录
- (void)createLoginBtn
{
    UIButton *loginBtn = [MyControl createButtonWithFrame:CGRectMake(PX_TO_PT(32),CGRectGetMaxY(self.midView.frame) + PX_TO_PT(95), ScreenWidth-PX_TO_PT(64), PX_TO_PT(96)) ImageName:nil Target:self Action:@selector(loginClick:) Title:nil];
    loginBtn.backgroundColor = R_G_B_16(0x00b38a);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    [loginBtn setTitle:@"确认登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:R_G_B_16(0xfbfffe) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.loginBtn = loginBtn;
    [self.mainView addSubview:loginBtn];
}

#pragma mark - 注册
- (void)createRegisterBtn
{
    UIButton *registerBtn = [MyControl createButtonWithFrame:CGRectMake(0, CGRectGetMaxY(self.loginBtn.frame) + PX_TO_PT(90), ScreenWidth, 30) ImageName:nil Target:self Action:@selector(registerClick:) Title:nil];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.loginBtn.frame) + PX_TO_PT(90), ScreenWidth, 30)];
    titleLabel.textColor = R_G_B_16(0xffffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"还没有账号？立即注册";
    titleLabel.font = [UIFont systemFontOfSize:16];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:titleLabel.text];
    NSDictionary*dicStr = @{
                          NSForegroundColorAttributeName:R_G_B_16(0x00ffc3)
                          };
    
    [AttributedString addAttributes:dicStr range:NSMakeRange(6,4)];
    [titleLabel setAttributedText:AttributedString];
    [self.mainView addSubview:titleLabel];
    self.registerBtn = registerBtn;
    [self.mainView addSubview:registerBtn];
    
}

#pragma mark - 注册
- (void)registerClick:(UIButton *)button
{
    if (self.com) {
        self.com();
    }
    XNRRegisterViewController *vc = [[XNRRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 登录
- (void)loginClick:(UIButton *)button
{
    if (self.com) {
        self.com();
    }
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    int flag = 1;
    NSString *title;
    if ([self.usernameTextField.text isEqualToString:@""] || self.usernameTextField.text == nil) {
        flag = 0;
        title= @"用户名不能为空";
    }
    else if ([self.passwordTextField.text isEqualToString:@""] || self.passwordTextField.text == nil) {
        flag = 0;
        title= @"密码不能为空";
    }else if([self validateMobile:self.usernameTextField.text]==NO)
    {
        flag=0;
        title=@"手机格式错误";
       
    }else{
        
        [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:NO];
        [KSHttpRequest get:KUserPubkey parameters:nil success:^(id result) {
            NSLog(@"======%@",result);
            if ([result[@"code"] integerValue] == 1000) {
                NSString *pubKey = result[@"public_key"];
                self.pubKey = pubKey;
                [self getNetwork];
                NSLog(@"======%@",pubKey);
                
            }
            
        } failure:^(NSError *error) {
            
        }];

        
    }

    if (flag == 0) {
        
        [UILabel showMessage:title];
        
        [BMProgressView LoadViewDisappear:self.view];
        
        return;
    }
}

-(void)getNetwork
{
    // 加密
    NSString *passWord = self.passwordTextField.text;
    NSString *encryptPassword = [GBAlipayManager encryptString:passWord publicKey:self.pubKey];
    NSString *encode = [KUserLogin stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [KSHttpRequest post:encode parameters:@{@"account":self.usernameTextField.text,@"password":encryptPassword,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000){
            [BMProgressView LoadViewDisappear:self.view];
            //本地归档保存用户账户信息
            NSDictionary *datasDic = result[@"datas"];
            NSDictionary *address = datasDic[@"userAddress"];
            NSDictionary *city = address[@"city"];
            NSDictionary *province = address[@"province"];
            NSDictionary *county = address[@"county"];
            NSDictionary *town = address[@"town"];

            UserInfo *info = [DataCenter account];
            [info setValuesForKeysWithDictionary:datasDic];
            info.loginState = YES;
            info.password = self.passwordTextField.text;
            info.token = result[@"token"];
            info.photo = datasDic[@"photo"];
            info.province = province[@"name"];
            info.city = city[@"name"];
            info.county = county[@"name"];
            info.town = town[@"name"];
            info.cartId = datasDic[@"cartId"];
            [DataCenter saveAccount:info];
            
             //上传购物车数据
            DatabaseManager *dataM = [DatabaseManager sharedInstance];
            if ([[dataM queryAllGood] count]> 0) {
                
                for (XNRShoppingCartModel *model in [dataM queryAllGood]) {
                    [self synchShoppingCarDataWith:model];
                }
                
                [dataM deleteShoppingCar];
            }
            
            
            //发送刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PageRefresh" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyAccount" object:nil];
            // 判断资料是否完善
            if ([datasDic[@"isUserInfoFullFilled"] integerValue] == 0) {
                XNRFinishMineDataController *fmdc = [[XNRFinishMineDataController alloc] init];
                fmdc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fmdc animated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        
        }else{
            
            [UILabel showMessage:result[@"message"]];
            [BMProgressView LoadViewDisappear:self.view];

            
        }
    } failure:^(NSError *error) {
        
        [UILabel showMessage:@"登录失败"];
        [BMProgressView LoadViewDisappear:self.view];

    }];


}

#pragma mark - 上传购物车数据
- (void)synchShoppingCarDataWith:(XNRShoppingCartModel *)model
{
    NSDictionary *params = @{@"SKUId":model._id?model._id:@"",@"userId":[DataCenter account].userid,@"quantity":@"1",@"update_by_add":@"true",@"user-agent":@"IOS-v2.0"};
    NSLog(@"--=0=9%@",params);
    [KSHttpRequest post:KAddToCart parameters:params success:^(id result) {
        NSLog(@"%@",result);
        
        if([result[@"code"] integerValue] == 1000){

        }else {
            
            [UILabel showMessage:result[@"message"]];
            [BMProgressView LoadViewDisappear:self.view];

        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark - 正则表达式判断手机号格式
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark - 键盘躲避
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:self.usernameTextField inputView:nil name:@"" insetBottom:0];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.passwordTextField inputView:nil name:@"" insetBottom:0];
        return @[tfm1,tfm2];
        
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [CoreTFManagerVC uninstallManagerForVC:self];
    
}

//消失时回收键盘
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
