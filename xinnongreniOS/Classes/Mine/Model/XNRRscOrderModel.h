//
//  XNRRscOrderModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/24.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRRscOrderModel : NSObject
/** 订单_id */
@property (nonatomic, copy) NSString *_id;
/** 收货人姓名 */
@property (nonatomic, copy) NSString *consigneeName;
/** 收货人电话 */
@property (nonatomic, copy) NSString *consigneePhone;
/** 总价 */
@property (nonatomic, copy) NSString *price;
/** 订单 id */
@property (nonatomic, copy) NSString *id;
/** 子订单列表 */
@property (nonatomic, strong) NSMutableArray *subOrders;
/** 支付列表 */
@property (nonatomic, strong) NSMutableArray *payments;
/** 订单是否已确认收货 */
@property (nonatomic, copy) NSString *confirmed;
/** SKU列表 */
@property (nonatomic, strong) NSMutableArray *SKUs;

@property (nonatomic, strong) NSMutableArray *SKUsFrame;

@property (nonatomic, strong) NSMutableArray *SKUsDeliverFrame;

/** 创建时间 */
@property (nonatomic, copy) NSString *dateCreated;
/** 是否待线下支付审核 */
@property (nonatomic, copy) NSString *pendingApprove;
/** 订单状态 */
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *deliverType;

@property (nonatomic, copy) NSString *deliverValue;


@property (nonatomic, strong) NSMutableDictionary *deliveryType;

@property (nonatomic, strong) NSMutableDictionary *RSCInfo;


@end

@interface XNRRscSubOrdersModel :NSObject

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *payStatus;

@end

@interface XNRRscPaymentsModel : NSObject

@property (nonatomic, copy) NSString *slice;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *suborderId;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *thirdPartyRecorded;
@property (nonatomic, copy) NSString *isClosed;
@property (nonatomic, copy) NSString *payStatus;
@property (nonatomic, copy) NSString *dateCreated;
@property (nonatomic, copy) NSString *datePaid;

@end

@interface XNRRscSkusModel : NSObject

@property (nonatomic, copy) NSString *ref;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *deposit;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *deliverStatus;
@property (nonatomic, copy) NSString *confirmed;
@property (nonatomic, copy) NSString *dateConfirmed;

@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, strong) NSMutableArray *additions;

@property (nonatomic ,assign) BOOL isSelected;

@end

@interface XNRRscAttributesModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *ref;

@end

@interface XNRRscAddtionsModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *ref;

@end

@interface XNRRscOrderTypeModel : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *value;

@end
