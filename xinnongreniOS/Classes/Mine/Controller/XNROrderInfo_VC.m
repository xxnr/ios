
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
#import "XNRDeliveryTypeModel.h"
#import "XNRRSCModel.h"
#import "XNRRSCDetailModel.h"
#import "XNRCompanyAddressModel.h"
#import "XNRConsigneeModel.h"
#import "MJExtension.h"
#import "XNRPayType_VC.h"
#import "XNRSelPayOrder_VC.h"
#import "XNRSelWebSiteVC.h"
#import "XNRSelContactVC.h"
#import "XNRAddOrderModel.h"
#import "XNRMyAllOrderFrame.h"
#import "XNROrderInfoFrame.h"
#import "XNRDeliveryBtn.h"
#import "AppDelegate.h"
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
    BOOL isfirst;
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
@property (nonatomic,strong)NSMutableArray *webSiteArr;
@property (nonatomic ,strong) NSMutableArray *addressArr;
@property (nonatomic,strong)NSMutableArray *deliveryArr;
@property (nonatomic ,weak) UILabel *goodsTotalLabel;
@property (nonatomic ,weak) UILabel *totoalPriceLabel;
@property (nonatomic,weak)UIView *topView;
@property (nonatomic,weak) UIView *addressView;//地址视图
@property (nonatomic,weak) UIView *NoDeliverView;//没有网点的头视图
@property (nonatomic,weak) UIView *deliverView;//网点自提
@property (nonatomic,weak)UILabel *RSCAddressLabel;//自提网点
@property (nonatomic,weak)UILabel *RSCContactLabel;//自提收货人电话
@property (nonatomic,weak)UILabel *webSiteLabel;
@property (nonatomic,weak) XNRDeliveryBtn *currrentBtn;
@property (nonatomic,strong) NSMutableArray *deliverBtnArr;

@property (nonatomic, strong) XNRAddressManageModel *nextAddresModel;

@property (nonatomic,strong)XNRRSCDetailModel *RSCdetailModel;
@property (nonatomic,strong)XNRConsigneeModel *consigneeModel;
@property (nonatomic,strong)NSString *RSCId;

@property (nonatomic,strong)NSString *RSCDetailAddress;
@property (nonatomic,strong)NSString *RSCContactInfo;
@property (nonatomic,assign)int deliveryType;

@property (nonatomic,strong)NSString *consigneePhone;
@property (nonatomic,strong)NSString *consigneeName;

@property (nonatomic, assign)NSInteger numOrder;

@property (nonatomic, strong)XNRAddOrderModel *addOrderModelSep;

@property (nonatomic, strong)XNRAddOrderModel *addOrderModelFull;
@end

@implementation XNROrderInfo_VC
-(NSMutableArray *)webSiteArr
{
    if (!_webSiteArr) {
        _webSiteArr = [NSMutableArray array];
    }
    return _webSiteArr;
}
-(void)viewWillAppear:(BOOL)animated{
     //获取预处理订单信息
    [super viewWillAppear:YES];
    [_NoDeliverView removeFromSuperview];
    [_headViewNormal removeFromSuperview];
    [_addressView removeFromSuperview];
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
    
    isfirst = YES;

    // 中部视图
    [self createMid];
    // 底部视图
    [self createFoot];
    
//    [self getcontactData];
//    [self getData];

    _deliverBtnArr = [[NSMutableArray alloc] init];
    _deliveryArr = [[NSMutableArray alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initNOAddressView) name:@"initNOAddressView" object:nil];
}

-(void)initNOAddressView
{
    self.nextAddresModel = nil;

    [_headViewNormal removeFromSuperview];
    [_addressView removeFromSuperview];
    [self createHeadView];    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getDeliveries{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *params = @{@"userId":[DataCenter account].userid,@"SKUs":self.dataArray,@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
    
    [manager POST:KGetDeliveries parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_deliveryArr removeAllObjects];

        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"---------返回数据:---------%@",str);
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            NSDictionary *datasDic = resultDic[@"datas"];
            NSArray *items = datasDic[@"items"];
            for (NSDictionary *subDic in items) {
                XNRDeliveryTypeModel *sectionModel = [[XNRDeliveryTypeModel alloc] init];
                sectionModel.deliveryType = subDic[@"deliveryType"];
                sectionModel.deliveryName = subDic[@"deliveryName"];
                [_deliveryArr addObject:sectionModel];
            }
            
            
            
        }
        else if ([resultObj[@"code"] integerValue] == 1401){
            [UILabel showMessage:resultDic[@"message"]];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            XNRLoginViewController *loginVC = [[XNRLoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        else{
            
            [UILabel showMessage:resultObj[@"message"]];
        }
        
        //顶部视图
        if (isfirst) {
            [self createReceiveView];
            isfirst = NO;
        }
        
        [self getRSCWebSiteData];
        
//        [self createDeliveryView:self.RSCDetailAddress andContact:self.RSCContactInfo];
        
  
        if ([_currrentBtn.titleLabel.text isEqualToString:@"网点自提"]) {
            _NoDeliverView.hidden = NO;
        }
//        else if ([_currrentBtn.titleLabel.text isEqualToString:@"配送到户"]) {
//            _addressView.hidden = NO;
//            _headViewNormal.hidden = NO;
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];
    
}

-(void)getRSCWebSiteData
{
    [KSHttpRequest get:KgetRSC parameters:@{@"products":[self GetProId],@"province":@"",@"city":@"",@"county":@"",@"token":[DataCenter account].token} success:^(id result)
     {
         if ([result[@"code"]integerValue] == 1000) {
             _webSiteArr = (NSMutableArray *)[XNRRSCModel objectArrayWithKeyValuesArray:result[@"RSCs"]];
             
             if (self.RSCContactInfo) {
                 [self createDeliveryView:self.RSCDetailAddress andContact:self.RSCContactInfo];
                 // 来自购物车页面的话才加载
                 if (self.isRoot) {// 获得地址信息
                     [self getAddressData];
                     _addressArr = [[NSMutableArray alloc] init];
                 }
                 
             }
             else
             {
                 [self getcontactData];
                 
             }
             
         }
         else if ([result[@"code"] integerValue] == 1401){
             [UILabel showMessage:result[@"message"]];
             UserInfo *infos = [[UserInfo alloc]init];
             infos.loginState = NO;
             [DataCenter saveAccount:infos];
             XNRLoginViewController *loginVC = [[XNRLoginViewController alloc] init];
             loginVC.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:loginVC animated:YES];
         }

         

     } failure:^(NSError *error) {
    }];
}
-(void)getData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSDictionary *params = @{@"SKUs":self.dataArray,@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};

    [manager POST:KGetShoppingCartOffline parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_dataArr removeAllObjects];

        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
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
                            

                            for (int i = 0; i<sectionModel.SKUList.count; i++) {
                                XNRShoppingCartModel *model = sectionModel.SKUList[i];
                                XNROrderInfoFrame *frameModel = [[XNROrderInfoFrame alloc] init];
                                // 传递购物车模型数据
                                frameModel.shoppingCarModel = model;
                                
                                frameModel.shoppingCarModel.num = frameModel.shoppingCarModel.count;
                                [sectionModel.SKUFrameList addObject:frameModel];
                                
                                NSLog(@"++_)_%@",sectionModel.SKUFrameList);
                                
                                
                            }
                            [_dataArr addObject:sectionModel];

                        }
            
                        [self.tableview reloadData];
                    }
        else if ([resultObj[@"code"] integerValue] == 1401){
            [UILabel showMessage:resultDic[@"message"]];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            XNRLoginViewController *loginVC = [[XNRLoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        else{
    
                        [UILabel showMessage:resultObj[@"message"]];
                    }
        
        [self getDeliveries];
        
        

        
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
            if (!self.nextAddresModel) {
                
                
                if (_addressArr.count>0) {
                    [self createAddressView:_addressArr];
    //                [self createHeadView];

                }
                else{
                    [self createHeadView];
                }
            }
            else
            {
                [self createAddressModelView:self.nextAddresModel];
            }
        }
        else {
            [UILabel showMessage:result[@"message"]];
        }
        
        if ([_currrentBtn.titleLabel.text isEqualToString:@"配送到户"]) {
            _addressView.hidden = NO;
            _headViewNormal.hidden = NO;
        }
        if ([_currrentBtn.titleLabel.text isEqualToString:@"网点自提"]) {
                self.headViewSpecial.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(_NoDeliverView.frame));
                
                self.tableview.tableHeaderView = self.headViewSpecial;

            _NoDeliverView.hidden = NO;
        }
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


//选择配送方式
-(void)createReceiveView
{
    [_topView removeFromSuperview];
//    UIView *headViewSpecial = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(350))];
    UIView *headViewSpecial = [[UIView alloc] init];
    headViewSpecial.backgroundColor = [UIColor whiteColor];
    self.headViewSpecial = headViewSpecial;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(183))];
    _topView = topView;
    topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *getGoodsAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(26), ScreenWidth, PX_TO_PT(34))];
    getGoodsAddressLabel.text = @"配送方式";
    getGoodsAddressLabel.textColor = R_G_B_16(0x323232);
    getGoodsAddressLabel.textAlignment = NSTextAlignmentLeft;
    getGoodsAddressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [topView addSubview:getGoodsAddressLabel];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31), CGRectGetMaxY(getGoodsAddressLabel.frame)+PX_TO_PT(26), ScreenWidth - PX_TO_PT(31), PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [topView addSubview:line];
    
    for (int i=0; i<self.deliveryArr.count; i++) {
        XNRDeliveryTypeModel *model = self.deliveryArr[i];
        if ([model.deliveryName isEqualToString:@"网点自提"] && self.deliveryArr.count > 1) {
//            [self.deliveryArr replaceObjectAtIndex:0 withObject:model];
            [self.deliveryArr exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }
    }
    for (int i=0; i<self.deliveryArr.count; i++) {
        XNRDeliveryTypeModel *model = self.deliveryArr[i];
        if ([model.deliveryName isEqualToString:@"网点自提"]) {
            [self.deliveryArr replaceObjectAtIndex:0 withObject:model];
        }
        XNRDeliveryBtn *deliveryBtn = [[XNRDeliveryBtn alloc]initWithFrame:CGRectMake(PX_TO_PT(31)*(i+1)+PX_TO_PT(169)*i, CGRectGetMaxY(line.frame)+PX_TO_PT(28), PX_TO_PT(169), PX_TO_PT(53))];
        [deliveryBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
        [deliveryBtn setTitle:model.deliveryName forState:UIControlStateNormal];
        [deliveryBtn setImage:[UIImage imageNamed:@"check-the"] forState:UIControlStateSelected];
        deliveryBtn.imageView.contentMode = UIViewContentModeBottomRight;
        deliveryBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        deliveryBtn.layer.borderColor = [R_G_B_16(0xB0B0B0) CGColor];
        deliveryBtn.layer.borderWidth = PX_TO_PT(2);
        deliveryBtn.tag = [model.deliveryType integerValue];

        [deliveryBtn addTarget:self action:@selector(deliveryClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_headViewSpecial];
        [topView addSubview:deliveryBtn];
        
        if ([model.deliveryName isEqualToString:@"网点自提"]) {
            [self deliveryClick:deliveryBtn];
            [_deliverBtnArr insertObject:deliveryBtn atIndex:0];
        }
        else
        {
            [_deliverBtnArr addObject:deliveryBtn];
        }
    }
    
    [_headViewSpecial addSubview:topView];
    
}
-(void)deliveryClick:(XNRDeliveryBtn*)sender
{
    if (_currrentBtn == sender) {
        return;
    }
    UIImage *iamge = [UIImage imageNamed:@"check-the"];


    for (UIButton *btn in _deliverBtnArr) {
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        btn.selected = NO;
        btn.layer.borderColor = [R_G_B_16(0xB0B0B0)CGColor];
    }
    sender.titleEdgeInsets = UIEdgeInsetsMake(0, -iamge.size.width, 0, 0);

    
    if ([sender.titleLabel.text isEqualToString:@"网点自提"])
    {
        _deliveryType = 1;
        self.headViewSpecial.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(_NoDeliverView.frame));
//        self.tableview.tableHeaderView = self.headViewSpecial;
        
        _NoDeliverView.hidden = NO;
        _headViewNormal.hidden = YES;
        _addressView.hidden = YES;
    }
    else if([sender.titleLabel.text isEqualToString:@"配送到户"])
    {
        _deliveryType = 2;
        
        if (_addressView) {
            self.headViewSpecial.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(_addressView.frame));
        }
        else
        {
            self.headViewSpecial.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(_headViewNormal.frame));
        }

        _NoDeliverView.hidden = YES;
        _headViewNormal.hidden = NO;
        _addressView.hidden = NO;

    }
    sender.selected = YES;
    sender.layer.borderColor = [R_G_B_16(0xFE9B00)CGColor];
    _currrentBtn = sender;
    self.tableview.tableHeaderView = self.headViewSpecial;

}
//
-(void)createDeliveryView:(NSString *)addressDetail andContact:(NSString *)contact
{
    [self.NoDeliverView removeFromSuperview];
    
    UIButton *btn = self.deliverBtnArr[0];
    UIView *NoDeliveryView=[[UIView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(btn.frame)+PX_TO_PT(27), ScreenWidth, PX_TO_PT(170))];
    NoDeliveryView.backgroundColor=[UIColor clearColor];
    self.NoDeliverView = NoDeliveryView;
    
    UIImageView *upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(7))];
    [upImageView setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
    
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(89), ScreenWidth, PX_TO_PT(7))];
    [downImageView setImage:[UIImage imageNamed:@"orderInfo_down"]];
    
    if (_webSiteArr.count == 0) {
        UIView *webSiteView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(7), ScreenWidth, PX_TO_PT(105))];
        webSiteView.backgroundColor = R_G_B_16(0xFFFCF6);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(25), PX_TO_PT(34), PX_TO_PT(34))];
        imageView.image = [UIImage imageNamed:@"prompt"];
        [webSiteView addSubview:imageView];
        
        UILabel *webSiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+PX_TO_PT(24), PX_TO_PT(20), PX_TO_PT(533), PX_TO_PT(70))];
        self.webSiteLabel = webSiteLabel;
        webSiteLabel.text = @"您选择的商品不能在同一个网点自提，请返回购物车重新选择";
        webSiteLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        webSiteLabel.numberOfLines = 0;
        webSiteLabel.textColor = R_G_B_16(0x323232);
        [webSiteView addSubview:webSiteLabel];
     
        downImageView.frame = CGRectMake(0, PX_TO_PT(113), ScreenWidth, PX_TO_PT(7));
        
        NoDeliveryView.frame = CGRectMake(0, CGRectGetMaxY(btn.frame)+PX_TO_PT(27), ScreenWidth,PX_TO_PT(120));
        
        [NoDeliveryView addSubview:upImageView];
        [NoDeliveryView addSubview:downImageView];
        [NoDeliveryView addSubview:webSiteView];
        
        if ([self.currrentBtn.titleLabel.text isEqualToString:@"网点自提"]) {
//          NoDeliveryView.hidden = YES;
        }
        else
        {
            NoDeliveryView.hidden = YES;
        }
        [self.headViewSpecial addSubview:NoDeliveryView];
        
        self.headViewSpecial.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(NoDeliveryView.frame));
        
        self.tableview.tableHeaderView = self.headViewSpecial;
//        [self.tableview reloadData];

        return;
    }

    UIButton *addressBtn =[MyControl createButtonWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(89)) ImageName:nil Target:self Action:@selector(addressBtnClick:) Title:nil];
    [addressBtn setBackgroundColor:R_G_B_16(0xfffaf0)];
    
    UIButton *contactBtn =[MyControl createButtonWithFrame:CGRectMake(0, CGRectGetMaxY(addressBtn.frame), ScreenWidth, PX_TO_PT(89)) ImageName:nil Target:self Action:@selector(contactBtnClick:) Title:nil];
    [contactBtn setBackgroundColor:R_G_B_16(0xfffaf0)];

    
    UILabel *addressLabel = [MyControl createLabelWithFrame:CGRectMake(PX_TO_PT(83), PX_TO_PT(35), PX_TO_PT(600), PX_TO_PT(30)) Font:PX_TO_PT(28) Text:nil];
    self.RSCAddressLabel = addressLabel;
    if (addressDetail) {
        addressLabel.text = addressDetail;
        addressLabel.textColor = R_G_B_16(0x323232);
    }
    else
    {   addressLabel.textColor = R_G_B_16(0x646464);
        addressLabel.text =@"订单中商品将配送至服务站，请选择自提网点";
    }
    CGSize size = [addressLabel.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(28)] constrainedToSize:CGSizeMake(PX_TO_PT(600), MAXFLOAT)];
    addressLabel.numberOfLines = 0;
    addressLabel.frame = CGRectMake(PX_TO_PT(83), PX_TO_PT(28), size.width, size.height);
    addressBtn.frame = CGRectMake(0, 0, ScreenWidth, size.height+PX_TO_PT(56));
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
//    addressLabel.textColor = R_G_B_16(0x323232);
    [addressBtn addSubview:addressLabel];
    
    // 地址图标
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(23), PX_TO_PT(27), PX_TO_PT(36))];
    [addressImageView setImage:[UIImage imageNamed:@"location"]];
    [addressBtn addSubview:addressImageView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31),addressBtn.height-PX_TO_PT(2), ScreenWidth - PX_TO_PT(31), PX_TO_PT(2))];
    line.backgroundColor = R_G_B_16(0xe7e7e7);
    [addressBtn addSubview:line];
    
    //联系人信息
    UILabel *contactLabel = [MyControl createLabelWithFrame:CGRectMake(PX_TO_PT(83), PX_TO_PT(28), PX_TO_PT(600), PX_TO_PT(30)) Font:PX_TO_PT(28) Text:nil];
    self.RSCContactLabel = contactLabel;
    if (contact) {
        contactLabel.textColor = R_G_B_16(0x323232);
        contactLabel.text = contact;
    }
    else
    {
        contactLabel.textColor = R_G_B_16(0x646464);
        contactLabel.text = @"请填写收货人信息";
    }
    CGSize contactLabelSize = [contactLabel.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(28)] constrainedToSize:CGSizeMake(PX_TO_PT(600), MAXFLOAT)];
    contactLabel.numberOfLines = 0;
    contactLabel.frame = CGRectMake(PX_TO_PT(83), PX_TO_PT(27), contactLabelSize.width, contactLabelSize.height);
    
    contactBtn.frame = CGRectMake(0, CGRectGetMaxY(addressBtn.frame), ScreenWidth, contactLabelSize.height+PX_TO_PT(56));
    contactLabel.textAlignment = NSTextAlignmentLeft;
    contactLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [contactBtn addSubview:contactLabel];
    
    // 联系人图标
    UIImageView *contactImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(23), PX_TO_PT(27), PX_TO_PT(36))];
    [contactImageView setImage:[UIImage imageNamed:@"contact-0"]];
    contactImageView.contentMode = UIViewContentModeScaleAspectFit;
    [contactBtn addSubview:contactImageView];
    
    
    downImageView.frame = CGRectMake(0, contactBtn.height - PX_TO_PT(7), ScreenWidth, PX_TO_PT(7));
    
    
    NoDeliveryView.frame = CGRectMake(0, CGRectGetMaxY(btn.frame)+PX_TO_PT(27), ScreenWidth,addressBtn.height+contactBtn.height);
    
    [addressBtn addSubview:upImageView];
    [NoDeliveryView addSubview:addressBtn];
    [NoDeliveryView addSubview:contactBtn];
    [contactBtn addSubview:downImageView];
//    [self.view addSubview:_headViewSpecial];

    if ([self.currrentBtn.titleLabel.text isEqualToString:@"网点自提"]) {
        //          NoDeliveryView.hidden = YES;
    }
    else
    {
        NoDeliveryView.hidden = YES;
    }
    [self.headViewSpecial addSubview:NoDeliveryView];
    
    
    self.headViewSpecial.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(NoDeliveryView.frame));
    self.tableview.tableHeaderView = self.headViewSpecial;
}

//选择自提网点
-(void)addressBtnClick:(UIButton *)sender
{
    XNRSelWebSiteVC *vc = [[XNRSelWebSiteVC alloc]init];
    
    __weak __typeof(&*self)weakSelf=self;

    [vc setRSCDetailChoseBlock:^(XNRRSCModel *model) {

        weakSelf.RSCdetailModel = [XNRRSCDetailModel objectWithKeyValues:model.RSCInfo]
        ;
        
        weakSelf.headViewNormal.hidden = YES;
        
        XNRCompanyAddressModel *addressModel = [XNRCompanyAddressModel objectWithKeyValues:self.RSCdetailModel.companyAddress];
        NSMutableString *str = [NSMutableString string];
        if (addressModel.province.count > 0) {
            [str appendString:addressModel.province[@"name"]];
        }
        if (addressModel.city.count > 0) {
            [str appendString:@" "];
            [str appendString:addressModel.city[@"name"]];
        }
        if (addressModel.county.count > 0) {
            [str appendString:@" "];
            [str appendString:addressModel.county[@"name"]];
        }
        if (addressModel.town.count > 0) {
            [str appendString:@" "];
            [str appendString:addressModel.town[@"name"]];
        }
        
        [str appendString:@" "];
        [str appendString:addressModel.details];
        weakSelf.RSCDetailAddress = str;
        
        weakSelf.RSCId = model._id;
        
    }];
    vc.hidesBottomBarWhenPushed=YES;
    
//    [self productId];
    vc.proId = [weakSelf GetProId];
    [weakSelf.navigationController pushViewController:vc animated:YES];

}
-(NSString *)GetProId
{
    NSMutableString *proIdArr = [[NSMutableString alloc]init];
    for (int i=0; i<self.dataArray.count; i++) {
        XNRShoppingCartModel *model = [XNRShoppingCartModel objectWithKeyValues:self.dataArray[i]];
        
        [proIdArr appendString:model.product];
        if (i+1 < self.dataArray.count) {
            [proIdArr appendString:@","];
        }
        
    }
    return proIdArr;
}
//收货人信息
-(void)contactBtnClick:(UIButton *)sender
{
    XNRSelContactVC *vc = [[XNRSelContactVC alloc]init];

    __weak __typeof(&*self)weakSelf=self;
    [vc setSetRSCContactChoseBlock:^(XNRConsigneeModel *model)
     {
         NSMutableString *str = [NSMutableString string];
         if (model) {
             weakSelf.RSCContactInfo = [NSString stringWithFormat:@"%@ %@",model.consigneeName,model.consigneePhone];
         }
         else
         {
             weakSelf.RSCContactInfo = nil;
         }
        weakSelf.consigneeName = model.consigneeName;
        weakSelf.consigneePhone = model.consigneePhone;
        weakSelf.consigneeModel = model;
        
    }];
    vc.hidesBottomBarWhenPushed=YES;
    vc.model = self.consigneeModel;
    [weakSelf.navigationController pushViewController:vc animated:YES];
    
}

//获取收货人列表信息
-(void)getcontactData
{
    [KSHttpRequest get:KqueryConsignees parameters:@{@"userId":[DataCenter account].userid} success:^(id result) {
        if ([result[@"code"]integerValue] == 1000) {
            
            NSMutableArray *arr = (NSMutableArray *)[XNRConsigneeModel objectArrayWithKeyValuesArray:result[@"datas"][@"rows"]];

            if (arr.count > 0) {
                self.consigneeModel = arr[0];
                self.consigneeName = self.consigneeModel.consigneeName;
                self.consigneePhone = self.consigneeModel.consigneePhone;
                
                self.RSCContactInfo = [NSString stringWithFormat:@"%@ %@",self.consigneeName,self.consigneePhone];
                

            }
     
            [self createDeliveryView:self.RSCDetailAddress andContact:self.RSCContactInfo];

            // 来自购物车页面的话才加载
            if (self.isRoot) {// 获得地址信息
                [self getAddressData];
                _addressArr = [[NSMutableArray alloc] init];
            }
            

        }
        else if ([result[@"code"] integerValue] == 1401){
            [UILabel showMessage:result[@"message"]];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            XNRLoginViewController *loginVC = [[XNRLoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }

    } failure:^(NSError *error) {
    }];
}


//
#pragma mark - 创建有地址后的视图
-(void)createAddressView:(NSMutableArray *)addressArray{
    [self.addressView removeFromSuperview];
    
    XNRAddressManageModel *model = addressArray[0];
    model.selected = YES;
    self.nextAddresModel = model;

    UIButton *btn = self.deliverBtnArr[0];
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+PX_TO_PT(27), ScreenWidth, PX_TO_PT(173))];
    self.addressView = addressView;
    
    UIButton *addressBtnSpecial = [[UIButton alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(166))];
    [addressBtnSpecial setBackgroundColor:R_G_B_16(0xfffaf0)];
    [addressBtnSpecial addTarget:self action:@selector(addressManage) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:addressBtnSpecial];
    
    UIImageView *upImageViewSpecial = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(7))];
    [upImageViewSpecial setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
    [addressView addSubview:upImageViewSpecial];
    
    UIImageView *downImageViewSpecial = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(166), ScreenWidth, PX_TO_PT(7))];
    [downImageViewSpecial setImage:[UIImage imageNamed:@"orderInfo_down"]];
    [addressView addSubview:downImageViewSpecial];
    
    _recipientNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(90), PX_TO_PT(28), PX_TO_PT(200), PX_TO_PT(36))];
    _recipientNameLabel.textColor = R_G_B_16(0x323232);
    _recipientNameLabel.text = model.receiptPeople;
    [addressView addSubview:_recipientNameLabel];
    
    _recipientPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_recipientNameLabel.frame), PX_TO_PT(28), ScreenWidth/2, PX_TO_PT(36))];
    _recipientPhoneLabel.textColor = R_G_B_16(0x323232);
    _recipientPhoneLabel.text = [NSString stringWithFormat:@"%@",model.receiptPhone];
    [addressView addSubview:_recipientPhoneLabel];

    
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(_recipientNameLabel.frame) + PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(34))];
    [addressImageView setImage:[UIImage imageNamed:@"orderInfo_address_picture"]];
    
    [addressView addSubview:addressImageView];
    
    
    _addressDetail = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(90), CGRectGetMaxY(_recipientNameLabel.frame) +PX_TO_PT(32), ScreenWidth-PX_TO_PT(90)-PX_TO_PT(32)-PX_TO_PT(24), PX_TO_PT(34))];
    _addressDetail.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    _addressDetail.textColor = R_G_B_16(0xc7c7c7);
    [addressView addSubview:_addressDetail];

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
    _addressDetail.numberOfLines = 0;
    
    CGSize size = [_addressDetail.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(32)] constrainedToSize:CGSizeMake( ScreenWidth-PX_TO_PT(90)-PX_TO_PT(32)-PX_TO_PT(24), MAXFLOAT)];
    _addressDetail.frame = CGRectMake(PX_TO_PT(90), CGRectGetMaxY(_recipientNameLabel.frame) +PX_TO_PT(32), ScreenWidth-PX_TO_PT(90)-PX_TO_PT(32)-PX_TO_PT(24), size.height);
    downImageViewSpecial.frame = CGRectMake(0, CGRectGetMaxY(_addressDetail.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(7));
    addressBtnSpecial.frame = CGRectMake(0,0, ScreenWidth, CGRectGetMaxY(downImageViewSpecial.frame)-CGRectGetMaxY(upImageViewSpecial.frame));
    _addressView.frame = CGRectMake(0, CGRectGetMaxY(btn.frame)+PX_TO_PT(27), ScreenWidth, CGRectGetMaxY(downImageViewSpecial.frame));

    // 箭头
    UIImageView *arrowImageView=[[UIImageView  alloc] init];
    arrowImageView.frame=CGRectMake(ScreenWidth-PX_TO_PT(32)-PX_TO_PT(24),PX_TO_PT(83) , PX_TO_PT(24), PX_TO_PT(42));
    [arrowImageView setImage:[UIImage imageNamed:@"icon_arrow"]];
    [addressView addSubview:arrowImageView];
    
    UIView *headLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    headLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [addressView addSubview:headLine];
    _addressView.hidden = YES;
//    [self.view addSubview:_headViewSpecial];

    
    self.headViewSpecial.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(_addressView.frame));
    self.tableview.tableHeaderView = _headViewSpecial;

    [_headViewSpecial addSubview:addressView];
}
#pragma mark-创建没有地址的视图
-(void)createHeadView{
    
    [self.headViewNormal removeFromSuperview];
    
    UIButton *btn = self.deliverBtnArr[0];
    UIView *headViewNormal=[[UIView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(btn.frame)+PX_TO_PT(27), ScreenWidth, PX_TO_PT(96))];
    headViewNormal.backgroundColor=R_G_B_16(0xfffaf0);
    self.headViewNormal = headViewNormal;
    
    UIButton *addressBtn =[MyControl createButtonWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(81)) ImageName:nil Target:self Action:@selector(addressManage) Title:nil];
    [addressBtn setBackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(7))];
    [upImageView setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
    [headViewNormal addSubview:upImageView];
    
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(89), ScreenWidth, PX_TO_PT(7))];
    [downImageView setImage:[UIImage imageNamed:@"orderInfo_down"]];
    [headViewNormal addSubview:downImageView];
    
    UILabel *addressLabel = [MyControl createLabelWithFrame:CGRectMake(ScreenWidth/3+PX_TO_PT(20), 0, ScreenWidth, PX_TO_PT(96)) Font:16 Text:@"添加收货地址"];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
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
    
    [headViewNormal addSubview:addressBtn];

    self.headViewSpecial.frame = CGRectMake(0, 0, ScreenWidth,  CGRectGetMaxY(_headViewNormal.frame));
    self.tableview.tableHeaderView = _headViewSpecial;

    _headViewNormal.hidden = YES;
    [_headViewSpecial addSubview:headViewNormal];

}

-(void)createAddressModelView:(XNRAddressManageModel *)model{
    [self.addressView removeFromSuperview];
    
    model.selected = YES;
    self.nextAddresModel = model;

    UIButton *btn = self.deliverBtnArr[0];
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+PX_TO_PT(27), ScreenWidth, PX_TO_PT(173))];
    self.addressView = addressView;
    
    UIButton *addressBtnSpecial = [[UIButton alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(166))];
    [addressBtnSpecial setBackgroundColor:R_G_B_16(0xfffaf0)];
    [addressBtnSpecial addTarget:self action:@selector(addressManage) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:addressBtnSpecial];
    
    UIImageView *upImageViewSpecial = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(7))];
    [upImageViewSpecial setImage:[UIImage imageNamed:@"orderInfo_address_bacground"]];
    [addressView addSubview:upImageViewSpecial];
    
    UIImageView *downImageViewSpecial = [[UIImageView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(166), ScreenWidth, PX_TO_PT(7))];
    [downImageViewSpecial setImage:[UIImage imageNamed:@"orderInfo_down"]];
    [addressView addSubview:downImageViewSpecial];
    

    _recipientNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(90), PX_TO_PT(28), PX_TO_PT(200), PX_TO_PT(36))];
    _recipientNameLabel.textColor = R_G_B_16(0x323232);
    _recipientNameLabel.text = model.receiptPeople;
    [addressView addSubview:_recipientNameLabel];
    
    _recipientPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_recipientNameLabel.frame), PX_TO_PT(28), ScreenWidth/2, PX_TO_PT(36))];
    _recipientPhoneLabel.textColor = R_G_B_16(0x323232);
    _recipientPhoneLabel.text = [NSString stringWithFormat:@"%@",model.receiptPhone];
    [addressView addSubview:_recipientPhoneLabel];
    
    
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(_recipientNameLabel.frame) + PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(34))];
    [addressImageView setImage:[UIImage imageNamed:@"orderInfo_address_picture"]];
    
    [addressView addSubview:addressImageView];
    
    
    _addressDetail = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(90), CGRectGetMaxY(_recipientNameLabel.frame) +PX_TO_PT(32), ScreenWidth-PX_TO_PT(90)-PX_TO_PT(32)-PX_TO_PT(24), PX_TO_PT(34))];
    _addressDetail.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    _addressDetail.textColor = R_G_B_16(0xc7c7c7);
    [addressView addSubview:_addressDetail];
    
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
    
    _addressDetail.numberOfLines = 0;
    
    CGSize size = [_addressDetail.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(32)] constrainedToSize:CGSizeMake( ScreenWidth-PX_TO_PT(90)-PX_TO_PT(32)-PX_TO_PT(24), MAXFLOAT)];
    _addressDetail.frame = CGRectMake(PX_TO_PT(90), CGRectGetMaxY(_recipientNameLabel.frame) +PX_TO_PT(32), ScreenWidth-PX_TO_PT(90)-PX_TO_PT(32)-PX_TO_PT(24), size.height);
    downImageViewSpecial.frame = CGRectMake(0, CGRectGetMaxY(_addressDetail.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(7));
    addressBtnSpecial.frame = CGRectMake(0,0, ScreenWidth, CGRectGetMaxY(downImageViewSpecial.frame)-CGRectGetMaxY(upImageViewSpecial.frame));
    _addressView.frame = CGRectMake(0, CGRectGetMaxY(btn.frame)+PX_TO_PT(27), ScreenWidth, CGRectGetMaxY(downImageViewSpecial.frame));

    
    // 箭头
    UIImageView *arrowImageView=[[UIImageView  alloc] init];
    arrowImageView.frame=CGRectMake(ScreenWidth-PX_TO_PT(32)-PX_TO_PT(24),PX_TO_PT(83) , PX_TO_PT(24), PX_TO_PT(42));
    [arrowImageView setImage:[UIImage imageNamed:@"icon_arrow"]];
    [addressView addSubview:arrowImageView];
    
    UIView *headLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    headLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [addressView addSubview:headLine];
    _addressView.hidden = YES;
    //    [self.view addSubview:_headViewSpecial];
    
    
    self.headViewSpecial.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(_addressView.frame));
    self.tableview.tableHeaderView = _headViewSpecial;
    
    [_headViewSpecial addSubview:addressView];
    
}

#pragma mark-中部视图
-(void)createMid{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-PX_TO_PT(89) ) style:UITableViewStylePlain];
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
    [totalPriceBtn setTitle:[NSString stringWithFormat:@"提交订单%@",[NSString stringWithFormat:@"(%ld)",_totalSelectNum]] forState:UIControlStateNormal];
    [totalPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    totalPriceBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [totalPriceBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fe9b00"]] forState:UIControlStateNormal];
    [totalPriceBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fec366"]] forState:UIControlStateHighlighted];

    [footView addSubview:totalPriceBtn];
    
    // 总计
    UILabel *totalPricelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(220)-PX_TO_PT(20), PX_TO_PT(89))];
    totalPricelabel.font=[UIFont systemFontOfSize:PX_TO_PT(28)];
    totalPricelabel.textAlignment = NSTextAlignmentRight;
    totalPricelabel.textColor = R_G_B_16(0x323232);
    totalPricelabel.text = [NSString stringWithFormat:@"合计:￥%.2f",self.totalPrice];
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:totalPricelabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                               
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
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(110))];
        topView.backgroundColor = R_G_B_16(0xf9f9f9);
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(88))];
        headView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:headView];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(28), ScreenWidth, PX_TO_PT(32))];
        label.text = sectionModel.brandName;
        label.textColor = R_G_B_16(0x323232);
        label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        label.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:label];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
        lineView1.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, PX_TO_PT(1))];
        lineView2.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView2];
        
        [topView addSubview:headView];
        
        return topView;
        
    } else {
        return nil;
    }
}

//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(89);

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
        XNROrderInfoFrame *frameModel = sectionModel.SKUFrameList[indexPath.row];
        return frameModel.cellHeight;
        
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
        if (sectionModel.SKUFrameList.count>0) {
            XNROrderInfoFrame *frameModel = sectionModel.SKUFrameList[indexPath.row];
            cell.orderFrame = frameModel;
        }
       
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
//        [self createAddressModelView:model];
        

    }];
    vc.hidesBottomBarWhenPushed=YES;
    
    vc.addressModel = self.nextAddresModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 提交订单
-(void)makeSure{
    NSLog(@"确认订单");
    NSDictionary *params = [NSDictionary dictionary];
    if ([_currrentBtn.titleLabel.text isEqualToString:@"网点自提"]) {
        if([self.RSCAddressLabel.text isEqualToString:@"订单中商品将配送至服务站，请选择自提网点"]){
            [UILabel showMessage:@"请选择自提网点"];
            return;
        }
        if([self.RSCContactLabel.text isEqualToString:@"请填写收货人信息"]){
            [UILabel showMessage:@"请填写收货人信息"];
            return;
        }
        if ([self.webSiteLabel.text isEqualToString:@"您选择的商品不能在同一个网点自提，请返回购物车重新选择"]) {
            [UILabel showMessage:@"您选择的商品不能在同一个网点自提，请返回购物车重新选择"];
            return;
        }

        params = @{@"userId":[DataCenter account].userid,@"shopCartId":[DataCenter account].cartId,@"deliveryType":[NSNumber numberWithInt:_deliveryType],@"addressId":self.nextAddresModel.addressId?self.nextAddresModel.addressId:@"",@"RSCId":self.RSCId?self.RSCId:@"",@"consigneePhone":self.consigneePhone,@"consigneeName":self.consigneeName,@"SKUs":self.dataArray,@"token":[DataCenter account].token?[DataCenter account].token:@"",@"payType":@"1",@"user-agent":@"IOS-v2.0"};

    }
    else
    {
        if([self.addressLabel.text isEqualToString:@"添加收货地址"]){
            [UILabel showMessage:@"请填写您的收货地址"];
            return;
        }
        

        params = @{@"userId":[DataCenter account].userid,@"shopCartId":[DataCenter account].cartId,@"addressId":self.nextAddresModel.addressId?self.nextAddresModel.addressId:@"",@"SKUs":self.dataArray,@"payType":@"1",@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:KAddOrder parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            NSArray *orders = resultObj[@"orders"];
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
                
            }else if (orders.count == 2){
                self.numOrder = 2;
                //第一个订单
                self.addOrderModelSep = [[XNRAddOrderModel alloc]init];
                self.addOrderModelSep.orderID = orders[0][@"id"];
                //                    addOrderModelSep.paymentId = orders[0][@"payment"][@"paymentId"];
                NSString *deposit1 = orders[0][@"payment"][@"price"];
                self.addOrderModelSep.money = [NSString stringWithFormat:@"%.2f",deposit1.doubleValue];
                
                //第二个订单
                self.addOrderModelFull = [[XNRAddOrderModel alloc]init];
                self.addOrderModelFull.orderID = orders[1][@"id"];
                //                    addOrderModelFull.paymentId = orders[1][@"payment"][@"paymentId"];
                NSString *deposit2 = orders[1][@"payment"][@"price"];
                self.addOrderModelFull.money = [NSString stringWithFormat:@"%.2f",deposit2.doubleValue];
                
                [self.tableview reloadData];

            
        }else{
            
            [UILabel showMessage:resultObj[@"message"]];
        }
            [self selectVC];

        }else if ([resultObj[@"code"] integerValue] == 1001) {
            [UILabel showMessage:resultObj[@"message"]];
        }
        else if ([resultObj[@"code"] integerValue] == 1401){
                [UILabel showMessage:resultObj[@"message"]];
                UserInfo *infos = [[UserInfo alloc]init];
                infos.loginState = NO;
                [DataCenter saveAccount:infos];
                //发送刷新通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PageRefresh" object:nil];
                
                XNRLoginViewController *vc = [[XNRLoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
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
        vc.payMoney = [NSString stringWithFormat:@"%.2f",deposit.doubleValue];
        vc.recieveName = self.recipientNameLabel.text;
        vc.recievePhone = self.recipientPhoneLabel.text;
        vc.recieveAddress = _addressDetail.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.numOrder == 2)
    {
        // 选择支付订单controller
        XNRSelPayOrder_VC *selVC = [[XNRSelPayOrder_VC alloc]init];
        selVC.addOrderModelSep =self.addOrderModelSep;
        selVC.addOrderModelFull = self.addOrderModelFull;
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
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#009975"]] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)backClick{
    NSNotification *tification = [[NSNotification alloc]initWithName:@"hhh" object:self userInfo:@{@"hh":@"XNROrderInfo_VC"}];
    [[NSNotificationCenter defaultCenter] postNotification:tification];
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
