//
//  XNRMyOrderModel.m
//  xinnongreniOS
//
//  Created by ZSC on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyOrderModel.h"

@implementation XNRMyOrderModel
//防止kvc由于缺少属性报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (NSMutableArray *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}
- (NSMutableArray *)additions {
    if (!_additions) {
        _additions = [NSMutableArray array];
    }
    return _additions;
}

@end
