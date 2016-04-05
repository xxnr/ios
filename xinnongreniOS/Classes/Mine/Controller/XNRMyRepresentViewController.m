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
#define btnTag 1000
#define tbTag 2000
@interface XNRMyRepresentViewController ()<UITableViewDelegate,UITableViewDataSource,XNRMyRepresentViewAddBtnDelegate,LumAlertViewDelegate>
{
    NSMutableArray *_dataArr;
    int currentPage;
    
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

@property (nonatomic ,weak) UIView *myRepTopView;

@property (nonatomic ,weak) UILabel *phoneNumLabel;

@property (nonatomic ,weak) UILabel *headLabel;

@property (nonatomic, copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,strong)myAlertView *myAlert;
@property (nonatomic,assign)BOOL isfirst;
@property (nonatomic,weak)UIView *firstView;
@property (nonatomic,weak)UIView *secondView;
@property (nonatomic,weak) UIView *thirdView;
@property (nonatomic,weak) UIView *BookView;
@property (nonatomic,weak) UITableView *tableView2;
@property (nonatomic,strong)NSMutableArray *userArr;
@property (nonatomic,weak)UILabel *bookTop1Label;
@property (nonatomic,weak)UILabel *bookTop2Label;
@property (nonatomic,weak) UIView *coverView;
@property (nonatomic,weak) UIButton *addbtn;
@property (nonatomic,assign)BOOL isadd;
@end

@implementation XNRMyRepresentViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_isadd) {
        [self creatBookView];
        [self bookViewGetData];
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
//    [self getCustomerData];
    self.isfirst = YES;
    _userArr = [NSMutableArray array];
    _dataArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = R_G_B_16(0xfafafa);
    [self setNavigationbarTitle];
    [self setBottomButton];
    [self createTableView];
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

    self.tableView.mj_header = header;
//    [self.tableView.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    
    // 设置刷新图片
    
    [footer setImages:RefreshImage forState:MJRefreshStateRefreshing];

    footer.refreshingTitleHidden = YES;
    
    // 设置尾部
    
    self.tableView.mj_footer = footer;

}

-(void)headRefresh{
    
    currentPage = 1;
    [_dataArr removeAllObjects];
    [self getCustomerData];
    
}

-(void)footRefresh{
    
    currentPage ++;
    [self getCustomerData];
}



#pragma mark -  导航
-(void)setNavigationbarTitle
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = R_G_B_16(0xffffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"新农代表";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0,0,80,44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
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
    CGFloat btnH = PX_TO_PT(100);
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
    [self bottomBtnClicked:_leftBtn];
    
    if (self.isBroker) {
        _bookBtn.hidden = NO;
        self.leftBtn.frame = CGRectMake(0, btnY, ScreenWidth/3, btnH);
        self.rightBtn.frame = CGRectMake(CGRectGetMaxX(self.leftBtn.frame), btnY, ScreenWidth/3, btnH);
        self.bookBtn.frame = CGRectMake(CGRectGetMaxX(self.rightBtn.frame), btnY, ScreenWidth/3, btnH);
        
    }

}

- (void)bottomBtnClicked:(UIButton *)sender {
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;

    if (sender.tag == btnTag) {
        
//        [self.topView removeFromSuperview];
//        _tableView.hidden = NO;
//        [self getCustomerData];
//        [self.mrv removeFromSuperview];
//        [self.myRepLabel removeFromSuperview];
//        [self.myRepView removeFromSuperview];
//        [self createCustomerLabel];

        
        [self.topView removeFromSuperview];
        _tableView.hidden = NO;
        
//        _tableView.hidden = NO;
//        self.thirdView.hidden = YES;

        [self getCustomerData];
        
        [self.thirdView removeFromSuperview];
        [self.mrv removeFromSuperview];
        [self.myRepTopView removeFromSuperview];
//        [self.myRepLabel removeFromSuperview];
        [self.myRepView removeFromSuperview];
        [self createCustomerLabel];
    } else if(sender.tag == btnTag + 1){
        _tableView.hidden = sender.selected;
        self.topView.hidden = sender.selected;
        [self.firstView removeFromSuperview];
//        self.thirdView.hidden = YES;
        [self.thirdView removeFromSuperview];

        [KSHttpRequest post:KUserGet parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue]==1000) {
                self.phoneNum = result[@"datas"][@"inviter"];
                if (self.phoneNum && self.phoneNum.length>0) {
                    [self.mrv removeFromSuperview];
                    [self createMyRepresentUI];
                    self.phoneNumLabel.text = _phoneNum;
                    if (result[@"datas"][@"inviterName"]) {
                        self.nickNameLabel.text = result[@"datas"][@"inviterName"];
                        CGSize nickNameSize = [self.nickNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
                        self.nickNameLabel.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(18), nickNameSize.width+PX_TO_PT(24), PX_TO_PT(60));

                    }else{
                        self.nickNameLabel.text = @"好友未填姓名";
                        self.nickNameLabel.backgroundColor = R_G_B_16(0xf0f0f0);
                        self.nickNameLabel.textColor = R_G_B_16(0x2a2a2a);
                    }
                } else {
                    [self.mrv removeFromSuperview];

                    if (self.isfirst) {
                        [self getNominatedInviter];
                    }
                    self.isfirst = NO;
            
                    XNRMyRepresentView *mrv = [[XNRMyRepresentView alloc] init];
                    mrv.delegate = self;
                    self.mrv = mrv;
                    [self.view addSubview:mrv];
                    
                    XNRMyRepresentViewDataModel *mrvData = [[XNRMyRepresentViewDataModel alloc] init];
                    XNRMyRepresentViewFrame *mrvF = [[XNRMyRepresentViewFrame alloc] init];
                    mrvF.model = mrvData;
                    mrv.viewF = mrvF;
                    mrv.frame = CGRectMake(0, (self.view.bounds.size.height-mrvF.viewH)*0.3, ScreenWidth, mrvF.viewH);
                }
            }else{
               
                [UILabel showMessage:result[@"message"]];
            
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else if(sender.tag == btnTag + 2)
    {
        
        _tableView.hidden = YES;
        self.topView.hidden = YES;
        self.mrv.hidden = YES;
//        [self.firstView removeFromSuperview];
        [self.mrv removeFromSuperview];
        [self.myRepTopView removeFromSuperview];
        [self.myRepLabel removeFromSuperview];
        [self.myRepView removeFromSuperview];
        
        [self.thirdView removeFromSuperview];
        
        [self creatBookView];
        [self bookViewGetData];
        
    }
}
-(void)creatBookView
{

    //添加顶部视图
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(100))];
    thirdView.backgroundColor = [UIColor clearColor];
    self.thirdView = thirdView;
    
    UIView *BooktopView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(220))];
    BooktopView.backgroundColor = [UIColor whiteColor];
    [self.thirdView addSubview:BooktopView];
    
    UILabel *top1Label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(29), ScreenWidth/2, PX_TO_PT(32))];
    top1Label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    top1Label.textColor =R_G_B_16(0x646464);
    self.bookTop1Label = top1Label;
    [BooktopView addSubview:top1Label];
    
    UILabel *top2Label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), CGRectGetMaxY(top1Label.frame) + PX_TO_PT(18), ScreenWidth/2, PX_TO_PT(33))];
    top2Label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    top2Label.textColor = R_G_B_16(0x646464);
    self.bookTop2Label = top2Label;
    [BooktopView addSubview:top2Label];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(605), PX_TO_PT(29),PX_TO_PT(80), PX_TO_PT(80))];
    addBtn.backgroundColor = R_G_B_16(0xE2E2E2);
//    [addBtn setBackgroundImage:[UIImage imageNamed:@"icon-++-0"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"icon-++-0"] forState:UIControlStateNormal];
    addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [addBtn addTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchDown];
    addBtn.layer.cornerRadius = 20;
    addBtn.layer.masksToBounds = YES;
    self.addbtn = addBtn;
    [BooktopView addSubview:addBtn];
    
    UIView *top2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(top2Label.frame)+PX_TO_PT(29), ScreenWidth, PX_TO_PT(80))];
    top2.backgroundColor = R_G_B_16(0xE8E8E8);
    [BooktopView addSubview:top2];
    UILabel *top3Label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(25), PX_TO_PT(200), PX_TO_PT(32))];
    top3Label.text = @"已登记客户";
    top3Label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    top3Label.textColor = R_G_B_16(0x323232);
    [top2 addSubview:top3Label];
    
    UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(BooktopView.frame), ScreenWidth, ScreenHeight - 64 - PX_TO_PT(100) - PX_TO_PT(240)) style:UITableViewStylePlain];
    tableView2.backgroundColor = [UIColor clearColor];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView2 = tableView2;
    _tableView2.tag = tbTag + 1;
    [self.thirdView addSubview:tableView2];
    
    [self.view addSubview:self.thirdView];
}
-(void)addUser:(UIButton *)sender
{
    self.isadd = YES;
    XNRAddLatentUserVC *addLatentUser = [[XNRAddLatentUserVC alloc]init];
    [self.navigationController pushViewController:addLatentUser animated:YES];
}

-(void)bookViewGetData
{
    
    [KSHttpRequest get:KGetQuery parameters:nil success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            _userArr = (NSMutableArray *)[XNRBookUser objectArrayWithKeyValuesArray:result[@"potentialCustomers"]];
            
            if(_userArr.count == 0){                
            
            
                BOOL isadd = [[NSUserDefaults standardUserDefaults]boolForKey:@"key"];
                if (isadd == NO) {
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                    UIImageView *iamgeview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    [iamgeview setImage:[UIImage imageNamed:@"mask"]];
                    iamgeview.contentMode = UIViewContentModeScaleAspectFit;
                    [view addSubview:iamgeview];
                    
                    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(262), PX_TO_PT(619), PX_TO_PT(197), PX_TO_PT(95))];
                    [btn addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchDown];
                    [view addSubview:btn];
                    
                    self.coverView = view;
                   UIWindow *window = [[UIApplication sharedApplication].delegate window];
                    [window addSubview:view];
                    
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"key"];
                }
            }
            self.bookTop1Label.text = [NSString stringWithFormat:@"共登记%@名客户",result[@"count"]];
            self.bookTop2Label.text = [NSString stringWithFormat:@"今日还可添加%@名",result[@"countLeftToday"]];
            
            if ([result[@"countLeftToday"] integerValue] == 0) {
                self.addbtn.backgroundColor = R_G_B_16(0xE2E2E2);
            }
            else
            {
                self.addbtn.backgroundColor = R_G_B_16(0xFE9B00);
            }
            NSInteger i = [result[@"count"] integerValue]/10;
            NSInteger j = [result[@"countLeftToday"] integerValue]/10;
            
            [self setDifFont:self.bookTop1Label andPosit:3 andlength:i+1 andColor:R_G_B_16(0xFE9B00)];
            [self setDifFont:self.bookTop2Label andPosit:6 andlength:j+1 andColor:R_G_B_16(0x00B38A)];
            
            [self.tableView2 reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)coverClick:(UIButton *)sender
{
    [self.coverView removeFromSuperview];
}
-(void)setDifFont:(UILabel *)label andPosit:(NSInteger )posit andlength:(NSInteger)length andColor:(UIColor *)color
{
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:label.text];
    NSDictionary *dict=@{
                         
                         NSForegroundColorAttributeName:color,
                         NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(40)],
                         
                         };
    
    [AttributedStringDeposit addAttributes:dict range:NSMakeRange(posit,length)];
    
    [label setAttributedText:AttributedStringDeposit];

}
-(void)getNominatedInviter
{
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
//                [self createMyRepresentUI];
                [self bottomBtnClicked:self.rightBtn];
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
    [_dataArr removeAllObjects];
    [KSHttpRequest post:KUserGetInvitee parameters:@{@"userId":[DataCenter account].userid,@"page":[NSString stringWithFormat:@"%d",currentPage],@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSArray *arr = result[@"invitee"];
            for (NSDictionary *dict in arr) {
                XNRMyRepresentModel *model = [[XNRMyRepresentModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArr addObject:model];
            }
            self.headLabel.text = [NSString stringWithFormat:@"已邀请%tu位好友",_dataArr.count];
            
            NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:self.headLabel.text];
            
            NSDictionary *priceStr=@{
                                     
                                     NSForegroundColorAttributeName:R_G_B_16(0x00b38a),
                                     NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(40)]
                                     };
            
            [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,1)];
            
            
            
            [_headLabel setAttributedText:AttributedStringPrice];

        }else{
            [UILabel showMessage:result[@"message"]];
        }
        
        if (_dataArr.count > 0) {
            [self.myRepTopView removeFromSuperview];
            [self.topView removeFromSuperview];
        }else{
            [self.headView removeFromSuperview];
            [self.tableView removeFromSuperview];
        }
        [self.tableView reloadData];
        
        //  如果到达最后一页 就消除footer
        
        NSInteger pages = [result[@"datas"][@"pages"] integerValue];
        
        NSInteger page = [result[@"datas"][@"page"] integerValue];
        
        self.tableView.mj_footer.hidden = pages == page;
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView.mj_footer endRefreshing];
        

    } failure:^(NSError *error) {
    [self.tableView.mj_header endRefreshing];
        
    [self.tableView.mj_footer endRefreshing];
        
    }];



}

-(void)createCustomerLabel{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(260))];
    
    topView.backgroundColor = R_G_B_16(0xf0f0f0);
    self.topView = topView;
    [self.view addSubview:topView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(70), PX_TO_PT(36), PX_TO_PT(140), PX_TO_PT(140))];
    [iconImageView setImage:[UIImage imageNamed:@"mine_represent"]];
    [topView addSubview:iconImageView];
    
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
    [topView addSubview:customerLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,PX_TO_PT(260), ScreenWidth, PX_TO_PT(1))];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [topView addSubview:lineView];

}

-(void)createTableView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(260))];
    headView.backgroundColor = R_G_B_16(0xf0f0f0);
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

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-PX_TO_PT(100)-64) style:UITableViewStylePlain];
    _tableView.tag = tbTag;
    _tableView.backgroundColor = [UIColor colorWithHexString_Ext:@"#EEEEEE"];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headView;
    [self.view addSubview:_tableView];
}

- (void)myRepresentViewWith:(XNRMyRepresentView *)representView and:(NSString *)phoneNum {
    self.phoneNum = phoneNum;
    int flag = 1;
    NSString *title;
    if (self.phoneNum == nil || [self.phoneNum isEqualToString:@""]) {
        flag = 0;
        title = @"手机号不能为空";
    }else if ([self validateMobile:phoneNum] == NO) {
        flag = 0;
        title = @"手机格式错误";
    } else {
        [KSHttpRequest post:KUserFindAccount parameters:@{@"account":phoneNum,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                if ([self.phoneNum  isEqualToString:[DataCenter account].phone]) {
                    [UILabel showMessage:@"不能设置自己为新农代表哦"];
                }else{

                    BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"确定设置为您的代表吗？" chooseBtns:@[@"取消",@"确定"]];
                    
                    alertView.chooseBlock = ^void(UIButton *btn){
                    
                        if (btn.tag == 11) {
                            [KSHttpRequest post:KUserBindInviter parameters:@{@"userId":[DataCenter account].userid,@"inviter":phoneNum,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                                if ([result[@"code"] integerValue]==1000) {
                                    [self.mrv removeFromSuperview];
                                    [self bottomBtnClicked:self.rightBtn];
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
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


-(void)createMyRepresentUI {
    [self.myRepTopView removeFromSuperview];
    [self.myRepView removeFromSuperview];
    
    UIView *myRepTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(260))];
//    myRepTopView.frame = CGRectMake(300, 33, 234, 33);
    myRepTopView.backgroundColor = R_G_B_16(0xf0f0f0);
    self.myRepTopView = myRepTopView;
    [self.view addSubview:myRepTopView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(70), PX_TO_PT(36), PX_TO_PT(140), PX_TO_PT(140))];
    [iconImageView setImage:[UIImage imageNamed:@"mine_represent"]];
    [myRepTopView addSubview:iconImageView];
    
    CGFloat myRepLabelX = 0;
    CGFloat myRepLabelY = CGRectGetMaxY(iconImageView.frame) + PX_TO_PT(10);
    CGFloat myRepLabelW = ScreenWidth;
    CGFloat myRepLabelH = 30;
    UILabel *myRepLabel = [[UILabel alloc] initWithFrame:CGRectMake(myRepLabelX, myRepLabelY, myRepLabelW, myRepLabelH)];
    myRepLabel.text = @"我的代表";
    myRepLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    myRepLabel.textColor = R_G_B_16(0x646464);
    myRepLabel.textAlignment = NSTextAlignmentCenter;
    self.myRepLabel = myRepLabel;
    [myRepTopView addSubview:myRepLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,PX_TO_PT(260), ScreenWidth, PX_TO_PT(1))];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [myRepTopView addSubview:lineView];

    
    UIView *myRepView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myRepTopView.frame), ScreenWidth, PX_TO_PT(96))];
    myRepView.backgroundColor = [UIColor whiteColor];
    self.myRepView = myRepView;
    [self.view addSubview:myRepView];
    
    CGFloat nickNameLabelY = (PX_TO_PT(96) - PX_TO_PT(60))*0.5;
//    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32),nickNameLabelY , PX_TO_PT(220), PX_TO_PT(60))];
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.backgroundColor = R_G_B_16(0x00b38a);
    nickNameLabel.layer.cornerRadius = 5.0;
    nickNameLabel.layer.masksToBounds = YES;
    nickNameLabel.adjustsFontSizeToFitWidth = YES;
    nickNameLabel.textColor = R_G_B_16(0xffffff);
    nickNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel = nickNameLabel;
    [myRepView addSubview:nickNameLabel];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, nickNameLabelY, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(60))];
    phoneNumLabel.textAlignment = NSTextAlignmentRight;
    phoneNumLabel.textColor = R_G_B_16(0x00b38a);
    phoneNumLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    self.phoneNumLabel = phoneNumLabel;
    [myRepView addSubview:phoneNumLabel];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    topLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [myRepView addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(96), ScreenWidth, PX_TO_PT(1))];
    bottomLineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [myRepView addSubview:bottomLineView];

}


#pragma mark -- tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tbTag) {
        return PX_TO_PT(96);
    }
    else
    {
        return PX_TO_PT(77);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == tbTag) {
        return _dataArr.count;
    }
    else
    {
        return _userArr.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tbTag) {
        XNRCustomerOrderController *customerVC = [[XNRCustomerOrderController alloc] init];
        customerVC.hidesBottomBarWhenPushed = YES;
        XNRMyRepresentModel *model = _dataArr[indexPath.row];
        customerVC.inviteeId = model.userId;
        
        [self.navigationController pushViewController:customerVC animated:YES];

    }
    else
    {
        XNRDetailUserVC *detailUser = [[XNRDetailUserVC alloc]init];
        detailUser.hidesBottomBarWhenPushed = YES;
        XNRBookUser *user = _userArr[indexPath.row];
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
            XNRMyRepresentModel *model = _dataArr[indexPath.row];
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
            XNRBookUser *user = _userArr[indexPath.row];
            cell2.model = user;
        }
        return cell2;
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
