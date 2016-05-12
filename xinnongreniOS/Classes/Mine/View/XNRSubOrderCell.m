//
//  XNRSubOrderCell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSubOrderCell.h"
#import "XRNSubOrdersModel.h"

@interface XNRSubOrderCell()

@property (nonatomic,weak) UILabel* stageLabel;
@property (nonatomic,weak) UILabel* statusLabel;
@property (nonatomic,weak) UILabel* shouldPayMoneyLabel;
@property (nonatomic,weak) UILabel* alreadyPayMoneyLabel;
@property (nonatomic,weak) UILabel* payTypeLabel;
@property (nonatomic,weak) UIButton* infoButton;
//@property (nonatomic,assign)BOOL isPay;
@property (nonatomic,strong) XRNSubOrdersModel *model;

@end

static BOOL isPay = NO;

@implementation XNRSubOrderCell
+(void)isFirstPay
{
    isPay = NO;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}

-(void)createView{

    //阶段
    UILabel *stageLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(34), PX_TO_PT(18), PX_TO_PT(200), PX_TO_PT(28))];
    stageLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    stageLabel.textColor = R_G_B_16(0x323232);
    self.stageLabel = stageLabel;
    [self.contentView addSubview:_stageLabel];
    
    //付款状态
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(0), PX_TO_PT(18), ScreenWidth - PX_TO_PT(30), PX_TO_PT(26))];
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.textColor = R_G_B_16(0x323232);
    statusLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.statusLabel = statusLabel;
    [self.contentView addSubview:_statusLabel];
    
    //应付款金额
    UILabel *shouldPayMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(34), PX_TO_PT(88), ScreenWidth - PX_TO_PT(34), PX_TO_PT(28))];
    shouldPayMoneyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    shouldPayMoneyLabel.textColor = R_G_B_16(0x646464);
  
    self.shouldPayMoneyLabel = shouldPayMoneyLabel;
    [self.contentView addSubview:_shouldPayMoneyLabel];
    
    //已付款金额
    UILabel *alreadyPayMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(34), PX_TO_PT(139),ScreenWidth - PX_TO_PT(34), PX_TO_PT(28))];
    alreadyPayMoneyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    alreadyPayMoneyLabel.textColor = R_G_B_16(0x646464);

    self.alreadyPayMoneyLabel = alreadyPayMoneyLabel;
    [self.contentView addSubview:_alreadyPayMoneyLabel];
    
    //查看详情
    UIButton *infoButton = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(590), PX_TO_PT(141), ScreenWidth - PX_TO_PT(613), PX_TO_PT(27))];

    [infoButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [infoButton setTitleColor:R_G_B_16(0x909090) forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchDown];

    infoButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.infoButton = infoButton;
    [self.contentView addSubview:_infoButton];
    
    //付款方式
        UILabel * payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(34), PX_TO_PT(193), ScreenWidth - PX_TO_PT(34), PX_TO_PT(28))];
        payTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payTypeLabel.textColor = R_G_B_16(0x646464);
    self.payTypeLabel = payTypeLabel;
        [self.contentView addSubview:_payTypeLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(58),ScreenWidth - PX_TO_PT(66), PX_TO_PT(1))];
    line1.backgroundColor = R_G_B_16(0xc7c7c7);
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    line2.backgroundColor = R_G_B_16(0xc7c7c7);
    
    [self.contentView addSubview:line1];
    
    [self.contentView addSubview:line2];
}

-(void)setView:(XRNSubOrdersModel *)model
{
    //阶段
    if ([model.type isEqualToString:@"deposit"]) {
        _stageLabel.text = @"阶段一：订金";
    }
    else if ([model.type isEqualToString:@"balance"])
    {
        _stageLabel.text = @"阶段二：尾款";
    }
    else if ([model.type isEqualToString:@"full"])
    {
        _stageLabel.text = @"订单总额";
    }
    
    //付款状态
    NSInteger status = [model.payStatus integerValue];
    _statusLabel.textColor = R_G_B_16(0xfe9b00);

    if (status == 1) {
        _statusLabel.text = @"待付款";
    }
    else if (status == 2)
    {
        _statusLabel.textColor = R_G_B_16(0x323232);
        _statusLabel.text = @"已付款";
    }
    else if (status == 3)
    {
        _statusLabel.text = @"部分付款";
    }

    if (status == 1 && [model.type isEqualToString:@"deposit"]) {
        isPay = YES;
    }
    if ((status == 1 || status == 3) && isPay == YES && [model.type isEqualToString:@"balance"]) {
        _statusLabel.textColor = R_G_B_16(0x323232);
        _statusLabel.text = @"未开始";
    }
    
    if ([_value isEqualToString:@"交易关闭"]) {
        _statusLabel.textColor = R_G_B_16(0x323232);
        _statusLabel.text = @"已关闭";
        
    }

    //应付款金额
    _shouldPayMoneyLabel.text = [NSString stringWithFormat:@"应支付金额：¥%.2f",[model.price doubleValue]];
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:_shouldPayMoneyLabel.text];
    NSDictionary *dict=@{
                         
                         NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                         
                         };
    [AttributedStringDeposit addAttributes:dict range:NSMakeRange(6,AttributedStringDeposit.length-6)];
    
    [_shouldPayMoneyLabel setAttributedText:AttributedStringDeposit];


    //已付款金额
    _alreadyPayMoneyLabel.text = [NSString stringWithFormat:@"已支付金额：¥%.2f",[model.paidPrice doubleValue]];
    
    NSMutableAttributedString *AttributedStringDeposit1 = [[NSMutableAttributedString alloc]initWithString:_alreadyPayMoneyLabel.text];
    NSDictionary *dict1=@{
                          
                          NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                          
                          };
    [AttributedStringDeposit1 addAttributes:dict1 range:NSMakeRange(6,AttributedStringDeposit1.length-6)];
    
    [_alreadyPayMoneyLabel setAttributedText:AttributedStringDeposit1];

    //付款方式
    if ([model.id isEqualToString:@"f5aa22bb51"]) {
        NSLog(@"%d",model.payType);
    }
    if (model.payType) {
        if (model.payType == 1)
        {
            _payTypeLabel.text = [NSString stringWithFormat:@"付款方式：支付宝支付"];
        }
        else if(model.payType == 2)
        {
            _payTypeLabel.text = [NSString stringWithFormat:@"付款方式：银联支付"];
        }
        
        else if(model.payType == 3)
        {
            _payTypeLabel.text = [NSString stringWithFormat:@"付款方式：线下支付"];
        }
        else if(model.payType == 4)
        {
            _payTypeLabel.text = [NSString stringWithFormat:@"付款方式：线下POS机"];
        }

        else
        {
            _payTypeLabel.frame = CGRectMake(0, 0, 0, 0);
        }

    }
    else
    {
        _payTypeLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
    if (model.payments) {
        if (model.payments.count > 0) {
            self.infoButton.hidden = NO;
        }
        else
        {
            self.infoButton.hidden = YES;
        }
    }
    else
    {
        self.infoButton.hidden = YES;
    }
    
}
-(void)infoButtonClick:(UIButton *)sender
{

//    NSDictionary *dict = [[NSDictionary alloc]initWithObjects:self.model forKeys:@"info"];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.model,@"info", nil];
    NSNotification *notification = [[NSNotification alloc]initWithName:@"payInfoClick" object:nil userInfo:dict];
    
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}
-(void)setCellDataWithModel:(XRNSubOrdersModel *)model
{
    _model = model;
    [self setView:model];
}
@end
