//
//  XNRAddress.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/7.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRAddress.h"

@implementation XNRAddress
-(NSMutableDictionary *)province
{
    if (!_province) {
        _province = [NSMutableDictionary dictionary];
    }
    return _province;
}
-(NSMutableDictionary *)city
{
    if (!_city) {
        _city = [NSMutableDictionary dictionary];
    }
    return _city;
}
-(NSMutableDictionary *)county
{
    if (!_county) {
        _county = [NSMutableDictionary dictionary];
    }
    return _county;
}
-(NSMutableDictionary *)town
{
    if (!_town) {
        _town = [NSMutableDictionary dictionary];
    }
    return _town;
}

@end
