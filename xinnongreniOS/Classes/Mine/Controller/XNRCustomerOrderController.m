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
#import "XNRCustomerOrderEmptyView.h"
@interface XNRCustomerOrderController()<UITableViewDelegate,UITableViewDataSource>
{
    int currentPage;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic ,weak) UIView *headView;

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic ,weak) UILabel *nameLabel;

@property (nonatomic ,weak) UILabel *phoneNum;

@property (nonatomic ,weak) UILabel *totalLabel;

@property (nonatomic, weak) XNRCustomerOrderEmptyView *emptyView;

@end

@implementation XNRCustomerOrderController

-(XNRCustomerOrderEmptyView *)emptyView
{
    if (!_emptyView) {
        XNRCustomerOrderEmptyView *emptyView = [[XNRCustomerOrderEmptyView alloc] init];
        self.emptyView = emptyView;
        [self.view addSubview:emptyView];
    }
    return _emptyView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    currentPage = 1;
    [self createHeadView];
    [self createTableView];

    [self getData];
    [self setNavigationbarTitle];
    _dataArray = [[NSMutableArray alloc] init];
    [self setupCustomerOrderRefresh];

}

-(void)setupCustomerOrderRefresh{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    
    NSMutableArray *idleImage = [NSMutableArray array];
    
    
    
    for (int i = 1; i<21; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
        
        
        
        [idleImage addObject:image];
        
    }
    
    NSMutableArray *RefreshImage = [NSMutableArray array];
    
    
    
    for (int i = 1; i<21; i++) {
        
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
    
    [_dataArray removeAllObjects];
    
    [self getData];
}

-(void)footRefresh{
    
    currentPage ++;
    
    [self getData];

}

-(void)getData
{
    NSDictionary *params = @{@"inviteeId":self.inviteeId,@"page":[NSString stringWithFormat:@"%d",currentPage],@"user-agent":@"IOS-v2.0"};
    [KSHttpRequest post:KgetInviteeOrders parameters:params success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datas = result[@"datas"];
            
            if (![KSHttpRequest isNULL:datas[@"name"]]) {
                self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",datas[@"name"]];
            }else{
                self.nameLabel.text = @"该好友未填姓名";
            }
            self.phoneNum.text = [NSString stringWithFormat:@"手机号：%@",datas[@"account"]];
            self.totalLabel.text = [NSString stringWithFormat:@"%@",datas[@"total"]];
            
            NSArray *rows = datas[@"rows"];
            for (NSDictionary *subDic in rows) {
                
                XNRCustomerOrderSectionModel *sectionModel = [[XNRCustomerOrderSectionModel alloc] init];
                
//                sectionModel.account = datas[@"account"];
//                sectionModel.nickname = datas[@"nickname"];
//                sectionModel.name = datas[@"name"];
//                sectionModel.total = datas[@"total"];
                
                sectionModel.dateCreated = subDic[@"dateCreated"];
                sectionModel.typeValue = subDic[@"typeValue"];
                sectionModel.totalPrice = subDic[@"totalPrice"];
                sectionModel.products = (NSMutableArray *)[XNRCustomerOrderModel objectArrayWithKeyValuesArray:subDic[@"products"]];
                [_dataArray addObject:sectionModel];
            }
           
        }
        
        if (_dataArray.count == 0) {
            self.totalLabel.backgroundColor = R_G_B_16(0xe0e0e0);
            self.tableView.scrollEnabled = NO;
            [self emptyView];
        }

        //  如果到达最后一页 就消除footer
        
        NSInteger pages = [result[@"datas"][@"pages"] integerValue];
        
        NSInteger page = [result[@"datas"][@"page"] integerValue];
        
        self.tableView.mj_footer.hidden = pages == page;
    
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView.mj_footer endRefreshing];
        // 刷新
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView.mj_footer endRefreshing];

        
    }];


}
// 在段头添加任意的视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArray.count>0) {
        XNRCustomerOrderSectionModel *sectionModel = _dataArray[section];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
        headView.backgroundColor = R_G_B_16(0xf0f0f0);
        [self.view addSubview:headView];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(30), ScreenWidth, PX_TO_PT(28))];
        timeLabel.textColor = R_G_B_16(0x323232);
        timeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        NSDate *dateFormatted = [dateFormatter dateFromString:sectionModel.dateCreated];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *locationTimeString=[dateFormatter stringFromDate:dateFormatted];
        timeLabel.text = [NSString stringWithFormat:@"下单时间：%@",locationTimeString];

        [headView addSubview:timeLabel];
        
        UILabel *orderTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(88))];
        orderTypeLabel.textColor = R_G_B_16(0xfe9b00);
        orderTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        orderTypeLabel.textAlignment = NSTextAlignmentRight;
        [headView addSubview:orderTypeLabel];
        // 订单状态 0:已关闭 1:待支付  2:待发货 3:已发货 4: 已完成

        if ([sectionModel.typeValue integerValue] == 0) {
            orderTypeLabel.text = @"已关闭";
        }else if ([sectionModel.typeValue integerValue] == 1){
            orderTypeLabel.text = @"待支付";

        }else if ([sectionModel.typeValue integerValue] == 2){
            orderTypeLabel.text = @"待发货";

        }else if ([sectionModel.typeValue integerValue] == 3){
            orderTypeLabel.text = @"已发货";

        }else if ([sectionModel.typeValue integerValue] == 4){
            orderTypeLabel.text = @"已完成";

        }
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        topLineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [headView addSubview:topLineView];
        
        return headView;
    }else{
        return nil;
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataArray.count>0) {
        XNRCustomerOrderSectionModel *sectionModel = _dataArray[section];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(100))];
        footView.backgroundColor = R_G_B_16(0xfafafa);
        [self.view addSubview:footView];
        
        UILabel *orderPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
        orderPriceLabel.textColor = R_G_B_16(0x323232);
        orderPriceLabel.textAlignment = NSTextAlignmentRight;
        orderPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        orderPriceLabel.text = [NSString stringWithFormat:@"订单金额：￥%@",sectionModel.totalPrice];
        NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:orderPriceLabel.text];
        NSDictionary *depositStr=@{

                                   NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                   NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(36)]

                                   };

        [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(5,AttributedStringDeposit.length-5)];
        
        [orderPriceLabel setAttributedText:AttributedStringDeposit];
        [footView addSubview:orderPriceLabel];
        
        UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(20))];
        lastView.backgroundColor = R_G_B_16(0xf4f4f4);
        [footView addSubview:lastView];
        
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        topLineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [footView addSubview:topLineView];

        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, 1)];
        bottomLineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [footView addSubview:bottomLineView];

        return footView;

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
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.nameLabel = nameLabel;
    [headView addSubview:nameLabel];
            
    UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(nameLabel.frame) + PX_TO_PT(30), ScreenWidth, PX_TO_PT(32))];
    phoneNum.textColor = R_G_B_16(0x323232);
    phoneNum.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
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
    orderNumLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
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
    return PX_TO_PT(100);
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
    return PX_TO_PT(100);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    XNRCustomerOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[XNRCustomerOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    if (_dataArray.count>0) {
        XNRCustomerOrderSectionModel *sectionModel = _dataArray[indexPath.section];
        if (sectionModel.products.count>0) {
            XNRCustomerOrderModel *model = sectionModel.products[indexPath.row];
            [cell setCellDataWithCustomerOrderModel:model];
        }
    }
    return cell;
}

#pragma mark -  导航
-(void)setNavigationbarTitle
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = R_G_B_16(0xffffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"客户订单";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0,0,30,44);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
-(void)backButtonClick{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeRedPoint" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
