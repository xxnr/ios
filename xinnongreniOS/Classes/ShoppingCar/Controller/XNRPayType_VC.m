//
//  XNRPayType_VC.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//  支付方式

#import "XNRPayType_VC.h"
#import "XNROrderSuccessViewController.h"
#import "GBAlipayManager.h"
#import "XNRTabBarController.h"
#import "XNRPayTypeAlertView.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "XNRCheckOrderSectionModel.h"
#import "XNRCheckOrderModel.h"
#import "XNRShoppingCarController.h"
#import "XNRProductInfo_VC.h"
#define kPayTypeBtn 1000
#define kSelectedBtn 2000

#define kMode_Development  @"00"
@interface XNRPayType_VC ()<UPPayPluginDelegate,UITextFieldDelegate>
{
    UIImageView *_tempImageView;
    CGFloat _payType;
    NSMutableArray *_dataArray;
    UIView *selLine;//下划线
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

@property (nonatomic ,weak) UIButton *selectedBtnOne;

@property (nonatomic ,weak) UIButton *selectedBtnTwo;

@property (nonatomic, strong) UIButton *btn1;

@property (nonatomic, strong) UIButton *btn2;

@property (nonatomic ,weak) UILabel *priceLabel;

@property (nonatomic ,weak) UILabel *totalLabel;

@property (nonatomic, copy) NSString *paySubOrderType;

@property (nonatomic,copy) NSString *holdPrice;

@property (nonatomic, copy) NSString *totalPrice;

@property (nonatomic, strong) UIView *showMoney;

@property (nonatomic, strong) UIView *midView;

@property (nonatomic, strong)UIButton *tmpBtn;

@property (nonatomic, strong) UIView *subView;

@property (nonatomic, strong) UILabel *fullMoney;//全部金额

@property (nonatomic,strong) UIView *sepMoneyView;

@property (nonatomic, strong) UILabel *sepMoney;//分次金额

@property (nonatomic, strong) NSString *minPrice;

@property (nonatomic, strong) UIButton *currentSelBtn;//当前支付类型

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic,assign) BOOL isFull;

@property (nonatomic, assign) BOOL ispayType;

@property (nonatomic, strong) UITextField *myTextField;

@property (nonatomic, assign)BOOL isHaveDian;

@property (nonatomic,assign) BOOL isInWhiteList;
@end

@implementation XNRPayType_VC


- (void)viewDidLoad {
    [super viewDidLoad];
    _payType = 0;
    self.view.backgroundColor = R_G_B_16(0xFAFAFA);
    self.minPrice = @"3000";

//    [self getMinPayPrice];
    [self getData];

    [self setNav];
    [self createTopView];
    [self createMidView];
    [self createBottomView];

    _dataArray = [NSMutableArray array];
    self.myTextField =[[UITextField alloc]initWithFrame:CGRectMake(PX_TO_PT(252), PX_TO_PT(35), PX_TO_PT(226), PX_TO_PT(40))];
    self.myTextField.delegate = self;
    self.myTextField.hidden = YES;
    
    self.sepMoney = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(252), PX_TO_PT(35), PX_TO_PT(226), PX_TO_PT(35))];
    self.sepMoney.textColor = R_G_B_16(0xFF4E00);
    self.sepMoney.textAlignment = UITextAlignmentCenter;
    self.sepMoney.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealAlipayResult:) name:@"alipayResult" object:nil];
    

//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(librate) name:@"succss_Push" object:nil];
}

//-(void)librate
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self ];
////    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:@"alipayResult"];
////    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:@"succss_Push"];
//}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
#pragma mark-支付成功回调
//-(void)orderSuccessDeal {
//    
//    XNROrderSuccessViewController *vc=[[XNROrderSuccessViewController alloc]init];
//    vc.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}
-(void)getMinPayPrice
{
    [KSHttpRequest post:KgetMinPayPrice parameters:@{@"token":[DataCenter account].token,@"orderId":self.orderID} success:^(id result) {
        if ([result[@"code"] doubleValue] == 1000) {

            if (result[@"payprice"] != nil) {
                self.minPrice = [NSString stringWithFormat:@"%@",result[@"payprice"]];
            }
            else
            {
                self.minPrice = @"3000";
            }
            
        }
        
        //分次付款的金额显示
        [self setSepMoney];
     } failure:^(NSError *error) {
        
    }];
}

/**
 *  如果用户在白名单中，则可以手动输入金额
 */
//-(void)getUserType
//{
//    [KSHttpRequest post:KisInWhiteList parameters: nil success:^(id result) {
//        
//        if ([result[@"code"] integerValue] == 1000) {
//            self.isInWhiteList = YES;
//            self.sepMoneyView.hidden = YES;
//            self.fullMoney.hidden = YES;
//            self.myTextField =[[UITextField alloc]initWithFrame:CGRectMake(PX_TO_PT(252), PX_TO_PT(35), PX_TO_PT(226), PX_TO_PT(28))];
//            self.myTextField.textColor = R_G_B_16(0xFF4E00);
//            self.myTextField.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
//            self.myTextField.textColor = R_G_B_16(0xFF4E00);
//            self.myTextField.textAlignment = NSTextAlignmentCenter;
//            [self.showMoney addSubview:self.myTextField];
//            
//        }
//        else if ([result[@"code"] integerValue] == 100)
//        {
//            [self setSepMoney];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}

-(void)getData{
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            
            //后请求getMinpayPrice
            [self getMinPayPrice];
            
            XNRCheckOrderSectionModel *sectionModel = [[XNRCheckOrderSectionModel alloc] init];
            
            NSDictionary *datasDic = result[@"datas"];
            sectionModel.address = datasDic[@"rows"][@"address"];
            sectionModel.id = datasDic[@"rows"][@"id"];
            sectionModel.recipientName = datasDic[@"rows"][@"recipientName"];
            sectionModel.recipientPhone = datasDic[@"rows"][@"recipientPhone"];
            sectionModel.payStatus = datasDic[@"rows"][@"payStatus"];
            sectionModel.duePrice = datasDic[@"rows"][@"duePrice"];//待付金额
            sectionModel.paySubOrderType = datasDic[@"rows"][@"paySubOrderType"];//支付模式
    
            self.paySubOrderType = sectionModel.paySubOrderType;
          
            [self isPaySubOrderType];
        
            NSDictionary *payment = datasDic[@"rows"][@"payment"];
            
            if (payment) {
                sectionModel.price = payment[@"price"];
                _Money = sectionModel.price;
            }
            
            NSDictionary *order = datasDic[@"rows"][@"order"];
            sectionModel.deposit = order[@"deposit"];
            sectionModel.totalPrice = order[@"totalPrice"];
            
            NSDictionary *orderStatus = order[@"orderStatus"];
            sectionModel.type = orderStatus[@"type"];
            sectionModel.value = orderStatus[@"value"];
            sectionModel.orderGoodsList = (NSMutableArray *)[XNRCheckOrderModel objectArrayWithKeyValuesArray:datasDic[@"rows"][@"orderGoodsList"]];

            [self setTop:sectionModel.price andFullMoney:sectionModel.totalPrice];
            [self setFullMoneyView];
         
            [_dataArray addObject:sectionModel];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

-(void)setFullMoneyView
{
    self.sepMoneyView.hidden = YES;
    self.fullMoney = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.showMoney.height)];
    self.fullMoney.textColor = R_G_B_16(0xFF4E00);
    self.fullMoney.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    self.fullMoney.text = [NSString stringWithFormat:@"¥%@",self.holdPrice];
    self.fullMoney.textAlignment = NSTextAlignmentCenter;
    [self.showMoney addSubview:self.fullMoney];
    //支付金额默认为全额支付
    _Money = self.holdPrice;

}

-(void)setTop:(NSString *)holdMoney andFullMoney:(NSString *)fullMoney
{
    self.holdPrice = holdMoney;
    self.priceLabel.text = [NSString stringWithFormat:@"待付金额：%.2f元",holdMoney.doubleValue];
    self.priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.priceLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(5,AttributedStringDeposit.length-5)];
    
    [self.priceLabel setAttributedText:AttributedStringDeposit];
    
    self.totalLabel.text = [NSString stringWithFormat:@"订单总额：%.2f元",fullMoney.doubleValue];
    self.totalLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    
    NSMutableAttributedString *AttributedStringDeposit2 = [[NSMutableAttributedString alloc]initWithString:self.totalLabel.text];
    NSDictionary *depositStr2=@{
                                
                                NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                                
                                };
    
    [AttributedStringDeposit2 addAttributes:depositStr2 range:NSMakeRange(5,AttributedStringDeposit2.length-5)];
    
    [self.totalLabel setAttributedText:AttributedStringDeposit2];
    

}
//支付类型
-(void)isPaySubOrderType
{
    UILabel *ordertotal = [[UILabel alloc] init];
    ordertotal.frame = CGRectMake(PX_TO_PT(500), PX_TO_PT(40), ScreenWidth - PX_TO_PT(545), PX_TO_PT(26));
//    ordertotal.backgroundColor = [UIColor blackColor];
    if ([self.paySubOrderType isEqualToString:@"deposit"]) {
        ordertotal.text = @"阶段一：订金 ";
    }
    else if ([self.paySubOrderType isEqualToString:@"full"])
    {
        ordertotal.text = @"订单总额 ";
    }
    else if ([self.paySubOrderType isEqualToString:@"balance"])
    {
        ordertotal.text = @"阶段二：尾款 ";
    }
    
    ordertotal.font = [UIFont systemFontOfSize:PX_TO_PT(29)];
    ordertotal.textAlignment = UITextAlignmentRight;
    NSLog(@"%@",self.paySubOrderType);

    [self.view addSubview:ordertotal];

}
#pragma mark - 顶部视图
-(void)createTopView{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(202))];
    
    self.topView = topView;
    [self.view addSubview:topView];
   
    //顶部1
    UIView *top1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(68))];
    top1.backgroundColor = R_G_B_16(0xfff1e5);
    
    UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(18), PX_TO_PT(340), PX_TO_PT(33))];
    orderNumLabel.textColor = R_G_B_16(0x323232);
    orderNumLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    orderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",self.orderID];
    [top1 addSubview:orderNumLabel];
    
    
    //顶部2
    UIView *top2 = [[UIView alloc]initWithFrame:CGRectMake(0, top1.height, ScreenWidth, PX_TO_PT(130))];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(130))];
    imageview.image = [UIImage imageNamed:@"矩形背景1"];
//    imageview.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, PX_TO_PT(130), 0)];
    [top2 addSubview:imageview];
    
    UILabel *holdPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(27), ScreenWidth, PX_TO_PT(28))];
    self.priceLabel = holdPriceLabel;
    [top2 addSubview:holdPriceLabel];
    
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(76), ScreenWidth, PX_TO_PT(28))];
    self.totalLabel = totalPriceLabel;
    [top2 addSubview:totalPriceLabel];

    [topView addSubview:top1];
    [topView addSubview:top2];
    
    //顶部视图描边
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*top1.height, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [topView addSubview:lineView];
        
    }

}
#pragma mark - 中部视图

-(void)createMidView{
//    self.midView = [[UIView alloc]init];

    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) + PX_TO_PT(20), ScreenWidth, PX_TO_PT(233))];
    [self.view addSubview:midView];
    //支付方式
    
    UIView *typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(69))];
    typeView.backgroundColor = R_G_B_16(0xF0F0F0);
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(21), PX_TO_PT(140), PX_TO_PT(30))];
    typeLabel.text = @"支付方式";
    typeLabel.textColor = R_G_B_16(0x323232);
    typeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [typeView addSubview:typeLabel];
    [midView addSubview:typeView];
    
    //支付的两种方式
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*ScreenWidth/2,CGRectGetMaxY(typeView.frame)+1,ScreenWidth/2, PX_TO_PT(75))];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:R_G_B_16(0x646464) forState:UIControlStateNormal];
        [btn setTitleColor:R_G_B_16(0xFE9B00) forState:UIControlStateSelected];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        
        btn.tag = i;
        if(i == 0)
        {
            btn.selected = YES;
            [self selPayType:btn];
            [btn setTitle:@"全额支付" forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitle:@"分次支付" forState:UIControlStateNormal];
            [midView addSubview:btn];
        }
        
        [btn addTarget:self action:@selector(selPayType:) forControlEvents:UIControlEventTouchDown];
        [midView addSubview:btn];
    }
    
    //间隔线
    UIView *gap1 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetMaxY(typeView.frame) + PX_TO_PT(15), PX_TO_PT(3), PX_TO_PT(47))];
    gap1.backgroundColor = R_G_B_16(0xE2E2E2);
    [midView addSubview:gap1];
    
    UIView *gap2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(148), ScreenWidth, PX_TO_PT(2))];
    gap2.backgroundColor = R_G_B_16(0xE2E2E2);
    [midView addSubview:gap2];
    UIView *gap3 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(69), ScreenWidth, PX_TO_PT(2))];
    gap2.backgroundColor = R_G_B_16(0xE2E2E2);
    [midView addSubview:gap3];
    
    //选中下划线
    selLine = [[UIView alloc]init];
    selLine.backgroundColor = R_G_B_16(0xFE9B00);
    selLine.width = ScreenWidth/2;
    selLine.height = PX_TO_PT(3);
    selLine.y = PX_TO_PT(386);
    [self.view addSubview:selLine];

    //显示的金额
    self.showMoney = [[UIView alloc]init];
    self.showMoney.backgroundColor = [UIColor whiteColor];
    self.showMoney.frame = CGRectMake(0, PX_TO_PT(389), ScreenWidth, PX_TO_PT(100));
    
    [self.view addSubview:self.showMoney];
    
    
    
    //付款方式view
    self.subView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.showMoney.frame), ScreenWidth, PX_TO_PT(421))];

    [self.view addSubview:self.subView];
    
    UIView *fkType = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(69))];
    fkType.backgroundColor = R_G_B_16(0XF0F0F0);
    [self.subView addSubview:fkType];
    
    //付款方式label
    UILabel *fkTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(21), ScreenWidth, PX_TO_PT(30))]
    ;
    fkTypeLabel.backgroundColor = R_G_B_16(0xF0F0F0);
    fkTypeLabel.text = @"付款方式";
    fkTypeLabel.textColor = R_G_B_16(0x323232);
    fkTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [fkType addSubview:fkTypeLabel];
    
    //付款的几种方式
    UIView *payTypeDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fkType.frame), ScreenWidth, PX_TO_PT(356))];
    [self.subView addSubview:payTypeDetailView];
    NSArray *arr = [NSArray arrayWithObjects:@"支付宝支付",@"银联支付",@"POS机刷卡",@"银行汇款", nil];

    UIImage *iamge1 = [UIImage imageNamed:@"支付宝logo-0"];
    UIImage *image2 = [UIImage imageNamed:@"银联logo"];
    UIImage *image3 = [UIImage imageNamed:@"全民付logo-0"];
    UIImage *image4 = [UIImage imageNamed:@"银行扁平化"];
    NSArray *imagesarr = [NSArray arrayWithObjects:iamge1,image2,image3,image4,nil];
    
    self.currentSelBtn = [[UIButton alloc]init];
    for (int i = 0; i<4; i++) {
        //间隔线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, PX_TO_PT(2))];
        lineView.backgroundColor = R_G_B_16(0xe2e2e2);
        
         //支付方式 button
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*(PX_TO_PT(89)), ScreenWidth, PX_TO_PT(88))];
        btn.tag = kSelectedBtn+i;
        btn.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(10), PX_TO_PT(80),PX_TO_PT(60))];
        imageView.image = imagesarr[i];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *Paylabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(144), PX_TO_PT(30), PX_TO_PT(200), PX_TO_PT(30))];
        Paylabel.text = arr[i];
        Paylabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        
        UIButton *selbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selbtn.frame = CGRectMake(PX_TO_PT(630),PX_TO_PT(25) , PX_TO_PT(37), PX_TO_PT(37));
        selbtn.tag = kSelectedBtn+i;
        selbtn.userInteractionEnabled = NO;
//        selbtn.enabled = NO;
        [selbtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [selbtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [selbtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchDown];
        
        if (i == 0) {
            self.selectedBtnOne = selbtn;
            self.currentSelBtn = selbtn;
//            [self selectedBtnClick:selbtn];
            [self selectedBtnClick:btn];
        }
        else if (i == 1) {
            self.selectedBtnTwo = selbtn;
        }
        else
        {
//            btn.userInteractionEnabled = NO;
            selbtn.userInteractionEnabled = NO;
            btn.enabled = NO;
            selbtn.enabled = NO;
        }
        
        if (i == 0 || i == 1) {
            
            [btn addSubview:selbtn];
            [btn addSubview:imageView];
            [btn addSubview:Paylabel];
            [btn addSubview:lineView];
            [payTypeDetailView addSubview:btn];

        }
    }

}

-(void)selPayType:(UIButton *)button
{

    //当前的为选中状态，其余未选中
    if (_tmpBtn == nil){
        button.selected = YES;
        _tmpBtn = button;
    }
    else if (_tmpBtn !=nil && _tmpBtn == button){
        button.selected = YES;
        
    }
    else if (_tmpBtn!= button && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        button.selected = YES;
        _tmpBtn = button;
    }
    
    
    if (button.tag == 0) {
        self.isFull = YES;
        self.sepMoneyView.hidden = YES;
        self.fullMoney.hidden = NO;

        [UIView animateWithDuration:0.2 animations:^{
            selLine.x = 0;
            self.showMoney.frame = CGRectMake(0, PX_TO_PT(390), ScreenWidth, PX_TO_PT(95));
            self.subView.y = CGRectGetMaxY(self.showMoney.frame);
        }];

        self.fullMoney.text = [NSString stringWithFormat:@"¥%@",self.holdPrice];
        
        _Money = self.holdPrice;
        
    }
    else
    {
        _Money = [self.sepMoney.text substringFromIndex:1];
        NSLog(@"%@",_Money);
        self.isFull = NO;
        self.sepMoneyView.hidden = NO;
        self.fullMoney.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            selLine.x = ScreenWidth/2+2;
            self.showMoney.frame = CGRectMake(0, PX_TO_PT(390), ScreenWidth, PX_TO_PT(143));
            self.subView.y = CGRectGetMaxY(self.showMoney.frame);

        }];
        
    }
//      [self.view addSubview:self.showMoney];

}
//分次付款的金额显示
-(void)setSepMoney
{
    self.sepMoneyView = [[UIView alloc]init];
//    if (self.minPrice >= self.holdPrice) {
//        self.btn2.enabled = NO;
//    }
    [KSHttpRequest post:KisInWhiteList parameters:nil success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
//            self.btn1.userInteractionEnabled = NO;
//            self.btn2.userInteractionEnabled = NO;
            self.btn1.enabled = NO;
            self.btn2.enabled = NO;
            self.isInWhiteList = YES;
            self.sepMoney.hidden = YES;
//            self.fullMoney.hidden = YES;
            self.myTextField.hidden = NO;
            [self.myTextField setBorderStyle:UITextBorderStyleRoundedRect];
            self.myTextField.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
            self.myTextField.textColor = R_G_B_16(0xFF4E00);
            self.myTextField.textAlignment = NSTextAlignmentCenter;
            [self.sepMoneyView addSubview:self.myTextField];
            
            [self separeteMoney];
            //    self.fullMoney.hidden = YES;
            self.sepMoneyView.hidden = YES;
            return ;
            
        }
        else if ([result[@"code"] integerValue] == 100)
        {
        }

    } failure:^(NSError *error) {
        
    }];
    
        self.myTextField.hidden = YES;
        //            self.sepMoney.hidden = NO;
        [self.sepMoneyView addSubview:self.sepMoney];
        
        if ([self.minPrice doubleValue] > [self.holdPrice doubleValue]) {
            _Money = self.holdPrice;
            self.sepMoney.text = [NSString stringWithFormat:@"¥%.2f",[self.holdPrice doubleValue]];
        }
        else
        {
            _Money = self.minPrice;
            self.sepMoney.text = [NSString stringWithFormat:@"¥%.2f",[self.minPrice doubleValue]];
            
        }

     [self separeteMoney];
    //    self.fullMoney.hidden = YES;
    self.sepMoneyView.hidden = YES;
    
}


-(void)separeteMoney
{
    self.sepMoneyView.frame = CGRectMake(0, 0, ScreenWidth, self.showMoney.height);
    [self.showMoney addSubview:self.sepMoneyView];

    self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(200), PX_TO_PT(24), PX_TO_PT(51), PX_TO_PT(52))];
    self.btn1.tag = 3;
    self.btn1.enabled = NO;
    [self.btn1 setImage:[UIImage imageNamed:@"01_discount_default1"] forState:UIControlStateNormal];
    [self.btn1 setImage:[UIImage imageNamed:@"05_discount_press1"] forState:UIControlStateSelected];
    [self.btn1 setImage:[UIImage imageNamed:@"03_discount_gray1"] forState:UIControlStateDisabled];
    [self.btn1 addTarget:self action:@selector(reviseMoney:) forControlEvents:UIControlEventTouchDown];
    [self.sepMoneyView addSubview:self.btn1];
    
    self.btn2 = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(480), PX_TO_PT(24), PX_TO_PT(51), PX_TO_PT(52))];
    self.btn2.tag = 4;
    [self.btn2 setImage:[UIImage imageNamed:@"02_discount_default2"] forState:UIControlStateNormal];
    [self.btn2 setImage: [UIImage imageNamed:@"06_discount_press2"] forState:UIControlStateSelected];
    [self.btn2 setImage:[UIImage imageNamed:@"04_discount_gray2"] forState:UIControlStateDisabled];
    [self.btn2 addTarget:self action:@selector(reviseMoney:) forControlEvents:UIControlEventTouchDown];
    [self.sepMoneyView addSubview:self.btn2];
    if ([_Money doubleValue] == [self.holdPrice doubleValue]) {
        self.btn2.enabled = NO;
    }

    
    UILabel *str = [[UILabel alloc]initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, PX_TO_PT(23))];
    str.backgroundColor = [UIColor whiteColor];
    str.textAlignment = UITextAlignmentCenter;
    str.text = [NSString stringWithFormat:@"+-可调节金额，幅度500元；最低调至%@元，不足按实际金额支付",self.minPrice];
    str.font = [UIFont systemFontOfSize:PX_TO_PT(20)];
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:str.text];
    NSDictionary *depositStr=@{
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(24)]
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(0,2)];
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(10,3)];
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(19,4)];
    
    [str setAttributedText:AttributedStringDeposit];
    [self.sepMoneyView addSubview:str];
//    [self.midView addSubview:self.sepMoneyView];
}

-(void)reviseMoney:(UIButton *)sender
{
    NSString *s =[self.sepMoney.text substringFromIndex:1];
    sender.enabled = YES;
    if (sender.tag == 3 && ([s doubleValue] <= [self.minPrice doubleValue])) {
        sender.enabled = NO;
        self.btn2.enabled = YES;
    }
    else if(sender.tag == 3 && ([s doubleValue] - 500) < [self.minPrice doubleValue])
    {
        _Money = self.minPrice;
        sender.enabled = NO;
        self.sepMoney.text = [NSString stringWithFormat:@"¥%.2f",[self.minPrice doubleValue]];

    }
    else if (sender.tag == 4 && ([s doubleValue]+500) > [self.holdPrice doubleValue])
    {
        
        _Money = self.holdPrice;
        sender.enabled = NO;
        self.btn1.enabled = YES;
        self.sepMoney.text = [NSString stringWithFormat:@"¥%.2f",[self.holdPrice doubleValue]];
    }
    else if ([self.holdPrice doubleValue] < [self.minPrice doubleValue])
    {
        _Money = self.holdPrice;
        self.sepMoney.text = [NSString stringWithFormat:@"¥%.2f",[self.holdPrice doubleValue]];
    }
    else
    {
       float mon = [s doubleValue];
        if (sender.tag == 3) {
            self.btn2.enabled = YES;
            mon -= 500.00;
        }
        else if(sender.tag == 4) {
            self.btn1.enabled = YES;
            mon += 500.00;
        }
        
        if (mon >= [self.holdPrice doubleValue]) {
            self.btn2.enabled = NO;
        }
        else if(mon <= [self.minPrice doubleValue])
        {
            self.btn1.enabled = NO;
        }
        _Money = [NSString stringWithFormat:@"%.2f",mon];

        self.sepMoney.text = [NSString stringWithFormat:@"¥%.2f",[_Money doubleValue]];
    }
    
//    sender.userInteractionEnabled = YES;
//    sender.enabled = YES;

}

-(void)selectedBtnClick:(UIButton *)button{
    
    if(!self.isFirst)
    {
        _Money = self.payMoney;
        self.isFirst = YES;
    }
    self.currentSelBtn = button;
    self.tempBtn.selected = NO;
    button.selected = YES;
    self.tempBtn = button;
    [self SelPayType];
    NSLog(@"%@",_Money);
}
-(void)SelPayType
{
    if (self.currentSelBtn.tag == kSelectedBtn) {
        self.selectedBtnOne.selected = YES;
        self.selectedBtnTwo.selected = NO;
        _payType = 1;
        [self payType];
        
    }else if (self.currentSelBtn.tag == kSelectedBtn + 1){
        self.selectedBtnTwo.selected = YES;
        self.selectedBtnOne.selected = NO;
        _payType = 2;
        [self payType];
        
    }else if (self.currentSelBtn.tag == kSelectedBtn + 2){
        
    }else{
        
    }
    

}
-(void)setselPayType
{
    if (self.currentSelBtn.tag == kSelectedBtn) {
//        self.selectedBtnOne.selected = YES;
//        self.selectedBtnTwo.selected = NO;
//        _payType = 1;
//        [self payType];
        NSDictionary *params = @{@"consumer":@"app",@"orderId":self.orderID,@"price": _Money,@"user-agent":@"IOS-v2.0"};
        [KSHttpRequest post:KAlipay parameters:params success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                _PaymentId = result[@"paymentId"];
                _Money = result[@"price"];
            }
            if (_ispayType == YES) {
                [GBAlipayManager alipayWithPartner:PartnerID
                                            seller:SellerID
                                           tradeNO:_PaymentId
                                       productName:@"新新农人产品"
                                productDescription:nil
                                            amount:_Money
                                         notifyURL:KDynamic
                                            itBPay:@"30m"];
                _ispayType = NO;
            }
            

        } failure:^(NSError *error) {
            
            
        }];
        
        
    }else if (self.currentSelBtn.tag == kSelectedBtn + 1){
//        self.selectedBtnTwo.selected = YES;
//        self.selectedBtnOne.selected = NO;
//        _payType = 2;
//        [self payType];
        // 获取tn
        [KSHttpRequest post:KUnionpay parameters:@{@"consumer":@"app",@"responseStyle":@"v1.0",@"orderId":self.orderID,@"price":_Money,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            
            _Tn = result[@"tn"];
            if (_ispayType == YES) {
                [UPPayPlugin startPay:_Tn mode:kMode_Development viewController:self delegate:self];
                _ispayType = NO;

            }
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }else if (self.currentSelBtn.tag == kSelectedBtn + 2){
        
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
    goPayBtn.frame = CGRectMake(PX_TO_PT(32), ScreenHeight - PX_TO_PT(40)-PX_TO_PT(89)-64, ScreenWidth - PX_TO_PT(32)*2, PX_TO_PT(89));
    goPayBtn.backgroundColor = R_G_B_16(0xFE9B00);
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
    if (_isInWhiteList && !self.isFull)  {
        if ([self.myTextField.text doubleValue] == 0.00) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入金额" delegate:nil
                                                     cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
        _Money = self.myTextField.text;
    }
    
    if (self.isFull) {
        _Money = self.holdPrice;
    }
    _ispayType = YES;
    [self setselPayType];
    NSLog(@"去支付");
//
//    NSLog(@"%ld",[_Money integerValue]);
    
    
//    XNROrderSuccessViewController*vc=[[XNROrderSuccessViewController alloc]init];
//    vc.money = _Money;
//    vc.orderID = self.orderID;
//    vc.fromType = self.fromType;
//    vc.paymentId = self.paymentId;
//    vc.recieveName = self.recieveName;
//    vc.recievePhone = self.recievePhone;
//    vc.recieveAddress = self.recieveAddress;
//    vc.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"]) {
        XNROrderSuccessViewController *vc = [[XNROrderSuccessViewController alloc] init];
        vc.money = self.Money;
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
        vc.money = self.Money;
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[XNRShoppingCarController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    for (UIViewController *vc  in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XNRProductInfo_VC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField delegate
//textField.text 输入之前的值 string 输入的字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    //                    [self showError:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian = YES;
                    return YES;
                    
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }
        else
        {//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
   
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [self.myTextField resignFirstResponder];
//}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    _Money = self.myTextField.text;
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    CGPoint point = [touch  locationInView:view];
    
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2);
    if (CGRectContainsPoint(rect, point)) {
        
        [self.myTextField resignFirstResponder];
        _Money = self.myTextField.text;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
