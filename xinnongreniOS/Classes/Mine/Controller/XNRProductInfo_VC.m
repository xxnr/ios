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
#import "CoreTFManagerVC.h"
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
#define kLeftBtn  3000
#define kRightBtn 4000
#define HEIGHT 100
@interface XNRProductInfo_VC ()<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,XNRProductInfo_cellDelegate,XNRToolBarBtnDelegate,UIScrollViewDelegate>{
    CGRect oldTableRect;
    CGFloat preY;
    NSMutableArray *_goodsArray;
    NSString *_Price;
    NSString *_marketPrice;
    NSMutableArray *_infoModelArray;

}
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,weak) UIImageView *headView;
@property(nonatomic,weak) UITextField *numTextField;

@property (nonatomic,weak) UIButton *buyBtn;   // 立即购买
@property(nonatomic,weak) UIButton*addBuyCarBtn; // 加入购物车
@property(nonatomic,weak) UIButton *rightBtn;
@property(nonatomic,weak) UIButton *leftBtn;

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

@end

@implementation XNRProductInfo_VC

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
        NSLog(@"self.model%@",self.model);
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
    [[XNRPropertyView sharedInstanceWithModel:self.model] changeSelfToIdentify];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:self.numTextField inputView:nil name:@"" insetBottom:0];
        
        return @[tfm1];
        
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
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
//    [self.view addSubview:self.scrollView];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    if ([self.numTextField.text isEqualToString:@"0"] || [self.numTextField.text isEqualToString:@""]) {
        self.numTextField.text = @"1";
    }

}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight * 2);
//        _scrollView.backgroundColor = [UIColor redColor];
        //设置分页效果
        _scrollView.pagingEnabled = YES;
        //禁用滚动
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
// 结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    XNRProductInfo_frame *frameModel = [_infoModelArray lastObject];
    
    if (self.tableView.y > frameModel.viewHeight) {
        self.tableView.pagingEnabled = YES;
        
    }else{
        self.tableView.contentOffset = CGPointMake(0, frameModel.viewHeight-(ScreenHeight-64-PX_TO_PT(80)));
        
    }

   
}

//将开始降速时
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
{

}


-(void)XNRProductInfo_cellScroll
{
    CGPoint point = self.tableView.contentOffset;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.contentOffset = CGPointMake(point.x, 0);
    }];
}
#pragma mark-获取网络数据
-(void)getData {
    NSLog(@"_model.goodsId===%@",_model.goodsId);
    [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
    [KSHttpRequest post:KHomeGetAppProductDetails parameters:@{@"productId":_model.goodsId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        [BMProgressView LoadViewDisappear:self.view];
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dic =result[@"datas"];
            XNRProductInfo_model *model = [[XNRProductInfo_model alloc] init];
            
            model.min = dic[@"SKUPrice"][@"min"];
            model.max = dic[@"SKUPrice"][@"max"];
            
            model.marketMin = dic[@"SKUMarketPrice"][@"min"];
            model.marketMax = dic[@"SKUMarketPrice"][@"max"];

            model._id = dic[@"_id"];
            
            model.online = _model.online;
            
            [model setValuesForKeysWithDictionary:dic];
            
            model.pictures = (NSMutableArray *)[XNRProductPhotoModel objectArrayWithKeyValuesArray:dic[@"pictures"]];
            model.SKUAttributes =  (NSMutableArray *)[XNRSKUAttributesModel objectArrayWithKeyValuesArray:dic[@"SKUAttributes"]];
            XNRProductInfo_frame *frame = [[XNRProductInfo_frame alloc] init];
            // 把商品详情的model传给frame
            frame.infoModel = model;
            
            [_goodsArray addObject:frame];
            [self createTableView:_goodsArray];
            // 判断一下从主页还是从购物车进入的详情页（加载不同的视图）
            if (_isFrom) {
                if ([_model.online integerValue] == 0) {
                    [self createonlineView];
                }else{
                    [self createBottomView];

                }
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
        [self.tableView reloadData];
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
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
    addBuyCarBtn.backgroundColor = R_G_B_16(0xfe9b00);
    [addBuyCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBuyCarBtn.titleLabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    self.addBuyCarBtn = addBuyCarBtn;
    [bgView addSubview:addBuyCarBtn];
    
    //分割线
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,PX_TO_PT(1) )];
    line.backgroundColor=R_G_B_16(0xc7c7c7);
    [bgView addSubview:line];
    
}
#pragma mark - 立即购买
-(void)buyBtnClick
{
    NSLog(@"-==++++++===%@",self.propertyView);

    [self.propertyView show:XNRFirstType];
    
}
#pragma mark-加入购物车
-(void)addBuyCar
{
    NSLog(@"-==------===%@",self.propertyView);

    [self.propertyView show:XNRSecondType];
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
    return frame.viewHeight*2;
    
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 传值
    XNRProductInfo_frame *frame = _goodsArray[indexPath.row];
    cell.infoFrame = frame;
//    [cell upDataWithModel:_goodsArray[indexPath.row]];
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
    login.hidesBottomBarWhenPushed = YES;
    [weakSelf.navigationController pushViewController:login animated:YES];
    };
    cell.delegate = self;
    return cell;
}

- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"商品详情";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
