//
//  XNRSelWebSiteVC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSelWebSiteVC.h"
#import "XNRSelWebSiteCell.h"
#import "XNRCityCell.h"
#import "XNRSelWebBtn.h"
#import "XNRRSCModel.h"
#import "XNRRSCDetailModel.h"
#import "XNRCompanyAddressModel.h"
#import "XNRCityDetailModel.h"

#define Tag 1000
#define TableViewTag 2000
@interface XNRSelWebSiteVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int currentPage;
}
@property (nonatomic,weak)UIView *topView;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UITableView *tableView2;
@property (nonatomic,weak)UIButton *proviceBtn;
@property (nonatomic,weak)UIButton *cityBtn;
@property (nonatomic,weak) UIButton *areaBtn;
@property (nonatomic,weak) UIButton *currentBtn;
@property (nonatomic,weak) XNRSelWebBtn *iconBtn;
@property (nonatomic,weak)UIView *coverView;
@property (nonatomic,weak)UIView *rollView;
@property (nonatomic,strong)NSString *proviceId;
@property (nonatomic,strong)NSString *cityId;
@property (nonatomic,strong)NSString *areaId;
@property (nonatomic,strong) NSMutableArray *dataArr;
//@property (nonatomic,strong) NSMutableArray *selProArr;
@property (nonatomic,strong) XNRRSCModel *currentModel;
@property (nonatomic,strong) NSMutableArray *iconArr;
@property (nonatomic,strong) NSMutableArray *provinceList;
@property (nonatomic,strong) NSMutableArray *cityList;
@property (nonatomic,strong) NSMutableArray *areaList;
@property (nonatomic,strong) NSMutableArray *currentCityArr;

@property (nonatomic,strong) NSIndexPath *proIndexPath;
@property (nonatomic,strong) NSIndexPath *cityIndexPath;
@property (nonatomic,strong) NSIndexPath *areaIndexPath;
@end

@implementation XNRSelWebSiteVC
-(NSMutableArray *)currentCityArr
{
    if (!_currentCityArr) {
        _currentCityArr = [NSMutableArray array];
    }
    return _currentCityArr;
}
-(NSMutableArray *)provinceList
{
    if (!_provinceList) {
        _provinceList = [NSMutableArray array];
    }
    return _provinceList;
}
-(NSMutableArray *)cityList
{
    if (!_cityList) {
        _cityList = [NSMutableArray array];
    }
    return _cityList;
}
-(NSMutableArray *)areaList
{
    if (!_areaList) {
        _areaList = [NSMutableArray array];
    }
    return _areaList;
}
//-(NSMutableArray *)iconArr
//{
//    if (!_iconArr) {
//        _iconArr = [NSMutableArray array];
//    }
//    return _iconArr;
//}
//-(NSMutableArray *)selProArr
//{
//    if (!_selProArr) {
//        _selProArr = [NSMutableArray array];
//    }
//    return  _selProArr;
//}
//-(NSMutableArray *)dataArr
//{
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//    }
//    return _dataArr;
//}

-(void)getData
{
    
    [KSHttpRequest get:KgetRSC parameters:@{@"products":self.proId,@"province":self.proviceId?self.proviceId:@"",@"city":self.cityId?self.cityId:@"",@"county":self.areaId?self.areaId:@"",@"page":[NSNumber numberWithInt:currentPage],@"max":@10} success:^(id result)
     {
        if ([result[@"code"]integerValue] == 1000) {
            
             if(currentPage == 1)
             {
                 [_dataArr removeAllObjects];
             }
            NSMutableArray *arr = (NSMutableArray *)[XNRRSCModel objectArrayWithKeyValuesArray:result[@"RSCs"]];
            [_dataArr addObjectsFromArray:arr];
            
            if (_dataArr.count == 0) {
                [UILabel showMessage:result[@"message"]];
            }
            else
            {
                [self.tableView reloadData];
            }
            
            //如果到达最后一页 就消除footer
            
            NSInteger pages = [result[@"datas"][@"pages"] integerValue];
            NSInteger page = [result[@"datas"][@"page"] integerValue];
            self.tableView.mj_footer.hidden = pages==page;
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [BMProgressView LoadViewDisappear:self.view];

        }
         else
         {
             [self.tableView.mj_header endRefreshing];
             [self.tableView.mj_footer endRefreshing];
         }
         
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [BMProgressView LoadViewDisappear:self.view];
        

    }];
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
//    [_dataArr removeAllObjects];
    [self getData];
//    [self.tableView reloadData];
    
    
}
-(void)footRefresh{
    
    currentPage ++;
    [self getData];
//    [self.tableView reloadData];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    _dataArr = [NSMutableArray array];
    _iconArr = [NSMutableArray array];
    currentPage = 1;
    [self getData];
    [self createTop];
    
    [self createBottom];

    [self createMidView];

    [self setupTotalRefresh];
    // Do any additional setup after loading the view.
}
-(void)createTop{
    UIButton *proviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proviceBtn.frame = CGRectMake(0,0, ScreenWidth/3, PX_TO_PT(89));
    proviceBtn.tag =Tag;
    [proviceBtn setTitle:@"河南" forState:UIControlStateNormal];
    proviceBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    proviceBtn.backgroundColor = [UIColor whiteColor];
    [proviceBtn setTitleColor:R_G_B_16(0xff4e00) forState:UIControlStateSelected];
    [proviceBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [proviceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"bottom-arrow"];
    [proviceBtn setImage:image forState:UIControlStateNormal];
    [proviceBtn setImage:[UIImage imageNamed:@"top--arrow"] forState:UIControlStateSelected];

    proviceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [proviceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, PX_TO_PT(180), 0, 0)];

    
    [proviceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width+PX_TO_PT(30))];
//    [proviceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width+image.size.width+PX_TO_PT(20), 0, -size.width-image.size.width-PX_TO_PT(20))];
    
    
    self.proviceBtn = proviceBtn;
//    [self btnClick:proviceBtn];
    [self.view addSubview:proviceBtn];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(CGRectGetMaxX(self.proviceBtn.frame),0, ScreenWidth/3, PX_TO_PT(89));
    cityBtn.tag = Tag+1;
    [cityBtn setTitle:@"全部地区" forState:UIControlStateNormal];
    cityBtn.backgroundColor = [UIColor whiteColor];

    cityBtn.adjustsImageWhenHighlighted = NO;
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [cityBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [cityBtn setTitleColor:R_G_B_16(0xff4e00) forState:UIControlStateSelected];
    cityBtn.adjustsImageWhenHighlighted = NO;
    [cityBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cityBtn setImage:[UIImage imageNamed:@"bottom-arrow"] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"top--arrow"] forState:UIControlStateSelected];

   
    [cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, PX_TO_PT(180), 0, 0)];

    [cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width+PX_TO_PT(30))];

    
    self.cityBtn = cityBtn;
    [self.view addSubview:cityBtn];
    
    UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    areaBtn.frame = CGRectMake(CGRectGetMaxX(self.cityBtn.frame),0, ScreenWidth/3, PX_TO_PT(89));
    areaBtn.tag = Tag+2;
    [areaBtn setTitle:@"全部地区" forState:UIControlStateNormal];
    areaBtn.backgroundColor = [UIColor whiteColor];
    [areaBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [areaBtn setTitleColor:R_G_B_16(0xC7C7C7) forState:UIControlStateDisabled];
    cityBtn.adjustsImageWhenHighlighted = NO;
    areaBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [areaBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [areaBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [areaBtn setImage:[UIImage imageNamed:@"bottom-arrow"] forState:UIControlStateNormal];
    [areaBtn setImage:[UIImage imageNamed:@"top--arrow"] forState:UIControlStateSelected];

    [areaBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width+PX_TO_PT(30))];
    [areaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, PX_TO_PT(180), 0, 0)];
    
    areaBtn.enabled = NO;
    self.areaBtn = areaBtn;
    [self.view addSubview:areaBtn];
    
    for (int i = 1; i<3; i++) {
        UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(i*(ScreenWidth/3), PX_TO_PT(17), 1, PX_TO_PT(61))];
        midView.backgroundColor = R_G_B_16(0xe0e0e0);
        [self.view addSubview:midView];
    }
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(87), ScreenWidth, 1)];
    bottomLine.backgroundColor = R_G_B_16(0xe0e0e0);
    [self.view addSubview:bottomLine];
    
    UIView *rollView = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(86), ScreenWidth/3, PX_TO_PT(2))];
    self.rollView = rollView;
    rollView.hidden = YES;
    rollView.backgroundColor = R_G_B_16(0xFF4E00);
    [self.view addSubview:rollView];
    
    
}
-(void)createBottom
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight - PX_TO_PT(99)-64, ScreenWidth, PX_TO_PT(99))];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(2))];
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [bottomView addSubview:line];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(161))/2, (PX_TO_PT(99)-PX_TO_PT(52))/2, PX_TO_PT(161), PX_TO_PT(52))];
    sureBtn.backgroundColor = R_G_B_16(0xFE9B00);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    sureBtn.layer.cornerRadius = PX_TO_PT(10);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
}
//确认按钮
-(void)sureBtnClick
{
    if (self.currentModel) {
        self.RSCDetailChoseBlock(self.currentModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [UILabel showMessage:@"请选择一个自提网点"];
    }
}
-(void)createMidView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.proviceBtn.frame), ScreenWidth, self.view.height-CGRectGetMaxY(self.proviceBtn.frame)-PX_TO_PT(99)-64) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundColor = R_G_B_16(0xf9f9f9);
    tableView.tag = TableViewTag;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.proviceBtn.frame), ScreenWidth, ScreenHeight)];
    self.coverView = coverView;
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.3;
    coverView.hidden = YES;
    [self.view addSubview:coverView];

    UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, -(ScreenHeight-CGRectGetMaxY(self.proviceBtn.frame)), ScreenWidth, self.view.height-self.proviceBtn.height) style:UITableViewStylePlain];
//    tableView2.backgroundColor = [UIColor blackColor];
//    tableView2.alpha = 0.3;
    tableView2.backgroundColor = [UIColor clearColor];
    tableView2.tag = TableViewTag+1;
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView2 = tableView2;
    [self.view addSubview:tableView2];
    
}
-(void)btnClick:(UIButton *)sender
{
    
    self.rollView.frame = CGRectMake((sender.tag - Tag)*ScreenWidth/3, PX_TO_PT(86), ScreenWidth/3, PX_TO_PT(2));
    self.rollView.hidden = NO;
    
    self.coverView.hidden = NO;

    [UIView animateWithDuration:0.1f animations:^{
        self.tableView2.frame = CGRectMake(0, CGRectGetMaxY(self.proviceBtn.frame), ScreenWidth, ScreenHeight-self.proviceBtn.height);
    }];
    if (sender.selected == YES) {
        self.coverView.hidden = YES;
        self.rollView.hidden = YES;
        [UIView animateWithDuration:0.1f animations:^{
            self.tableView2.frame = CGRectMake(0, -self.tableView2.height, self.tableView2.width, self.tableView2.height);
        }];
        self.proviceBtn.selected = NO;
        self.cityBtn.selected = NO;
        self.areaBtn.selected = NO;
    }
    else
    {
        self.proviceBtn.selected = NO;
        self.cityBtn.selected = NO;
        self.areaBtn.selected = NO;

        sender.selected = YES;
    }
    
    _currentBtn = sender;
    
    if (sender.tag == Tag)
    {
        [self getProviceData];
    }
    else if (sender.tag == Tag+1)
    {
        [self getCityData];
    }
    else
    {
        [self getAreaData];
    }
 }
-(void)getProviceData
{
    [self.provinceList removeAllObjects];
    [self.currentCityArr removeAllObjects];

    [KSHttpRequest get:KgetProvince parameters:@{@"userId":[DataCenter account].userid,@"products":self.proId} success:^(id result) {
        if ([result[@"code"]integerValue] == 1000) {
            self.provinceList = (NSMutableArray *)[XNRCityDetailModel objectArrayWithKeyValuesArray:result[@"provinceList"]];
            
            [self.currentCityArr setArray:self.provinceList];

            [self.tableView2 reloadData];
        }
        else
        {
            [UILabel showMessage:result[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getCityData
{
    [self.cityList removeAllObjects];
    [self.currentCityArr removeAllObjects];
    [KSHttpRequest get:KgetCity parameters:@{@"userId":[DataCenter account].userid,@"products":self.proId,@"province":self.proviceId?self.proviceId:@"5649bd6c8eba3c20360afa0a"} success:^(id result) {
        if ([result[@"code"]integerValue] == 1000) {
            self.cityList = (NSMutableArray *)[XNRCityDetailModel objectArrayWithKeyValuesArray:result[@"cityList"]];
            XNRCityDetailModel *model = [[XNRCityDetailModel alloc]init];
            model.name = @"全部地区";
            
//            [self.cityList setObject:model atIndexedSubscript:0];
            [self.cityList insertObject:model atIndex:0];
            [self.currentCityArr setArray:self.cityList];
            [self.tableView2 reloadData];
        }
        
        else
        {
            [UILabel showMessage:result[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getAreaData
{
    [self.areaList removeAllObjects];
    [self.currentCityArr removeAllObjects];

    [KSHttpRequest get:KgetCounty parameters:@{@"userId":[DataCenter account].userid,@"products":self.proId,@"province":self.proviceId?self.proviceId:@"5649bd6c8eba3c20360afa0a",@"city":self.cityId} success:^(id result) {
        if ([result[@"code"]integerValue] == 1000) {
            self.areaList = (NSMutableArray *)[XNRCityDetailModel objectArrayWithKeyValuesArray:result[@"countyList"]];

            XNRCityDetailModel *model = [[XNRCityDetailModel alloc]init];
            model.name = @"全部地区";

            [self.areaList insertObject:model atIndex:0];
            [self.currentCityArr setArray:self.areaList];
            [self.tableView2 reloadData];
        }
        else
        {
            [UILabel showMessage:result[@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - uitableView数据源和代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TableViewTag) {
        return _dataArr.count;
    }
    else if(tableView.tag == TableViewTag+1)
    {
        return _currentCityArr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == TableViewTag) {
        NSString static *cellID1 = @"cell1";
        XNRSelWebSiteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell) {
            cell = [[XNRSelWebSiteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
//        for (XNRSelWebBtn *btn in cell.contentView.subviews) {
//            [btn removeFromSuperview];
//        }
    
        XNRRSCModel *RSCmodel = [self.dataArr objectAtIndex:indexPath.row];
        XNRRSCDetailModel *model = [XNRRSCDetailModel objectWithKeyValues:RSCmodel.RSCInfo];
        cell.model = model;
        
        XNRSelWebBtn *iconBtn = [[XNRSelWebBtn alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, cell.height)];

        [iconBtn setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
        [iconBtn setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];

        [iconBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchDown];
        iconBtn.tag = indexPath.row;
        
        if (self.currentModel == self.dataArr[iconBtn.tag]) {
                iconBtn.selected = YES;
            }
        [cell.contentView addSubview:iconBtn];
        [_iconArr addObject:iconBtn];
        return cell;
    }
    else if(tableView.tag == TableViewTag+1)
    {
        NSString static *cellID = @"cell";
        XNRCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[XNRCityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        XNRCityDetailModel *model = self.currentCityArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.nameLabel.highlightedTextColor = R_G_B_16(0xFF4E00);
        
        cell.name = model.name;
        
        if (_currentBtn.tag == Tag && indexPath ==_proIndexPath) {
            cell.nameLabel.textColor = R_G_B_16(0xFF4E00);
        }
        if (_currentBtn.tag == Tag+1 && indexPath ==_cityIndexPath) {
            cell.nameLabel.textColor = R_G_B_16(0xFF4E00);
        }
        if (_currentBtn.tag == Tag+2 && indexPath ==_areaIndexPath) {
            cell.nameLabel.textColor = R_G_B_16(0xFF4E00);
        }

        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewTag+1) {
        
        XNRCityDetailModel *model = [_currentCityArr objectAtIndex:indexPath.row];
        self.coverView.hidden = YES;
        self.rollView.hidden = YES;

        if (_currentBtn.tag == Tag) {
            
            [_proviceBtn setTitle:model.name forState:UIControlStateSelected | UIControlStateNormal];
            [_proviceBtn setTitle:model.name forState: UIControlStateNormal];

            [_cityBtn setTitle:@"全部地区" forState: UIControlStateNormal];
            [_cityBtn setTitle:@"全部地区" forState:UIControlStateSelected];

            [_areaBtn setTitle:@"全部地区" forState: UIControlStateNormal];
            [_areaBtn setTitle:@"全部地区" forState:UIControlStateSelected];

            
            _proviceId = model._id;
            _cityId = nil;
            _areaId = nil;
            _areaBtn.enabled = NO;
            _proIndexPath = indexPath;
            _cityIndexPath = nil;
            _areaIndexPath = nil;
        }
        else if (_currentBtn.tag == Tag+1) {
            
            [_cityBtn setTitle:model.name forState:UIControlStateSelected | UIControlStateNormal];
            [_cityBtn setTitle:model.name forState: UIControlStateNormal];

            [_areaBtn setTitle:@"全部地区" forState: UIControlStateNormal];
            [_areaBtn setTitle:@"全部地区" forState:UIControlStateSelected];
            _cityId = model._id;
            _areaId = nil;

            if (_cityId) {
                self.areaBtn.enabled = YES;
            }
            else
            {
                self.areaBtn.enabled = NO;
            }
            _cityIndexPath = indexPath;
            _areaIndexPath = nil;
        }
        else if (_currentBtn.tag == Tag+2) {
            [_areaBtn setTitle:model.name forState:UIControlStateSelected | UIControlStateNormal];
            [_areaBtn setTitle:model.name forState: UIControlStateNormal];

            _areaId = model._id;
            _areaIndexPath = indexPath;
        }
        _currentBtn.selected = NO;
        [UIView animateWithDuration:0.1f animations:^{
            self.tableView2.frame = CGRectMake(0, -self.tableView2.height, self.tableView2.width, self.tableView2.height);
        }];
        currentPage = 1;
//        [self.dataArr removeAllObjects];
//        [self.tableView2 reloadData];
        [self getData];
    }
    
}
// 单选按钮
-(void)iconClick:(UIButton *)sender
{
    for (UIButton *btn in _iconArr) {
        btn.selected = NO;
    }
    sender.selected = YES;
    _currentModel = self.dataArr[sender.tag];
    
    [_iconArr removeAllObjects];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewTag) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    
    return PX_TO_PT(81);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == TableViewTag+1) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-(self.currentCityArr.count+1)*PX_TO_PT(81))];
        footView.backgroundColor = [UIColor clearColor];
        return footView;

    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == TableViewTag+1) {
        return ScreenHeight - (self.currentCityArr.count+1) * PX_TO_PT(81);
    }
    return 0;
}
#pragma mark  - 设置导航
- (void)setNav
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];

    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择自提网点";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);

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
