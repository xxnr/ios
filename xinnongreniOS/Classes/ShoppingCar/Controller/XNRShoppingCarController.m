//
//  XNRShoppingCarController.m
//  xinnongreniOS
//
//  Created by Scarecrow on 15/5/25.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRShoppingCarController.h"
#import "XNRShoppingCartModel.h"
#import "XNRShoppingCartTableViewCell.h"
#import "XNROrderInfo_VC.h"
#import "XNRLoginViewController.h"
#import "XNRShopcarView.h"
#import "XNRHomeController.h"
#import "AppDelegate.h"
#import "XNRTabBarController.h"
#import "XNRFerViewController.h"
#import "MJRefresh.h"

@interface XNRShoppingCarController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,XNRShopcarViewBtnDelegate>
{
    NSMutableArray *_dataArr;    //购物车数据
    NSMutableArray *_brandNameMarr;//品牌名字数组
    UIButton *_settlementBtn;   //去结算
    UILabel *_totalPriceLabel;  //总价
    CGFloat _totalPrice;      //总价
    NSString*_shoppingCarID;    //购物车id
    NSMutableArray *_modifyDataArr;
    float totalPrice;
}
@property (nonatomic,strong) UIView *bottomView; // 底部视图

@property (nonatomic,weak) UITableView *shoppingCarTableView;//购物车tableView

@property (nonatomic, weak) XNRShopcarView *shopCarView;// 购物车为空时的图片

@property (nonatomic ,weak) UIView *headView;
@end

@implementation XNRShoppingCarController

- (XNRShopcarView *)shopCarView {
    if (_shopCarView == nil) {
        XNRShopcarView *shopCarView = [[XNRShopcarView alloc] init];
        shopCarView.delegate = self;
        self.shopCarView = shopCarView;
         [self.view addSubview:shopCarView];
    }
    return _shopCarView;
}
#pragma mark -- 买化肥，买汽车
-(void)ShopcarViewWith:(XNRShopcarViewbuySort)type
{
    if (type == XNRShopcarView_buyFer) {
        XNRFerViewController *ferView = [[XNRFerViewController alloc] init];
        ferView.type = eXNRFerType;
        ferView.tempTitle = @"化肥";
        ferView.classId = @"531680A5";
        ferView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ferView animated:YES];
    }else if(type == XNRShopcarView_buyCar){
        XNRFerViewController *carView = [[XNRFerViewController alloc] init];
        carView.type = eXNRCarType;
        carView.classId = @"6C7D8F66";
        carView.tempTitle = @"汽车";
        carView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:carView animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (IS_Login) {// 已登录
        // 获取数据从网络
        [self getDataFromNetwork];

        __weak __typeof(&*self)weakSelf = self;

        [self.shoppingCarTableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf getDataFromNetwork];
        }];
//        [self.shoppingCarTableView.header beginRefreshing];
        
    }else{// 未登录
        [_dataArr removeAllObjects];
        [_brandNameMarr removeAllObjects];
        // 获取数据从本地数据库
        [self getDataFromDatabase];
        [self.shoppingCarTableView reloadData];
        [self changeBottom];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataArr = [[NSMutableArray alloc]init];
    _brandNameMarr = [[NSMutableArray alloc]init];
    _modifyDataArr = [[NSMutableArray alloc] init];;
    
    //创建订单
    [self createShoppingCarTableView];
    //创建底部视图
    [self createBottomView];
}

#pragma mark - 创建底部视图
- (void)createBottomView
{
    _totalPrice = 0;    //总价
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49-40-64, ScreenWidth, 40)];
    _bottomView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.view addSubview:_bottomView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.1;
    [_bottomView addSubview:lineView];
    
    _totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 110, 40)];
    _totalPriceLabel.textColor = R_G_B_16(0xc6222b);
    _totalPriceLabel.font = XNRFont(13);
    _totalPriceLabel.adjustsFontSizeToFitWidth = YES;
    [_bottomView addSubview:_totalPriceLabel];
    
    _settlementBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-80-5, 5, 80, 30) ImageName:nil Target:self Action:@selector(settlementBtnClick:) Title:nil];
    _settlementBtn.layer.masksToBounds = YES;
    _settlementBtn.layer.cornerRadius = 5;
    _settlementBtn.backgroundColor = [UIColor lightGrayColor];
    _settlementBtn.enabled = NO;
    [_settlementBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [_settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settlementBtn.titleLabel.font = XNRFont(14);
    [_bottomView addSubview:_settlementBtn];
    
}

#pragma mark - 结算
- (void)settlementBtnClick:(UIButton *)button
{
    //登录
    if (IS_Login) {
  //打开订单信息页
    [self openOrder];
    }else{ // 未登录
        //登录警告视图
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"您尚未登录" message:@"请先前往登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert1 show];

    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 1) {
            XNRLoginViewController *login = [[XNRLoginViewController alloc]init];
            login.loginFrom = @"shoppingCar";
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];

    }
}

#pragma mark - 跳转订单信息页
- (void)openOrder {
    //这个地方做出修改界面逻辑错误先确认订单在提交支付
    XNROrderInfo_VC*vc=[[XNROrderInfo_VC alloc] init];
    vc.hidesBottomBarWhenPushed=YES;
    NSMutableArray*arr=[[NSMutableArray alloc]init];
    for (int i = 0; i<_dataArr.count; i++) {
        NSMutableArray *modelArr = _dataArr[i];
        for (int j=0; j<modelArr.count; j++) {
            XNRShoppingCartModel *model = modelArr[j];
            if(model.num.intValue>0){
                [arr addObject:model];
            }
        }
    }
    //将所有数据中产品数量大于0的model加入数组等待传值
//    vc.dataArray=arr;
    vc.shopCarID=_shoppingCarID;
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 改变底部视图
- (void)changeBottom{
    _totalPrice = 0;
    for (int i = 0; i<_dataArr.count; i++) {
        NSMutableArray *modelArr = _dataArr[i];
        for (int j=0; j<modelArr.count; j++) {
            XNRShoppingCartModel *model = modelArr[j];
            
        if ([model.deposit integerValue] == 0 || model.deposit == nil) {
            _totalPrice = _totalPrice + model.num.intValue*[[NSString stringWithFormat:@"%.2f",model.unitPrice] floatValue];
                }else{
                    _totalPrice = _totalPrice + model.num.intValue*[[NSString stringWithFormat:@"%@",model.deposit] integerValue];
                }
        }
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"合计: ￥%.2f",_totalPrice];
    
    if (_totalPrice == 0) {
        
        [self.shopCarView show];
        _settlementBtn.enabled = NO;
        _settlementBtn.backgroundColor = [UIColor lightGrayColor];
    }else{
        [self.shopCarView removeFromSuperview];
        _settlementBtn.enabled = YES;
        _settlementBtn.backgroundColor = R_G_B_16(0x00b38a);
    }
}

#pragma mark - 获取数据从网络
- (void)getDataFromNetwork {
    //网络请求成功先删除数据
    [_dataArr removeAllObjects];
    [_brandNameMarr removeAllObjects];
    //改变底部
    [self changeBottom];
    [self.shoppingCarTableView reloadData];
    
    [KSHttpRequest post:KGetShopCartList parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            //网络请求成功先删除数据
            [_dataArr removeAllObjects];
            [_brandNameMarr removeAllObjects];
            
            NSDictionary *datasDic = result[@"datas"];
            
            _shoppingCarID=datasDic[@"shopCartId"];
            NSArray *rowsArr = datasDic[@"rows"];
            for (NSDictionary *subDic in rowsArr) {
                NSArray *goodsListArr = subDic[@"goodsList"];
                NSMutableArray *tempSubDataArr = [[NSMutableArray alloc]init];
                for (NSDictionary *subDic2 in goodsListArr) {
                    XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc]init];
                    [model setValuesForKeysWithDictionary:subDic2];
                    model.num = model.goodsCount;
                    [tempSubDataArr addObject:model];
                }
                [_brandNameMarr addObject:subDic[@"brandName"]];
                [_dataArr addObject:tempSubDataArr];
            }
            //改变底部
            [self changeBottom];
            [self.shoppingCarTableView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:result[@"message"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
        }
        [self.shoppingCarTableView.header endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"购物车列表获取失败"];
        [self.shoppingCarTableView.header endRefreshing];

    }];
}

#pragma mark - 获取数据从数据库
- (void)getDataFromDatabase {
    DatabaseManager *manager = [DatabaseManager sharedInstance];
    //获取所有购物车数据(存的时候已经去重)
    NSArray *allGoodArr = [manager queryAllGood];
    //品牌名数组
    NSLog(@"_____%@",allGoodArr);
    NSMutableArray *tempMarr = [[NSMutableArray alloc]init];
    for (int i=0; i<allGoodArr.count; i++) {
        XNRShoppingCartModel *model = allGoodArr[i];
        [tempMarr addObject:model.brandName];
    }
    //数组去重
    NSSet *set = [NSSet setWithArray:tempMarr];
    _brandNameMarr = [[set allObjects] mutableCopy];
    
    for (int i = 0; i<_brandNameMarr.count; i++) {
        NSArray *arr = [manager queryTypeGoodWithBrandName:_brandNameMarr[i]];
        [_dataArr addObject:arr];
    }
    
}
#pragma mark - 创建购物车
- (void)createShoppingCarTableView
{
    UITableView *shoppingCarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
    shoppingCarTableView.backgroundColor = [UIColor clearColor];
    shoppingCarTableView.showsVerticalScrollIndicator = YES;
    shoppingCarTableView.delegate = self;
    shoppingCarTableView.dataSource = self;
    shoppingCarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shoppingCarTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];  //添加尾部视图防止遮挡无法点击
    self.shoppingCarTableView = shoppingCarTableView;
    [self.view addSubview:shoppingCarTableView];
    
//    self.shoppingCarTableView.tableHeaderView = _headView;
}

#pragma mark - tableView代理方法

// 在段头添加任意的视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headView.backgroundColor = [UIColor whiteColor];
    self.headView = headView;
    [self.view addSubview:headView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 29)];
    label.text = _brandNameMarr[section];
    label.textColor = [UIColor blackColor];
    label.font = XNRFont(18);
    [headView addSubview:label];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 29, ScreenWidth-20, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [headView addSubview:lineView];
    return headView;
}

//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

//段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _dataArr.count-1) {
        return 0.0;
    }
    return 20.0;
}

//设置段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return _dataArr.count;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = _dataArr[section];
    return arr.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    XNRShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        //单元格复用cellID要一致
        cell = [[XNRShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        cell.backgroundColor = [UIColor whiteColor];
    }
        XNRShoppingCartModel *model = _dataArr[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //传递数据模型model
        [cell setCellDataWithShoppingCartModel:model];
    
    cell.changeBottomBlock = ^{
        [self changeBottom];
    };
    cell.deleteBlock = ^{
        //每个cell对应一个block 不需要传入indexPath
        NSMutableArray *marr = _dataArr[indexPath.section];
        if (!IS_Login) {
            DatabaseManager *manager = [DatabaseManager sharedInstance];
            //数据库删除
            [manager deleteShoppingCarWithModel:marr[indexPath.row]];
        }else{
        
        }

        [marr removeObjectAtIndex:indexPath.row];
        //加删除动画
        [self.shoppingCarTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if (marr.count == 0) {
            [_dataArr removeObjectAtIndex:indexPath.section];
            [_brandNameMarr removeObjectAtIndex:indexPath.section];
            [self.shoppingCarTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];

        }
        [self.shoppingCarTableView reloadData];
        [self changeBottom];
    };
    return cell;
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
