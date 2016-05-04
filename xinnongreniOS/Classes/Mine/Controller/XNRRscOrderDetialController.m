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
#import "XNRRscDetialFootFrameModel.h"
#import "XNRRscConfirmDeliverView.h"
#import "XNRRscIdentifyPayView.h"

@interface XNRRscOrderDetialController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataFrameArray;

@property (nonatomic, weak) XNRRscOrderDetialHeadView *headView;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIView *footView;

@property (nonatomic, weak) XNRRscIdentifyPayView *identifyPayView;

@property (nonatomic, weak) XNRRscConfirmDeliverView *deliverView;


@end

@implementation XNRRscOrderDetialController

-(XNRRscIdentifyPayView *)identifyPayView
{
    if (!_identifyPayView) {
        XNRRscIdentifyPayView *identifyPayView = [[XNRRscIdentifyPayView alloc] init];
        self.identifyPayView = identifyPayView;
        [self.view addSubview:identifyPayView];
    }
    return _identifyPayView;
}

-(XNRRscConfirmDeliverView *)deliverView
{
    if (!_deliverView) {
        XNRRscConfirmDeliverView *deliverView = [[XNRRscConfirmDeliverView alloc] init];
        self.deliverView = deliverView;
        [self.view addSubview:deliverView];
    }
    return _deliverView;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _dataFrameArray = [NSMutableArray array];
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
        
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
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
            model.id = dict[@"id"];
            model.deliveryType = dict[@"deliveryType"];
            model.orderStatus = dict[@"orderStatus"];
            model.totalPrice = dict[@"totalPrice"];
            model.subOrders = (NSMutableArray *)[XNRRscSubOrdersModel objectArrayWithKeyValuesArray:dict[@"subOrders"]];
            
            for (XNRRscSkusModel *skuModel in model.SKUList ) {
                XNRRscOrderDetialFrameModel *frameModel = [[XNRRscOrderDetialFrameModel alloc] init];
                frameModel.model = skuModel;
                [model.SKUFrameList addObject:frameModel];
            }

            [_dataArray addObject:model];
            
            XNRRscDetialFootFrameModel *frameModel = [[XNRRscDetialFootFrameModel alloc] init];
            frameModel.model = model;
            [_dataFrameArray addObject:frameModel];

            
            [self.headView updataWithModel:model];

        }

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    

}

#pragma mark - 在段尾添加任意视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    XNRRscOrderDetailModel *detailModel = _dataArray[section];
    UIView *footView;
    NSDictionary *dict = detailModel.orderStatus;
        if ([dict[@"type"] integerValue] == 2 || [dict[@"type"] integerValue] == 4) {
            footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(160))];
            footView.backgroundColor = R_G_B_16(0xffffff);
            self.footView = footView;
            [self.view addSubview:footView];
            
            UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(30), PX_TO_PT(80))];
            totalPriceLabel.textAlignment = NSTextAlignmentRight;
            totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@",detailModel.totalPrice];
            [footView addSubview:totalPriceLabel];
            
            NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
            NSDictionary *priceStr=@{
                                     
                                     NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                     NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                                     
                                     };
            
            [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
            
            [totalPriceLabel setAttributedText:AttributedStringPrice];

            
            UIButton *footButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(170), PX_TO_PT(90), PX_TO_PT(140), PX_TO_PT(60))];
            footButton.layer.cornerRadius = 5.0;
            footButton.layer.masksToBounds = YES;
            footButton.backgroundColor = R_G_B_16(0xfe9b00);
            if ([dict[@"type"] integerValue] == 2) {
                [footButton setTitle:@"审核付款" forState:UIControlStateNormal];
            }else if ([dict[@"type"] integerValue] == 4){
                [footButton setTitle:@"开始配送" forState:UIControlStateNormal];
            }else if ([dict[@"type"] integerValue] == 5){
                for (XNRRscSkusModel *skuModel in detailModel.SKUList) {
                    if ([skuModel.deliverStatus integerValue] == 4) {
                        [footButton setTitle:@"客户自提" forState:UIControlStateNormal];
                    }
                }
            }else if ([dict[@"type"] integerValue] == 6){
                for (XNRRscSkusModel *skuModel in detailModel.SKUList) {
                    if ([skuModel.deliverStatus integerValue] == 4) {
                        [footButton setTitle:@"开始配送" forState:UIControlStateNormal];
                    }
                }
            }

            footButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            [footButton addTarget:self action:@selector(footButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:footButton];
            
            for (int i = 0; i<2; i++) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*(i+1), ScreenWidth, PX_TO_PT(1))];
                lineView.backgroundColor = R_G_B_16(0xc7c7c7);
                [footView addSubview:lineView];
            }

        }else if ([dict[@"type"] integerValue] == 5 || [dict[@"type"] integerValue] == 6){
        for (XNRRscSkusModel *skuModel in detailModel.SKUList) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(160))];
                footView.backgroundColor = R_G_B_16(0xffffff);
                self.footView = footView;
                [self.view addSubview:footView];
                
                UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(30), PX_TO_PT(80))];
                totalPriceLabel.textAlignment = NSTextAlignmentRight;
                totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
                totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@",detailModel.totalPrice];
                [footView addSubview:totalPriceLabel];
                
                NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
                NSDictionary *priceStr=@{
                                         
                                         NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                         NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                                         
                                         };
                
                [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
                
                [totalPriceLabel setAttributedText:AttributedStringPrice];

                
                UIButton *footButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(170), PX_TO_PT(90), PX_TO_PT(140), PX_TO_PT(60))];
                footButton.layer.cornerRadius = 5.0;
                footButton.layer.masksToBounds = YES;
                footButton.backgroundColor = R_G_B_16(0xfe9b00);
                if ([dict[@"type"] integerValue] == 2) {
                    [footButton setTitle:@"审核付款" forState:UIControlStateNormal];
                }else if ([dict[@"type"] integerValue] == 4){
                    [footButton setTitle:@"开始配送" forState:UIControlStateNormal];
                }else if ([dict[@"type"] integerValue] == 5){
                    for (XNRRscSkusModel *skuModel in detailModel.SKUList) {
                        if ([skuModel.deliverStatus integerValue] == 4) {
                            [footButton setTitle:@"客户自提" forState:UIControlStateNormal];
                        }
                    }
                }else if ([dict[@"type"] integerValue] == 6){
                    for (XNRRscSkusModel *skuModel in detailModel.SKUList) {
                        if ([skuModel.deliverStatus integerValue] == 4) {
                            [footButton setTitle:@"开始配送" forState:UIControlStateNormal];
                        }
                    }
                }
                footButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
                [footButton addTarget:self action:@selector(footButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [footView addSubview:footButton];
                for (int i = 0; i<2; i++) {
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80)*(i+1), ScreenWidth, PX_TO_PT(1))];
                    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
                    [footView addSubview:lineView];
                }
                
            }else{
                footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(160))];
                footView.backgroundColor = [UIColor whiteColor];
                self.footView = footView;
                [self.view addSubview:footView];
                
                UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(30), PX_TO_PT(80))];
                totalPriceLabel.textAlignment = NSTextAlignmentRight;
                totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
                totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@",detailModel.totalPrice];
                [footView addSubview:totalPriceLabel];
                
                NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
                NSDictionary *priceStr=@{
                                         
                                         NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                         NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                                         
                                         };
                
                [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
                
                [totalPriceLabel setAttributedText:AttributedStringPrice];

                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(1))];
                lineView.backgroundColor = R_G_B_16(0xc7c7c7);
                [footView addSubview:lineView];

            }
        }

            
        }else{
            footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(160))];
            footView.backgroundColor = [UIColor whiteColor];
            self.footView = footView;
            [self.view addSubview:footView];
            
            UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-PX_TO_PT(30), PX_TO_PT(80))];
            totalPriceLabel.textAlignment = NSTextAlignmentRight;
            totalPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@",detailModel.totalPrice];
            [footView addSubview:totalPriceLabel];
            
            NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:totalPriceLabel.text];
            NSDictionary *priceStr=@{
                                     
                                     NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                     NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                                     
                                     };
            
            [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(3,AttributedStringPrice.length-3)];
            
            [totalPriceLabel setAttributedText:AttributedStringPrice];

            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(1))];
            lineView.backgroundColor = R_G_B_16(0xc7c7c7);
            [footView addSubview:lineView];

        }
        return footView;
  }

-(void)footButtonClick
{
    for (XNRRscOrderDetailModel *detailModel in _dataArray) {
        NSDictionary *dict = detailModel.orderStatus;
        if ([dict[@"type"] integerValue] == 2) {
            [self getdetailData:detailModel];
        }
    }
    
}

-(void)getdetailData:(XNRRscOrderDetailModel *)model
{
    [KSHttpRequest get:KRscOrderDetail parameters:@{@"orderId":model.id} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *orderDict = result[@"order"];
            XNRRscOrderDetailModel *detailModel = [[XNRRscOrderDetailModel alloc] init];
            detailModel.consigneeName = orderDict[@"consigneeName"];
            NSDictionary *payment = orderDict[@"payment"];
            detailModel.price = payment[@"price"];
            detailModel.id = payment[@"id"];
            [self.identifyPayView show:detailModel.consigneeName andPrice:detailModel.price andPaymentId:detailModel.id];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - tableView代理方法
// 段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataFrameArray.count>0) {
        XNRRscDetialFootFrameModel *frameModel = _dataFrameArray[section];
        return frameModel.footViewHeight;
    }else{
        return 0;
    }
}
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
