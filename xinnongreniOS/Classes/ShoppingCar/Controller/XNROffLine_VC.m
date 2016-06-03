//
//  XNROffLine_VC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/13.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNROffLine_VC.h"
#import "XNRCheckOrderSectionModel.h"
#import "XNRCheckOrderVC.h"
#import "XNRMyOrder_VC.h"
#import "XNRRSCInfoModel.h"
#import "XNROfflinePayTypeModel.h"
#import "XNRProductInfo_VC.h"
@interface XNROffLine_VC ()
@property (nonatomic,weak)UIView *topView;
@property (nonatomic,weak)UIView *midView;
@property (nonatomic,weak)UIView *bottomView;
@property (nonatomic,strong)NSMutableArray *PayTypeArr;
@property (nonatomic,strong)XNRRSCInfoModel *model;
@end

@implementation XNROffLine_VC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = R_G_B_16(0xFAFAFA);
    
    [self setNav];
    [self getServiceData];

}
-(void)createTop
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(180))];
    topView.backgroundColor = [UIColor whiteColor];
    self.topView = topView;
    [self.view addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(40), PX_TO_PT(103), PX_TO_PT(100))];
    imageView.image = [UIImage imageNamed:@"offline_payment2"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:imageView];
    
    UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + PX_TO_PT(67), PX_TO_PT(52), PX_TO_PT(300), PX_TO_PT(32))];
    successLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    successLabel.text = @"线下支付提交成功!";
    successLabel.textColor = R_G_B_16(0x646464);
    [topView addSubview:successLabel];
    
    UILabel *holdMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+PX_TO_PT(67), CGRectGetMaxY(successLabel.frame)+PX_TO_PT(18), ScreenWidth-CGRectGetMaxX(imageView.frame)-PX_TO_PT(67), PX_TO_PT(32))];
    holdMoneyLabel.text = [NSString stringWithFormat:@"待支付金额：¥%.2f",[self.holdPayMoney floatValue]];
    holdMoneyLabel.textColor = R_G_B_16(0xFF4E00);
    holdMoneyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:holdMoneyLabel.text];
    NSDictionary *depositStr=@{
                               NSForegroundColorAttributeName:R_G_B_16(0x646464),
                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(28)]
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(0,6)];
    [holdMoneyLabel setAttributedText:AttributedStringDeposit];
    [topView addSubview:holdMoneyLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(178), ScreenWidth, PX_TO_PT(2))];
    line.backgroundColor = R_G_B_16(0xE0E0E0);
    [topView addSubview:line];
}
-(void)createCenter
{
    [self.midView removeFromSuperview];

    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.topView.frame)+PX_TO_PT(25), ScreenWidth, PX_TO_PT(30))];
    headLabel.text = @"请到服务网点完成线下支付";
    headLabel.textColor = R_G_B_16(0x646464);
    headLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    [self.view addSubview:headLabel];
    
    UIView *midView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headLabel.frame)+PX_TO_PT(32), ScreenWidth, PX_TO_PT(400))];
    midView.backgroundColor = [UIColor whiteColor];

    self.midView = midView;
    [self.view addSubview:_midView];
    NSArray *titleNameArr = @[@"服务网点",@"网点名称",@"地址",@"电话"];
    NSArray *detailArr = @[@" ",self.model.companyName,self.model.RSCAddress,self.model.RSCPhone];
    CGFloat maxY = PX_TO_PT(0);
    for (int i=0; i<4; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), maxY+PX_TO_PT(29), PX_TO_PT(130), PX_TO_PT(30))];
        titleLabel.text = titleNameArr[i];
        titleLabel.textColor = R_G_B_16(0x646464);
        titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        
        NSString *str = detailArr[i];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(32)] constrainedToSize:CGSizeMake(PX_TO_PT(500), MAXFLOAT)];
        
        UILabel *DetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+PX_TO_PT(29), maxY+PX_TO_PT(29), PX_TO_PT(500), size.height)];
        DetailLabel.text = str;
        DetailLabel.textColor = R_G_B_16(0x323232);
        DetailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        DetailLabel.numberOfLines = 0;
        [midView addSubview:DetailLabel];
        [midView addSubview:titleLabel];
        
        maxY = CGRectGetMaxY(DetailLabel.frame)+PX_TO_PT(28);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, maxY+1, ScreenWidth, PX_TO_PT(1))];
        line.backgroundColor = R_G_B_16(0xE0E0E0);
        [midView addSubview:line];
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(1), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [midView addSubview:line];

    midView.frame = CGRectMake(0, CGRectGetMaxY(headLabel.frame)+PX_TO_PT(32), ScreenWidth, maxY);
    
}

-(void)createEmptyCenter
{
    [self.midView removeFromSuperview];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.topView.frame)+PX_TO_PT(25), ScreenWidth, PX_TO_PT(30))];
    headLabel.text = @"请到服务网点完成线下支付";
    headLabel.textColor = R_G_B_16(0x646464);
    headLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    [self.view addSubview:headLabel];
    
    UIView *midView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headLabel.frame)+PX_TO_PT(32), ScreenWidth, PX_TO_PT(400))];
    midView.backgroundColor = [UIColor whiteColor];
    self.midView = midView;
    [self.view addSubview:_midView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(30), PX_TO_PT(130), PX_TO_PT(30))];
    titleLabel.text = @"服务网点";
    titleLabel.textColor = R_G_B_16(0x646464);
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    
    [midView addSubview:titleLabel];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(90), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xE0E0E0);
    [midView addSubview:line];
    
    UIImageView *emptyimageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(297), CGRectGetMaxY(line.frame)+PX_TO_PT(58), PX_TO_PT(126), PX_TO_PT(116))];
    emptyimageView.image = [UIImage imageNamed:@"branches-0"];
    emptyimageView.contentMode = UIViewContentModeScaleAspectFit;
    [midView addSubview:emptyimageView];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(emptyimageView.frame)+PX_TO_PT(58), ScreenWidth, PX_TO_PT(30))];
    detailLabel.text = @"小新正在为您匹配最近的网点,请稍后从我的订单查看";
    detailLabel.textColor = R_G_B_16(0x909090);
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    
    [midView addSubview:detailLabel];
    
    for (int i=0; i<2; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(394)*i, ScreenWidth, PX_TO_PT(1))];
        line.backgroundColor = R_G_B_16(0xe0e0e0);
        [midView addSubview:line];
    }
    
}


-(void)getServiceData
{
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            
            XNRCheckOrderSectionModel *orderModel = [XNRCheckOrderSectionModel objectWithKeyValues:result[@"datas"][@"rows"]];
            self.holdPayMoney = orderModel.duePrice;
            
            [self createTop];

            if (orderModel.RSCInfo.count != 0) {
                self.model = [XNRRSCInfoModel objectWithKeyValues:orderModel.RSCInfo];
                [self createCenter];
            }
            else
            {
                [self createEmptyCenter];
            }
            [self getPayTypeData];

        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    

}
-(void)getPayTypeData
{
    [KSHttpRequest get:KGetOfflinePayType parameters:nil success:^(id result) {
        if ([result[@"code"]integerValue] == 1000) {
            self.PayTypeArr = (NSMutableArray *)[XNROfflinePayTypeModel objectArrayWithKeyValuesArray:result[@"offlinePayType"]];
            [self createBottom];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)createBottom
{
    [self.bottomView removeFromSuperview];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.midView.frame)+PX_TO_PT(19), ScreenWidth, PX_TO_PT(270))];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    [self.view addSubview:_bottomView];
    
    UILabel *payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(30), ScreenWidth, PX_TO_PT(30))];
    payTypeLabel.text = @"付款方式";
    payTypeLabel.textColor = R_G_B_16(0x646464);
    payTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [bottomView addSubview:payTypeLabel];
    
    for (int i=0; i<2; i++) {
        UILabel *payTypedetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32),  PX_TO_PT(90)*(i+1)+PX_TO_PT(30), ScreenWidth, PX_TO_PT(30))];
        XNROfflinePayTypeModel *model = self.PayTypeArr[i];
        payTypedetailLabel.text = model.name;
        payTypedetailLabel.textColor = R_G_B_16(0x323232);
        payTypedetailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        [bottomView addSubview:payTypedetailLabel];
    }
    
    for (int i=0; i<4; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(90)*i, ScreenWidth, PX_TO_PT(2))];
        line.backgroundColor = R_G_B_16(0xe0e0e0);
        [bottomView addSubview:line];
    }
    
}
- (void)rightBtnClick:(UIButton *)button
{
    NSLog(@"查看订单");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"succss_Push" object:nil];
    XNRCheckOrderVC*vc=[[XNRCheckOrderVC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.orderID = self.orderID;
//    vc.orderNO = self.paymentId;
    vc.myOrderType = @"确认订单";
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark  - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"线下支付";
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchDown];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
    UIButton *seeOrderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    seeOrderBtn.frame=CGRectMake(PX_TO_PT(560), 0, ScreenWidth - PX_TO_PT(560), 44);
    [seeOrderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    seeOrderBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    seeOrderBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -34);
    [seeOrderBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:seeOrderBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

- (void)backClick:(UIButton *)btn
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadOrderList" object:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"serveHeadRefresh" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"payHeadRefresh" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendHeadRefresh" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reciveHeadRefresh" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentHeadRefresh" object:self];

    if ([self.fromType isEqualToString:@"orderList"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
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
