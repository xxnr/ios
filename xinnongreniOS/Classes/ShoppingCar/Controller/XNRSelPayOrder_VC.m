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
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel1;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel2;
@property (weak, nonatomic) IBOutlet UILabel *payType1;
@property (weak, nonatomic) IBOutlet UILabel *payType2;
@property (weak, nonatomic) IBOutlet UILabel *holdPayLabel1;
@property (weak, nonatomic) IBOutlet UILabel *holdPayLabel2;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel1;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel2;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel1;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel2;
@property (weak, nonatomic) IBOutlet UIButton *payButton1;
@property (weak, nonatomic) IBOutlet UIButton *payButton2;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) NSString *paySubOrderType;//本次付款的字订单类型

@property (nonatomic, strong) NSMutableString *str1;
@property (nonatomic, strong) NSMutableString *str2;
@end


@implementation XNRSelPayOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setNav];
    [self setTop];
    [self setButton];
    [self getData1];
    [self getData2];
    self.str1 = [NSMutableString string];
    self.str2 = [NSMutableString string];
    self.payType1.textAlignment = UITextAlignmentRight;
    self.payType2.textAlignment = UITextAlignmentRight;

    self.orderDetailLabel1.layer.cornerRadius = 10;
    self.orderDetailLabel2.layer.cornerRadius = 10;
    self.orderDetailLabel1.layer.masksToBounds = YES;
    self.orderDetailLabel2.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
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
    self.topView.frame = CGRectMake(0, 0, ScreenWidth,62);
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

-(void)setMiddle
{

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

- (IBAction)pay1Btn:(UIButton *)sender {
    XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.orderID = self.addOrderModel1.orderID;
    vc.paymentId = self.addOrderModel1.paymentId;
    vc.payMoney = [NSString stringWithFormat:@"%.2f",self.addOrderModel1.money.floatValue];
//    vc.recieveName = self.recipientNameLabel.text;
//    vc.recievePhone = self.recipientPhoneLabel.text;
//    vc.recieveAddress = _addressDetail.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)pay2Btn:(UIButton *)sender {
    
    XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.orderID = self.addOrderModel2.orderID;
    vc.paymentId = self.addOrderModel2.paymentId;
    vc.payMoney = [NSString stringWithFormat:@"%.2f",self.addOrderModel2.money.floatValue];
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
    self.orderIDLabel1.text = self.addOrderModel1.orderID;
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
    self.holdPayLabel1.text = [NSString stringWithFormat:@"%.2f元",holdMoney.floatValue];
    self.totalMoneyLabel1.text = [NSString stringWithFormat:@"%.2f元",totalMoney.floatValue];
    for ( int i = 0; i < orderGoodList.count; i++) {
        XNRCheckOrderModel *orderModer = orderGoodList[i];
        [self.str1 appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.goodsName,orderModer.goodsCount]];
        if ((i+1) < orderGoodList.count) {
            [self.str1 appendString:@","];
        }
        NSString *str = [NSString stringWithFormat:@"  %@",self.str1];
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
    self.orderIDLabel2.text = self.addOrderModel2.orderID;
    if ([paySubOrderType isEqualToString:@"deposit"]) {
        self.payType2.text = @"分阶段：订金";
    }
    else if ([paySubOrderType isEqualToString:@"full"])
    {
        self.payType2.text = @"订单总额";
    }
    self.holdPayLabel2.text = [NSString stringWithFormat:@"%.2f元",holdMoney.floatValue];
    self.totalMoneyLabel2.text = [NSString stringWithFormat:@"%.2f元",totalMoney.floatValue];
    for ( int i = 0; i < orderGoodList.count; i++) {
        XNRCheckOrderModel *orderModer = orderGoodList[i];
        [self.str2 appendString:[NSString stringWithFormat:@"%@－%@件",orderModer.goodsName,orderModer.goodsCount]];
        if ((i+1) < orderGoodList.count) {
            [self.str2 appendString:@","];
        }
        NSString *str = [NSString stringWithFormat:@"  %@",self.str2];
        self.orderDetailLabel2.text = str;
        self.orderDetailLabel2.layer.cornerRadius = 10;

//        self.orderDetailLabel2.text = self.str2;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
