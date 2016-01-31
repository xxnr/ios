//
//  XNROrderSuccessViewController.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNROrderSuccessViewController.h"
#import "XNRCheckOrder_VC.h"
@interface XNROrderSuccessViewController ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation XNROrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    [self createTitle];
    [self createLeftBtn];
    [self createRightBtn];
}

- (void)createTitle
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, 35)];
    self.titleLabel.text = @"您的订单成功";
    self.titleLabel.font = XNRFont(26);
    self.titleLabel.textColor = R_G_B_16(0x00bc00);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
}

- (void)createLeftBtn
{
    self.leftBtn = [MyControl createButtonWithFrame:CGRectMake(35, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+50, (ScreenWidth-100)/2.0, 35) ImageName:nil Target:self Action:@selector(leftBtnClick:) Title:@"联系客服"];
    self.leftBtn.backgroundColor = R_G_B_16(0xed2a4a);
    self.leftBtn.layer.masksToBounds = YES;
    self.leftBtn.layer.cornerRadius = 5;
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.leftBtn];
}

- (void)leftBtnClick:(UIButton *)button
{
    NSLog(@"联系客服");
    
    
    if(TARGET_IPHONE_SIMULATOR){
        
        [UILabel showMessage:@"必须真机环境"];
        
    }else{

    UIWebView*phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
   
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"4000560371"]];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    [self.view addSubview:phoneCallWebView];
    
    
    }
    
}

- (void)createRightBtn
{
    self.rightBtn = [MyControl createButtonWithFrame:CGRectMake(self.leftBtn.frame.origin.x+self.leftBtn.frame.size.width+30, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+50, (ScreenWidth-100)/2.0, 35) ImageName:nil Target:self Action:@selector(rightBtnClick:) Title:@"查看订单"];
    self.rightBtn.backgroundColor = R_G_B_16(0x696969);
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 5;
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.rightBtn];
}

- (void)rightBtnClick:(UIButton *)button
{
    NSLog(@"查看订单");
    
    XNRCheckOrder_VC*vc=[[XNRCheckOrder_VC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.orderID = self.orderID;
    vc.orderNO = self.paymentId;
    vc.myOrderType = @"确认订单";
//    vc.recieveName = self.recieveName;
//    vc.recievePhone = self.recievePhone;
//    vc.recieveAddress = self.recieveAddress;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"订单成功";
    
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
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];

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
