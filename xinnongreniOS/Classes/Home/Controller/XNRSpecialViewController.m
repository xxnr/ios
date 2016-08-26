//
//  XNRSpecialViewController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/12.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSpecialViewController.h"
#import "XNRferView.h"
#import "XNRSpecialCell.h"
#import "XNRProductInfo_VC.h"
#import "XNRTabBarController.h"
#import "XNRHomeSelectBrandView.h"
#import "XNRNoSelectView.h"
#import "XNRSelectItemArrModel.h"

#define MAX_PAGE_SIZE 10

@interface XNRSpecialViewController()<UITableViewDelegate,UITableViewDataSource,XNRferViewAddBtnDelegate>
{
    XNRferViewDoType _fertype;
    XNRferViewDoType _lastType;

    BOOL isSort;
    int totalCurPage;
    int compositorCurPage;
    int filterCurPage;
    BOOL isCancel;
    BOOL istotal;
}

@property (nonatomic, weak) XNRferView *ferView;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *totalArray;

@property (nonatomic ,strong) NSMutableArray *compositorArr;

@property (nonatomic ,strong) NSMutableArray *filterArr;

@property (nonatomic, weak) UIButton *backtoTopBtn;

@property (nonatomic ,weak) XNRNoSelectView *noSelectView;

@property (nonatomic ,weak) BMProgressView *progressView;

@property (nonatomic ,copy) NSString *brandName;

@property (nonatomic ,copy) NSString *modelName;

@property (nonatomic ,copy) NSString *reservePrice;
@property (nonatomic, strong) NSArray *selectedItemArr;
@property (nonatomic ,weak) XNRHomeSelectBrandView *selectBrandView;
@property (nonatomic,strong)NSArray *brands;
@property (nonatomic,copy)NSString *currentBrand;
@property (nonatomic,strong)NSArray *gxArr;
@property (nonatomic,strong)NSArray *txArr;
@property (nonatomic,strong)NSArray *kinds;
@property (nonatomic,strong)NSArray *atts;
@property (nonatomic,strong)NSArray *showTxArr;
@property (nonatomic,strong)NSString *kind;
@property (nonatomic,assign)BOOL isfirst;
@property (nonatomic,assign)int currentBtn;
@end

@implementation XNRSpecialViewController

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
    totalCurPage = 1;
    compositorCurPage = 1;
    filterCurPage = 1;
    istotal = YES;
    _totalArray = [NSMutableArray array];
    _compositorArr  = [NSMutableArray array];
    _filterArr = [NSMutableArray array];
    _atts = [NSArray array];
    [self createbackBtn];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.currentBtn = 1;
//    [self getData];
    [self getTotalData];
    // 刷新
    [self setupTotalRefresh];
    
}
#pragma mark - 刷新
-(void)setupTotalRefresh{
    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    NSMutableArray *idleImage = [NSMutableArray array];
    
//    for (int i = 1; i<21; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
//        
//        [idleImage addObject:image];
//    }
//    NSMutableArray *RefreshImage = [NSMutableArray array];
//    
//    for (int i = 10; i<21; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
//        
//        [RefreshImage addObject:image];
//        
//    }
    for (int i = 1; i<21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
        
        [idleImage addObject:image];
    }
    NSMutableArray *RefreshImage = [NSMutableArray array];
    
    for (int i = 1; i<21; i++) {
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
    
    
    
}
-(void)headRefresh{
    if (self.currentBtn == 1) {
        totalCurPage = 1;
        [_totalArray removeAllObjects];
        [self getTotalData];
    }
    else if (self.currentBtn == 2)
    {
        compositorCurPage = 1;
        [_compositorArr removeAllObjects];
        if (isSort) { // 正序
            NSLog(@"正序");
            [self getPriceDataWith:@"price-asc"];
        }else{   // 反序
            NSLog(@"反序");
            [self getPriceDataWith:@"price-desc"];
        }
        
    }
    else if (self.currentBtn == 3)
    {
        filterCurPage = 1;
        [_filterArr removeAllObjects];
        [_totalArray removeAllObjects];
        [_compositorArr removeAllObjects];
        [self getselectDataWithName:self.brands and:self.gxArr and:self.txArr and:self.reservePrice and:self.kinds];
    }
    [self.tableView reloadData];
    
    
}
-(void)footRefresh{
    
    if (self.currentBtn == 1) {
        totalCurPage ++;
        [self getTotalData];
    }
    else if (self.currentBtn == 2)
    {
        compositorCurPage ++;
        if (isSort) { // 正序
            NSLog(@"正序");
            [self getPriceDataWith:@"price-asc"];
        }else{   // 反序
            NSLog(@"反序");
            [self getPriceDataWith:@"price-desc"];
        }
        
    }
    else if (self.currentBtn == 3)
    {
        filterCurPage ++;
        [self getselectDataWithName:self.brands and:self.gxArr and:self.txArr and:self.reservePrice and:self.kinds];
    }
    [self.tableView reloadData];
    
    //    currentPage ++;
    ////    [self getData];
    //    [self getTotalData];
    //    if (isSort) { // 正序
    //        NSLog(@"正序");
    //        [self getPriceDataWith:@"price-asc"];
    //    }else{   // 反序
    //        NSLog(@"反序");
    //        [self getPriceDataWith:@"price-desc"];
    //    }
    //    [self getselectDataWithName:self.brands and:self.gxArr and:self.txArr and:self.reservePrice and:self.kinds];
    //
    //    [self.tableView reloadData];
    
    
}
#pragma mark - 返回顶部啊按钮
-(void)createbackBtn
{
    UIButton *backtoTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backtoTopBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(60)-PX_TO_PT(32), ScreenHeight-PX_TO_PT(360), PX_TO_PT(100), PX_TO_PT(100));
    [backtoTopBtn setImage:[UIImage imageNamed:@"icon_home_backTop"] forState:UIControlStateNormal];
    [backtoTopBtn addTarget:self action:@selector(backtoTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backtoTopBtn = backtoTopBtn;
    self.backtoTopBtn.hidden = YES;
    [self.view addSubview:backtoTopBtn];
}

-(void)backtoTopBtnClick{
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 0) {
        self.backtoTopBtn.hidden = YES;
    }else{
        self.backtoTopBtn.hidden = NO;
    }
}
#pragma mark  - 获得商品数据
-(void)getData
{    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *dic = [NSDictionary dictionary];

        dic = @{@"classId":_classId,@"brand":self.currentBrand?self.currentBrand:@"",@"reservePrice":self.reservePrice?self.reservePrice:@"",@"rowCount":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",totalCurPage],@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};

    [manager POST:KHomeGetProductsListPage parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            NSDictionary *dict = resultDic[@"datas"];
            NSArray *arr = dict[@"rows"];
                for (NSDictionary *dicts in arr) {
                    XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                    [model setValuesForKeysWithDictionary:dicts];
                    
                    [_filterArr addObject:model];
                }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
}
#pragma mark  - 顶部视图
-(void)setupTopView
{
    XNRferView *ferView = [[XNRferView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(89))];
    self.ferView = ferView;
    ferView.delegate = self;
    [self.view addSubview:ferView];
}
#pragma mark - 顶部按钮的点击事件
-(void)ferView:(XNRferViewDoType)type
{
    
    _fertype = type;
    if (type == XNRferView_DoTotalType) {// 综合
        istotal = YES;
        self.currentBtn = 1;
        totalCurPage = 1;
        [self.totalArray removeAllObjects];
        
        isCancel = NO;
        [XNRHomeSelectBrandView cancelSelectedBrandView];
        [self.noSelectView removeFromSuperview];
        [self getTotalData];
        _lastType = type;
    }else if (type == XNRferView_DoPriceType){ // 价格排序
        istotal = NO;
        self.currentBtn = 2;
        compositorCurPage = 1;
        [self.compositorArr removeAllObjects];
        
        isCancel = NO;
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
        
        _lastType = type;
    }else if(type == XNRferView_DoSelectType){   // 筛选
        
         [_compositorArr removeAllObjects];
        [_totalArray removeAllObjects];
        
        self.currentBtn = 3;
        filterCurPage = 1;
        
        NSLog(@"筛选");
        self.kind = @"车系";
        isCancel = !isCancel;
        NSLog(@"_____+=====%d",isCancel);
        
        if (isCancel) {
            __weak typeof(self) weakSelf=self;
            
            [XNRHomeSelectBrandView showSelectedBrandViewWith:^(NSArray *param1, NSArray *param2, NSArray *param3, NSString *param4, NSArray *kinds,NSArray *selectedParams,NSArray *txarr){
                weakSelf.selectedItemArr = selectedParams;
                weakSelf.showTxArr = txarr;
                weakSelf.kind = kinds[1];
                if ([_classId isEqualToString:XNRFER]) {
                    
                    weakSelf.brands = param1;
                    weakSelf.gxArr = param2;
                    weakSelf.txArr = param3;
                    weakSelf.reservePrice = param4;
                    weakSelf.kinds = kinds;
                    [weakSelf getselectDataWithName:param1 and:param2 and:param3 and:param4 and:kinds];
                }else{
                    weakSelf.brands = param1;
                    weakSelf.gxArr = param2;
                    weakSelf.txArr = param3;
                    weakSelf.reservePrice = param4;
                    weakSelf.kinds = kinds;
                    [weakSelf getselectDataWithName:param1 and:param2 and:param3 and:param4 and:kinds];
                }
                
            } andTarget:self.view andType:self.type andParam:self.selectedItemArr andShowTx:self.showTxArr andkind:self.kind];
            // 把视图提到前面
            [self.view bringSubviewToFront:self.ferView];
            
        }else{
            
            _fertype = _lastType;
            [XNRHomeSelectBrandView cancelSelectedBrandView];
        }

    }
}
-(void)getTotalData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *dic = [NSDictionary dictionary];
    if (self.atts.count != 0) {
        dic = @{@"classId":_classId,@"brand":self.currentBrand?self.currentBrand:@"",@"attributes":self.atts?self.atts:nil,@"reservePrice":self.reservePrice?self.reservePrice:@"",@"rowCount":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",totalCurPage],@"user-agent":@"IOS-v2.0"};
    }
    else
    {
        
        dic = @{@"classId":_classId,@"brand":self.currentBrand?self.currentBrand:@"",@"reservePrice":self.reservePrice?self.reservePrice:@"",@"rowCount":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",totalCurPage],@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
    }
    [manager POST:KHomeGetProductsListPage parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            NSDictionary *dict = resultDic[@"datas"];
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
        
        //  如果到达最后一页 就消除footer
        NSInteger pages = [resultDic[@"datas"][@"pages"] integerValue];
        NSInteger page = [resultDic[@"datas"][@"page"] integerValue];
        self.tableView.mj_footer.hidden = pages == page;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [BMProgressView LoadViewDisappear:self.view];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [BMProgressView LoadViewDisappear:self.view];
        
    }];
    
}

-(void)getPriceDataWith:(NSString *)sort{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *dic = [NSDictionary dictionary];
    if (self.atts.count != 0) {
        dic = @{@"classId":_classId,@"sort":sort,@"brand":self.currentBrand?self.currentBrand:@"",@"attributes":self.atts,@"reservePrice":self.reservePrice?self.reservePrice:@"",@"rowCount":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",compositorCurPage],@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
    }
    else
    {
        dic = @{@"classId":_classId,@"sort":sort,@"brand":self.currentBrand?self.currentBrand:@"",@"reservePrice":self.reservePrice?self.reservePrice:@"",@"rowCount":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",compositorCurPage],@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
    }
    
    [manager POST:KHomeGetProductsListPage parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            NSDictionary *dict = resultDic[@"datas"];
            NSArray *arr = dict[@"rows"];
            for (NSDictionary *dicts in arr) {
                XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                [model setValuesForKeysWithDictionary:dicts];
                [_compositorArr addObject:model];
            }
        }
        [self.tableView reloadData];
        // 筛选为空
        [self noselectViewShowAndHidden:_compositorArr];
        
        //        self.tableView.legendFooter.hidden = YES;
        
        //  如果到达最后一页 就消除footer
        NSInteger pages = [resultDic[@"datas"][@"pages"] integerValue];
        NSInteger page = [resultDic[@"datas"][@"page"] integerValue];
        self.tableView.mj_footer.hidden = pages == page;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        [UILabel showMessage:@"您的网络不太顺畅，重试或检查下网络吧~"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
}

-(void)getselectDataWithName:(NSArray *)param1 and:(NSArray *)param2 and:(NSArray *)param3 and:(NSString *)param4 and:(NSArray *)kinds{

    _lastType = XNRferView_DoSelectType;

    NSMutableDictionary *dics = [NSMutableDictionary dictionary];
    [dics setObject:_classId forKey:@"classId"];
    // 品牌的ID
    NSMutableString *str = [NSMutableString string];
    self.currentBrand = nil;
    
    if (param1.count > 0) {
        
        for (int i=0; i<param1.count; i++) {
            
            [str appendString:param1[i]];
            if (i + 1 >= param1.count) {
                break;
            }
            else
            {
                [str appendString:@","];
            }
        }
        self.currentBrand = str;
        //        [dics setObject:str forKey:@"brand"];
        
    }
    //商品属性数组
    NSMutableArray *arr = [NSMutableArray array];
    if (param2.count > 0) {
        NSDictionary *dic1 = @{@"name":kinds[0],@"value":@{@"$in":param2}};
        [arr addObject:dic1];
        
    }
    if (param3.count > 0) {
        NSDictionary *dic2 = @{@"name":kinds[1],@"value":@{@"$in":param3}};
        [arr addObject:dic2];
        
    }
    
    if (arr > 0) {
        //        [dics setObject:arr forKey:@"attributes"];
        self.atts = arr;
    }
    if (param4) {
        //        [dics setObject:param4 forKey:@"reservePrice"];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *dic = [NSDictionary dictionary];
    if (arr.count != 0) {
        dic = @{@"attributes":arr,@"brand":str?str:@"",@"classId":_classId?_classId:@"",@"reservePrice":param4?param4:@"",@"rowCount":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",filterCurPage],@"user-agent":@"IOS-v2.0"};
    }else{
        dic =@{@"brand":str?str:@"",@"classId":_classId?_classId:@"",@"reservePrice":param4?param4:@"",@"rowCount":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",filterCurPage],@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
    }
    [manager POST:KHomeGetProductsListPage parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.filterArr removeAllObjects];
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            isCancel = NO;
            NSDictionary *dict = resultDic[@"datas"];
            NSArray *Array = dict[@"rows"];
            for (NSDictionary *dicts in Array) {
                XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                [model setValuesForKeysWithDictionary:dicts];
                [_filterArr addObject:model];
            }
//            [self.tableView reloadData];
            
        }
        
        // 筛选为空
        [self noselectViewShowAndHidden:_filterArr];
        //        self.tableView.legendFooter.hidden = YES;
//        self.tableView.mj_footer.hidden = YES;
//        [self.tableView reloadData];
        
        if (!istotal) {
        
            _fertype = XNRferView_DoPriceType;
            _lastType =XNRferView_DoPriceType;
            compositorCurPage = filterCurPage;
//            [_compositorArr removeAllObjects];
            if (isSort) { // 正序
                NSLog(@"正序");
                [self getPriceDataWith:@"price-asc"];
            }else{   // 反序
                NSLog(@"反序");
                [self getPriceDataWith:@"price-desc"];
            }
        }
        else
        {
            _fertype = XNRferView_DoTotalType;
            _lastType =XNRferView_DoTotalType;
            totalCurPage = filterCurPage;
//            [_totalArray removeAllObjects];
            [self getTotalData];
        }
        //  如果到达最后一页 就消除footer
        NSInteger pages = [resultDic[@"datas"][@"pages"] integerValue];
        NSInteger page = [resultDic[@"datas"][@"page"] integerValue];
        self.tableView.mj_footer.hidden = pages == page;
        
//        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [BMProgressView LoadViewDisappear:self.view];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [BMProgressView LoadViewDisappear:self.view];
        
    }];
    
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"===%@",error);
    //
    //    }];
}
-(void)noselectViewShowAndHidden:(NSMutableArray *)array{
    if (array.count == 0) {
        [self.noSelectView show];
        //        [self.tableView.legendFooter endRefreshing];
        self.tableView.mj_footer.hidden = YES;
        
        self.backtoTopBtn.hidden = YES;
    }else{
        [self.noSelectView removeFromSuperview];
        
    }
}

#pragma mark - 创建tableView
-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ferView.frame), ScreenWidth, ScreenHeight-64-PX_TO_PT(89))];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    UIView* footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = footerView;
    
    //    tableView.separatorStyle = UITableViewCellAccessoryDisclosureIndicator;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
#pragma mark - 导航
-(void)setupNav
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _tempTitle;
    self.navigationItem.titleView = titleLabel;
    

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 44);
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backBtn addTarget: self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)backClick
{
    [XNRHomeSelectBrandView cancelSelectedBrandView];
    [[XNRSelectItemArrModel defaultModel] cancel];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_fertype == XNRferView_DoTotalType) {
        return _totalArray.count;
    }else if (_fertype == XNRferView_DoPriceType){
        return _compositorArr.count;
    }else{
        return _filterArr.count;
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
        if (_compositorArr.count>0) {
            model = _compositorArr[indexPath.row];
        }
    }else{
        if (_filterArr.count>0) {
            model = _filterArr[indexPath.row];
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
        if (_totalArray.count>0) {
            model = _totalArray[indexPath.row];
        }
        
    }else if (_fertype == XNRferView_DoPriceType){
        if (_compositorArr.count>0) {
            model = _compositorArr[indexPath.row];

        }
    }else{
        if (_filterArr.count>0) {
            model = _filterArr[indexPath.row];
        }
    }
    
    info_VC.model = model;
    info_VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info_VC animated:YES];
}

@end
