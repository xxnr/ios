//
//  XNRSendView.m
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRSendView.h"
#import "XNRMyOrderSend_Cell.h"
#import "XNRMyOrderModel.h"
#import "XNRMyOrderSectionModel.h"
#import "XNROrderEmptyView.h"
#import "XNRMyAllOrderFrame.h"
#import "XNRMyOrderServe_Cell.h"

@interface XNRSendView()<XNROrderEmptyViewBtnDelegate>
@property (nonatomic ,weak)XNROrderEmptyView *orderEmptyView;
@property (nonatomic, weak) UIButton *backtoTopBtn;
@end
@implementation XNRSendView
-(XNROrderEmptyView *)orderEmptyView
{
    if (!_orderEmptyView) {
        XNROrderEmptyView *orderEmptyView = [[XNROrderEmptyView alloc] init];
        orderEmptyView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-PX_TO_PT(100)-64);
        orderEmptyView.delegate = self;
        [self addSubview:orderEmptyView];
    }
    return _orderEmptyView;
    
}

#pragma mark - 图片为空的代理方法
-(void)XNROrderEmptyView:(XNROrderEmptyViewbuySort)type
{
    if (type == XNROrderEmptyView_buyFer) {
        
    }else if(type == XNROrderEmptyView_buyCar){
        
    }
}


-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [[NSMutableArray alloc]init];
        //获取数据
        [self getData];
        //创建订单
        [self createMainTableView];
        
        [self setupStaySendRefresh];
        
        [self createbackBtn];
 
    }
    return self;
}

#pragma mark - 滑动到顶部按钮

-(void)createbackBtn
{
    
    UIButton *backtoTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backtoTopBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(60)-PX_TO_PT(32), ScreenHeight-PX_TO_PT(164), PX_TO_PT(100), PX_TO_PT(100));
    
    [backtoTopBtn setImage:[UIImage imageNamed:@"icon_home_backTop"] forState:UIControlStateNormal];
    
    [backtoTopBtn addTarget:self action:@selector(backtoTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.backtoTopBtn = backtoTopBtn;
    
    [self addSubview:backtoTopBtn];
    
}

-(void)backtoTopBtnClick{
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    
    NSLog(@"%f",scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y == 0) {
        
        self.backtoTopBtn.hidden = YES;
        
    }else{
        
        self.backtoTopBtn.hidden = NO;
        
    }
    
}
#pragma mark - 刷新

-(void)setupStaySendRefresh{
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
    
    // 设置刷新图片
    
    [footer setImages:RefreshImage forState:MJRefreshStateRefreshing];
    
    
    
    footer.refreshingTitleHidden = YES;
    
    // 设置尾部
    
    self.tableView.mj_footer = footer;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headRefresh) name:@"reloadOrderList" object:nil];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadOrderList" object:nil];
    
}

-(void)headRefresh{
    
    _currentPage = 1;
    
    [_dataArr removeAllObjects];
    
    [self getData];
    
}

-(void)footRefresh{
    
    _currentPage ++;
    
    [self getData];
    
}



#pragma mark - 获取数据
- (void)getData
{
//    typeValue说明：1为待支付（代付款）：2为商品准备中（待发货），3已发货（待收货），4已收货（待评价）
    [KSHttpRequest post:KGetOderList parameters:@{@"userId":[DataCenter account].userid,@"page":[NSString stringWithFormat:@"%d",_currentPage],@"typeValue":@"2",@"user-agent":@"IOS-v2.0"} success:^(id result) {
       
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datasDic = result[@"datas"];
            NSArray *rowsArr = datasDic[@"rows"];
            for (NSDictionary *subDic in rowsArr) {
                XNRMyOrderSectionModel *sectionModel = [[XNRMyOrderSectionModel alloc]init];
                sectionModel.orderId = subDic[@"orderId"];
                sectionModel.payType = subDic[@"payType"];
                sectionModel.duePrice = subDic[@"duePrice"];
                
                NSDictionary *orders = subDic[@"order"];
                sectionModel.deposit = orders[@"deposit"];
                sectionModel.totalPrice = orders[@"totalPrice"];
                NSDictionary *orderStatus = orders[@"orderStatus"];
                sectionModel.type = [orderStatus[@"type"] integerValue];
                sectionModel.value = orderStatus[@"value"];
                
                sectionModel.products = (NSMutableArray *)[XNRMyOrderModel objectArrayWithKeyValuesArray:subDic[@"products"]];
                
                sectionModel.skus = (NSMutableArray *)[XNRMyOrderModel objectArrayWithKeyValuesArray:subDic[@"SKUs"]];
                
                if (sectionModel.skus.count == 0) {
                    for (XNRMyOrderModel *model in sectionModel.products) {
                        XNRMyAllOrderFrame *frameOrder = [[XNRMyAllOrderFrame alloc] init];
                        frameOrder.orderModel = model;
                        
                        [sectionModel.orderFrameArray addObject:frameOrder];
                    }
                    
                }else{
                    for (XNRMyOrderModel *model in sectionModel.skus) {
                        XNRMyAllOrderFrame *frameOrder = [[XNRMyAllOrderFrame alloc] init];
                        frameOrder.orderModel = model;
                        
                        [sectionModel.orderFrameArray addObject:frameOrder];
                    }
                    
                }
                
                
                [_dataArr addObject:sectionModel];
            }
        }
        
        //刷新列表
        [self.tableView reloadData];
        
        if (_dataArr.count == 0) {
            [self orderEmptyView];
        }
        
            

        
        //  如果到达最后一页 就消除footer
        
        NSInteger pages = [result[@"datas"][@"pages"] integerValue];
        
        NSInteger page = [result[@"datas"][@"page"] integerValue];
        
        
        
        self.tableView.mj_footer.hidden = pages == page;
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView.mj_footer endRefreshing];
        


        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView.mj_footer endRefreshing];
        

        
    }];
}

#pragma mark--创建
-(void)createMainTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(100)) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArr.count > 0) {
        XNRMyOrderSectionModel *sectionModel = _dataArr[section];
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(89))];
        headView.backgroundColor = [UIColor whiteColor];
        [self addSubview:headView];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(28), ScreenWidth/2, PX_TO_PT(32))];
        label.text = [NSString stringWithFormat:@"订单号 : %@",sectionModel.orderId];
        label.textColor = R_G_B_16(0x323232);
        label.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
        label.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:label];
        
        UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0,ScreenWidth/2-PX_TO_PT(32) , PX_TO_PT(89))];
        payTypeLabel.textColor = R_G_B_16(0xfe9b00);
        payTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        payTypeLabel.textAlignment = NSTextAlignmentRight;
        payTypeLabel.text = sectionModel.value;
        [headView addSubview:payTypeLabel];
        
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
        lineView1.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(89), ScreenWidth, PX_TO_PT(1))];
        lineView2.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView2];
        
        return headView;
        
    } else {
        return nil;
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataArr.count>0) {
        UIView *bottomView = [[UIView alloc] init];
        XNRMyOrderSectionModel *sectionModel = _dataArr[section];
        
        bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(100));
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
                
        
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PX_TO_PT(0), ScreenWidth -PX_TO_PT(32), PX_TO_PT(80))];
        totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        totalPriceLabel.textAlignment = NSTextAlignmentRight;
        totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sectionModel.totalPrice.doubleValue];
        [bottomView addSubview:totalPriceLabel];
                
        NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
                NSDictionary *priceStr=@{
                                         
                                         NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
                                         
                                         };
                
                [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
                
                [totalPriceLabel setAttributedText:AttributedStringPrice];
                
                
                UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(20))];
                sectionView.backgroundColor = R_G_B_16(0xf4f4f4);
                [bottomView addSubview:sectionView];
                
                for (int i = 0; i<2; i++) {
                    
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
                    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
                    [bottomView addSubview:lineView];
                }
        
        return bottomView;
    }else{
        return nil;
    
  }
}

#pragma mark - tableView代理方法

// 端头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(88);
    
}

// 断尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataArr.count>0) {
        
        return PX_TO_PT(100);
        
    }else{
        return 0;
    }
    
    
}

// 设置段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArr.count>0) {
        XNRMyOrderSectionModel *sectionModel = _dataArr[section];
        return sectionModel.orderFrameArray.count;
    }else{
        return 0;
    }
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArr.count>0) {
        XNRMyOrderSectionModel *sectionModel = _dataArr[indexPath.section];
        if (sectionModel.orderFrameArray.count>0) {
            XNRMyAllOrderFrame *frameModel = sectionModel.orderFrameArray[indexPath.row];
            return  frameModel.cellHeight;
        }else{
            return 0;
        }
        
    }else{
        return 0;
    }
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"被点击了");
    XNRMyOrderSectionModel *sectionModel = _dataArr[indexPath.section];
    self.checkOrderBlock(sectionModel.orderId);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    XNRMyOrderServe_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        //单元格复用cellID要一致
        cell = [[XNRMyOrderServe_Cell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //传递数据模型model
    if (_dataArr.count>0) {
        XNRMyOrderSectionModel *sectionModel = _dataArr[indexPath.section];
        if (sectionModel.skus.count>0) {
            XNRMyOrderModel *model = sectionModel.skus[indexPath.row];
            cell.attributesArray = model.attributes;
            cell.addtionsArray = model.additions;
            XNRMyAllOrderFrame *frameModel = sectionModel.orderFrameArray [indexPath.row];
            cell.orderFrame = frameModel;

        }else{
            XNRMyOrderModel *model = sectionModel.products[indexPath.row];
            cell.attributesArray = model.attributes;
            cell.addtionsArray = model.additions;
        }
    }
    
    
    return cell;
}

@end
