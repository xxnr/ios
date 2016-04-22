//
//  XNRRSCDetailModel.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRSCDetailModel.h"

@implementation XNRRSCDetailModel
-(NSMutableDictionary *)companyAddress
{
    if (!_companyAddress) {
        _companyAddress = [NSMutableDictionary dictionary];
    }
    return _companyAddress;
}
@end
