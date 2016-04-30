//
//  XNRRscOrderDetialController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscOrderDetialController.h"
#import "XNRRscOrderDetailModel.h"
#import "XNRRscOrderDetialFrameModel.h"
#import "XNRRscOrderModel.h"
#import "XNRRscOrderDetialCell.h"
#import "XNRRscOrderDetialHeadView.h"

@interface XNRRscOrderDetialController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) XNRRscOrderDetialHeadView *headView;

@property (nonatomic, weak) UITableView *tableView;


@end

@implementation XNRRscOrderDetialController

-(void)viewDidLoad
{
    [super viewDidLoad];
<<<<<<< HEAD
    [self setNavigationBar];
    self.view.backgroundColor = R_G_B_16(0xffffff);
=======
    _dataArray = [NSMutableArray array];
    [self setNavigationBar];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self createView];
    [self getOrderDetialData];
}

-(void)createView
{
    XNRRscOrderDetialHeadView *headView =  [[XNRRscOrderDetialHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(798))];
    self.headView = headView;
    [self.view addSubview:headView];
        
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = R_G_B_16(0xf4f4f4);
    tableView.tableHeaderView = headView;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

-(void)getOrderDetialData
{
    
    [KSHttpRequest get:KRscOrderDetail parameters:@{@"orderId":self.orderId} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"order"];
            XNRRscOrderDetailModel *model = [[XNRRscOrderDetailModel alloc] init];
            model.SKUList = (NSMutableArray *)[XNRRscSkusModel objectArrayWithKeyValuesArray:dict[@"SKUList"]];
            model.consigneeName = dict[@"consigneeName"];
            model.consigneePhone = dict[@"consigneePhone"];
            model.dateCreated = dict[@"dateCreated"];
            model.deposit = dict[@"deposit"];
            model.totalPrice = dict[@"totalPrice"];
            model.subOrders = (NSMutableArray *)[XNRRscSubOrdersModel objectArrayWithKeyValuesArray:dict[@"subOrders"]];
            
            for (XNRRscSkusModel *skuModel in model.SKUList ) {
                XNRRscOrderDetialFrameModel *frameModel = [[XNRRscOrderDetialFrameModel alloc] init];
                frameModel.model = skuModel;
                [model.SKUFrameList addObject:frameModel];
            }

            [_dataArray addObject:model];
            [self.headView updataWithModel:model];

        }

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    

}
//#pragma mark - 在段头添加任意视图
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    return tableHeadView;
//}


//#pragma mark - 在段尾添加任意视图
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return nil;
//}
//
//#pragma mark - tableView代理方法

//// 段头高度
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return PX_TO_PT(798);
//    
//}
//
//// 段尾高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return PX_TO_PT(100);
//    
//}
// 设置段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XNRRscOrderDetailModel *model = _dataArray[section];
    return model.SKUList.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscOrderDetailModel *model = _dataArray[indexPath.section];
    XNRRscOrderDetialFrameModel *frameModel = model.SKUFrameList[indexPath.row];
    return frameModel.cellHeight;
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRRscOrderDetialCell *cell = [XNRRscOrderDetialCell cellWithTableView:tableView];
    XNRRscOrderDetailModel *model = _dataArray[indexPath.section];
    XNRRscOrderDetialFrameModel *frameModel = model.SKUFrameList[indexPath.row];
    cell.frameModel = frameModel;
    return cell;
    
}


-(void)setNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单详情";
    self.navigationItem.titleView = titleLabel;
>>>>>>> master
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

<<<<<<< HEAD
-(void)setNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"服务站订单";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

=======
>>>>>>> master

@end
