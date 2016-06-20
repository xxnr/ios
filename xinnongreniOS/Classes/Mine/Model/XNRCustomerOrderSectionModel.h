//
//  XNRCustomerOrderSectionModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/1/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRCustomerOrderSectionModel : NSObject

/**
 *  客户电话
 */
@property (nonatomic, copy) NSString *account;
/**
 *  客户昵称
 */
@property (nonatomic ,copy) NSString *nickname;
/**
 *  客户名
 */
@property (nonatomic ,copy) NSString *name;
/**
 *  客户订单总数
 */
@property (nonatomic ,copy) NSString *total;

/**
 *  下单时间
 */
@property (nonatomic ,copy) NSString *dateCreated;

/**
 *  订单数组
 */
@property (nonatomic ,strong) NSMutableArray *products;
/**
 *  订单状态
 */
@property (nonatomic ,copy) NSString *typeValue;

@property (nonatomic, copy) NSString *totalPrice;


@end

