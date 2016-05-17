//
//  XNRMyStoreOrderController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRMyStoreOrderController.h"
#import "XNRRscAllOrderView.h"
#import "XNRRscWaitPayView.h"
#import "XNRRscWaitIdentifyView.h"
#import "XNRRscWaitDeliverView.h"
#import "XNRRscWaitTakeView.h"
#import "XNRRscOrderDetialController.h"
#import "XNRRscSearchController.h"
#import "XNRRscOrderModel.h"
#define KtitleBtn  1000

@interface XNRMyStoreOrderController()<UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *tempBtn;

@property (nonatomic, weak) UIView *selectedLineView;

@property (nonatomic, weak) UIView *headView;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, retain) XNRRscAllOrderView *RscAllOrderView;

@property (nonatomic, retain) XNRRscWaitPayView *RscWaitPayView;

@property (nonatomic, retain) XNRRscWaitIdentifyView *RscWaitIdentifyView;

@property (nonatomic, retain) XNRRscWaitDeliverView *RscWaitDeliverView;

@property (nonatomic, retain) XNRRscWaitTakeView *RscWaitTakeView;


@end

@implementation XNRMyStoreOrderController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = R_G_B_16(0xffffff);
    [self setNavigationBar];
    [self createView];
    
}

-(void)createView
{
    [self createHeadView];
    [self createScrollView];
    [self createOrderStateView];
    
}

-(void)createOrderStateView
{
    if (self.RscAllOrderView == nil) {
        self.RscAllOrderView  = [[XNRRscAllOrderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        __weak __typeof(&*self)weakSelf=self;
        self.RscAllOrderView.com = ^(XNRRscOrderModel *model){
            XNRRscOrderDetialController *orderDetialVC = [[XNRRscOrderDetialController alloc] init];
            orderDetialVC.hidesBottomBarWhenPushed = YES;
            orderDetialVC.orderModel = model;
            [weakSelf.navigationController pushViewController:orderDetialVC animated:YES];
        };
    }
    if (self.RscWaitPayView == nil) {
        self.RscWaitPayView  = [[XNRRscWaitPayView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        __weak __typeof(&*self)weakSelf=self;
        self.RscWaitPayView.com = ^(XNRRscOrderModel *model){
            XNRRscOrderDetialController *orderDetialVC = [[XNRRscOrderDetialController alloc] init];
            orderDetialVC.hidesBottomBarWhenPushed = YES;
            orderDetialVC.orderModel = model;
            [weakSelf.navigationController pushViewController:orderDetialVC animated:YES];
        };
    }
    if (self.RscWaitIdentifyView == nil) {
        self.RscWaitIdentifyView  = [[XNRRscWaitIdentifyView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        __weak __typeof(&*self)weakSelf=self;
        self.RscWaitIdentifyView.com = ^(XNRRscOrderModel *model){
            XNRRscOrderDetialController *orderDetialVC = [[XNRRscOrderDetialController alloc] init];
            orderDetialVC.hidesBottomBarWhenPushed = YES;
            orderDetialVC.orderModel = model;
            [weakSelf.navigationController pushViewController:orderDetialVC animated:YES];
        };
    }
    if (self.RscWaitDeliverView == nil) {
        self.RscWaitDeliverView  = [[XNRRscWaitDeliverView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        __weak __typeof(&*self)weakSelf=self;
        self.RscWaitDeliverView.com = ^(XNRRscOrderModel *model){
            XNRRscOrderDetialController *orderDetialVC = [[XNRRscOrderDetialController alloc] init];
            orderDetialVC.hidesBottomBarWhenPushed = YES;
            orderDetialVC.orderModel = model;
            [weakSelf.navigationController pushViewController:orderDetialVC animated:YES];
        };
    }
    if (self.RscWaitTakeView == nil) {
        self.RscWaitTakeView  = [[XNRRscWaitTakeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        __weak __typeof(&*self)weakSelf=self;
        self.RscWaitTakeView.com = ^(XNRRscOrderModel *model){
            XNRRscOrderDetialController *orderDetialVC = [[XNRRscOrderDetialController alloc] init];
            orderDetialVC.hidesBottomBarWhenPushed = YES;
            orderDetialVC.orderModel = model;
            [weakSelf.navigationController pushViewController:orderDetialVC animated:YES];
        };

    }
   
    // 滚动视图上添加5个表格视图
    NSArray*arr=@[self.RscAllOrderView,self.RscWaitPayView,self.RscWaitIdentifyView,self.RscWaitDeliverView,self.RscWaitTakeView];
    for (int i=0; i<arr.count; i++)
    {
        UIView *view = arr[i];
        
        view.frame = CGRectMake((ScreenWidth+PX_TO_PT(20))*i, 0, ScreenWidth, ScreenHeight-64);
        [self.scrollView addSubview:view];
    }
}

-(void)createScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(100),ScreenWidth+PX_TO_PT(20),ScreenHeight-64)];
    scrollView.contentSize=CGSizeMake((ScreenWidth+PX_TO_PT(20))*5, ScreenHeight-64);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor =R_G_B_16(0xf4f4f4);
    // 取消反弹效果
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];

}

-(void)createHeadView{
    
    CGFloat headX = 0;
    CGFloat headY = PX_TO_PT(0);
    CGFloat headW = ScreenWidth;
    CGFloat headH = PX_TO_PT(100);
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
    headView.backgroundColor = R_G_B_16(0xffffff);
    self.headView = headView;
    [self.view addSubview:headView];
    
    NSArray *titleArray = @[@"全部",@"待付款",@"待审核",@"待配送",@"待自提"];
    CGFloat titleBtnY = 0;
    CGFloat titleBtnW = ScreenWidth/5;
    CGFloat titleBtnH = PX_TO_PT(100);
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(ScreenWidth/5*i, titleBtnY, titleBtnW, titleBtnH);
        [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
        [titleBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateSelected];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        [titleBtn addTarget: self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.tag = KtitleBtn +i;
        [headView addSubview:titleBtn];
        
        if (i == 0) {
            [self titleBtnClick:titleBtn];
        }
        
    }
    
    for (int i = 0; i<2; i++) {
        UIView *line = [[UIView  alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98)*i, ScreenWidth, PX_TO_PT(1))];
        line.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:line];
    }
    UIView *selectedLineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(95), ScreenWidth/5, PX_TO_PT(5))];
    selectedLineView.backgroundColor = R_G_B_16(0x00b38a);
    self.selectedLineView = selectedLineView;
    [headView addSubview:selectedLineView];

}

-(void)titleBtnClick:(UIButton *)button
{
    self.tempBtn.selected = NO;
    button.selected = YES;
    self.tempBtn = button;
    [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
   
//    [UIView animateWithDuration:.3 animations:^{
    self.selectedLineView.frame=CGRectMake((button.tag - KtitleBtn)*ScreenWidth/5.0,  PX_TO_PT(95), ScreenWidth/5.0, PX_TO_PT(5));
//        }];
     [self.scrollView setContentOffset:CGPointMake((ScreenWidth+PX_TO_PT(20))*(button.tag-KtitleBtn),0) animated:NO];
    if (button.tag == KtitleBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
        
    }else if (button.tag == KtitleBtn +1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];

    }else if (button.tag == KtitleBtn +2){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];

    }else if (button.tag == KtitleBtn +3){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
    }
    [BMProgressView LoadViewDisappear:self.view];
}

#pragma mark - scrollView左右滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = self.scrollView.contentOffset.x/(ScreenWidth+PX_TO_PT(20));
    
    static int tag = 0;

    if(0 <= offset&&offset < 0.5){
        tag=0;
        UIButton *button = (UIButton *)[self.view viewWithTag:KtitleBtn+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
    }else if (0.5<=offset&&offset<1.5){
        tag=1;
        UIButton *button = (UIButton *)[self.view viewWithTag:KtitleBtn+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
    }else if (1.5<=offset&&offset<2.5){
        tag=2;
        UIButton *button = (UIButton *)[self.view viewWithTag:KtitleBtn+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
    }else if (2.5<=offset&&offset<3.5){
        tag=3;
        UIButton *button = (UIButton *)[self.view viewWithTag:KtitleBtn+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
    }else{
        tag=4;
        UIButton *button = (UIButton *)[self.view viewWithTag:KtitleBtn+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
    }
    
    [UIView animateWithDuration:.3 animations:^{
        self.selectedLineView.frame = CGRectMake((ScreenWidth/5.0)*offset,  PX_TO_PT(95), ScreenWidth/5.0, PX_TO_PT(5));
    }];
}


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
    backButton.frame = CGRectMake(0, 0, 30, 44);
    //    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    [searchBtn setImage:[UIImage imageNamed:@"search-"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBtnClick
{
    XNRRscSearchController *searchVC = [[XNRRscSearchController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}


@end
