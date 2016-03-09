//
//  XNRAddOrderModel.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/3.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRAddOrderModel : NSObject

@property (nonatomic, copy) NSString *paymentId;
@property (nonatomic,copy) NSString *money;    //价钱
@property (nonatomic,copy) NSString *orderID;  //订单号
//@property (nonatomic, copy) NSString *recieveName;
//@property (nonatomic, copy) NSString *recievePhone;
//@property (nonatomic, copy) NSString *recieveAddress;

@end
