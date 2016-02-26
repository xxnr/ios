//
//  XNRChangeAttributesModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/2/26.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRChangeAttributesModel.h"

@implementation XNRChangeAttributesModel

//防止kvc由于缺少属性报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
    
}
-(NSMutableArray *)attributes{
    if (!_attributes) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

-(NSMutableArray *)additions{
    if (!_additions) {
        _additions = [NSMutableArray array];
    }
    return _additions;
}




@end
