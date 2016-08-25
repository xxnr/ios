//
//  XNRProductInfo_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.

#import "XNRProductInfo_VC.h"
#import "CWStarRateView.h"
#import "XNRShoppingCartModel.h"
#import "UIImageView+WebCache.h"
#import "XNRTabBarController.h"
#import "XNROrderInfo_VC.h"
#import "XNRProductInfo_model.h"
#import "XNRProductPhotoModel.h"
#import "XNRSKUAttributesModel.h"
#import "XNRProductInfo_cell.h"
#import "MJExtension.h"
#import "XNRToolBar.h"
#import "XNRPropertyView.h"
#import "XNRProductInfo_frame.h"
#import "MWPhotoBrowser.h"
#import "XNRProductInfo_VC.h"
#import "UINavigationBar+PS.h"
#import "UINavigationBar+Awesome.h"

#define kLeftBtn  3000
#define kRightBtn 4000
#define HEIGHT 100


#define KbtnTag 1000
#define KlabelTag 2000
#define Max_OffsetY  50


#define  Statur_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define  NAVIBAR_HEIGHT  (self.navigationController.navigationBar.frame.size.height)
#define  INVALID_VIEW_HEIGHT (Statur_HEIGHT + NAVIBAR_HEIGHT)
#define NavigationBarBGColor R_G_B_16(0x00B38A)

@interface XNRProductInfo_VC ()<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,XNRProductInfo_cellDelegate,XNRToolBarBtnDelegate,UIScrollViewDelegate,MWPhotoBrowserDelegate,UIWebViewDelegate,UIScrollViewDelegate>{
    CGRect oldTableRect;
    CGFloat preY;
    NSMutableArray *_goodsArray;
    NSString *_Price;
    NSString *_marketPrice;
    NSMutableArray *_infoModelArray;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,weak) UIImageView *headView;
@property(nonatomic,weak) UITextField *numTextField;

@property (nonatomic,weak) UIButton *buyBtn;   // 立即购买
@property(nonatomic,weak) UIButton*addBuyCarBtn; // 加入购物车
@property(nonatomic,weak) UIButton *rightBtn;
@property(nonatomic,weak) UIButton *leftBtn;

@property(nonatomic,weak) UIButton *button;


@property (nonatomic,weak) UIView *midView;
@property (nonatomic,weak) UIView *selectLine;
@property (nonatomic,weak) UIButton *tempBtn;
@property (nonatomic,weak) UILabel *tempLabel;
@property (nonatomic,weak) UIScrollView *bottomScrollView;

@property (nonatomic ,weak) BMProgressView *progressView;

@property (nonatomic ,weak) UIView *bgView;
@property (nonatomic ,weak) UIView *bgExpectView;

@property (nonatomic ,strong) NSMutableArray *attributes;
@property (nonatomic ,strong) NSMutableArray *additions;

@property (nonatomic ,weak) XNRPropertyView *propertyView;

@property (nonatomic, strong) NSMutableArray *picBrowserList;

@property (nonatomic, assign) BOOL bottomBtnClick;

@property (nonatomic,strong)CALayer *subLayer;
@property (nonatomic,strong)UIView *productView;
@property (nonatomic ,copy) NSString *thumbnail;
@property (nonatomic,weak)UIButton *shopcarButton;
@property (nonatomic,weak)CAGradientLayer *layer;
@property (nonatomic,assign) BOOL is_loading;
@property (nonatomic,weak)UIView *blowView;
@property (nonatomic,assign)BOOL changeTableViewFrame;
@end

@implementation XNRProductInfo_VC
{
    CAGradientLayer *_gradientLayer;
    UIView *_layerView;
    UIImageView *_imageView;
}

- (NSMutableArray *)picBrowserList {
    if (!_picBrowserList) {
        _picBrowserList = [NSMutableArray array];
    }
    return _picBrowserList;
}

-(BMProgressView *)progressView{
    if (!_progressView) {
        BMProgressView *progressView = [[BMProgressView alloc] init];
        self.progressView = progressView;
        [self.view addSubview:progressView];
    }
    return _progressView;
}

-(XNRPropertyView *)propertyView{
    
    [self.tableView reloadData];
    XNRPropertyView *propertyView = [XNRPropertyView sharedInstanceWithModel:self.model];
    if (!_propertyView) {
        __weak __typeof(self)weakSelf = self;
        // 传回来的属性
        propertyView.valueBlock = ^(NSMutableArray *attributes,NSMutableArray *addtions,NSString *price,NSString *marketPrice){
            _attributes = attributes;
            _additions = addtions;
            _Price = price;
            _marketPrice = marketPrice;
            
            
            [self.tableView reloadData];
        };
        // 提交订单页面的跳转
        propertyView.com = ^(NSMutableArray *dataArray,CGFloat totalPrice,NSString *totalNum){
            XNROrderInfo_VC *orderVC = [[XNROrderInfo_VC alloc] init];
            orderVC.dataArray = dataArray;
            orderVC.totalPrice = totalPrice;
            orderVC.totalSelectNum = totalNum.intValue;
            orderVC.isRoot = YES;
            [weakSelf.navigationController pushViewController:orderVC animated:YES];
        };
        // 跳转登录界面
        propertyView.loginBlock = ^(){
            XNRLoginViewController *login = [[XNRLoginViewController alloc]init];
            login.loginFromProductInfo = YES;
            login.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:login animated:YES];
        };
        [self.view addSubview:propertyView];
        self.propertyView = propertyView;
    }
    
    return _propertyView;
}

#pragma mark - 键盘回收

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.numTextField.text isEqualToString:@"0"] || [self.numTextField.text isEqualToString:@""]) {
        self.numTextField.text = @"1";
    }
    
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    //    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addShoppingCar" object:nil];
    
    //    self.mainScrollView.delegate = nil;
    [self.blowView removeFromSuperview];
    
    [super viewWillDisappear:animated];
    [self.layer removeFromSuperlayer];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_navbg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.alpha = 1;
    
    self.navigationController.navigationBar.translucent = NO;
    [_numTextField resignFirstResponder];
    
    if (self.navigationController.childViewControllers.count-1 > [self.navigationController.childViewControllers indexOfObject:self]) {
        
    } else {
        [[XNRPropertyView sharedInstanceWithModel:self.model] changeSelfToIdentify];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *mainScrollView = [MyControl createUIScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, 600*SCALE) pagingEnabled:NO showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO delegate:self];
    self.mainScrollView.delegate = self;
    self.mainScrollView = mainScrollView;
    self.mainScrollView.scrollEnabled = NO;
    
    [self.scrollView addSubview:mainScrollView];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    // 获取网络数据
    [self getData];
    _goodsArray  = [NSMutableArray array];
    
    // 导航栏
    [self setNavigationbarTitle];
    // 注册消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_numTextField];
    
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.view addSubview:self.scrollView];
    [self.mainScrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.webView];
    self.changeTableViewFrame = YES;
    
    
    // 设置UITableView的上拉加载
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.refreshingTitleHidden = YES;
    footer.automaticallyHidden = YES;
    self.tableView.mj_footer = footer;
    
    //设置UIWebView 有下拉操作
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉，返回商品简介" forState:MJRefreshStateIdle];
    [header setTitle:@"释放，返回商品简介" forState:MJRefreshStatePulling];
    [header setTitle:@"返回中 ..." forState:MJRefreshStateRefreshing];
    self.webView.scrollView.mj_header = header;
    
    [self createWebView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notSelectedAttributes) name:@"notSelectedAttributes" object:nil];
    
    
}

-(void)notSelectedAttributes
{
    [[XNRPropertyView sharedInstanceWithModel:self.model] changeSelfToIdentify];
}


-(void)loadMoreData{
    
    _midView.frame = CGRectMake(0, ScreenHeight+64+64, ScreenWidth, PX_TO_PT(80));
    _webView.frame = CGRectMake(0, ScreenHeight+PX_TO_PT(80)+64+64, ScreenWidth, ScreenHeight-PX_TO_PT(160)-PX_TO_PT(80)-PX_TO_PT(40));
    
    _is_loading = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scrollView.contentOffset = CGPointMake(0, ScreenHeight);
        [self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:1]];
        self.title = @"商品详情";
        
    } completion:^(BOOL finished) {
        //结束加载
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
}
-(void)loadNewData{
    _is_loading = NO;
    //下拉执行对应的操作
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        //        self.tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - PX_TO_PT(80));
        
        self.mainScrollView.frame =CGRectMake(0, 64, ScreenWidth, ScreenHeight-PX_TO_PT(80));
        
        self.tableView.contentOffset = CGPointMake(0, 0);
        [self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:0]];
        self.title = @"";
        
    } completion:^(BOOL finished) {
        //结束加载
        [self.webView.scrollView.mj_header endRefreshing];
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    if ([self.numTextField.text isEqualToString:@"0"] || [self.numTextField.text isEqualToString:@""]) {
        self.numTextField.text = @"1";
    }
    
}
#pragma mark - 懒加载视图
-(UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -64, ScreenWidth, ScreenHeight+64)];
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight * 2);
        //设置分页效果
        _scrollView.pagingEnabled = YES;
        //禁用滚动
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

-(UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - PX_TO_PT(80)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView * view = [[UIView alloc] init];
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}

-(UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, ScreenHeight+PX_TO_PT(80)+64+64, ScreenWidth, ScreenHeight-PX_TO_PT(160)-PX_TO_PT(80)-PX_TO_PT(40))];
        _webView.backgroundColor = R_G_B_16(0xf2f2f2);
        _webView.delegate = self;
    }
    return _webView;
}


-(void)createWebView
{
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight+64+64, ScreenWidth, PX_TO_PT(80))];
    midView.backgroundColor = R_G_B_16(0xf2f2f2);
    self.midView = midView;
    [self.scrollView addSubview:midView];
    
    
    NSArray *array = @[@"商品描述",@"详细参数",@"服务说明"];
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = ScreenWidth/3.0;
    CGFloat H = PX_TO_PT(80);
    
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(X+i*W, Y, W, H);
        button.tag = KbtnTag+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.button = button;
        [midView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(W*i, 0, W, H)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        label.textColor = R_G_B_16(0x646464);
        label.text = array[i];
        label.tag = KlabelTag + i;
        [midView addSubview:label];
        
        if (i == 0) {
            button.selected =YES;
            self.tempBtn = button;
            
            label.textColor = R_G_B_16(0x00b38a);
            self.tempLabel = label;
        }
    }
    
    UIView *selectLine = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(35), PX_TO_PT(77), PX_TO_PT(180), PX_TO_PT(3))];
    selectLine.backgroundColor = R_G_B_16(0x00b38a);
    self.selectLine = selectLine;
    [midView addSubview:selectLine];
    
    for (int i = 1; i<3; i++) {
        UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3*i, PX_TO_PT(20), 1, PX_TO_PT(40))];
        dividedLine.backgroundColor = R_G_B_16(0xe0e0e0);
        [midView addSubview:dividedLine];
        
    }
}

-(void)buttonClick:(UIButton *)button
{
    XNRProductInfo_frame *frameModel = [_goodsArray lastObject];
    static int index = 1000;
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:button.tag + KbtnTag];
    [UIView animateWithDuration:.3 animations:^{
        self.selectLine.frame = CGRectMake((button.tag - KbtnTag)*ScreenWidth/3 + PX_TO_PT(35), PX_TO_PT(77), PX_TO_PT(180), PX_TO_PT(3));
        
    }];
    index = (int)button.tag;
    if (button.tag == KbtnTag) {
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
        
        self.tempLabel.textColor = R_G_B_16(0x646464);
        titleLabel.textColor = R_G_B_16(0x00b38a);
        self.tempLabel = titleLabel;
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:frameModel.infoModel.app_body_url]];
        [self.webView loadRequest:request];
        //        [SVProgressHUD dismiss];
        
        
    }else if (button.tag == KbtnTag + 1)
    {
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
        
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:frameModel.infoModel.app_standard_url]];
        [self.webView loadRequest:request];
        //        [SVProgressHUD dismiss];
        
        self.tempLabel.textColor = R_G_B_16(0x646464);
        titleLabel.textColor = R_G_B_16(0x00b38a);
        self.tempLabel = titleLabel;
    }else{
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
        
        
        self.tempLabel.textColor = R_G_B_16(0x646464);
        titleLabel.textColor = R_G_B_16(0x00b38a);
        self.tempLabel = titleLabel;
        
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:frameModel.infoModel.app_support_url]];
        [self.webView loadRequest:request];
        //        [SVProgressHUD dismiss];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
-(void)createTableView:(NSMutableArray *)infoModelArray{
    _infoModelArray = infoModelArray;
    XNRProductInfo_frame *frame = [infoModelArray lastObject];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.viewHeight )];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark-获取网络数据
-(void)getData {
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [KSHttpRequest post:KHomeGetAppProductDetails parameters:@{@"productId":_model.goodsId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dic =result[@"datas"];
            self.thumbnail = dic[@"imgUrl"];
            
            XNRProductInfo_model *model = [[XNRProductInfo_model alloc] init];
            
            model.min = dic[@"SKUPrice"][@"min"];
            model.max = dic[@"SKUPrice"][@"max"];
            
            model.marketMin = dic[@"SKUMarketPrice"][@"min"];
            model.marketMax = dic[@"SKUMarketPrice"][@"max"];
            
            model._id = dic[@"_id"];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:dic[@"app_body_url"]]];
            [self.webView loadRequest:request];
            
            model.online = dic[@"online"];
            
            [model setValuesForKeysWithDictionary:dic];
            
            model.pictures = (NSMutableArray *)[XNRProductPhotoModel objectArrayWithKeyValuesArray:dic[@"pictures"]];
            model.SKUAttributes =  (NSMutableArray *)[XNRSKUAttributesModel objectArrayWithKeyValuesArray:dic[@"SKUAttributes"]];
            XNRProductInfo_frame *frame = [[XNRProductInfo_frame alloc] init];
            // 把商品详情的model传给frame
            frame.infoModel = model;
            
            [_goodsArray addObject:frame];
            
            if ([model.online integerValue] == 0) {
                [self createonlineView];
            }else{
                [self createBottomView];
                
            }
            
            if ([dic[@"presale"] integerValue] == 1) {
                
                self.bgView.hidden = YES;
                self.bgExpectView.hidden = NO;
                
            }else{
                self.bgView.hidden = NO;
                self.bgExpectView.hidden = YES;
            }
            
            [self createProcuct];
        }
        XNRProductInfo_frame *frame = [_goodsArray lastObject];
        if ([frame.infoModel.app_body_url isEqualToString:@""] &&[frame.infoModel.app_standard_url isEqualToString:@""] && [frame.infoModel.app_support_url isEqualToString:@""]) {
            _tableView.scrollEnabled = NO;
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [UILabel showMessage:@"您的网络不太顺畅，重试或检查下网络吧~"];
    }];
}

-(void)createProcuct
{
    [self.productView removeFromSuperview];
    
    UIView *product = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(70))/2, (ScreenHeight-PX_TO_PT(70))/2, PX_TO_PT(70),PX_TO_PT(70))];
    product.layer.cornerRadius = PX_TO_PT(35);
    product.layer.masksToBounds = YES;
    product.hidden = YES;
    self.productView = product;
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, PX_TO_PT(70), PX_TO_PT(70))];
    imageview.layer.cornerRadius = PX_TO_PT(35);
    imageview.layer.masksToBounds = YES;
    
    NSString *imageUrl=[HOST stringByAppendingString:self.thumbnail];
    
    [imageview sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
            [imageview setImage:[UIImage imageNamed:@"icon_placehold"]];
        }else{
        }}];
    
    [self.productView addSubview:imageview];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.productView];
}
-(void)textFieldChanged:(NSNotification*)noti {
    
    if([self.numTextField.text isEqualToString:@"0"]){
        self.numTextField.text = @"1";
    }else{
        self.addBuyCarBtn.enabled = YES;
    }
    if (self.numTextField.text.length>4) {
        self.numTextField.text = [self.numTextField.text substringToIndex:4];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([self.numTextField.text isEqualToString:@"0"] || [self.numTextField.text isEqualToString:@""]) {
        
        self.numTextField.text = @"1";
    }
}

-(void)createonlineView
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-PX_TO_PT(80), ScreenWidth, PX_TO_PT(80))];
    bgView.backgroundColor=R_G_B_16(0xE2E2E2);
    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    UILabel *expectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80))];
    expectLabel.text = @"商品已下架";
    expectLabel.textAlignment = NSTextAlignmentCenter;
    expectLabel.textColor = R_G_B_16(0x909090);
    expectLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [bgView addSubview:expectLabel];
}

#pragma mark-底部视图
-(void)createBottomView {
    
    
    UIView *bgExpectView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-PX_TO_PT(80), ScreenWidth, PX_TO_PT(80))];
    bgExpectView.backgroundColor = R_G_B_16(0xe2e2e2);
    self.bgExpectView = bgExpectView;
    [self.view addSubview:bgExpectView];
    
    UILabel *expectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80))];
    expectLabel.text = @"敬请期待";
    expectLabel.textAlignment = NSTextAlignmentCenter;
    expectLabel.textColor = R_G_B_16(0x909090);
    expectLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [bgExpectView addSubview:expectLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [bgExpectView addSubview:lineView];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-PX_TO_PT(80)+ 64, ScreenWidth, PX_TO_PT(80))];
    bgView.backgroundColor=[UIColor whiteColor];
    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    // 立即购买
    UIButton *buyBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, ScreenWidth/2, PX_TO_PT(80)) ImageName:nil Target:self Action:@selector(buyBtnClick) Title:@"立即购买"];
    buyBtn.backgroundColor = [UIColor whiteColor];
    [buyBtn setTitleColor:R_G_B_16(0xfe9b00) forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.buyBtn = buyBtn;
    [bgView addSubview:buyBtn];
    
    //加入购物车
    UIButton *addBuyCarBtn=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(2), ScreenWidth/2, PX_TO_PT(81)) ImageName:nil Target:self Action:@selector(addBuyCar) Title:@"加入购物车"];
    [addBuyCarBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fe9b00"]] forState:UIControlStateNormal];
    [addBuyCarBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fec366"]] forState:UIControlStateHighlighted];
    [addBuyCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBuyCarBtn.titleLabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    self.addBuyCarBtn = addBuyCarBtn;
    [bgView addSubview:addBuyCarBtn];
    
    //分割线
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,1 )];
    line.backgroundColor=R_G_B_16(0xe0e0e0);
    [bgView addSubview:line];
    
}
#pragma mark - 立即购买
-(void)buyBtnClick
{
    [self.propertyView show:XNRBuyType];
    _bottomBtnClick = YES;
}
#pragma mark-加入购物车
-(void)addBuyCar
{
    
    //    [self.propertyView setXNRAddShoppingCarBlock:^{
    //        [self addshoppingCar];
    //    }];
    [self.propertyView show:XNRAddCartType];
    _bottomBtnClick = YES;
    
}

-(void)addshoppingCar
{
    self.productView.hidden = NO;
    //    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.productView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            self.productView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
                self.productView.transform = CGAffineTransformMakeScale(0.4, 0.4);
                self.productView.alpha = 0.1;
                CGRect rect = self.productView.frame;
                //                rect.origin = CGPointMake(ScreenWidth-PX_TO_PT(50), 30);
                rect.origin.x = self.shopcarButton.center.x-PX_TO_PT(5);
                rect.origin.y = self.shopcarButton.center.y+PX_TO_PT(5);
                self.productView.frame = rect;
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
                    self.productView.alpha = 0;
                    self.shopcarButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.shopcarButton.transform = CGAffineTransformIdentity;
                        
                    } completion:^(BOOL finished) {
                        self.productView.hidden = YES;
                        self.productView.alpha = 1;
                        self.productView.transform = CGAffineTransformIdentity;
                        self.productView.frame =CGRectMake(ScreenWidth/2, ScreenHeight/2, 100, 100);
                    }];
                }];
            }];
        }];
    }];
    
}
#pragma 加减数量
-(void)btnClick:(UIButton*)button{
    if(button.tag == kLeftBtn){
        
        if([self.numTextField.text integerValue]>1){
            self.numTextField.text = [NSString stringWithFormat:@"%ld",(long)[self.numTextField.text floatValue]-1];
        }else{
            self.numTextField.text=@"1";
        }
        
        if([self.numTextField.text isEqualToString:@"1"]){
            self.addBuyCarBtn.enabled=YES;
        }
    }else if(button.tag == kRightBtn){
        
        if (self.numTextField.text.length >10) {
            return;
        }
        self.numTextField.text=[NSString stringWithFormat:@"%ld",(long)[self.numTextField.text floatValue]+1];
    }
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _goodsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRProductInfo_frame *frame = _goodsArray[indexPath.row];
    return frame.viewHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRProductInfo_cell *cell = [XNRProductInfo_cell cellWithTableView:tableView];
    cell.goodsId = _model.goodsId;
    cell.shopcarModel = _model;
    // 属性
    cell.attributes = _attributes;
    cell.additions = _additions;
    cell.Price = _Price;
    cell.marketPrice = _marketPrice;
    cell.bottomBtnClick = _bottomBtnClick;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 传值
    XNRProductInfo_frame *frame = _goodsArray[indexPath.row];
    cell.infoFrame = frame;
    // 提交订单页面的跳转
    __weak __typeof(self)weakSelf = self;
    
    cell.con = ^(NSMutableArray *_dataArray,CGFloat totalPrice,NSString *totalNumber){
        
        XNROrderInfo_VC *infoVC  = [[XNROrderInfo_VC alloc] init];
        infoVC.dataArray = _dataArray;
        infoVC.totalPrice = totalPrice;
        infoVC.totalSelectNum = totalNumber.intValue;
        infoVC.isRoot = YES;
        [weakSelf.navigationController pushViewController:infoVC animated:YES];
    };
    // 登录页面的跳转
    cell.logincom = ^(){
        XNRLoginViewController *login = [[XNRLoginViewController alloc]init];
        login.loginFromProductInfo = YES;
        login.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:login animated:YES];
    };
    // 图片浏览器的跳转
    cell.photoBrowsercom = ^(NSInteger page){
        
        [self pushToPhotoBrowser:page andFrameModel:frame];
    };
    cell.delegate = self;
    return cell;
}

-(void)pushToPhotoBrowser:(NSInteger)page andFrameModel:(XNRProductInfo_frame *)frame
{
    // 创建浏览器对象
    [self.picBrowserList removeAllObjects];
    NSInteger count = frame.infoModel.pictures.count;
    
    for (int i = 0; i<count; i++) {
        XNRProductPhotoModel *photoModel = frame.infoModel.pictures[i];
        MWPhoto *photo=[MWPhoto photoWithURL:[NSURL URLWithString:[HOST stringByAppendingString:photoModel.originalUrl]]];
        [self.picBrowserList addObject:photo];
    }
    
    MWPhotoBrowser *photoBrowser=[[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton=NO;
    photoBrowser.alwaysShowControls=NO;
    [photoBrowser setCurrentPhotoIndex:page];
    [self.navigationController pushViewController:photoBrowser animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    self.blowView = view;
    view.backgroundColor = R_G_B_16(0x00B38A);
    [[UIApplication sharedApplication].keyWindow insertSubview:view atIndex:0];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:0]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    
    UIColor *colorOne = [UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:0.3];
    UIColor *colorTwo = [UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = CGRectMake(0, -20, ScreenWidth, 64);
    self.layer = headerLayer;
    [self.navigationController.navigationBar.layer insertSublayer:headerLayer atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addshoppingCar) name:@"addShoppingCar" object:nil];
    
    if (!self.changeTableViewFrame) {
        self.mainScrollView.frame =CGRectMake(0, 64, ScreenWidth, ScreenHeight-PX_TO_PT(80));
    }
    else
    {
        self.changeTableViewFrame = NO;
    }
    
    if ([self.navigationItem.title isEqualToString:@"商品详情"]) {
        //        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_navbg"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:1]];
        
        _webView.frame = CGRectMake(0, ScreenHeight+PX_TO_PT(80)+64, ScreenWidth, ScreenHeight-PX_TO_PT(160)-PX_TO_PT(80)-PX_TO_PT(40));
        _midView.frame = CGRectMake(0, ScreenHeight+64, ScreenWidth, PX_TO_PT(80));
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    if (!_is_loading) {
        if (offset_Y > Max_OffsetY)
        {
            CGFloat alpha = MIN(1, 1 - ((Max_OffsetY + INVALID_VIEW_HEIGHT - offset_Y) / INVALID_VIEW_HEIGHT));
            
            [self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:alpha]];
            
            self.navigationItem.title = @"商品详情";
            //            self.title = alpha > 0.8? @"商品详情":@"";
        }
        else
        {
            self.navigationItem.title = @"";
            
            [self.navigationController.navigationBar ps_setBackgroundColor:[NavigationBarBGColor colorWithAlphaComponent:0]];
            
        }
        
    }
}


- (void)setNavigationbarTitle{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);
    
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton*shopcarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    shopcarButton.frame=CGRectMake(0, 0, 30, 30);
    self.shopcarButton = shopcarButton;
    [shopcarButton addTarget:self action:@selector(shopcarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [shopcarButton setImage:[UIImage imageNamed:@"icon_shopcar_white"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:shopcarButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)setNavigationbarTitlehh{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"商品详情";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);
    
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton*shopcarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    shopcarButton.frame=CGRectMake(0, 0, 30, 30);
    [shopcarButton addTarget:self action:@selector(shopcarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [shopcarButton setImage:[UIImage imageNamed:@"icon_shopcar_white"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:shopcarButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)backClick{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shopcarButtonClick
{
    XNRTabBarController *tab = (XNRTabBarController *)self.tabBarController;
    tab.selectedIndex = 2;
    CATransition *myTransition=[CATransition animation];
    myTransition.duration=0.3;
    myTransition.type= @"fade";
    [tab.view.superview.layer addAnimation:myTransition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)synchShoppingCarDataWith:(XNRShoppingCartModel *)model
{
    NSString *goodsId;
    if (model) {
        goodsId = model.goodsId;
    } else {
        goodsId = self.model.goodsId;
    }
    [KSHttpRequest post:KAddToCart parameters:@{@"goodsId":goodsId,@"userId":[DataCenter account].userid,@"count":self.numTextField.text,@"update_by_add":@"true",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        NSLog(@"%@",result);
        if([result[@"code"] integerValue] == 1000){
            
            [UILabel showMessage:@"加入购物车成功"];
            [BMProgressView LoadViewDisappear:self.view];
        }else {
            [UILabel showMessage:result[@"message"]];
            [BMProgressView LoadViewDisappear:self.view];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}
#pragma mark - MWPhotoBrowser的代理
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [_picBrowserList count];
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    return _picBrowserList[index];
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    return [NSString stringWithFormat:@"%ld/%ld",(long)index+1,(long)[_picBrowserList count]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
