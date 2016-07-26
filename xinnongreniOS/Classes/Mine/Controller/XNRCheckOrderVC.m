
//
//  XNRCheckOrderVC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCheckOrderVC.h"

#import "XNRAddressManageViewController.h"
#import "XNROrderInfoCell.h"
#import "XNRSubOrderCell.h"
#import "XNRPayType_VC.h"
#import "XNRShopCarSectionModel.h"
#import "XNRCheckOrderSectionModel.h"
#import "XNRCheckOrderModel.h"
#import "XRNSubOrdersModel.h"
#import "XNRSeePayInfoVC.h"
#import "XNROrderInfoModel.h"
#import "XNROffLine_VC.h"
#import "XNRMyOrder_VC.h"
#import "XNRCarryVC.h"
#import "XNRNavigationController.h"
#import "XNRMakeSureView.h"
#import "XNRMyOrderModel.h"
#import "XNRRSCInfoModel.h"
#import "MJExtension.h"
#import "UILabel+ZSC.h"

@interface XNRCheckOrderVC ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,retain)UITableView *tableview;
@property (nonatomic,weak) UILabel *orderLabel;
@property (nonatomic,strong) UILabel *addressDetail;
@property (nonatomic ,weak) UILabel *payTypeLabel;
@property (nonatomic ,weak) UILabel *nameLabel;
@property (nonatomic ,weak) UILabel *phoneNum;
@property (nonatomic ,weak) UILabel *addressLabel;
@property (nonatomic,strong) NSString *value;
@property (nonatomic,assign)BOOL isHoldBtm;
@property (nonatomic,assign)BOOL ismakeSureBtm;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong)XNRRSCInfoModel *RSCInfoModel;
@property (nonatomic,strong)NSMutableArray *proArr;
@property (nonatomic,strong)XNRCarryVC *carryVC;
@end

@implementation XNRCheckOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeight = 300;
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    _dataArray = [[NSMutableArray alloc]init];
    _proArr = [[NSMutableArray alloc]init];
    //中部视图
    [self createMid];
    
    [XNRSubOrderCell isFirstPay];
    //获取网络数据
    [self getData];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector: @selector(tongzhi:) name:@"payInfoClick" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHeight:) name:@"height" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView) name:@"orderVCRefresh" object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (_becomeCarryVC == YES) {
        [self refreshView];
        _becomeCarryVC = NO;
    }
}
-(void)refreshView
{
    _ismakeSureBtm = NO;
    _isHoldBtm = NO;

    self.tableview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    
    [self getData];
    
}
-(void)getHeight:(NSNotification *)notification
{
    self.cellHeight = [notification.userInfo[@"key"] floatValue];
}
-(void)tongzhi:(NSNotification *)notification
{
    XRNSubOrdersModel *model = notification.userInfo[@"info"];
    XNRSeePayInfoVC *infoVC = [[XNRSeePayInfoVC alloc]init];
    infoVC.model = model;
    [self.navigationController pushViewController:infoVC animated:YES];
    
}
-(void)creatZtBottom
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - PX_TO_PT(88)- 64, ScreenWidth, PX_TO_PT(88))];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *seePayInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(120)-PX_TO_PT(31), PX_TO_PT(10), PX_TO_PT(120), PX_TO_PT(60))];
    seePayInfoBtn.backgroundColor = R_G_B_16(0xFE9B00);
    [seePayInfoBtn setTitle:@"去自提" forState:UIControlStateNormal];
    seePayInfoBtn.titleLabel.textColor = [UIColor whiteColor];
    seePayInfoBtn.layer.cornerRadius = PX_TO_PT(10);
    seePayInfoBtn.layer.masksToBounds = YES;
    seePayInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [seePayInfoBtn addTarget:self action:@selector(holdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:seePayInfoBtn];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 1)];
    line1.backgroundColor = R_G_B_16(0xe0e0e0);
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, 1)];
    line2.backgroundColor = R_G_B_16(0xe0e0e0);
    
    [bottomView addSubview:line1];
    [bottomView addSubview:line2];
    self.bottomView = bottomView;
    [self.view addSubview:_bottomView];
    
}
-(void)creatPSBottom
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - PX_TO_PT(88)- 64, ScreenWidth, PX_TO_PT(88))];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *seePayInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(140)-PX_TO_PT(31), PX_TO_PT(10), PX_TO_PT(140), PX_TO_PT(60))];
    seePayInfoBtn.backgroundColor = R_G_B_16(0xFE9B00);
    [seePayInfoBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    seePayInfoBtn.titleLabel.textColor = [UIColor whiteColor];
    seePayInfoBtn.layer.cornerRadius = PX_TO_PT(10);
    seePayInfoBtn.layer.masksToBounds = YES;
    seePayInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [seePayInfoBtn addTarget:self action:@selector(makeSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:seePayInfoBtn];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 1)];
    line1.backgroundColor = R_G_B_16(0xe0e0e0);
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, 1)];
    line2.backgroundColor = R_G_B_16(0xe0e0e0);
    
    [bottomView addSubview:line1];
    [bottomView addSubview:line2];
    _bottomView = bottomView;
    [self.view addSubview:_bottomView];
    
}

-(void)creatBottomTwo
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - PX_TO_PT(88)- 64, ScreenWidth, PX_TO_PT(88))];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *seePayInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(190)-PX_TO_PT(31), PX_TO_PT(10), PX_TO_PT(190), PX_TO_PT(60))];
    seePayInfoBtn.backgroundColor = R_G_B_16(0xFE9B00);
    [seePayInfoBtn setTitle:@"查看付款信息" forState:UIControlStateNormal];
    seePayInfoBtn.titleLabel.textColor = [UIColor whiteColor];
    seePayInfoBtn.layer.cornerRadius = PX_TO_PT(10);
    seePayInfoBtn.layer.masksToBounds = YES;
    seePayInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [seePayInfoBtn addTarget:self action:@selector(seePayInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:seePayInfoBtn];
    
    
    UIButton *reviseBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(seePayInfoBtn.frame)-PX_TO_PT(31)-PX_TO_PT(190), PX_TO_PT(10), PX_TO_PT(190), PX_TO_PT(60))];
    reviseBtn.backgroundColor = [UIColor whiteColor];
    [reviseBtn setTitle:@"修改付款方式" forState:UIControlStateNormal];
    [reviseBtn setTitleColor:R_G_B_16(0xFE9B00) forState:UIControlStateNormal];
    reviseBtn.layer.cornerRadius = PX_TO_PT(10);
    reviseBtn.layer.borderColor = [R_G_B_16(0xFE9B00) CGColor];
    reviseBtn.layer.borderWidth = PX_TO_PT(2);
    reviseBtn.layer.masksToBounds = YES;
    reviseBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [reviseBtn addTarget:self action:@selector(reviseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:reviseBtn];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 1)];
    line1.backgroundColor = R_G_B_16(0xe0e0e0);
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, 1)];
    line2.backgroundColor = R_G_B_16(0xe0e0e0);
    
    [bottomView addSubview:line1];
    [bottomView addSubview:line2];
    _bottomView = bottomView;
    [self.view addSubview:_bottomView];

}
-(void)creatBottom
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - PX_TO_PT(88)- 64, ScreenWidth, PX_TO_PT(88))];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *sectionFour = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(172), PX_TO_PT(10), PX_TO_PT(132), PX_TO_PT(60))];
    sectionFour.backgroundColor = R_G_B_16(0xfe9b00);
    [sectionFour setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fe9b00"]] forState:UIControlStateNormal];
    [sectionFour setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fec366"]] forState:UIControlStateHighlighted];
    [sectionFour setTitle:@"去付款" forState:UIControlStateNormal];
    sectionFour.layer.cornerRadius = PX_TO_PT(10);
    sectionFour.layer.masksToBounds = YES;
    sectionFour.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [sectionFour addTarget:self action:@selector(sectionFourClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sectionFour];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 1)];
    line1.backgroundColor = R_G_B_16(0xe0e0e0);
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, 1)];
    line2.backgroundColor = R_G_B_16(0xe0e0e0);

    [bottomView addSubview:line1];
    [bottomView addSubview:line2];
    _bottomView = bottomView;
    [self.view addSubview:_bottomView];
    
}

- (void)getData
{
    [_dataArray removeAllObjects];
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            //            NSLog(@"%@",result[@"rows"][@"SKUList"]);
            XNRCheckOrderSectionModel *sectionModel = [[XNRCheckOrderSectionModel alloc] init];
            NSDictionary *datasDic = result[@"datas"];
            sectionModel.address = datasDic[@"rows"][@"address"];
            sectionModel.id = datasDic[@"rows"][@"id"];
            sectionModel.recipientName = datasDic[@"rows"][@"recipientName"];
            sectionModel.recipientPhone = datasDic[@"rows"][@"recipientPhone"];
            sectionModel.payStatus = datasDic[@"rows"][@"payStatus"];
            sectionModel.duePrice = datasDic[@"rows"][@"duePrice"];
            sectionModel.payType = datasDic[@"rows"][@"payType"];
            sectionModel.paySubOrderType = datasDic[@"rows"][@"paySubOrderType"];
            NSDictionary *payment = datasDic[@"rows"][@"payment"];
            sectionModel.price = payment[@"price"];
            sectionModel.deliveryTypeName =datasDic[@"rows"][@"deliveryType"][@"value"];
            sectionModel.deliveryTypenum =datasDic[@"rows"][@"deliveryType"][@"type"];
            
            NSArray *skuList = [NSArray array];
            skuList = datasDic[@"rows"][@"SKUList"];
            for (int i=0; i<skuList.count; i++) {
                NSLog(@"%@",datasDic[@"rows"][@"SKUList"][i][@"deliverStatus"]);
                NSString *status =datasDic[@"rows"][@"SKUList"][i][@"deliverStatus"];
                if ([status integerValue] == 4) {
                    _isHoldBtm = YES;
                }
                if ([status integerValue] == 2) {
                    _ismakeSureBtm = YES;
                }
            }
            NSDictionary *order = datasDic[@"rows"][@"order"];
            sectionModel.totalPrice = order[@"totalPrice"];
            sectionModel.deposit = order[@"deposit"];
            
            
            NSDictionary *orderStatus = order[@"orderStatus"];
            sectionModel.type = orderStatus[@"type"];
            
            sectionModel.RSCInfo =datasDic[@"rows"][@"RSCInfo"];
            if (sectionModel.RSCInfo) {
                self.RSCInfoModel = [XNRRSCInfoModel objectWithKeyValues:sectionModel.RSCInfo];
            }
            sectionModel.value = orderStatus[@"value"];
            self.value = sectionModel.value;
            
            [_bottomView removeFromSuperview];

            if ([self.value isEqualToString: @"待付款"] || [self.value isEqualToString:@"部分付款"]) {
                self.tableview.frame =CGRectMake(0, 0, ScreenWidth,ScreenHeight -PX_TO_PT(88) - 64);
                // 底部视图
                [self creatBottom];
                
            }
            else if([self.value isEqualToString: @"付款待审核"]) {
                self.tableview.frame =CGRectMake(0, 0, ScreenWidth,ScreenHeight -PX_TO_PT(88) - 64);
                    // 底部视图
                    [self creatBottomTwo];
                    
                }
            else if([self.value isEqualToString:@"待自提"] && _isHoldBtm)
            {
                self.tableview.frame =CGRectMake(0, 0, ScreenWidth,ScreenHeight -PX_TO_PT(88) - 64);
                // 底部视图
                [self creatZtBottom];

            }
            else if([self.value isEqualToString:@"配送中"] && _ismakeSureBtm)
            {
                self.tableview.frame =CGRectMake(0, 0, ScreenWidth,ScreenHeight -PX_TO_PT(88) - 64);
                // 底部视图
                [self creatPSBottom];
                
            }

            sectionModel.subOrders = (NSMutableArray *)[XRNSubOrdersModel objectArrayWithKeyValuesArray:datasDic[@"rows"][@"subOrders"]];
            
            sectionModel.SKUList = (NSMutableArray *)[XNRCheckOrderModel objectArrayWithKeyValuesArray:datasDic[@"rows"][@"SKUList"]];
            if (sectionModel.SKUList.count == 0) {
                sectionModel.orderGoodsList = [NSMutableArray array];
    //            sectionModel.orderGoodsList = (NSMutableArray *)[XNRCheckOrderModel objectArrayWithKeyValuesArray:datasDic[@"rows"][@"orderGoodsList"]];
                NSArray *Arr = [NSArray arrayWithArray:datasDic[@"rows"][@"orderGoodsList"]];
                for (int i=0; i<Arr.count; i++) {
                    XNRCheckOrderModel *model = [[XNRCheckOrderModel alloc]init];
                    model.imgs = datasDic[@"rows"][@"orderGoodsList"][i][@"imgs"];
                    model.productName = datasDic[@"rows"][@"orderGoodsList"][i][@"goodsName"];
                    model.count = datasDic[@"rows"][@"orderGoodsList"][i][@"goodsCount"];
                    model.price = datasDic[@"rows"][@"orderGoodsList"][i][@"unitPrice"];
                    model.deposit = datasDic[@"rows"][@"orderGoodsList"][i][@"deposit"];
                    model.deliverStatus = datasDic[@"rows"][@"orderGoodsList"][i][@"deliverStatus"];
                    [sectionModel.orderGoodsList addObject:model];
                }
            }
            [_dataArray addObject:sectionModel];
          
            
            [_tableview reloadData];
            
            [self gettableHeadView];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}
#pragma mark-中部视图
-(void)createMid{
    
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight- 64) style:UITableViewStyleGrouped];
    self.tableview.showsHorizontalScrollIndicator=NO;
    self.tableview.showsVerticalScrollIndicator=NO;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundColor=[UIColor clearColor];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    
}
#pragma mark - 在段头添加任意视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (_dataArray.count > 0) {
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(98))];
            headView.backgroundColor = [UIColor clearColor];
            
            UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(78))];


            infoView.backgroundColor = [UIColor whiteColor];
            
            UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(27), PX_TO_PT(130), PX_TO_PT(28))];
            infoLabel.text = @"支付信息";
            infoLabel.textColor = R_G_B_16(0x323232);
            infoLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            [infoView addSubview:infoLabel];
            
            UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
            line3.backgroundColor = R_G_B_16(0xe0e0e0);
            [infoView addSubview:line3];
            
            [headView addSubview:infoView];
            return headView;
            
        }
    }
    else if (section == 1)
    {
        UIView *section1View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(109))];
        UILabel *listLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(20), ScreenWidth - PX_TO_PT(30), PX_TO_PT(89))];
        listLabel.backgroundColor = R_G_B_16(0xF0F0F0);
        listLabel.text = @"商品清单";
        listLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        listLabel.textColor = R_G_B_16(0x323232);
        
        UIView *toplineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, 1)];
        toplineView.backgroundColor = R_G_B_16(0xe0e0e0);
        UIView *bottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(108), ScreenWidth, 1)];
        bottomlineView.backgroundColor = R_G_B_16(0xe0e0e0);
        
        [section1View addSubview:listLabel];
        [section1View addSubview:toplineView];
        [section1View addSubview:bottomlineView];
        
        return section1View;
    }
    return nil;
}

#pragma mark - 在断尾添加任意视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        if (_dataArray.count>0) {
            UIView *bottomView = [[UIView alloc] init];
            XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
//            if ([sectionModel.type integerValue] ==  1 || [sectionModel.type integerValue] == 2) {
//
                bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88));
                bottomView.backgroundColor = [UIColor whiteColor];
//                [self.view addSubview:bottomView];
                
                UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
                totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
                totalPriceLabel.textAlignment = NSTextAlignmentRight;
                totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sectionModel.totalPrice.doubleValue];
                [bottomView addSubview:totalPriceLabel];
                
                NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
                NSDictionary *priceStr=@{
                                         
                                         NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                         NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(36)]
                                         
                                         };
                
                [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
                
                [totalPriceLabel setAttributedText:AttributedStringPrice];
                
                
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
            line1.backgroundColor = R_G_B_16(0xe0e0e0);
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(86), ScreenWidth, 1)];
            line2.backgroundColor = R_G_B_16(0xe0e0e0);

            [bottomView addSubview:line1];
            [bottomView addSubview:line2];
            
                return bottomView;
                
//            }
        }
    }
    else if (section == 0)
    {

        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        line1.backgroundColor = R_G_B_16(0xe0e0e0);
        return line1;
    }
    
    return nil;
    
}

//修改付款方式
-(void)reviseBtnClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
    XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    vc.orderID = sectionModel.id;
    vc.dueMoney = sectionModel.duePrice;
    vc.fromType = @"orderList";
    vc.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)holdBtnClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    _becomeCarryVC = YES;
    XNRCarryVC *vc=[[XNRCarryVC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    _carryVC = vc;
    
    if (self.model.orderId) {

        _carryVC.orderId = self.model.orderId;
    }
    else
    {
        _carryVC.orderId = self.orderID;
    }
        [self getOrderDetail];
    
}

-(void)getOrderDetail
{
    [self.proArr removeAllObjects];
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            
            XNRCheckOrderSectionModel *orderModel = [XNRCheckOrderSectionModel objectWithKeyValues:result[@"datas"][@"rows"]];
            
            for (int i=0; i<orderModel.SKUList.count; i++) {
                XNRMyOrderModel *model = [[XNRMyOrderModel alloc]init];
                XNRCheckOrderModel *checkModel = [XNRCheckOrderModel objectWithKeyValues:orderModel.SKUList[i]];
                model.orderId = checkModel.goodsId;
                
                model.productName = checkModel.productName;
                model.attributes = checkModel.attributes;
                model.additions = checkModel.additions;
                model.count = checkModel.count;
                model.deliverStatus = [checkModel.deliverStatus integerValue];
                
                if(model.deliverStatus == 4)
                {
                    [_carryVC.modelArr addObject:model];
                }
            }
            
            [self.navigationController pushViewController:_carryVC animated:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];

}
-(void)makeSureBtn:(UIButton *)sender
{
    
    XNRMakeSureView *makesureView = [[XNRMakeSureView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
//    self.model = _dataArray[0];
   
    
    makesureView.orderId = self.model.orderId;
    makesureView.modelArr = [NSMutableArray array];
    makesureView.iscome = @"XNROrderVC";
    
    XNRCheckOrderSectionModel *model = _dataArray[0];
    for (int i=0; i<model.SKUList.count; i++) {
        XNRCheckOrderModel *orderModel = model.SKUList[i];
        if ([orderModel.deliverStatus integerValue] == 2) {
            [makesureView.modelArr addObject:self.model.skus[i]];
        }
    }
    
    [makesureView createview];

    [self.view addSubview:makesureView];

}
//查看付款信息
-(void)seePayInfoBtnClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
    XNROffLine_VC *vc=[[XNROffLine_VC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.orderID = sectionModel.id;
    vc.fromType = @"orderList";
    [self.navigationController pushViewController:vc animated:YES];

}

//去付款
-(void)sectionFourClick:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
    XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.orderID = sectionModel.id;
    vc.payMoney = sectionModel.deposit;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)gettableHeadView
{
    XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(346))];
//    headView.backgroundColor=R_G_B_16(0xf4f4f4);
    self.headView = headView;
    
    UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(128))];
    orderView.backgroundColor=[UIColor whiteColor];
    [self.headView addSubview:orderView];
    // 订单号
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(28), PX_TO_PT(28), ScreenWidth, PX_TO_PT(28))];
    orderLabel.textColor = R_G_B_16(0x323232);
    orderLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    orderLabel.text = [NSString stringWithFormat:@"订单号：%@",sectionModel.id];
    self.orderLabel = orderLabel;
    [orderView addSubview:orderLabel];
    
    // 交易状态
    UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(28), CGRectGetMaxY(orderLabel.frame) + PX_TO_PT(16), ScreenWidth, PX_TO_PT(28))];
    payTypeLabel.textColor = R_G_B_16(0x323232);
    payTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    payTypeLabel.text = [NSString stringWithFormat:@"订单状态：%@",sectionModel.value];
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:payTypeLabel.text];
    NSDictionary *dict=@{
                         
                         NSForegroundColorAttributeName:R_G_B_16(0xFE9B00),
                         
                         
                         };
    
    [AttributedStringDeposit addAttributes:dict range:NSMakeRange(5,AttributedStringDeposit.length-5)];
    
    [payTypeLabel setAttributedText:AttributedStringDeposit];
    self.payTypeLabel = payTypeLabel;
    
    [orderView addSubview:payTypeLabel];
    
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(128)*i, ScreenWidth, 1)];
        lineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [orderView addSubview:lineView];
    }
    
    UIView *deliveryTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(orderView.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(82))];
    deliveryTypeView.backgroundColor = [UIColor whiteColor];
    [self.headView addSubview:deliveryTypeView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(2))];
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [deliveryTypeView addSubview:line];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(140), PX_TO_PT(35))];
    typeLabel.text = @"配送方式";
    typeLabel.textColor = R_G_B_16(0x323232);
    typeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [deliveryTypeView addSubview:typeLabel];
    
    UILabel *deliveryInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(32)-PX_TO_PT(115), PX_TO_PT(28), PX_TO_PT(115), PX_TO_PT(30))];
    deliveryInfoLabel.textAlignment = NSTextAlignmentRight;
    deliveryInfoLabel.text = sectionModel.deliveryTypeName;
    deliveryInfoLabel.textColor = R_G_B_16(0x646464);
    deliveryInfoLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [deliveryTypeView addSubview:deliveryInfoLabel];
    
    UIImageView *typeImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(deliveryInfoLabel.frame)-PX_TO_PT(50), PX_TO_PT(26), PX_TO_PT(35), PX_TO_PT(33))];
    if ([sectionModel.deliveryTypenum integerValue] == 1) {
        typeImage.image = [UIImage imageNamed:@"since"];
    }
    else
    {
        typeImage.image = [UIImage imageNamed:@"delivery"];
    }
    [deliveryTypeView addSubview:typeImage];
    
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(orderView.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(180))];
    
    //配送到户
    if ([sectionModel.deliveryTypenum integerValue] == 2) {
        addressView.backgroundColor = R_G_B_16(0xfffaf0);
        [self.headView addSubview:addressView];
        
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(6))];
        [topImageView setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
        [addressView addSubview:topImageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(64), PX_TO_PT(43), ScreenWidth/3, PX_TO_PT(38))];
        nameLabel.textColor = R_G_B_16(0x323232);
        nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        nameLabel.text = sectionModel.recipientName;
        
        self.nameLabel = nameLabel;
        [addressView addSubview:nameLabel];
        
        UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), PX_TO_PT(43), ScreenWidth/2, PX_TO_PT(32))];
        phoneNum.textColor = R_G_B_16(0x323232);
        phoneNum.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        phoneNum.text = sectionModel.recipientPhone;
        
        self.phoneNum = phoneNum;
        [addressView addSubview:phoneNum];
        
        UIImageView *addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(35))];
        [addressImage setImage:[UIImage imageNamed:@"orderInfo_address_picture"]];
        [addressView addSubview:addressImage];
        
        CGSize size = [sectionModel.address sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(28)] constrainedToSize:CGSizeMake(ScreenWidth-CGRectGetMaxX(addressImage.frame) - PX_TO_PT(52), MAXFLOAT)];
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressImage.frame) + PX_TO_PT(20), CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(32), ScreenWidth-CGRectGetMaxX(addressImage.frame) - PX_TO_PT(52), size.height)];
        addressLabel.textColor = R_G_B_16(0xe0e0e0);
        addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        addressLabel.numberOfLines = 0;
        addressLabel.text = sectionModel.address;
//        addressLabel.adjustsFontSizeToFitWidth = YES;
        //        addressLabel.backgroundColor = [UIColor redColor];
        self.addressLabel = addressLabel;
        [addressView addSubview:addressLabel];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addressLabel.frame)+PX_TO_PT(45), ScreenWidth, PX_TO_PT(7))];
        [bottomImageView setImage:[UIImage imageNamed:@"orderInfo_down"]];
        [addressView addSubview:bottomImageView];
        

        addressView.frame=CGRectMake(0, CGRectGetMaxY(deliveryTypeView.frame), ScreenWidth, CGRectGetMaxY(bottomImageView.frame));
        [self.headView addSubview:addressView];
        
    }
    //网点自提
    else
    {
        addressView.backgroundColor = R_G_B_16(0xfffaf0);
        
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(6))];
        [topImageView setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
        [addressView addSubview:topImageView];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(171), ScreenWidth, PX_TO_PT(7))];
        [bottomImageView setImage:[UIImage imageNamed:@"orderInfo_down"]];
        
        // 地址图标
        UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(23), PX_TO_PT(27), PX_TO_PT(36))];
        [addressImageView setImage:[UIImage imageNamed:@"address"]];
        [addressView addSubview:addressImageView];
        
        UIView *addressLine = [[UIView alloc]init];
        UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addressImageView.frame)+PX_TO_PT(29), PX_TO_PT(24), PX_TO_PT(500), PX_TO_PT(30))];
        companyLabel.textColor = R_G_B_16(0x323232);
        companyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        companyLabel.text = self.RSCInfoModel.companyName;
        [addressView addSubview:companyLabel];
        
        
        CGSize size = [self.RSCInfoModel.RSCAddress sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(24)] constrainedToSize:CGSizeMake(ScreenWidth-PX_TO_PT(119), MAXFLOAT)];
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addressImageView.frame)+PX_TO_PT(29), CGRectGetMaxY(companyLabel.frame)+PX_TO_PT(15),ScreenWidth-PX_TO_PT(119),size.height)];
        addressLabel.numberOfLines = 0;
        addressLabel.text = self.RSCInfoModel.RSCAddress;
        addressLabel.textColor = R_G_B_16(0x646464);
        addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
        [addressView addSubview:addressLabel];
        
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addressImageView.frame)+PX_TO_PT(29), CGRectGetMaxY(addressLabel.frame)+PX_TO_PT(15), ScreenWidth,PX_TO_PT(25))];
        phoneLabel.text = self.RSCInfoModel.RSCPhone;
        phoneLabel.textColor = R_G_B_16(0x646464);
        phoneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
        [addressView addSubview:phoneLabel];
        addressLine.frame = CGRectMake(PX_TO_PT(31), CGRectGetMaxY(phoneLabel.frame)+PX_TO_PT(18), PX_TO_PT(689), PX_TO_PT(2));

        addressLine.backgroundColor = R_G_B_16(0xE2E2E2);
        [addressView addSubview:addressLine];
        
        // 联系人图标
        UIImageView *contactImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(addressLine.frame)+PX_TO_PT(23), PX_TO_PT(32), PX_TO_PT(32))];
        [contactImageView setImage:[UIImage imageNamed:@"call-contact-0"]];
        [addressView addSubview:contactImageView];
        
        UILabel *contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contactImageView.frame)+PX_TO_PT(29),CGRectGetMaxY(addressLine.frame)+ PX_TO_PT(27), PX_TO_PT(500), PX_TO_PT(34))];
        contactLabel.textColor = R_G_B_16(0x323232);
        contactLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        contactLabel.text = [NSString stringWithFormat:@"%@ %@",sectionModel.recipientName,sectionModel.recipientPhone];
        [addressView addSubview:contactLabel];
        
        bottomImageView.frame = CGRectMake(0, CGRectGetMaxY(contactLabel.frame)+PX_TO_PT(26), ScreenWidth, PX_TO_PT(7));
        [addressView addSubview:bottomImageView];
        addressView.frame=CGRectMake(0, CGRectGetMaxY(deliveryTypeView.frame), ScreenWidth, CGRectGetMaxY(bottomImageView.frame));
        [self.headView addSubview:addressView];
        

    }
        headView.frame = CGRectMake(0, PX_TO_PT(20), ScreenWidth, CGRectGetMaxY(addressView.frame));
    
    self.tableview.tableHeaderView = headView;
    
}

#pragma mark - tableView代理方法
//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
//        return self.headView.frame.size.height;
        return PX_TO_PT(98);
    }
    else if (section == 1)
    {
        return  PX_TO_PT(109);
    }
    else
    {
        return 0;
    }
    
}

//段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return PX_TO_PT(84);
    }
    else if(section == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}


//设置段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count>0) {
        return _dataArray.count + 1;
        
    }else{
        return 0;
    }
    
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count > 0) {
        XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
        if (section == 1) {
            if (sectionModel.SKUList.count > 0) {
                return sectionModel.SKUList.count;
            }
            else
            {
                return sectionModel.orderGoodsList.count;
            }
        }
        else if (section == 0)
        {
            return sectionModel.subOrders.count;
        }
        else
        { 
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

// 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (_dataArray.count>0) {
        XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
        if (indexPath.section == 1) {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.height;
            //            if (sectionModel.SKUList.count > 0) {
//                XNRCheckOrderModel *model = sectionModel.SKUList[indexPath.row];
//                if ([model.deposit floatValue] == 0.00) {
//                    if (model.additions.count == 0) {
////                        return self.cellHeight;
//                        return cell.height;
//                    }else{
//                        return cell.height+model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
//                    }
//                }
//                else{
//                    if (model.additions.count == 0) {
//                        return cell.height;// + PX_TO_PT(150);
//                        
//                    }
//                    else{
//                        return cell.height +model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
//                    }
//                }
//
//            }
            
//            else
//            {
//                XNRCheckOrderModel *model = sectionModel.orderGoodsList[indexPath.row];
//                if ([model.deposit floatValue] == 0.00) {
//                    if (model.additions.count == 0) {
//                        return cell.height;
//                    }else{
//                        return cell.height+model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
//                    }
//                }
//                else{
//                    if (model.additions.count == 0) {
//                        return cell.height;// + PX_TO_PT(150);
//                        
//                    }
//                    else{
//                        return cell.height +model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
//                    }
//                }
//
//            }
        }
        else if (indexPath.section == 0)
        {
            XRNSubOrdersModel *subOrderModel = sectionModel.subOrders[indexPath.row];
            if (subOrderModel.payType == 1 || subOrderModel.payType == 2 || subOrderModel.payType == 3|| subOrderModel.payType == 4|| subOrderModel.payType == 5) {
                return PX_TO_PT(240);
            }
            else
            {
                return PX_TO_PT(192);
            }
        }
        
        else
        {
            return 0;
        }
        
    }
    else
    {
        return 0;
    }
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        static NSString *cellID=@"XNROderInfo";
        XNROrderInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            
            cell=[[XNROrderInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        if (_dataArray.count>0) {
            XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
            if (sectionModel.SKUList.count > 0) {
                XNRCheckOrderModel *model = sectionModel.SKUList[indexPath.row];
                [cell setCellDataWithModel:model];
            }
            else
            {
                XNRCheckOrderModel *model = sectionModel.orderGoodsList[indexPath.row];
            
                [cell setCellDataWithModel:model];
            }
            
        }
        cell.backgroundColor=R_G_B_16(0xf4f4f4);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 0)
    {
        static NSString *cellID1 = @"XNRSubOrder";
        XNRSubOrderCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell1) {
            cell1 = [[XNRSubOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
        }
        if (_dataArray.count>0) {
            XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
            XRNSubOrdersModel *model = sectionModel.subOrders[indexPath.row];
            model.orderId = sectionModel.id;
            
            cell1.value = self.value;
            [cell1 setCellDataWithModel:model];
            
        }
        cell1.backgroundColor=R_G_B_16(0xf4f4f4);
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
        
    }
    else
    {
        return nil;
    }
}
- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单详情";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);

    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
}

-(void)backClick{
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"serveHeadRefresh" object:self];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"payHeadRefresh" object:self];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendHeadRefresh" object:self];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"reciveHeadRefresh" object:self];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentHeadRefresh" object:self];
    
    if ([self.presentingViewController isKindOfClass:[XNRNavigationController class]]) {
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }

    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XNRMyOrder_VC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    if (self.isRoot) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else
    {
        XNRMyOrder_VC *orderVC=[[XNRMyOrder_VC alloc]init];
        orderVC.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:orderVC animated:NO];
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
