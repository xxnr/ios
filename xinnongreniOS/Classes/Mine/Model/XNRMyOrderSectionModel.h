//
//  XNRMyOrderSectionModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/1/15.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRMyOrderSectionModel : NSObject
/**
 *  订单号
 */

@property (nonatomic, copy) NSString *orderId;
/**
 *  支付状态
 */

@property (nonatomic, copy) NSString *payType;
/**
 *  商品数组
 */

@property (nonatomic, strong) NSMutableArray *products;

@property (nonatomic, strong) NSMutableArray *skus;


@property (nonatomic ,copy) NSString *type;

@property (nonatomic ,copy) NSString *value;

@property (nonatomic ,copy) NSString *totalPrice;

@property (nonatomic ,copy) NSString *deposit;

@property (nonatomic ,copy) NSString *duePrice;



@end
