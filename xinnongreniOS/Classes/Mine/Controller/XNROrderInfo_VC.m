
//  XNROrderInfo_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNROrderInfo_VC.h"
#import "XNRAddressManageViewController.h"
#import "XNROderInfo_Cell.h"
#import "XNRPayTypeViewController.h"
#import "XNRCheckFee_VC.h"
#import "XNRLeaveMessage_VC.h"
#import "XNRMakeSureOrderInfo_VC.h"
#import "XNRCheckOrderModel.h"
#import "XNROrderInfoModel.h"  //订单信息模型
#import "XNRShoppingCartModel.h"


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
//    UILabel*totalPriceDetail;
    UILabel*countPriceDetail;

    int payType;
}
@property (nonatomic ,weak) UILabel *totalPriceDetail;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *recipientNameLabel;   //收货人
@property (nonatomic,strong) UILabel *recipientPhoneLabel;  //收货电话
@property (nonatomic,retain)UIButton*select;
@property (nonatomic,retain)UILabel*addressDetail;//收货地址
@property (nonatomic,weak) UITableView *tableview;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation XNROrderInfo_VC
-(void)viewWillAppear:(BOOL)animated{
     //获取预处理订单信息
    [super viewWillAppear:YES];
    [self getData];
    _dataArray = [[NSMutableArray alloc] init];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    NSLog(@"shoppingCar-->%@",self.shopCarID);
    
    //中部视图
    [self createMid];
    //创建头视图
    [self createHeadView];
    //底部视图
    [self createFoot];
    //底部视图
    [self createBottom];
    // 改变底部视图
    [self changeFoot];
}

-(void)getData {
    [KSHttpRequest post:KGetShopCartList parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datasDic = result[@"datas"];
            NSArray *rowsArr = datasDic[@"rows"];
            for (NSDictionary *subDic in rowsArr) {
                NSArray *goodsListArr = subDic[@"goodsList"];
                for (NSDictionary *subDic2 in goodsListArr) {
                    XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc]init];
                    [model setValuesForKeysWithDictionary:subDic2];
                    [_dataArray addObject:model];
                    [self changeFoot];
                }
            }
            [self.tableview reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:result[@"message"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
        }
        
        } failure:^(NSError *error) {
    }];

    
}
#pragma mark-创建头视图
-(void)createHeadView{
    
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 10+45*SCALE+10+45*SCALE+10+45*SCALE+10)];
    headView.backgroundColor=R_G_B_16(0xf4f4f4);
   
    
     _nameBtn=[MyControl createButtonWithFrame:CGRectMake(0, 10, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    [_nameBtn setTitleColor:[UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1] forState:UIControlStateNormal];
    _nameBtn.backgroundColor=[UIColor whiteColor] ;
    [headView addSubview:_nameBtn];
    
    _nameLabel = [MyControl createLabelWithFrame:CGRectMake(0, 10, ScreenWidth-20, 30*SCALE) Font:15 Text:@"请选择一个地址"];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = XNRFont(16);
    _nameLabel.textColor = TITLECOLOR;
    [_nameBtn addSubview:_nameLabel];
    
    _recipientNameLabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:nil];
    _recipientNameLabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    _recipientNameLabel.font=XNRFont(16);
    _recipientNameLabel.textColor = TITLECOLOR;
    [_nameBtn addSubview: _recipientNameLabel];
    
    _recipientPhoneLabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text: nil];
    
    _recipientPhoneLabel.center = CGPointMake(ScreenWidth-ScreenWidth/4+10, 45*SCALE/2);
    _recipientPhoneLabel.font = XNRFont(16);
    _recipientPhoneLabel.textColor = TITLECOLOR;
    [_nameBtn addSubview: _recipientPhoneLabel];
    
    
    //收货地址
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(0, 10+45*SCALE+10, ScreenWidth-20, 45*SCALE);
    [addressBtn addTarget:self action:@selector(addressManage) forControlEvents:UIControlEventTouchUpInside];
    addressBtn.backgroundColor=[UIColor whiteColor] ;
    [headView addSubview:addressBtn];
    
    
    UILabel *addresslabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:@"收货地址:"];
    addresslabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    addresslabel.font=XNRFont(16);
    addresslabel.textColor = TITLECOLOR;
    [addressBtn addSubview: addresslabel];
    
    _addressDetail=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2+30, 30*SCALE) Font:15 Text:@"请添加收货地址"];
    _addressDetail.textAlignment=NSTextAlignmentCenter;
    _addressDetail.center= CGPointMake(90*SCALE+80*SCALE+20, 45*SCALE/2);
    _addressDetail.font=XNRFont(12);
    _addressDetail.numberOfLines = 0;
    _addressDetail.textColor = TITLECOLOR;
    [addressBtn addSubview: _addressDetail];
    
    UIButton*arrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.frame=CGRectMake(0, 0, 10, 15*SCALE);
    arrowButton.center=CGPointMake(ScreenWidth-30,  45*SCALE/2);
    [arrowButton setImage:[UIImage imageNamed:@"未标题-1_05"] forState:UIControlStateNormal];
    [addressBtn addSubview:arrowButton];
    
    
//    UIButton*addressIcon=[MyControl createButtonWithFrame:CGRectMake(0, 0, 20*SCALE, 25*SCALE) ImageName:@"chakandingdan_icon_address" Target:nil Action:nil Title:nil];
//    
//    addressIcon.center=CGPointMake(10+10*SCALE, 0);
//    
//    [addressBtn addSubview:addressIcon];
    self.tableview.tableHeaderView=headView;
}
#pragma mark-中部视图
-(void)createMid{

    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20,ScreenHeight-64-40*SCALE-20 ) style:UITableViewStylePlain];
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
    UIView*footView=[[UIView alloc]initWithFrame:CGRectMake(0, self.tableview.frame.origin.y+self.tableview.frame.size.height+10, ScreenWidth-20,220*SCALE)];
    footView.backgroundColor=R_G_B_16(0xf4f4f4);
    [self.view addSubview:footView];

    
    //商品总额
    UIButton *totalPriceBtn=[MyControl createButtonWithFrame:CGRectMake(0, 45*SCALE*0+.5, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    
    totalPriceBtn.backgroundColor=[UIColor whiteColor] ;
    [footView addSubview:totalPriceBtn];
    
    //商品总额
    UILabel*totalPricelabel=[MyControl createLabelWithFrame:CGRectMake(10, 0, 100, 45*SCALE) Font:15 Text:@"商品总额:"];
    totalPricelabel.font=XNRFont(16);
    totalPricelabel.textColor = TITLECOLOR;
    [totalPriceBtn addSubview: totalPricelabel];
    // 总价
    UILabel *totalPriceDetail = [[UILabel alloc] initWithFrame:CGRectMake(totalPricelabel.frame.origin.x + totalPricelabel.frame.size.width, 0, totalPriceBtn.frame.size.width-totalPricelabel.frame.size.width-20, 45*SCALE)];
    totalPriceDetail.adjustsFontSizeToFitWidth = YES;
    totalPriceDetail.textAlignment = NSTextAlignmentRight;
    self.totalPriceDetail = totalPriceDetail;
    totalPriceDetail.textColor=R_G_B_16(0xdd1b23);
  
    totalPriceDetail.font=XNRFont(16);
    [totalPriceBtn addSubview: totalPriceDetail];
    self.tableview.tableFooterView=footView;
    

}
-(void)changeFoot{
    float totalPrice = 0.00;
    for (XNRShoppingCartModel *model in _dataArray) {
        if ([model.deposit integerValue] == 0 || model.deposit == nil) {
            totalPrice = totalPrice + model.goodsCount.intValue * model.unitPrice;
        }else{
            totalPrice = totalPrice + model.goodsCount.intValue * model.deposit.floatValue;
        }
    }
    self.totalPriceDetail.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];

}
#pragma mark-计算商品总额
-(CGFloat)computeTotalPrice {
     float totalPrice = 0.00;
    for (XNRShoppingCartModel *model in _dataArray) {
    if ([model.deposit integerValue] == 0 || model.deposit == nil) {
        totalPrice = totalPrice + model.goodsCount.intValue * model.unitPrice;
    }else{
        totalPrice = totalPrice + model.goodsCount.intValue * model.deposit.floatValue;
        }
}
    return totalPrice;

}
-(void)createBottom{
    
    //确认订单按钮
    UIButton *makeSure=[MyControl createButtonWithFrame:CGRectMake(10, ScreenHeight-64-40*SCALE-10, ScreenWidth-20, 40*SCALE) ImageName:nil Target:self Action:@selector(makeSure) Title:@"确认订单"];
    
    makeSure.backgroundColor=R_G_B_16(0x00b38a);
    [makeSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    makeSure.titleLabel.font=XNRFont(16);
    makeSure.clipsToBounds=YES;
    [makeSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    makeSure.layer.cornerRadius=8;
    [self.view addSubview:makeSure];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID=@"XNROderInfo";
    XNROderInfo_Cell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        
        cell=[[XNROderInfo_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    XNRShoppingCartModel *model = _dataArray[indexPath.row];
    [cell setCellDataWithModel:model];
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
#pragma mark- 确认订单
-(void)makeSure{
    NSLog(@"确认订单");
    if([_addressDetail.text isEqualToString:@"添加收货地址"]){
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"请选择一个地址，没有地址我们的服务人员送不到货哦\(^o^)/~" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [al show];
        return;
    }
    
    [KSHttpRequest post:KAddOrder parameters:@{@"userId":[DataCenter account].userid,@"shopCartId":self.shopCarID,@"addressId":addressId?addressId:@"",@"payType":@"1",@"user-agent":@"IOS-v2.0"}success:^(id result) {
        NSLog(@"%@",result);
        //获取预处理订单id 订单号
        orderDataId = result[@"id"];
        // 支付id
        paymentId = result[@"paymentId"];
        
        // 商品总额
        self.totalPriceDetail.text = [NSString stringWithFormat:@"￥%.2f",[self computeTotalPrice]];
        UserInfo *info = [DataCenter account];
        info.orderId = orderDataId;
        [DataCenter saveAccount:info];
        [self.tableview reloadData];
        
        
        // 获取tn
        [KSHttpRequest post:KUnionpay parameters:@{@"consumer":@"app",@"responseStyle":@"v1.0",@"orderId":[DataCenter account].orderId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            
            tn = result[@"tn"];
            [SVProgressHUD dismiss];
            
            XNRPayTypeViewController *vc = [[XNRPayTypeViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.money= [NSString stringWithFormat:@"%f",[self computeTotalPrice]];
            vc.orderID = info.orderId;
            vc.paymentId = paymentId;
            vc.fromType = @"确认订单";
            vc.recieveName = self.recipientNameLabel.text;
            vc.recievePhone = self.recipientPhoneLabel.text;
            vc.recieveAddress = _addressDetail.text;
            vc.tn = tn;
            [self.navigationController pushViewController:vc animated:YES];

            
        } failure:^(NSError *error) {
            NSLog(@"+++++%@",error);
        }];
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络请求错误"];
        NSLog(@"%@",error);
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
