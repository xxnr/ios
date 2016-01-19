//
//  XNRMYOrderComment_Cell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderModel.h"
@interface XNRMYOrderComment_Cell : UITableViewCell

@property (nonatomic,strong) XNRMyOrderModel*info;

@property (nonatomic, copy)  void(^cellCommentBlock)();
@property (nonatomic,copy)   void(^checkOrderBlock)(NSString*orderID,NSString*orderNO);                                        //查看订单
- (void)setCellDataWithShoppingCartModel:(XNRMyOrderModel*)info;


@end
