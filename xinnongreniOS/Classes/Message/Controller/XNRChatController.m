//
//  XNRChatController.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/24.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRChatController.h"
#import "XNRMessageModel.h"
#import "XNRMessageCell.h"
#import "XNRWebViewController.h"
#import "MJRefresh.h"
#define MAX_PAGE_SIZE 10

@interface XNRChatController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_messageArr;
    int currentPage;
}
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic ,weak) UIButton *backtoTopBtn;
@end

@implementation XNRChatController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setupRefresh];
    
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self setNav];
    [self setupTableView];
    [self createbackBtn];
    [self getData];
}

-(void)setupRefresh{
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [_messageArr removeAllObjects];
        currentPage = 1;
        [weakSelf getData];
    }];
//    [self.tableView.header beginRefreshing];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        currentPage = currentPage + 1;
        [weakSelf getData];
    }];
}

-(void)createbackBtn
{
    UIButton *backtoTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backtoTopBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(60)-PX_TO_PT(32), ScreenHeight-PX_TO_PT(360), PX_TO_PT(100), PX_TO_PT(100));
    [backtoTopBtn setImage:[UIImage imageNamed:@"icon_home_backTop"] forState:UIControlStateNormal];
    [backtoTopBtn addTarget:self action:@selector(backtoTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backtoTopBtn = backtoTopBtn;
    [self.view addSubview:backtoTopBtn];
}

-(void)backtoTopBtnClick{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y == 0) {
        self.backtoTopBtn.hidden = YES;
    }else{
        self.backtoTopBtn.hidden = NO;
    }
}



-(void)setNav{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textColor = R_G_B_16(0xfbffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"新农资讯";
    self.navigationItem.titleView = titleLabel;
}
-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    UIView * view = [[UIView alloc] init];
    [tableView setTableFooterView:view];
    _messageArr = [NSMutableArray array];
    self.tableView = tableView;
    [self.view addSubview:tableView];

}

-(void)getData
{
    [KSHttpRequest get:KMessageNews parameters:@{@"max":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",currentPage]} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dicts = result[@"datas"];
            NSArray *array = dicts[@"items"];
            for (NSDictionary *dict in array) {
                XNRMessageModel *model = [[XNRMessageModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_messageArr addObject:model];
            }
        }
        NSInteger pages = [result[@"datas"][@"pages"] integerValue];
        NSInteger page = [result[@"datas"][@"page"] integerValue];
        //如果到达最后一页 就消除footer
        //如果没有达到最后一页 就显示footer
        self.tableView.legendFooter.hidden = pages==page;

        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];


    }];

}
#pragma mark -- 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(190);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   XNRMessageCell *cell = [XNRMessageCell cellWithTableView:tableView];
    if (_messageArr.count>0) {
        XNRMessageModel *model = _messageArr[indexPath.row];
        cell.model = model;
    }
    return cell;
}
#pragma mark -- 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XNRWebViewController *webViewController = [[XNRWebViewController alloc] init];
    XNRMessageModel *model = _messageArr[indexPath.row];
    webViewController.model = model;
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
