//
//  XNRRscIdentifyPayView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/26.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscIdentifyPayView.h"
#import "XNRRscPayTypeModel.h"

#define KpayTypeBtn 1000

@interface XNRRscIdentifyPayView()

@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, weak) UIView *identifyView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@property (nonatomic, weak) UIButton *payTypeBtn;

@property (nonatomic, weak) UIButton *tempBtn;

@property (nonatomic, weak) UIImageView *selectedImageView;

@property (nonatomic, strong) NSMutableArray *payTypeArray;

@property (nonatomic, copy) NSString *paymentId;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *type;

@end

@implementation XNRRscIdentifyPayView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _payTypeArray = [NSMutableArray array];
        [self getOfflinePayTypeData];
        [self createView];
    }
    return self;
}

-(void)getOfflinePayTypeData
{
    [KSHttpRequest get:KGetOfflinePayType parameters:nil success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSArray *offlinePayType = result[@"offlinePayType"];
            for (NSDictionary *dict in offlinePayType) {
                XNRRscPayTypeModel *model = [[XNRRscPayTypeModel alloc] init];
                model.type = dict[@"type"];
                model.name = dict[@"name"];
                [_payTypeArray addObject:model];
            }
            [self createPayTypeBtn];
        }
        
    } failure:^(NSError *error) {
        
    }];

}

-(void)createView
{
    UIView *coverView = [[UIView alloc] initWithFrame:AppKeyWindow.bounds];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)]];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.4;
    self.coverView = coverView;
    [AppKeyWindow addSubview:coverView];
    
    UIView *identifyView = [[UIView alloc] init];
    identifyView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(882));
    identifyView.backgroundColor = [UIColor whiteColor];
    identifyView.userInteractionEnabled = YES;
    self.identifyView = identifyView;
    [AppKeyWindow addSubview:identifyView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
    headView.backgroundColor = R_G_B_16(0xfafafa);
    [identifyView addSubview:headView];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth, PX_TO_PT(88))];
    stateLabel.textColor = R_G_B_16(0x323232);
    stateLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    stateLabel.text = @"审核付款";
    [identifyView addSubview:stateLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(34)-PX_TO_PT(30), PX_TO_PT(27), PX_TO_PT(34), PX_TO_PT(34))];
    [cancelBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [identifyView addSubview:cancelBtn];
    
    [self createMiddleView];
    
    [self createBottomView];
}

-(void)createMiddleView
{
    NSArray *titleArray = @[@"用户选择线下支付方式，请核对线下支付信息",@"收货人姓名",@"待审金额",@"付款方式"];
    
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30),PX_TO_PT(88)+PX_TO_PT(88)*i, ScreenWidth,PX_TO_PT(88))];
        titleLabel.textColor = R_G_B_16(0x646464);
        titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        titleLabel.text = titleArray[i];
        [self.identifyView addSubview:titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(88)*(i+1), ScreenWidth, PX_TO_PT(1))];
        line.backgroundColor = R_G_B_16(0xc7c7c7);
        [self.identifyView addSubview:line];
        
    }
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200), PX_TO_PT(88)*2, ScreenWidth, PX_TO_PT(88))];
        nameLabel.textColor = R_G_B_16(0xfe9b00);
        nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        self.nameLabel = nameLabel;
        [self.identifyView addSubview:nameLabel];
    
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200), PX_TO_PT(88)*3, ScreenWidth, PX_TO_PT(88))];
        priceLabel.textColor = R_G_B_16(0xfe9b00);
        priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        self.priceLabel = priceLabel;
        [self.identifyView addSubview:priceLabel];
}

-(void)createPayTypeBtn{
    
    for (int i = 0; i<_payTypeArray.count; i++) {
        XNRRscPayTypeModel *model = _payTypeArray[i];
        UIButton *payTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        payTypeBtn.frame = CGRectMake(PX_TO_PT(200)+PX_TO_PT(229)*i, PX_TO_PT(88)*4+PX_TO_PT(20), PX_TO_PT(169), PX_TO_PT(53));
        [payTypeBtn setTitle:model.name forState:UIControlStateNormal];
        payTypeBtn.tag = KpayTypeBtn + i;
        [payTypeBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
        payTypeBtn.layer.borderWidth = PX_TO_PT(1);
        payTypeBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        payTypeBtn.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
        [payTypeBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#c7c7c7"]] forState:UIControlStateNormal];
        [payTypeBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fe9b00"]] forState:UIControlStateSelected];
        [payTypeBtn addTarget:self action:@selector(payTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.payTypeBtn = payTypeBtn;
        [self.identifyView addSubview:payTypeBtn];
        
        if (i == 0) {
            [self payTypeBtnClick:payTypeBtn];
        }
    }

}
-(void)payTypeBtnClick:(UIButton *)button
{
    _tempBtn.selected = NO;
    button.selected = YES;
    _tempBtn = button;
    
    XNRRscPayTypeModel *model = _payTypeArray[button.tag - KpayTypeBtn];
    _type = model.type;
    
}

-(void)createBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(782), ScreenWidth, PX_TO_PT(100))];
    bottomView.backgroundColor = R_G_B_16(0xffffff);
    [self.identifyView addSubview:bottomView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xc7c7c7);
    [bottomView addSubview:line];
    
    UIButton *admireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    admireBtn.frame = CGRectMake(0, 0, PX_TO_PT(180), PX_TO_PT(52));
    admireBtn.center = CGPointMake(ScreenWidth/2, PX_TO_PT(50));
    [admireBtn setTitle:@"确定" forState:UIControlStateNormal];
    [admireBtn setTitleColor:R_G_B_16(0xffffff) forState:UIControlStateNormal];
    admireBtn.backgroundColor = R_G_B_16(0xfe9b00);
    admireBtn.layer.cornerRadius = 5.0;
    admireBtn.layer.masksToBounds = YES;
    [admireBtn addTarget:self action:@selector(admireBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:admireBtn];
}

-(void)admireBtnClick
{
    NSDictionary *params = @{@"paymentId":_paymentId,@"price":_price,@"offlinePayType":_type};
    NSLog(@"ppppppp%@",params);
    [KSHttpRequest get:KRscConfirmOfflinePay parameters:params success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            [self cancel];
            // 刷新tableView
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshIdentifyTableView" object:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)cancelBtnClick
{
    [self cancel];
}

-(void)show:(NSString *)name andPrice:(NSString *)price andPaymentId:(NSString *)paymentId
{
    _paymentId = paymentId;
    _price = price;
    self.nameLabel.text = name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f元",[price doubleValue]];
    self.coverView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.identifyView.frame  =  CGRectMake(0, ScreenHeight-PX_TO_PT(882), ScreenWidth, PX_TO_PT(882));
    }];
    
}

-(void)cancel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.identifyView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
    }];
    
}

@end
