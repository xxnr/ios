//
//  XNRRscOrderDetialHeadView.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscOrderDetialHeadView.h"
#import "XNRRscOrderDetailModel.h"
@interface XNRRscOrderDetialHeadView()

@property (nonatomic, weak) UIView *tableHeadView;
@property (nonatomic, weak) UIView *headView;
@property (nonatomic, weak) UIView *middleView;

@property (nonatomic, weak) UILabel *orderNumber;
@property (nonatomic, weak) UILabel *deliverState;
@property (nonatomic, weak) UIView *orderDate;


@property (nonatomic, strong) XNRRscOrderDetailModel *model;


@end

@implementation XNRRscOrderDetialHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
    }
    return self;
}

-(void)createView
{
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(798))];
    tableHeadView.backgroundColor = R_G_B_16(0xf4f4f4);
    self.tableHeadView = tableHeadView;
    [self addSubview:tableHeadView];
    
    [self createTableHeadView];


}

-(void)createTableHeadView
{
    
    
    [self createHeadView];
    
    [self createMiddleView];
    
    [self createBottomView];
    
    
}
-(void)createHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(170))];
    headView.backgroundColor = R_G_B_16(0xffffff);
    self.headView = headView;
    [self.tableHeadView addSubview:headView];
    
    UIView *headMarginView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(20))];
    headMarginView.backgroundColor = R_G_B_16(0xf4f4f4);
    [headView addSubview:headMarginView];
    
    UILabel *orderNumber = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(20), ScreenWidth/2, PX_TO_PT(65))];
    orderNumber.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    orderNumber.text = @"订单号：123345667678";
    orderNumber.textColor = R_G_B_16(0x323232);
    self.orderNumber = orderNumber;
    [headView addSubview:orderNumber];
    
    UILabel *deliverState = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(20), ScreenWidth/2-PX_TO_PT(30), PX_TO_PT(65))];
    deliverState.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    deliverState.textAlignment = NSTextAlignmentRight;
    deliverState.textColor = R_G_B_16(0xfe9b00);
    deliverState.text = @"待自提";
    self.deliverState  =deliverState;
    [headView addSubview:deliverState];
    
    
    UILabel *orderDate = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), CGRectGetMaxY(orderNumber.frame), ScreenWidth/2, PX_TO_PT(65))];
    orderDate.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    orderDate.textColor = R_G_B_16(0x323232);
    self.orderDate = orderDate;
    [headView addSubview:orderDate];
    
    UIView *bottomMarginView =[[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(150), ScreenWidth, PX_TO_PT(20))];
    bottomMarginView.backgroundColor = R_G_B_16(0xf4f4f4);
    [headView addSubview:bottomMarginView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(1))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [headView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(150), ScreenWidth, PX_TO_PT(1))];
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(230), PX_TO_PT(27), PX_TO_PT(34), PX_TO_PT(31))];
    imageView.image = [UIImage imageNamed:@"mention-icon-"];
    [middleView addSubview:imageView];
    
    UILabel *deliverStyleDetial = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 0, PX_TO_PT(200), PX_TO_PT(80))];
    deliverStyleDetial.textColor = R_G_B_16(0x646464);
    deliverStyleDetial.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [middleView addSubview:deliverStyleDetial];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(30),PX_TO_PT(80)+PX_TO_PT(28), PX_TO_PT(32), PX_TO_PT(32))];
    imageView1.image = [UIImage imageNamed:@"call-contact"];
    [middleView addSubview:imageView1];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+PX_TO_PT(20), PX_TO_PT(80), PX_TO_PT(200), PX_TO_PT(80))];
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    nameLabel.text = @"经销美";
    [middleView addSubview:nameLabel];
    
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), PX_TO_PT(80), PX_TO_PT(200), PX_TO_PT(80))];
    phoneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    phoneLabel.text = @"13578563456";
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
    stageOne.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [bottomView addSubview:stageOne];
    
    
    UILabel *depisitStateOne = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(80), ScreenWidth/2-PX_TO_PT(30), PX_TO_PT(65))];
    depisitStateOne.text = @"已付款";
    depisitStateOne.textColor = R_G_B_16(0x323232);
    depisitStateOne.textAlignment = NSTextAlignmentRight;
    depisitStateOne.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [bottomView addSubview:depisitStateOne];
    
    UILabel *shouldPayOne = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(145), ScreenWidth, PX_TO_PT(65))];
    shouldPayOne.text = @"应支付金额：909090";
    shouldPayOne.textColor = R_G_B_16(0x323232);
    shouldPayOne.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [bottomView addSubview:shouldPayOne];
    
    
    UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(210),ScreenWidth-PX_TO_PT(60), PX_TO_PT(1))];
    topLine2.backgroundColor = R_G_B_16(0xc7c7c7);
    [bottomView addSubview:topLine2];
    
    
    UILabel *stageTwo = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(210), ScreenWidth, PX_TO_PT(79))];
    stageTwo.text = @"阶段二：订金";
    stageTwo.textColor = R_G_B_16(0x323232);
    stageTwo.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [bottomView addSubview:stageTwo];
    
    
    UILabel *depisitStateTwo = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2,PX_TO_PT(210), ScreenWidth/2-PX_TO_PT(30), PX_TO_PT(65))];
    depisitStateTwo.text = @"已付款";
    depisitStateTwo.textColor = R_G_B_16(0x323232);
    depisitStateTwo.textAlignment = NSTextAlignmentRight;
    depisitStateTwo.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [bottomView addSubview:depisitStateTwo];
    
    UILabel *shouldPayTwo = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30),PX_TO_PT(275), ScreenWidth, PX_TO_PT(65))];
    shouldPayTwo.text = @"应支付金额：909090";
    shouldPayTwo.textColor = R_G_B_16(0x323232);
    shouldPayTwo.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
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
    
    

}



@end
