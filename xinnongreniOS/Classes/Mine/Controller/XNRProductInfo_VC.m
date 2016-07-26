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
#define kLeftBtn  3000
#define kRightBtn 4000
#define HEIGHT 100


#define KbtnTag 1000
#define KlabelTag 2000
@interface XNRProductInfo_VC ()<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,XNRProductInfo_cellDelegate,XNRToolBarBtnDelegate,UIScrollViewDelegate,MWPhotoBrowserDelegate>{
    CGRect oldTableRect;
    CGFloat preY;
    NSMutableArray *_goodsArray;
    NSString *_Price;
    NSString *_marketPrice;
    NSMutableArray *_infoModelArray;

}
@property (nonatomic, strong) UIScrollView *scrollView;
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
@end

@implementation XNRProductInfo_VC

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
    
    [_numTextField resignFirstResponder];
    
    if (self.navigationController.childViewControllers.count-1 > [self.navigationController.childViewControllers indexOfObject:self]) {
        
    } else {
        [[XNRPropertyView sharedInstanceWithModel:self.model] changeSelfToIdentify];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.webView];
    
    
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
    
    NSLog(@"navigation===%@",self.navigationController);
    
    
}

-(void)notSelectedAttributes
{
    [[XNRPropertyView sharedInstanceWithModel:self.model] changeSelfToIdentify];
}


-(void)loadMoreData{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scrollView.contentOffset = CGPointMake(0, ScreenHeight);
    } completion:^(BOOL finished) {
        //结束加载
        [self.tableView.mj_footer endRefreshing];
    }];

}
-(void)loadNewData{
    //下拉执行对应的操作
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
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
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
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
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, ScreenHeight+PX_TO_PT(80), ScreenWidth, ScreenHeight-PX_TO_PT(160)-64)];
        _webView.backgroundColor = R_G_B_16(0xf2f2f2);
    }
    return _webView;
}


-(void)createWebView
{
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(80))];
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
        dividedLine.backgroundColor = R_G_B_16(0xc7c7c7);
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
        [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:frameModel.infoModel.app_body_url]];
        [self.webView loadRequest:request];
        [BMProgressView LoadViewDisappear:self.view];
        
    }else if (button.tag == KbtnTag + 1)
    {
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
        
        [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:frameModel.infoModel.app_standard_url]];
        [self.webView loadRequest:request];
        [BMProgressView LoadViewDisappear:self.view];
        
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
        
        [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:frameModel.infoModel.app_support_url]];
        [self.webView loadRequest:request];
        [BMProgressView LoadViewDisappear:self.view];
    }
}

-(void)createTableView:(NSMutableArray *)infoModelArray{
    _infoModelArray = infoModelArray;
    XNRProductInfo_frame *frame = [infoModelArray lastObject];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.viewHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark-获取网络数据
-(void)getData {
    [KSHttpRequest post:KHomeGetAppProductDetails parameters:@{@"productId":_model.goodsId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        [BMProgressView showCoverWithTarget:self.view color: nil isNavigation:YES];

        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dic =result[@"datas"];
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
        }
        XNRProductInfo_frame *frame = [_goodsArray lastObject];
        if ([frame.infoModel.app_body_url isEqualToString:@""] &&[frame.infoModel.app_standard_url isEqualToString:@""] && [frame.infoModel.app_support_url isEqualToString:@""]) {
                _tableView.scrollEnabled = NO;
            }
        
        [self.tableView reloadData];
        [BMProgressView LoadViewDisappear:self.view];
    } failure:^(NSError *error) {
        [BMProgressView LoadViewDisappear:self.view];
    }];
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
    
    
    UIView *bgExpectView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-64-PX_TO_PT(80), ScreenWidth, PX_TO_PT(80))];
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
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [bgExpectView addSubview:lineView];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-PX_TO_PT(80), ScreenWidth, PX_TO_PT(80))];
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
    line.backgroundColor=R_G_B_16(0xc7c7c7);
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
    [self.propertyView show:XNRAddCartType];
    _bottomBtnClick = YES;

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

- (void)setNavigationbarTitle{
    
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

@end
