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

#define btnTag 1000

@interface XNRMyRepresentViewController ()<UITableViewDelegate,UITableViewDataSource,XNRMyRepresentViewAddBtnDelegate>
{
    NSMutableArray *_dataArr;
    
}

@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, strong) XNRMyRepresentView *mrv;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) UILabel *customerLabel;

@property (nonatomic, weak) UILabel *myRepLabel;

@property (nonatomic, weak) UILabel *nickNameLabel;

@property (nonatomic, copy) NSString *phoneNum;

@property (nonatomic, weak) UIView *myRepView;

@property (nonatomic, weak) UIView *headView;
@end

@implementation XNRMyRepresentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = R_G_B_16(0xf0f0f0);
    [self setNavigationbarTitle];
    [self setBottomButton];
    [self createTableView];
}

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
        _tableView.hidden = NO;
        [_dataArr removeAllObjects];
        [KSHttpRequest post:KUserGetInvitee parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                NSArray *arr = result[@"invitee"];
                for (NSDictionary *dict in arr) {
                    XNRMyRepresentModel *model = [[XNRMyRepresentModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [_dataArr addObject:model];
                }
            }else{
                UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:result[@"message"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [al show];
            }
            
            if (_dataArr.count > 0) {
                [self.customerLabel removeFromSuperview];
            }else{
                [self.headView removeFromSuperview];
                [self.tableView removeFromSuperview];
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
        [self.mrv removeFromSuperview];
        [self.myRepLabel removeFromSuperview];
        [self.myRepView removeFromSuperview];
        [self.customerLabel removeFromSuperview];
        [self createCustomerLabel];
    } else {
        _tableView.hidden = sender.selected;
        self.customerLabel.hidden = sender.selected;
        [KSHttpRequest post:KUserGet parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue]==1000) {
                self.phoneNum = result[@"datas"][@"inviter"];
                if (self.phoneNum && self.phoneNum.length>0) {
                    [self.mrv removeFromSuperview];
                    [self createMyRepresentUI];
                    if (result[@"datas"][@"inviterNickname"]) {
                        self.nickNameLabel.text = result[@"datas"][@"inviterNickname"];
                    }else{
                        self.nickNameLabel.text = @"好友未设置昵称";
                    }
                } else {
                    [self.mrv removeFromSuperview];
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
                UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:result[@"message"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [al show];
            
            }
        } failure:^(NSError *error) {
            
        }];

        

    }
}

-(void)createCustomerLabel{
    
    CGFloat customerLabelX = 0;
    CGFloat customerLabelY = ScreenHeight/2-100;
    CGFloat customerLabelW = ScreenWidth;
    CGFloat customerLabelH = 50;
    UILabel *customerLabel = [[UILabel alloc] initWithFrame:CGRectMake(customerLabelX, customerLabelY, customerLabelW, customerLabelH)];
    customerLabel.text = @"您还没有客户哦~";
    customerLabel.font = [UIFont systemFontOfSize:18];
    customerLabel.textColor = R_G_B_16(0x323232);
    customerLabel.textAlignment = NSTextAlignmentCenter;
    self.customerLabel = customerLabel;
    [self.view addSubview:customerLabel];

}

-(void)createTableView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    headView.backgroundColor = R_G_B_16(0xf0f0f0);
    [self.view addSubview:headView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-70)*0.5, 10, 70, 70)];
    [imageView setImage:[UIImage imageNamed:@"头像-拷贝"]];
    [headView addSubview:imageView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth, ScreenHeight-PX_TO_PT(100)-100) style:UITableViewStylePlain];
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
                    [SVProgressHUD showErrorWithStatus:@"不能设置自己为新农代表哦"];
                }else{
                    [KSHttpRequest post:KUserBindInviter parameters:@{@"userId":[DataCenter account].userid,@"inviter":phoneNum,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                        if ([result[@"code"] integerValue]==1000) {
                            [self.mrv removeFromSuperview];
                            [self createMyRepresentUI];
                            [SVProgressHUD showSuccessWithStatus:@"设置代表成功"];
                        } else {
                            UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:result[@"message"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                            [al show];
                            
                        }
                        
                        
                    } failure:^(NSError *error) {
                        
                    }];

                
                }
               
                
            }else{
                UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:result[@"message"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [al show];
            
            }
        } failure:^(NSError *error) {
            
        }];
    
    }
    if (flag == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
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
//    self.customerLabel.hidden = YES;
//    self.rightBtn.enabled = NO;
    [self.myRepLabel removeFromSuperview];
    [self.myRepView removeFromSuperview];
    
    CGFloat margin = 20;
    
    UILabel *myRepLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, ScreenWidth, 20)];
    myRepLabel.text = @"我的代表:";
    myRepLabel.font = [UIFont systemFontOfSize:18];
    myRepLabel.textColor = R_G_B_16(0x323232);
    self.myRepLabel = myRepLabel;
    [self.view addSubview:myRepLabel];
    
    CGFloat myRepLabelH = 60;
    UIView *myRepView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myRepLabel.frame)+margin, ScreenWidth, myRepLabelH)];
    myRepView.backgroundColor = [UIColor whiteColor];
    self.myRepView = myRepView;
    [self.view addSubview:myRepView];
    
    CGFloat nickNameLabelY = (myRepLabelH - 20)*0.5;
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,nickNameLabelY , ScreenWidth/2, 20)];
    nickNameLabel.textColor = R_G_B_16(0x646464);
    nickNameLabel.font = [UIFont systemFontOfSize:18];
    self.nickNameLabel = nickNameLabel;
    [myRepView addSubview:nickNameLabel];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+10, nickNameLabelY, ScreenWidth/2, 20)];
    phoneNumLabel.text = self.phoneNum;
    phoneNumLabel.textColor = R_G_B_16(0x20b2aa);
    phoneNumLabel.font = [UIFont systemFontOfSize:18];
    [myRepView addSubview:phoneNumLabel];
    
}


#pragma mark -- tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    XNRMyRepresent_cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XNRMyRepresent_cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
