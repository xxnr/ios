//
//  XNRSelContactVC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/20.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSelContactVC.h"
#import "XNRConsigneeModel.h"
#import "XNRConsigneesCell.h"
#import "XNRBtn.h"

@interface XNRSelContactVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    int currentPage;
}
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UITextField *phoneTf;
@property (nonatomic,weak)UITextField *nameTf;
@property (nonatomic,weak)UIView *headView;

@property (nonatomic,strong)XNRConsigneeModel *currentModel;
@property (nonatomic,assign)int nameLength;
@property (nonatomic,strong)NSMutableArray *consigneeArr;
@property (nonatomic,strong)NSMutableArray *iconArr;
@end

@implementation XNRSelContactVC

-(NSMutableArray *)iconArr
{
    if (!_iconArr) {
        _iconArr = [NSMutableArray array];
    }
    return _iconArr;
}
-(NSMutableArray *)consigneeArr
{
    if (!_consigneeArr) {
        _consigneeArr = [NSMutableArray array];
    }
    return _consigneeArr;
}
#pragma mark - 刷新
-(void)setupTotalRefresh{
    
    
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
    [_consigneeArr removeAllObjects];
    [self getData];
    [self.tableView reloadData];
    
    
}
-(void)footRefresh{
    currentPage ++;
    [self getData];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    currentPage = 1;
    [self createTableHeadView];
    [self createTableView];
    _consigneeArr = [NSMutableArray array];
    [self getData];
    [self setupTotalRefresh];
}
//获取收货人列表信息
-(void)getData
{
    [KSHttpRequest get:KqueryConsignees parameters:@{@"userId":[DataCenter account].userid,@"page":[NSNumber numberWithInt:currentPage],@"max":@20} success:^(id result) {
        if ([result[@"code"]integerValue] == 1000) {
            
            NSMutableArray *arr = (NSMutableArray *)[XNRConsigneeModel objectArrayWithKeyValuesArray:result[@"datas"][@"rows"]];
//            [_consigneeArr arrayByAddingObjectsFromArray:arr];
            [_consigneeArr addObjectsFromArray:arr];
            [self.tableView reloadData];

            if (_consigneeArr.count == 0) {
                _nameTf.text = [DataCenter account].name;
                _phoneTf.text = [DataCenter account].phone;
            }

            //如果到达最后一页 就消除footer
            
            NSInteger pages = [result[@"datas"][@"pages"] integerValue];
            NSInteger page = [result[@"datas"][@"page"] integerValue];
            self.tableView.mj_footer.hidden = pages==page;
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [BMProgressView LoadViewDisappear:self.view];
            

        }
        else
        {
            [UILabel showMessage:result[@"message"]];
        }
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [BMProgressView LoadViewDisappear:self.view];
        

    }];
}
//用户选择自提方式时保存收货人信息
-(void)saveConsigneeData
{
    XNRConsigneeModel *model = [[XNRConsigneeModel alloc]init];
    model.consigneeName = self.nameTf.text;
    model.consigneePhone = self.phoneTf.text;
    self.currentModel = model;
    
    NSDictionary *dic = [NSDictionary dictionary];
    dic = @{@"userId":[DataCenter account].userid,@"consigneeName":self.nameTf.text,@"consigneePhone":self.phoneTf.text};
    
    [KSHttpRequest post:KsaveConsignees parameters:dic success:^(id result) {
        if ([result[@"code"]integerValue] == 1000) {
            
            self.setRSCContactChoseBlock(self.currentModel);
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [UILabel showMessage:result[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
//创建tableView
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(564), ScreenWidth, ScreenHeight-PX_TO_PT(564)-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

//创建tableView的tableHeadView
-(void)createTableHeadView
{
    
    [self.headView removeFromSuperview];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(564))];
    self.headView = headView;
    headView.backgroundColor = R_G_B_16(0xf9f9f9);
    UIView *writeInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(23), ScreenWidth, PX_TO_PT(198))];
    
    UILabel *title1Label = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(31), PX_TO_PT(100), PX_TO_PT(37))];
    title1Label.textColor = R_G_B_16(0x323232);
    title1Label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    title1Label.text = @"收货人";
    [writeInfoView addSubview:title1Label];
    
    // 姓名
    UITextField *nameTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title1Label.frame)+PX_TO_PT(32), PX_TO_PT(31), ScreenWidth, PX_TO_PT(37))];
//    nameTf.textAlignment = NSTextAlignmentLeft;
    nameTf.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写收货人的真实姓名" attributes:@{NSForegroundColorAttributeName:R_G_B_16(0x909090)}];
    nameTf.textColor = R_G_B_16(0x323232);
    nameTf.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    nameTf.delegate = self;
    self.nameTf = nameTf;
    [writeInfoView addSubview:nameTf];
    
    // 手机号
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(nameTf.frame)+PX_TO_PT(62), PX_TO_PT(100), PX_TO_PT(37))];
    phonelabel.textColor = R_G_B_16(0x323232);
    phonelabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    phonelabel.text = @"手机号";
    [writeInfoView addSubview:phonelabel];
    
    UITextField *phone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title1Label.frame)+PX_TO_PT(32),CGRectGetMaxY(nameTf.frame)+PX_TO_PT(62), ScreenWidth, PX_TO_PT(37))];
//    phone.textAlignment = NSTextAlignmentLeft;
    phone.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写联系方式" attributes:@{NSForegroundColorAttributeName:R_G_B_16(0x909090)}];
    
    phone.textColor = R_G_B_16(0x323232);
    phone.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    phone.delegate = self;
    //设置键盘类型
    phone.returnKeyType = UIReturnKeyDone;
    phone.keyboardType=UIKeyboardTypeNumberPad;
    phone.clearButtonMode = UITextFieldViewModeAlways;
    phone.textAlignment = NSTextAlignmentLeft;
    self.phoneTf = phone;
    [writeInfoView addSubview:phone];
    
    for (int i=0; i<3; i++)
    {
        UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98)*i+1, ScreenWidth, PX_TO_PT(2))];
        line2View.backgroundColor = R_G_B_16(0xc7c7c7);
        [writeInfoView addSubview:line2View];
    }
    
    [headView addSubview:writeInfoView];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(PX_TO_PT(31), CGRectGetMaxY(writeInfoView.frame) + PX_TO_PT(58), PX_TO_PT(657), PX_TO_PT(89));
    saveBtn.layer.cornerRadius = PX_TO_PT(10);
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    saveBtn.backgroundColor = R_G_B_16(0x00B38A);
    [saveBtn setTintColor:[UIColor whiteColor]];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:saveBtn];
    
    
    UIView *contactView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(465), ScreenWidth, PX_TO_PT(99))];
    contactView.backgroundColor = R_G_B_16(0xF0F0F0);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(29), PX_TO_PT(45), PX_TO_PT(41))];
    [imageView setImage:[UIImage imageNamed:@"history"]];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+PX_TO_PT(24), PX_TO_PT(34), PX_TO_PT(160), PX_TO_PT(32))];
    titleLabel.text = @"历史收货人";
    titleLabel.textColor = R_G_B_16(0x323232);
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xc7c7c7);
    [contactView addSubview:imageView];
    [contactView addSubview:titleLabel];
    [contactView addSubview:line];
    
    [headView addSubview:contactView];
    
    [self.view addSubview:headView];
}
#pragma mark - 正则表达式判断手机号格式
- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - textField代理方法
#pragma mark - 键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.iswarn = NO;
    //验证手机号输入是否正确
    if (textField == self.phoneTf) {
        if(![self validateMobile:self.phoneTf.text])
        {
            [UILabel showMessage:@"手机号格式错误"];
        }
        
    }
    
    else if (textField == self.nameTf) {

        int strlength = 0;
        char* p = (char*)[textField.text cStringUsingEncoding:NSUnicodeStringEncoding];
        for (int i=0 ; i<[textField.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
            if (*p) {
                p++;
                strlength++;
            }
            else {
                p++;
            }
            
        }
        
        self.nameLength = strlength;
        
        if (strlength > 12) {
            [UILabel showMessage:[NSString stringWithFormat:@"您的输入超过限制"]];
        }
    }
    
}

#pragma mark -- tableView的数据源和代理方法
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _consigneeArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(99);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString static *cellID = @"cell";
    XNRConsigneesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XNRConsigneesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.consigneeArr[indexPath.row];

    XNRBtn *iconBtn = [[XNRBtn alloc]initWithFrame:CGRectMake(0, PX_TO_PT(10), ScreenWidth, PX_TO_PT(89))];
    [iconBtn setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [iconBtn setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
    [iconBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchDown];
    iconBtn.tag = indexPath.row;
    XNRConsigneeModel *consigneemodel =self.consigneeArr[indexPath.row];
    if ([consigneemodel.consigneePhone isEqualToString: self.model.consigneePhone] && [consigneemodel.consigneeName isEqualToString:self.model.consigneeName]) {
        iconBtn.selected = YES;
    }
    
    if (self.currentModel == self.consigneeArr[iconBtn.tag]) {
        iconBtn.selected = YES;
    }
    [cell addSubview:iconBtn];
    [_iconArr addObject:iconBtn];


    return cell;
}
// 单选按钮
-(void)iconClick:(UIButton *)sender
{
    for (UIButton *btn in _iconArr) {
        btn.selected = NO;
    }
    sender.selected = YES;
    _currentModel = self.consigneeArr[sender.tag];    
    [self.tableView reloadData];

    self.setRSCContactChoseBlock(self.currentModel);
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)saveBtnClick{
    int flag = 1;
    NSString *title;
    if ([self.nameTf.text isEqualToString:@""] || self.nameTf.text == nil) {
        flag = 0;
        title = @"收货人不能为空";
    }else if ([self.phoneTf.text isEqualToString:@""] || self.phoneTf.text == nil){
        flag = 0;
        title = @"电话号码不能为空";
        
    }else if ([self validateMobile:self.phoneTf.text] == NO){
        flag = 0;
        title = @"手机格式错误";
        
    }
    else if(self.nameLength>12)
    {
        [UILabel showMessage:@"您输入的姓名超过限制"];
    }
    else
    {
        [self saveConsigneeData];
    }
    
    if (flag == 0) {
        
        [UILabel showMessage:title];
    }
}

#pragma mark  - 设置导航
- (void)setNav
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择收货人";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#009975"]] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

- (void)backClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
