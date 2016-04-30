//
//  XNRRscOrderDetailModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/26.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscOrderDetailModel.h"

@implementation XNRRscOrderDetailModel

-(NSMutableArray *)SKUList
{
    if (!_SKUList) {
        _SKUList = [NSMutableArray array];
    }
    return _SKUList;
}

-(NSMutableArray *)SKUFrameList
{
    if (!_SKUFrameList) {
        _SKUFrameList = [NSMutableArray array];
    }
    return _SKUFrameList;
}

-(NSMutableArray *)subOrders
{
    if (!_subOrders) {
        _subOrders = [NSMutableArray array];
    }
    return _subOrders;
}

@end
