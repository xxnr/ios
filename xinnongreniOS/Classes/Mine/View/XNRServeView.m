//
//  XNRServeView.m
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRServeView.h"
#import "XNRMyOrderSectionModel.h"
#import "XNRMyOrderModel.h"
#import "XNRMyOrderServe_Cell.h"
#import "UIImageView+WebCache.h"
#import "XNRMyOrderPayCell.h"
#import "MJExtension.h"
#import "XNROrderEmptyView.h"
#import "XNRMyAllOrderFrame.h"
#import "XNROffLine_VC.h"
#import "XNRPayType_VC.h"
#import "XNRMakeSureView.h"
#import "XNRMyOrderModel.h"
#import "XNRCarryVC.h"
#define MAX_PAGE_SIZE 10

@interface XNRServeView()<XNROrderEmptyViewBtnDelegate>

@property (nonatomic ,weak) UIView *headView;
@property (nonatomic ,weak) XNROrderEmptyView *orderEmptyView;
@property (nonatomic ,weak) UIButton *backtoTopBtn;
@property (nonatomic,strong)XNRMyOrderSectionModel *currentModel;


@end
@implementation XNRServeView


-(XNROrderEmptyView *)orderEmptyView
{
    if (!_orderEmptyView) {
        XNROrderEmptyView *orderEmptyView = [[XNROrderEmptyView alloc] init];
        orderEmptyView.delegate = self;
        orderEmptyView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-PX_TO_PT(100)-64);
        [self addSubview:orderEmptyView];
    }
    return _orderEmptyView;
    
}

-(void)XNROrderEmptyView:(XNROrderEmptyViewbuySort)type
{
    if (type == XNROrderEmptyView_buyFer) {
        
    }else if (type == XNROrderEmptyView_buyCar){
    
    }

}

#pragma mark - 滑动到顶部按钮
-(void)createbackBtn
{
    UIButton *backtoTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backtoTopBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(60)-PX_TO_PT(32), ScreenHeight-PX_TO_PT(164), PX_TO_PT(100), PX_TO_PT(100));
    [backtoTopBtn setImage:[UIImage imageNamed:@"icon_home_backTop"] forState:UIControlStateNormal];
    [backtoTopBtn addTarget:self action:@selector(backtoTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backtoTopBtn = backtoTopBtn;
    [self addSubview:backtoTopBtn];
}

-(void)backtoTopBtnClick{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y == 0) {
        [self.backtoTopBtn removeFromSuperview];
    }else{
        self.backtoTopBtn.hidden = NO;
    }
}


-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = 1;
        _dataArr = [[NSMutableArray alloc]init];
        //获取数据
        [self getData];
        [self createbackBtn];
        //创建订单
        [self createMainTableView];
        [self setupAllViewRefresh];

    }
    return self;
}

#pragma mark - 刷新
-(void)setupAllViewRefresh{
    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    NSMutableArray *idleImage = [NSMutableArray array];
    
    for (int i = 1; i<21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
        
        [idleImage addObject:image];
    }
    NSMutableArray *RefreshImage = [NSMutableArray array];
    
    for (int i = 10; i<21; i++) {
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
    
    
//    footer.automaticallyHidden = YES;
    
    // 设置刷新图片
    [footer setImages:RefreshImage forState:MJRefreshStateRefreshing];
    footer.refreshingTitleHidden = YES;

    
    // 设置尾部
    self.tableView.mj_footer = footer;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headRefresh) name:@"reloadOrderList" object:nil];
    
}
-(void)headRefresh{
    _currentPage = 1;
    [_dataArr removeAllObjects];
    [self getData];
    
    
}
-(void)footRefresh{
    _currentPage ++;
    [self getData];
    
}


#pragma mark - 获取数据
- (void)getData
{
    // typeValue说明：1未付款 ，2待发货，3已发货，4已收货  全部订单为空
    [KSHttpRequest post:KGetOderList parameters:@{@"userId":[DataCenter account].userid?[DataCenter account].userid:@"",@"page":[NSString stringWithFormat:@"%d",_currentPage],@"max":[NSString stringWithFormat:@"%d",MAX_PAGE_SIZE],@"typeValue":@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datasDic = result[@"datas"];
            NSArray *rowsArr = datasDic[@"rows"];
            for (NSDictionary *subDic in rowsArr) {
                XNRMyOrderSectionModel *sectionModel = [[XNRMyOrderSectionModel alloc]init];
                sectionModel.orderId = subDic[@"orderId"];
                sectionModel.payType = subDic[@"payType"];
                sectionModel.duePrice = subDic[@"duePrice"];

                
                NSDictionary *orders = subDic[@"order"];
                sectionModel.totalPrice = orders[@"totalPrice"];
                sectionModel.deposit = orders[@"deposit"];
                NSDictionary *orderStatus = orders[@"orderStatus"];
                sectionModel.type = [orderStatus[@"type"] integerValue];
                sectionModel.value = orderStatus[@"value"];
                sectionModel.deliveryType = orders[@"deliveryType"][@"type"];
                sectionModel.deliveryValue =orders[@"deliveryType"][@"value"];
                sectionModel.products = (NSMutableArray *)[XNRMyOrderModel objectArrayWithKeyValuesArray:subDic[@"products"]];
                
                sectionModel.skus = (NSMutableArray *)[XNRMyOrderModel objectArrayWithKeyValuesArray:subDic[@"SKUs"]];
                if (sectionModel.skus.count == 0) {
                    for (XNRMyOrderModel *model in sectionModel.products) {
                        XNRMyAllOrderFrame *orderFrame = [[XNRMyAllOrderFrame alloc] init];
                        // 把订单模型传递给frame模型
                        orderFrame.orderModel = model;
                        
                        
                        [sectionModel.orderFrameArray addObject:orderFrame];
                        NSLog(@"orderFrameArray%@",sectionModel.orderFrameArray);
                    }

                }else{
                    for (XNRMyOrderModel *model in sectionModel.skus) {
                        XNRMyAllOrderFrame *orderFrame = [[XNRMyAllOrderFrame alloc] init];
                        // 把订单模型传递给frame模型
                        orderFrame.orderModel = model;
                        
                        [sectionModel.orderFrameArray addObject:orderFrame];
                        NSLog(@"orderFrameArray%@",sectionModel.orderFrameArray);
                    }

                
                }
            [_dataArr addObject:sectionModel];
            }
               

        }
        
        //刷新列表
        [self.tableView reloadData];
        
        if (_dataArr.count == 0) {
            [self orderEmptyView];
        }
        
        //  如果到达最后一页 就消除footer
        NSInteger pages = [result[@"datas"][@"pages"] integerValue];
        NSInteger page = [result[@"datas"][@"page"] integerValue];
        NSLog(@"pages = %ld----page = %ld",pages,page);
        self.tableView.mj_footer.hidden = pages == page;
            
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
}
#pragma mark--创建TableView
-(void)createMainTableView{
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(100)) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
}

// 在段头添加任意的视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArr.count > 0) {
        XNRMyOrderSectionModel *sectionModel = _dataArr[section];
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(89))];
        headView.backgroundColor = [UIColor whiteColor];
        self.headView = headView;
        [self addSubview:headView];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(28), ScreenWidth/2, PX_TO_PT(32))];
        label.text = [NSString stringWithFormat:@"订单号 : %@",sectionModel.orderId];
        label.textColor = R_G_B_16(0x323232);
        label.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
        label.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:label];
        
        UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0,ScreenWidth/2-PX_TO_PT(32) , PX_TO_PT(89))];
        payTypeLabel.textColor = R_G_B_16(0xfe9b00);
        payTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        payTypeLabel.textAlignment = NSTextAlignmentRight;
        payTypeLabel.text = sectionModel.value;
        [headView addSubview:payTypeLabel];
        
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
        lineView1.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(89), ScreenWidth, PX_TO_PT(1))];
        lineView2.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView2];
        
        return headView;
        
    } else {
        return nil;
    }
}

#pragma mark - 在断尾添加任意视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataArr.count>0) {
        UIView *bottomView = [[UIView alloc] init];
        XNRMyOrderSectionModel *sectionModel = _dataArr[section];
        self.currentModel = sectionModel;
        if (sectionModel.type ==  1 || sectionModel.type == 2) {
                
            bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(180));
            bottomView.backgroundColor = [UIColor whiteColor];
            [self addSubview:bottomView];
        
            UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(0), ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
            deliveryLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            deliveryLabel.text = sectionModel.deliveryValue;
            [bottomView addSubview:deliveryLabel];

            // 合计
            UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
            totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            totalPriceLabel.textAlignment = NSTextAlignmentRight;
            totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sectionModel.totalPrice.doubleValue];
            [bottomView addSubview:totalPriceLabel];
            
            NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
            NSDictionary *priceStr=@{
                                     
                                     NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
                                     
                                     };
            
            [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
            
            [totalPriceLabel setAttributedText:AttributedStringPrice];
        
        
        
            UIButton *sectionFour = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(172), PX_TO_PT(90), PX_TO_PT(140), PX_TO_PT(60))];
            [sectionFour setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fe9b00"]] forState:UIControlStateNormal];
            [sectionFour setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fec366"]] forState:UIControlStateHighlighted];
            [sectionFour setTitle:@"去付款" forState:UIControlStateNormal];
            sectionFour.layer.cornerRadius = 5.0;
            sectionFour.layer.masksToBounds = YES;
            sectionFour.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            sectionFour.tag = section + 1000;
            [sectionFour addTarget:self action:@selector(sectionFourClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:sectionFour];

            
            for (int i = 0; i<3; i++) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
                lineView.backgroundColor = R_G_B_16(0xc7c7c7);
                [bottomView addSubview:lineView];
            }
                    
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(160), ScreenWidth, PX_TO_PT(20))];
            sectionView.backgroundColor = R_G_B_16(0xf4f4f4);
            [bottomView addSubview:sectionView];
                
            UIView *sectionLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
                sectionLine.backgroundColor = R_G_B_16(0xc7c7c7);
                [sectionView addSubview:sectionLine];
                
        return bottomView;
            
        }
        else if(sectionModel.type == 7)
        {
            
            bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(180));
            bottomView.backgroundColor = [UIColor whiteColor];
            [self addSubview:bottomView];
            
            UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(0), ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
            deliveryLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            deliveryLabel.text = sectionModel.deliveryValue;
            [bottomView addSubview:deliveryLabel];
            
            // 合计
            UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
            totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            totalPriceLabel.textAlignment = NSTextAlignmentRight;
            totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sectionModel.totalPrice.doubleValue];
            [bottomView addSubview:totalPriceLabel];
            
            NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
            NSDictionary *priceStr=@{
                                     
                                     NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
                                     
                                     };
            
            [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
            
            [totalPriceLabel setAttributedText:AttributedStringPrice];
            
            
            UIButton *seePayInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(190)-PX_TO_PT(31), PX_TO_PT(90), PX_TO_PT(190), PX_TO_PT(60))];
            seePayInfoBtn.backgroundColor = R_G_B_16(0xFE9B00);
            [seePayInfoBtn setTitle:@"查看付款信息" forState:UIControlStateNormal];
            seePayInfoBtn.titleLabel.textColor = [UIColor whiteColor];
            seePayInfoBtn.layer.cornerRadius = 10.0;
            seePayInfoBtn.tag = section + 1000;
            seePayInfoBtn.layer.masksToBounds = YES;
            seePayInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            [seePayInfoBtn addTarget:self action:@selector(seePayInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:seePayInfoBtn];

            
            UIButton *reviseBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(seePayInfoBtn.frame)-PX_TO_PT(31)-PX_TO_PT(190), PX_TO_PT(90), PX_TO_PT(190), PX_TO_PT(60))];
            reviseBtn.backgroundColor = [UIColor whiteColor];
            [reviseBtn setTitle:@"修改付款方式" forState:UIControlStateNormal];
            [reviseBtn setTitleColor:R_G_B_16(0xFE9B00) forState:UIControlStateNormal];
            reviseBtn.layer.cornerRadius = 10.0;
            reviseBtn.layer.borderColor = [R_G_B_16(0xFE9B00) CGColor];
            reviseBtn.layer.borderWidth = PX_TO_PT(2);
            reviseBtn.layer.masksToBounds = YES;
            reviseBtn.tag = section + 1000;
            reviseBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            [reviseBtn addTarget:self action:@selector(reviseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:reviseBtn];

            for (int i = 0; i<3; i++) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
                lineView.backgroundColor = R_G_B_16(0xc7c7c7);
                [bottomView addSubview:lineView];
            }
            
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(160), ScreenWidth, PX_TO_PT(20))];
            sectionView.backgroundColor = R_G_B_16(0xf4f4f4);
            [bottomView addSubview:sectionView];
            
            UIView *sectionLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
            sectionLine.backgroundColor = R_G_B_16(0xc7c7c7);
            [sectionView addSubview:sectionLine];
            
            return bottomView;

        }
        else if(sectionModel.type == 4)
        {
            bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(180));
            bottomView.backgroundColor = [UIColor whiteColor];
            [self addSubview:bottomView];
            
            UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(0), ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
            deliveryLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            deliveryLabel.text = sectionModel.deliveryValue;
            [bottomView addSubview:deliveryLabel];
            
            // 合计
            UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
            totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            totalPriceLabel.textAlignment = NSTextAlignmentRight;
            totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sectionModel.totalPrice.doubleValue];
            [bottomView addSubview:totalPriceLabel];
            
            NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
            NSDictionary *priceStr=@{
                                     
                                     NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
                                     
                                     };
            
            [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
            
            [totalPriceLabel setAttributedText:AttributedStringPrice];
            
            
            
            UIButton *makeSureBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(172), PX_TO_PT(90), PX_TO_PT(140), PX_TO_PT(60))];
            makeSureBtn.backgroundColor = R_G_B_16(0xfe9b00);
            [makeSureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            makeSureBtn.layer.cornerRadius = 5.0;
            makeSureBtn.layer.masksToBounds = YES;
            makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            makeSureBtn.tag = section + 1000;
            [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:makeSureBtn];
            
            
            for (int i = 0; i<3; i++) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
                lineView.backgroundColor = R_G_B_16(0xc7c7c7);
                [bottomView addSubview:lineView];
            }
            
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(160), ScreenWidth, PX_TO_PT(20))];
            sectionView.backgroundColor = R_G_B_16(0xf4f4f4);
            [bottomView addSubview:sectionView];
            
            UIView *sectionLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
            sectionLine.backgroundColor = R_G_B_16(0xc7c7c7);
            [sectionView addSubview:sectionLine];
            
            return bottomView;

        }
        else if(sectionModel.type == 5)
        {
            bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(180));
            bottomView.backgroundColor = [UIColor whiteColor];
            [self addSubview:bottomView];
            
            UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(0), ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
            deliveryLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            deliveryLabel.text = sectionModel.deliveryValue;
            [bottomView addSubview:deliveryLabel];
            
            // 合计
            UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
            totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            totalPriceLabel.textAlignment = NSTextAlignmentRight;
            totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sectionModel.totalPrice.doubleValue];
            [bottomView addSubview:totalPriceLabel];
            
            NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
            NSDictionary *priceStr=@{
                                     
                                     NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
                                     
                                     };
            
            [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
            
            [totalPriceLabel setAttributedText:AttributedStringPrice];
            
            
            
            UIButton *holdNeckBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(172), PX_TO_PT(90), PX_TO_PT(140), PX_TO_PT(60))];
            holdNeckBtn.backgroundColor = R_G_B_16(0xfe9b00);
            [holdNeckBtn setTitle:@"待自提" forState:UIControlStateNormal];
            holdNeckBtn.layer.cornerRadius = 5.0;
            holdNeckBtn.layer.masksToBounds = YES;
            holdNeckBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            holdNeckBtn.tag = section + 1000;
            [holdNeckBtn addTarget:self action:@selector(holdNeckClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:holdNeckBtn];
            
            
            for (int i = 0; i<3; i++) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
                lineView.backgroundColor = R_G_B_16(0xc7c7c7);
                [bottomView addSubview:lineView];
            }
            
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(160), ScreenWidth, PX_TO_PT(20))];
            sectionView.backgroundColor = R_G_B_16(0xf4f4f4);
            [bottomView addSubview:sectionView];
            
            UIView *sectionLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
            sectionLine.backgroundColor = R_G_B_16(0xc7c7c7);
            [sectionView addSubview:sectionLine];
            
            return bottomView;
            
        }

        else{
        bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(100));
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        
        UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(31), PX_TO_PT(0), ScreenWidth-PX_TO_PT(32), PX_TO_PT(80))];
        deliveryLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        deliveryLabel.text = sectionModel.deliveryValue;
        [bottomView addSubview:deliveryLabel];

        
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth -PX_TO_PT(32), PX_TO_PT(80))];
        totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        totalPriceLabel.textAlignment = NSTextAlignmentRight;
        totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sectionModel.totalPrice.doubleValue];
        [bottomView addSubview:totalPriceLabel];
        
        NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
        NSDictionary *priceStr=@{
                                 
                                 NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
                                 
                                 };
        
        [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
        
        [totalPriceLabel setAttributedText:AttributedStringPrice];
        
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(20))];
        sectionView.backgroundColor = R_G_B_16(0xf4f4f4);
        [bottomView addSubview:sectionView];

        UIView *sectionLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
        sectionLine.backgroundColor = R_G_B_16(0xc7c7c7);
        [sectionView addSubview:sectionLine];


        for (int i = 0; i<2; i++) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*i, ScreenWidth, PX_TO_PT(1))];
            lineView.backgroundColor = R_G_B_16(0xc7c7c7);
            [bottomView addSubview:lineView];
        }

        return bottomView;
    }

    }else{
        return nil;
    }

}

-(void)sectionFourClick:(UIButton *)sender{
    XNRMyOrderSectionModel *sectionModel = _dataArr[sender.tag - 1000];
    if (sectionModel.deposit && [sectionModel.deposit doubleValue]>0) {
        self.payBlock(sectionModel.orderId,sectionModel.deposit);
    }else{
        self.payBlock(sectionModel.orderId,sectionModel.totalPrice);
    }

}
-(void)makeSureClick:(UIButton *)sender{
    
    XNRMyOrderSectionModel *sectionModel = _dataArr[sender.tag - 1000];
    XNRMakeSureView *makesureView = [[XNRMakeSureView alloc]init];
    makesureView.orderId = sectionModel.orderId;
    
    for (int i=0; i<sectionModel.skus.count; i++) {
        XNRMyOrderModel *model = sectionModel.skus[i];
        if(model.deliverStatus == 2)
        {
            [makesureView.modelArr addObject:model];
        }
    }
    
    [makesureView createview];
    
    [self addSubview:makesureView];
}
-(void)holdNeckClick:(UIButton *)sender{
    
    XNRMyOrderSectionModel *sectionModel = _dataArr[sender.tag - 1000];
    XNRCarryVC *carryVC = [[XNRCarryVC alloc]init];
    carryVC.orderId = sectionModel.orderId;
    
    for (int i=0; i<sectionModel.skus.count; i++) {
        XNRMyOrderModel *model = sectionModel.skus[i];
        if(model.deliverStatus == 4)
        {
            [carryVC.modelArr addObject:model];
        }
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:carryVC,@"carryVC", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"carry" object:self userInfo:dic];
}

-(void)reviseBtnClick:(UIButton *)sender
{
    XNRMyOrderSectionModel *sectionModel = _dataArr[sender.tag - 1000];
    XNRPayType_VC *vc = [[XNRPayType_VC alloc]init];
    vc.orderID = sectionModel.orderId;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:vc,@"payType", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"revisePayType" object:self userInfo:dic];
}
-(void)seePayInfoBtnClick:(UIButton *)sender
{
    XNRMyOrderSectionModel *sectionModel = _dataArr[sender.tag - 1000];
    XNROffLine_VC *vc=[[XNROffLine_VC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.orderID = sectionModel.orderId;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:vc,@"checkVC", nil];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"seePayInfo" object:self userInfo:dic];
}
#pragma mark - tableView代理方法

// 段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(89);
}

// 段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (_dataArr.count>0) {
        XNRMyOrderSectionModel *sectionModel = _dataArr[section];
        if (sectionModel.type ==  1 || sectionModel.type == 2 ||sectionModel.type == 4 || sectionModel.type == 5|| sectionModel.type == 7) {
            return PX_TO_PT(180);
        }else{
            return PX_TO_PT(100);
        }

    }else{
        return 0;
    }
}

//设置段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArr.count > 0) {
        XNRMyOrderSectionModel *sectionModel = _dataArr[section];
        return sectionModel.orderFrameArray.count;
    } else {
        return 0;
    }
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArr.count>0) {
        XNRMyOrderSectionModel *sectionModel = _dataArr[indexPath.section];
        if (sectionModel.orderFrameArray.count>0) {
            XNRMyAllOrderFrame *frame = sectionModel.orderFrameArray[indexPath.row];
            return frame.cellHeight;
            
        }else{
            return 0;
        }
        
    }else{
        return 0;
    }
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"被点击了");
    XNRMyOrderSectionModel *sectionModel = _dataArr[indexPath.section];
    self.checkOrderBlock(sectionModel.orderId,sectionModel.value);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    XNRMyOrderServe_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        //单元格复用cellID要一致
        cell = [[XNRMyOrderServe_Cell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //传递数据模型model
    if (_dataArr.count>0) {
        XNRMyOrderSectionModel *sectionModel = _dataArr[indexPath.section];
        if (sectionModel.orderFrameArray.count>0) {
            if (sectionModel.skus.count >0) {
                XNRMyOrderModel *modelArray = sectionModel.skus[indexPath.row];
                cell.attributesArray = modelArray.attributes;
                cell.addtionsArray = modelArray.additions;
            }
            XNRMyAllOrderFrame *orderFrame = sectionModel.orderFrameArray[indexPath.row];
            cell.orderFrame = orderFrame;

        }
    }
    
    return cell;

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadOrderList" object:nil];
    
}
@end
