//
//  XNROrderInfoModel.h
//  xinnongreniOS
//
//  Created by ZSC on 15/7/9.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNROrderInfoModel : NSObject

/**
 *  送货地址ID(目前是北京北京test)
 */
@property (nonatomic,strong) NSString *buildingUserId;
/**
 *  订单提交时间
 */
@property (nonatomic,strong) NSString *dataSubmit;
/**
 *  期望发货时间
 */
@property (nonatomic,strong) NSString *deliveryTime;
/**
 *  订单id
 */
@property (nonatomic,strong) NSString *ID;
/**
 *  发票ID
 */
@property (nonatomic,strong) NSString *invoiceId;
/**
 *  订单编号
 */
@property (nonatomic,strong) NSString *orderNo;
/**
 *  商品数量
 */
@property (nonatomic,strong) NSString *goodsCount;
/**
 *  商品ID
 */
@property (nonatomic,strong) NSString *goodsId;
/**
 *  商品名称
 */
@property (nonatomic,strong) NSString *goodsName;
/**
 *  商品产地
 */
@property (nonatomic,strong) NSString *habitatId;
/**
 *
 */
@property (nonatomic,strong) NSString *imgs;
/**
 *
 */
@property (nonatomic,strong) NSString *orderSubType;
/**
 *  商品原价
 */
@property (nonatomic,strong) NSString *originalPrice;
/**
 *  积分抵扣信息
 */
@property (nonatomic,strong) NSString *point;
/**
 *  积分抵扣信息
 */
@property (nonatomic,strong) NSString *proType;
/**
 *  商品优惠价格
 */
@property (nonatomic,strong) NSString *unitPrice;
/**
 *  支付方式
 */
@property (nonatomic,strong) NSString *payType;
/**
 *  优惠ID
 */
@property (nonatomic,strong) NSString *privilegeId;
/**
 *  收件人
 */
@property (nonatomic,strong) NSString *recipientName;
/**
 *  联系电话
 */
@property (nonatomic,strong) NSString *recipientPhone;
/**
 *
 */
@property (nonatomic,strong) NSString *redPacketMemberId;
/**
 *  备注说明
 */
@property (nonatomic,strong) NSString *remarks;
/**
 *  购物车ID
 */
@property (nonatomic,strong) NSString *shopCartId;
/**
 *  订单总价
 */
@property (nonatomic,strong) NSString *totalPrice;
/**
 *  用户ID
 */
@property (nonatomic,strong) NSString *userId;




@end
