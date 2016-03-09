//
//  XNRPayOrder_VC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/3.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRPayOrder_VC.h"

@interface XNRPayOrder_VC ()

@end

@implementation XNRPayOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self setTop];
    // Do any additional setup after loading the view from its nib.
}

-(void)setTop
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(126))];
    [self.view addSubview:topView];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形背景1"]];
    bgImageView.frame = topView.frame;
    [topView addSubview:bgImageView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(25), ScreenWidth, PX_TO_PT(30))];
    label1.text = @"为了让您更快的收到商品，系统已为您拆分了订单";
    label1.textColor = R_G_B_16(0xfe9b00);
    label1.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [topView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(75), ScreenWidth, PX_TO_PT(30))];
    label2.text = @"您可选择此次支付订单，其他订单请到我的新农人继续支付。";
    label2.textColor = R_G_B_16(0xfe9b00);
    label2.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [topView addSubview:label2];

}

//-(void)setMiddle
//{
//    UIView view =
//}
#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"选择支付订单";
    
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


@end
