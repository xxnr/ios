//
//  XNRShoppingCartModel.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRShoppingCartModel.h"

@implementation XNRShoppingCartModel
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
