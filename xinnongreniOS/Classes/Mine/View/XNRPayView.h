//
//  XNRPayView.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderSectionModel.h"
@interface XNRPayView : UIView<UITableViewDataSource,UITableViewDelegate>{
     NSMutableArray *_dataArr;   //数据
    int _currentPage;            //当前页
}
@property (nonatomic, copy) void(^payBlock)(NSString *orderID,NSString *money);//去付款
@property(nonatomic,copy)void(^checkOrderBlock)(NSString*orderID,XNRMyOrderSectionModel *model);//查看订单
@property (nonatomic,strong) UITableView *tableView;//信息列表

/**
 *  重写init方法传入数据流所需要的url
 *
 */
-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString;
@end
