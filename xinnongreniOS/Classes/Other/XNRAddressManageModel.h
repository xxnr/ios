//
//  XNRAddressManageModel.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRAddressManageModel : NSObject

/**
 *  地址
 */
@property (copy,nonatomic) NSString *address;

/**
 *  用户ID
 */
@property (copy,nonatomic) NSString *userId;
/**
 *  地址唯一标识
 */
@property (copy,nonatomic) NSString *addressId;
/**
 *  是否默认(1.默认2.非默认)
 */
@property (copy,nonatomic) NSString *type;
/**
 *  收货人手机号
 */
@property (copy,nonatomic) NSString *receiptPhone;
/**
 *  收货人名称
 */
@property (copy,nonatomic) NSString *receiptPeople;

/**
 *  省份ID
 */
@property (copy,nonatomic) NSString *areaId;
@property (copy,nonatomic) NSString *cityId;
@property (copy,nonatomic) NSString *countyId;
@property (copy,nonatomic) NSString *townId;

//附加字段
@property (nonatomic,assign) BOOL selected;
/**
 *  省
 */
@property (nonatomic ,copy) NSString *areaName;
/**
 *  市
 */
@property (nonatomic ,copy) NSString *cityName;
/**
 *  县
 */

@property (nonatomic ,copy) NSString *countyName;
/**
 *  镇
 */

@property (nonatomic ,copy) NSString *townName;
/**
 *  邮编
 */
@property (nonatomic ,copy) NSString *zipCode;

@end
