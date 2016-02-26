//
//  XNRSKUAttributesModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/2/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSKUAttributesModel.h"

@implementation XNRSKUAttributesModel

//防止kvc由于缺少属性报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
    
}

-(NSMutableArray *)values{
    if (!_values) {
        _values = [NSMutableArray array];
    }
    return _values;
}

@end
