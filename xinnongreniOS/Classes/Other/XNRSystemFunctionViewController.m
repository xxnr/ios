//
//  XNRSystemFunctionViewController.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//  系统功能

#import "XNRSystemFunctionViewController.h"
#import "XNRLoginViewController.h"
#import "XNRAboutUs_VC.h"
@interface XNRSystemFunctionViewController ()<UIActionSheetDelegate>
{
    UIView *_versionBg;
    UIView *_aboutUsBg;
    UIView*_quiteBg;
}

@property (nonatomic,strong) UIButton *versionBtn;
@property (nonatomic,strong) UIButton *aboutUsBtn;
@property (nonatomic,strong) UIButton *quiteBtn;
@end

@implementation XNRSystemFunctionViewController

- (void)viewWillAppear:(BOOL)animated
{
//    if (IS_Login) {
//        _quiteBg.hidden = NO;
//    }else{
        _quiteBg.hidden = YES;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    [self setNav];
    //关于我们
    // [self createAboutUsBtn];
    //退出登录
    [self createQuiteLogin];
        
}

#pragma mark--我们

//我们

- (void)createAboutUsBtn
{
    _aboutUsBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    _aboutUsBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_aboutUsBg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, _aboutUsBg.frame.size.height)];
    label.textColor = [UIColor blackColor];
    label.text = @"关于我们";
    label.font = XNRFont(18);
    [_aboutUsBg addSubview:label];
    
    UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectMake(ScreenWidth-20-10, (45-18)/2.0, 10, 18) ImageName:@"nextArrow"];
    [_aboutUsBg addSubview:imageView];
    
    _aboutUsBtn = [MyControl createButtonWithFrame:_aboutUsBg.bounds ImageName:nil Target:self Action:@selector(aboutUsBtnClick:) Title:nil];
    [_aboutUsBg addSubview:_aboutUsBtn];
}

- (void)aboutUsBtnClick:(UIButton *)button
{
    NSLog(@"关于我们");
    XNRAboutUs_VC*vc=[[XNRAboutUs_VC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--退出登录
-(void)createQuiteLogin{
    _quiteBg = [[UIView alloc]initWithFrame:CGRectMake(0, _aboutUsBg.frame.origin.y+_aboutUsBg.frame.size.height+5, ScreenWidth, 45)];
    _quiteBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_quiteBg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, _aboutUsBg.frame.size.height)];
    label.textColor = [UIColor blackColor];
    label.text = @"退出登录";
    label.font = XNRFont(18);
    [_quiteBg addSubview:label];
    
    UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectMake(ScreenWidth-20-10, (45-18)/2.0, 10, 18) ImageName:@"nextArrow"];
    [_quiteBg addSubview:imageView];
    
    _quiteBtn = [MyControl createButtonWithFrame:_quiteBg.bounds ImageName:nil Target:self Action:@selector(QuiteLogin) Title:nil];
    [_quiteBg addSubview:_quiteBtn];
    
}

-(void)QuiteLogin{
    
    NSLog(@"退出登录");
    UIActionSheet*ac=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出当前账号" otherButtonTitles: nil];
    [ac showInView:self.view];
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        //本地用户信息状态设为非登录
        UserInfo *infos = [[UserInfo alloc]init];
        infos.loginState = NO;
        [DataCenter saveAccount:infos];
        
        //发送刷新通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageRefresh" object:nil];
        
        XNRLoginViewController *vc = [[XNRLoginViewController alloc]init];
        
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:^{
            [self.navigationController popViewControllerAnimated:NO];
        }];
        
    }
    
}

#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"系统功能";
    
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
