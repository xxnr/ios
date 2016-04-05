//
//  XNRCustomer.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCustomer.h"

@implementation XNRCustomer
-(NSArray *)buyIntentions
{
    if (!_buyIntentions) {
        _buyIntentions = [NSArray array];
    }
    return _buyIntentions;
}
@end
