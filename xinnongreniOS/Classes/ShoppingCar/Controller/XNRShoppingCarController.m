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

@interface XNRShoppingCarController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,XNRShopcarViewBtnDelegate,XNRShoppingCartTableViewCellDelegate>
{
    NSMutableArray *_dataArr;    //购物车数据
    NSMutableArray *_brandNameArr;//品牌名字数组
    NSMutableArray *_cellModelArr;
    UIButton *_settlementBtn;   //去结算
    UIButton *_deleteBtn;       // 删除
    UILabel *_totalPriceLabel;  //总价
    CGFloat _totalPrice;      //总价
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
    if (IS_Login) {// 已登录
        // 获取数据从网络
        [self getDataFromNetwork];

//        __weak __typeof(&*self)weakSelf = self;
//
//        [self.shoppingCarTableView addLegendHeaderWithRefreshingBlock:^{
//            [weakSelf getDataFromNetwork];
//        }];
        
    }else{// 未登录
        [_dataArr removeAllObjects];
        [_brandNameArr removeAllObjects];
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
    _brandNameArr = [[NSMutableArray alloc]init];
    _modifyDataArr = [[NSMutableArray alloc] init];
    _cellModelArr = [[NSMutableArray alloc] init];
    
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
//    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame=CGRectMake(0, 0, 80, 44);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
//    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchDown];
//    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
//    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem=leftItem;
    
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
    
    
    
    _totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(440), 0, PX_TO_PT(220), PX_TO_PT(88))];
    _totalPriceLabel.textColor = R_G_B_16(0x323232);
    _totalPriceLabel.font = XNRFont(14);
    _totalPriceLabel.adjustsFontSizeToFitWidth = YES;
    [_bottomView addSubview:_totalPriceLabel];
    
    _settlementBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(220), 0, PX_TO_PT(220), PX_TO_PT(88)) ImageName:nil Target:self Action:@selector(settlementBtnClick:) Title:nil];
    _settlementBtn.backgroundColor = [UIColor lightGrayColor];
    _settlementBtn.enabled = NO;
    [_settlementBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [_settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settlementBtn.titleLabel.font = XNRFont(14);
    [_bottomView addSubview:_settlementBtn];
    
    _deleteBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(220), 0, PX_TO_PT(220), PX_TO_PT(88)) ImageName:nil Target:self Action:@selector(deleteBtnClick:) Title:nil];
    _deleteBtn.backgroundColor = [UIColor lightGrayColor];
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

#pragma mark -  代理
-(void)XNRShoppingCartTableViewCellBtnClick
{
    for (int i = 0; i<_dataArr.count; i++) {
        NSMutableArray *modelArr = _dataArr[i];
        for (int j = 0; j<modelArr.count; j++) {
            XNRShoppingCartModel *model = modelArr[j];
            if (model.selectState) {
                model.selectState = NO;
            }else{
                model.selectState = YES;
            }
            [self.shoppingCarTableView reloadData];
            [self changeBottom];
        }
    }
//    XNRShoppingCartModel *model = _dataArr[indexPath.section][indexPath.row];
//    if (model.selectState) {
//        model.selectState = NO;
//    }else{
//        model.selectState = YES;
//    }
//    [self.shoppingCarTableView reloadData];
//    
//    [self.shoppingCarTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    [self changeBottom];
    

}

-(void)selectedClick:(UIButton *)sender{
    sender.tag = !sender.tag;
    if (sender.tag) {
        sender.selected = YES;
    }else{
        sender.selected = NO;
    }
    for (int i = 0; i<_dataArr.count; i++) {
        NSLog(@"=======+++++++%@",_dataArr);
        NSMutableArray *modelArray = _dataArr[i];
        for (int j = 0; j<modelArray.count; j++) {
            XNRShoppingCartModel *model = modelArray[j];
            model.selectState  = sender.tag;
            NSLog(@"=======+++++++%@",model);
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
  //打开订单信息页
    [self openOrder];
    }else{ // 未登录
        //登录警告视图
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"您尚未登录" message:@"请先前往登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert1 show];

    }
}

#pragma mark - 删除
-(void)deleteBtnClick:(UIButton *)button{


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
//#pragma mark - 改变底部视图
//- (void)changeBottom{
//    _totalPrice = 0;
//    for (int i = 0; i<_dataArr.count; i++) {
//        NSMutableArray *modelArr = _dataArr[i];
//        for (int j=0; j<modelArr.count; j++) {
//            XNRShoppingCartModel *model = modelArr[j];
//            
//        if ([model.deposit integerValue] == 0 || model.deposit == nil) {
//            _totalPrice = _totalPrice + model.num.intValue*[[NSString stringWithFormat:@"%.2f",model.unitPrice] floatValue];
//                }else{
//                    _totalPrice = _totalPrice + model.num.intValue*[[NSString stringWithFormat:@"%@",model.deposit] integerValue];
//                }
//        }
//    }
//    _totalPriceLabel.text = [NSString stringWithFormat:@"合计: ￥%.2f",_totalPrice];
//    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:_totalPriceLabel.text];
//    NSDictionary *depositStr=@{
//                               
//                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
//                               NSFontAttributeName:[UIFont systemFontOfSize:18]
//                               
//                               };
//    
//    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
//    
//    [_totalPriceLabel setAttributedText:AttributedStringDeposit];
//    
//    if (_totalPrice == 0) {
//        
//        [self.shopCarView show];
//        _settlementBtn.enabled = YES;
//        _settlementBtn.backgroundColor = [UIColor lightGrayColor];
//    }else{
//        [self.shopCarView removeFromSuperview];
//        self.editeBtn.hidden = NO;
//
//        _settlementBtn.enabled = YES;
//        _settlementBtn.backgroundColor = R_G_B_16(0xfe9b00);
//        
//        _deleteBtn.enabled = YES;
//        _deleteBtn.backgroundColor = R_G_B_16(0xfe9b00);
//    }
//}

#pragma mark - 获取数据从网络
- (void)getDataFromNetwork {
    //网络请求成功先删除数据
    [_dataArr removeAllObjects];
    [_brandNameArr removeAllObjects];
    //改变底部
    [self changeBottom];
    [self.shoppingCarTableView reloadData];
    
    [KSHttpRequest post:KGetShopCartList parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            //网络请求成功先删除数据
            [_dataArr removeAllObjects];
            [_brandNameArr removeAllObjects];
            
            NSDictionary *datasDic = result[@"datas"];
            
            _shoppingCarID = datasDic[@"shopCartId"];
            NSArray *rowsArr = datasDic[@"rows"];
            
            for (NSDictionary *subDic in rowsArr) {
                
                XNRShopCarSectionModel *cellModel = [[XNRShopCarSectionModel alloc] init];
                [cellModel setValuesForKeysWithDictionary:subDic];
                [_cellModelArr addObject:cellModel];
                
                NSArray *goodsListArr = subDic[@"goodsList"];
                NSMutableArray *tempSubDataArr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *subDic2 in goodsListArr) {
                    XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc]init];
                    [model setValuesForKeysWithDictionary:subDic2];
                    model.num = model.goodsCount;
                    [tempSubDataArr addObject:model];
                }
                [_brandNameArr addObject:subDic[@"brandName"]];
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
    _brandNameArr = [[set allObjects] mutableCopy];
    
    for (int i = 0; i<_brandNameArr.count; i++) {
        NSArray *arr = [manager queryTypeGoodWithBrandName:_brandNameArr[i]];
        [_dataArr addObject:arr];
    }
    
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
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
    headView.backgroundColor = [UIColor whiteColor];
    self.headView = headView;
    [self.view addSubview:headView];
    
    UIButton *selectedHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedHeadBtn.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(26), PX_TO_PT(36), PX_TO_PT(36));
    [selectedHeadBtn setImage:[UIImage imageNamed:@"shopCar_circle"] forState:UIControlStateNormal];
    [selectedHeadBtn setImage:[UIImage imageNamed:@"shopcar_right"] forState:UIControlStateSelected];
    [selectedHeadBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedHeadBtn = selectedHeadBtn;
    [headView addSubview:selectedHeadBtn];
    
    UIImageView *shopcarImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectedHeadBtn.frame) + PX_TO_PT(20), PX_TO_PT(26), PX_TO_PT(36), PX_TO_PT(36))];
    [shopcarImage setImage:[UIImage imageNamed:@"shopcar_icon"]];
    [headView addSubview:shopcarImage];

    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopcarImage.frame) + PX_TO_PT(24), PX_TO_PT(28), ScreenWidth, PX_TO_PT(32))];
    label.text = _brandNameArr[section];
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
}

-(void)selectedBtnClick:(UIButton *)sender{
        sender.tag = !sender.tag;
        if (sender.tag) {
            sender.selected = YES;
        }else{
            sender.selected = NO;
        }
    // 改变单元格选中状态
    for (int i = 0; i<_cellModelArr.count; i++) {
        NSLog(@"=————————————+++++++%@",_cellModelArr);
            XNRShopCarSectionModel *model = _cellModelArr[i];
            model.isSelected  = sender.tag;

        NSLog(@"=======+++++++%@",model);
        NSLog(@"+++++++_____%@",model.cellModelArray);

        }
    
    [self changeBottom];
//    [self.shoppingCarTableView reloadData];


}
#pragma mark - 计算价格
-(void)changeBottom{
    _totalPrice = 0;
    // 遍历整个数据源，然后判断如果是选中的商品，就计算价格
    for (int i = 0; i<_dataArr.count; i++) {
        NSMutableArray *modelArray = _dataArr[i];
        for (int j = 0; j<modelArray.count; j++) {
            XNRShoppingCartModel *model = modelArray[j];
            if (model.selectState) {
                // 合计
                if ([model.deposit integerValue] == 0) {
                    _totalPrice = _totalPrice + model.num.intValue*[[NSString stringWithFormat:@"%.2f",model.unitPrice] floatValue];
                }else{
                    _totalPrice = _totalPrice + model.num.intValue*[[NSString stringWithFormat:@"%@",model.deposit] integerValue];
                }

            }
        }
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"合计: ￥%.2f",_totalPrice];
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:_totalPriceLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                               NSFontAttributeName:[UIFont systemFontOfSize:18]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
    
    [_totalPriceLabel setAttributedText:AttributedStringDeposit];
    
    //每次算完要重置为0，因为每次的都是全部循环算一遍
    _totalPrice = 0.00;
    
    if (_dataArr.count == 0) {
        
        [self.shopCarView show];
        _settlementBtn.enabled = YES;
        _settlementBtn.backgroundColor = [UIColor lightGrayColor];
    }else{
        [self.shopCarView removeFromSuperview];
        self.editeBtn.hidden = NO;
        
        _settlementBtn.enabled = YES;
        _settlementBtn.backgroundColor = R_G_B_16(0xfe9b00);
        
        _deleteBtn.enabled = YES;
        _deleteBtn.backgroundColor = R_G_B_16(0xfe9b00);
    }


}

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
    NSMutableArray *arr = _dataArr[section];
    return arr.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_dataArr.count>0) {
        XNRShoppingCartModel *model = _dataArr[indexPath.section][indexPath.row];
        NSLog(@"=========%@",_dataArr);
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
    XNRProductInfo_VC *info_VC = [[XNRProductInfo_VC alloc] init];
    info_VC.hidesBottomBarWhenPushed = YES;
    XNRShoppingCartModel *model = _dataArr[indexPath.section][indexPath.row];
    info_VC.model = model;
    [self.navigationController pushViewController:info_VC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    XNRShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        //单元格复用cellID要一致
        cell = [[XNRShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.delegate = self;
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
            [_brandNameArr removeObjectAtIndex:indexPath.section];
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
