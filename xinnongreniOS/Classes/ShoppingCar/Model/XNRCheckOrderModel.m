//
//  XNRCheckOrderModel.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/3.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRCheckOrderModel.h"

@implementation XNRCheckOrderModel
//防止kvc由于缺少属性报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}

-(NSMutableArray *)additions
{
    if (!_additions) {
        _additions = [NSMutableArray array];
    }
    return _additions;
}


@end
