//
//  XNRMyOrderPayCell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderModel.h"

@interface XNRMyOrderPayCell : UITableViewCell

@property (nonatomic,strong) XNRMyOrderModel*info;
@property (nonatomic,strong) UILabel *orderNum;       //订单号
@property (nonatomic,strong) UILabel *allPrice;       //总计
@property (nonatomic,strong) UIButton*goPay;          //去结算
@property (nonatomic,strong) UIButton*cancelOrder;    //取消订单
@property (nonatomic,copy)   void(^deleteBlock)();    //取消订单
@property (nonatomic,copy)   void(^checkOrderBlock)(NSString*orderID,NSString*orderNO);                                        //查看订单
@property(nonatomic,copy)    void(^goPayBlock)();     //去结算
- (void)setCellDataWithShoppingCartModel:(XNRMyOrderModel*)info;
@end
