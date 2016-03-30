//
//  XNRPayInfoTableViewCell.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRPayInfoTableViewCell.h"
@interface XNRPayInfoTableViewCell()
@property (nonatomic,weak) UILabel *numLabel;
@property (nonatomic,weak) UILabel *payMoneyLabel;
@property (nonatomic,weak) UILabel *payTypeLabel;
@property (nonatomic,weak) UILabel *completeLabel;
@property (nonatomic,weak) UIView *line2;
@property (nonatomic,strong) NSArray *arr;

@end

@implementation XNRPayInfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.arr = [NSArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八", nil];
        [self createView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}

-(void)createView{
    
    //次数
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(100), PX_TO_PT(28))];
    numLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.numLabel = numLabel;
    [self.contentView addSubview:_numLabel];
    
    //付款状态
//    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(583), PX_TO_PT(26), PX_TO_PT(110), PX_TO_PT(26))];
//    statusLabel.textAlignment = UITextAlignmentRight;
//    statusLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
//    [self.contentView addSubview:statusLabel];
//    
    //支付金额
    UILabel *payMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(75), ScreenWidth - PX_TO_PT(32), PX_TO_PT(28))];
    payMoneyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payMoneyLabel.textColor = R_G_B_16(0x646464);
    
    self.payMoneyLabel = payMoneyLabel;
    
    [self.contentView addSubview:_payMoneyLabel];
    
    //支付方式
    UILabel *payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(130),ScreenWidth - PX_TO_PT(32), PX_TO_PT(28))];
    payTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    payTypeLabel.textColor = R_G_B_16(0x646464);
    self.payTypeLabel = payTypeLabel;
    [self.contentView addSubview:_payTypeLabel];
    
    //完成时间
    UILabel *completeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(184), ScreenWidth - PX_TO_PT(32), PX_TO_PT(28))];
    completeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    completeLabel.textColor = R_G_B_16(0x646464);
    self.completeLabel = completeLabel;
    [self.contentView addSubview:_completeLabel];
    
    //支付完成
    UILabel *successPay = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(26), ScreenWidth - PX_TO_PT(66), PX_TO_PT(28))];
    successPay.textAlignment = UITextAlignmentRight;
    successPay.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    successPay.text = @"支付成功";
    [self.contentView addSubview:successPay];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(59),ScreenWidth - PX_TO_PT(65), PX_TO_PT(1))];
    line1.backgroundColor = R_G_B_16(0xc7c7c7);
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(222), ScreenWidth, PX_TO_PT(1))];
    line2.backgroundColor = R_G_B_16(0xc7c7c7);
    self.line2 = line2;
    [self.contentView addSubview:line1];
    
    [self.contentView addSubview:line2];
}

-(void)setCellDataWithModel:(XNRPayInfoModel *)model
{
    self.payMoneyLabel.text = [NSString stringWithFormat:@"支付金额：¥%.2f",[model.price floatValue]];
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:_payMoneyLabel.text];
    NSDictionary *dict=@{
                         
                         NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                         
                         };
    [AttributedStringDeposit addAttributes:dict range:NSMakeRange(5,AttributedStringDeposit.length-5)];
    
    [_payMoneyLabel setAttributedText:AttributedStringDeposit];

    int j = model.slice - 1;
    
    self.numLabel.text = [NSString stringWithFormat:@"第%@次",self.arr[j]];

    //付款方式
    if (model.payType) {
        if (model.payType == 1) {
            _payTypeLabel.text = [NSString stringWithFormat:@"付款方式：支付宝支付"];
        }
        else if (model.payType == 2)
        {
            _payTypeLabel.text = [NSString stringWithFormat:@"付款方式：银联支付"];
        }
        else
        {
            _payTypeLabel.frame = CGRectMake(0, 0, 0, 0);
            self.completeLabel.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(130), ScreenWidth - PX_TO_PT(32), PX_TO_PT(28));
            self.line2.frame = CGRectMake(0, PX_TO_PT(184), ScreenWidth, PX_TO_PT(1));

        }
    }
    NSString *str = [model.datePaid substringToIndex:10];
    self.completeLabel.text = [NSString stringWithFormat:@"支付完成时间：%@",str];
}
@end
