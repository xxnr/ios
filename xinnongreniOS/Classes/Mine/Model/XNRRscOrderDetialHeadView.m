//
//  XNRRscOrderDetialHeadView.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscOrderDetialHeadView.h"
#import "XNRRscOrderDetailModel.h"
#import "XNRRscOrderModel.h"
@interface XNRRscOrderDetialHeadView()

@property (nonatomic, weak) UIView *tableHeadView;
@property (nonatomic, weak) UIView *headView;
@property (nonatomic, weak) UIView *middleView;

@property (nonatomic, weak) UILabel *orderNumber;
@property (nonatomic, weak) UILabel *deliverState;
@property (nonatomic, weak) UILabel *orderDate;

@property (nonatomic, weak) UILabel *deliverStyleDetial;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *phoneLabel;


@property (nonatomic, weak) UILabel *depisitStateOne;
@property (nonatomic, weak) UILabel *shouldPayOne;
@property (nonatomic, weak) UILabel *depisitStateTwo;
@property (nonatomic, weak) UILabel *shouldPayTwo;



@property (nonatomic, strong) XNRRscOrderDetailModel *model;


@end

@implementation XNRRscOrderDetialHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)createView:(XNRRscOrderDetailModel *)model
{
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(798))];
    tableHeadView.backgroundColor = R_G_B_16(0xf4f4f4);
    self.tableHeadView = tableHeadView;
    [self addSubview:tableHeadView];
    
    [self createTableHeadView:model];


}

-(void)createTableHeadView:(XNRRscOrderDetailModel *)model
{
    
    
    [self createHeadView];
    
    NSDictionary *subDict = model.deliveryType;
    if ([subDict[@"type"] integerValue] == 2) {    //配送到户
        
        UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth, PX_TO_PT(280))];
        middleView.backgroundColor = R_G_B_16(0xfffaf0);
        self.middleView = middleView;
        [self.tableHeadView addSubview:middleView];
        
        UIView *deliverStyleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80))];
        deliverStyleView.backgroundColor = R_G_B_16(0xffffff);
        [middleView addSubview:deliverStyleView];
        
        UILabel *deliverStyle = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth/2, PX_TO_PT(80))];
        deliverStyle.textColor = R_G_B_16(0x323232);
        deliverStyle.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        deliverStyle.text = @"配送方式";
        [deliverStyleView addSubview:deliverStyle];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(200), PX_TO_PT(27), PX_TO_PT(34), PX_TO_PT(31))];
        imageView.image = [UIImage imageNamed:@"mention-icon-"];
        [middleView addSubview:imageView];
        
        UILabel *deliverStyleDetial = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+PX_TO_PT(20), 0, PX_TO_PT(130), PX_TO_PT(80))];
        deliverStyleDetial.textColor = R_G_B_16(0x646464);
        deliverStyleDetial.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        self.deliverStyleDetial = deliverStyleDetial;
        [middleView addSubview:deliverStyleDetial];


        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(6))];
        [topImageView setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
        [middleView addSubview:topImageView];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(251), ScreenWidth, PX_TO_PT(7))];
        [bottomImageView setImage:[UIImage imageNamed:@"orderInfo_down"]];
        [middleView addSubview:bottomImageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(64), PX_TO_PT(112), ScreenWidth/3, PX_TO_PT(38))];
        nameLabel.textColor = R_G_B_16(0x323232);
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = model.consigneeName;
        self.nameLabel = nameLabel;
        [middleView addSubview:nameLabel];
        
        UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), PX_TO_PT(112), ScreenWidth/2, PX_TO_PT(32))];
        phoneNum.textColor = R_G_B_16(0x323232);
        phoneNum.font = [UIFont systemFontOfSize:16];
        phoneNum.text = model.consigneePhone;
        [middleView addSubview:phoneNum];
        
        UIImageView *addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(35))];
        [addressImage setImage:[UIImage imageNamed:@"orderInfo_address_picture"]];
        [middleView addSubview:addressImage];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressImage.frame) + PX_TO_PT(20), CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(32), ScreenWidth-CGRectGetMaxX(addressImage.frame) - PX_TO_PT(52), PX_TO_PT(32))];
        addressLabel.textColor = R_G_B_16(0xc7c7c7);
        addressLabel.font = [UIFont systemFontOfSize:16];
        addressLabel.adjustsFontSizeToFitWidth = YES;
        addressLabel.text = model.consigneeAddress;
        [middleView addSubview:addressLabel];
        
        UIView *middleMarginView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(260), ScreenWidth, PX_TO_PT(20))];
        middleMarginView.backgroundColor = R_G_B_16(0xf4f4f4);
        [middleView addSubview:middleMarginView];


    }else{  // 网点自提
        [self createMiddleView];
    }

    
    [self createBottomView];
    
    
}
-(void)createHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(150))];
    headView.backgroundColor = R_G_B_16(0xffffff);
    self.headView = headView;
    [self.tableHeadView addSubview:headView];
    
    UILabel *orderNumber = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(0), ScreenWidth/2, PX_TO_PT(65))];
    orderNumber.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    orderNumber.textColor = R_G_B_16(0x323232);
    self.orderNumber = orderNumber;
    [headView addSubview:orderNumber];
    
    UILabel *deliverState = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(0), ScreenWidth/2-PX_TO_PT(30), PX_TO_PT(65))];
    deliverState.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    deliverState.textAlignment = NSTextAlignmentRight;
    deliverState.textColor = R_G_B_16(0xfe9b00);
    deliverState.text = @"待自提";
    self.deliverState  =deliverState;
    [headView addSubview:deliverState];
    
    
    UILabel *orderDate = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), CGRectGetMaxY(orderNumber.frame), ScreenWidth, PX_TO_PT(65))];
    orderDate.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    orderDate.textColor = R_G_B_16(0x323232);
    self.orderDate = orderDate;
    [headView addSubview:orderDate];
    
    UIView *bottomMarginView =[[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(130), ScreenWidth, PX_TO_PT(20))];
    bottomMarginView.backgroundColor = R_G_B_16(0xf4f4f4);
    [headView addSubview:bottomMarginView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(0), ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [headView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(130), ScreenWidth, PX_TO_PT(1))];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [headView addSubview:bottomLine];
    
}

-(void)createMiddleView
{
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth, PX_TO_PT(180))];
    middleView.backgroundColor = R_G_B_16(0xffffff);
    self.middleView = middleView;
    [self.tableHeadView addSubview:middleView];
    
    UILabel *deliverStyle = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth/2, PX_TO_PT(80))];
    deliverStyle.textColor = R_G_B_16(0x323232);
    deliverStyle.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    deliverStyle.text = @"配送方式";
    [middleView addSubview:deliverStyle];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(200), PX_TO_PT(27), PX_TO_PT(34), PX_TO_PT(31))];
    imageView.image = [UIImage imageNamed:@"mention-icon-"];
    [middleView addSubview:imageView];
    
    UILabel *deliverStyleDetial = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+PX_TO_PT(20), 0, PX_TO_PT(130), PX_TO_PT(80))];
    deliverStyleDetial.textColor = R_G_B_16(0x646464);
    deliverStyleDetial.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.deliverStyleDetial = deliverStyleDetial;
    [middleView addSubview:deliverStyleDetial];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(30),PX_TO_PT(80)+PX_TO_PT(28), PX_TO_PT(32), PX_TO_PT(32))];
    imageView1.image = [UIImage imageNamed:@"call-contact"];
    [middleView addSubview:imageView1];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+PX_TO_PT(20), PX_TO_PT(80), PX_TO_PT(150), PX_TO_PT(80))];
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.nameLabel = nameLabel;
    [middleView addSubview:nameLabel];
    
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), PX_TO_PT(80), PX_TO_PT(200), PX_TO_PT(80))];
    phoneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.phoneLabel = phoneLabel;
    [middleView addSubview:phoneLabel];
    
    UIView *middleMarginView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(160), ScreenWidth, PX_TO_PT(20))];
    middleMarginView.backgroundColor = R_G_B_16(0xf4f4f4);
    [middleView addSubview:middleMarginView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [middleView addSubview:topLine];
    
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(1))];
    middleLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [middleView addSubview:middleLine];
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(160), ScreenWidth, PX_TO_PT(1))];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [middleView addSubview:bottomLine];
}

-(void)createBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.middleView.frame), ScreenWidth, PX_TO_PT(448))];
    bottomView.backgroundColor = R_G_B_16(0xffffff);
    [self.tableHeadView addSubview:bottomView];
    
    UILabel *payInfo = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth, PX_TO_PT(80))];
    payInfo.textColor = R_G_B_16(0x323232);
    payInfo.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    payInfo.text = @"支付信息";
    [bottomView addSubview:payInfo];
    
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [bottomView addSubview:topLine];
    
    UIView *topLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80),ScreenWidth, PX_TO_PT(1))];
    topLine1.backgroundColor = R_G_B_16(0xc7c7c7);
    [bottomView addSubview:topLine1];
    
    
    UILabel *stageOne = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(80), ScreenWidth, PX_TO_PT(65))];
    stageOne.text = @"阶段一：订金";
    stageOne.textColor = R_G_B_16(0x323232);
    stageOne.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [bottomView addSubview:stageOne];
    
    
    UILabel *depisitStateOne = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(80), ScreenWidth/2-PX_TO_PT(30), PX_TO_PT(65))];
    depisitStateOne.text = @"已付款";
    depisitStateOne.textColor = R_G_B_16(0xfe9b00);
    depisitStateOne.textAlignment = NSTextAlignmentRight;
    depisitStateOne.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.depisitStateOne = depisitStateOne;
    [bottomView addSubview:depisitStateOne];
    
    UILabel *shouldPayOne = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(145), ScreenWidth, PX_TO_PT(65))];
    shouldPayOne.textColor = R_G_B_16(0x323232);
    shouldPayOne.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.shouldPayOne = shouldPayOne;
    [bottomView addSubview:shouldPayOne];
    
    
    UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(210),ScreenWidth-PX_TO_PT(60), PX_TO_PT(1))];
    topLine2.backgroundColor = R_G_B_16(0xc7c7c7);
    [bottomView addSubview:topLine2];
    
    
    UILabel *stageTwo = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(210), ScreenWidth, PX_TO_PT(79))];
    stageTwo.text = @"阶段二：尾款";
    stageTwo.textColor = R_G_B_16(0x323232);
    stageTwo.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [bottomView addSubview:stageTwo];
    
    
    UILabel *depisitStateTwo = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2,PX_TO_PT(210), ScreenWidth/2-PX_TO_PT(30), PX_TO_PT(65))];
    depisitStateTwo.text = @"已付款";
    depisitStateTwo.textColor = R_G_B_16(0xfe9b00);
    depisitStateTwo.textAlignment = NSTextAlignmentRight;
    depisitStateTwo.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.depisitStateTwo = depisitStateTwo;
    [bottomView addSubview:depisitStateTwo];
    
    UILabel *shouldPayTwo = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30),PX_TO_PT(275), ScreenWidth, PX_TO_PT(65))];
    shouldPayTwo.textColor = R_G_B_16(0x323232);
    shouldPayTwo.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.shouldPayTwo = shouldPayTwo;
    [bottomView addSubview:shouldPayTwo];
    
    UIView *bottomMarginView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(340), ScreenWidth, PX_TO_PT(20))];
    bottomMarginView.backgroundColor = R_G_B_16(0xf4f4f4);
    [bottomView addSubview:bottomMarginView];
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(340), ScreenWidth, PX_TO_PT(1))];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [bottomView addSubview:bottomLine];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomMarginView.frame), ScreenWidth, PX_TO_PT(88))];
    sectionView.backgroundColor = R_G_B_16(0xf0f0f0);
    [bottomView addSubview:sectionView];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth, PX_TO_PT(88))];
    sectionLabel.text = @"商品清单";
    sectionLabel.textColor = R_G_B_16(0x323232);
    sectionLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [sectionView addSubview:sectionLabel];
    
    UIView *sectionLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    sectionLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [sectionView addSubview:sectionLine];
    
}
-(void)updataWithModel:(XNRRscOrderDetailModel *)model
{
    _model = model;
    [self createView:model];

    self.orderNumber.text = [NSString stringWithFormat:@"订单号：%@",model.id];
    NSDictionary *dict = model.orderStatus;
    self.deliverState.text = dict[@"value"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *dateFormatted = [dateFormatter dateFromString:model.dateCreated];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *locationTimeString=[dateFormatter stringFromDate:dateFormatted];
    self.orderDate.text = [NSString stringWithFormat:@"下单时间：%@",locationTimeString];
    
    NSDictionary *subDict = model.deliveryType;
    self.deliverStyleDetial.text = subDict[@"value"];
    self.nameLabel.text = model.consigneeName;
    self.phoneLabel.text = model.consigneePhone;
    
    if (_model.subOrders.count==2) {
        XNRRscSubOrdersModel *modelOne = _model.subOrders[0];
        self.shouldPayOne.text = [NSString stringWithFormat:@"应支付金额：%@",modelOne.price];
        if ([modelOne.payStatus integerValue] == 1) {
            self.depisitStateOne.text = @"未付款";
        }else {
            self.depisitStateOne.text = @"已付款";
        }
        
        XNRRscSubOrdersModel *modelTwo = _model.subOrders[1];
        self.shouldPayTwo.text = [NSString stringWithFormat:@"应支付金额：%@",modelTwo.price];
        if ([modelTwo.payStatus integerValue] == 1) {
            self.depisitStateTwo.text = @"未付款";
        }else {
            self.depisitStateTwo.text = @"已付款";
        }

    }else{
        XNRRscSubOrdersModel *model = _model.subOrders[0];
        self.shouldPayOne.text = [NSString stringWithFormat:@"应支付金额：%@",model.price];
        self.depisitStateOne.text = @"已付款";
        self.shouldPayTwo.text = [NSString stringWithFormat:@"应支付金额：%@",model.price];
        self.depisitStateTwo.text = @"已付款";

    
    }    
}



@end
