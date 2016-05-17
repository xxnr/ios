//
//  XNRRscAllOrderView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscAllOrderView.h"
#import "XNRRscSectionHeadView.h"
#import "XNRRscSectionFootView.h"
#import "XNRRscMyOrderStateCell.h"
#import "XNRRscOrderModel.h"
#import "XNRRscSkusFrameModel.h"
#import "XNRRscIdentifyPayView.h"
#import "XNRRscConfirmDeliverView.h"
#import "XNRRscOrderDetailModel.h"
#import "XNRRscFootFrameModel.h"
#import "XNRRscNoOrderView.h"
#define MAX_PAGE_SIZE 10

@interface XNRRscAllOrderView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataFrameArray;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, weak) XNRRscIdentifyPayView *identifyPayView;

@property (nonatomic, weak) XNRRscConfirmDeliverView *deliverView;

@property (nonatomic, weak) XNRRscNoOrderView *noOrderView;


@end

@implementation XNRRscAllOrderView

-(XNRRscNoOrderView *)noOrderView
{
    if (!_noOrderView) {
        XNRRscNoOrderView *noOrderView = [[XNRRscNoOrderView  alloc] init];
        self.noOrderView = noOrderView;
        [self addSubview:noOrderView];
    }
    return _noOrderView;
    
}


-(XNRRscIdentifyPayView *)identifyPayView
{
    if (!_identifyPayView) {
        XNRRscIdentifyPayView *identifyPayView = [[XNRRscIdentifyPayView alloc] init];
        self.identifyPayView = identifyPayView;
        [self addSubview:identifyPayView];
    }
    return _identifyPayView;
}

-(XNRRscConfirmDeliverView *)deliverView
{
    if (!_deliverView) {
        XNRRscConfirmDeliverView *deliverView = [[XNRRscConfirmDeliverView alloc] init];
        self.deliverView = deliverView;
        [self addSubview:deliverView];
    }
    return _deliverView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = 1;
        _dataArray = [NSMutableArray array];
        _dataFrameArray = [NSMutableArray array];
        [self getData];
        [self createView];
        [self setupAllViewRefresh];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllTableView) name:@"refreshTableView" object:nil];

    }
    return self;
}

-(void)refreshAllTableView
{
    [self headRefresh];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 刷新
-(void)setupAllViewRefresh{
    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    NSMutableArray *idleImage = [NSMutableArray array];
    
    for (int i = 1; i<21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
        
        [idleImage addObject:image];
    }
    NSMutableArray *RefreshImage = [NSMutableArray array];
    
    for (int i = 10; i<21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
        
        [RefreshImage addObject:image];
        
    }
    
    [header setImages:idleImage forState:MJRefreshStateIdle];
    
    [header setImages:RefreshImage forState:MJRefreshStatePulling];
    
    [header setImages:RefreshImage forState:MJRefreshStateRefreshing];
    // 隐藏时
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    self.tableView.mj_header = header;
    
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    
    
    //    footer.automaticallyHidden = YES;
    
    // 设置刷新图片
    [footer setImages:RefreshImage forState:MJRefreshStateRefreshing];
    footer.refreshingTitleHidden = YES;
    
    
    // 设置尾部
    self.tableView.mj_footer = footer;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headRefresh) name:@"reloadOrderList" object:nil];
    
}
-(void)headRefresh{
    _currentPage = 1;
    [_dataFrameArray removeAllObjects];
    [_dataArray removeAllObjects];
    [self getData];
    
    
}
-(void)footRefresh{
    _currentPage ++;
    [self getData];
    
}


-(void)getData
{
    NSDictionary *params = @{@"page":[NSString stringWithFormat:@"%d",_currentPage],@"max":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE]};
    [KSHttpRequest get:KRscOrders parameters:params success:^(id result) {
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
        if (_dataArray.count == 0) {
            [self noOrderView];
        }

        //  如果到达最后一页 就消除footer
        NSInteger page = [result[@"pageCount"] integerValue];
        self.tableView.mj_footer.hidden = page == _currentPage;
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];


        
    } failure:^(NSError *error) {
        
    }];
}

-(void)createView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(100)) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = YES;
    tableView.delegate = self;
    tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    tableView.dataSource = self;
    tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self addSubview:tableView];

}

#pragma mark - 在断头添加任意视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArray.count>0) {
        XNRRscSectionHeadView *sectionHeadView = [[XNRRscSectionHeadView alloc] init];
        XNRRscOrderModel *sectionModel = _dataArray[section];
        [sectionHeadView upDataHeadViewWithModel:sectionModel];
        [self addSubview:sectionHeadView];
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
        XNRRscFootFrameModel*footFrameModel = _dataFrameArray[section];
        [sectionFootView upDataFootViewWithModel:footFrameModel];
        [self addSubview:sectionFootView];
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
    [KSHttpRequest get:KRscOrderDetail parameters:@{@"orderId":model._id} success:^(id result) {
        
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
    if (_dataArray.count>0) {
        XNRRscOrderModel *sectionModel = _dataArray[indexPath.section];
        if (self.com) {
            self.com(sectionModel);
        }
    }
   
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

@end
