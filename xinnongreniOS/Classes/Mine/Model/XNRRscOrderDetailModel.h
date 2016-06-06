//
//  XNRRscOrderDetailModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/26.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRRscOrderDetailModel : NSObject

@property (nonatomic, copy) NSString *consigneeName;

@property (nonatomic, copy) NSString *consigneePhone;
@property (nonatomic, copy) NSString *consigneeAddress;

@property (nonatomic, copy) NSString *dateCreated;

@property (nonatomic, copy) NSString *totalPrice;

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *deposit;
@property (nonatomic, strong) NSDictionary *deliveryType;
@property (nonatomic, strong) NSDictionary *orderStatus;


@property (nonatomic, copy) NSString *id;

@property (nonatomic ,strong) NSMutableArray *SKUList;
@property (nonatomic ,strong) NSMutableArray *SKUFrameList;
@property (nonatomic ,strong) NSMutableArray *SKUsDeliverFrame;


@property (nonatomic ,strong) NSMutableArray *subOrders;

@property (nonatomic ,assign) BOOL isSelected;



@end
