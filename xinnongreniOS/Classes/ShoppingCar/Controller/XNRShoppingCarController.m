//
//  XNRShoppingCarController.m
//  xinnongreniOS
//
//  Created by Scarecrow on 15/5/25.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRShoppingCarController.h"
#import "XNRShoppingCartModel.h"
#import "XNRShopCarSectionModel.h"
#import "XNRShoppingCartTableViewCell.h"
#import "XNROrderInfo_VC.h"
#import "XNRLoginViewController.h"
#import "XNRShopcarView.h"
#import "XNRHomeController.h"
#import "AppDelegate.h"
#import "XNRTabBarController.h"
#import "XNRFerViewController.h"
#import "MJRefresh.h"
#import "XNRProductInfo_VC.h"
#import "MJExtension.h"


@interface XNRShoppingCarController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,XNRShopcarViewBtnDelegate>
{
    NSMutableArray *_dataArr;    //购物车数据
    NSMutableArray *_brandNameArr;
    UIButton *_settlementBtn;   //去结算
    UIButton *_deleteBtn;       // 删除
    UILabel *_totalPriceLabel;  //总价
    float _totalPrice;      //总价
    NSString*_shoppingCarID;    //购物车id
    NSMutableArray *_modifyDataArr; // 更新的数据
    float totalPrice;
    BOOL sort;
}
@property (nonatomic,strong) UIView *bottomView; // 底部视图

@property (nonatomic,weak) UITableView *shoppingCarTableView;//购物车

@property (nonatomic, weak) XNRShopcarView *shopCarView;// 购物车为空时的图片

@property (nonatomic ,weak) UIView *headView; // 头部品牌视图

@property (nonatomic ,weak) UIButton *editeBtn;

@property (nonatomic ,weak) UIButton *selectedBottomBtn;

@property (nonatomic ,weak) UIButton *selectedHeadBtn;

@end

@implementation XNRShoppingCarController

#pragma mark - 购物车为空
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
    self.selectedBottomBtn.selected = NO;
    
    [self.editeBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _deleteBtn.hidden = YES;
    _settlementBtn.hidden = NO;
    _totalPriceLabel.hidden = NO;
    
    if (IS_Login) {// 已登录
        // 获取数据从网络
        [self getDataFromNetwork];
        [self changeBottom];

    }else{// 未登录
        [_dataArr removeAllObjects];
        // 获取数据从本地数据库
        [self getDataFromDatabase];
        [self.shoppingCarTableView reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataArr = [[NSMutableArray alloc]init];
    _brandNameArr = [[NSMutableArray alloc] init];
    _modifyDataArr = [[NSMutableArray alloc] init];
    
    //创建订单
    [self createShoppingCarTableView];
    //创建底部视图
    [self createBottomView];
    // 创建导航栏
    [self createNavgation];
    
}


#pragma mark - 创建导航栏
-(void)createNavgation{
    self.navigationItem.title = @"购物车";
    
    UIButton *editeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editeBtn.frame = CGRectMake(0, 0, 40, 40);
    [editeBtn setTitle:@"编辑" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:editeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.editeBtn = editeBtn;
    [editeBtn addTarget:self action:@selector(editeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backClick:(UIButton *)button{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)editeBtnClick{
    sort = !sort;
    if (sort) {
        [self.editeBtn setTitle:@"完成" forState:UIControlStateNormal];
        _totalPriceLabel.hidden  = YES;
        _settlementBtn.hidden = YES;
        _deleteBtn.hidden = NO;
    }else{
        [self.editeBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _totalPriceLabel.hidden  = NO;
        _settlementBtn.hidden = NO;
        _deleteBtn.hidden = YES;

    }
}

#pragma mark - 创建底部视图
- (void)createBottomView
{
    _totalPrice = 0;    //总价
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49-PX_TO_PT(88)-64, ScreenWidth, PX_TO_PT(88))];
    _bottomView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.view addSubview:_bottomView];
    
    UIButton *selectedBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedBottomBtn.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(36), PX_TO_PT(36));
    [selectedBottomBtn setImage:[UIImage imageNamed:@"shopCar_circle"] forState:UIControlStateNormal];
    [selectedBottomBtn setImage:[UIImage imageNamed:@"shopcar_right"] forState:UIControlStateSelected];
    [selectedBottomBtn addTarget: self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedBottomBtn = selectedBottomBtn;
    [_bottomView addSubview:selectedBottomBtn];
    
    UILabel *allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectedBottomBtn.frame) + PX_TO_PT(20), PX_TO_PT(28), ScreenWidth/2, PX_TO_PT(32))];
    allSelectLabel.text = @"全选";
    allSelectLabel.font = XNRFont(16);
    allSelectLabel.textAlignment = NSTextAlignmentLeft;
    allSelectLabel.textColor = R_G_B_16(0x323232);
    [_bottomView addSubview:allSelectLabel];
    
    _totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth-PX_TO_PT(220)-PX_TO_PT(20), PX_TO_PT(88))];
    _totalPriceLabel.textColor = R_G_B_16(0x323232);
    _totalPriceLabel.font = XNRFont(14);
    _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    _totalPriceLabel.adjustsFontSizeToFitWidth = YES;
    [_bottomView addSubview:_totalPriceLabel];
    
    _settlementBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(220), 0, PX_TO_PT(220), PX_TO_PT(88)) ImageName:nil Target:self Action:@selector(settlementBtnClick:) Title:nil];
    _settlementBtn.backgroundColor = R_G_B_16(0xfe9b00);
    _settlementBtn.enabled = NO;
    [_settlementBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [_settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settlementBtn.titleLabel.font = XNRFont(14);
    [_bottomView addSubview:_settlementBtn];
    
    _deleteBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(220), 0, PX_TO_PT(220), PX_TO_PT(88)) ImageName:nil Target:self Action:@selector(deleteBtnClick:) Title:nil];
    _deleteBtn.backgroundColor = R_G_B_16(0xfe9b00);
    _deleteBtn.enabled = NO;
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = XNRFont(14);
    _deleteBtn.hidden = YES;
    [_bottomView addSubview:_deleteBtn];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.1;
    [_bottomView addSubview:lineView];
}

#pragma mark -  底部按钮点击

-(void)selectedClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    for (XNRShopCarSectionModel *sectionModel in _dataArr) {
        sectionModel.isSelected = sender.selected;
        for (XNRShoppingCartModel *shopCar in sectionModel.goodsList) {
            shopCar.selectState = sender.selected;
        }
    }
    
    [self changeBottom];
    [self.shoppingCarTableView reloadData];

}
#pragma mark - 结算
- (void)settlementBtnClick:(UIButton *)button
{
    //登录
    if (IS_Login) {

        if (_totalPrice == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请至少选择一件商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
         
        }else{// 打开订单信息页
            
        [self openOrder];
        }
    }else{ // 未登录
        //登录警告视图
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"您尚未登录" message:@"请先前往登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert1.tag = 1000;
        [alert1 show];

    }
}

#pragma mark - 删除
-(void)deleteBtnClick:(UIButton *)button{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认要删除该商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 1001;
    [alertView show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            XNRLoginViewController *login = [[XNRLoginViewController alloc]init];
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:login animated:YES];
            
        }

    }else{
        if (buttonIndex == 1) {
            NSMutableArray *arr1 = [NSMutableArray array];
            NSMutableArray *arr2 = [NSMutableArray array];
            
            //1.先删除购物车 中的数据 并且用arr1、arr2记录要删除的数据
            for (XNRShopCarSectionModel *sectionModel in _dataArr) {
                
                if (sectionModel.isSelected) {
                    if (!IS_Login) { //未登录时 把数据库这条数据删除
                        for (XNRShoppingCartModel *carModel in sectionModel.goodsList) {
                            DatabaseManager *manager = [DatabaseManager sharedInstance];
                            [manager deleteShoppingCarWithModel:carModel];
                        }
                    } else { //TODO:服务器调用接口 让服务器把这条数据删除
                        for (XNRShoppingCartModel *carModel in sectionModel.goodsList) {
                            [KSHttpRequest post:KUpdateShoppingCart parameters:@{@"userId":[DataCenter account].userid,@"goodsId":carModel.goodsId,@"quantity":@"0"} success:^(id result) {
                                if ([result[@"code"] integerValue] == 1000) {
                                    
                                }
                            } failure:^(NSError *error) {
                                
                            }];
                        }
                        
                        
                    }
                    
                    [arr1 addObject:sectionModel];
                    
                } else {
                    for (XNRShoppingCartModel *model in sectionModel.goodsList) {
                        if (model.selectState) {
                            if (!IS_Login) {//未登录时 把数据库这条数据删除
                                DatabaseManager *manager = [DatabaseManager sharedInstance];
                                [manager deleteShoppingCarWithModel:model];
                            } else {
                                //TODO:服务器调用接口 让服务器把这条数据删除
                                [KSHttpRequest post:KchangeShopCarNum parameters:@{@"userId":[DataCenter account].userid,@"goodsId":model.goodsId,@"quantity":@"0"} success:^(id result) {
                                    
                                } failure:^(NSError *error) {
                                    
                                }];
                            }
                            [arr2 addObject:model];
                        }
                    }
                }
            }
            
            //2.删除数据源里面的记录的数据
            for (int i = 0; i < arr1.count; i++) {
                XNRShopCarSectionModel *sectionModel = arr1[i];
                [_dataArr removeObject:sectionModel];
            }
            for (XNRShopCarSectionModel *sectionModel in _dataArr) {
                for (XNRShoppingCartModel *cellModel in arr2) {
                    [sectionModel.goodsList removeObject:cellModel];
                }
            }
            
            [self.shoppingCarTableView reloadData];
            
            if (_dataArr.count == 0) {
                [self.shopCarView show];
                self.editeBtn.hidden = YES;
                self.navigationItem.title = @"购物车";
            }else{
                [self.shopCarView removeFromSuperview];
            }

            
        }
    }
    // 改变底部
    [self changeBottom];
}

#pragma mark - 跳转订单信息页
- (void)openOrder {
    //这个地方做出修改界面逻辑错误先确认订单在提交支付
    XNROrderInfo_VC*vc=[[XNROrderInfo_VC alloc] init];
    vc.hidesBottomBarWhenPushed=YES;
    // 去结算
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    // 提交订单
    NSMutableArray *idArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<_dataArr.count; i++) {
        XNRShopCarSectionModel *sectionModel = _dataArr[i];
        for (XNRShoppingCartModel *cellModel in sectionModel.goodsList) {
            if (cellModel.selectState) {
        
                NSDictionary *params = @{@"productId":cellModel.goodsId,@"count":cellModel.num};
                [arr addObject:params];
                NSDictionary *idParams = @{@"id":cellModel.goodsId,@"count":cellModel.num};
                [idArr addObject:idParams];
            }
        }
    }
    vc.dataArray = arr;
    vc.idArray = idArr;
    vc.totalPrice = _totalPrice;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取数据从网络
- (void)getDataFromNetwork {
    //网络请求成功先删除数据
    [_dataArr removeAllObjects];
    //改变底部
    [self changeBottom];
    
    [self.shoppingCarTableView reloadData];
    
    [KSHttpRequest post:KGetShopCartList parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            //网络请求成功先删除数据
            [_dataArr removeAllObjects];
            
            NSDictionary *datasDic = result[@"datas"];
            _shoppingCarID = datasDic[@"shopCartId"];
            NSArray *rowsArr = datasDic[@"rows"];
            
            for (NSDictionary *subDic in rowsArr) {
                XNRShopCarSectionModel *sectionModel = [[XNRShopCarSectionModel alloc] init];
                sectionModel.brandName = subDic[@"brandName"];
                sectionModel.goodsList = (NSMutableArray *)[XNRShoppingCartModel objectArrayWithKeyValuesArray:subDic[@"goodsList"]];
                [_dataArr addObject:sectionModel];
                
                for (int i = 0; i<sectionModel.goodsList.count; i++) {
                    XNRShoppingCartModel *model = sectionModel.goodsList[i];
                    model.num = model.goodsCount;
                }
                
                NSLog(@"%@",sectionModel.goodsList);
            }
            // 改变底部
            [self changeBottom];
            
            [self.shoppingCarTableView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:result[@"message"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
        }
        
        if (_dataArr.count == 0) {
            [self.shopCarView show];
            self.editeBtn.hidden = YES;
            self.navigationItem.title = @"购物车";

        }else{
            [self.shopCarView removeFromSuperview];
        }
        [self.shoppingCarTableView.header endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"购物车列表获取失败"];
        [self.shoppingCarTableView.header endRefreshing];

    }];
}

#pragma mark - 获取数据从数据库(只需要从数据库拿到商品的ID和商品的数量)
- (void)getDataFromDatabase {
    [self.shopCarView show];

    DatabaseManager *manager = [DatabaseManager sharedInstance];
    //获取所有购物车数据(存的时候已经去重)
    NSArray *allGoodArr = [manager queryAllGood];
    // 如果购物车为空
    if (allGoodArr.count == 0) {
        self.navigationItem.title = @"购物车";
        self.editeBtn.hidden = YES;
    }
    // 存放商品ID和数量
    NSMutableArray *tempMarr = [[NSMutableArray alloc]init];
    for (int i=0; i<allGoodArr.count; i++) {
        XNRShoppingCartModel *model = allGoodArr[i];
        NSDictionary *params = @{@"productId":model.goodsId,@"count":model.num};
        [tempMarr addObject:params];
        [KSHttpRequest post:KGetShoppingCartOffline parameters:@{@"products":[tempMarr JSONString_Ext]} success:^(id result) {
            NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
            if ([result[@"code"] integerValue] == 1000)  {
                NSDictionary *datas = result[@"datas"];
                NSArray *rows = datas[@"rows"];
                for (NSDictionary *subDic in rows) {
                    XNRShopCarSectionModel *sectionModel = [[XNRShopCarSectionModel alloc] init];
                    sectionModel.brandName = subDic[@"brandName"];
                    sectionModel.goodsList = (NSMutableArray *)[XNRShoppingCartModel objectArrayWithKeyValuesArray:subDic[@"goodsList"]];
                    [goodsArray addObject:sectionModel];
                    
                    // 数组去重
                    NSSet *set = [NSSet setWithArray:goodsArray];
                    _dataArr = [[set allObjects] mutableCopy];
                    
                    for (int i = 0; i<sectionModel.goodsList.count; i++) {
                        XNRShoppingCartModel *model = sectionModel.goodsList[i];
                        model.num = model.goodsCount;
                    }

                    if (_dataArr.count == 0) {
                        [self.shopCarView show];
                        self.editeBtn.hidden = YES;
                        self.navigationItem.title = @"购物车";
                        
                    }else{
                        [self.shopCarView removeFromSuperview];
                    }
            }
                [self.shoppingCarTableView reloadData];
                [self changeBottom];
        }
        } failure:^(NSError *error) {
            
        }];
    }
    
    //数组去重
//    NSSet *set = [NSSet setWithArray:tempMarr];
//    _brandNameArr = [[set allObjects] mutableCopy];
    
//    for (int i = 0; i<_brandNameArr.count; i++) {
//        NSArray *arr = [manager queryTypeGoodWithBrandName:_brandNameArr[i]];
//        
//        XNRShopCarSectionModel *sectionModel = [[XNRShopCarSectionModel alloc] init];
//        
//        for (XNRShoppingCartModel *carModel in arr) {
//            sectionModel.brandName = _brandNameArr[i];
//            [sectionModel.goodsList addObject:carModel];
//        }
//        
//        [_dataArr addObject:sectionModel];
//    }
    
}
#pragma mark - 创建购物车
- (void)createShoppingCarTableView
{
    UITableView *shoppingCarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(88)) style:UITableViewStyleGrouped];
    shoppingCarTableView.backgroundColor = [UIColor clearColor];
    shoppingCarTableView.showsVerticalScrollIndicator = YES;
    shoppingCarTableView.delegate = self;
    shoppingCarTableView.dataSource = self;
    shoppingCarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shoppingCarTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];  //添加尾部视图防止遮挡无法点击
    self.shoppingCarTableView = shoppingCarTableView;
    [self.view addSubview:shoppingCarTableView];
    
}

#pragma mark - tableView代理方法

// 在段头添加任意的视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArr.count > 0) {
        XNRShopCarSectionModel *sectionModel = _dataArr[section];
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
        headView.backgroundColor = [UIColor whiteColor];
        self.headView = headView;
        [self.view addSubview:headView];
        
        UIButton *selectedHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedHeadBtn.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(36), PX_TO_PT(36));
        [selectedHeadBtn setImage:[UIImage imageNamed:@"shopCar_circle"] forState:UIControlStateNormal];
        [selectedHeadBtn setImage:[UIImage imageNamed:@"shopcar_right"] forState:UIControlStateSelected];
        selectedHeadBtn.tag = section+1010;
        [selectedHeadBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectedHeadBtn.selected = sectionModel.isSelected;
        self.selectedHeadBtn = selectedHeadBtn;
        [headView addSubview:selectedHeadBtn];
        
        UIImageView *shopcarImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectedHeadBtn.frame) + PX_TO_PT(20), PX_TO_PT(26), PX_TO_PT(36), PX_TO_PT(36))];
        [shopcarImage setImage:[UIImage imageNamed:@"shopcar_icon"]];
        [headView addSubview:shopcarImage];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopcarImage.frame) + PX_TO_PT(24), PX_TO_PT(28), ScreenWidth, PX_TO_PT(32))];
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
#pragma mark - headView的Button的选中
-(void)selectedBtnClick:(UIButton *)sender{
    
    XNRShopCarSectionModel *sectionModel = _dataArr[sender.tag-1010];
    
    sectionModel.isSelected = !sectionModel.isSelected;
    
    for (XNRShoppingCartModel *shopCarModel in sectionModel.goodsList) {
        shopCarModel.selectState = sectionModel.isSelected;
    }
    
    [self.shoppingCarTableView reloadData];
    
    [self valiteAllCarShopModelIsSelected];
    [self changeBottom];


}
#pragma mark - 计算价格
-(void)changeBottom {
    NSInteger goodsNum = 0;
    NSInteger goodsNumSelected = 0;
    _totalPrice = 0;
    // 遍历整个数据源，然后判断如果是选中的商品，就计算价格
    for (int i = 0; i<_dataArr.count; i++) {
        XNRShopCarSectionModel *sectionModel = _dataArr[i];
        for (int j = 0; j<sectionModel.goodsList.count; j++) {
            XNRShoppingCartModel *model = sectionModel.goodsList[j];
            goodsNum = goodsNum + model.num.integerValue;
            if (model.selectState) {
                // 合计xxxx
                if (model.deposit && [model.deposit floatValue] > 0) {
                    _totalPrice = _totalPrice + model.num.intValue*[[NSString stringWithFormat:@"%@",model.deposit] floatValue];
                }else{
                    _totalPrice = _totalPrice + model.num.intValue*[[NSString stringWithFormat:@"%@",model.unitPrice] floatValue];
                }
                NSLog(@"totalPriceg === %.2f",_totalPrice);
                goodsNumSelected = goodsNumSelected + model.num.integerValue;
                
                [self.shoppingCarTableView reloadData];
                
            } else {
                
            }
            self.navigationItem.title = [NSString stringWithFormat:@"购物车(%ld)",(long)goodsNum];

            
            

        }
    }
    
    [_settlementBtn setTitle:[NSString stringWithFormat:@"去结算%@",(long)goodsNumSelected==0?@"":[NSString stringWithFormat:@"(%ld)",(long)goodsNumSelected]] forState:UIControlStateNormal];
    
    [_deleteBtn setTitle:[NSString stringWithFormat:@"删除%@",(long)goodsNumSelected==0?@"":[NSString stringWithFormat:@"(%ld)",(long)goodsNumSelected]] forState:UIControlStateNormal];
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"合计: ￥%.2f",_totalPrice];
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:_totalPriceLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:18]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
    
    [_totalPriceLabel setAttributedText:AttributedStringDeposit];
    
//    //每次算完要重置为0，因为每次的都是全部循环算一遍
    
    if (_dataArr.count == 0) {
        _settlementBtn.enabled = YES;

    }else{
        self.editeBtn.hidden = NO;
        
        _settlementBtn.enabled = YES;

        _deleteBtn.enabled = YES;
    }

}

#pragma mark  - TableViewDelegate

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
     return _dataArr.count;
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

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_dataArr.count>0) {
        XNRShopCarSectionModel *sectionModel = _dataArr[indexPath.section];
        XNRShoppingCartModel *model = sectionModel.goodsList[indexPath.row];
        
        if ([model.deposit floatValue] == 0.00) {
            return PX_TO_PT(300);
        }else{
            return PX_TO_PT(460);
        }
    }else{
        return 0;
    }
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArr.count > 0) {
        
        XNRProductInfo_VC *info_VC = [[XNRProductInfo_VC alloc] init];
        info_VC.hidesBottomBarWhenPushed = YES;
        XNRShopCarSectionModel *sectionModel = _dataArr[indexPath.section];
        XNRShoppingCartModel *model = sectionModel.goodsList[indexPath.row];
        info_VC.model = model;
        [self.navigationController pushViewController:info_VC animated:YES];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    XNRShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        //单元格复用cellID要一致
        cell = [[XNRShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID andCom:^(NSIndexPath *indexPath) {
            
            XNRShopCarSectionModel *sectionModel = _dataArr[indexPath.section];
            XNRShoppingCartModel *cellModel = sectionModel.goodsList[indexPath.row];
            BOOL isAll = YES;
            for (XNRShoppingCartModel *carModel in sectionModel.goodsList) {
                isAll = isAll && carModel.selectState;
            }
            
            if (isAll) {
                sectionModel.isSelected = cellModel.selectState;
            } else {
                sectionModel.isSelected = NO;
                self.selectedBottomBtn.selected = NO;
            }
            
            [self.shoppingCarTableView reloadData];
            [self changeBottom];
            
            [self valiteAllCarShopModelIsSelected];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.changeBottomBlock = ^{
            [self changeBottom];
        };
        
        
    }
    
    
    if (_dataArr.count > 0) {
        cell.indexPath = indexPath;
        XNRShopCarSectionModel *sectionModle = _dataArr[indexPath.section];
        if (sectionModle.goodsList.count > 0) {
            XNRShoppingCartModel *model = sectionModle.goodsList[indexPath.row];
            //传递数据模型model
            [cell setCellDataWithShoppingCartModel:model];
        }
    }
    return cell;
}
#pragma mark  - 购物车商品全部选中
- (void)valiteAllCarShopModelIsSelected {
    BOOL isAllAll = YES;
    for (XNRShopCarSectionModel *sectionModel in _dataArr) {
        isAllAll = isAllAll && sectionModel.isSelected;
    }
    
    self.selectedBottomBtn.selected = isAllAll;
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
