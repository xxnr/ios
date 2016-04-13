////
////  XNROffLine_VC.m
////  xinnongreniOS
////
////  Created by 杨宁 on 16/4/13.
////  Copyright © 2016年 qxhiOS. All rights reserved.
////
//
//#import "XNROffLine_VC.h"
//#import "XNRCheckOrderVC.h"
//#import "XNRMyOrder_VC.h"
//#import "XNRRSCInfoModel.h"
//@interface XNROffLine_VC ()
//@property (nonatomic,weak)UIView *topView;
//@property (nonatomic,weak)UIView *midView;
//@property (nonatomic,weak)UIView *bottomView;
//@end
//
//@implementation XNROffLine_VC
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = R_G_B_16(0xFAFAFA);
//    
//    [self setNav];
//    
//    [self createTop];
//    [self createCenter];
//    [self createBtn];
//    
//}
//-(void)createTop
//{
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(180))];
//    topView.backgroundColor = [UIColor whiteColor];
//    self.topView = topView;
//    [self.view addSubview:topView];
//    
////    UIImageView *imageView = [UIImageView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//}
//-(void)getServiceData
//{
//    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
//        if ([result[@"code"] integerValue] == 1000) {
//            
//            [XNRRSCInfoModel objectWithKeyValues:result[@"rows"][@"RSCInfo"]];
//
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        
//    }];
//    
//
//}
//-(void)createCenter
//{
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(123), PX_TO_PT(170), PX_TO_PT(140), PX_TO_PT(140))];
//    imageView.image = [UIImage imageNamed:@"pay-right-btn"];
//    [self.view addSubview:imageView];
//    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(311), PX_TO_PT(185), PX_TO_PT(290), PX_TO_PT(35))];
//    label.text = @"您已完成本次支付";
//    label.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
//    label.textColor = R_G_B_16(0x00B38A);
//    [self.view addSubview:label];
//    
//    UILabel *payMoney = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(311), PX_TO_PT(244), PX_TO_PT(350), PX_TO_PT(27))];
//    float f = [self.money doubleValue];
//    payMoney.text = [NSString stringWithFormat:@"支付金额：¥%.2f元",f];
//    payMoney.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
//    [self.view addSubview:payMoney];
//    
//}
//-(void)createBtn
//{
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(149), PX_TO_PT(440), PX_TO_PT(181), PX_TO_PT(61))];
//    [leftBtn setTitle:@"返回订单列表" forState:UIControlStateNormal];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
//    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [leftBtn setBackgroundColor:R_G_B_16(0xFDA940)];
//    leftBtn.layer.cornerRadius = 6;
//    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:leftBtn];
//    
//    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(389), PX_TO_PT(440), PX_TO_PT(181), PX_TO_PT(61))];
//    [rightBtn setTitle:@"查看该笔订单" forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn setBackgroundColor:R_G_B_16(0xFDA940)];
//    rightBtn.layer.cornerRadius = 6;
//    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:rightBtn];
//    
//}
//
//- (void)rightBtnClick:(UIButton *)button
//{
//    NSLog(@"查看订单");
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"succss_Push" object:nil];
//    XNRCheckOrderVC*vc=[[XNRCheckOrderVC alloc]init];
//    vc.hidesBottomBarWhenPushed=YES;
//    vc.orderID = self.orderID;
//    vc.orderNO = self.paymentId;
//    vc.myOrderType = @"确认订单";
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}
//
//#pragma mark  - 设置导航
//- (void)setNav
//{
//    self.navigationItem.title = @"线下支付";
//    
//    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    backButton.frame=CGRectMake(0, 0, 80, 44);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
//    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchDown];
//    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
//    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem=leftItem;
//    
//    
//    UIButton *seeOrderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    seeOrderBtn.frame=CGRectMake(PX_TO_PT(560), 0, ScreenWidth - PX_TO_PT(560), 44);
//    seeOrderBtn.titleLabel.text = @"查看订单";
//    seeOrderBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
//    seeOrderBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 34);
//    [seeOrderBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchDown];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:seeOrderBtn];
//    self.navigationItem.rightBarButtonItem=rightItem;
//}
//
//- (void)backClick:(UIButton *)btn
//{
//    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadOrderList" object:nil];
//    
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[XNRMyOrder_VC class]]) {
//            [self.navigationController popToViewController:vc animated:YES];
//            return;
//        }
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
