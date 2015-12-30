//
//  XNRPayView.m
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRPayView.h"
#import "XNRMyOrderModel.h"
#import "XNRMyOrderPayCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "XNRCheckOrder_VC.h"
#define kPayViewURL @"app/order/getOderList"  //待付款
#define kDeleteOrder @"app/order/cancelOrder" //取消订单

@interface XNRPayView ()

@end

@implementation XNRPayView
-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {

        
        NSLog(@"1");
        self.urlString = urlString;
        _currentPage = 1;
        _dataArr = [[NSMutableArray alloc]init];
       
        //获取数据
        [self getData];
        
        //创建订单
        [self createMainTableView];
       
        //创建底部视图
        [self createBottomView];
     
    }
    
    return self;
}

#pragma mark - 获取数据
- (void)getData
{
    
    //typeValue说明：1为待支付（未付款）：2为商品准备中（待发货），3已发货（待收货），4已收货（待评价）
    [KSHttpRequest post:KGetOderList parameters:@{@"userId":[DataCenter account].userid,@"page":[NSString stringWithFormat:@"%d",_currentPage],@"typeValue":@"1",@"user-agent":@"IOS-v2.0"} success:^(id result) {
       
        if ([result[@"code"] integerValue] == 1000) {
            LogRed(@"%@",result);
            if (_currentPage == 1) {
                [_dataArr removeAllObjects];
            }
            
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

#pragma mark--创建尾部视图
-(void)createfootView{
    
    self.footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    self.footView.backgroundColor=[UIColor whiteColor];
    
    //商品总数
    self.allNum=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    self.allNum.textColor=R_G_B_16(0xb1b1b1);
    self.allNum.font=XNRFont(14);
    self.allNum.adjustsFontSizeToFitWidth=YES;
    [self.footView addSubview:self.allNum];
    //积分抵用
    
    self.score=[[UILabel alloc]initWithFrame:CGRectMake(self.allNum.frame.origin.x+self.allNum.frame.size.width+20, 10, 100, 20)];
    self.score.textColor=R_G_B_16(0xb1b1b1);
    self.score.font=XNRFont(14);
    self.score.adjustsFontSizeToFitWidth=YES;
  
    [self.footView addSubview:self.score];
    //合计
    
    self.totoalMoney=[[UILabel alloc]initWithFrame:CGRectMake(self.score.frame.origin.x+self.score.frame.size.width+20, 10, 100, 20)];
    self.totoalMoney.textColor=R_G_B_16(0xb1b1b1);
    self.totoalMoney.font=XNRFont(14);
    self.totoalMoney.adjustsFontSizeToFitWidth=YES;
   
    [self.footView addSubview:self.totoalMoney];
    
    self.tableView.tableFooterView=self.footView;
    
    
    
}

#pragma mark--创建
-(void)createMainTableView{
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-60*SCALE-5-64-49) style:UITableViewStylePlain];
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
    
    XNRMyOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        //单元格复用cellID要一致
        cell = [[XNRMyOrderPayCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
    }
    [cell setDeleteBlock:^{
        //删除订单
        XNRMyOrderModel *model = _dataArr[indexPath.row];
        [SVProgressHUD showWithStatus:@"订单删除中" maskType:SVProgressHUDMaskTypeClear];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [KSHttpRequest post:[NSString stringWithFormat:@"%@/%@",HOST,kDeleteOrder] parameters:@{@"locationUserId":[DataCenter account].userid,@"userId":[DataCenter account].userid,@"orderId":model.orderId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                LogBlue(@"%@",result[@"message"]);
                
                if ([result[@"code"] isEqualToString:@"1000"]) {
                    [_dataArr removeObjectAtIndex:indexPath.row];
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    [_tableView reloadData];
                    [SVProgressHUD showSuccessWithStatus:@"订单删除成功"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"删除订单失败"];
                }
                
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"删除订单失败"];
            }];
        });
        
    }];
    [cell setGoPayBlock:^{
        self.payBlock([_dataArr[indexPath.row] deposit].floatValue,[_dataArr[indexPath.row] orderNo],[_dataArr[indexPath.row] orderId]);
    }];
    
    [cell setCheckOrderBlock:^(NSString *orderID,NSString*orderNO) {
        self.checkOrderBlock(orderID,orderNO);
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    //传递数据模型model
    [cell setCellDataWithShoppingCartModel:_dataArr[indexPath.row]];

    return cell;
    
    
}

#pragma mark - 创建底部视图
- (void)createBottomView{
    
    UIView *bootomView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-60*SCALE-5-49-64, ScreenWidth, 49)];
    bootomView.backgroundColor=[UIColor whiteColor];
    [self addSubview:bootomView];
   
    //联系客服
    UIButton*contact=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth/2-100, 15, 80, bootomView.frame.size.height) ImageName:nil Target:self Action:@selector(contactUs) Title:@"联系客服"];
    contact.center = CGPointMake(ScreenWidth/2.0, bootomView.frame.size.height/2.0);
    [contact setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    contact.titleLabel.font=XNRFont(16);
    [bootomView addSubview:contact];
    
}
#pragma mark--全部结算
-(void)goPay{
    
    NSLog(@"全部结算");
    CGFloat money = 0;
    for (XNRMyOrderModel *model in _dataArr) {
        money = model.totalPrice.floatValue + money;
    }
    self.allPayBlock(money);
    
}

#pragma mark--联系客服
-(void)contactUs{
    
    NSLog(@"联系客服");
    //联系客服
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LianXiKeFu" object:nil];
}

@end
