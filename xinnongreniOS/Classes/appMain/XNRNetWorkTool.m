//
//  XNRNetWorkTool.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRNetWorkTool.h"

@implementation XNRNetWorkTool

+(void)monitorNetwork
{
    //开启网络监听
    MonitorNetworkViewController *mnvc = [MonitorNetworkViewController sharedInstance];
    [mnvc monitorNetworkType];
}




@end
