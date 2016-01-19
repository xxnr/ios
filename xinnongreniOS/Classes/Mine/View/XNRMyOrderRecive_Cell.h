//
//  XNRMyOrderRecive_Cell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderModel.h"
@interface XNRMyOrderRecive_Cell : UITableViewCell

@property(nonatomic,copy)    void(^goPayBlock)(XNRMyOrderModel *model);     //确认收货
@property (nonatomic,copy)   void(^checkOrderBlock)(NSString*orderID);                                        //查看订单


- (void)setCellDataWithShoppingCartModel:(XNRMyOrderModel*)info;
@end
