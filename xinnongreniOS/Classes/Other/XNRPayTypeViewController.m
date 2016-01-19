//
//  XNRPayTypeViewController.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//  支付方式

#import "XNRPayTypeViewController.h"
#import "XNROrderSuccessViewController.h"
#import "GBAlipayManager.h"
#import "XNRTabBarController.h"
#import "XNRPayTypeAlertView.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"

#define kPayTypeBtn 1000
#define kSelectedBtn 2000
#define kMode_Development  @"00"
@interface XNRPayTypeViewController ()<UPPayPluginDelegate>
{
    UIImageView *_tempImageView;
    CGFloat _payType;
}
@property (nonatomic,strong)UIButton *confirmButton;

@property (nonatomic,strong)UILabel *payLabel;

@property (nonatomic,strong) XNRPayTypeAlertView *payTypeAlertView;

@property (nonatomic, strong) UIImageView *aplipayImg;

@property (nonatomic, strong) UIImageView *yinlianImg;

@property (nonatomic ,weak) UIView *topView;

@property (nonatomic ,weak) UIButton *tempBtn;

@property (nonatomic, copy) NSString *PaymentId;

@property (nonatomic,copy) NSString *Money;    //价钱

@property (nonatomic ,copy) NSString *Tn;

@end

@implementation XNRPayTypeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _payType=0;
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    
    [self setNav];
    [self createTopView];
    [self createMidView];
    [self createBottomView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealAlipayResult:) name:@"alipayResult" object:nil];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark-支付成功回调
-(void)orderSuccessDeal {
    
    XNROrderSuccessViewController *vc=[[XNROrderSuccessViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 顶部视图
-(void)createTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(140))];
    topView.backgroundColor = R_G_B_16(0xfffaf6);
    self.topView = topView;
    [self.view addSubview:topView];
    
    UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(22), ScreenWidth, PX_TO_PT(36))];
    orderNumLabel.textColor = R_G_B_16(0x323232);
    orderNumLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.orderID];
    [topView addSubview:orderNumLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(orderNumLabel.frame) + PX_TO_PT(30), ScreenWidth, PX_TO_PT(36))];
    priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    priceLabel.text = [NSString stringWithFormat:@"应付金额：%.2f元",self.money.floatValue];
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:priceLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:18]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(5,AttributedStringDeposit.length-5)];
    
    [priceLabel setAttributedText:AttributedStringDeposit];
    [topView addSubview:priceLabel];
    
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*PX_TO_PT(140), ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [topView addSubview:lineView];
    }
}
#pragma mark - 中部视图

-(void)createMidView{
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(356))];
    midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView];
    
    UILabel *payStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(30), ScreenWidth, PX_TO_PT(40))];
    payStyleLabel.textColor = R_G_B_16(0x323232);
    payStyleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    payStyleLabel.text = @"请选择支付方式";
    payStyleLabel.textAlignment = NSTextAlignmentLeft;
    [midView addSubview:payStyleLabel];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(102), ScreenWidth-PX_TO_PT(32) * 2, PX_TO_PT(196))];
    subView.layer.borderWidth = 1.0;
    subView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    subView.layer.cornerRadius = 5.0;
    subView.layer.masksToBounds = YES;
    [midView addSubview:subView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(24), PX_TO_PT(24), PX_TO_PT(300), PX_TO_PT(50))];
    [imageView1 setImage:[UIImage imageNamed:@"pay_0"]];
    [subView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(24), PX_TO_PT(98)+PX_TO_PT(24), PX_TO_PT(250), PX_TO_PT(50))];
    [imageView2 setImage:[UIImage imageNamed:@"pay_1"]];
    [subView addSubview:imageView2];

    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(24), PX_TO_PT(98)*2+PX_TO_PT(14), PX_TO_PT(280), PX_TO_PT(70))];
    [imageView3 setImage:[UIImage imageNamed:@"pay_2"]];
//    [subView addSubview:imageView3];

    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(24), PX_TO_PT(98)*3+PX_TO_PT(14), PX_TO_PT(310), PX_TO_PT(70))];
    [imageView4 setImage:[UIImage imageNamed:@"pay_3"]];
//    [subView addSubview:imageView4];

    for (int i = 0; i<2; i++) {
        UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(32)*2-PX_TO_PT(98), PX_TO_PT(98)*i, PX_TO_PT(98), PX_TO_PT(98));
        selectedBtn.tag = kSelectedBtn + i;
        [selectedBtn setImage:[UIImage imageNamed:@"shopCar_circle"] forState:UIControlStateNormal];
        [selectedBtn setImage:[UIImage imageNamed:@"shopcar_right"] forState:UIControlStateSelected];
        [selectedBtn addTarget: self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [subView addSubview:selectedBtn];
        
    }
    
    for (int i = 1; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [subView addSubview:lineView];
    }
    
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(356)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [midView addSubview:lineView];
    }
}

-(void)selectedBtnClick:(UIButton *)button{
    self.tempBtn.selected = NO;
    button.selected = YES;
    self.tempBtn = button;
    if (button.tag == kSelectedBtn) {
        _payType = 1;
        [self payType];
        NSDictionary *params = @{@"consumer":@"app",@"orderId":self.orderID};
        [KSHttpRequest post:KAlipay parameters:params success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                _PaymentId = result[@"paymentId"];
                _Money = result[@"price"];
            }
        } failure:^(NSError *error) {
            
        }];

        
    }else if (button.tag == kSelectedBtn + 1){
        _payType = 2;
        [self payType];
        // 获取tn
        [KSHttpRequest post:KUnionpay parameters:@{@"consumer":@"app",@"responseStyle":@"v1.0",@"orderId":self.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {

                _Tn = result[@"tn"];
                

            
        } failure:^(NSError *error) {
            
        }];

    
    }else if (button.tag == kSelectedBtn + 2){
    
    }else{
    
    }
}
#pragma mark - 支付类型
-(void)payType{
    [KSHttpRequest post:KUpdateOrderPaytype parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderID,@"payType":[NSString stringWithFormat:@"%f",_payType],@"user-agent":@"IOS-v2.0"}success:^(id result) {
        
    } failure:^(NSError *error) {
        
 }];
}
#pragma mark - 底部视图
-(void)createBottomView{
    UIButton *goPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goPayBtn.frame = CGRectMake(PX_TO_PT(32), ScreenHeight - PX_TO_PT(32)-PX_TO_PT(89)-64, ScreenWidth - PX_TO_PT(32)*2, PX_TO_PT(89));
    goPayBtn.backgroundColor = R_G_B_16(0x00b38a);
    [goPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [goPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goPayBtn.layer.cornerRadius = 5.0;
    goPayBtn.layer.masksToBounds = YES;
    [goPayBtn addTarget:self action:@selector(goPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goPayBtn];
}

#pragma  mark - 去支付
- (void)goPayBtnClick:(UIButton *)button
{
    NSLog(@"去支付");
   
    if (_payType == 1) { // 支付宝支付
        [GBAlipayManager alipayWithPartner:PartnerID
                                    seller:SellerID
                                   tradeNO:_PaymentId
                               productName:@"新新农人产品"
                        productDescription:nil
                                    amount:_Money
                                 notifyURL:KDynamic
                                    itBPay:@"30m"];

    }else if (_payType == 2){ // 银联支付
        [UPPayPlugin startPay:_Tn mode:kMode_Development viewController:self delegate:self];
        
    }
}

-(void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"]) {
        XNROrderSuccessViewController *vc = [[XNROrderSuccessViewController alloc] init];
        vc.money = self.money;
        vc.orderID = self.orderID;
        vc.fromType = self.fromType;
        vc.recieveName = self.recieveName;
        vc.recievePhone = self.recievePhone;
        vc.recieveAddress = self.recieveAddress;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)dealAlipayResult:(NSNotification*)notification{
    
    NSString*result=notification.object;
    if([result isEqualToString:@"9000"]){
        XNROrderSuccessViewController*vc=[[XNROrderSuccessViewController alloc]init];
        vc.money = self.money;
        vc.orderID = self.orderID;
        vc.fromType = self.fromType;
        vc.paymentId = self.paymentId;
        vc.recieveName = self.recieveName;
        vc.recievePhone = self.recievePhone;
        vc.recieveAddress = self.recieveAddress;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        NSLog(@"支付成功");
       
    }else{
        
        NSLog(@"支付失败");
    }
}
-(NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"支付方式";
    
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
    if ([self.fromType isEqualToString:@"确认订单"]) {
        XNRTabBarController *tab = (XNRTabBarController *)self.tabBarController;
        tab.selectedIndex = 0;
        CATransition *myTransition=[CATransition animation];
        myTransition.duration=0.3;
        myTransition.type= @"fade";
        [tab.view.superview.layer addAnimation:myTransition forKey:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
        return;
    }
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
