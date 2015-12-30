//
//  XNRProductInfo_model.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/7.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRProductInfo_model.h"

@implementation XNRProductInfo_model

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //纠错赋值
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.Desc = value;
    }
}


@end
