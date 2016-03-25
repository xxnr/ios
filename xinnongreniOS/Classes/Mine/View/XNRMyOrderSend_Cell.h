//
//  XNRMyOrderSend_Cell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderModel.h"
@class XNRMyAllOrderFrame;
@interface XNRMyOrderSend_Cell : UITableViewCell


@property (nonatomic,copy)void(^checkOrderBlock)(NSString*orderID,NSString*orderNO);
- (void)setCellDataWithShoppingCartModel:(XNRMyOrderModel*)info;

@property (nonatomic,strong) XNRMyAllOrderFrame *orderFrame;

@property (nonatomic ,strong) NSMutableArray *attributesArray;

@property (nonatomic ,strong) NSMutableArray *addtionsArray;


@end
