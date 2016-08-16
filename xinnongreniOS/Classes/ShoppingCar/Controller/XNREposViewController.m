//
//  XNREposViewController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/7/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNREposViewController.h"
#import "XNREposAddressViewController.h"
@interface XNREposViewController()

@property (nonatomic, weak) UIScrollView *mainScrollView;

@property (nonatomic, weak) UIView *topView;

@property (nonatomic, weak) UIView *middleView;

@property (nonatomic, weak) UIView *bgView;

@end

@implementation XNREposViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavgation];
    NSLog(@"===rscModel===%@====",_rscModel);
    [self createUI];
    [self getData];
}


-(void)createUI
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.mainScrollView = mainScrollView;
    
    [self.view addSubview:mainScrollView];
    
    [self createTopView];
    
    [self createMiddleView];
    
    [self createBottomView];
    
}

-(void)createTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(180))];
    topView.backgroundColor = R_G_B_16(0xffffff);
    self.topView = topView;
    [self.mainScrollView addSubview:topView];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(61), PX_TO_PT(148), PX_TO_PT(58))];
    iconImage.image = [UIImage imageNamed:@"the-pay_logo-"];
    [topView addSubview:iconImage];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+PX_TO_PT(60), 0, ScreenWidth/2, PX_TO_PT(180))];
    priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    priceLabel.textColor = R_G_B_16(0x646464);
    priceLabel.text = [NSString stringWithFormat:@"待支付金额：¥ %@",_price];
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:priceLabel.text];
    NSDictionary *depositStr=@{
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(6,AttributedStringDeposit.length-6)];
    [priceLabel setAttributedText:AttributedStringDeposit];
    [topView addSubview:priceLabel];
}

-(void)createMiddleView
{
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, PX_TO_PT(68))];
    self.middleView = middleView;
    middleView.backgroundColor = R_G_B_16(0xf4f4f4);
    [self.mainScrollView addSubview:middleView];
    
    UILabel *middleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth, PX_TO_PT(68))];
    middleLabel.text = @"您需要到服务网点连接全民付POS机后刷卡支付";
    middleLabel.textColor = R_G_B_16(0x646464);
    middleLabel.font = XNRFont14;
    [middleView addSubview:middleLabel];
    
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*PX_TO_PT(68), ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [middleView addSubview:lineView];
    }
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = R_G_B_16(0xffffff);
    self.bgView = bgView;
    [self.mainScrollView addSubview:bgView];
    
    UILabel *serverLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth, PX_TO_PT(90))];
    serverLabel.text = @"服务网点在哪儿？";
    serverLabel.textColor = R_G_B_16(0x646464);
    serverLabel.font = XNRFont15;
    [bgView addSubview:serverLabel];
    
    if (_rscModel == nil||_rscModel.companyName == nil) {
        UIImageView *emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(126))*0.5, CGRectGetMaxY(serverLabel.frame)+PX_TO_PT(30), PX_TO_PT(126), PX_TO_PT(116))];
        [emptyImageView setImage:[UIImage imageNamed:@"branches-"]];
        [bgView addSubview:emptyImageView];
        
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(emptyImageView.frame)+PX_TO_PT(60), ScreenWidth, PX_TO_PT(30))];
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.text = @"小新正在为您匹配最近的网点，请稍后从我的订单查看";
        emptyLabel.textColor = R_G_B_16(0x646464);
        emptyLabel.font = XNRFont15;
        [bgView addSubview:emptyLabel];
        
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(360), ScreenWidth, PX_TO_PT(90))];
        [bgView addSubview:btnView];
        
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(250), 0, PX_TO_PT(170), PX_TO_PT(90))];
        [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [checkBtn setTitle:@"查看其它网点" forState:UIControlStateNormal];
        [checkBtn setTitleColor:R_G_B_16(0x646464) forState:UIControlStateNormal];
        checkBtn.titleLabel.font = XNRFont14;
        [btnView addSubview:checkBtn];
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkBtn.frame)+PX_TO_PT(30), PX_TO_PT(32), PX_TO_PT(16), PX_TO_PT(28))];
        [arrowImage setImage:[UIImage imageNamed:@"arrow-1"]];
        [btnView addSubview:arrowImage];
        
        bgView.frame = CGRectMake(0, CGRectGetMaxY(middleView.frame), ScreenWidth, PX_TO_PT(540));
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(0), ScreenWidth, PX_TO_PT(1))];
        topLine.backgroundColor = R_G_B_16(0xe0e0e0);
        [bgView addSubview:topLine];
        
        
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(90), ScreenWidth, PX_TO_PT(1))];
        middleLine.backgroundColor = R_G_B_16(0xe0e0e0);
        [bgView addSubview:middleLine];
        
        UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(360), ScreenWidth, PX_TO_PT(1))];
        
        Line.backgroundColor = R_G_B_16(0xe0e0e0);
        [bgView addSubview:Line];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(450), ScreenWidth, PX_TO_PT(1))];
        bottomLine.backgroundColor = R_G_B_16(0xe0e0e0);
        [bgView addSubview:bottomLine];

        
    }else{
        UILabel *rscLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(90), PX_TO_PT(124), PX_TO_PT(90))];
        rscLabel.text = @"网点名称";
        rscLabel.textColor = R_G_B_16(0x646464);
        rscLabel.font = XNRFont15;
        [bgView addSubview:rscLabel];
        
        UILabel *rscNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rscLabel.frame)+PX_TO_PT(30), PX_TO_PT(90), ScreenWidth, PX_TO_PT(90))];
        rscNameLabel.text = _rscModel.companyName;
        rscNameLabel.textColor = R_G_B_16(0x323232);
        rscNameLabel.font = XNRFont15;
        [bgView addSubview:rscNameLabel];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(210), PX_TO_PT(62), PX_TO_PT(30))];
        addressLabel.text = @"地址";
        addressLabel.textColor = R_G_B_16(0x646464);
        addressLabel.font = XNRFont15;
        [bgView addSubview:addressLabel];
        
        UILabel *addressNameLabel = [[UILabel alloc] init];
        addressNameLabel.textColor = R_G_B_16(0x323232);
        addressNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
        addressNameLabel.numberOfLines = 0;
        if (_isfromOrderVC) {
            addressNameLabel.text = _rscModel.RSCAddress;
        }else{
            XNRCompanyAddressModel *addressModel = [XNRCompanyAddressModel objectWithKeyValues:_rscModel.companyAddress];
            NSMutableString *str = [NSMutableString string];
            if (addressModel.province.count > 0) {
                [str appendString:addressModel.province[@"name"]];
            }
            if (addressModel.city.count > 0) {
                [str appendString:@" "];
                [str appendString:addressModel.city[@"name"]];
            }
            if (addressModel.county.count > 0) {
                [str appendString:@" "];
                [str appendString:addressModel.county[@"name"]];
            }
            if (addressModel.town.count > 0) {
                [str appendString:@" "];
                [str appendString:addressModel.town[@"name"]];
            }
            
            [str appendString:@" "];
            [str appendString:addressModel.details];
            addressNameLabel.text = str;
        }
        
        CGSize addressSize = [addressNameLabel.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(30)] constrainedToSize:CGSizeMake(ScreenWidth-CGRectGetMaxX(rscLabel.frame)-PX_TO_PT(30), MAXFLOAT)];
        
        addressNameLabel.frame = CGRectMake(CGRectGetMaxX(rscLabel.frame)+PX_TO_PT(30), PX_TO_PT(210), addressSize.width, addressSize.height);
        [bgView addSubview:addressNameLabel];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), CGRectGetMaxY(addressNameLabel.frame)+PX_TO_PT(30), PX_TO_PT(60), PX_TO_PT(90))];
        phoneLabel.text = @"电话";
        phoneLabel.textColor = R_G_B_16(0x646464);
        phoneLabel.font = XNRFont15;
        [bgView addSubview:phoneLabel];
        
        UILabel *phoneNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rscLabel.frame)+PX_TO_PT(30), CGRectGetMaxY(addressNameLabel.frame)+PX_TO_PT(30), ScreenWidth, PX_TO_PT(90))];
        if (_isfromOrderVC) {
            phoneNameLabel.text = _rscModel.RSCPhone;
        }else{
            phoneNameLabel.text = _rscModel.phone;
        }
        phoneNameLabel.textColor = R_G_B_16(0x323232);
        phoneNameLabel.font = XNRFont15;
        [bgView addSubview:phoneNameLabel];
        
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneNameLabel.frame), ScreenWidth, PX_TO_PT(90))];
        [bgView addSubview:btnView];
        
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(250), 0, PX_TO_PT(170), PX_TO_PT(90))];
        [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [checkBtn setTitle:@"查看其它网点" forState:UIControlStateNormal];
        [checkBtn setTitleColor:R_G_B_16(0x646464) forState:UIControlStateNormal];
        checkBtn.titleLabel.font = XNRFont14;
        //    checkBtn.backgroundColor = [UIColor redColor];
        [btnView addSubview:checkBtn];
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkBtn.frame)+PX_TO_PT(30), PX_TO_PT(32), PX_TO_PT(16), PX_TO_PT(28))];
        [arrowImage setImage:[UIImage imageNamed:@"arrow-1"]];
        [btnView addSubview:arrowImage];
        
        bgView.frame = CGRectMake(0, CGRectGetMaxY(middleView.frame), ScreenWidth, CGRectGetMaxY(btnView.frame));
        
        for (int i = 0; i<3; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(90)*i, ScreenWidth, PX_TO_PT(1))];
            lineView.backgroundColor = R_G_B_16(0xe0e0e0);
            [bgView addSubview:lineView];
            
        }
        
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addressNameLabel.frame)+PX_TO_PT(29), ScreenWidth, PX_TO_PT(1))];
        middleLine.backgroundColor = R_G_B_16(0xe0e0e0);
        [bgView addSubview:middleLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneNameLabel.frame)-PX_TO_PT(1), ScreenWidth, PX_TO_PT(1))];
        bottomLine.backgroundColor = R_G_B_16(0xe0e0e0);
        [bgView addSubview:bottomLine];
        
        UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnView.frame)-PX_TO_PT(1), ScreenWidth, PX_TO_PT(1))];
        Line.backgroundColor = R_G_B_16(0xe0e0e0);
        [bgView addSubview:Line];

    }
}

-(void)checkBtnClick
{
    XNREposAddressViewController *eposAddressVC = [[XNREposAddressViewController alloc] init];
    eposAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:eposAddressVC animated:YES];
}

-(void)createBottomView
{
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame)+PX_TO_PT(100), ScreenWidth, PX_TO_PT(90));
    [payBtn setTitle:@"立刻支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:R_G_B_16(0xff4e00) forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:payBtn];
}
-(void)payBtnClick
{
    // 设备激活
//    [UMSCashierPlugin setupDevice:@"shouji000000004" BillsTID:@"sj000001" WithViewController:self Delegate:self];
}

// 定义设备设置、激活回调
//-(void)onUMSSetupDevice:(BOOL) resultStatus resultInfo:(NSString *)resultInfo withDeviceId:(NSString *)deviceId
//{
//    if(resultStatus == YES){ // 设备激活成功
//    
//    }else {
//    
//    }
//}

-(void)getData
{
    NSDictionary *params = @{@"orderId":_orderId,
                           @"price":_price
                           };
    [KSHttpRequest get:KEPOSpay parameters:params success:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - 创建导航栏
-(void)createNavgation{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 200, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = R_G_B_16(0xfbffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"全民付EPOS";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
