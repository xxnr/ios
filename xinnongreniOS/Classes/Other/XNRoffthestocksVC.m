//
//  XNRoffthestocksVC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/5/16.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRoffthestocksVC.h"


#import "XNRCheckOrderVC.h"
#import "XNRMyOrder_VC.h"
#import "XNRProductInfo_VC.h"
@interface XNRoffthestocksVC ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation XNRoffthestocksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = R_G_B_16(0xFAFAFA);
    [self setNav];
    [self createCenter];
    [self createBtn];
}

-(void)createCenter
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(159), PX_TO_PT(160), PX_TO_PT(140), PX_TO_PT(140))];
    imageView.image = [UIImage imageNamed:@"pay-right-btn"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(347), PX_TO_PT(213), PX_TO_PT(290), PX_TO_PT(35))];
    label.text = @"订单已支付";
    label.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    label.textColor = R_G_B_16(0x323232);
    [self.view addSubview:label];
}
-(void)createBtn
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(149), PX_TO_PT(400), PX_TO_PT(181), PX_TO_PT(61))];
    [leftBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [leftBtn setTitleColor:R_G_B_16(0x00B38A) forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor whiteColor]];
    leftBtn.layer.cornerRadius = 6;
    leftBtn.layer.borderWidth = 1;
    leftBtn.layer.borderColor = [R_G_B_16(0x00B38A) CGColor];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(389), PX_TO_PT(400), PX_TO_PT(181), PX_TO_PT(61))];
    [rightBtn setTitle:@"回到首页" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [rightBtn setTitleColor:R_G_B_16(0x00B38A) forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    rightBtn.layer.cornerRadius = 6;
    rightBtn.layer.borderWidth = 1;
    rightBtn.layer.borderColor = [R_G_B_16(0x00B38A) CGColor];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:rightBtn];
}


-(void)leftBtnClick:(UIButton *)button
{
    NSLog(@"查看订单");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"succss_Push" object:nil];
    XNRCheckOrderVC*vc=[[XNRCheckOrderVC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.orderID = self.orderID;
    vc.myOrderType = @"确认订单";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)rightBtnClick:(UIButton *)button
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    if ([self.navigationController.viewControllers firstObject].presentedViewController == nil) {
//        XNRTabBarController *tabVC = (XNRTabBarController *)window.rootViewController;
//        tabVC.selectedIndex = 0;
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    window.rootViewController = [[XNRTabBarController alloc]init];
    [window makeKeyAndVisible];

}

#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"订单已支付";
    
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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadOrderList" object:nil];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XNRMyOrder_VC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XNRProductInfo_VC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
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
