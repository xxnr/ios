//
//  XNRAddressModel.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/7.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRAddressModel.h"

@implementation XNRAddressModel
-(NSDictionary *)province
{
    if (!_province) {
        _province = [NSDictionary dictionary];
    }
    return _province;
}
-(NSDictionary *)city
{
    if (!_city) {
        _city = [NSDictionary dictionary];
    }
    return _city;
}
-(NSDictionary *)county
{
    if (!_county) {
        _county = [NSDictionary dictionary];
    }
    return _county;
}
-(NSDictionary *)town
{
    if (!_town) {
        _town = [NSDictionary dictionary];
    }
    return _town;
}


@end
