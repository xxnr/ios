//
//  XNRProviceModel.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/11.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRProviceModel.h"
@implementation XNRProviceModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //纠错赋值
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
