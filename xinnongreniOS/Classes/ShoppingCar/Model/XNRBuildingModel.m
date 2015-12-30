//
//  XNRBuildingModel.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/4.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRBuildingModel.h"

@implementation XNRBuildingModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //纠错赋值
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    
}
@end
