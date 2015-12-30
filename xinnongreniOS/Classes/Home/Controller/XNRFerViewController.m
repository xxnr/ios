//
//  XNRFerViewController.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/28.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRFerViewController.h"
#import "XNRferView.h"
#import "XNRSpecialCell.h"
#import "XNRProductInfo_VC.h"
#import "XNRTabBarController.h"
#import "XNRHomeSelectBrandView.h"
#import "MJRefresh.h"
#import "XNRNoSelectView.h"
#define MAX_PAGE_SIZE 10

@interface XNRFerViewController()<UITableViewDelegate,UITableViewDataSource,XNRferViewAddBtnDelegate>
{
    XNRferViewDoType _fertype;
    BOOL isSort;
    int currentPage;
    BOOL isCancel;
}

@property (nonatomic, weak) XNRferView *ferView;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *totalArray;

@property (nonatomic ,strong) NSMutableArray *ferArray;

@property (nonatomic ,strong) NSMutableArray *carArray;

@property (nonatomic, weak) UIButton *backtoTopBtn;

@property (nonatomic ,weak) XNRNoSelectView *noSelectView;

@property (nonatomic ,weak) BMProgressView *progressView;

@property (nonatomic ,copy) NSString *brandName;

@property (nonatomic ,copy) NSString *modelName;

@property (nonatomic ,copy) NSString *reservePrice;
@property (nonatomic, strong) NSArray *selectedItemArr;

@property (nonatomic ,weak) XNRHomeSelectBrandView *selectBrandView;

@end

@implementation XNRFerViewController

-(XNRHomeSelectBrandView *)selectBrandView{
    if (!_selectBrandView) {
        XNRHomeSelectBrandView *selectBrandView = [[XNRHomeSelectBrandView alloc] init];
        self.selectBrandView = selectBrandView;
        [self.view addSubview:selectBrandView];
        
    }
    return _selectBrandView;

}

-(BMProgressView *)progressView{
    if (!_progressView) {
        BMProgressView *progressView = [[BMProgressView alloc] init];
        self.progressView = progressView;
        [self.view addSubview:progressView];
    }
    return _progressView;
}
#pragma mark  - 筛选为空的视图
-(XNRNoSelectView *)noSelectView{

    if (!_noSelectView) {
        XNRNoSelectView *noSelectView = [[XNRNoSelectView alloc] init];
        self.noSelectView = noSelectView;
        [self.view addSubview:noSelectView];
    }
    return _noSelectView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNav];
    [self setupTopView];
    [self setupTableView];
    currentPage = 1;
    _totalArray = [NSMutableArray array];
    _ferArray  = [NSMutableArray array];
    _carArray = [NSMutableArray array];
    [self createbackBtn];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self getData];
    // 综合
    [self setupTotalRefresh];
    // 价格
    [self setuoPriceRefresh];
    // 筛选
    [self setuoSelectRefresh];

}
#pragma mark - 刷新
-(void)setupTotalRefresh{
    // 下拉刷新
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        currentPage = 1;
        [_totalArray removeAllObjects];
        [weakSelf getData];
    }];
    
    // 上拉加载
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        currentPage = currentPage + 1;
        [weakSelf getData];
    }];
}
-(void)setuoPriceRefresh{
    

}
-(void)setuoSelectRefresh{
    // 下拉刷新
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        currentPage = 1;
        [_carArray removeAllObjects];
        if ([_classId isEqualToString:XNRFER]) {
        [weakSelf getselectDataWithName:@"brandName" and:weakSelf.brandName and:weakSelf.reservePrice];
        }else{
        [weakSelf getselectDataWithName:@"modelName" and:weakSelf.modelName and:weakSelf.reservePrice];

        }
    }];
    
    // 上拉加载
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        currentPage = currentPage + 1;
        if ([_classId isEqualToString:XNRFER]) {
            [weakSelf getselectDataWithName:@"brandName" and:weakSelf.brandName and:weakSelf.reservePrice];
        }else{
            [weakSelf getselectDataWithName:@"modelName" and:weakSelf.modelName and:weakSelf.reservePrice];
            
        }
    }];


}
#pragma mark - 返回顶部啊按钮
-(void)createbackBtn
{
    UIButton *backtoTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backtoTopBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(60)-PX_TO_PT(32), ScreenHeight-PX_TO_PT(360), PX_TO_PT(100), PX_TO_PT(100));
    [backtoTopBtn setImage:[UIImage imageNamed:@"icon_home_backTop"] forState:UIControlStateNormal];
    [backtoTopBtn addTarget:self action:@selector(backtoTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backtoTopBtn = backtoTopBtn;
    [self.view addSubview:backtoTopBtn];
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
#pragma mark  - 获得商品数据
-(void)getData
{
    [SVProgressHUD show];
    [KSHttpRequest get:KHomeGetProductsListPage parameters:@{@"classId":_classId,@"brandName":self.brandName?self.brandName:@"",@"modelName":self.modelName?self.modelName:@"",@"reservePrice":self.reservePrice?self.reservePrice:@"",@"rowCount":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",currentPage]} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"datas"];
            NSArray *arr = dict[@"rows"];
            for (NSDictionary *dicts in arr) {
                XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                [model setValuesForKeysWithDictionary:dicts];
                [_totalArray addObject:model];
            }
        }
        NSInteger pages = [result[@"datas"][@"pages"] integerValue];
        NSInteger page = [result[@"datas"][@"page"] integerValue];
        //如果到达最后一页 就消除footer
        //如果没有达到最后一页 就显示footer
        self.tableView.legendFooter.hidden = pages==page;
        [self.tableView reloadData];
        
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
        [SVProgressHUD dismiss];

   }];
}
#pragma mark  - 顶部视图
-(void)setupTopView
{
    XNRferView *ferView = [[XNRferView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(100))];
    self.ferView = ferView;
    ferView.delegate = self;
    [self.view addSubview:ferView];
}
#pragma mark - 顶部按钮的点击事件
-(void)ferView:(XNRferViewDoType)type
{
    _fertype = type;
    if (type == XNRferView_DoTotalType) {// 综合
        
        [XNRHomeSelectBrandView cancelSelectedBrandView];
        [self.noSelectView removeFromSuperview];
        [self getTotalData];
        
    }else if (type == XNRferView_DoPriceType){ // 价格排序
        
        [XNRHomeSelectBrandView cancelSelectedBrandView];
        [self.noSelectView removeFromSuperview];
        
        isSort = !isSort;
        if (isSort) { // 正序
            NSLog(@"正序");
            [self getPriceDataWith:@"price-asc"];
        }else{   // 反序
            NSLog(@"反序");
            [self getPriceDataWith:@"price-desc"];
        }
        
    }else if(type == XNRferView_DoSelectType){   // 筛选
        [_carArray removeAllObjects];
        isCancel = !isCancel;
        if (isCancel) {
            __weak typeof(self) weakSelf=self;
            [XNRHomeSelectBrandView showSelectedBrandViewWith:^(NSString *param1, NSString *param2,NSArray *selectedParams) {
                weakSelf.selectedItemArr = selectedParams;
                if ([_classId isEqualToString:XNRFER]) {
                    weakSelf.brandName = param1;
                    weakSelf.reservePrice = param2;
                    [weakSelf getselectDataWithName:@"brandName" and:param1 and:param2];
                }else{
                    weakSelf.modelName = param1;
                    weakSelf.reservePrice = param2;
                    [weakSelf getselectDataWithName:@"modelName" and:param1 and:param2];
                }
        } andTarget:self.view andType:self.type andParam:self.selectedItemArr];
            // 把视图提到前面
            [self.view bringSubviewToFront:self.ferView];

        }else{
            [XNRHomeSelectBrandView cancelSelectedBrandView];

        }
    }
}
-(void)getTotalData{
    [SVProgressHUD show];
    [_totalArray removeAllObjects];
    [KSHttpRequest get:KHomeGetProductsListPage parameters:@{@"classId":_classId,@"brandName":self.brandName?self.brandName:@"",@"modelName":self.modelName?self.modelName:@"",@"reservePrice":self.reservePrice?self.reservePrice:@""} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"datas"];
            NSArray *arr = dict[@"rows"];
            for (NSDictionary *dicts in arr) {
                XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                [model setValuesForKeysWithDictionary:dicts];
                [_totalArray addObject:model];
            }
        }
        [self.tableView reloadData];
        // 筛选为空
        [self noselectViewShowAndHidden:_totalArray];
        [SVProgressHUD dismiss];
        self.tableView.legendFooter.hidden = YES;
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)getPriceDataWith:(NSString *)sort{
    [_ferArray removeAllObjects];
    [SVProgressHUD show];
    [KSHttpRequest get:KHomeGetProductsListPage parameters:@{@"classId":_classId,@"sort":sort,@"brandName":self.brandName?self.brandName:@"",@"modelName":self.modelName?self.modelName:@"",@"reservePrice":self.reservePrice?self.reservePrice:@""} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"datas"];
            NSArray *arr = dict[@"rows"];
            for (NSDictionary *dicts in arr) {
                XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                [model setValuesForKeysWithDictionary:dicts];
                [_ferArray addObject:model];
            }
        }
        [self.tableView reloadData];
        // 筛选为空
        [self noselectViewShowAndHidden:_ferArray];
        
        [SVProgressHUD dismiss];
        self.tableView.legendFooter.hidden = YES;
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];

}
-(void)getselectDataWithName:(NSString *)goodsName and:(NSString *)param1 and:(NSString *)param2{
    [KSHttpRequest get:KHomeGetProductsListPage parameters:@{@"classId":_classId,goodsName:param1?param1:[NSString stringWithFormat:@"%@",param1],@"reservePrice":param2,@"rowCount":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",currentPage]} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"datas"];
            NSArray *Array = dict[@"rows"];
            for (NSDictionary *dicts in Array) {
                XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                [model setValuesForKeysWithDictionary:dicts];
                [_carArray addObject:model];
            }
        }
        NSInteger pages = [result[@"datas"][@"pages"] integerValue];
        NSInteger page = [result[@"datas"][@"page"] integerValue];
        //如果到达最后一页 就消除footer
        //如果没有达到最后一页 就显示footer
        self.tableView.legendFooter.hidden = pages==page;
        [self.tableView reloadData];
        // 筛选为空
        [self noselectViewShowAndHidden:_carArray];
        
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
        } failure:^(NSError *error) {
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
            
    }];
}

-(void)noselectViewShowAndHidden:(NSMutableArray *)array{
    if (array.count == 0) {
        [self.noSelectView show];
        [self.tableView.legendFooter endRefreshing];
        self.backtoTopBtn.hidden = YES;
    }else{
        [self.noSelectView removeFromSuperview];
        
    }
}

#pragma mark - 创建tableView
-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ferView.frame), ScreenWidth, ScreenHeight-64-PX_TO_PT(100))];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
#pragma mark - 导航
-(void)setupNav
{
    self.navigationItem.title = _tempTitle;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 44);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backBtn addTarget: self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)backClick
{
    [XNRHomeSelectBrandView cancelSelectedBrandView];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_fertype == XNRferView_DoTotalType) {
        return _totalArray.count;
    }else if (_fertype == XNRferView_DoPriceType){
        return _ferArray.count;
    }else{
        return _carArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(240);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRSpecialCell *cell = [XNRSpecialCell cellWithTableView:tableView];
    XNRShoppingCartModel *model;
    if (_fertype == XNRferView_DoTotalType) {
        if (_totalArray.count>0) {
            model = _totalArray[indexPath.row];

        }
    }else if (_fertype == XNRferView_DoPriceType){
        if (_ferArray.count>0) {
            model = _ferArray[indexPath.row];
        }
    }else{
        if (_carArray.count>0) {
            model = _carArray[indexPath.row];
        }else{
            model = _totalArray[indexPath.row];
      }
    }
    if (model) {
        [cell setCellDataWithShoppingCartModel:model];

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XNRProductInfo_VC *info_VC = [[XNRProductInfo_VC alloc] init];
    XNRShoppingCartModel *model;
    if (_fertype == XNRferView_DoTotalType) {
        model = _totalArray[indexPath.row];
        
    }else if (_fertype == XNRferView_DoPriceType){
        model = _ferArray[indexPath.row];
    }else{
        model = _carArray[indexPath.row];
    }

    info_VC.model = model;
    info_VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info_VC animated:YES];
}
@end
