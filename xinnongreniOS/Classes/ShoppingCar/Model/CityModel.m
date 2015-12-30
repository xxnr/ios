//
//  CityModel.m
//  ZSC城市列表
//
//  Created by ZSC on 15/6/15.
//  Copyright (c) 2015年 ZSC. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
//防止kvc由于缺少属性报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //纠错赋值
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    
}
    

@end
