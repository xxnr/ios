//
//  XNRRscSearchController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/5/3.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscSearchController.h"
#import "XNRSearchBar.h"
#import "XNRRscSectionHeadView.h"
#import "XNRRscSectionFootView.h"
#import "XNRRscMyOrderStateCell.h"
#import "XNRRscOrderModel.h"
#import "XNRRscSkusFrameModel.h"
#import "XNRRscIdentifyPayView.h"
#import "XNRRscConfirmDeliverView.h"
#import "XNRRscOrderDetailModel.h"
#import "XNRRscFootFrameModel.h"
#import "XNRRscOrderDetialController.h"
@interface XNRRscSearchController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) XNRSearchBar *searchBar;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataFrameArray;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, weak) XNRRscIdentifyPayView *identifyPayView;

@property (nonatomic, weak) XNRRscConfirmDeliverView *deliverView;

@end

@implementation XNRRscSearchController

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
    self.view.backgroundColor = R_G_B_16(0xfafafa);
    self.navigationItem.hidesBackButton = YES;
    XNRSearchBar *searchBar = [XNRSearchBar searchBar];
    searchBar.width = ScreenWidth-PX_TO_PT(60);
    searchBar.height = PX_TO_PT(60);
//    [searchBar becomeFirstResponder];
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;
    
    [self setNavigationBar];
    
    _dataArray = [NSMutableArray array];
    _dataFrameArray = [NSMutableArray array];
    [self createView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

}

-(void)createView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = YES;
    tableView.delegate = self;
    tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    tableView.dataSource = self;
    tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
}

-(void)keyboardHide:(NSNotification *)notif
{
    [_dataArray removeAllObjects];
    [KSHttpRequest get:KRscOrders parameters:@{@"search":self.searchBar.text} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSArray *ordersArray = result[@"orders"];
            for (NSDictionary *dict in ordersArray) {
                XNRRscOrderModel *sectionModel = [[XNRRscOrderModel alloc] init];
                sectionModel.dateCreated = dict[@"dateCreated"];
                sectionModel._id = dict[@"id"];
                sectionModel.consigneeName = dict[@"consigneeName"];
                sectionModel.consigneePhone = dict[@"consigneePhone"];
                NSDictionary *deliveryType = dict[@"deliveryType"];
                sectionModel.deliveryType = deliveryType[@"type"];
                sectionModel.deliverValue = deliveryType[@"value"];
                NSDictionary *type = dict[@"type"];
                sectionModel.type = type[@"type"];
                sectionModel.value = type[@"value"];
                
                sectionModel.price = dict[@"price"];
                sectionModel.pendingApprove = dict[@"pendingApprove"];
                sectionModel.deliverStatus = dict[@"deliverStatus"];
                sectionModel.SKUs = (NSMutableArray *)[XNRRscSkusModel objectArrayWithKeyValuesArray:dict[@"SKUs"]];
                sectionModel.subOrders = (NSMutableArray *)[XNRRscSubOrdersModel objectArrayWithKeyValuesArray:dict[@"subOrders"]];
                
                for (XNRRscSkusModel *skuModel in sectionModel.SKUs) {
                    XNRRscSkusFrameModel *frameModel = [[XNRRscSkusFrameModel alloc] init];
                    frameModel.model = skuModel;
                    [sectionModel.SKUsFrame addObject:frameModel];
                }
                [_dataArray addObject:sectionModel];
                
                XNRRscFootFrameModel *footModel = [[XNRRscFootFrameModel alloc] init];
                footModel.model = sectionModel;
                [_dataFrameArray addObject:footModel];
            }
            [self.tableView reloadData];

            
        }
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - 在断头添加任意视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArray.count>0) {
        XNRRscSectionHeadView *sectionHeadView = [[XNRRscSectionHeadView alloc] init];
        XNRRscOrderModel *sectionModel = _dataArray[section];
        [sectionHeadView upDataHeadViewWithModel:sectionModel];
        [self.view addSubview:sectionHeadView];
        return sectionHeadView;
    }else{
        return nil;
    }
    
}

#pragma mark - 在断尾添加任意视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataArray.count>0) {
        XNRRscOrderModel *sectionModel = _dataArray[section];
        XNRRscSectionFootView *sectionFootView = [[XNRRscSectionFootView alloc] init];
//        [sectionFootView upDataHeadViewWithModel:sectionModel];
        [self.view addSubview:sectionFootView];
        sectionFootView.com = ^{
            if ([sectionModel.type integerValue] == 2) {
                [self getdetailData:sectionModel];
            }else if ([sectionModel.type integerValue] == 4||[sectionModel.type integerValue] == 6){
                [self.deliverView show:sectionModel andType:isFromDeliverController];
            }else if([sectionModel.type integerValue] == 5){
                [self.deliverView show:sectionModel andType:isFromTakeController];
            }
        };
        return sectionFootView;
    }else{
        return nil;
    }
}

-(void)getdetailData:(XNRRscOrderModel *)model
{
    [KSHttpRequest get:KRscOrderDetail parameters:@{@"orderId":model._id,@"token":[DataCenter account].token} success:^(id result) {
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

// 段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(88);
    
}

// 段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataFrameArray.count>0) {
        XNRRscFootFrameModel *frameModel = _dataFrameArray[section];
        return frameModel.footViewHeight;
        
    }else{
        return 0;
    }
}

//设置段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count>0) {
        XNRRscOrderModel *sectionModel = _dataArray[section];
        return sectionModel.SKUs.count;
    }else{
        return 0;
    }
}

// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count>0) {
        XNRRscOrderModel *sectionModel = _dataArray[indexPath.section];
        XNRRscSkusFrameModel *frameModel = sectionModel.SKUsFrame[indexPath.row];
        return frameModel.cellHeight;
    }else{
        return 0;
    }
    
}

// cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscOrderModel *sectionModel = _dataArray[indexPath.section];
    XNRRscOrderDetialController *detailVC = [[XNRRscOrderDetialController  alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.orderId = sectionModel._id;
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscMyOrderStateCell *cell = [XNRRscMyOrderStateCell cellWithTableView:tableView];
    if (_dataArray.count>0) {
        XNRRscOrderModel *sectionModel = _dataArray[indexPath.section];
        XNRRscSkusFrameModel *skuModel = sectionModel.SKUsFrame[indexPath.row];
        cell.frameModel = skuModel;
    }
    
    return cell;
}


-(void)setNavigationBar{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 40, 40);
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)searchBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];

}

@end
