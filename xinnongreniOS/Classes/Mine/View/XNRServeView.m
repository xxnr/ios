//
//  XNRServeView.m
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRServeView.h"
#import "XNRMyOrderModel.h"
#import "XNRMyOrderServe_Cell.h"
#import "UIImageView+WebCache.h"
#import "XNRMyOrderPayCell.h"
#import "MJRefresh.h"

#define kCommentViewURL @"app/order/getOderList"  //售后
@implementation XNRServeView
-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"2");
        self.urlString = urlString;
        _dataArr = [[NSMutableArray alloc]init];
        _currentPage = 1;
        //获取数据
        [self getData];
        //创建订单
        [self createMainTableView];
        
        
    }
    return self;
}

#pragma mark - 获取数据
- (void)getData
{
    if (_currentPage == 1) {
        [_dataArr removeAllObjects];
    }
    
    //typeValue说明：1为待支付（代付款）：2为商品准备中（待发货），3已发货（待收货），4已收货（待评价），8退货/换货（退货/售后）
    [KSHttpRequest post:KGetOderList parameters:@{@"locationUserId":[DataCenter account].userid,@"userId":[DataCenter account].userid,@"page":[NSString stringWithFormat:@"%d",_currentPage],@"typeValue":@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datasDic = result[@"datas"];
            NSArray *rowsArr = datasDic[@"rows"];
            for (NSDictionary *subDic in rowsArr) {
                XNRMyOrderModel *model = [[XNRMyOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:subDic];
                [_dataArr addObject:model];
            }
        }
        //刷新头部
        [self.tableView.legendHeader endRefreshing];
        //刷新尾部
        [self.tableView.legendFooter endRefreshing];
        //刷新列表
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络请求错误"];
        //刷新头部
        [self.tableView.legendHeader endRefreshing];
        //刷新尾部
        [self.tableView.legendFooter endRefreshing];
        //刷新列表
        [self.tableView reloadData];
    }];
}


#pragma mark--创建
-(void)createMainTableView{
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-60*SCALE-5-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    //头部刷新
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        _currentPage = 1;
        [weakSelf getData];
    }];
    
    //尾部刷新
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        _currentPage = _currentPage + 1;
        [weakSelf getData];
    }];
}
#pragma mark - tableView代理方法

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"被点击了");
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
    
    [cell setCheckOrderBlock:^(NSString *orderID,NSString*orderNO) {
        self.checkOrderBlock(orderID,orderNO);
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    //传递数据模型model
    [cell setCellDataWithShoppingCartModel:_dataArr[indexPath.row]];
    
    return cell;
    
    
}

@end
