//
//  XNRMyOrderSectionModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/15.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRMyOrderSectionModel.h"

@implementation XNRMyOrderSectionModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSMutableArray *)products {
    if (!_products) {
        _products = [NSMutableArray array];
    }
    return _products;
}

- (NSMutableArray *)skus {
    if (!_skus) {
        _skus = [NSMutableArray array];
    }
    return _skus;
}

- (NSMutableArray *)orderFrameArray {
    if (!_orderFrameArray) {
        _orderFrameArray = [NSMutableArray array];
    }
    return _orderFrameArray;
}

- (NSMutableDictionary *)RSCInfo {
    if (!_RSCInfo) {
        _RSCInfo = [NSMutableDictionary dictionary];
    }
    return _RSCInfo;
}




@end
