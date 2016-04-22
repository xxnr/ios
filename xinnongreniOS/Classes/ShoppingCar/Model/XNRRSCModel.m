//
//  XNRRSCModel.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRSCModel.h"

@implementation XNRRSCModel
-(NSMutableDictionary *)RSCInfo
{
    if (!_RSCInfo) {
        _RSCInfo = [NSMutableDictionary dictionary];
    }
    return _RSCInfo;
}
@end
