//
//  XNRCompanyAddressModel.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCompanyAddressModel.h"

@implementation XNRCompanyAddressModel
-(NSMutableDictionary *)province
{
    if (!_province) {
        _province = [NSMutableDictionary dictionary];
    }
    return _province;
}
-(NSMutableDictionary *)town
{
    if (!_town) {
        _town = [NSMutableDictionary dictionary];
    }
    return _town;
}
-(NSMutableDictionary *)county
{
    if (!_county) {
        _county = [NSMutableDictionary dictionary];
    }
    return _county;
}
-(NSMutableDictionary *)city
{
    if (!_city) {
        _city = [NSMutableDictionary dictionary];
    }
    return _city;
}
@end
