//
//  XNRMessageModel.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/30.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRMessageModel.h"

@implementation XNRMessageModel

//防止kvc由于缺少属性报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //纠错赋值
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
