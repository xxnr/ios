//
//  XNRManagerTakeAddressController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/5/10.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRManagerTakeAddressController.h"
#import "XNRAddAddress_VC.h"
#import "XNRAddressEmptyView.h"
#import "XNRManagerAddressCell.h"
#import "XNRAddressManageModel.h"

@interface XNRManagerTakeAddressController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *addressManageTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic ,weak) XNRAddressEmptyView *emptyView;

@end

@implementation XNRManagerTakeAddressController

-(XNRAddressEmptyView *)emptyView{
    if (!_emptyView) {
        XNRAddressEmptyView *emptyView = [[XNRAddressEmptyView alloc] init];
        self.emptyView = emptyView;
        [self.view addSubview:emptyView];
    }
    return _emptyView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    [self setNavigationBar];
    [self createView];
    [self getAddressData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressRefresh) name:@"addressRefresh" object:nil];

}

-(void)addressRefresh{
    [_dataArray removeAllObjects];
    [self getAddressData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)createView
{
    UITableView *addressManageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    addressManageTableView.backgroundColor = R_G_B_16(0xffffff);
    addressManageTableView.showsVerticalScrollIndicator = YES;
    addressManageTableView.delegate = self;
    addressManageTableView.dataSource = self;
    addressManageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addressManageTableView = addressManageTableView;
    [self.view addSubview:addressManageTableView];
}

-(void)getAddressData
{
    [KSHttpRequest post:KGetUserAddressList parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            
        if([result[@"code"] integerValue] == 1000){
            for(NSDictionary *dic in result[@"datas"][@"rows"]){
                
                XNRAddressManageModel *model=[[XNRAddressManageModel alloc]init];
                // 选为默认地址
                if ([dic[@"type"] integerValue] == 1) {
                    model.selected = YES;
                }
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
                
            }
            [self.addressManageTableView reloadData];
        
        } else {
            
            [UILabel showMessage:result[@"message"]];
            [BMProgressView LoadViewDisappear:self.view];
        }
        if (_dataArray.count == 0) {
            [self.emptyView show];
        }else{
            [self.emptyView removeFromSuperview];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView代理方法

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(280);
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    XNRManagerAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        // 单元格复用cellID要一致
        cell = [[XNRManagerAddressCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.contentView.backgroundColor = R_G_B_16(0xfbffff);
    }
    
    XNRAddressManageModel *model = _dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 删除
    cell.deleteCellBlock = ^{
        BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"确认要删除该地址吗?" chooseBtns:@[@"取消",@"确定"]];
        
        alertView.chooseBlock = ^void(UIButton *btn){
            
            if (btn.tag == 11) {
                [KSHttpRequest post:KDeleteUserAddress parameters:@{@"userId": [DataCenter account].userid,@"addressId":model.addressId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                    NSLog(@"%@",result);
                    if([result[@"code"] integerValue] == 1000){
                        //每个cell对应一个block 不需要传入indexPath
                        [_dataArray removeObjectAtIndex:indexPath.row];
                        //加删除动画
                        [self.addressManageTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        [self.addressManageTableView reloadData];
                        if (_dataArray.count == 0) {
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
            [self getAddressData];
        };
        [self.navigationController pushViewController:VC animated:YES];
    };
    
    //传递数据模型model
//    for (XNRAddressManageModel *addModel in _dataArray) {
//        addModel.selected = [addModel.addressId isEqualToString:self.addressModel.addressId];
//    }
    [cell setCellDataWithAddressManageModel:model];
    
    return cell;
}


-(void)setNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"管理收货地址";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 30, 44);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem  *leftItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBtn.frame = CGRectMake(0, 0, 40, 40);
    [addAddressBtn setTitle:@"添加" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addAddressBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [addAddressBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)searchBtnClick
{
    XNRAddAddress_VC *addressVC = [[XNRAddAddress_VC alloc] init];
    addressVC.hidesBottomBarWhenPushed  = YES;
    addressVC.titleLabel = @"添加收货地址";
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
