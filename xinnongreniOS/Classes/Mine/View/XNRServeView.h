//
//  XNRServeView.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderSectionModel.h"
@interface XNRServeView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_dataArr;   //模拟数据
    int _currentPage;            //当前页
}

@property (nonatomic, copy) void(^payBlock)(NSString *orderID,NSString *money);//去付款
@property(nonatomic,copy)void(^checkOrderBlock)(NSString*orderID,NSString *type,XNRMyOrderSectionModel *model);//查看订单
@property (nonatomic,strong) UITableView*tableView;//信息列表
@property (nonatomic,copy)NSString *deleteId;
/**
 *  重写init方法传入数据流所需要的url
 *
 */
-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString;
@end
