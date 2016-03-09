//
//  XNRCheckOrderSectionModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/1/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRCheckOrderSectionModel : NSObject

@property (nonatomic ,copy) NSString *id;//订单ID

@property (nonatomic ,copy) NSString *recipientName;//收件人姓名

@property (nonatomic ,copy) NSString *recipientPhone;//收件人电话

@property (nonatomic ,copy) NSString *address;//收件人地址

@property (nonatomic ,copy) NSString *type;//订单目前状态类型

@property (nonatomic ,copy) NSString *value;//订单状态的展示

@property (nonatomic ,copy) NSString *deposit;//定金（没有定金时为0）

@property (nonatomic ,copy) NSString *totalPrice;//总价

@property (nonatomic ,copy) NSString *payStatus;//支付状态

@property (nonatomic ,strong) NSMutableArray *orderGoodsList;//订单商品信息

@property (nonatomic ,copy) NSString *duePrice;//待付金额,仅用于展示，不用于付款

@property (nonatomic ,copy) NSString *price;//下次要支付的金额（详情页展示的待付金额）

@property (nonatomic ,copy) NSString *payType;//支付类型

@property (nonatomic ,copy) NSString *paySubOrderType;//本次付款的子订单类型
@end
