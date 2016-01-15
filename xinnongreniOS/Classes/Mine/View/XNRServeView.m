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
#import "MJRefresh.h"
#import "MJExtension.h"
@interface XNRServeView()

@property (nonatomic ,weak) UIView *headView;


@end
@implementation XNRServeView
-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [[NSMutableArray alloc]init];
        //获取数据
        [self getData];
        //创建订单
        [self createMainTableView];
        
        
    }
    return self;
}

#pragma mark - 获取数据
- (void)getData
{
    // typeValue说明：1未付款 ，2待发货，3已发货，4已收货  全部订单为空
    [KSHttpRequest post:KGetOderList parameters:@{@"userId":[DataCenter account].userid,@"page":[NSString stringWithFormat:@"%d",_currentPage],@"typeValue":@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datasDic = result[@"datas"];
            NSArray *rowsArr = datasDic[@"rows"];
            for (NSDictionary *subDic in rowsArr) {
                XNRMyOrderSectionModel *sectionModel = [[XNRMyOrderSectionModel alloc]init];
                sectionModel.orderId = subDic[@"orderId"];
                sectionModel.payType = subDic[@"payType"];
                
                NSDictionary *orders = subDic[@"order"];
                sectionModel.deposit = orders[@"deposit"];
                sectionModel.totalPrice = orders[@"totalPrice"];
                NSDictionary *orderStatus = orders[@"orderStatus"];
                sectionModel.type = orderStatus[@"type"];
                sectionModel.value = orderStatus[@"value"];
                
                sectionModel.products = (NSMutableArray *)[XNRMyOrderModel objectArrayWithKeyValuesArray:subDic[@"products"]];
                [_dataArr addObject:sectionModel];
            }
        }
        //刷新列表
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {

    }];
}


#pragma mark--创建
-(void)createMainTableView{
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
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
        label.font = XNRFont(16);
        label.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:label];
        
        UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0,ScreenWidth/2-PX_TO_PT(32) , PX_TO_PT(89))];
        payTypeLabel.textColor = R_G_B_16(0x00b38a);
        payTypeLabel.font = [UIFont systemFontOfSize:14];
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
        if ([sectionModel.type integerValue] ==  1 || [sectionModel.type integerValue] == 2) {
            if (sectionModel.deposit && [sectionModel.deposit integerValue] > 0) {
                
                bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(320));
                bottomView.backgroundColor = [UIColor whiteColor];
                [self addSubview:bottomView];
                
                UILabel *sectionOne = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth/2, PX_TO_PT(80))];
                sectionOne.textColor = R_G_B_16(0x323232);
                sectionOne.font = [UIFont systemFontOfSize:14];
                sectionOne.text = @"阶段一: 订金";
                [bottomView addSubview:sectionOne];
                
                UILabel *sectionTwo = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(80), ScreenWidth/2, PX_TO_PT(80))];
                sectionTwo.textColor = R_G_B_16(0x323232);
                sectionTwo.font = [UIFont systemFontOfSize:14];
                sectionTwo.text = @"阶段一: 尾款";
                [bottomView addSubview:sectionTwo];
                
                UILabel *sectionThree = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(160), ScreenWidth/2, PX_TO_PT(80))];
                sectionThree.textColor = R_G_B_16(0x323232);
                sectionThree.font = [UIFont systemFontOfSize:14];
                [bottomView addSubview:sectionThree];
                
                UILabel *sectionFour = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(240), PX_TO_PT(140), PX_TO_PT(60))];
                sectionFour.backgroundColor = R_G_B_16(0x00b38a);
                sectionFour.textColor = [UIColor whiteColor];
                sectionFour.text = @"去付款";
                sectionFour.layer.cornerRadius = 5.0;
                sectionFour.layer.masksToBounds = YES;
                [bottomView addSubview:sectionFour];
                
                UILabel *depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
                depositLabel.textColor = R_G_B_16(0x323232);
                depositLabel.font = [UIFont systemFontOfSize:14];
                [bottomView addSubview:depositLabel];
                
                UILabel *remainPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(80), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
                remainPriceLabel.textColor = R_G_B_16(0x00b38a);
                remainPriceLabel.font = [UIFont systemFontOfSize:14];
                [bottomView addSubview:remainPriceLabel];
                
                UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(160), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
                totalPriceLabel.font = [UIFont systemFontOfSize:14];
                [bottomView addSubview:totalPriceLabel];
                
            }else{
                
                bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(160));
                bottomView.backgroundColor = [UIColor whiteColor];
                [self addSubview:bottomView];


            }
        }else{
            if (sectionModel.deposit && [sectionModel.deposit integerValue] >0) {
                bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(240));
                bottomView.backgroundColor = [UIColor whiteColor];
                [self addSubview:bottomView];


            }else{
                bottomView.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80));
                bottomView.backgroundColor = [UIColor whiteColor];
                [self addSubview:bottomView];
        }
    }

        return bottomView;
    }else{
        return nil;
    }
    


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
        if ([sectionModel.type integerValue] ==  1 || [sectionModel.type integerValue] == 2) {
            if (sectionModel.deposit && [sectionModel.deposit integerValue] > 0) {
                return PX_TO_PT(320);
                
            }else{
                return PX_TO_PT(160);
            }
        }else{
            if (sectionModel.deposit && [sectionModel.deposit integerValue] >0) {
                return PX_TO_PT(240);
            }else{
                return PX_TO_PT(80);
            }
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
        return sectionModel.products.count;
    } else {
        return 0;
    }
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(300);
    
}

//cell点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"被点击了");
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
    
    [cell setCheckOrderBlock:^(NSString *orderID,NSString*orderNO) {
        self.checkOrderBlock(orderID,orderNO);
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    //传递数据模型model
    XNRMyOrderSectionModel *sectionModel = _dataArr[indexPath.section];
    XNRMyOrderModel *model = sectionModel.products[indexPath.row];
    [cell setCellDataWithShoppingCartModel:model];
    
    return cell;
    
    
}

@end
