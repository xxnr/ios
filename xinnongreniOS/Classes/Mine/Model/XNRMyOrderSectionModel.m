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


@end
