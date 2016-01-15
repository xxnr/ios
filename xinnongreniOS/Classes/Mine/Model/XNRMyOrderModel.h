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
 *  订单中商品数
 */
@property (copy,nonatomic) NSString *count;
/**
 *  订单总价
 */
@property (copy,nonatomic) NSString *price;
/**
 *  最后一次支付时的支付类型
 */
@property (copy,nonatomic) NSString *payType;
/**
 *  商品名称
 */
@property (copy,nonatomic) NSString *name;
/**
 *  待付金额
 */
@property (nonatomic ,copy) NSString *duePrice;
/**
 *  订金
 */
@property (nonatomic ,copy) NSString *deposit;
/**
 *  商品图片
 */
@property (nonatomic ,copy) NSString *thumbnail;

@end
