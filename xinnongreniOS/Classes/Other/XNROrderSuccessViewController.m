//
//  XNROrderSuccessViewController.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNROrderSuccessViewController.h"
#import "XNRCheckOrderVC.h"
#import "XNRMyOrder_VC.h"
#import "XNRProductInfo_VC.h"
@interface XNROrderSuccessViewController ()

@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UIButton *leftBtn;
//@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation XNROrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = R_G_B_16(0xFAFAFA);
//    [self getData];
    
    [self setNav];

    [self createCenter];
    [self createBtn];
}

//-(void)getData
//{
//    [KSHttpRequest get:KAlipaySuccess parameters:nil success:^(id result) {
//        
//        NSLog(@"%@",result);
//    } failure:^(NSError *error) {
//        
//    }];
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.orderID forKey:@"orderId"];
    
//    NSNotification *notification = [NSNotification notificationWithName:@"deleteModel" object:nil userInfo:dic];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
   
}
-(void)createCenter
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(123), PX_TO_PT(170), PX_TO_PT(140), PX_TO_PT(140))];
    imageView.image = [UIImage imageNamed:@"pay-right-btn"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(311), PX_TO_PT(185), PX_TO_PT(290), PX_TO_PT(35))];
    label.text = @"您已完成本次支付";
    label.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    label.textColor = R_G_B_16(0x00B38A);
    [self.view addSubview:label];
    
    UILabel *payMoney = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(311), PX_TO_PT(244), PX_TO_PT(350), PX_TO_PT(27))];
    float f = [self.money doubleValue];
    payMoney.text = [NSString stringWithFormat:@"支付金额：¥%.2f元",f];
    payMoney.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [self.view addSubview:payMoney];

}
-(void)createBtn
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(149), PX_TO_PT(440), PX_TO_PT(181), PX_TO_PT(61))];
    [leftBtn setTitle:@"返回订单列表" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:R_G_B_16(0xFDA940)];
    leftBtn.layer.cornerRadius = 6;
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(389), PX_TO_PT(440), PX_TO_PT(181), PX_TO_PT(61))];
    [rightBtn setTitle:@"查看该笔订单" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:R_G_B_16(0xFDA940)];
    rightBtn.layer.cornerRadius = 6;
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:rightBtn];

}


-(void)leftBtnClick:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"succss_Push" object:nil];
    XNRMyOrder_VC *orderVC=[[XNRMyOrder_VC alloc]init];
    orderVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:orderVC animated:NO];
}

- (void)rightBtnClick:(UIButton *)button
{
    NSLog(@"查看订单");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"succss_Push" object:nil];
    XNRCheckOrderVC*vc=[[XNRCheckOrderVC alloc]init];
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
    self.navigationItem.title = @"支付完成";
    
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
    
//    NSNotification *notification = [[NSNotification alloc]initWithName:@"reloadOrderList" object:nil userInfo:nil];

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
