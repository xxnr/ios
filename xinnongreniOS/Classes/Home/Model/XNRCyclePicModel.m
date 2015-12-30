//
//  XNRCyclePicModel.m
//  xinnongreniOS
//
//  Created by ZSC on 15/7/3.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRCyclePicModel.h"

@implementation XNRCyclePicModel
//防止kvc由于缺少属性报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //纠错赋值
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
