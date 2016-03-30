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
#define btnTag 1000

@interface XNRMyRepresentViewController ()<UITableViewDelegate,UITableViewDataSource,XNRMyRepresentViewAddBtnDelegate,LumAlertViewDelegate>
{
    NSMutableArray *_dataArr;
    int currentPage;
    
}

@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
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
@end

@implementation XNRMyRepresentViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setupCustomerRefresh];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getCustomerData];
    self.isfirst = YES;
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
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [leftBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = btnTag;
    self.leftBtn = leftBtn;
    [self.view addSubview:_leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightBtn;
    _rightBtn.frame = CGRectMake(btnW, btnY, btnW, btnH);
    [_rightBtn setTitle:@"我的新农代表" forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"huise"] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"baise"] forState:UIControlStateSelected];
    [_rightBtn setTitleColor:R_G_B_16(0xffffff) forState:UIControlStateSelected];
    [_rightBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateSelected];
    [_rightBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"FFFFFF"]] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_rightBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.tag = btnTag + 1;
    [self.view addSubview:_rightBtn];
    
    [self bottomBtnClicked:_leftBtn];

}

- (void)bottomBtnClicked:(UIButton *)sender {
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;

    if (sender.tag == btnTag) {
        
        [self.topView removeFromSuperview];
        _tableView.hidden = NO;
        [self getCustomerData];
        [self.mrv removeFromSuperview];
        [self.myRepLabel removeFromSuperview];
        [self.myRepView removeFromSuperview];
        [self createCustomerLabel];
    } else {
        _tableView.hidden = sender.selected;
        self.topView.hidden = sender.selected;
        [KSHttpRequest post:KUserGet parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue]==1000) {
                self.phoneNum = result[@"datas"][@"inviter"];
                if (self.phoneNum && self.phoneNum.length>0) {
                    [self.mrv removeFromSuperview];
                    [self createMyRepresentUI];
                    self.phoneNumLabel.text = _phoneNum;
                    if (result[@"datas"][@"inviterName"]) {
                        self.nickNameLabel.text = result[@"datas"][@"inviterName"];
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
                                     NSFontAttributeName:[UIFont systemFontOfSize:20]
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
    customerLabel.font = [UIFont systemFontOfSize:16];
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
    headLabel.font = [UIFont systemFontOfSize:16];
    self.headLabel = headLabel;
    [headView addSubview:headLabel];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-PX_TO_PT(100)-64) style:UITableViewStylePlain];
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
                    [KSHttpRequest post:KUserBindInviter parameters:@{@"userId":[DataCenter account].userid,@"inviter":phoneNum,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                        if ([result[@"code"] integerValue]==1000) {
                            [self.mrv removeFromSuperview];
//                            [self createMyRepresentUI];
                            [self bottomBtnClicked:self.rightBtn];
                            [UILabel showMessage:@"设置代表成功"];
                        } else {
                           
                            [UILabel showMessage:result[@"message"]];
                            
                        }
                    } failure:^(NSError *error) {
                        
                    }];

                
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
    [self.myRepLabel removeFromSuperview];
    [self.myRepView removeFromSuperview];
    
    UIView *myRepTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(260))];
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
    myRepLabel.font = [UIFont systemFontOfSize:16];
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
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32),nickNameLabelY , PX_TO_PT(220), PX_TO_PT(60))];
    nickNameLabel.backgroundColor = R_G_B_16(0x00b38a);
    nickNameLabel.layer.cornerRadius = 5.0;
    nickNameLabel.layer.masksToBounds = YES;
    nickNameLabel.adjustsFontSizeToFitWidth = YES;
    nickNameLabel.textColor = R_G_B_16(0xffffff);
    nickNameLabel.font = [UIFont systemFontOfSize:16];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel = nickNameLabel;
    [myRepView addSubview:nickNameLabel];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, nickNameLabelY, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(60))];
    phoneNumLabel.textAlignment = NSTextAlignmentRight;
    phoneNumLabel.textColor = R_G_B_16(0x00b38a);
    phoneNumLabel.font = [UIFont systemFontOfSize:18];
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
    return PX_TO_PT(96);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRCustomerOrderController *customerVC = [[XNRCustomerOrderController alloc] init];
    customerVC.hidesBottomBarWhenPushed = YES;
    XNRMyRepresentModel *model = _dataArr[indexPath.row];
    customerVC.inviteeId = model.userId;
    
    [self.navigationController pushViewController:customerVC animated:YES];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
