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
#import "XNRProductInfo_VC.h"
#import "MJExtension.h"
#import "XNRShoppingCarFrame.h"

#import "XNRSKUAttributesModel.h"

@interface XNRShoppingCarController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,XNRShopcarViewBtnDelegate,XNRShoppingCartTableViewCellDelegate,UITextFieldDelegate>
{
    NSMutableArray *_MapOfAllStateArr;
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
    int currentPage;
    NSInteger _totalSelectNum;
}
@property (nonatomic,strong) UIView *bottomView; // 底部视图

@property (nonatomic,weak) UITableView *shoppingCarTableView;//购物车

@property (nonatomic, weak) XNRShopcarView *shopCarView;// 购物车为空时的图片

@property (nonatomic ,weak) UIView *headView; // 头部品牌视图

@property (nonatomic ,weak) UIButton *editeBtn;

@property (nonatomic ,weak) UIButton *selectedBottomBtn;

@property (nonatomic ,weak) UIButton *selectedHeadBtn;

@property (nonatomic ,weak) UITextField *numTextField;

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
    // 把选中的商品状态清空
    [_MapOfAllStateArr removeAllObjects];
    
    if (IS_Login) {// 已登录
        // 获取数据从网络
        [self getDataFromNetwork];
        [self changeBottom];
        [self setupShopCarOnLineRefresh];

    }else{// 未登录
        [_dataArr removeAllObjects];
        // 获取数据从本地数据库
        [self getDataFromDatabase];
        [self setupShopCarOfflineRefresh];
//        [self.shoppingCarTableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataArr = [[NSMutableArray alloc]init];
    _brandNameArr = [[NSMutableArray alloc] init];
    _modifyDataArr = [[NSMutableArray alloc] init];
    _MapOfAllStateArr = [NSMutableArray array];
    
    
    //创建订单
    [self createShoppingCarTableView];
    //创建底部视图
    [self createBottomView];
    // 创建导航栏
    [self createNavgation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"refreshTableView" object:nil];
    
}

-(void)refreshTableView
{
    [self.shoppingCarTableView reloadData];
}

#pragma mark - 刷新
-(void)setupShopCarOnLineRefresh{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headOnLineRefresh)];
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
    
    self.shoppingCarTableView.mj_header = header;
}

-(void)setupShopCarOfflineRefresh{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headOfflineRefresh)];
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
    
    self.shoppingCarTableView.mj_header = header;
}


-(void)headOnLineRefresh{
    currentPage = 1;
    [_dataArr removeAllObjects];
    [self getDataFromNetwork];
}

-(void)headOfflineRefresh
{
    currentPage = 1;
    [self getDataFromDatabase];
}

- (void)XNRShoppingCartTableViewCellBtnClickWith:(UITextField *)numTextField {
    
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
    if (sort) {// 完成
        [self.editeBtn setTitle:@"完成" forState:UIControlStateNormal];
        _totalPriceLabel.hidden  = YES;
        _settlementBtn.hidden = YES;
        _deleteBtn.hidden = NO;
        // 回到正常状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelBtnPresent" object:nil];

    }else{// 编辑
        [self.editeBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _totalPriceLabel.hidden  = NO;
        _settlementBtn.hidden = NO;
        _deleteBtn.hidden = YES;
        // 下架商品变成可删除的状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"normalBtnPresent" object:nil];


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
    [selectedBottomBtn setImage:[UIImage imageNamed:@"orange-icon"] forState:UIControlStateSelected];
    [selectedBottomBtn addTarget: self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedBottomBtn = selectedBottomBtn;
    [_bottomView addSubview:selectedBottomBtn];
    
    UILabel *allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectedBottomBtn.frame) + PX_TO_PT(20), PX_TO_PT(28), ScreenWidth/2, PX_TO_PT(32))];
    allSelectLabel.text = @"全选";
    allSelectLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    allSelectLabel.textAlignment = NSTextAlignmentLeft;
    allSelectLabel.textColor = R_G_B_16(0x323232);
    [_bottomView addSubview:allSelectLabel];
    
    _totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth-PX_TO_PT(220)-PX_TO_PT(20), PX_TO_PT(88))];
    _totalPriceLabel.textColor = R_G_B_16(0x323232);
    _totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    _totalPriceLabel.adjustsFontSizeToFitWidth = YES;
    [_bottomView addSubview:_totalPriceLabel];
    
    _settlementBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(220), 0, PX_TO_PT(220), PX_TO_PT(88)) ImageName:nil Target:self Action:@selector(settlementBtnClick:) Title:nil];
    _settlementBtn.backgroundColor = R_G_B_16(0xfe9b00);
    _settlementBtn.enabled = NO;
    [_settlementBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [_settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settlementBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [_bottomView addSubview:_settlementBtn];
    
    _deleteBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(220), 0, PX_TO_PT(220), PX_TO_PT(88)) ImageName:nil Target:self Action:@selector(deleteBtnClick:) Title:nil];
    _deleteBtn.backgroundColor = R_G_B_16(0xfe9b00);
    _deleteBtn.enabled = NO;
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
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
        for (XNRShoppingCarFrame *shopCar in sectionModel.SKUFrameList) {
            shopCar.shoppingCarModel.selectState = sender.selected;
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
            
            [UILabel showMessage:@"请至少选择一件商品"];
         
        }else{// 打开订单信息页
            
        [self openOrder];
        }
    }else{ // 未登录
        //登录警告视图
        BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"您还没有登录，是否登录?" chooseBtns:@[@"取消",@"确定"]];
        
        alertView.chooseBlock = ^void(UIButton *btn){
            
            if (btn.tag == 11) {
                
                XNRLoginViewController *login = [[XNRLoginViewController alloc]init];
                login.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:login animated:YES];
                
            }
            
        };
        
        [alertView BMAlertShow];

    }
}

#pragma mark - 删除
-(void)deleteBtnClick:(UIButton *)button{
    
    BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"确认要删除该商品吗?" chooseBtns:@[@"取消",@"确定"]];
    
    alertView.chooseBlock = ^void(UIButton *btn){
        
        if (btn.tag == 11) {
            
            NSMutableArray *arr1 = [NSMutableArray array];
            NSMutableArray *arr2 = [NSMutableArray array];
            
            //1.先删除购物车 中的数据 并且用arr1、arr2记录要删除的数据
            for (XNRShopCarSectionModel *sectionModel in _dataArr) {
                
                if (sectionModel.isSelected) {
                    if (!IS_Login) { //未登录时 把数据库这条数据删除
                        for (XNRShoppingCarFrame *carModel in sectionModel.SKUFrameList) {
                            DatabaseManager *manager = [DatabaseManager sharedInstance];
                            [manager deleteShoppingCarWithModel:carModel.shoppingCarModel];
                        }
                    } else { //TODO:服务器调用接口 让服务器把这条数据删除
                        for (XNRShoppingCarFrame *carModel in sectionModel.SKUFrameList) {
                    NSDictionary *params1 = @{@"userId":[DataCenter account].userid,@"SKUId":carModel.shoppingCarModel._id,@"quantity":@"0",@"additions":carModel.shoppingCarModel.additions,@"user-agent":@"IOS-v2.0"};
                            [KSHttpRequest post:KchangeShopCarNum parameters:params1 success:^(id result) {
                                if ([result[@"code"] integerValue] == 1000) {
                                    [UILabel showMessage:@"删除成功"];
                                }
                            } failure:^(NSError *error) {
                                
                            }];
                        }
                    }
                    
                    [arr1 addObject:sectionModel];
                    
                } else {
                    for (XNRShoppingCarFrame *model in sectionModel.SKUFrameList) {
                        if (model.shoppingCarModel.selectState) {
                            if (!IS_Login) {//未登录时 把数据库这条数据删除
                                DatabaseManager *manager = [DatabaseManager sharedInstance];
                                [manager deleteShoppingCarWithModel:model.shoppingCarModel];
                            } else {
                                //TODO:服务器调用接口 让服务器把这条数据删除
                                NSDictionary *params2 = @{@"userId":[DataCenter account].userid,@"SKUId":model.shoppingCarModel._id,@"quantity":@"0",@"additions":model.shoppingCarModel.additions,@"user-agent":@"IOS-v2.0"};
                                [KSHttpRequest post:KchangeShopCarNum parameters:params2 success:^(id result) {
                                    if ([result[@"code"] integerValue] == 1000) {
                                        [UILabel showMessage:@"删除成功"];
                                    }
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
                for (XNRShoppingCarFrame *cellModel in arr2) {
                    [sectionModel.SKUFrameList removeObject:cellModel];

                }
                NSLog(@"sectionModel.SKUFrameList%tu",sectionModel.SKUFrameList.count);
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
        // 改变底部
        [self changeBottom];
        
    };
    
    [alertView BMAlertShow];

}

#pragma mark - 跳转订单信息页
- (void)openOrder {
    //这个地方做出修改界面逻辑错误先确认订单在提交支付
    XNROrderInfo_VC*vc=[[XNROrderInfo_VC alloc] init];
    vc.hidesBottomBarWhenPushed=YES;
    // 去结算
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    // 提交订单
    for (int i = 0; i<_dataArr.count; i++) {
        XNRShopCarSectionModel *sectionModel = _dataArr[i];
        for (XNRShoppingCarFrame *cellModel in sectionModel.SKUFrameList) {
            if (cellModel.shoppingCarModel.selectState && [cellModel.shoppingCarModel.online integerValue] == 1) {
                
                NSDictionary *params = @{@"_id":cellModel.shoppingCarModel._id,@"count":cellModel.shoppingCarModel.num,@"additions":cellModel.shoppingCarModel.additions};
                [arr addObject:params];

            }
        }
    }
    vc.dataArray = arr;
    vc.totalPrice = _totalPrice;
    vc.isRoot = YES;
    vc.totalSelectNum = _totalSelectNum;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取数据从网络
- (void)getDataFromNetwork {
    [_dataArr removeAllObjects];
    //改变底部
    [self changeBottom];
    [self.shoppingCarTableView reloadData];
    [KSHttpRequest get:KGetShopCartList parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            
            NSDictionary *datasDic = result[@"datas"];
            _shoppingCarID = datasDic[@"shopCartId"];
            NSArray *rowsArr = datasDic[@"rows"];
            for (NSDictionary *subDic in rowsArr) {
                
                XNRShopCarSectionModel *sectionModel = [[XNRShopCarSectionModel alloc] init];
                sectionModel.brandName = subDic[@"brandName"];
                sectionModel.SKUList = (NSMutableArray *)[XNRShoppingCartModel objectArrayWithKeyValuesArray:subDic[@"SKUList"]];
                [_dataArr addObject:sectionModel];
                
                for (int i = 0; i<sectionModel.SKUList.count; i++) {
                    XNRShoppingCartModel *model = sectionModel.SKUList[i];
                    XNRShoppingCarFrame *frameModel = [[XNRShoppingCarFrame alloc] init];
                    // 传递购物车模型数据
                    frameModel.shoppingCarModel = model;
                    
                    frameModel.shoppingCarModel.num = frameModel.shoppingCarModel.count;
                    [sectionModel.SKUFrameList addObject:frameModel];
                    
                    NSLog(@"++_)_%@",sectionModel.SKUFrameList);

                    
                }
                
                NSLog(@"%@",sectionModel.SKUList);
            }
            
            [self getInitialAllNewData];
            // 改变底部
            [self changeBottom];
            [self.shoppingCarTableView reloadData];
        }else{
            
//            [UILabel showMessage:result[@"message"]];
            
        }
        
        if (_dataArr.count == 0) {
            [self.shopCarView show];
            self.editeBtn.hidden = YES;
            self.navigationItem.title = @"购物车";
        }else{
            [self.shopCarView removeFromSuperview];
        }
        [self.shoppingCarTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.shoppingCarTableView.mj_header endRefreshing];

        [UILabel showMessage:@"购物车列表获取失败"];

    }];
}

#pragma mark - 获取数据从数据库(只需要从数据库拿到商品的ID和商品的数量)
- (void)getDataFromDatabase {
    [self.shopCarView show];
    DatabaseManager *dbManager = [DatabaseManager sharedInstance];
    //获取所有购物车数据(存的时候已经去重)
    NSArray *allGoodArr = [dbManager queryAllGood];
    // 如果购物车为空
    if (allGoodArr.count == 0) {
        self.navigationItem.title = @"购物车";
        self.editeBtn.hidden = YES;
    }
    // 取出商品的skuid和数量
    NSMutableArray *tempMarr = [[NSMutableArray alloc]init];
    for (int i=0; i<allGoodArr.count; i++) {
        XNRShoppingCartModel *model = allGoodArr[i];
        NSDictionary *params = @{@"_id":model._id,@"count":model.num?model.num:@"1",@"additions":model.additions};
        NSLog(@"898990======%@",params);
        [tempMarr addObject:params];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:KGetShoppingCartOffline parameters:@{@"SKUs":tempMarr,@"user-agent":@"IOS-v2.0"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"---------返回数据:---------%@",str);
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
        if ([resultObj[@"code"] integerValue] == 1000) {
            NSDictionary *datas = resultObj[@"datas"];
            NSArray *rows = datas[@"rows"];
            for (NSDictionary *subDic in rows) {
                XNRShopCarSectionModel *sectionModel = [[XNRShopCarSectionModel alloc] init];
                sectionModel.brandName = subDic[@"brandName"];
                sectionModel.SKUList = (NSMutableArray *)[XNRShoppingCartModel objectArrayWithKeyValuesArray:subDic[@"SKUList"]];
                [goodsArray addObject:sectionModel];
                
                // 数组去重
                NSSet *set = [NSSet setWithArray:goodsArray];
                _dataArr = [[set allObjects] mutableCopy];

                for (int i = 0; i<sectionModel.SKUList.count; i++) {
                    XNRShoppingCartModel *model = sectionModel.SKUList[i];
                    XNRShoppingCarFrame *frameModel = [[XNRShoppingCarFrame alloc] init];
                    frameModel.shoppingCarModel = model;
                    frameModel.shoppingCarModel.num = frameModel.shoppingCarModel.count;
                    [sectionModel.SKUFrameList addObject:frameModel];
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
        [self.shoppingCarTableView.mj_header endRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];
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
        [selectedHeadBtn setImage:[UIImage imageNamed:@"orange-icon"] forState:UIControlStateSelected];
        selectedHeadBtn.tag = section+1010;
        [selectedHeadBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectedHeadBtn.selected = sectionModel.isSelected;
        self.selectedHeadBtn = selectedHeadBtn;
        [headView addSubview:selectedHeadBtn];
        // 已下架的商品selectedHeadBtn隐藏
        for (int i = 0; i<sectionModel.SKUList.count; i++) {
            XNRShoppingCartModel *model = sectionModel.SKUList[i];
            if ([model.online integerValue] == 1 && [model.online integerValue] == 0) {
                selectedHeadBtn.hidden = NO;
            }else if([model.online integerValue] == 1){// 非下架
                selectedHeadBtn.hidden = NO;
            }else if([model.online integerValue] == 0){// 下架
                selectedHeadBtn.hidden = YES;
            }
        }
       
        UIImageView *shopcarImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectedHeadBtn.frame) + PX_TO_PT(20), PX_TO_PT(26), PX_TO_PT(36), PX_TO_PT(36))];
        [shopcarImage setImage:[UIImage imageNamed:@"shopcar_icon"]];
        [headView addSubview:shopcarImage];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopcarImage.frame) + PX_TO_PT(24), PX_TO_PT(28), ScreenWidth, PX_TO_PT(32))];
        label.text = sectionModel.brandName;
        label.textColor = R_G_B_16(0x323232);
        label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
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
    
    for (XNRShoppingCarFrame *shopCarModel in sectionModel.SKUFrameList) {
        shopCarModel.shoppingCarModel.selectState = sectionModel.isSelected;
    }
    
    [self.shoppingCarTableView reloadData];
    // section商品全部选中
    [self valiteAllCarShopModelIsSelected];
    
    [self changeBottom];
    [self recordSelectedShopGoods];
    
}
#pragma mark - 计算价格
-(void)changeBottom {
    NSInteger goodsNum = 0;
    NSInteger goodsNumSelected = 0;
    _totalPrice = 0;
    // 遍历整个数据源，然后判断如果是选中的商品，就计算价格
    for (int i = 0; i<_dataArr.count; i++) {
        XNRShopCarSectionModel *sectionModel = _dataArr[i];
        for (int j = 0; j<sectionModel.SKUFrameList.count; j++) {
            XNRShoppingCarFrame *model = sectionModel.SKUFrameList[j];
            if (model.shoppingCarModel.num != nil) {
                goodsNum = goodsNum + model.shoppingCarModel.num.integerValue;
            }
            if (model.shoppingCarModel.selectState&&[model.shoppingCarModel.online integerValue]==1) {
                // 合计xxxx
                if (model.shoppingCarModel.deposit && [model.shoppingCarModel.deposit floatValue] > 0) {
                    _totalPrice = _totalPrice + model.shoppingCarModel.num.intValue*[[NSString stringWithFormat:@"%@",model.shoppingCarModel.deposit] floatValue];
                }else{
                    _totalPrice = _totalPrice + model.shoppingCarModel.num.intValue*[[NSString stringWithFormat:@"%@",model.shoppingCarModel.price] floatValue];
                }
                NSLog(@"totalPriceg === %.2f",_totalPrice);
                goodsNumSelected = goodsNumSelected + model.shoppingCarModel.num.integerValue;
                _totalSelectNum = goodsNumSelected;
                [self.shoppingCarTableView reloadData];
                
            } else {
                
        }
            // 购物车的总数
            self.navigationItem.title = [NSString stringWithFormat:@"购物车(%ld)",(long)goodsNum];
        }
    }
    
    [_settlementBtn setTitle:[NSString stringWithFormat:@"去结算%@",(long)goodsNumSelected==0?@"":[NSString stringWithFormat:@"(%ld)",(long)goodsNumSelected]] forState:UIControlStateNormal];
    
    [_deleteBtn setTitle:[NSString stringWithFormat:@"删除%@",(long)goodsNumSelected==0?@"":[NSString stringWithFormat:@"(%ld)",(long)goodsNumSelected]] forState:UIControlStateNormal];
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"合计: ￥%.2f",_totalPrice];
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:_totalPriceLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(36)]
                               
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
        return sectionModel.SKUFrameList.count;
    } else {
        return 0;
  }
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArr.count>0) {
        XNRShopCarSectionModel *sectionModel = _dataArr[indexPath.section];
        XNRShoppingCarFrame *frameModel = sectionModel.SKUFrameList[indexPath.row];
        NSLog(@"frame.cellHeight==%.2f",frameModel.cellHeight);
        return frameModel.cellHeight;
        
    }else{
        return 0;
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
            XNRShoppingCarFrame *cellModel = sectionModel.SKUFrameList[indexPath.row];
            
            BOOL isAll = YES;
            for (XNRShoppingCarFrame *carModel in sectionModel.SKUFrameList) {
                isAll = isAll && carModel.shoppingCarModel.selectState;
            }
            
            if (isAll) {
                sectionModel.isSelected = cellModel.shoppingCarModel.selectState;
            } else {
                sectionModel.isSelected = NO;
                self.selectedBottomBtn.selected = NO;
            }
            
            [self.shoppingCarTableView reloadData];
            [self changeBottom];
            
            [self valiteAllCarShopModelIsSelected];
            [self recordSelectedShopGoods];
        }];
        // 自定义跳转
        cell.pushBlock = ^(NSIndexPath *indexP){
            if (_dataArr.count > 0) {
                
                XNRProductInfo_VC *info_VC = [[XNRProductInfo_VC alloc] init];
                info_VC.hidesBottomBarWhenPushed = YES;
                XNRShopCarSectionModel *sectionModel = _dataArr[indexP.section];
                XNRShoppingCartModel *model = sectionModel.SKUList[indexP.row];
                info_VC.model = model;
                NSLog(@"model.goodIdmodel===%@",model);
                NSLog(@"----+++__+%@",indexP);
                
                info_VC.isFrom = YES;
                [self.navigationController pushViewController:info_VC animated:YES];
                
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        cell.changeBottomBlock = ^{
            [self changeBottom];
        };
    }
    
    
    if (_dataArr.count > 0) {
        cell.indexPath = indexPath;
        XNRShopCarSectionModel *sectionModle = _dataArr[indexPath.section];
        if (sectionModle.SKUFrameList.count > 0) {
            XNRShoppingCarFrame *frame = sectionModle.SKUFrameList[indexPath.row];
            //传递数据模型model
            cell.shoppingCarFrame = frame;
//            [cell setCellDataWithShoppingCartModel:model];
        }
    }
    return cell;
}
#pragma mark  - 购物车商品全部选中
- (void)valiteAllCarShopModelIsSelected {
    BOOL isAllAll = YES;
    for (XNRShopCarSectionModel *sectionModel in _dataArr) {
        for (XNRShoppingCarFrame *model in sectionModel.SKUFrameList) {
            isAllAll = isAllAll && sectionModel.isSelected && ([model.shoppingCarModel.online integerValue]==1);
        }
        
    }
    self.selectedBottomBtn.selected = isAllAll;
}

#pragma mark - 记录选中的商品的唯一标示 取消选中的就删除 -
- (void)recordSelectedShopGoods {
    for (XNRShopCarSectionModel *sectionModel in _dataArr) {
        for (XNRShoppingCarFrame *carModel in sectionModel.SKUFrameList) {
            
            if (carModel.shoppingCarModel.selectState&&![_MapOfAllStateArr containsObject:carModel.shoppingCarModel._id]) {
                NSLog(@"++++++选中:%@",carModel.shoppingCarModel._id);
                [_MapOfAllStateArr addObject:carModel.shoppingCarModel._id];
            } else if(!carModel.shoppingCarModel.selectState) {
                NSLog(@"------取消选中:%@",carModel.shoppingCarModel._id);
                [_MapOfAllStateArr removeObject:carModel.shoppingCarModel._id];
            }
            
//            if ([_MapOfAllStateArr containsObject:carModel._id]&&!carModel.selectState) {
//                [_MapOfAllStateArr removeObject:carModel._id];
//            }
//            
//            if (carModel.selectState) {
//                [_MapOfAllStateArr addObject:carModel._id];
//            }
        }
    }
    

}
//得到经过记录选中选项数据_map 初始化的所有刷新后的数据
- (void)getInitialAllNewData {
    
    for (XNRShopCarSectionModel *sectionModel in _dataArr) {
        for (XNRShoppingCarFrame *carModel in sectionModel.SKUFrameList) {
            for (NSString *dataId in _MapOfAllStateArr) {
                if ([dataId isEqualToString:carModel.shoppingCarModel._id]) {
                    carModel.shoppingCarModel.selectState = YES;
                }
            }
        }
    }
    
    for (XNRShopCarSectionModel *sectionModel in _dataArr) {
        BOOL isAll = YES;
        for (XNRShoppingCarFrame *cellModel in sectionModel.SKUFrameList) {
            
            isAll = isAll && cellModel.shoppingCarModel.selectState;
            if (isAll) {
                sectionModel.isSelected = cellModel.shoppingCarModel.selectState;
            } else {
                sectionModel.isSelected = NO;
                self.selectedBottomBtn.selected = NO;
            }
            
            [self.shoppingCarTableView reloadData];
            [self changeBottom];
            
            [self valiteAllCarShopModelIsSelected];
        }
    }

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
