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

#define KtitleBtn  1000

@interface XNRMyStoreOrderController()<UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *tempBtn;

@property (nonatomic, weak) UIView *selectedLineView;

@property (nonatomic, weak) UIView *headView;

@property (nonatomic, weak) UIScrollView *scrollView;

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
}

-(void)createScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(120),ScreenWidth+PX_TO_PT(20),ScreenHeight-64)];
    scrollView.contentSize=CGSizeMake((ScreenWidth+PX_TO_PT(20))*5, ScreenHeight-64);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor =R_G_B_16(0xf4f4f4);
    //取消反弹效果
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];

}

-(void)createHeadView{
    
    CGFloat headX = 0;
    CGFloat headY = PX_TO_PT(20);
    CGFloat headW = ScreenWidth;
    CGFloat headH = PX_TO_PT(100);
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
    headView.backgroundColor = R_G_B_16(0xffffff);
    self.headView = headView;
    [self.view addSubview:headView];
    
    for (int i = 0; i<2; i++) {
        UIView *line = [[UIView  alloc] initWithFrame:CGRectMake(0, PX_TO_PT(100)*i, ScreenWidth, PX_TO_PT(1))];
        line.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:line];
    }
    NSArray *titleArray = @[@"全部",@"代付款",@"待审核",@"待配送",@"待自提"];
    CGFloat titleBtnY = 0;
    CGFloat titleBtnW = ScreenWidth/5;
    CGFloat titleBtnH = PX_TO_PT(100);
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(ScreenWidth/5*i, titleBtnY, titleBtnW, titleBtnH);
        [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
        [titleBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateSelected];
        [titleBtn addTarget: self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.tag = KtitleBtn +i;
        [headView addSubview:titleBtn];
        
        if (i == 0) {
            [self titleBtnClick:titleBtn];
        }
        
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
    
    [UIView animateWithDuration:.3 animations:^{
        self.selectedLineView.frame=CGRectMake((button.tag - KtitleBtn)*ScreenWidth/5.0,  PX_TO_PT(95), ScreenWidth/5.0, PX_TO_PT(5));
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


@end
