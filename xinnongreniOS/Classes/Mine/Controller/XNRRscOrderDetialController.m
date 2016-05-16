//
//  XNRRscOrderDetialController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscOrderDetialController.h"
#import "XNRRscOrderDetailModel.h"
#import "XNRRscOrderDetialFrameModel.h"
#import "XNRRscOrderModel.h"
#import "XNRRscOrderDetialCell.h"
#import "XNRRscOrderDetialHeadView.h"
#import "XNRRscDetialFootFrameModel.h"
#import "XNRRscConfirmDeliverView.h"
#import "XNRRscIdentifyPayView.h"

@interface XNRRscOrderDetialController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataFrameArray;

@property (nonatomic, weak) XNRRscOrderDetialHeadView *headView;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) XNRRscIdentifyPayView *identifyPayView;

@property (nonatomic, weak) XNRRscConfirmDeliverView *deliverView;

@property (nonatomic, weak) UIButton *footButton;

@property (nonatomic, weak) UIView *footView;

@end

@implementation XNRRscOrderDetialController

-(XNRRscIdentifyPayView *)identifyPayView
{
    if (!_identifyPayView) {
        XNRRscIdentifyPayView *identifyPayView = [[XNRRscIdentifyPayView alloc] init];
        self.identifyPayView = identifyPayView;
        [self.view addSubview:identifyPayView];
    }
    return _identifyPayView;
}

-(XNRRscConfirmDeliverView *)deliverView
{
    if (!_deliverView) {
        XNRRscConfirmDeliverView *deliverView = [[XNRRscConfirmDeliverView alloc] init];
        self.deliverView = deliverView;
        [self.view addSubview:deliverView];
    }
    return _deliverView;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
//    _dataFrameArray = [NSMutableArray array];
    [self setNavigationBar];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self createView];
    [self getOrderDetialData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDetialTableView) name:@"refreshTableView" object:nil];
}

-(void)refreshDetialTableView
{
    [_dataArray removeAllObjects];
    [self getOrderDetialData];
    [self.footView removeFromSuperview];
//    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createView
{
    XNRRscOrderDetialHeadView *headView =  [[XNRRscOrderDetialHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(778))];
    self.headView = headView;
    [self.view addSubview:headView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = R_G_B_16(0xf4f4f4);
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

-(void)getOrderDetialData
{
    [KSHttpRequest get:KRscOrderDetail parameters:@{@"orderId":_orderModel._id?_orderModel._id:_orderId} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"order"];
            XNRRscOrderDetailModel *model = [[XNRRscOrderDetailModel alloc] init];
            model.SKUList = (NSMutableArray *)[XNRRscSkusModel objectArrayWithKeyValuesArray:dict[@"SKUList"]];
            model.consigneeName = dict[@"consigneeName"];
            model.consigneePhone = dict[@"consigneePhone"];
            model.consigneeAddress = dict[@"consigneeAddress"];
            model.dateCreated = dict[@"dateCreated"];
            model.deposit = dict[@"deposit"];
            model.id = dict[@"id"];
            model.deliveryType = dict[@"deliveryType"];
            model.orderStatus = dict[@"orderStatus"];
            model.totalPrice = dict[@"totalPrice"];
            model.subOrders = (NSMutableArray *)[XNRRscSubOrdersModel objectArrayWithKeyValuesArray:dict[@"subOrders"]];
            
            for (XNRRscSkusModel *skuModel in model.SKUList ) {
                XNRRscOrderDetialFrameModel *frameModel = [[XNRRscOrderDetialFrameModel alloc] init];
                frameModel.model = skuModel;
                [model.SKUFrameList addObject:frameModel];
            }

            [_dataArray addObject:model];
            
            [self.headView updataWithModel:model];
            
            if ([dict[@"deliveryType"][@"type"] integerValue] == 2) {
                if (model.subOrders.count == 2) {
                    self.headView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(878));
                }else{
                    self.headView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(748));
                }
            }else{
                if (model.subOrders.count == 2) {
                    self.headView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(778));
                }else{
                    self.headView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(648));
                }
            }
            self.tableView.tableHeaderView = self.headView;

            
            if ([dict[@"orderStatus"][@"type"] integerValue] == 2 ||[dict[@"orderStatus"][@"type"] integerValue] == 4) {
                [self createFootView:model];
                self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(80));

            }else if ([dict[@"orderStatus"][@"type"] integerValue] == 5 || [dict[@"orderStatus"][@"type"] integerValue] == 6){
                self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
                for (XNRRscSkusModel *skuModel in model.SKUList ) {
                    if ([skuModel.deliverStatus integerValue] == 4) {
                        [self createFootView:model];
                        self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(80));
                    }
                }
            }else{
                self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
            }
        }
    
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)createFootView:(XNRRscOrderDetailModel *)model
{
    NSDictionary *dict = model.orderStatus;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight -64- PX_TO_PT(80), ScreenWidth,PX_TO_PT(80))];
    footView.backgroundColor = [UIColor whiteColor];
    self.footView = footView;
    [self.view addSubview:footView];
    
    UIButton *footButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(170), PX_TO_PT(10), PX_TO_PT(140), PX_TO_PT(60))];
    footButton.layer.cornerRadius = 5.0;
    footButton.layer.masksToBounds = YES;
    footButton.backgroundColor = R_G_B_16(0xfe9b00);
    footButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [footButton addTarget:self action:@selector(footButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.footButton = footButton;
    [footView addSubview:footButton];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(2))];
    topLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [footView addSubview:topLine];
    
    if ([dict[@"type"] integerValue] == 2) {
        [self.footButton setTitle:@"审核付款" forState:UIControlStateNormal];
    }else if ([dict[@"type"] integerValue] == 4){
        [self.footButton setTitle:@"开始配送" forState:UIControlStateNormal];
    }else if ([dict[@"type"] integerValue] == 5){
        for (XNRRscSkusModel *skuModel in model.SKUList) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                [self.footButton setTitle:@"客户自提" forState:UIControlStateNormal];
            }
        }
    }else if ([dict[@"type"] integerValue] == 6){
        for (XNRRscSkusModel *skuModel in model.SKUList) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                [self.footButton setTitle:@"开始配送" forState:UIControlStateNormal];
            }
        }
    }

}

#pragma mark - 在段尾添加任意视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    XNRRscOrderDetailModel *detailModel = _dataArray[section];
    UIView *sectionFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80))];
    sectionFootView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sectionFootView];
    
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(30), PX_TO_PT(80))];
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    totalPriceLabel.text = [NSString stringWithFormat:@"合计：¥ %@",detailModel.totalPrice];
    [sectionFootView addSubview:totalPriceLabel];
    
    NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
    NSDictionary *priceStr=@{
                             NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                             NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                             
                             };
    
    [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
    
    [totalPriceLabel setAttributedText:AttributedStringPrice];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(1))];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [sectionFootView addSubview:lineView];

    return sectionFootView;
  }


-(void)footButtonClick
{
    for (XNRRscSkusModel *skuModel in _orderModel.SKUs) {
        skuModel.isSelected = NO;
    }
    for (XNRRscOrderDetailModel *detailModel in _dataArray) {
        NSDictionary *dict = detailModel.orderStatus;
        if ([dict[@"type"] integerValue] == 2) {
            [self getdetailData:detailModel];
        }else if ([dict[@"type"] integerValue] == 4||[dict[@"type"] integerValue] == 6){
            [self.deliverView show:_orderModel andType:isFromDeliverController];
        }else if([dict[@"type"] integerValue] == 5){
            [self.deliverView show:_orderModel andType:isFromTakeController];
        }
    }
}

-(void)getdetailData:(XNRRscOrderDetailModel *)model
{
    [KSHttpRequest get:KRscOrderDetail parameters:@{@"orderId":model.id} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *orderDict = result[@"order"];
            XNRRscOrderDetailModel *detailModel = [[XNRRscOrderDetailModel alloc] init];
            detailModel.consigneeName = orderDict[@"consigneeName"];
            NSDictionary *payment = orderDict[@"payment"];
            detailModel.price = payment[@"price"];
            detailModel.id = payment[@"id"];
            [self.identifyPayView show:detailModel.consigneeName andPrice:detailModel.price andPaymentId:detailModel.id];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - tableView代理方法
// 段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
      return PX_TO_PT(80);
}
// 设置段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XNRRscOrderDetailModel *model = _dataArray[section];
    return model.SKUList.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscOrderDetailModel *model = _dataArray[indexPath.section];
    XNRRscOrderDetialFrameModel *frameModel = model.SKUFrameList[indexPath.row];
    return frameModel.cellHeight;
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscOrderDetialCell *cell = [XNRRscOrderDetialCell cellWithTableView:tableView];
    XNRRscOrderDetailModel *model = _dataArray[indexPath.section];
    XNRRscOrderDetialFrameModel *frameModel = model.SKUFrameList[indexPath.row];
    cell.frameModel = frameModel;
    return cell;
    
}


-(void)setNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单详情";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 30, 44);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
     [backButton setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#009975"]] forState:UIControlStateHighlighted];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
