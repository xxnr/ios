//
//  XNRAddressManagementViewController.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//  地址管理

#import "XNRAddressManageViewController.h"
#import "XNRAddressManageModel.h"
#import "XNRAddressManageTableViewCell.h"
#import "XNROrderInfo_VC.h"
#import "XNRAddAddress_VC.h"
#import "XNRAddressEmptyView.h"

@interface XNRAddressManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArr;
}
@property (nonatomic,strong) UITableView *addressManageTableView;
@property (nonatomic,strong) UIButton *addAddressBtn;
@property (nonatomic,strong) NSString *areaID;

@property (nonatomic ,weak) XNRAddressEmptyView *emptyView;

@end

@implementation XNRAddressManageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(XNRAddressEmptyView *)emptyView{
    if (!_emptyView) {
        XNRAddressEmptyView *emptyView = [[XNRAddressEmptyView alloc] init];
        self.emptyView = emptyView;
        [self.view addSubview:emptyView];
    }
    return _emptyView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [[NSMutableArray alloc]init];
    [self setNav];
    [self createAddressManageTableView];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressRefresh) name:@"addressRefresh" object:nil];
}

-(void)addressRefresh{
    [self getData];
}

#pragma mark - 地址管理
- (void)createAddressManageTableView
{
    self.addressManageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.addressManageTableView.backgroundColor = R_G_B_16(0xfbffff);
    self.addressManageTableView.showsVerticalScrollIndicator = YES;
    self.addressManageTableView.delegate = self;
    self.addressManageTableView.dataSource = self;
    self.addressManageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.addressManageTableView];
}

#pragma mark - 获取数据
- (void)getData
{
 
    [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
    [KSHttpRequest post:KGetUserAddressList parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        [BMProgressView LoadViewDisappear:self.view];

        if([result[@"code"] integerValue] == 1000){
            [_dataArr removeAllObjects];
            for(NSDictionary *dic in result[@"datas"][@"rows"]){
                
                XNRAddressManageModel *model=[[XNRAddressManageModel alloc]init];
                // 选为默认地址
                if ([dic[@"type"] integerValue] == 1) {
                    model.selected = YES;
                }
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
                
            }
            [self.addressManageTableView reloadData];
            
            
        } else {
            
            [UILabel showMessage:result[@"message"]];
            [BMProgressView LoadViewDisappear:self.view];
        }
        if (_dataArr.count == 0) {
            [self.emptyView show];
        }else{
            [self.emptyView removeFromSuperview];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"收货地址";
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchDown];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBtn.frame = CGRectMake(0, 0, 40, 40);
    [addAddressBtn setTitle:@"添加" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addAddressBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [addAddressBtn addTarget:self action:@selector(addAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addAddressBtnClick{
    
    XNRAddAddress_VC *addAddressVC = [[XNRAddAddress_VC alloc] init];
    addAddressVC.titleLabel = @"添加收货地址";
    addAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addAddressVC animated:YES];
}

- (void)backClick:(UIButton *)btn
{
    if (_dataArr.count>0) {
        XNRAddressManageModel *model = _dataArr[0];
        model.selected = YES;
        self.addressChoseBlock(model);
        [self.addressManageTableView reloadData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView代理方法

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(240);
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i<_dataArr.count; i++) {
        XNRAddressManageModel *model = _dataArr[i];
        model.selected = NO;
    }
    XNRAddressManageModel *model = _dataArr[indexPath.row];
    model.selected = YES;
    self.addressChoseBlock(model);
    [self.addressManageTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    XNRAddressManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        // 单元格复用cellID要一致
        cell = [[XNRAddressManageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.contentView.backgroundColor = R_G_B_16(0xfbffff);
    }
    
    XNRAddressManageModel *model = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     // 选中
    cell.selectedBlock = ^{
        
        if (model.selected == YES) {
            self.addressChoseBlock(model);
            [self.addressManageTableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    // 删除
    cell.deleteCellBlock = ^{
        BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"确认要删除该地址吗?" chooseBtns:@[@"取消",@"确定"]];
        
        alertView.chooseBlock = ^void(UIButton *btn){
            
            if (btn.tag == 11) {
                [KSHttpRequest post:KDeleteUserAddress parameters:@{@"userId": [DataCenter account].userid,@"addressId":model.addressId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                    NSLog(@"%@",result);
                    if([result[@"code"] integerValue] == 1000){
                        //每个cell对应一个block 不需要传入indexPath
                        [_dataArr removeObjectAtIndex:indexPath.row];
                        //加删除动画
                        [self.addressManageTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        [self.addressManageTableView reloadData];
                        if (_dataArr.count == 0) {
                            [self.emptyView show];
                        }else{
                            [self.emptyView removeFromSuperview];
                        }
                        
                        if ([model.type integerValue] == 1) {
                            UserInfo *info = [DataCenter account];
                            info.address = [DataCenter account].address;
                            [DataCenter saveAccount:info];
// #TODO:                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyAccount" object:nil];
                        }
                    }
                    [self.addressManageTableView reloadData];
                } failure:^(NSError *error) {
                    [UILabel showMessage:@"删除失败"];
                }];

                
                
            }
            
        };
        
        [alertView BMAlertShow];
        
        
    };
    // 编辑
    cell.editorBtnBlock = ^{
        
        XNRAddAddress_VC *VC = [[XNRAddAddress_VC alloc] init];
        VC.model = model;
        VC.isRoot = YES;
        VC.titleLabel = @"编辑收货地址";
        VC.hidesBottomBarWhenPushed = YES;
        VC.addressRefreshBlock = ^(){
            [self getData];
        };
        [self.navigationController pushViewController:VC animated:YES];
        
    };
    
    //传递数据模型model
    for (XNRAddressManageModel *addModel in _dataArr) {
        addModel.selected = [addModel.addressId isEqualToString:self.addressModel.addressId];
    }
    [cell setCellDataWithAddressManageModel:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
