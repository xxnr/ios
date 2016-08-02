//
//  XNRMyRepresentViewController.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/13.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyRepresentViewController.h"
#import "XNRMyRepresentView.h"
#import "XNRMyRepresentModel.h"
#import "XNRMyRepresent_cell.h"
#import "XNRCustomerOrderController.h"
#import "myAlertView.h"
#import "XNRBookUser.h"
#import "XNRUser_Cell.h"
#import "XNRAddLatentUserVC.h"
#import "XNRDetailUserVC.h"
#import "BMProgressView.h"

#define btnTag 1000
#define tbTag 2000

#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_IPhone6 (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhone6plus (736 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)

@interface XNRMyRepresentViewController ()<UITableViewDelegate,UITableViewDataSource,XNRMyRepresentViewAddBtnDelegate,LumAlertViewDelegate>
{
    NSMutableArray *_dataArr;
//    int currentPage;
//    int registerCurrentPage;
    UITableView *currentTableView;
}

@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic,weak) UIButton *bookBtn;
@property (nonatomic, weak) UIButton *selectedBtn; // 临时button

@property (nonatomic, strong) XNRMyRepresentView *mrv;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) UILabel *customerLabel;

@property (nonatomic, weak) UILabel *myRepLabel;

@property (nonatomic, weak) UILabel *nickNameLabel;

@property (nonatomic, copy) NSString *phoneNum;

@property (nonatomic, weak) UIView *myRepView;

@property (nonatomic, weak) UIView *headView;

@property (nonatomic ,weak) UIView *topView;

//我的代表
@property (nonatomic,weak) UIView *middleView;

@property (nonatomic ,weak) UIView *myRepTopView;

@property (nonatomic,weak) UIImageView *sexImage;

@property (nonatomic,weak) UILabel *rep_userType;
@property (nonatomic,weak) UILabel *rep_address;
@property (nonatomic,weak) UILabel *rep_phone;
@property (nonatomic,weak) UIImageView *rep_badge;

@property (nonatomic ,weak) UILabel *phoneNumLabel;

@property (nonatomic ,weak) UILabel *headLabel;

@property (nonatomic, copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,strong)myAlertView *myAlert;
@property (nonatomic,weak)UIView *firstView;
@property (nonatomic,weak)UIView *secondView;
@property (nonatomic,weak) UIView *thirdView;
@property (nonatomic,weak) UIView *BookView;
@property (nonatomic,weak) UITableView *tableView2;
@property (nonatomic,strong)NSMutableArray *userArr;
@property (nonatomic,weak)UILabel *bookTopTotalLabel;
@property (nonatomic,weak)UILabel *bookTopRemainLabel;
@property (nonatomic,weak) UIView *coverView;
@property (nonatomic,weak)UIView *bgview;
@property (nonatomic,weak) UIButton *addbtn;
@property (nonatomic,weak)UIView *circleView;
@property (nonatomic ,weak) BMProgressView *progressView;
@property (nonatomic,assign)BOOL isadd;
@property (nonatomic,assign)BOOL isfirst;
@property (nonatomic,assign)BOOL isFirstTableView;
@property (nonatomic,assign)BOOL isuserDetail;

@property (nonatomic,strong) NSMutableArray *customer_indexTitleArr;
@property (nonatomic,strong) NSMutableArray *Rep_indexTitleArr;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (nonatomic,weak) UIView *sv;
@property (nonatomic,strong)NSString *rep_totalCount;
@end

@implementation XNRMyRepresentViewController
static bool isBroker;
- (NSMutableArray *)customer_indexTitleArr
{
    if (_customer_indexTitleArr == nil)
    {
        _customer_indexTitleArr = [NSMutableArray array];
    }
    return _customer_indexTitleArr;
}
- (NSMutableArray *)Rep_indexTitleArr
{
    if (_Rep_indexTitleArr == nil)
    {
        _Rep_indexTitleArr = [NSMutableArray array];
    }
    return _Rep_indexTitleArr;
}



-(BMProgressView *)progressView{
    if (!_progressView) {
        BMProgressView *progressView = [[BMProgressView alloc] init];
        self.progressView = progressView;
        [self.view addSubview:progressView];
    }
    return _progressView;
}

+(void)SetisBroker:(BOOL)broker
{
    isBroker = broker;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_isadd) {
        [self creatBookView];
        [self.userArr removeAllObjects];
        [self rep_isUpdata];
        currentTableView = self.tableView2;
    }
    else if (_isuserDetail) {
        currentTableView = self.tableView2;
    }
    else
    {
        currentTableView = self.tableView;
    }
    
    [self setupCustomerRefresh];

}

-(void)viewDidDisappear:(BOOL)animated
{
    if (_isadd) {
        [self.thirdView removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isfirst = YES;
    _userArr = [NSMutableArray array];
    _dataArr = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = R_G_B_16(0xfafafa);
    [self setNavigationbarTitle];
    [self setBottomButton];
    [self createTableView];
    [self createCustomerLabel];

    [_dataArr removeAllObjects];
    [self getCustomerData];
    currentTableView = self.tableView;

}

-(void)removeRedPoint
{
    [_dataArr removeAllObjects];
    [self getCustomerData];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 刷新

-(void)setupCustomerRefresh{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    
    NSMutableArray *idleImage = [NSMutableArray array];
    
    
    
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

    currentTableView.mj_header = header;

}

-(void)headRefresh{
    
    if (currentTableView.tag == tbTag) {
        [_dataArr removeAllObjects];
        [_customer_indexTitleArr removeAllObjects];
        [self getCustomerData];
    }
    else
    {
        [_userArr removeAllObjects];
        [_Rep_indexTitleArr removeAllObjects];
        
        [self bookViewGetData];
    }
}

#pragma mark -  导航
-(void)setNavigationbarTitle
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = R_G_B_16(0xffffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"新农代表";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0,0,30,44);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -  底部按钮

-(void)setBottomButton
{
    CGFloat btnW = ScreenWidth * 0.5;
    CGFloat btnH = PX_TO_PT(98);
    CGFloat btnY = ScreenHeight - btnH - 64;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, btnY, btnW, btnH);
    [leftBtn setTitle:@"我的客户" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"list_huise"] forState:UIControlStateNormal];
    [leftBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"list_baise"] forState:UIControlStateSelected];
    [leftBtn setTitleColor:R_G_B_16(0xffffff) forState:UIControlStateSelected];
    [leftBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateSelected];
    [leftBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"FFFFFF"]] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [leftBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = btnTag;
    leftBtn.selected = YES;
    self.leftBtn = leftBtn;
    [self.view addSubview:_leftBtn];
    

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightBtn;
    _rightBtn.frame = CGRectMake(btnW, btnY, btnW, btnH);
    [_rightBtn setTitle:@"我的代表" forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"huise"] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"baise"] forState:UIControlStateSelected];
    [_rightBtn setTitleColor:R_G_B_16(0xffffff) forState:UIControlStateSelected];
    [_rightBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateSelected];
    [_rightBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"FFFFFF"]] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_rightBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.tag = btnTag + 1;
    [self.view addSubview:_rightBtn];
    

    UIButton *bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bookBtn = bookBtn;
    _bookBtn.frame = CGRectMake(CGRectGetMaxX(self.rightBtn.frame), btnY, ScreenWidth/3, btnH);
    [_bookBtn setTitle:@"客户登记" forState:UIControlStateNormal];
    [_bookBtn setImage:[UIImage imageNamed:@"customer2"] forState:UIControlStateNormal];
    [_bookBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [_bookBtn setImage:[UIImage imageNamed:@"customer"] forState:UIControlStateSelected];
    [_bookBtn setTitleColor:R_G_B_16(0xffffff) forState:UIControlStateSelected];
    [_bookBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateSelected];
    [_bookBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"FFFFFF"]] forState:UIControlStateNormal];
    _bookBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    _bookBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_bookBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _bookBtn.tag = btnTag + 2;
    _bookBtn.hidden = YES;
    [self.view addSubview:_bookBtn];
    
    self.selectedBtn = _leftBtn;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, btnH)];
    line2.backgroundColor = R_G_B_16(0xe0e0e0);
    [self.bookBtn addSubview:line2];

    if (isBroker) {
        _bookBtn.hidden = NO;
        self.leftBtn.frame = CGRectMake(0, btnY, ScreenWidth/3, btnH);
        self.rightBtn.frame = CGRectMake(CGRectGetMaxX(self.leftBtn.frame), btnY, ScreenWidth/3, btnH);
        self.bookBtn.frame = CGRectMake(CGRectGetMaxX(self.rightBtn.frame), btnY, ScreenWidth/3, btnH);
    }
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame)-1, 0, PX_TO_PT(2), btnH)];
    line1.backgroundColor = R_G_B_16(0xe0e0e0);
    [self.leftBtn addSubview:line1];

}

- (void)bottomBtnClicked:(UIButton *)sender {
    
    if (self.selectedBtn.tag == sender.tag) {
        return;
    }
    [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    [self.customer_indexTitleArr removeAllObjects];
    if (sender.tag == btnTag) {
        
        [_dataArr removeAllObjects];
        self.isadd = NO;
        self.isuserDetail = NO;
        _tableView.hidden = NO;
        
        [self.middleView removeFromSuperview];
        [self.thirdView removeFromSuperview];
        [self.mrv removeFromSuperview];
        
        [self getCustomerData];
        currentTableView = self.tableView;
        
        self.isFirstTableView = YES;
    } else if(sender.tag == btnTag + 1){
        self.isFirstTableView = NO;
        self.isadd = NO;
        self.isuserDetail = NO;
        
        _tableView.hidden = YES;
        self.topView.hidden = YES;
        [self.thirdView removeFromSuperview];
        
        [self createMrv];
        [self createMyRepresentUI];
        
        [self getrepresent];
        
    }
    else if(sender.tag == btnTag + 2)
    {
        self.isFirstTableView = NO;
        _tableView.hidden = YES;
        self.topView.hidden = YES;
        
        self.mrv.hidden = YES;
        [self.middleView removeFromSuperview];
        [self.thirdView removeFromSuperview];
        [self.mrv removeFromSuperview];
        
        [self.userArr removeAllObjects];
        [self creatBookView];
        [self rep_isUpdata];
        currentTableView = self.tableView2;
    }
    
    [self setupCustomerRefresh];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [BMProgressView LoadViewDisappear:self.view];
    });

}
-(void)getrepresent
{
    [KSHttpRequest get:KGetInviter parameters:nil success:^(id result) {
        if ([result[@"code"] integerValue]==1000) {
            
            self.topView.hidden = YES;
            
            self.phoneNum = result[@"datas"][@"inviterPhone"];
            
            if (self.phoneNum && self.phoneNum.length>0) {
                [self.mrv removeFromSuperview];
                self.middleView.hidden = NO;
                self.myRepLabel.text = result[@"datas"][@"inviterName"]?result[@"datas"][@"inviterName"]:@"好友未填姓名";
                CGSize size = [self.myRepLabel.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(40)] constrainedToSize:CGSizeMake(ScreenWidth, MAXFLOAT)];
                
                self.myRepLabel.frame =CGRectMake(0, 0, size.width, size.height);
                self.sexImage.image = [result[@"datas"][@"inviterSex"] boolValue] == true?[UIImage imageNamed:@"girl1-ico"]:[UIImage imageNamed:@"boy1-ico"];
                self.sexImage.frame = CGRectMake(CGRectGetMaxX(self.myRepLabel.frame)+PX_TO_PT(19), PX_TO_PT(5), PX_TO_PT(35), PX_TO_PT(35));
        
                CGFloat topWidth = self.myRepLabel.width + self.sexImage.size.width+PX_TO_PT(19);
                CGRect rect = self.myRepTopView.frame;
                rect.size.width = topWidth;
                self.myRepTopView.frame = rect;
                CGPoint center = self.myRepTopView.center;
                center.x = self.view.frame.size.width/2;
                self.myRepTopView.center = center;
                
                self.rep_userType.text =result[@"datas"][@"inviterUserTypeInName"];
                
                self.rep_badge.hidden = YES;
                if ([result[@"datas"][@"inviterVerifiedTypes"] containsObject:result[@"datas"][@"inviterUserType"] ]) {
                    self.rep_badge.hidden = NO;
                }
                NSDictionary *address =result[@"datas"][@"inviterAddress"];
                NSString *province = [NSString stringWithFormat:@"%@  ",address[@"province"][@"name"]];
                NSString *city = [NSString stringWithFormat:@"%@  ",address[@"city"][@"name"]];
                NSString *county = [NSString stringWithFormat:@"%@  ",address[@"county"][@"name"]];
                NSString *town = [NSString stringWithFormat:@"%@",address[@"town"][@"name"]];

                self.rep_address.text = [NSString stringWithFormat:@"%@%@%@%@",address[@"province"][@"name"]?province:@"",address[@"city"][@"name"]?city:@"",address[@"county"][@"name"]?county:@"",address[@"town"][@"name"]?town:@""];
                
                self.rep_phone.text = _phoneNum;
                
            } else {
                [self.middleView removeFromSuperview];
                
                if (self.isfirst) {
                    [self getNominatedInviter];
                }
                self.isfirst = NO;
                
                self.mrv.hidden = NO;
            }
        }else if ([result[@"code"] integerValue]== 1401){
            
            [UILabel showMessage:result[@"message"]];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            //发送刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PageRefresh" object:nil];
            
            XNRLoginViewController *vc = [[XNRLoginViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)createMrv
{
    [self.mrv removeFromSuperview];
    
    XNRMyRepresentView *mrv = [[XNRMyRepresentView alloc] init];
    mrv.delegate = self;
    self.mrv = mrv;
    self.mrv.hidden = YES;
    [self.view addSubview:mrv];
    
    XNRMyRepresentViewDataModel *mrvData = [[XNRMyRepresentViewDataModel alloc] init];
    XNRMyRepresentViewFrame *mrvF = [[XNRMyRepresentViewFrame alloc] init];
    mrvF.model = mrvData;
    mrv.viewF = mrvF;
    mrv.frame = CGRectMake(0, (self.view.bounds.size.height-mrvF.viewH)*0.3, ScreenWidth, mrvF.viewH);

}
-(void)creatBookView
{

    //添加顶部视图
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(98))];
    thirdView.backgroundColor = [UIColor clearColor];
    self.thirdView = thirdView;
    
    UIView *BooktopView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(220))];
    BooktopView.backgroundColor = [UIColor whiteColor];
    [self.thirdView addSubview:BooktopView];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(140))];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.hidden = YES;
    self.bgview = bgview;
    [self.view addSubview:bgview];

    
    UILabel *top1Label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(29), ScreenWidth/2, PX_TO_PT(32))];
    top1Label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    top1Label.textColor =R_G_B_16(0x646464);
    self.bookTopTotalLabel = top1Label;
    [BooktopView addSubview:top1Label];
    
    UILabel *top2Label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), CGRectGetMaxY(top1Label.frame) + PX_TO_PT(18), ScreenWidth/2, PX_TO_PT(33))];
    top2Label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    top2Label.textColor = R_G_B_16(0x646464);
    self.bookTopRemainLabel = top2Label;
    [BooktopView addSubview:top2Label];
    
    if (IS_IPHONE4 || IS_IPHONE5) {
        top1Label.frame = CGRectMake(PX_TO_PT(33), PX_TO_PT(15), ScreenWidth/2, PX_TO_PT(32));
        top2Label.frame = CGRectMake(PX_TO_PT(33), CGRectGetMaxY(top1Label.frame)+PX_TO_PT(10), ScreenWidth/2, PX_TO_PT(32));
        top1Label.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        top2Label.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
 
    }


    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(80)-PX_TO_PT(34), PX_TO_PT(29),PX_TO_PT(80), PX_TO_PT(80))];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"6add-orange"] forState:UIControlStateNormal];

    [addBtn addTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.layer.cornerRadius = PX_TO_PT(80)/2;
    addBtn.layer.masksToBounds = YES;
    self.addbtn = addBtn;
    [BooktopView addSubview:addBtn];
    
    if (IS_IPHONE4) {
        BooktopView.frame = CGRectMake(0, PX_TO_PT(14), ScreenWidth, PX_TO_PT(100));
        bgview.frame = CGRectMake(0, PX_TO_PT(14), ScreenWidth, PX_TO_PT(100));
       
        addBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(64)-PX_TO_PT(34),  (PX_TO_PT(100)-PX_TO_PT(64))/2,PX_TO_PT(64), PX_TO_PT(64));
        addBtn.layer.cornerRadius = PX_TO_PT(64)/2;

    }
    else if (IS_IPHONE5){
        BooktopView.frame = CGRectMake(0, PX_TO_PT(14), ScreenWidth, PX_TO_PT(100));
        bgview.frame =CGRectMake(0, PX_TO_PT(14), ScreenWidth, PX_TO_PT(100));
        addBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(64)-PX_TO_PT(34), (PX_TO_PT(100)-PX_TO_PT(64))/2,PX_TO_PT(64), PX_TO_PT(64));
        addBtn.layer.cornerRadius = PX_TO_PT(64)/2;

    }
    else if (IS_IPhone6){
        BooktopView.frame = CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(140));
        bgview.frame = CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(140));
        addBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(80)-PX_TO_PT(34),  (PX_TO_PT(140)-PX_TO_PT(80))/2,PX_TO_PT(80), PX_TO_PT(80));
        addBtn.layer.cornerRadius = PX_TO_PT(80)/2;

    }
    else if (IS_IPhone6plus){
        BooktopView.frame = CGRectMake(0, PX_TO_PT(30), ScreenWidth, PX_TO_PT(150));
        bgview.frame = CGRectMake(0, PX_TO_PT(30), ScreenWidth, PX_TO_PT(150));
        addBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(96)-PX_TO_PT(34),  (PX_TO_PT(150)-PX_TO_PT(96))/2,PX_TO_PT(96), PX_TO_PT(96));
        addBtn.layer.cornerRadius = PX_TO_PT(96)/2;

    }
    
    UIView *top2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(BooktopView.frame)+PX_TO_PT(19), ScreenWidth, PX_TO_PT(80))];
    top2.backgroundColor = [UIColor whiteColor];
    [self.thirdView addSubview:top2];
    
    UILabel *top3Label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(25), PX_TO_PT(200), PX_TO_PT(32))];
    top3Label.text = @"已登记客户";
    top3Label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    top3Label.textColor = R_G_B_16(0x323232);
    [top2 addSubview:top3Label];
    
    
    UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(top2.frame), ScreenWidth, ScreenHeight - 64 - PX_TO_PT(98) - CGRectGetMaxY(top2.frame)) style:UITableViewStylePlain];
    tableView2.backgroundColor = [UIColor clearColor];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView2.sectionIndexColor = R_G_B_16(0x909090);
    tableView2.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView2 = tableView2;
    _tableView2.tag = tbTag + 1;
    [self.thirdView addSubview:tableView2];
    
    [self.view addSubview:self.thirdView];
    
//    [self bookViewGetData];

}
-(void)addUser:(UIButton *)sender
{
    self.isadd = YES;
    XNRAddLatentUserVC *addLatentUser = [[XNRAddLatentUserVC alloc]init];
    [self.navigationController pushViewController:addLatentUser animated:YES];
}
-(void)rep_isUpdata
{
    self.rep_totalCount = @12;
    [KSHttpRequest get:KGetIsLatest parameters:@{@"count":self.rep_totalCount} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            self.rep_totalCount = result[@"count"];
            if([result[@"count"]integerValue] == 0){
                BOOL isadd = [[NSUserDefaults standardUserDefaults]boolForKey:@"key"];
                if (isadd == NO) {
                    self.thirdView.hidden = YES;
                    self.bgview.hidden = NO;
                    self.circleView.hidden = NO;
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(40), ScreenWidth, ScreenHeight-PX_TO_PT(40))];
                    UIColor *color = [UIColor blackColor];
                    view.backgroundColor = [color colorWithAlphaComponent:0.6];
                    
                    UIImageView *iamgeview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, view.height)];
                    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(80)-PX_TO_PT(26),PX_TO_PT(29), PX_TO_PT(80), PX_TO_PT(80))];
                    coverView.backgroundColor = [UIColor whiteColor];
                    coverView.layer.cornerRadius = PX_TO_PT(80)/2;
                    coverView.layer.masksToBounds = YES;
                    coverView.alpha = 1;
                    self.circleView.hidden = YES;
                    self.circleView = coverView;
                    
                    UIButton *addbtn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(8), PX_TO_PT(8),PX_TO_PT(80), PX_TO_PT(80))];
                    [addbtn setBackgroundImage:[[UIImage imageNamed:@"6add-orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    addbtn.enabled = NO;
                    addbtn.layer.cornerRadius = PX_TO_PT(80)/2;
                    addbtn.layer.masksToBounds = YES;
                    [self.circleView addSubview:addbtn];
                    
                    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(262), PX_TO_PT(630), PX_TO_PT(197), PX_TO_PT(100))];
                    [btn addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    if (IS_IPHONE4) {
                        UIImage *image = [UIImage imageNamed:@"text_icon-4"];
                        
                        [iamgeview setImage:image];
                        coverView.frame = CGRectMake(ScreenWidth-PX_TO_PT(80)-PX_TO_PT(26),  PX_TO_PT(128)+PX_TO_PT(8),PX_TO_PT(80), PX_TO_PT(80));
                        iamgeview.frame = CGRectMake((ScreenWidth-image.size.width)/2, CGRectGetMaxY(coverView.frame), image.size.width,image.size.height);
                        addbtn.frame = CGRectMake(PX_TO_PT(8),  PX_TO_PT(8),PX_TO_PT(64), PX_TO_PT(64));
                        btn.frame = CGRectMake(PX_TO_PT(262), PX_TO_PT(550), PX_TO_PT(197), PX_TO_PT(100));
                        
                        addbtn.layer.cornerRadius = PX_TO_PT(64)/2;
                        coverView.layer.cornerRadius = PX_TO_PT(80)/2;
                        
                    }
                    else if (IS_IPHONE5){
                        UIImage *image = [UIImage imageNamed:@"text-_icon5"];
                        [iamgeview setImage:image];
                        coverView.frame = CGRectMake(ScreenWidth-PX_TO_PT(80)-PX_TO_PT(26),    PX_TO_PT(128)+PX_TO_PT(8),PX_TO_PT(80), PX_TO_PT(80));
                        iamgeview.frame = CGRectMake((ScreenWidth-image.size.width)/2, CGRectGetMaxY(coverView.frame), image.size.width,image.size.height);
                        addbtn.frame = CGRectMake(PX_TO_PT(8), PX_TO_PT(8),PX_TO_PT(64), PX_TO_PT(64));
                        btn.frame = CGRectMake(PX_TO_PT(262), PX_TO_PT(630), PX_TO_PT(197), PX_TO_PT(100));
                        
                        addbtn.layer.cornerRadius = PX_TO_PT(64)/2;
                        coverView.layer.cornerRadius = PX_TO_PT(80)/2;
                        
                        
                    }
                    else if (IS_IPhone6){
                        UIImage *image = [UIImage imageNamed:@"text_icon6"];
                        [iamgeview setImage:image];
                        coverView.frame = CGRectMake(ScreenWidth-PX_TO_PT(100)-PX_TO_PT(26),PX_TO_PT(128)+PX_TO_PT(8),PX_TO_PT(96), PX_TO_PT(96));
                        iamgeview.frame = CGRectMake((ScreenWidth-image.size.width)/2, CGRectGetMaxY(coverView.frame), image.size.width,image.size.height);
                        addbtn.frame = CGRectMake(PX_TO_PT(8), PX_TO_PT(8),PX_TO_PT(80), PX_TO_PT(80));
                        btn.frame = CGRectMake(PX_TO_PT(262), PX_TO_PT(630), PX_TO_PT(197), PX_TO_PT(100));
                        
                        addbtn.layer.cornerRadius = PX_TO_PT(80)/2;
                        coverView.layer.cornerRadius = PX_TO_PT(96)/2;
                        
                        
                    }
                    else if (IS_IPhone6plus){
                        UIImage *image = [UIImage imageNamed:@"text_icon6p"];
                        [iamgeview setImage:image];
                        coverView.frame = CGRectMake(ScreenWidth-PX_TO_PT(112)-PX_TO_PT(26),    PX_TO_PT(128)+PX_TO_PT(8),PX_TO_PT(112), PX_TO_PT(112));
                        iamgeview.frame = CGRectMake((ScreenWidth-image.size.width)/2, CGRectGetMaxY(coverView.frame), image.size.width,image.size.height);
                        addbtn.frame = CGRectMake(PX_TO_PT(8), PX_TO_PT(8),PX_TO_PT(96), PX_TO_PT(96));
                        btn.frame = CGRectMake(PX_TO_PT(262), PX_TO_PT(700), PX_TO_PT(197), PX_TO_PT(100));
                        
                        addbtn.layer.cornerRadius = PX_TO_PT(96)/2;
                        coverView.layer.cornerRadius = PX_TO_PT(112)/2;
                    }
                    iamgeview.contentMode = UIViewContentModeScaleAspectFit;
                    [view addSubview:iamgeview];
                    
                    [view addSubview:coverView];
                    
                    [view addSubview:btn];
                    
                    
                    self.coverView = view;
                    UIWindow *window = [[UIApplication sharedApplication].delegate window];
                    [window addSubview:view];
                    
                    
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"key"];
                }
            }
            
            if ([result[@"countLeftToday"] integerValue] < 1) {
                
                if (IS_IPHONE4) {
                    [self.addbtn setBackgroundImage:[UIImage imageNamed:@"4add-gray"] forState:UIControlStateNormal];
                }
                else if (IS_IPHONE5){
                    [self.addbtn setBackgroundImage:[UIImage imageNamed:@"5add-gray"] forState:UIControlStateNormal];
                }
                else if (IS_IPhone6){
                    [self.addbtn setBackgroundImage:[UIImage imageNamed:@"6add-gray"] forState:UIControlStateNormal];
                }
                else if (IS_IPhone6plus){
                    [self.addbtn setBackgroundImage:[UIImage imageNamed:@"add-orange"] forState:UIControlStateNormal];
                }
                
                self.addbtn.enabled = NO;
            }
            else
            {
                if (IS_IPHONE4) {
                    [self.addbtn setBackgroundImage:[UIImage imageNamed:@"4add-orange"] forState:UIControlStateNormal];
                }
                else if (IS_IPHONE5){
                    [self.addbtn setBackgroundImage:[UIImage imageNamed:@"5add-orange"] forState:UIControlStateNormal];
                }
                else if (IS_IPhone6){
                    [self.addbtn setBackgroundImage:[UIImage imageNamed:@"6add-orange"] forState:UIControlStateNormal];
                }
                else if (IS_IPhone6plus){
                    [self.addbtn setBackgroundImage:[UIImage imageNamed:@"add-orange"] forState:UIControlStateNormal];
                }
                
                self.addbtn.enabled = YES;
            }
            

            
            
            self.bookTopTotalLabel.text = [NSString stringWithFormat:@"共登记%@名客户",result[@"count"]];
            self.bookTopRemainLabel.text = [NSString stringWithFormat:@"今日还可添加%@名",result[@"countLeftToday"]];
            
            
            if (self.bookTopTotalLabel) {
                
                NSString *total = [NSString stringWithFormat:@"%@",result[@"count"]];
                NSString *remain = [NSString stringWithFormat:@"%@",result[@"countLeftToday"]];
                
                if (IS_IPHONE4 || IS_IPHONE5) {
                    [self setbookTopTotalLabelDifFontandlength:total.length andFont:[UIFont systemFontOfSize:PX_TO_PT(32)]];
                    [self setbookTopRemainLabelDifFontandlength:remain.length andFont:[UIFont systemFontOfSize:PX_TO_PT(32)]];
                }
                else
                {
                    [self setbookTopTotalLabelDifFontandlength:total.length andFont:[UIFont systemFontOfSize:PX_TO_PT(40)]];
                    [self setbookTopRemainLabelDifFontandlength:remain.length andFont:[UIFont systemFontOfSize:PX_TO_PT(40)]];
                }
            }
            if ([result[@"needUpdate"] integerValue] == 1) {
                [self.Rep_indexTitleArr removeAllObjects];
                [self bookViewGetData];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)bookViewGetData
{

    [KSHttpRequest get:KGetAllQuery parameters:@{@"userId":[DataCenter account].userid} success:^(id result) {

        if ([result[@"code"] integerValue] == 1000) {
            
            NSMutableArray *arr = (NSMutableArray *)[XNRBookUser objectArrayWithKeyValuesArray:result[@"potentialCustomers"]];
            [_userArr addObjectsFromArray:arr];
            
            [self LoadIndex:self.tableView2 sourceArr:_userArr IndexTitleArr:_Rep_indexTitleArr];
//
            [self.tableView2.mj_header endRefreshing];

        }
        else if([result[@"code"] integerValue] == 1401)
        {
            [UILabel showMessage:result[@"message"]];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            //发送刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PageRefresh" object:nil];
            
            XNRLoginViewController *vc = [[XNRLoginViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [UILabel showMessage:result[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.tableView2.mj_header endRefreshing];

    }];
}
-(void)coverClick:(UIButton *)sender
{
    self.circleView.hidden = YES;
    self.bgview.hidden = YES;
    self.thirdView.hidden = NO;
    [self.coverView removeFromSuperview];
}
//总计
-(void)setbookTopTotalLabelDifFontandlength:(NSInteger)length andFont:(UIFont *)font
{

    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.bookTopTotalLabel.text];
    NSDictionary *dict=@{
                         
                         NSForegroundColorAttributeName:R_G_B_16(0xFE9B00),
                         NSFontAttributeName:font
                         
                         };
    
    [AttributedStringDeposit addAttributes:dict range:NSMakeRange(3,length)];
    
    [self.bookTopTotalLabel setAttributedText:AttributedStringDeposit];

}
//还可添加数
-(void)setbookTopRemainLabelDifFontandlength:(NSInteger)length andFont:(UIFont *)font
{
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.bookTopRemainLabel.text];
    NSDictionary *dict=@{
                         NSForegroundColorAttributeName:R_G_B_16(0x00B38A),
                         NSFontAttributeName:font
                         };
    
    [AttributedStringDeposit addAttributes:dict range:NSMakeRange(6,length)];
    
    [self.bookTopRemainLabel setAttributedText:AttributedStringDeposit];
    
}

-(void)getNominatedInviter
{
    [self.middleView removeFromSuperview];

    [KSHttpRequest get:KGetNominatedInviter parameters:nil success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            self.name = result[@"nominated_inviter"][@"name"];
            self.phone = result[@"nominated_inviter"][@"phone"];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.name,@"name",self.phone,@"phone", nil];
            myAlertView *alert = [[myAlertView alloc]initWithHeadTitle:@"是否要添加该用户为您的代表？" LeftButton:@"不是" RightButton:@"是的" andDic:dic];
            alert.delegate = self;
            self.myAlert = alert;
            [alert show];
            
        }
        else if ([result[@"code"]integerValue] == 1404)
        {
            self.name = @"";
            self.phone = @"";
        }
    } failure:^(NSError *error) {
        
    }];
}
#
-(void)alertView:(myAlertView *)lumAlertView Action:(NSInteger)index Dic:(NSDictionary *)dic
{
    if (index == 1) {
        [KSHttpRequest post:KUserBindInviter parameters:@{@"userId":[DataCenter account].userid,@"inviter":self.phone,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue]==1000) {

                [self.mrv removeFromSuperview];
                [self createMyRepresentUI];
//                [self bottomBtnClicked:self.rightBtn];
                [self getrepresent];
                [UILabel showMessage:@"设置代表成功"];
                [self.myAlert dismissLumAleatView];
                

            } else {

                [UILabel showMessage:result[@"message"]];
                [self.myAlert dismissLumAleatView];

            }
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        [self.myAlert dismissLumAleatView];
 
    }
    
}
-(void)getCustomerData
{
    [KSHttpRequest get:KGetInviteeOrderbyName parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSArray *arr = result[@"invitee"];
            for (NSDictionary *dict in arr) {
                XNRMyRepresentModel *model = [[XNRMyRepresentModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArr addObject:model];
            }
            self.headLabel.text = [NSString stringWithFormat:@"已邀请%@位好友",result[@"total"]];
            NSInteger i = 1;
            NSInteger count = [result[@"total"] integerValue];
            while (count >= 10) {
                count = count/10;
                i++;
            }
            NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:self.headLabel.text];
            
            NSDictionary *priceStr=@{
                                     
                                     NSForegroundColorAttributeName:R_G_B_16(0x00b38a),
                                     NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(40)]
                                     };
            
            
            [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,i)];
            

            
            [_headLabel setAttributedText:AttributedStringPrice];

            if(_dataArr.count > 0){
                self.topView.hidden = YES;
            }
            else{
                [self.tableView removeFromSuperview];
                
                self.topView.hidden = NO;
            }
//            [self.tableView reloadData];

            [self LoadIndex:self.tableView sourceArr:_dataArr IndexTitleArr:_customer_indexTitleArr];
        }else{
            [UILabel showMessage:result[@"message"]];
        }
        
        //
        [self.tableView.mj_header endRefreshing];
        

    } failure:^(NSError *error) {
    [self.tableView.mj_header endRefreshing];
        
        
    }];

}

-(void)LoadIndex:(UITableView *)tableView sourceArr:(NSArray *)sourceArr IndexTitleArr:(NSMutableArray *)IndexTitleArr
{
    // 实例化 整理对象
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    self.collation = collation;
    
    [IndexTitleArr addObjectsFromArray:collation.sectionIndexTitles];
    
    //    collation.sectionTitles.count  A~Z #
    
    NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:collation.sectionTitles.count];
    
    [collation.sectionTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSMutableArray *itemArr = [NSMutableArray array];
        
        [sectionArr addObject:itemArr];
        
    }];
    
    
    [sourceArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSInteger index = [collation sectionForObject:(XNRMyRepresentModel *)obj collationStringSelector:@selector(name)];
        
        NSMutableArray *itemArr = sectionArr[index];
        
        [itemArr addObject:obj];
        
    }];
    
    NSMutableArray *sectionTmpArr = [NSMutableArray array];
    //
    [sectionTmpArr addObjectsFromArray:sectionArr];
    //
    __block NSInteger integer = 0;
    
    [sectionArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSArray *tmpArr = (NSArray *)obj;
        
        if (tmpArr.count == 0)
        {
            
            [IndexTitleArr removeObjectAtIndex:idx - integer];
            
            [sectionTmpArr removeObject:tmpArr];
            
            
            integer++;
        }
        
    }];
    
    
//    [sectionTmpArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        NSMutableArray *itemArr = sectionArr[idx];
//        
//        NSArray *sortedArr = [collation sortedArrayFromArray:itemArr collationStringSelector:@selector(name)];
//        
//        sectionArr[idx] = [sortedArr mutableCopy];
//        
//    }];
    
    if (tableView.tag == tbTag) {
        _dataArr = sectionTmpArr;
    }
    else
    {
        _userArr= sectionTmpArr;
    }
    
    [tableView reloadData];
}
-(void)createCustomerLabel{
    [self.topView removeFromSuperview];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(260))];
    
    topView.backgroundColor = R_G_B_16(0xf0f0f0);
    self.topView = topView;
    self.topView.hidden = YES;
    [self.view addSubview:_topView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(70), PX_TO_PT(36), PX_TO_PT(140), PX_TO_PT(140))];
    [iconImageView setImage:[UIImage imageNamed:@"mine_represent"]];
    [_topView addSubview:iconImageView];
    
    CGFloat customerLabelX = 0;
    CGFloat customerLabelY = CGRectGetMaxY(iconImageView.frame) + PX_TO_PT(20);
    CGFloat customerLabelW = ScreenWidth;
    CGFloat customerLabelH = 30;
    UILabel *customerLabel = [[UILabel alloc] initWithFrame:CGRectMake(customerLabelX, customerLabelY, customerLabelW, customerLabelH)];
    customerLabel.text = @"您没有邀请用户哦~";
    customerLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    customerLabel.textColor = R_G_B_16(0x909090);
    customerLabel.textAlignment = NSTextAlignmentCenter;
    self.customerLabel = customerLabel;
    [_topView addSubview:customerLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,PX_TO_PT(260), ScreenWidth, 1)];
    lineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [_topView addSubview:lineView];

}

-(void)createTableView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(260))];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-70)*0.5, 10, PX_TO_PT(140), PX_TO_PT(140))];
    [imageView setImage:[UIImage imageNamed:@"mine_represent"]];
    [headView addSubview:imageView];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + PX_TO_PT(30), ScreenWidth, PX_TO_PT(36))];
    headLabel.textColor = R_G_B_16(0x646464);
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.headLabel = headLabel;
    [headView addSubview:headLabel];

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-PX_TO_PT(98)-64) style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.tag = tbTag;
    _tableView.backgroundColor = [UIColor colorWithHexString_Ext:@"#EEEEEE"];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexColor = R_G_B_16(0x909090);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headView;
    [self.view addSubview:_tableView];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // 可以根据需要返回只存在的数据的索引。
    if (tableView.tag == tbTag) {
        return self.customer_indexTitleArr;
    }
    else
    {
        return self.Rep_indexTitleArr;
    }
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self showView:title];
    return index;
}
-(void)showView:(NSString *)title
{
    [self.sv removeFromSuperview];
    UILabel *sv = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(80), PX_TO_PT(415), PX_TO_PT(161), PX_TO_PT(161))];
//    sv.center = self.view.center;
    sv.backgroundColor = R_G_B_16(0x00B38A);
    sv.text = title;
    sv.textAlignment = NSTextAlignmentCenter;
    sv.layer.cornerRadius = PX_TO_PT(161)/2;
    sv.layer.opacity = 0.5;
    sv.clipsToBounds = YES;
    self.sv = sv;
    [self.view addSubview:sv];
    [UIView animateWithDuration:3.0f animations:^{
        sv.alpha = 0;
    } completion:^(BOOL finished) {
        [sv removeFromSuperview];
    }];
}
- (void)myRepresentViewWith:(XNRMyRepresentView *)representView and:(NSString *)phoneNum {
    self.phoneNum = phoneNum;
    int flag = 1;
    NSString *title;
    if (self.phoneNum == nil || [self.phoneNum isEqualToString:@""]) {
        flag = 0;
        title = @"请输入手机号";
    }else if ([self validateMobile:phoneNum] == NO) {
        flag = 0;
        title = @"请输入正确的手机号";
    } else {
        [KSHttpRequest post:KUserFindAccount parameters:@{@"account":phoneNum,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                if ([self.phoneNum  isEqualToString:[DataCenter account].phone]) {
                    [UILabel showMessage:@"不能绑定自己为新农代表，请重新输入"];
                }else{

                    BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"确定设置为您的代表吗？" chooseBtns:@[@"取消",@"确定"]];
                    
                    alertView.chooseBlock = ^void(UIButton *btn){
                    
                        if (btn.tag == 11) {
                            [KSHttpRequest post:KUserBindInviter parameters:@{@"userId":[DataCenter account].userid,@"inviter":phoneNum,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                                if ([result[@"code"] integerValue]==1000) {
                                    [self.mrv removeFromSuperview];
                                    [self createMyRepresentUI];

                                    [self getrepresent];
                                    [UILabel showMessage:@"设置代表成功"];
                                } else {
                                    
                                    [UILabel showMessage:result[@"message"]];
                                    
                                }
                            } failure:^(NSError *error) {
                                
                            }];
                        }
                        
                    };
                    [alertView BMAlertShow];
                }
               
                
            }else{
                
                [UILabel showMessage:result[@"message"]];
            }
        } failure:^(NSError *error) {
            
        }];
    
    }
    if (flag == 0) {
        
        [UILabel showMessage:title];
    }
}
/**
 *  手机格式判断
 *
 */
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


-(void)createMyRepresentUI {
    
//    [self.mrv removeFromSuperview];
    [self.middleView removeFromSuperview];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(98))];
    middleView.backgroundColor = [UIColor whiteColor];
    self.middleView = middleView;
    self.middleView.hidden = YES;
    [self.view addSubview:self.middleView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(70), PX_TO_PT(36), PX_TO_PT(140), PX_TO_PT(140))];
    [iconImageView setImage:[UIImage imageNamed:@"mine_represent"]];
    [self.middleView addSubview:iconImageView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + PX_TO_PT(28), ScreenWidth, PX_TO_PT(60))];
    self.myRepTopView = topView;
    [self.middleView addSubview:topView];
    
    CGFloat myRepLabelX = 0;
    CGFloat myRepLabelY = 0;
    CGFloat myRepLabelW = ScreenWidth;
    CGFloat myRepLabelH = PX_TO_PT(60);
    UILabel *myRepLabel = [[UILabel alloc] initWithFrame:CGRectMake(myRepLabelX, myRepLabelY, myRepLabelW, myRepLabelH)];
    myRepLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    myRepLabel.textColor = R_G_B_16(0x646464);
    myRepLabel.textAlignment = NSTextAlignmentCenter;
    self.myRepLabel = myRepLabel;
    [topView addSubview:myRepLabel];
    
    UIImageView *sexImage = [[UIImageView alloc]init];
    self.sexImage = sexImage;
    [topView addSubview:sexImage];
    
    CGFloat type_Y = PX_TO_PT(325);
    NSArray *arr = @[@"用户类型:",@"所在地区:",@"电话号码:"];
    UILabel *type;
    for(int i=0;i<3;i++)
    {
        type = [[UILabel alloc]init];
        type.frame = CGRectMake(PX_TO_PT(70), type_Y, PX_TO_PT(160), PX_TO_PT(31));
        type.text = arr[i];
        type.textColor = R_G_B_16(0x646464);
        type.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        [self.middleView addSubview:type];
        type_Y = type_Y + PX_TO_PT(33)+PX_TO_PT(24);
    }
    
    UILabel *rep_userType = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(type.frame)+PX_TO_PT(10), PX_TO_PT(325), PX_TO_PT(160), PX_TO_PT(31))];
    self.rep_userType = rep_userType;
    rep_userType.textColor = R_G_B_16(0x646464);

    rep_userType.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [self.middleView addSubview:rep_userType];
    
    UIImageView *rep_badge = [[UIImageView alloc]init];
    rep_badge.frame = CGRectMake(CGRectGetMaxX(rep_userType.frame)+PX_TO_PT(22), PX_TO_PT(321), PX_TO_PT(18), PX_TO_PT(40));
    rep_badge.contentMode = UIViewContentModeScaleAspectFit;
    self.rep_badge =rep_badge;
    rep_badge.image = [UIImage imageNamed:@"badge"];
    rep_badge.hidden = YES;
    [self.middleView addSubview:rep_badge];
  
    UILabel *rep_address = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(type.frame)+PX_TO_PT(10), CGRectGetMaxY(rep_userType.frame)+PX_TO_PT(24), PX_TO_PT(440), PX_TO_PT(31))];
    self.rep_address = rep_address;
    rep_address.textColor = R_G_B_16(0x646464);

    rep_address.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [self.middleView addSubview:rep_address];
    
    UILabel *rep_phone = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(type.frame)+PX_TO_PT(10), CGRectGetMaxY(rep_address.frame)+PX_TO_PT(28), PX_TO_PT(195), PX_TO_PT(31))];
    self.rep_phone = rep_phone;
    rep_phone.textColor = R_G_B_16(0x646464);
    rep_phone.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [self.middleView addSubview:rep_phone];
    
    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rep_phone.frame)+PX_TO_PT(17), CGRectGetMaxY(rep_address.frame)+PX_TO_PT(26), PX_TO_PT(24), PX_TO_PT(30))];
    [phoneBtn setImage:[UIImage imageNamed:@"phone-icon"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.middleView addSubview:phoneBtn];
}
-(void)call
{
    if (self.phoneNum) {
        
        if(TARGET_IPHONE_SIMULATOR){
            [UILabel showMessage:@"模拟器不支持打电话，请用真机测试"];
        } else {
            
            UIWebView*phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.rep_phone.text]];
            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
            [self.view addSubview:phoneCallWebView];
        }
    }
}

#pragma mark -- tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tbTag) {
        return PX_TO_PT(99);
    }
    else
    {
        return PX_TO_PT(99);
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == tbTag) {
        return _dataArr.count;
    }
    else
    {
        return _userArr.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == tbTag) {
       NSArray * Arr =_dataArr[section];
        return Arr.count;
    }
    else
    {
        NSArray *Arr =_userArr[section];
        return Arr.count;
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *itemArr = [NSArray array];
    NSString *title;
    if (tableView.tag == tbTag) {
        itemArr =_dataArr[section];
        title =self.customer_indexTitleArr[section];
    }
    else
    {
        itemArr = _userArr[section];
        title = self.Rep_indexTitleArr[section];
    }
    if ([itemArr count] > 0) {
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(45))];
        titleView.backgroundColor = R_G_B_16(0xe8e8e8);
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(0), PX_TO_PT(30), PX_TO_PT(47))];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        titleLabel.textColor = R_G_B_16(0X909090);
        [titleView addSubview:titleLabel];
        return titleView;
    }
    else
    {
        return nil;
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(47);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tbTag) {
        XNRCustomerOrderController *customerVC = [[XNRCustomerOrderController alloc] init];
        customerVC.hidesBottomBarWhenPushed = YES;
        NSArray *itemArr = _dataArr[indexPath.section];
        
        XNRMyRepresentModel *model = itemArr[indexPath.row];
        customerVC.inviteeId = model.userId;
        if (model.newOrdersNumber > 0) {
            XNRMyRepresent_cell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.redImageView removeFromSuperview];
        }
        [self.navigationController pushViewController:customerVC animated:YES];

    }
    else
    {
        XNRDetailUserVC *detailUser = [[XNRDetailUserVC alloc]init];
        detailUser.hidesBottomBarWhenPushed = YES;
        self.isadd = NO;
        self.isuserDetail = YES;
        XNRBookUser *user = _userArr[indexPath.section][indexPath.row];
        detailUser._id = user._id;
        [self.navigationController pushViewController:detailUser animated:YES];
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tbTag) {
        static NSString *cellID = @"cellID";
        XNRMyRepresent_cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[XNRMyRepresent_cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (_dataArr.count > 0) {
            NSArray *itemArr = _dataArr[indexPath.section];
            XNRMyRepresentModel *model = itemArr[indexPath.row];
            cell.model = model;
        }
        
        return cell;

    }
    else
    {
        static NSString *cell2ID = @"cell2ID";
        XNRUser_Cell *cell2 = [tableView dequeueReusableCellWithIdentifier:cell2ID];
        if (!cell2) {
            cell2 = [[XNRUser_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2ID];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_userArr.count > 0) {
            XNRBookUser *user = _userArr[indexPath.section][indexPath.row];
            cell2.model = user;
        }
        return cell2;
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
