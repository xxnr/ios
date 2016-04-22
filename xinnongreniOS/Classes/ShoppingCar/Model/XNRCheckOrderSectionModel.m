//
//  XNRCheckOrderSectionModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCheckOrderSectionModel.h"

@implementation XNRCheckOrderSectionModel

//防止kvc由于缺少属性报错

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
-(NSMutableDictionary *)RSCInfo
{
    if (!_RSCInfo) {
        _RSCInfo = [NSMutableDictionary dictionary];
    }
    return _RSCInfo;
}
- (NSMutableArray *)goodsList {
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

-(NSMutableArray *)SKUList{
    if (!_SKUList) {
        _SKUList = [NSMutableArray array];
    }
    return _SKUList;
}

-(NSMutableArray *)subOrders
{
    if (!_subOrders) {
        _subOrders = [NSMutableArray array];
    }
    return _subOrders;
}

@end
