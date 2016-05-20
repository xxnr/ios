//
//  XNRCarryVC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCarryVC.h"
#import "XNRRSCInfoModel.h"
#import "XNRCheckOrderSectionModel.h"
#import "XNRMyOrderModel.h"
#import "XNRDeliveryCell.h"
@interface XNRCarryVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIView *topView;
@property (nonatomic,weak)UIView *midView;
@property (nonatomic,weak)UIView *threeView;
@property (nonatomic,weak)UIView *tbHeadView;
@property (nonatomic,strong)XNRRSCInfoModel *model;
@property (nonatomic,copy)NSString *carryNum;
@end

@implementation XNRCarryVC
-(NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationbarTitle];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = R_G_B_16(0xf9f9f9);
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 0, 0))];
    self.tableView.tableHeaderView=[[UIView alloc] initWithFrame:(CGRectMake(0,20,82,0.5))];
    
    [self.view addSubview:tableView];
    
    [self getDeliveryCode];
    
}
#pragma mark -- UItableView的数据源和代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGRectGetMaxY(self.threeView.frame);
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    [self createCenter];
    UIView *tbHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(500))];
    
    tbHeadView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(_threeView.frame));
    self.tbHeadView = tbHeadView;
    [_tbHeadView addSubview:_topView];
    [_tbHeadView addSubview:_midView];
    [_tbHeadView addSubview:_threeView];
    
    return _tbHeadView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRMyOrderModel *model = self.modelArr[indexPath.row];
    
    static NSString *cellID = @"cellID";
    XNRDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XNRDeliveryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell setModel:model];
    
    return cell;
    
}

-(void)createCenter
{
    UIView *tbHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(500))];
    self.tbHeadView = tbHeadView;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(180))];
    topView.backgroundColor = [UIColor whiteColor];
    self.topView = topView;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(47), ScreenWidth, PX_TO_PT(32))];
    title.text = @"商品已配送至服务网点,请凭自提码到网点提货";
    title.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    title.textColor = R_G_B_16(0x646464);
    [self.topView addSubview:title];
    
    UILabel *carryLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(title.frame)+PX_TO_PT(26), ScreenWidth, PX_TO_PT(32))];
    carryLabel.textColor = R_G_B_16(0xFF4E00);
    carryLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    carryLabel.text = self.carryNum;
    [self.topView addSubview:carryLabel];
    
    
    //    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.topView.frame)+PX_TO_PT(18), ScreenWidth, PX_TO_PT(30))];
    //    headLabel.text = @"服务网点";
    //    headLabel.textColor = R_G_B_16(0x646464);
    //    headLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    //    [self.view addSubview:headLabel];
    
    UIView *midView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame)+PX_TO_PT(18), ScreenWidth, PX_TO_PT(400))];
    midView.backgroundColor = [UIColor whiteColor];
    
    self.midView = midView;
    [self.view addSubview:_midView];
    NSArray *titleNameArr = @[@"服务网点",@"网点名称",@"地址",@"电话"];
    NSArray *detailArr = @[@" ",self.model.companyName,self.model.RSCAddress,self.model.RSCPhone];
    CGFloat maxY = 0;
    for (int i=0; i<4; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), maxY+PX_TO_PT(30), PX_TO_PT(130), PX_TO_PT(30))];
        titleLabel.text = titleNameArr[i];
        titleLabel.textColor = R_G_B_16(0x646464);
        titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        
        NSString *str = detailArr[i];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(32)] constrainedToSize:CGSizeMake(PX_TO_PT(500), MAXFLOAT)];
        
        UILabel *DetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+PX_TO_PT(29), maxY+PX_TO_PT(28), PX_TO_PT(500), size.height)];
        DetailLabel.text = str;
        DetailLabel.textColor = R_G_B_16(0x323232);
        DetailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        DetailLabel.numberOfLines = 0;
        [midView addSubview:DetailLabel];
        [midView addSubview:titleLabel];
        
        maxY = CGRectGetMaxY(DetailLabel.frame)+PX_TO_PT(28);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, maxY+1, ScreenWidth, PX_TO_PT(1))];
        line.backgroundColor = R_G_B_16(0xE0E0E0);
        [midView addSubview:line];
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(1), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [midView addSubview:line];
    
    midView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame)+PX_TO_PT(18), ScreenWidth, maxY);
    
    UIView *threeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(midView.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(89))];
    threeView.backgroundColor = R_G_B_16(0xf4f4f4);
    self.threeView = threeView;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(31), ScreenWidth, PX_TO_PT(30))];
    titleLabel.text = @"可自提商品";
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    titleLabel.textColor = R_G_B_16(0x646464);
    [threeView addSubview:titleLabel];
    
    
    for(int i=0;i<2;i++)
    {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(89)*i, ScreenWidth, PX_TO_PT(1))];
        line.backgroundColor = R_G_B_16(0xe0e0e0);
        [threeView addSubview:line];
        
    }
    tbHeadView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(threeView.frame));
    
    [_tbHeadView addSubview:_topView];
    [_tbHeadView addSubview:_midView];
    [_tbHeadView addSubview:_threeView];
    
    //    [self.view addSubview:_tbHeadView];
    
}
-(void)createEmptyCenter
{
    [self.midView removeFromSuperview];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.topView.frame)+PX_TO_PT(25), ScreenWidth, PX_TO_PT(30))];
    headLabel.text = @"请到服务网点完成线下支付";
    headLabel.textColor = R_G_B_16(0x646464);
    headLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    [self.view addSubview:headLabel];
    
    UIView *midView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headLabel.frame)+PX_TO_PT(32), ScreenWidth, PX_TO_PT(400))];
    midView.backgroundColor = [UIColor whiteColor];
    self.midView = midView;
    [self.view addSubview:_midView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(30), PX_TO_PT(130), PX_TO_PT(30))];
    titleLabel.text = @"服务网点";
    titleLabel.textColor = R_G_B_16(0x646464);
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    
    [midView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(90), ScreenWidth, PX_TO_PT(1))];
    line.backgroundColor = R_G_B_16(0xE0E0E0);
    [midView addSubview:line];
    
    UIImageView *emptyimageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(297), CGRectGetMaxY(line.frame)+PX_TO_PT(58), PX_TO_PT(126), PX_TO_PT(116))];
    emptyimageView.image = [UIImage imageNamed:@"branches-0"];
    emptyimageView.contentMode = UIViewContentModeScaleAspectFit;
    [midView addSubview:emptyimageView];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(emptyimageView.frame)+PX_TO_PT(58), ScreenWidth, PX_TO_PT(30))];
    detailLabel.text = @"小新正在为您匹配最近的网点,请稍后从我的订单查看";
    detailLabel.textColor = R_G_B_16(0x909090);
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    
    [midView addSubview:detailLabel];
    
    for (int i=0; i<2; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(394)*i, ScreenWidth, PX_TO_PT(1))];
        line.backgroundColor = R_G_B_16(0xe0e0e0);
        [midView addSubview:line];
    }
    
}
-(void)getDeliveryCode
{
    [KSHttpRequest get:KgetDeliveryCode parameters:@{@"orderId":self.orderId} success:^(id result) {
        if ([result[@"code"]integerValue] == 1000) {
            self.carryNum = result[@"deliveryCode"];
            [self getServiceData];
        }
        else
        {
            [UILabel showMessage:result[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)getServiceData
{
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            
            XNRCheckOrderSectionModel *orderModel = [XNRCheckOrderSectionModel objectWithKeyValues:result[@"datas"][@"rows"]];
            
            if (orderModel.RSCInfo.count != 0) {
                self.model = [XNRRSCInfoModel objectWithKeyValues:orderModel.RSCInfo];
                [self createCenter];
            }
            else
            {
                [self createEmptyCenter];
            }
            
            //            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
            //
            //            tableView.backgroundColor = R_G_B_16(0xf9f9f9);
            //
            //            tableView.delegate = self;
            //            tableView.dataSource = self;
            //            self.tableView = tableView;
            //
            //            [self.view addSubview:tableView];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    
}
#pragma mark -  导航
-(void)setNavigationbarTitle
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = R_G_B_16(0xffffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"网点自提";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0,0,30,44);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
-(void)backButtonClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeRedPoint" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
