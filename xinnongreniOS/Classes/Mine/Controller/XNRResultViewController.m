//
//  XNRResultViewController.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/8/3.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRResultViewController.h"
#import "XNRMyRepresentModel.h"
#import "XNRBookUser.h"
#import "XNRMyRepresent_cell.h"
#import "XNRUser_Cell.h"
#import "XNRCustomerOrderController.h"
#import "XNRDetailUserVC.h"
#import "XNRSearchBar.h"

@interface XNRResultViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate>

@property (nonatomic, weak) XNRSearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *searchResultArr;

@property (nonatomic,weak) UIView *NoUserView;
@end

@implementation XNRResultViewController

-(NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
-(NSArray *)userArr
{
    if (!_userArr) {
        _userArr = [NSArray array];
    }
    return _userArr;
}

- (NSMutableArray *)searchResultArr
{
    if (_searchResultArr == nil)
    {
        _searchResultArr = [NSMutableArray array];
    }
    return _searchResultArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self preferredStatusBarStyle];
    
    self.view.backgroundColor = R_G_B_16(0xfafafa);
    self.navigationItem.hidesBackButton = YES;
    XNRSearchBar *searchBar = [XNRSearchBar searchBar];
    searchBar.placeholder = @" 姓名/手机号";
    [searchBar setValue:[UIFont boldSystemFontOfSize:PX_TO_PT(28)]forKeyPath:@"_placeholderLabel.font"];
    
    [searchBar setValue:R_G_B_16(0xB0B0B0) forKeyPath:@"_placeholderLabel.textColor"];
    searchBar.textColor = R_G_B_16(0x323232);
    searchBar.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    searchBar.x = PX_TO_PT(32);
    searchBar.width = ScreenWidth-PX_TO_PT(60)-PX_TO_PT(32);
    searchBar.height = PX_TO_PT(60);
    searchBar.returnKeyType = UIReturnKeySearch;
    [searchBar becomeFirstResponder];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;
    
    [self setNavigationBar];
 
    [self createView];
    
}
- (void)createView
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [self.view addSubview:line];
    
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(1), ScreenWidth, ScreenHeight)style:UITableViewStylePlain];

        tableView.backgroundColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = YES;
        tableView.delegate = self;
        tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        tableView.dataSource = self;
        tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        self.tableView = tableView;
        [self.view addSubview:tableView];

    UIView *Nouser = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(235), PX_TO_PT(188), PX_TO_PT(252), PX_TO_PT(282))];
    Nouser.hidden = YES;
    self.NoUserView = Nouser;
    
    UIImage *image = [UIImage imageNamed:@"can't-find-_icon-0"];
    UIImageView *NoUserImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(30), 0, image.size.width,image.size.height)];
    NoUserImageView.image = image;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, NoUserImageView.height+PX_TO_PT(40), PX_TO_PT(252), PX_TO_PT(30))];
    label.text = @"未查找到相关用户";
    label.textColor = R_G_B_16(0xc7c7c7);
    label.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    
    [self.NoUserView addSubview:NoUserImageView];
    [self.NoUserView addSubview:label];
    
    [self.view addSubview:self.NoUserView];
}
-(void)setNavigationBar{

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(PX_TO_PT(10), 0, PX_TO_PT(60), 40);
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [searchBtn setTitleColor:R_G_B_16(0x00B38A) forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_navbg"] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor_Ext:R_G_B_16(0xFAFAFA)] forBarMetrics:UIBarMetricsDefault];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)searchBtnClick
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchResultArr.count <= 0) {
        return 0;
    }
        NSArray *Arr = [NSArray array];
        Arr = self.searchResultArr[section];
        return Arr.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchResultArr.count <= 0) {
        return 0;
    }
    NSArray *Arr =self.searchResultArr[section];
    if (Arr.count <=0) {
        return 0;
    }
    NSArray *itemarr =self.searchResultArr[0];
    if (section == 0 || itemarr.count == 0) {
        return PX_TO_PT(61);
    }
    return PX_TO_PT(80);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *topView = [[UIView alloc]init];
    UIView *headView = [[UIView alloc]init];

    NSArray *itemarr =self.searchResultArr[0];
    if (section == 0 || itemarr.count == 0) {
        topView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(61));
        headView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(61));
    }
    else
    {
        topView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80));
        headView.frame = CGRectMake(0, PX_TO_PT(19), ScreenWidth, PX_TO_PT(61));
    }
    headView.backgroundColor = [UIColor whiteColor];
    for(int i=0;i<2;i++){
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(60)*i, ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [headView addSubview:line];
    }
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), 0, PX_TO_PT(120), headView.height)];
    headLabel.text = section == 0?@"我的客户":@"客户登记";
    headLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    headLabel.textColor = R_G_B_16(0x909090);
    [headView addSubview:headLabel];
    
    [topView addSubview:headView];
    return topView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchResultArr.count <= 0) {
        return nil;
    }
    if (indexPath.section == 0) {
        XNRMyRepresent_cell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRepresent_cell"];
        
        if (cell == nil)
        {
            cell = [[XNRMyRepresent_cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyRepresent_cell"];
        }
        
        XNRMyRepresentModel *model = self.searchResultArr[indexPath.section][indexPath.row];
        cell.model = model;
        return cell;
    }
    else
    {
        XNRUser_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"User_Cell"];
        
        if (cell == nil)
        {
            cell = [[XNRUser_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"User_Cell"];
        }
        
        XNRBookUser *model = self.searchResultArr[indexPath.section][indexPath.row];
        cell.model = model;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchResultArr.count <= 0) {
        return 0;
    }
    return PX_TO_PT(99);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.searchResultArr.count <= 0) {
        return ;
    }
    if (indexPath.section == 0) {
        XNRCustomerOrderController *customerVC = [[XNRCustomerOrderController alloc] init];
        customerVC.hidesBottomBarWhenPushed = YES;
        NSArray *itemArr = self.searchResultArr[indexPath.section];
        
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
        
        XNRBookUser *user = self.searchResultArr[indexPath.section][indexPath.row];
        detailUser._id = user._id;
        [self.navigationController pushViewController:detailUser animated:YES];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.NoUserView.hidden = YES;
    
    NSMutableString *currentStr = [NSMutableString stringWithString:textField.text];
    
    if (/*[string isEqualToString:@""] && */range.length) {
        [currentStr deleteCharactersInRange:range];
    }
    else
    {
        [currentStr insertString:string atIndex:range.location];
    }
    
    if (currentStr.length == 0 && range.location == 0) {
        [self.searchResultArr removeAllObjects];
        [self.tableView reloadData];
        return YES;
    }

        [self.searchResultArr removeAllObjects];
    
        __block NSMutableArray *resultArr = [NSMutableArray array];

        [_dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSArray *arr = (NSArray *)obj;
            
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                XNRMyRepresentModel *model = (XNRMyRepresentModel *)obj;
                
                if ([model.name containsString:currentStr] ||[model.account isEqualToString:currentStr])
                {
                    [resultArr addObject:model];
                }
                
            }];

        }];
    
    [self.searchResultArr addObject:resultArr];

    
    __block NSMutableArray *userresultArr = [NSMutableArray array];

        [_userArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSArray *arr = (NSArray *)obj;
            
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                XNRBookUser *model = (XNRBookUser *)obj;
                
                if ([model.name containsString:currentStr] ||[model.phone isEqualToString:currentStr])
                {
                    [userresultArr addObject:model];
                }

            }];
            
        }];

    [self.searchResultArr addObject:userresultArr];
    [self.tableView reloadData];
    
    NSArray *customerArr = [NSArray arrayWithArray:self.searchResultArr[0]];
    NSArray *userArr = [NSArray arrayWithArray:self.searchResultArr[1]];
    if(customerArr.count + userArr.count <= 0)
    {
        self.NoUserView.hidden = NO;
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.NoUserView.hidden = YES;
    
    [self.searchResultArr removeAllObjects];
    [self.tableView reloadData];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tableView reloadData];
    return YES;
}


@end
