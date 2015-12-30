//
//  XNRMyOrderModel.h
//  xinnongreniOS
//
//  Created by ZSC on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRMyOrderModel : NSObject

/**
 *  订单ID
 */
@property (nonatomic,copy) NSString *orderId;
/**
 *  订单号
 */
@property (copy,nonatomic) NSString *orderNo;
/**
 *  订单金额
 */
@property (copy,nonatomic) NSString *totalPrice;
/**
 *  订单状态说明
 */
@property (copy,nonatomic) NSString *typeLable;
/**
 *  状态值
 */
@property (copy,nonatomic) NSNumber *typeValue;
/**
 *  deposit
 */
@property (nonatomic, copy) NSString *deposit;

@end
