//
//  XNROrderStatusOrderDetailModel.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/8/8.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNROrderStatusOrderDetailModel : NSObject
@property (nonatomic,copy)NSString *totalPrice;
@property (nonatomic,copy)NSString *deposit;

@property (nonatomic,copy)NSString *dateCreated;
@property (nonatomic,copy)NSString *datePaid;
@property (nonatomic,copy)NSString *datePendingDeliver;
@property (nonatomic,copy)NSString *dateDelivered;
@property (nonatomic,copy)NSString *dateCompleted;
@property (nonatomic,strong)NSDictionary *orderStatus;
@end
