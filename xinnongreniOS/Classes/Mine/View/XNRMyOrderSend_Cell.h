//
//  XNRMyOrderSend_Cell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderModel.h"
@interface XNRMyOrderSend_Cell : UITableViewCell

@property (nonatomic,strong) XNRMyOrderModel*info;
@property (nonatomic,strong) UILabel *orderNum;       //订单号
@property (nonatomic,strong) UILabel *allPrice;
@property (nonatomic,strong) UILabel *orderState;                                     //发货状态

@property (nonatomic,copy)   void(^checkOrderBlock)(NSString*orderID,NSString*orderNO);                                        //查看订单                                     
- (void)setCellDataWithShoppingCartModel:(XNRMyOrderModel*)info;


@end
