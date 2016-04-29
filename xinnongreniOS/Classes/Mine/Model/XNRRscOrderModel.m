//
//  XNRRscOrderModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/24.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscOrderModel.h"

@implementation XNRRscOrderModel

-(NSMutableArray *)subOrders
{
    if (!_subOrders) {
        _subOrders = [NSMutableArray array];
    }
    return _subOrders;
}

-(NSMutableArray *)payments
{
    if (!_payments) {
        _payments = [NSMutableArray array];
    }
    return _payments;
}

-(NSMutableArray *)SKUs
{
    if (!_SKUs) {
        _SKUs = [NSMutableArray array];
    }
    return _SKUs;
}

-(NSMutableArray *)SKUsFrame
{
    if (!_SKUsFrame) {
        _SKUsFrame = [NSMutableArray array];
    }
    return _SKUsFrame;
}
-(NSMutableArray *)SKUsDeliverFrame
{
    if (!_SKUsDeliverFrame) {
        _SKUsDeliverFrame = [NSMutableArray array];
    }
    return _SKUsDeliverFrame;
}
-(NSMutableDictionary *)RSCInfo
{
    if (!_RSCInfo) {
        _RSCInfo = [NSMutableDictionary dictionary];
    }
    return _RSCInfo;
}


@end

@implementation XNRRscSubOrdersModel



@end

@implementation XNRRscPaymentsModel



@end

@implementation XNRRscSkusModel

-(NSMutableArray *)attributes
{
    if (!_attributes) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

-(NSMutableArray *)additions
{
    if (!_additions) {
        _additions = [NSMutableArray array];
    }
    return _additions;
}

@end

@implementation XNRRscAttributesModel


@end

@implementation XNRRscAddtionsModel



@end

@implementation XNRRscOrderTypeModel



@end
