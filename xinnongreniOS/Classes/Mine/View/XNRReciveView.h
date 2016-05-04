//
//  XNRReciveView.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderModel.h"
#import "XNRMyOrderSectionModel.h"
@interface XNRReciveView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
     NSMutableArray *_dataArr;   //模拟数据
     int _currentPage;            //当前页
}
@property (nonatomic, copy) void(^payBlock)(XNRMyOrderModel *model);//确认收货
@property(nonatomic,copy)void(^checkOrderBlock)(NSString*orderID,XNRMyOrderSectionModel *model);//查看订单
@property (nonatomic,strong) UITableView *tableView;//信息列表
@property (retain,nonatomic) NSString *urlString;
@property (nonatomic,strong)NSMutableArray *dataArr;
/**
 *  重写init方法传入数据流所需要的url
 *
 */
-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString;
-(void)headRefresh;
@end
