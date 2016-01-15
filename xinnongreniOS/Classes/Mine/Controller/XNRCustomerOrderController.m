//
//  XNRCustomerOrderController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCustomerOrderController.h"
#import "XNRCustomerOrderSectionModel.h"
#import "XNRCustomerOrderModel.h"
#import "XNRCustomerOrderCell.h"
#import "MJExtension.h"
@interface XNRCustomerOrderController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic ,weak) UIView *headView;

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic ,weak) UILabel *nameLabel;

@property (nonatomic ,weak) UILabel *phoneNum;

@property (nonatomic ,weak) UILabel *totalLabel;

@end

@implementation XNRCustomerOrderController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    


}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self getData];
    _dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationbarTitle];
    [self createHeadView];
    [self createTableView];
}

-(void)getData
{
    NSDictionary *params = @{@"inviteeId":self.inviteeId};
    [KSHttpRequest post:KgetInviteeOrders parameters:params success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datas = result[@"datas"];
            XNRCustomerOrderSectionModel *sectionModel = [[XNRCustomerOrderSectionModel alloc] init];
            sectionModel.account = datas[@"account"];
            sectionModel.nickname = datas[@"nickname"];
            sectionModel.name = datas[@"name"];
            sectionModel.total = datas[@"total"];
            
            self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",sectionModel.name];
            self.phoneNum.text = [NSString stringWithFormat:@"手机号：%@",sectionModel.account];
            self.totalLabel.text = [NSString stringWithFormat:@"%@",sectionModel.total];

            NSArray *rows = datas[@"rows"];
            for (NSDictionary *subDic in rows) {
                sectionModel.dateCreated = subDic[@"dateCreated"];
                sectionModel.products = (NSMutableArray *)[XNRCustomerOrderModel objectArrayWithKeyValuesArray:subDic[@"products"]];
                [_dataArray addObject:sectionModel];
            }
            // 刷新
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
    }];


}
// 在段头添加任意的视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArray.count>0) {
        XNRCustomerOrderSectionModel *sectionModel = _dataArray[section];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
        headView.backgroundColor = R_G_B_16(0xfafafa);
        [self.view addSubview:headView];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(30), ScreenWidth, PX_TO_PT(28))];
        timeLabel.textColor = R_G_B_16(0x323232);
        timeLabel.font = [UIFont systemFontOfSize:14];
        NSString *netDateString = [NSString stringWithFormat:@"%@",sectionModel.dateCreated];
        NSArray *dateArr = [netDateString componentsSeparatedByString:@"T"];
        NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
        [dataFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [dataFormatter stringFromDate:[dataFormatter dateFromString:[dateArr firstObject]]];

        timeLabel.text = [NSString stringWithFormat:@"下单时间：%@",date];
        [headView addSubview:timeLabel];
        
        UILabel *orderTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(88))];
        orderTypeLabel.textColor = R_G_B_16(0xfe9b00);
        orderTypeLabel.font = [UIFont systemFontOfSize:16];
        orderTypeLabel.textAlignment = NSTextAlignmentRight;
        [headView addSubview:orderTypeLabel];
        // 订单状态 0:已关闭 1:待支付  2:待发货 3:已发货 4: 已完成

        if (sectionModel.typeValue == 0) {
            orderTypeLabel.text = @"已关闭";
        }else if (sectionModel.typeValue == 1){
            orderTypeLabel.text = @"待支付";

        }else if (sectionModel.typeValue == 2){
            orderTypeLabel.text = @"待发货";

        }else if (sectionModel.typeValue == 3){
            orderTypeLabel.text = @"已发货";

        }else if (sectionModel.typeValue == 4){
            orderTypeLabel.text = @"已完成";

        }
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
        topLineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:topLineView];
        
        return headView;
    }else{
        return nil;
    }
    
    
}

-(void)createHeadView
{

            
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(140))];
    headView.backgroundColor = [UIColor whiteColor];
    self.headView = headView;
    [self.view addSubview:headView];
            
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(23), ScreenWidth/2, PX_TO_PT(32))];
    nameLabel.textColor = R_G_B_16(0x323232);
    nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel = nameLabel;
    [headView addSubview:nameLabel];
            
    UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(30), ScreenWidth/2, PX_TO_PT(32))];
    phoneNum.textColor = R_G_B_16(0x323232);
    phoneNum.font = [UIFont systemFontOfSize:16];
    self.phoneNum = phoneNum;
    [headView addSubview:phoneNum];
            
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(112), PX_TO_PT(30), PX_TO_PT(80), PX_TO_PT(80))];
    totalLabel.layer.cornerRadius = PX_TO_PT(40);
    totalLabel.layer.masksToBounds = YES;
    totalLabel.backgroundColor = R_G_B_16(0xfe9b00);
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    self.totalLabel = totalLabel;
    [headView addSubview:totalLabel];
            
    UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(56), ScreenWidth/2-PX_TO_PT(130), PX_TO_PT(28))];
    orderNumLabel.textColor = R_G_B_16(0x323232);
    orderNumLabel.font = [UIFont systemFontOfSize:14];
    orderNumLabel.textAlignment = NSTextAlignmentRight;
    orderNumLabel.text = @"订单数：";
    [headView addSubview:orderNumLabel];
    
}
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.tableHeaderView = self.headView;
}

#pragma mark - tableViewDelegate
//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(88);
}

//段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _dataArray.count-1) {
        return 0.0;
    }
    return 10.0;
}

//设置段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count > 0) {
        XNRCustomerOrderSectionModel *sectionModel = _dataArray[section];
        return sectionModel.products.count;
    } else {
        return 0;
    }
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(260);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    XNRCustomerOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[XNRCustomerOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        XNRCustomerOrderSectionModel *sectionModel = _dataArray[indexPath.section];
        XNRCustomerOrderModel *model = sectionModel.products[indexPath.row];
        [cell setCellModelWith:model];
    }
    return cell;
}

#pragma mark -  导航
-(void)setNavigationbarTitle
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = R_G_B_16(0xffffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"客户订单";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0,0,80,44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
