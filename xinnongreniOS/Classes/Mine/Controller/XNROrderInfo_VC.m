
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
#import "XNRPayTypeViewController.h"
#import "XNRCheckFee_VC.h"
#import "XNRLeaveMessage_VC.h"
#import "XNRMakeSureOrderInfo_VC.h"
#import "XNRCheckOrderModel.h"
#import "XNROrderInfoModel.h"  //订单信息模型
#import "XNRShoppingCartModel.h"
#import "XNRShopCarSectionModel.h"
#import "MJExtension.h"
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

    int payType;
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



@end

@implementation XNROrderInfo_VC
-(void)viewWillAppear:(BOOL)animated{
     //获取预处理订单信息
    [super viewWillAppear:YES];
    [self getData];
    _dataArr = [[NSMutableArray alloc] init];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    NSLog(@"shoppingCar-->%@",self.shopCarID);
    
    // 中部视图
    [self createMid];
    // 创建头视图
    [self createHeadView];

    // 底部视图
    [self createFoot];
    // 改变底部视图
//    [self changeFoot];
}

-(void)getData {
    
    NSDictionary *params = @{@"products":[self.dataArray JSONString_Ext],@"IOS-v2.0":@"user-agent"};
    [KSHttpRequest post:KGetShoppingCartOffline parameters:params success:^(id result) {
        
        NSLog(@"---=++--+=%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datasDic = result[@"datas"];

            NSArray *rowsArr = datasDic[@"rows"];
            for (NSDictionary *subDic in rowsArr) {
                    XNRShopCarSectionModel *sectionModel = [[XNRShopCarSectionModel alloc] init];
                    sectionModel.brandName = subDic[@"brandName"];

                    sectionModel.goodsList = (NSMutableArray *)[XNRShoppingCartModel objectArrayWithKeyValuesArray:subDic[@"goodsList"]];
                    [_dataArr addObject:sectionModel];
                
                for (int i = 0; i<sectionModel.goodsList.count; i++) {
                    XNRShoppingCartModel *model = sectionModel.goodsList[i];
                    model.num = model.totalCount;
                }

                    
            }
            [self.tableview reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:result[@"message"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
        }
        
        } failure:^(NSError *error) {
            NSLog(@"-=-=-=-=====%@,,,,,%@ ",error,error.userInfo);
    }];

    
}

#pragma mark-创建头视图
-(void)createHeadView{
    
    UIView *headViewNormal=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(96))];
    headViewNormal.backgroundColor=R_G_B_16(0xf4f4f4);
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
    
    UILabel *addressLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(96)) Font:16 Text:@"添加收货地址"];
    addressLabel.textAlignment = NSTextAlignmentCenter;
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
-(void)createAddressView{
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
    [headViewSpecial addSubview:_recipientNameLabel];
    
    _recipientPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_recipientNameLabel.frame), PX_TO_PT(112), ScreenWidth/2, PX_TO_PT(36))];
    _recipientPhoneLabel.textColor = R_G_B_16(0x323232);
    [headViewSpecial addSubview:_recipientPhoneLabel];

    
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(_recipientNameLabel.frame) + PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(34))];
    [addressImageView setImage:[UIImage imageNamed:@"orderInfo_address_picture"]];
    [headViewSpecial addSubview:addressImageView];
    
    _addressDetail = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(90), CGRectGetMaxY(_recipientNameLabel.frame) +PX_TO_PT(32), ScreenWidth, PX_TO_PT(34))];
    _addressDetail.textColor = R_G_B_16(0xc7c7c7);
    [headViewSpecial addSubview:_addressDetail];
    
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
    UILabel *totalPricelabel=[MyControl createLabelWithFrame:CGRectMake(ScreenWidth/3, 0, ScreenWidth/3*2, PX_TO_PT(89)) Font:16 Text:@"总计:"];
    totalPricelabel.font=XNRFont(16);
    totalPricelabel.textColor = R_G_B_16(0x323232);
    totalPricelabel.text = [NSString stringWithFormat:@"总计:￥%.2f",self.totalPrice];
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:totalPricelabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:18]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
    
    [totalPricelabel setAttributedText:AttributedStringDeposit];

    self.totalPricelabel = totalPricelabel;
    [footView addSubview: totalPricelabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(2))];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [footView addSubview:lineView];

}
//#pragma mark - 改变底部视图
//-(void)changeFoot{
//    float totalPrice = 0.00;
//    for (XNRShopCarSectionModel *sectionModel in _dataArr) {
//        NSLog(@"====***+++=%@",_dataArr);
//        for (XNRShoppingCartModel *model in sectionModel.goodsList) {
//            if (model.deposit && [model.deposit floatValue] > 0) {
//                totalPrice = totalPrice + model.goodsCount.intValue * model.unitPrice.floatValue;
//            }else{
//                totalPrice = totalPrice + model.goodsCount.intValue * model.deposit.floatValue;
//            }
//        }
//
//    }
//        self.totalPricelabel.text = [NSString stringWithFormat:@"合计：￥%.2f",totalPrice];
//
//}
//#pragma mark-计算商品总额
//-(CGFloat)computeTotalPrice {
//    _totalPrice = 0.00;
//    for (XNRShopCarSectionModel *sectionModel in _dataArr) {
//        for (XNRShoppingCartModel *model in sectionModel.goodsList) {
//            if (model.deposit && [model.deposit floatValue] > 0) {
//                _totalPrice = _totalPrice + model.goodsCount.intValue * model.deposit.floatValue;
//
//            }else{
//                _totalPrice = _totalPrice + model.goodsCount.intValue * model.unitPrice.floatValue;
//
//            }
//        }
//
//    }
//        return _totalPrice;
//
//}
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
//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(88);
}

//段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
        return sectionModel.goodsList.count;
    } else {
        return 0;
    }
}

// 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataArr.count>0) {
        XNRShopCarSectionModel *sectionModel = _dataArr[indexPath.section];
        XNRShoppingCartModel *model = sectionModel.goodsList[indexPath.row];
        
        if ([model.deposit floatValue] == 0.00) {
            return PX_TO_PT(380);
        }else{
            return PX_TO_PT(540);
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
        XNRShoppingCartModel *model = sectionModel.goodsList[indexPath.row];
        [cell setCellDataWithModel:model];
    }
    
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark-地址管理
-(void)addressManage{
    
    XNRAddressManageViewController*vc=[[XNRAddressManageViewController alloc]init];
    [vc setAddressChoseBlock:^(XNRAddressManageModel *model) {
        
        NSLog(@"%@",model.address);
        NSLog(@"%@",model.addressId);
        self.headViewNormal.hidden = YES;
        [self createAddressView];
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
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark - 提交订单
-(void)makeSure{
    NSLog(@"确认订单");
    if([self.addressLabel.text isEqualToString:@"添加收货地址"]){
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"请选择一个地址，没有地址我们的服务人员送不到货哦\(^o^)/~" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [al show];
        return;
    }
    
    [KSHttpRequest post:KAddOrder parameters:@{@"userId":[DataCenter account].userid,@"shopCartId":[DataCenter account].cartId,@"addressId":addressId?addressId:@"",@"payType":@"1",@"user-agent":@"IOS-v2.0"}success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            NSArray *orders = result[@"orders"];
            NSDictionary *subDic = orders[0];
                    //获取预处理订单id 订单号
                    orderDataId = subDic[@"id"];
                    NSDictionary *payment = subDic[@"payment"];
                    // 支付id
                    paymentId = payment[@"paymentId"];
        }
        [self.tableview reloadData];
        
            XNRPayTypeViewController *vc = [[XNRPayTypeViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.orderID = orderDataId;
            vc.paymentId = paymentId;
            vc.money = [NSString stringWithFormat:@"%.2f",self.totalPrice];
            vc.recieveName = self.recipientNameLabel.text;
            vc.recievePhone = self.recipientPhoneLabel.text;
            vc.recieveAddress = _addressDetail.text;
            [self.navigationController pushViewController:vc animated:YES];

            
        } failure:^(NSError *error) {
            
        }];
        
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
