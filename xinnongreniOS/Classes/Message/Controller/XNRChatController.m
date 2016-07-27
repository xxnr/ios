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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    currentPage = 1;
    [self setNav];
    [self setupTableView];
    [self createbackBtn];
    [self getData];
    [self setupRefresh];
}
#pragma mark - 刷新
-(void)setupRefresh{
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
//    for (int i = 1; i<21; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
//        
//        [idleImage addObject:image];
//    }
//    NSMutableArray *RefreshImage = [NSMutableArray array];
//    
//    for (int i = 1; i<21; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
//        
//        [RefreshImage addObject:image];
//        
//    }
    

        
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
    [_messageArr removeAllObjects];
    [self getData];
    
    
}
-(void)footRefresh{
    currentPage ++;
    [self getData];
    
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
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];

    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"新农资讯";
    self.navigationItem.titleView = titleLabel;
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:PX_TO_PT(40)];
//    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"新农资讯";
//    self.navigationItem.titleView = titleLabel;

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
    [KSHttpRequest get:KMessageNews parameters:@{@"max":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"page":[NSString stringWithFormat:@"%d",currentPage],@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dicts = result[@"datas"];
            NSArray *array = dicts[@"items"];
            for (NSDictionary *dict in array) {
                XNRMessageModel *model = [[XNRMessageModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_messageArr addObject:model];
            }
        }
        //如果到达最后一页 就消除footer

        NSInteger pages = [result[@"datas"][@"pages"] integerValue];
        NSInteger page = [result[@"datas"][@"page"] integerValue];
        self.tableView.mj_footer.hidden = pages==page;

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}
#pragma mark -- tableView代理
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -- tableView点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRWebViewController *webViewController = [[XNRWebViewController alloc] init];
    if (_messageArr.count>0) {
        XNRMessageModel *model = _messageArr[indexPath.row];
        webViewController.model = model;
    }
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
