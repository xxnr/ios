//
//  XNRShopCarSectionModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/6.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRShopCarSectionModel.h"

@implementation XNRShopCarSectionModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
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

-(NSMutableArray *)SKUFrameList{
    if (!_SKUFrameList) {
        _SKUFrameList = [NSMutableArray array];
    }
    return _SKUFrameList;
}

@end
