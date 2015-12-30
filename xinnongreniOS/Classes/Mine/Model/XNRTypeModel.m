//
//  XNRTypeModel.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/12.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRTypeModel.h"

@implementation XNRTypeModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //纠错赋值
    if ([key isEqualToString:@"1"]) {
        self.dataId = @"其它";
    }
    if ([key isEqualToString:@"2"]) {
        self.dataId = @"种植大户";
    }
    if ([key isEqualToString:@"3"]) {
        self.dataId = @"村级经销商";
    }
    if ([key isEqualToString:@"4"]) {
        self.dataId = @"乡镇经销商";
    }
    if ([key isEqualToString:@"5"]) {
        self.dataId = @"县级经销商";
    }
    
}
@end
