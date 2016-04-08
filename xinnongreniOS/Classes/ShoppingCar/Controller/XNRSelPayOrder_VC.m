//
//  XNRSelPayOrder_VC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/3.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSelPayOrder_VC.h"
#import "XNRCheckOrderSectionModel.h"
#import "XNRCheckOrderModel.h"
#import "XNROrderInfo_VC.h"
#import "XNRPayType_VC.h"
#import "XNRShoppingCarController.h"
@interface XNRSelPayOrder_VC ()
@property (weak, nonatomic) UIView *topView;
@property (weak, nonatomic) UIView *midView;
@property (weak, nonatomic) UIView *bottomView;
@property (weak, nonatomic) UILabel *orderIDLabel1;
@property (weak, nonatomic) UILabel *orderIDLabel2;
@property (weak, nonatomic) UILabel *payType1;
@property (weak, nonatomic) UILabel *payType2;
@property (weak, nonatomic) UILabel *holdPayLabel1;
@property (weak, nonatomic) UILabel *holdPayLabel2;
@property (weak, nonatomic) UILabel *totalMoneyLabel1;
@property (weak, nonatomic) UILabel *totalMoneyLabel2;
@property (weak, nonatomic) UILabel *orderDetailLabel1;
@property (weak, nonatomic) UILabel *orderDetailLabel2;
@property (weak, nonatomic) UIButton *payButton1;
@property (weak, nonatomic) UIButton *payButton2;
@property (weak, nonatomic) UIView *bgView1;

@property (weak, nonatomic) UIView *bgView2;
@property (weak, nonatomic) UIView *line1;
@property (weak, nonatomic) UIView *line2;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) NSString *paySubOrderType;//本次付款的字订单类型

@property (nonatomic, strong) NSMutableString *str1;
@property (nonatomic, strong) NSMutableString *str2;
@end


@implementation XNRSelPayOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setNav];
    [self createMidView];
    [self setTop];
    [self setButton];
    [self getData1];
    [self getData2];
    self.str1 = [NSMutableString string];
    self.str2 = [NSMutableString string];

    // Do any additional setup after loading the view from its nib.
}
-(void)createMidView
{
    self.view.backgroundColor = R_G_B_16(0xf9f9f9);
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(126))];
    self.topView = topView;
    [self.view addSubview:topView];
    
    UIView *midView = [[UIView alloc]initWithFrame: CGRectMake(0, CGRectGetMaxY(self.topView.frame) + PX_TO_PT(14), ScreenWidth, PX_TO_PT(410))];
    midView.backgroundColor = [UIColor whiteColor];
    self.midView = midView;
    [self.view addSubview:midView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.midView.frame) + PX_TO_PT(20), ScreenWidth, PX_TO_PT(410))];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];

    UIView *bgView1 = [[UIView alloc]initWithFrame: CGRectMake(0,0, ScreenWidth, PX_TO_PT(80))];
    bgView1.backgroundColor = R_G_B_16(0xF0F0F0);
    [self.midView addSubview:bgView1];
    
    
    UILabel *orderIDLabel1 = [[UILabel alloc]initWithFrame: CGRectMake(PX_TO_PT(31), PX_TO_PT(24), ScreenWidth, PX_TO_PT(35))];
    orderIDLabel1.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    orderIDLabel1.textColor = R_G_B_16(0x323232);
    self.orderIDLabel1 = orderIDLabel1;
    [bgView1 addSubview:orderIDLabel1];
    
    UILabel *payType1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(24), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(27))];
    payType1.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payType1.textColor = R_G_B_16(0x646464);
    self.payType1 = payType1;
    [self.midView addSubview:payType1];
    
    UILabel *holdPayLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(bgView1.frame)+PX_TO_PT(28), ScreenWidth, PX_TO_PT(30))];
    holdPayLabel1.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    holdPayLabel1.textColor = R_G_B_16(0x323232);
    self.holdPayLabel1 = holdPayLabel1;
    [self.midView addSubview:holdPayLabel1];
    
    
    UILabel *totalMoneyLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(self.holdPayLabel1.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(30))];
    totalMoneyLabel1.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    totalMoneyLabel1.textColor = R_G_B_16(0x323232);
    self.totalMoneyLabel1 = totalMoneyLabel1;
    [self.midView addSubview:totalMoneyLabel1];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(self.totalMoneyLabel1.frame) + PX_TO_PT(27), ScreenWidth - PX_TO_PT(62), PX_TO_PT(2))];
    line1.backgroundColor = R_G_B_16(0xC7C7C7);
    [self.midView addSubview:line1];
    
    UIView *detailView0 = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31),CGRectGetMaxY(line1.frame) + PX_TO_PT(12), ScreenWidth - PX_TO_PT(62), PX_TO_PT(80))];
    detailView0.backgroundColor = R_G_B_16(0xF8F8F8);
    [self.midView addSubview:detailView0];
    
    UILabel *orderdetail0 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(26), detailView0.width - PX_TO_PT(60), PX_TO_PT(28))];
    orderdetail0.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    orderdetail0.textColor = R_G_B_16(0x646464);
    self.orderDetailLabel1 = orderdetail0;
    [detailView0 addSubview:orderdetail0];

    UIButton *payButton1 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(133)-PX_TO_PT(32), CGRectGetMaxY(detailView0.frame) + PX_TO_PT(19), PX_TO_PT(133), PX_TO_PT(60))];
    [payButton1 setTitle:@"去支付" forState:UIControlStateNormal];
    payButton1.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payButton1.backgroundColor = R_G_B_16(0xFE9B00);
    [payButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton1 addTarget:self action:@selector(pay1Btn:) forControlEvents:UIControlEventTouchDown];
    self.payButton1 = payButton1;
    [self.midView addSubview:payButton1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payButton1.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(1))];
    line2.backgroundColor = R_G_B_16(0xC7C7C7);
    [self.midView addSubview:line2];
    
    UIView *bgView2 = [[UIView alloc]initWithFrame: CGRectMake(0,0, ScreenWidth, PX_TO_PT(80))];
    bgView2.backgroundColor = R_G_B_16(0xF0F0F0);
    [self.bottomView addSubview:bgView2];
    
    
    UILabel *orderIDLabel2 = [[UILabel alloc]initWithFrame: CGRectMake(PX_TO_PT(31), PX_TO_PT(24), ScreenWidth, PX_TO_PT(35))];
    orderIDLabel2.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    orderIDLabel2.textColor = R_G_B_16(0x323232);
    self.orderIDLabel2 = orderIDLabel2;
    [bgView2 addSubview:orderIDLabel2];
    
    UILabel *payType2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(24), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(27))];
    payType2.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payType2.textColor = R_G_B_16(0x646464);

    self.payType2 = payType2;
    [self.bottomView addSubview:payType2];
    
    UILabel *holdPayLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(bgView2.frame)+PX_TO_PT(28), ScreenWidth, PX_TO_PT(30))];
    holdPayLabel2.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    holdPayLabel2.textColor = R_G_B_16(0x323232);
    self.holdPayLabel2 = holdPayLabel2;
    [self.bottomView addSubview:holdPayLabel2];
    
    
    UILabel *totalMoneyLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(self.holdPayLabel2.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(30))];
    totalMoneyLabel2.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    totalMoneyLabel2.textColor = R_G_B_16(0x323232);
    self.totalMoneyLabel2 = totalMoneyLabel2;
    [self.bottomView addSubview:totalMoneyLabel2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(self.totalMoneyLabel2.frame) + PX_TO_PT(26), ScreenWidth - PX_TO_PT(62), PX_TO_PT(2))];
    line3.backgroundColor = R_G_B_16(0xC7C7C7);
    [self.bottomView addSubview:line3];
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31),CGRectGetMaxY(line3.frame) + PX_TO_PT(12), ScreenWidth - PX_TO_PT(62), PX_TO_PT(80))];
    detailView.backgroundColor = R_G_B_16(0xF8F8F8);
    [self.bottomView addSubview:detailView];
    
    UILabel *orderdetail = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(26), detailView.width - PX_TO_PT(60), PX_TO_PT(28))];
    orderdetail.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    orderdetail.textColor = R_G_B_16(0x646464);
    self.orderDetailLabel2 = orderdetail;
    [detailView addSubview:orderdetail];
    
    UIButton *payButton2 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(133) - PX_TO_PT(32), CGRectGetMaxY(detailView.frame) + PX_TO_PT(19), PX_TO_PT(133), PX_TO_PT(60))];
    [payButton2 setTitle:@"去支付" forState:UIControlStateNormal];
    payButton2.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payButton2.backgroundColor = R_G_B_16(0xFE9B00);
    [payButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton2 addTarget:self action:@selector(pay2Btn:) forControlEvents:UIControlEventTouchDown];
    self.payButton2 = payButton2;
    [self.bottomView addSubview:payButton2];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payButton2.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(1))];
    line4.backgroundColor = R_G_B_16(0xC7C7C7);
    [self.bottomView addSubview:line4];

    detailView0.layer.cornerRadius = 10;
    detailView.layer.cornerRadius = 10;
    detailView.layer.masksToBounds = YES;
    detailView0.layer.masksToBounds = YES;
    self.payType1.textAlignment = UITextAlignmentRight;
    self.payType2.textAlignment = UITextAlignmentRight;


}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//设置圆角button
-(void)setButton
{
    self.payButton1.layer.cornerRadius = 5;
    self.payButton2.layer.cornerRadius = 5;
}
-(void)setTop
{
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形背景1"]];
    
    bgImageView.frame = self.topView.frame;
    [self.topView addSubview:bgImageView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(25), ScreenWidth, PX_TO_PT(30))];
    label1.text = @"为了让您更快的收到商品，系统已为您拆分了订单";
    label1.textColor = R_G_B_16(0xfe9b00);
    label1.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [self.topView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(70), ScreenWidth, PX_TO_PT(30))];
    label2.text = @"您可选择此次支付订单，其他订单请到我的新农人继续支付。";
    label2.textColor = R_G_B_16(0xfe9b00);
    label2.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [self.topView addSubview:label2];
    
}

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

    //返回到购物车页面
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XNRShoppingCarController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    

}

- (void)pay1Btn:(UIButton *)sender {
    XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.orderID = self.addOrderModel1.orderID;
    vc.paymentId = self.addOrderModel1.paymentId;
    vc.payMoney = [NSString stringWithFormat:@"%.2f",self.addOrderModel1.money.doubleValue];
//    vc.recieveName = self.recipientNameLabel.text;
//    vc.recievePhone = self.recipientPhoneLabel.text;
//    vc.recieveAddress = _addressDetail.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pay2Btn:(UIButton *)sender {
    
    XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.orderID = self.addOrderModel2.orderID;
    vc.paymentId = self.addOrderModel2.paymentId;
    vc.payMoney = [NSString stringWithFormat:@"%.2f",self.addOrderModel2.money.doubleValue];
    //    vc.recieveName = self.recipientNameLabel.text;
    //    vc.recievePhone = self.recipientPhoneLabel.text;
    //    vc.recieveAddress = _addressDetail.text;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getData1
{
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.addOrderModel1.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            
            
            XNRCheckOrderSectionModel *sectionModel = [[XNRCheckOrderSectionModel alloc] init];
            
            NSDictionary *datasDic = result[@"datas"];
            sectionModel.id = datasDic[@"rows"][@"id"];
            sectionModel.payStatus = datasDic[@"rows"][@"payStatus"];
            sectionModel.duePrice = datasDic[@"rows"][@"duePrice"];//待付金额
            sectionModel.paySubOrderType = datasDic[@"rows"][@"paySubOrderType"];//支付模式
            
            self.paySubOrderType = sectionModel.paySubOrderType;
            
            NSDictionary *payment = datasDic[@"rows"][@"payment"];
            
            if (payment) {
                sectionModel.price = payment[@"price"];
            }
            
            NSDictionary *order = datasDic[@"rows"][@"order"];
            sectionModel.deposit = order[@"deposit"];
            sectionModel.totalPrice = order[@"totalPrice"];
            
            NSDictionary *orderStatus = order[@"orderStatus"];
            sectionModel.type = orderStatus[@"type"];
            sectionModel.value = orderStatus[@"value"];
            sectionModel.orderGoodsList = (NSMutableArray *)[XNRCheckOrderModel objectArrayWithKeyValuesArray:datasDic[@"rows"][@"orderGoodsList"]];
           
//            [_dataArray addObject:sectionModel];
            [self setOrder1:sectionModel.paySubOrderType andHoldMoney:sectionModel.price andTotalMoney:sectionModel.totalPrice andOrderGoodList:sectionModel.orderGoodsList];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];

}

-(void)setOrder1:(NSString *)paySubOrderType andHoldMoney:(NSString *)holdMoney andTotalMoney:(NSString *)totalMoney andOrderGoodList:(NSMutableArray *)orderGoodList
{
    self.orderIDLabel1.text = [NSString stringWithFormat:@"订单号：%@",self.addOrderModel1.orderID];
    if ([paySubOrderType isEqualToString:@"deposit"]) {
        self.payType1.text = @"阶段一：订金";
    }
    else if ([paySubOrderType isEqualToString:@"balance"])
    {
        self.payType1.text = @"阶段二：尾款";
    }
    else if ([paySubOrderType isEqualToString:@"full"])
    {
        self.payType1.text = @"订单总额";
    }
    self.holdPayLabel1.text = [NSString stringWithFormat:@"待付金额：%.2f元",holdMoney.doubleValue];
    self.totalMoneyLabel1.text = [NSString stringWithFormat:@"订单总额：%.2f元",totalMoney.doubleValue];
    [self setDifFont:self.holdPayLabel1];
    [self setDifFont:self.totalMoneyLabel1];
    
    for ( int i = 0; i < orderGoodList.count; i++) {
        XNRCheckOrderModel *orderModer = orderGoodList[i];
        if (orderModer.productName) {
            [self.str1 appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.productName,orderModer.count]];
        }
        else
        {
            [self.str1 appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.goodsName,orderModer.goodsCount]];

        }
        if ((i+1) < orderGoodList.count) {
            [self.str1 appendString:@","];
        }
        NSString *str = [NSString stringWithFormat:@"%@",self.str1];
        self.orderDetailLabel1.text = str;

    }
}

-(void)getData2
{
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.addOrderModel2.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            
            
            XNRCheckOrderSectionModel *sectionModel = [[XNRCheckOrderSectionModel alloc] init];
            
            NSDictionary *datasDic = result[@"datas"];
            sectionModel.id = datasDic[@"rows"][@"id"];
            sectionModel.payStatus = datasDic[@"rows"][@"payStatus"];
            sectionModel.duePrice = datasDic[@"rows"][@"duePrice"];//待付金额
            sectionModel.paySubOrderType = datasDic[@"rows"][@"paySubOrderType"];//支付模式
            
            self.paySubOrderType = sectionModel.paySubOrderType;
            
            NSDictionary *payment = datasDic[@"rows"][@"payment"];
            
            if (payment) {
                sectionModel.price = payment[@"price"];
            }
            
            NSDictionary *order = datasDic[@"rows"][@"order"];
            sectionModel.deposit = order[@"deposit"];
            sectionModel.totalPrice = order[@"totalPrice"];
            
            NSDictionary *orderStatus = order[@"orderStatus"];
            sectionModel.type = orderStatus[@"type"];
            sectionModel.value = orderStatus[@"value"];
            sectionModel.orderGoodsList = (NSMutableArray *)[XNRCheckOrderModel objectArrayWithKeyValuesArray:datasDic[@"rows"][@"orderGoodsList"]];
            
            //            [_dataArray addObject:sectionModel];
            [self setOrder2:sectionModel.paySubOrderType andHoldMoney:sectionModel.price andTotalMoney:sectionModel.totalPrice andOrderGoodList:sectionModel.orderGoodsList];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];

}

-(void)setOrder2:(NSString *)paySubOrderType andHoldMoney:(NSString *)holdMoney andTotalMoney:(NSString *)totalMoney andOrderGoodList:(NSMutableArray *)orderGoodList
{
    self.orderIDLabel2.text = [NSString stringWithFormat:@"订单号：%@",self.addOrderModel2.orderID];

    if ([paySubOrderType isEqualToString:@"deposit"]) {
        self.payType2.text = @"分阶段：订金";
    }
    else if ([paySubOrderType isEqualToString:@"full"])
    {
        self.payType2.text = @"订单总额";
    }
    self.holdPayLabel2.text = [NSString stringWithFormat:@"待付金额：%.2f元",holdMoney.doubleValue];
    self.totalMoneyLabel2.text = [NSString stringWithFormat:@"订单总额：%.2f元",totalMoney.doubleValue];
    

    [self setDifFont:self.holdPayLabel2];
    [self setDifFont:self.totalMoneyLabel2];
    
    for ( int i = 0; i < orderGoodList.count; i++) {
        XNRCheckOrderModel *orderModer = orderGoodList[i];
        if (orderModer.productName) {
            [self.str2 appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.productName,orderModer.count]];
        }
        else
        {
            [self.str2 appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.goodsName,orderModer.goodsCount]];
        }

        if ((i+1) < orderGoodList.count) {
            [self.str2 appendString:@","];
        }
        NSString *str = [NSString stringWithFormat:@"%@",self.str2];
        self.orderDetailLabel2.text = str;
        self.orderDetailLabel2.layer.cornerRadius = 10;

//        self.orderDetailLabel2.text = self.str2;
        
    }
}
-(void)setDifFont:(UILabel *)label
{
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:label.text];
    NSDictionary *dict=@{
                         
                         NSForegroundColorAttributeName:R_G_B_16(0xFF4E00),
                         NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)],
                         };
    
    [AttributedStringDeposit addAttributes:dict range:NSMakeRange(5,AttributedStringDeposit.length-5)];
    
    [label setAttributedText:AttributedStringDeposit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
