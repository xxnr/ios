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
#define kSelectedImageView 2000
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
@end

@implementation XNRPayTypeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    _payType=0;
  
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    
    [self setNav];
    [self createTopBtn];
    [self createLabel];
    [self createBottomBtn];
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealAlipayResult:) name:@"alipayResult" object:nil];
    
  
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark-支付成功回调
-(void)orderSuccessDeal {
    
    XNROrderSuccessViewController*vc=[[XNROrderSuccessViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//支付方式
- (void)createTopBtn
{
//    NSArray *picArr = @[@"netBank",@"icon_alipay",@"icon_unionpay"];
//    NSArray *titleArr = @[@"网站网银支付",@"支付宝支付",@"银行电汇"];
    NSArray *picArr = @[@"icon_alipay",@"icon_unionpay"];
    NSArray *titleArr = @[@"支付宝支付",@"银联支付"];
    
    for (int i=0; i<2; i++) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 60*i, ScreenWidth, 60)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UIImageView *picImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 10, 40, 40) ImageName:picArr[i]];
        picImageView.userInteractionEnabled = YES;
        [bgView addSubview:picImageView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(picImageView.frame.origin.x+picImageView.frame.size.width+10, 0, 150, 60)];
        titleLabel.text = titleArr[i];
        titleLabel.font = XNRFont(18);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:titleLabel];
    
        if (i == 0) {
            _aplipayImg = [MyControl createImageViewWithFrame:CGRectMake(ScreenWidth-25-10, (60-20)/2.0, 25, 16) ImageName:@"payWaySelect"];
            _aplipayImg.userInteractionEnabled = YES;
            _aplipayImg.tag = kSelectedImageView+i;
            _aplipayImg.hidden = YES;
            [bgView addSubview:_aplipayImg];
        }else{
            _yinlianImg = [MyControl createImageViewWithFrame:CGRectMake(ScreenWidth-25-10, (60-20)/2.0, 25, 16) ImageName:@"payWaySelect"];
            _yinlianImg.userInteractionEnabled = YES;
            _yinlianImg.tag = kSelectedImageView+i;
            _yinlianImg.hidden = YES;
            [bgView addSubview:_yinlianImg];
        }
        UIImageView *selectedImageView = [MyControl createImageViewWithFrame:CGRectMake(ScreenWidth-25-10, (60-20)/2.0, 25, 16) ImageName:@"payWaySelect"];
        selectedImageView.userInteractionEnabled = YES;
        selectedImageView.tag = kSelectedImageView+i;
        selectedImageView.hidden = YES;
        [bgView addSubview:selectedImageView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [bgView addSubview:lineView];
        
        UIButton *payTypeBtn = [MyControl createButtonWithFrame:CGRectMake(0, 60*i, ScreenWidth, 60) ImageName:nil Target:self Action:@selector(btnClick:) Title:nil];
        payTypeBtn.tag = kPayTypeBtn+i;
        [self.view addSubview:payTypeBtn];
    }
}



- (void)btnClick:(UIButton *)button
{
        if (button.tag == kPayTypeBtn) {
            _payType=1;
            _aplipayImg.hidden = NO;
            _yinlianImg.hidden = YES;
        }
        if (button.tag == kPayTypeBtn+1) {
            _payType=2;
            _aplipayImg.hidden = YES;
            _yinlianImg.hidden = NO;
        }


    self.confirmButton.enabled = YES;
    self.confirmButton.backgroundColor = R_G_B_16(0x00b38a);
}
//应付
- (void)createLabel
{
    self.payLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, ScreenWidth, 40)];
    self.payLabel.text = [NSString stringWithFormat:@"应付:  %.2f",self.money.floatValue];
    self.payLabel.font = XNRFont(20);
    self.payLabel.textAlignment = NSTextAlignmentLeft;
    self.payLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.payLabel];
    
    //设定内容样式
    NSMutableAttributedString * attributedString =
    [[NSMutableAttributedString alloc] initWithString:self.payLabel.text];
    //索引一开始一个字符长度
    [attributedString addAttribute:NSForegroundColorAttributeName value:R_G_B_16(0xf10000) range:NSMakeRange(5,self.payLabel.text.length-5)];
    [self.payLabel setAttributedText:attributedString];
}

//确认
- (void)createBottomBtn
{
    self.confirmButton = [MyControl createButtonWithFrame:CGRectMake(10, self.payLabel.frame.origin.y+self.payLabel.frame.size.height, ScreenWidth-20, 45) ImageName:nil Target:self Action:@selector(confirmClick:) Title:nil];
    self.confirmButton.backgroundColor = [UIColor lightGrayColor];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.cornerRadius = 5;
    self.confirmButton.titleLabel.font = XNRFont(18);
    self.confirmButton.enabled = NO;
    [self.view addSubview:self.confirmButton];
}

//确认点击
- (void)confirmClick:(UIButton *)button
{
    NSLog(@"确认");
   
    [KSHttpRequest post:KUpdateOrderPaytype parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderID,@"payType":[NSString stringWithFormat:@"%f",_payType],@"user-agent":@"IOS-v2.0"}success:^(id result) {
        NSLog(@"%@",result);
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络请求错误"];
        NSLog(@"%@",error);
    }];

    
    if(_payType==0){
        
    }else if (_payType==1) {
        NSString *urlStr = [HOST stringByAppendingString:@"/dynamic/alipay/nofity.asp"];
        [GBAlipayManager alipayWithPartner:PartnerID
                                    seller:SellerID
                                   tradeNO:self.paymentId
                               productName:@"新新农人产品"
                        productDescription:nil
                                    amount:self.money
                                 notifyURL:urlStr
                                    itBPay:@"30m"];

    }else if (_payType==2){
        // 银联支付
        [UPPayPlugin startPay:self.tn mode:kMode_Development viewController:self delegate:self];
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
