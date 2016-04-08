//
//  XRNSubOrdersModel.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XRNSubOrdersModel.h"

@implementation XRNSubOrdersModel
//防止kvc由于缺少属性报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    //纠错赋值
//    if ([key isEqualToString:@"id"]) {
//        self.orderId = value;
//    }
}

- (NSMutableArray *)payments {
    if (!_payments) {
        _payments = [NSMutableArray array];
    }
    return _payments;
}

@end
