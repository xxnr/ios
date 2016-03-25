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
@property (copy,nonatomic) NSString *count;
/**
 *  商品名
 */
@property (copy,nonatomic) NSString *productName;

@property (copy, nonatomic)NSString *goodsName;
@property (copy, nonatomic)NSString *goodsCount;
@property (copy,nonatomic)NSString *unitPrice;

/**
 *  现价
 */
@property (copy,nonatomic) NSString *price;

//商品的ID
@property (nonatomic,copy) NSString *goodsId;

/**
 *  图片链接
 */
@property (copy,nonatomic) NSString *imgs;

//商品的定金
@property (nonatomic, copy) NSString *deposit;

//发货状态
@property (nonatomic,copy)NSString *deliverStatus;

//附加属性
@property (nonatomic,strong) NSMutableArray *attributes;

//附加选项
@property (nonatomic,strong) NSMutableArray *additions;


/**
 *  子订单状态
 */
@property (copy,nonatomic) NSString *orderSubType;


/**
 *  原价
 */
@property (copy,nonatomic) NSNumber *originalPrice;
/**
 *  订单编码
 */
@property (nonatomic,copy) NSString *orderSubNo;

/**
 *  我的订单类型
 */
@property (copy,nonatomic) NSString *orderType;

@property (nonatomic,assign) BOOL isSelected;

//@property (copy,nonatomic) NSString *goodsId;

@property (copy,nonatomic) NSString *habitatId;

@property (copy,nonatomic) NSString *point;


@property (nonatomic ,copy) NSString *totalPrice;

@property (nonatomic ,copy) NSString *id;

@property (nonatomic ,copy) NSString *payStatus;


@end
