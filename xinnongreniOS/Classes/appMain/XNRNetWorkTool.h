//
//  XNRNetWorkTool.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XNRNetWorkTool : NSObject
/**
 *  是否打开网络
 */
+(BOOL)isOpen;

/**
 *  监控网络
 */
+(void)monitorNetwork;

@end
