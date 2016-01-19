//
//  XNRCheckOrderModel.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/3.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRCheckOrderModel : NSObject
/**
 *  商品数
 */
@property (copy,nonatomic) NSString *goodsCount;
/**
 *  商品名
 */
@property (copy,nonatomic) NSString *goodsName;
/**
 *  图片名
 */
@property (copy,nonatomic) NSString *imgs;
/**
 *  子订单状态
 */
@property (copy,nonatomic) NSString *orderSubType;
/**
 *  现价
 */
@property (copy,nonatomic) NSString *unitPrice;
/**
 *  原价
 */
@property (copy,nonatomic) NSNumber *originalPrice;
/**
 *  订单编码
 */
@property (nonatomic,copy) NSString *orderSubNo;

@property (nonatomic, copy) NSString *deposit;

//附加属性
/**
 *  我的订单类型
 */
@property (copy,nonatomic) NSString *orderType;

@property (nonatomic,assign) BOOL isSelected;

@property (copy,nonatomic) NSString *goodsId;

@property (copy,nonatomic) NSString *habitatId;

@property (copy,nonatomic) NSString *point;


@property (nonatomic ,copy) NSString *totalPrice;

@property (nonatomic ,copy) NSString *id;

@property (nonatomic ,copy) NSString *payStatus;

@end
