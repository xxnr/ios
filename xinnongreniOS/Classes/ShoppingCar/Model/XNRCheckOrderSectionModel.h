//
//  XNRCheckOrderSectionModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/1/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRCheckOrderSectionModel : NSObject

@property (nonatomic ,copy) NSString *id;

@property (nonatomic ,copy) NSString *recipientName;

@property (nonatomic ,copy) NSString *recipientPhone;

@property (nonatomic ,copy) NSString *address;

@property (nonatomic ,copy) NSString *type;

@property (nonatomic ,copy) NSString *value;

@property (nonatomic ,copy) NSString *deposit;

@property (nonatomic ,copy) NSString *totalPrice;

@property (nonatomic ,copy) NSString *payStatus;

@property (nonatomic ,strong) NSMutableArray *orderGoodsList;

@property (nonatomic ,copy) NSString *duePrice;

@property (nonatomic ,copy) NSString *price;

@property (nonatomic ,copy) NSString *payType;


@end
