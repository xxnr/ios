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
@property (weak, nonatomic) UILabel *orderIDLabelSep;
@property (weak, nonatomic) UILabel *orderIDLabelFull;
@property (weak, nonatomic) UILabel *payTypeSep;
@property (weak, nonatomic) UILabel *payTypeFull;
@property (weak, nonatomic) UILabel *holdPayLabelSep;
@property (weak, nonatomic) UILabel *holdPayLabelFull;
@property (weak, nonatomic) UILabel *totalMoneyLabelSep;
@property (weak, nonatomic) UILabel *totalMoneyLabelFull;
@property (weak, nonatomic) UILabel *orderDetailLabelSep;
@property (weak, nonatomic) UILabel *orderDetailLabelFull;
@property (weak, nonatomic) UIButton *payButtonSep;
@property (weak, nonatomic) UIButton *payButtonFull;
@property (weak, nonatomic) UIView *bgViewSep;

@property (weak, nonatomic) UIView *bgViewFull;
@property (weak, nonatomic) UIView *line1;
@property (weak, nonatomic) UIView *line2;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) NSString *paySubOrderType;//本次付款的字订单类型

@property (nonatomic, strong) NSMutableString *strSep;
@property (nonatomic, strong) NSMutableString *strFull;
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
    self.strSep = [NSMutableString string];
    self.strFull = [NSMutableString string];

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

    UIView *bgViewSep = [[UIView alloc]initWithFrame: CGRectMake(0,0, ScreenWidth, PX_TO_PT(80))];
    bgViewSep.backgroundColor = R_G_B_16(0xF0F0F0);
    [self.midView addSubview:bgViewSep];
    
    
    UILabel *orderIDLabelSep = [[UILabel alloc]initWithFrame: CGRectMake(PX_TO_PT(31), PX_TO_PT(24), ScreenWidth, PX_TO_PT(35))];
    orderIDLabelSep.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    orderIDLabelSep.textColor = R_G_B_16(0x323232);
    self.orderIDLabelSep = orderIDLabelSep;
    [bgViewSep addSubview:orderIDLabelSep];
    
    UILabel *payTypeSep = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(24), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(27))];
    payTypeSep.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payTypeSep.textColor = R_G_B_16(0x646464);
    self.payTypeSep = payTypeSep;
    [self.midView addSubview:payTypeSep];
    
    UILabel *holdPayLabelSep = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(bgViewSep.frame)+PX_TO_PT(28), ScreenWidth, PX_TO_PT(30))];
    holdPayLabelSep.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    holdPayLabelSep.textColor = R_G_B_16(0x323232);
    self.holdPayLabelSep = holdPayLabelSep;
    [self.midView addSubview:holdPayLabelSep];
    
    
    UILabel *totalMoneyLabelSep = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(self.holdPayLabelSep.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(30))];
    totalMoneyLabelSep.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    totalMoneyLabelSep.textColor = R_G_B_16(0x323232);
    self.totalMoneyLabelSep = totalMoneyLabelSep;
    [self.midView addSubview:totalMoneyLabelSep];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(self.totalMoneyLabelSep.frame) + PX_TO_PT(27), ScreenWidth - PX_TO_PT(62), PX_TO_PT(2))];
    line1.backgroundColor = R_G_B_16(0xC7C7C7);
    [self.midView addSubview:line1];
    
    UIView *detailView0 = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31),CGRectGetMaxY(line1.frame) + PX_TO_PT(12), ScreenWidth - PX_TO_PT(62), PX_TO_PT(80))];
    detailView0.backgroundColor = R_G_B_16(0xF8F8F8);
    [self.midView addSubview:detailView0];
    
    UILabel *orderdetail0 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(26), detailView0.width - PX_TO_PT(60), PX_TO_PT(28))];
    orderdetail0.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    orderdetail0.textColor = R_G_B_16(0x646464);
    self.orderDetailLabelSep = orderdetail0;
    [detailView0 addSubview:orderdetail0];

    UIButton *payButtonSep = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(133)-PX_TO_PT(32), CGRectGetMaxY(detailView0.frame) + PX_TO_PT(19), PX_TO_PT(133), PX_TO_PT(60))];
    [payButtonSep setTitle:@"去支付" forState:UIControlStateNormal];
    payButtonSep.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payButtonSep.backgroundColor = R_G_B_16(0xFE9B00);
    [payButtonSep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButtonSep addTarget:self action:@selector(pay1Btn:) forControlEvents:UIControlEventTouchDown];
    self.payButtonSep = payButtonSep;
    [self.midView addSubview:payButtonSep];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payButtonSep.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(1))];
    line2.backgroundColor = R_G_B_16(0xC7C7C7);
    [self.midView addSubview:line2];
    
    UIView *bgViewFull = [[UIView alloc]initWithFrame: CGRectMake(0,0, ScreenWidth, PX_TO_PT(80))];
    bgViewFull.backgroundColor = R_G_B_16(0xF0F0F0);
    [self.bottomView addSubview:bgViewFull];
    
    
    UILabel *orderIDLabelFull = [[UILabel alloc]initWithFrame: CGRectMake(PX_TO_PT(31), PX_TO_PT(24), ScreenWidth, PX_TO_PT(35))];
    orderIDLabelFull.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    orderIDLabelFull.textColor = R_G_B_16(0x323232);
    self.orderIDLabelFull = orderIDLabelFull;
    [bgViewFull addSubview:orderIDLabelFull];
    
    UILabel *payTypeFull = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(24), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(27))];
    payTypeFull.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payTypeFull.textColor = R_G_B_16(0x646464);

    self.payTypeFull = payTypeFull;
    [self.bottomView addSubview:payTypeFull];
    
    UILabel *holdPayLabelFull = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(bgViewFull.frame)+PX_TO_PT(28), ScreenWidth, PX_TO_PT(30))];
    holdPayLabelFull.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    holdPayLabelFull.textColor = R_G_B_16(0x323232);
    self.holdPayLabelFull = holdPayLabelFull;
    [self.bottomView addSubview:holdPayLabelFull];
    
    
    UILabel *totalMoneyLabelFull = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(self.holdPayLabelFull.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(30))];
    totalMoneyLabelFull.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    totalMoneyLabelFull.textColor = R_G_B_16(0x323232);
    self.totalMoneyLabelFull = totalMoneyLabelFull;
    [self.bottomView addSubview:totalMoneyLabelFull];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(self.totalMoneyLabelFull.frame) + PX_TO_PT(26), ScreenWidth - PX_TO_PT(62), PX_TO_PT(2))];
    line3.backgroundColor = R_G_B_16(0xC7C7C7);
    [self.bottomView addSubview:line3];
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31),CGRectGetMaxY(line3.frame) + PX_TO_PT(12), ScreenWidth - PX_TO_PT(62), PX_TO_PT(80))];
    detailView.backgroundColor = R_G_B_16(0xF8F8F8);
    [self.bottomView addSubview:detailView];
    
    UILabel *orderdetail = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(26), detailView.width - PX_TO_PT(60), PX_TO_PT(28))];
    orderdetail.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    orderdetail.textColor = R_G_B_16(0x646464);
    self.orderDetailLabelFull = orderdetail;
    [detailView addSubview:orderdetail];
    
    UIButton *payButtonFull = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(133) - PX_TO_PT(32), CGRectGetMaxY(detailView.frame) + PX_TO_PT(19), PX_TO_PT(133), PX_TO_PT(60))];
    [payButtonFull setTitle:@"去支付" forState:UIControlStateNormal];
    payButtonFull.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payButtonFull.backgroundColor = R_G_B_16(0xFE9B00);
    [payButtonFull setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButtonFull addTarget:self action:@selector(pay2Btn:) forControlEvents:UIControlEventTouchDown];
    self.payButtonFull = payButtonFull;
    [self.bottomView addSubview:payButtonFull];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payButtonFull.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(1))];
    line4.backgroundColor = R_G_B_16(0xC7C7C7);
    [self.bottomView addSubview:line4];

    detailView0.layer.cornerRadius = 10;
    detailView.layer.cornerRadius = 10;
    detailView.layer.masksToBounds = YES;
    detailView0.layer.masksToBounds = YES;
    self.payTypeSep.textAlignment = UITextAlignmentRight;
    self.payTypeFull.textAlignment = UITextAlignmentRight;


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
    self.payButtonSep.layer.cornerRadius = 5;
    self.payButtonFull.layer.cornerRadius = 5;
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
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchDown];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

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
    vc.orderID = self.addOrderModelSep.orderID;
    vc.paymentId = self.addOrderModelSep.paymentId;
    vc.payMoney = [NSString stringWithFormat:@"%.2f",self.addOrderModelSep.money.doubleValue];
//    vc.recieveName = self.recipientNameLabel.text;
//    vc.recievePhone = self.recipientPhoneLabel.text;
//    vc.recieveAddress = _addressDetail.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pay2Btn:(UIButton *)sender {
    
    XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.orderID = self.addOrderModelFull.orderID;
    vc.paymentId = self.addOrderModelFull.paymentId;
    vc.payMoney = [NSString stringWithFormat:@"%.2f",self.addOrderModelFull.money.doubleValue];
    //    vc.recieveName = self.recipientNameLabel.text;
    //    vc.recievePhone = self.recipientPhoneLabel.text;
    //    vc.recieveAddress = _addressDetail.text;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getData1
{
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.addOrderModelSep.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
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
    self.orderIDLabelSep.text = [NSString stringWithFormat:@"订单号：%@",self.addOrderModelSep.orderID];
    if ([paySubOrderType isEqualToString:@"deposit"]) {
        self.payTypeSep.text = @"阶段一：订金";
    }
    else if ([paySubOrderType isEqualToString:@"balance"])
    {
        self.payTypeSep.text = @"阶段二：尾款";
    }
    else if ([paySubOrderType isEqualToString:@"full"])
    {
        self.payTypeSep.text = @"订单总额";
    }
    self.holdPayLabelSep.text = [NSString stringWithFormat:@"待付金额：%.2f元",holdMoney.doubleValue];
    self.totalMoneyLabelSep.text = [NSString stringWithFormat:@"订单总额：%.2f元",totalMoney.doubleValue];
    [self setDifFont:self.holdPayLabelSep];
    [self setDifFont:self.totalMoneyLabelSep];
    
    for ( int i = 0; i < orderGoodList.count; i++) {
        XNRCheckOrderModel *orderModer = orderGoodList[i];
        if (orderModer.productName) {
            [self.strSep appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.productName,orderModer.count]];
        }
        else
        {
            [self.strSep appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.goodsName,orderModer.goodsCount]];

        }
        if ((i+1) < orderGoodList.count) {
            [self.strSep appendString:@","];
        }
        NSString *str = [NSString stringWithFormat:@"%@",self.strSep];
        self.orderDetailLabelSep.text = str;

    }
}

-(void)getData2
{
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.addOrderModelFull.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
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
    self.orderIDLabelFull.text = [NSString stringWithFormat:@"订单号：%@",self.addOrderModelFull.orderID];

    if ([paySubOrderType isEqualToString:@"deposit"]) {
        self.payTypeFull.text = @"分阶段：订金";
    }
    else if ([paySubOrderType isEqualToString:@"full"])
    {
        self.payTypeFull.text = @"订单总额";
    }
    self.holdPayLabelFull.text = [NSString stringWithFormat:@"待付金额：%.2f元",holdMoney.doubleValue];
    self.totalMoneyLabelFull.text = [NSString stringWithFormat:@"订单总额：%.2f元",totalMoney.doubleValue];
    

    [self setDifFont:self.holdPayLabelFull];
    [self setDifFont:self.totalMoneyLabelFull];
    
    for ( int i = 0; i < orderGoodList.count; i++) {
        XNRCheckOrderModel *orderModer = orderGoodList[i];
        if (orderModer.productName) {
            [self.strFull appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.productName,orderModer.count]];
        }
        else
        {
            [self.strFull appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.goodsName,orderModer.goodsCount]];
        }

        if ((i+1) < orderGoodList.count) {
            [self.strFull appendString:@","];
        }
        NSString *str = [NSString stringWithFormat:@"%@",self.strFull];
        self.orderDetailLabelFull.text = str;
        self.orderDetailLabelFull.layer.cornerRadius = 10;

//        self.orderDetailLabelFull.text = self.strFull;
        
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
