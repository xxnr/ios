
//  XNROrderInfo_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNROrderInfo_VC.h"
#import "XNRAddressManageViewController.h"
#import "XNROderInfo_Cell.h"
#import "XNRSubmitOrderCell.h"
#import "XNRMakeSureOrderInfo_VC.h"
#import "XNRCheckOrderModel.h"
#import "XNROrderInfoModel.h"  //订单信息模型
#import "XNRShoppingCartModel.h"
#import "XNRShopCarSectionModel.h"
#import "MJExtension.h"
#import "XNRPayType_VC.h"
#import "XNRSelPayOrder_VC.h"
#import "XNRAddOrderModel.h"
@interface XNROrderInfo_VC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    
    NSString *orderDataId;    //订单id
    NSString *paymentId;     // 支付id
    NSString *buildingUserId; //地址id
    NSString *deliveryTime;   //期望收货日期
    NSString *address;          // 默认地址
    NSArray  *_goodsArr;     //商品信息数组(运费参考用到)
    NSString *tn;            // 银联tn
    NSString *addressId;
    UIButton *_nameBtn;
    UILabel*countPriceDetail;
    CGFloat _totalPrice;
    NSString *deposit;
    int payType;

    CGFloat _goodsTotalPrice;
}
@property (nonatomic ,weak) UIView *headViewNormal;
@property (nonatomic ,weak) UIView *headViewSpecial;
@property (nonatomic ,weak) UILabel *totalPriceDetail;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *recipientNameLabel;   //收货人
@property (nonatomic,strong) UILabel *recipientPhoneLabel;  //收货电话
@property (nonatomic,retain)UIButton*select;
@property (nonatomic,retain)UILabel *addressDetail;//收货地址
@property (nonatomic,weak) UILabel *addressLabel;
@property (nonatomic,weak) UITableView *tableview;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,weak) UILabel *totalPricelabel;
@property (nonatomic ,strong) NSMutableArray *dataArr;

@property (nonatomic ,strong) NSMutableArray *addressArr;

@property (nonatomic ,weak) UILabel *goodsTotalLabel;
@property (nonatomic ,weak) UILabel *totoalPriceLabel;

@property (nonatomic, strong) XNRAddressManageModel *nextAddresModel;

@property (nonatomic, assign)NSInteger numOrder;

@property (nonatomic, strong)XNRAddOrderModel *addorderModel1;

@property (nonatomic, strong)XNRAddOrderModel *addorderModel2;
@end

@implementation XNROrderInfo_VC
-(void)viewWillAppear:(BOOL)animated{
     //获取预处理订单信息
    [super viewWillAppear:YES];
    // 获得订单信息
    [self getData];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    [self.tableview reloadData];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    NSLog(@"shoppingCar-->%@",self.shopCarID);
    
    // 中部视图
    [self createMid];
    // 底部视图
    [self createFoot];
    
    
    // 来自购物车页面的话才加载
    if (self.isRoot) {// 获得地址信息
        [self getAddressData];
        _addressArr = [[NSMutableArray alloc] init];
        
    }
}

-(void)getData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSDictionary *params = @{@"SKUs":self.dataArray,@"user-agent":@"IOS-v2.0"};
    NSLog(@"---------返回数据:+_-------%@",params);

    [manager POST:KGetShoppingCartOffline parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---------params:+_-------%@",params);
        NSLog(@"---------返回数据:+_-------%@",str);

        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
                        NSDictionary *datasDic = resultDic[@"datas"];
                        NSArray *rowsArr = datasDic[@"rows"];
                        for (NSDictionary *subDic in rowsArr) {
                                XNRShopCarSectionModel *sectionModel = [[XNRShopCarSectionModel alloc] init];
                                sectionModel.brandName = subDic[@"brandName"];
            
                            NSArray *SKUList = subDic[@"SKUList"];
                            for (NSDictionary *dict in SKUList) {
                                sectionModel.goodsCount = dict[@"count"];
                                sectionModel.deposit = dict[@"deposit"];
                                sectionModel.unitPrice = dict[@"price"];
                            }
            
                                sectionModel.SKUList = (NSMutableArray *)[XNRShoppingCartModel objectArrayWithKeyValuesArray:subDic[@"SKUList"]];
                                [_dataArr addObject:sectionModel];
            
                            for (int i = 0; i<sectionModel.SKUList.count; i++) {
                                XNRShoppingCartModel *model = sectionModel.SKUList[i];
            
                                model.num = model.totalCount;
                            }
                        }
                        [self.tableview reloadData];
                    }else{
                        
                        [UILabel showMessage:resultObj[@"message"]];
                    }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];
    
}

-(void)getAddressData
{
    [KSHttpRequest post:KGetUserAddressList parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if([result[@"code"] integerValue] == 1000){
            for(NSDictionary *dic in result[@"datas"][@"rows"]){
                addressId = dic[@"addressId"];
                XNRAddressManageModel *model=[[XNRAddressManageModel alloc]init];
                // 选为默认地址
                if ([dic[@"type"] integerValue] == 1) {
                    model.selected = YES;
                }
                
                [model setValuesForKeysWithDictionary:dic];
                [_addressArr addObject:model];
                
            }
            if (_addressArr.count>0) {
                [self createAddressView:_addressArr];
            }else{
                [self createHeadView];
            }
            
            
        } else {
            [UILabel showMessage:result[@"message"]];
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark-创建头视图
-(void)createHeadView{
    
    UIView *headViewNormal=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(96))];
    headViewNormal.backgroundColor=[UIColor clearColor];
    self.headViewNormal = headViewNormal;
    [self.view addSubview:headViewNormal];
    
     UIButton *addressBtn =[MyControl createButtonWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(96)) ImageName:nil Target:self Action:@selector(addressManage) Title:nil];
    [addressBtn setBackgroundColor:R_G_B_16(0xfffaf0)];
    [headViewNormal addSubview:addressBtn];
    
    
    UIImageView *upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(7))];
    [upImageView setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
    [headViewNormal addSubview:upImageView];
    
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(89), ScreenWidth, PX_TO_PT(7))];
    [downImageView setImage:[UIImage imageNamed:@"orderInfo_down"]];
    [headViewNormal addSubview:downImageView];
    
    UILabel *addressLabel = [MyControl createLabelWithFrame:CGRectMake(ScreenWidth/3+PX_TO_PT(20), 0, ScreenWidth, PX_TO_PT(96)) Font:16 Text:@"添加收货地址"];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = XNRFont(16);
    addressLabel.textColor = R_G_B_16(0x323232);
    self.addressLabel = addressLabel;
    [addressBtn addSubview:addressLabel];

    // 地址图标
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/3-PX_TO_PT(20), PX_TO_PT(34), PX_TO_PT(26), PX_TO_PT(34))];
    [addressImageView setImage:[UIImage imageNamed:@"orderInfo_address_picture"]];
    [addressBtn addSubview:addressImageView];
    
    // 箭头
    UIImageView *arrowImageView=[[UIImageView  alloc] init];
    arrowImageView.frame=CGRectMake(ScreenWidth-PX_TO_PT(32)-PX_TO_PT(24),PX_TO_PT(27) , PX_TO_PT(24), PX_TO_PT(42));
    [arrowImageView setImage:[UIImage imageNamed:@"icon_arrow"]];
    [addressBtn addSubview:arrowImageView];
    self.tableview.tableHeaderView = headViewNormal;

}
#pragma mark - 创建有地址后的视图
-(void)createAddressView:(NSMutableArray *)addressArray{
    XNRAddressManageModel *model = addressArray[0];
    model.selected = YES;
    self.nextAddresModel = model;
    // headViewSpecial
    UIView *headViewSpecial = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(260))];
    headViewSpecial.backgroundColor = [UIColor whiteColor];
    self.headViewSpecial = headViewSpecial;
    [self.view addSubview:headViewSpecial];
    
    UILabel *getGoodsAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth, PX_TO_PT(80))];
    getGoodsAddressLabel.text = @"收货地址";
    getGoodsAddressLabel.textColor = R_G_B_16(0x323232);
    getGoodsAddressLabel.textAlignment = NSTextAlignmentLeft;
    getGoodsAddressLabel.font = [UIFont systemFontOfSize:16];
    [headViewSpecial addSubview:getGoodsAddressLabel];
    
    UIButton *addressBtnSpecial = [[UIButton alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(180))];
    [addressBtnSpecial setBackgroundColor:R_G_B_16(0xfffaf0)];
    [addressBtnSpecial addTarget:self action:@selector(addressManage) forControlEvents:UIControlEventTouchUpInside];
    [headViewSpecial addSubview:addressBtnSpecial];
    
    UIImageView *upImageViewSpecial = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(7))];
    [upImageViewSpecial setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
    [headViewSpecial addSubview:upImageViewSpecial];
    
    UIImageView *downImageViewSpecial = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(253), ScreenWidth, PX_TO_PT(7))];
    [downImageViewSpecial setImage:[UIImage imageNamed:@"orderInfo_down"]];
    [headViewSpecial addSubview:downImageViewSpecial];
    
    
    _recipientNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(90), PX_TO_PT(112), PX_TO_PT(200), PX_TO_PT(36))];
    _recipientNameLabel.textColor = R_G_B_16(0x323232);
    _recipientNameLabel.text = model.receiptPeople;
    [headViewSpecial addSubview:_recipientNameLabel];
    
    _recipientPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_recipientNameLabel.frame), PX_TO_PT(112), ScreenWidth/2, PX_TO_PT(36))];
    _recipientPhoneLabel.textColor = R_G_B_16(0x323232);
    _recipientPhoneLabel.text = [NSString stringWithFormat:@"%@",model.receiptPhone];
    [headViewSpecial addSubview:_recipientPhoneLabel];

    
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(_recipientNameLabel.frame) + PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(34))];
    [addressImageView setImage:[UIImage imageNamed:@"orderInfo_address_picture"]];
    [headViewSpecial addSubview:addressImageView];
    
    
    _addressDetail = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(90), CGRectGetMaxY(_recipientNameLabel.frame) +PX_TO_PT(32), ScreenWidth-PX_TO_PT(90)-PX_TO_PT(32)-PX_TO_PT(24), PX_TO_PT(34))];
    _addressDetail.textColor = R_G_B_16(0xc7c7c7);
    [headViewSpecial addSubview:_addressDetail];

    NSString *address1 = [NSString stringWithFormat:@"%@%@",model.areaName,model.cityName];
    NSString *address2 = [NSString stringWithFormat:@"%@%@%@",model.areaName,model.cityName,model.countyName];
    if ([model.countyName isEqualToString:@""] || model.countyName == nil) {
        if ([model.townName isEqualToString:@""] || model.townName == nil) {
            _addressDetail.text = [NSString stringWithFormat:@"%@%@",address1,model.address];
        }else{
            _addressDetail.text = [NSString stringWithFormat:@"%@%@%@",address1,model.townName,model.address];
            
        }
        
    }else{
        if ([model.townName isEqualToString:@""]|| model.townName == nil) {
            _addressDetail.text = [NSString stringWithFormat:@"%@%@",address2,model.address];
        }else{
            _addressDetail.text = [NSString stringWithFormat:@"%@%@%@",address2,model.townName,model.address];
            
        }
        
    }
    
    // 箭头
    UIImageView *arrowImageView=[[UIImageView  alloc] init];
    arrowImageView.frame=CGRectMake(ScreenWidth-PX_TO_PT(32)-PX_TO_PT(24),PX_TO_PT(149) , PX_TO_PT(24), PX_TO_PT(42));
    [arrowImageView setImage:[UIImage imageNamed:@"icon_arrow"]];
    [headViewSpecial addSubview:arrowImageView];
    self.tableview.tableHeaderView = headViewSpecial;
    
    UIView *headLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    headLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [headViewSpecial addSubview:headLine];

}

#pragma mark-中部视图
-(void)createMid{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth,ScreenHeight-64-PX_TO_PT(89) ) style:UITableViewStyleGrouped];
    tableview.backgroundColor=[UIColor clearColor];
    tableview.showsHorizontalScrollIndicator=NO;
    tableview.showsVerticalScrollIndicator=NO;
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundColor=R_G_B_16(0xf4f4f4);
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview = tableview;
    [self.view addSubview:tableview];
}
#pragma mark-创建底部视图
-(void)createFoot{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-PX_TO_PT(89)-64, ScreenWidth,PX_TO_PT(89))];
    footView.backgroundColor=R_G_B_16(0xf4f4f4);
    [self.view addSubview:footView];
    
    // 提交订单
    UIButton *totalPriceBtn=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(220), 0, PX_TO_PT(220), PX_TO_PT(89)) ImageName:nil Target:self Action:@selector(makeSure) Title:nil];
    [totalPriceBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [totalPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    totalPriceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    totalPriceBtn.backgroundColor = R_G_B_16(0xfe9b00);
    [footView addSubview:totalPriceBtn];
    
    // 总计
    UILabel *totalPricelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(220)-PX_TO_PT(20), PX_TO_PT(89))];
    totalPricelabel.font=XNRFont(14);
    totalPricelabel.textAlignment = NSTextAlignmentRight;
    totalPricelabel.textColor = R_G_B_16(0x323232);
    totalPricelabel.text = [NSString stringWithFormat:@"总计:￥%.2f",self.totalPrice];
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:totalPricelabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:16]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
    
    [totalPricelabel setAttributedText:AttributedStringDeposit];

    self.totalPricelabel = totalPricelabel;
    [footView addSubview: totalPricelabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(2))];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [footView addSubview:lineView];

}
#pragma mark - TableViewDelegate

// 在段头添加任意的视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArr.count > 0) {
        XNRShopCarSectionModel *sectionModel = _dataArr[section];
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
        headView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:headView];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(28), ScreenWidth, PX_TO_PT(32))];
        label.text = sectionModel.brandName;
        label.textColor = R_G_B_16(0x323232);
        label.font = XNRFont(16);
        label.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:label];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
        lineView1.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(88), ScreenWidth, PX_TO_PT(1))];
        lineView2.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView2];
        
        return headView;
        
    } else {
        return nil;
    }
}

// 在断尾添加任意视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(20))];
    footView.backgroundColor =  R_G_B_16(0xf4f4f4);
    [self.view addSubview:footView];
    
    return  footView;

//    if (_dataArr.count>0) {
//        XNRShopCarSectionModel *sectionModel = _dataArr[section];
//        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(100))];
//        footView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:footView];
//        
//        UIView *divideView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(20))];
//        divideView.backgroundColor = R_G_B_16(0xf4f4f4);
//        [footView addSubview:divideView];
//        
//        UILabel *goodsTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
//        goodsTotalLabel.textColor = R_G_B_16(0x323232);
//        goodsTotalLabel.font = [UIFont systemFontOfSize:14];
//        goodsTotalLabel.text = [NSString stringWithFormat:@"共%@件商品",sectionModel.goodsCount];
//        self.goodsTotalLabel = goodsTotalLabel;
//        [footView addSubview:goodsTotalLabel];
//        
//        
//        UILabel *totoalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2 - PX_TO_PT(32), PX_TO_PT(80))];
//        totoalPriceLabel.textAlignment = NSTextAlignmentRight;
//        totoalPriceLabel.font = [UIFont systemFontOfSize:14];
//        if (sectionModel.deposit && [sectionModel.deposit floatValue]>0) {
//            totoalPriceLabel.text = [NSString stringWithFormat:@"合计：%.2f",sectionModel.deposit.floatValue * sectionModel.goodsCount.integerValue];
//        }else{
//            totoalPriceLabel.text = [NSString stringWithFormat:@"合计：%.2f",sectionModel.unitPrice.floatValue * sectionModel.goodsCount.integerValue];
//        }
//                        NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:totoalPriceLabel.text];
//                        NSDictionary *depositStr=@{
//        
//                                                   NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
//                                                   // NSFontAttributeName:[UIFont systemFontOfSize:18]
//        
//                                                   };
//        
//                        [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
//        
//                        [totoalPriceLabel setAttributedText:AttributedStringDeposit];
//        
//        self.totoalPriceLabel = totoalPriceLabel;
//        [footView addSubview:totoalPriceLabel];
//        
//        for (int i = 0; i<2; i++) {
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
//            lineView.backgroundColor = R_G_B_16(0xc7c7c7);
//            [footView addSubview:lineView];
//        }
//        return footView;
//
//    }else{
//        return nil;
//    }
    

}
//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(88);
}

//段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    return PX_TO_PT(100);
    if (section == _dataArr.count-1) {
        return 0.0;
    }
    return 10.0;
}


//设置段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArr.count>0) {
        return _dataArr.count;

    }else{
        return 0;
    }
    
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArr.count > 0) {
        XNRShopCarSectionModel *sectionModel = _dataArr[section];
        return sectionModel.SKUList.count;
    } else {
        return 0;
    }
}

// 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataArr.count>0) {
        XNRShopCarSectionModel *sectionModel = _dataArr[indexPath.section];
        XNRShoppingCartModel *model = sectionModel.SKUList[indexPath.row];
        
        if ([model.deposit floatValue] == 0.00) {
            if (model.additions.count == 0) {
                return PX_TO_PT(300);
            }else{
                return PX_TO_PT(300)+model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
            }
        }else{
            if (model.additions.count == 0) {
                return PX_TO_PT(460);

            }else{
                return PX_TO_PT(460)+model.additions.count*PX_TO_PT(45)+PX_TO_PT(20);
            }
        }
    }else{
        return 0;
    }

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"XNROderInfo";
    XNRSubmitOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        
        cell=[[XNRSubmitOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    if (_dataArr.count>0) {
        XNRShopCarSectionModel *sectionModel = _dataArr[indexPath.section];
        XNRShoppingCartModel *model = sectionModel.SKUList[indexPath.row];
        [cell setCellDataWithModel:model];
    }
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark-地址管理
-(void)addressManage {
    
    XNRAddressManageViewController*vc=[[XNRAddressManageViewController alloc]init];
    
    [vc setAddressChoseBlock:^(XNRAddressManageModel *model) {
        
        self.nextAddresModel = model;
        NSLog(@"%@",model.address);
        NSLog(@"%@",model.addressId);
        self.headViewNormal.hidden = YES;
        NSString *address1 = [NSString stringWithFormat:@"%@%@",model.areaName,model.cityName];
        NSString *address2 = [NSString stringWithFormat:@"%@%@%@",model.areaName,model.cityName,model.countyName];
        if ([model.countyName isEqualToString:@""] || model.countyName == nil) {
            if ([model.townName isEqualToString:@""] || model.townName == nil) {
                _addressDetail.text = [NSString stringWithFormat:@"%@%@",address1,model.address];
            }else{
                _addressDetail.text = [NSString stringWithFormat:@"%@%@%@",address1,model.townName,model.address];

            }
            
        }else{
            if ([model.townName isEqualToString:@""]|| model.townName == nil) {
                _addressDetail.text = [NSString stringWithFormat:@"%@%@",address2,model.address];
            }else{
                _addressDetail.text = [NSString stringWithFormat:@"%@%@%@",address2,model.townName,model.address];

            }
            
        }
        _recipientNameLabel.text = model.receiptPeople;
        _recipientPhoneLabel.text = model.receiptPhone;
        address = model.address;
        _nameLabel.hidden = YES;
        addressId = model.addressId;
    
    }];
    vc.hidesBottomBarWhenPushed=YES;
    
    vc.addressModel = self.nextAddresModel;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 提交订单
-(void)makeSure{
    NSLog(@"确认订单");
    if([self.addressLabel.text isEqualToString:@"添加收货地址"]){
        [UILabel showMessage:@"请选择一个地址，没有地址我们的服务人员送不到货哦"];
        return;
    }

    [KSHttpRequest post:KAddOrder parameters:@{@"userId":[DataCenter account].userid,@"shopCartId":[DataCenter account].cartId,@"addressId":self.nextAddresModel.addressId?self.nextAddresModel.addressId:@"",@"products":[self.dataArray JSONString_Ext],@"payType":@"1",@"user-agent":@"IOS-v2.0"}success:^(id result) {

        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            NSArray *orders = result[@"orders"];
            NSLog(@"%tu",orders.count);
            NSLog(@"%d",(int)self.numOrder);
                if (orders.count == 1) {
                    self.numOrder = 1;
                    NSDictionary *subDic = orders[0];
                    //获取预处理订单id 订单号
                    orderDataId = subDic[@"id"];
                    deposit = subDic[@"deposit"];
                    NSDictionary *payment = subDic[@"payment"];
                    // 支付id
                    paymentId = payment[@"paymentId"];
                    
                    [self.tableview reloadData];
                    
                }
                else if (orders.count == 2)
                {
                    self.numOrder = 2;
                    //第一个订单
                    self.addorderModel1 = [[XNRAddOrderModel alloc]init];
                    self.addorderModel1.orderID = orders[0][@"id"];
//                    addorderModel1.paymentId = orders[0][@"payment"][@"paymentId"];
                    NSString *deposit1 = orders[0][@"payment"][@"price"];
                    self.addorderModel1.money = [NSString stringWithFormat:@"%.2f",deposit1.floatValue];
                    
                    //第二个订单
                    self.addorderModel2 = [[XNRAddOrderModel alloc]init];
                    self.addorderModel2.orderID = orders[1][@"id"];
//                    addorderModel2.paymentId = orders[1][@"payment"][@"paymentId"];
                    NSString *deposit2 = orders[1][@"payment"][@"price"];
                    self.addorderModel2.money = [NSString stringWithFormat:@"%.2f",deposit2.floatValue];

                    [self.tableview reloadData];

                }else{
                    [UILabel showMessage:result[@"message"]];
                }
                [self selectVC];
            
        }
    } failure:^(NSError *error) {
            
        }];
    [self selectVC];

}

-(void)selectVC
{
    if (self.numOrder == 1) {
        XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderID = orderDataId;
        vc.paymentId = paymentId;
        vc.payMoney = [NSString stringWithFormat:@"%.2f",deposit.floatValue];
        vc.recieveName = self.recipientNameLabel.text;
        vc.recievePhone = self.recipientPhoneLabel.text;
        vc.recieveAddress = _addressDetail.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.numOrder == 2)
    {
        // 选择支付订单controller
        XNRSelPayOrder_VC *selVC = [[XNRSelPayOrder_VC alloc]init];
        selVC.addOrderModel1 =self.addorderModel1;
        selVC.addOrderModel2 = self.addorderModel2;
        
        [self.navigationController pushViewController:selVC animated:YES];
        
    }

}
-(void)select:(UIButton*)button{
    button.selected=!button.selected;
    if(button.selected==NO){
        
        [self.select setImage:[UIImage imageNamed:@"list_btn_unchecked_gray"] forState:UIControlStateNormal];
    }else{
         [self.select setImage:[UIImage imageNamed:@"list_btn_checked_green"] forState:UIControlStateNormal];
        
    }
}
- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"提交订单";
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
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
