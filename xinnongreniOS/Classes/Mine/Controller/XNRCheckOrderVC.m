
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
#import "MJExtension.h"

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
@property (nonatomic,assign)CGFloat cellHeight;
@end

@implementation XNRCheckOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeight = 300;
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    _dataArray = [[NSMutableArray alloc]init];
    //中部视图
    [self createMid];
    
    [XNRSubOrderCell isFirstPay];
    //获取网络数据
    [self getData];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector: @selector(tongzhi:) name:@"payInfoClick" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHeight:) name:@"height" object:nil];
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
-(void)creatBottom
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - PX_TO_PT(88)- 64, ScreenWidth, PX_TO_PT(88))];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *sectionFour = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(172), PX_TO_PT(10), PX_TO_PT(132), PX_TO_PT(60))];
    sectionFour.backgroundColor = R_G_B_16(0xfe9b00);
    [sectionFour setTitle:@"去付款" forState:UIControlStateNormal];
    sectionFour.layer.cornerRadius = 5.0;
    sectionFour.layer.masksToBounds = YES;
    sectionFour.titleLabel.font = [UIFont systemFontOfSize:16];
    //    sectionFour.tag = section + 1000;
    [sectionFour addTarget:self action:@selector(sectionFourClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sectionFour];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, PX_TO_PT(1))];
    line1.backgroundColor = R_G_B_16(0xc7c7c7);
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, PX_TO_PT(1))];
    line2.backgroundColor = R_G_B_16(0xc7c7c7);

    [bottomView addSubview:line1];
    [bottomView addSubview:line2];
    [self.view addSubview:bottomView];
    
}

- (void)getData
{
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
            
            NSDictionary *order = datasDic[@"rows"][@"order"];
            sectionModel.totalPrice = order[@"totalPrice"];
            sectionModel.deposit = order[@"deposit"];
            
            
            NSDictionary *orderStatus = order[@"orderStatus"];
            sectionModel.type = orderStatus[@"type"];
            
            sectionModel.value = orderStatus[@"value"];
            self.value = sectionModel.value;
            
            if ([self.value isEqualToString: @"待付款"] || [self.value isEqualToString:@"部分付款"]) {
                self.tableview.frame =CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth,ScreenHeight- CGRectGetMaxY(self.headView.frame) -PX_TO_PT(88) - 64);

                // 底部视图
                [self creatBottom];
                
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
            
        }
        
        [_tableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}
#pragma mark-中部视图
-(void)createMid{
    
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth,ScreenHeight- CGRectGetMaxY(self.headView.frame) - 64) style:UITableViewStyleGrouped];
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
            XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
            
            UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(346))];
            headView.backgroundColor=R_G_B_16(0xf4f4f4);
            self.headView = headView;
            
            UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(128))];
            orderView.backgroundColor=[UIColor whiteColor];
            [self.headView addSubview:orderView];
            // 订单号
            UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(28), PX_TO_PT(28), ScreenWidth, PX_TO_PT(28))];
            orderLabel.textColor = R_G_B_16(0x323232);
//            orderLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            orderLabel.font = [UIFont fontWithName:@"FZHTJW--GB1-0" size:PX_TO_PT(32)];
            orderLabel.text = [NSString stringWithFormat:@"订单号：%@",sectionModel.id];
            self.orderLabel = orderLabel;
            [orderView addSubview:orderLabel];
            
            // 交易状态
            UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(28), CGRectGetMaxY(orderLabel.frame) + PX_TO_PT(16), ScreenWidth, PX_TO_PT(28))];
            payTypeLabel.textColor = R_G_B_16(0x323232);
            payTypeLabel.text = [NSString stringWithFormat:@"订单状态：%@",sectionModel.value];
            NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:payTypeLabel.text];
            NSDictionary *dict=@{
        
                                       NSForegroundColorAttributeName:R_G_B_16(0xFE9B00),
    
        
                                       };
        
            [AttributedStringDeposit addAttributes:dict range:NSMakeRange(5,AttributedStringDeposit.length-5)];
//            payTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            orderLabel.font = [UIFont fontWithName:@"FZHTJW--GB1-0" size:PX_TO_PT(32)];

            [payTypeLabel setAttributedText:AttributedStringDeposit];
            self.payTypeLabel = payTypeLabel;
            
            [orderView addSubview:payTypeLabel];
            
            for (int i = 0; i<2; i++) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(128)*i, ScreenWidth, PX_TO_PT(1))];
                lineView.backgroundColor = R_G_B_16(0xc7c7c7);
                [orderView addSubview:lineView];
            }
            
            UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(orderView.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(180))];
            addressView.backgroundColor = R_G_B_16(0xfffaf0);
            [self.headView addSubview:addressView];
            
            UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(6))];
            [topImageView setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
            [addressView addSubview:topImageView];
            
            UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(171), ScreenWidth, PX_TO_PT(7))];
            [bottomImageView setImage:[UIImage imageNamed:@"orderInfo_down"]];
            [addressView addSubview:bottomImageView];
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.textColor = R_G_B_16(0x323232);
            nameLabel.font = [UIFont systemFontOfSize:16];
            nameLabel.text = sectionModel.recipientName;
            CGSize size = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            nameLabel.frame = CGRectMake(PX_TO_PT(78), PX_TO_PT(43), size.width, size.height);
            self.nameLabel = nameLabel;
            [addressView addSubview:nameLabel];
            
            UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+PX_TO_PT(42), PX_TO_PT(43), ScreenWidth/2, PX_TO_PT(32))];
            phoneNum.textColor = R_G_B_16(0x323232);
            phoneNum.font = [UIFont systemFontOfSize:16];
            phoneNum.text = sectionModel.recipientPhone;
            
            self.phoneNum = phoneNum;
            [addressView addSubview:phoneNum];
            
            UIImageView *addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(93), PX_TO_PT(27), PX_TO_PT(36))];
            [addressImage setImage:[UIImage imageNamed:@"orderInfo_address_picture"]];
            [addressView addSubview:addressImage];
            
            UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressImage.frame) + PX_TO_PT(20), PX_TO_PT(100), ScreenWidth-CGRectGetMaxX(addressImage.frame) - PX_TO_PT(52), PX_TO_PT(32))];
            addressLabel.textColor = R_G_B_16(0x646464);
            addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            addressLabel.text = sectionModel.address;
            addressLabel.adjustsFontSizeToFitWidth = YES;
            //        addressLabel.backgroundColor = [UIColor redColor];
            self.addressLabel = addressLabel;
            [addressView addSubview:addressLabel];
            
            UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(addressView.frame) + PX_TO_PT(20), ScreenWidth, PX_TO_PT(78))];
            infoView.backgroundColor = [UIColor whiteColor];
            [self.headView addSubview:infoView];
            
            UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(27), PX_TO_PT(130), PX_TO_PT(28))];
            infoLabel.text = @"支付信息";
            infoLabel.textColor = R_G_B_16(0x323232);
            infoLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            [infoView addSubview:infoLabel];
            
            UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
            line3.backgroundColor = R_G_B_16(0xc7c7c7);
            [infoView addSubview:line3];
            return headView;
            
        }
    }
    else if (section == 1)
    {
        UIView *section1View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(89))];
        UILabel *listLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth - PX_TO_PT(30), PX_TO_PT(89))];
        listLabel.backgroundColor = R_G_B_16(0xF0F0F0);
        listLabel.text = @"商品清单";
        [section1View addSubview:listLabel];
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
                totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sectionModel.totalPrice.floatValue];
                [bottomView addSubview:totalPriceLabel];
                
                NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
                NSDictionary *priceStr=@{
                                         
                                         NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                         NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(36)]
                                         
                                         };
                
                [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
                
                [totalPriceLabel setAttributedText:AttributedStringPrice];
                
                
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
            line1.backgroundColor = R_G_B_16(0xc7c7c7);
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(86), ScreenWidth, PX_TO_PT(1))];
            line2.backgroundColor = R_G_B_16(0xc7c7c7);

            [bottomView addSubview:line1];
            [bottomView addSubview:line2];
            
//            UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, PX_TO_PT(32))];
//            emptyView.backgroundColor = R_G_B_16(0xf0f0f0);
//            [bottomView addSubview:emptyView];
            
                return bottomView;
                
//            }
        }
    }
    else if (section == 0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(20))];
        view.backgroundColor = [UIColor clearColor];

        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
        line1.backgroundColor = R_G_B_16(0xc7c7c7);
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(19), ScreenWidth, PX_TO_PT(1))];
        line2.backgroundColor = R_G_B_16(0xc7c7c7);
        
        [view addSubview:line1];
        [view addSubview:line2];
        return view;
    }
    
    return nil;
    
}

-(void)sectionFourClick:(UIButton *)sender{
    //    XNRCheckOrderSectionModel *sectionModel = _dataArray[sender.tag - 1000];
    XNRCheckOrderSectionModel *sectionModel = _dataArray[0];
    //    if (sectionModel.deposit && [sectionModel.deposit floatValue]>0) {
    XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.orderID = sectionModel.id;
    vc.payMoney = sectionModel.deposit;
    [self.navigationController pushViewController:vc animated:YES];
    
    //    }else{
    //        XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    //        vc.hidesBottomBarWhenPushed = YES;
    //        vc.orderID = sectionModel.id;
    ////        vc.money = sectionModel.totalPrice;
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
}


#pragma mark - tableView代理方法
//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return PX_TO_PT(450);
    }
    else if (section == 1)
    {
        return  PX_TO_PT(89);
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
        return PX_TO_PT(20);
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
            if (sectionModel.SKUList.count > 0) {
                XNRCheckOrderModel *model = sectionModel.SKUList[indexPath.row];
                if ([model.deposit floatValue] == 0.00) {
                    if (model.additions.count == 0) {
                        return self.cellHeight;
                    }else{
                        return self.cellHeight+model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
                    }
                }
                else{
                    if (model.additions.count == 0) {
                        return self.cellHeight;// + PX_TO_PT(150);
                        
                    }
                    else{
                        return self.cellHeight +model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
                    }
                }

            }
            
            else
            {
                XNRCheckOrderModel *model = sectionModel.orderGoodsList[indexPath.row];
                if ([model.deposit floatValue] == 0.00) {
                    if (model.additions.count == 0) {
                        return self.cellHeight;
                    }else{
                        return self.cellHeight+model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
                    }
                }
                else{
                    if (model.additions.count == 0) {
                        return self.cellHeight;// + PX_TO_PT(150);
                        
                    }
                    else{
                        return self.cellHeight +model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
                    }
                }

            }
        }
        else if (indexPath.section == 0)
        {
            XRNSubOrdersModel *subOrderModel = sectionModel.subOrders[indexPath.row];
            if (subOrderModel.payType) {
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
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单详情";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
}

-(void)backClick{
    
    if (self.isRoot) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
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
