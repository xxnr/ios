//
//  XNRSelectItemArrModel.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/15.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSelectItemArrModel.h"

static XNRSelectItemArrModel* model;

@implementation XNRSelectItemArrModel

+ (XNRSelectItemArrModel*)defaultModel
{
    if (!model) {
        model = [[self allocWithZone:NULL] init];
        
    }
    return model;
}

- (void)cancel
{
    [_XNRSelectItemArr removeAllObjects];
    [_XNRSelectItemDict removeAllObjects];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _XNRSelectItemArr = [NSMutableArray array];
        _XNRSelectItemDict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

@end
