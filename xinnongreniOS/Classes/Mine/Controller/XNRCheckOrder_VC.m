////
////  XNRCheckOrder_VC.m
////  xinnongreniOS
////
////  Created by marks on 15/5/28.
////  Copyright (c) 2015年 qxhiOS. All rights reserved.
////
//
//#import "XNRCheckOrder_VC.h"
//#import "XNRAddressManageViewController.h"
//#import "XNROderInfo_Cell.h"
//#import "XNRPayType_VC.h"
//#import "XNRCheckOrderSectionModel.h"
//#import "XNRCheckOrderModel.h"
//#import "MJExtension.h"
//@interface XNRCheckOrder_VC ()<UITableViewDataSource,UITableViewDelegate>{
//    
//    NSMutableArray *_dataArray;
//}
//@property (nonatomic,strong) UIView *headView;
//@property (nonatomic,retain)UITableView *tableview;
//@property (nonatomic,weak) UILabel *orderLabel;
//@property (nonatomic,strong) UILabel *addressDetail;
//@property (nonatomic ,weak) UILabel *payTypeLabel;
//@property (nonatomic ,weak) UILabel *nameLabel;
//@property (nonatomic ,weak) UILabel *phoneNum;
//@property (nonatomic ,weak) UILabel *addressLabel;
//
//@end
//
//@implementation XNRCheckOrder_VC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
//    [self setNavigationbarTitle];
//    _dataArray = [[NSMutableArray alloc]init];
//     //中部视图
//    [self createMid];
//
//    //获取网络数据
//    [self getData];
//}
//
//- (void)getData
//{
//    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
//        if ([result[@"code"] integerValue] == 1000) {
//            
//            XNRCheckOrderSectionModel *sectionModel = [[XNRCheckOrderSectionModel alloc] init];
//            NSDictionary *datasDic = result[@"datas"];
//            sectionModel.address = datasDic[@"rows"][@"address"];
//            sectionModel.id = datasDic[@"rows"][@"id"];
//            sectionModel.recipientName = datasDic[@"rows"][@"recipientName"];
//            sectionModel.recipientPhone = datasDic[@"rows"][@"recipientPhone"];
//            sectionModel.payStatus = datasDic[@"rows"][@"payStatus"];
//            sectionModel.duePrice = datasDic[@"rows"][@"duePrice"];
//            sectionModel.payType = datasDic[@"rows"][@"payType"];
//            
//            NSDictionary *payment = datasDic[@"rows"][@"payment"];
//            sectionModel.price = payment[@"price"];
//
//            
//            NSDictionary *order = datasDic[@"rows"][@"order"];
//            sectionModel.totalPrice = order[@"totalPrice"];
//            sectionModel.deposit = order[@"deposit"];
//
//            
//            NSDictionary *orderStatus = order[@"orderStatus"];
//            sectionModel.type = orderStatus[@"type"];
//            
//            sectionModel.value = orderStatus[@"value"];
//            sectionModel.orderGoodsList = (NSMutableArray *)[XNRCheckOrderModel objectArrayWithKeyValuesArray:datasDic[@"rows"][@"orderGoodsList"]];
//            [_dataArray addObject:sectionModel];
//
//        }
//        
//    [_tableview reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        
//    }];
//    
//}
//#pragma mark-中部视图
//-(void)createMid{
//    
//    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame)+ PX_TO_PT(24), ScreenWidth,ScreenHeight- CGRectGetMaxY(self.headView.frame)-PX_TO_PT(24)-64) style:UITableViewStyleGrouped];
//    self.tableview.showsHorizontalScrollIndicator=NO;
//    self.tableview.showsVerticalScrollIndicator=NO;
//    self.tableview.delegate=self;
//    self.tableview.dataSource=self;
//    self.tableview.backgroundColor=[UIColor clearColor];
//    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableview];
//}
//#pragma mark - 在段头添加任意视图
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (_dataArray.count > 0) {
//        XNRCheckOrderSectionModel *sectionModel = _dataArray[section];
//        
//        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(346))];
//        headView.backgroundColor=R_G_B_16(0xf4f4f4);
//        self.headView = headView;
//        
//        UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(128))];
//        orderView.backgroundColor=[UIColor whiteColor];
//        [self.headView addSubview:orderView];
//        // 订单号
//        UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(20), PX_TO_PT(20), ScreenWidth, PX_TO_PT(28))];
//        orderLabel.textColor = R_G_B_16(0x323232);
//        orderLabel.font = [UIFont systemFontOfSize:14];
//        orderLabel.text = [NSString stringWithFormat:@"订单号：%@",sectionModel.id];
//        self.orderLabel = orderLabel;
//        [orderView addSubview:orderLabel];
//        
//        // 交易状态
//        UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(20), CGRectGetMaxY(orderLabel.frame) + PX_TO_PT(32), ScreenWidth, PX_TO_PT(28))];
//        payTypeLabel.textColor = R_G_B_16(0x323232);
//        payTypeLabel.font = [UIFont systemFontOfSize:14];
//        payTypeLabel.text = [NSString stringWithFormat:@"交易状态：%@",sectionModel.value];
//        self.payTypeLabel = payTypeLabel;
//        [orderView addSubview:payTypeLabel];
//        
//        for (int i = 0; i<2; i++) {
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(128)*i, ScreenWidth, PX_TO_PT(1))];
//            lineView.backgroundColor = R_G_B_16(0xc7c7c7);
//            [orderView addSubview:lineView];
//        }
//        
//        UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(orderView.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(180))];
//        addressView.backgroundColor = R_G_B_16(0xfffaf0);
//        [self.headView addSubview:addressView];
//        
//        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(6))];
//        [topImageView setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
//        [addressView addSubview:topImageView];
//        
//        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(171), ScreenWidth, PX_TO_PT(7))];
//        [bottomImageView setImage:[UIImage imageNamed:@"orderInfo_down"]];
//        [addressView addSubview:bottomImageView];
//
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(64), PX_TO_PT(32), ScreenWidth/3, PX_TO_PT(32))];
//        nameLabel.textColor = R_G_B_16(0x323232);
//        nameLabel.font = [UIFont systemFontOfSize:16];
//        nameLabel.text = sectionModel.recipientName;
//
//        self.nameLabel = nameLabel;
//        [addressView addSubview:nameLabel];
//        
//        UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), PX_TO_PT(32), ScreenWidth/2, PX_TO_PT(32))];
//        phoneNum.textColor = R_G_B_16(0x323232);
//        phoneNum.font = [UIFont systemFontOfSize:16];
//        phoneNum.text = sectionModel.recipientPhone;
//
//        self.phoneNum = phoneNum;
//        [addressView addSubview:phoneNum];
//        
//        UIImageView *addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(35))];
//        [addressImage setImage:[UIImage imageNamed:@"orderInfo_address_picture"]];
//        [addressView addSubview:addressImage];
//        
//        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressImage.frame) + PX_TO_PT(20), CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(32), ScreenWidth-CGRectGetMaxX(addressImage.frame) - PX_TO_PT(52), PX_TO_PT(32))];
//        addressLabel.textColor = R_G_B_16(0xc7c7c7);
//        addressLabel.font = [UIFont systemFontOfSize:16];
//        addressLabel.text = sectionModel.address;
//        addressLabel.adjustsFontSizeToFitWidth = YES;
////        addressLabel.backgroundColor = [UIColor redColor];
//        self.addressLabel = addressLabel;
//        [addressView addSubview:addressLabel];
//        
//        return headView;
//
//    } else {
//        return nil;
//    }
//    
//}
//
//#pragma mark - 在断尾添加任意视图
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (_dataArray.count>0) {
//        UIView *bottomView = [[UIView alloc] init];
//        XNRCheckOrderSectionModel *sectionModel = _dataArray[section];
//        if ([sectionModel.type integerValue] ==  1 || [sectionModel.type integerValue] == 2) {
//            
//            bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(180));
//            bottomView.backgroundColor = [UIColor whiteColor];
//            [self.view addSubview:bottomView];
//            
//            
//            UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
//            totalPriceLabel.font = [UIFont systemFontOfSize:16];
//            totalPriceLabel.textAlignment = NSTextAlignmentRight;
//            totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sectionModel.price.floatValue];
//            [bottomView addSubview:totalPriceLabel];
//            
//            NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
//            NSDictionary *priceStr=@{
//                                     
//                                     NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
//                                     
//                                     };
//            
//            [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
//            
//            [totalPriceLabel setAttributedText:AttributedStringPrice];
//            
//            UIButton *sectionFour = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(172), PX_TO_PT(90), PX_TO_PT(140), PX_TO_PT(60))];
//            sectionFour.backgroundColor = R_G_B_16(0xfe9b00);
//            [sectionFour setTitle:@"去付款" forState:UIControlStateNormal];
//            sectionFour.layer.cornerRadius = 5.0;
//            sectionFour.layer.masksToBounds = YES;
//            sectionFour.titleLabel.font = [UIFont systemFontOfSize:16];
//            sectionFour.tag = section + 1000;
//            [sectionFour addTarget:self action:@selector(sectionFourClick:) forControlEvents:UIControlEventTouchUpInside];
//            [bottomView addSubview:sectionFour];
//            
//            
//            for (int i = 0; i<3; i++) {
//                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
//                lineView.backgroundColor = R_G_B_16(0xc7c7c7);
//                [bottomView addSubview:lineView];
//            }
//            
//            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(160), ScreenWidth, PX_TO_PT(20))];
//            sectionView.backgroundColor = R_G_B_16(0xf4f4f4);
//            [bottomView addSubview:sectionView];
//            
//            UIView *sectionLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
//            sectionLine.backgroundColor = R_G_B_16(0xc7c7c7);
//            [sectionView addSubview:sectionLine];
//
//            
//            return bottomView;
//            
//        }
//        
//        
//            return bottomView;
//        
//    }else{
//        return nil;
//    }
//    
//}
//
//-(void)sectionFourClick:(UIButton *)sender{
//    XNRCheckOrderSectionModel *sectionModel = _dataArray[sender.tag - 1000];
////    if (sectionModel.deposit && [sectionModel.deposit floatValue]>0) {
//        XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.orderID = sectionModel.id;
//        vc.payMoney = sectionModel.deposit;
//        [self.navigationController pushViewController:vc animated:YES];
//
////    }else{
////        XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
////        vc.hidesBottomBarWhenPushed = YES;
////        vc.orderID = sectionModel.id;
//////        vc.money = sectionModel.totalPrice;
////        [self.navigationController pushViewController:vc animated:YES];
////    }
//}
//
//
//#pragma mark - tableView代理方法
//// 端头高度
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return PX_TO_PT(346);
//    
//}
//
//// 断尾高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (_dataArray.count>0) {
//        return PX_TO_PT(180);
//        
//    }else{
//        return 0;
//    }
//    
//    
//}
//
//// 设置段数
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return _dataArray.count;
//}
//
////设置行数
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (_dataArray.count>0) {
//        XNRCheckOrderSectionModel *sectionModel = _dataArray[section];
//        return sectionModel.orderGoodsList.count;
//    }else{
//        return 0;
//    }
//}
//
////行高
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    XNRCheckOrderSectionModel *sectionModel = _dataArray[indexPath.section];
//    XNRCheckOrderModel *model = sectionModel.orderGoodsList[indexPath.row];
//    if (model.deposit && [model.deposit floatValue] >0 ) {
//        return PX_TO_PT(460);
//    }else{
//        return PX_TO_PT(300);
//    }
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString*cellID = @"XNROderInfo";
//    XNROderInfo_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if(!cell){
//        
//        cell=[[XNROderInfo_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.refreshBlock = ^{
//        [self.tableview reloadData];
//    };
//    if (_dataArray.count>0) {
//        XNRCheckOrderSectionModel *sectionModel = _dataArray[indexPath.section];
//        if (sectionModel.orderGoodsList.count>0) {
//            XNRCheckOrderModel *model = sectionModel.orderGoodsList[indexPath.row];
//            [cell setCellDataWithModel:model];
//
//        }
//    }
//    return cell;
//    
//}
//- (void)setNavigationbarTitle{
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"订单详情";
//    self.navigationItem.titleView = titleLabel;
//
//    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame=CGRectMake(0, 0, 80, 44);
//     backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
//    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
//    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem=leftItem;
//    
//    
//}
//
//-(void)backClick{
//
//    if (self.isRoot) {
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }else
//    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//
//    }
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
