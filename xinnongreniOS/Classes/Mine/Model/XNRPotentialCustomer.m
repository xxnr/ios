//
//  XNRPotentialCustomer.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/7.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRPotentialCustomer.h"

@implementation XNRPotentialCustomer
-(NSMutableArray *)buyIntentions
{
    if (!_buyIntentions) {
        _buyIntentions = [NSMutableArray array];
    }
    return _buyIntentions;
}
-(NSMutableDictionary *)address
{
    if (!_address) {
        _address = [NSMutableDictionary dictionary];
    }
    return _address;
}
@end
