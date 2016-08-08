//
//  XNRBaseTool.h
//  xinnongreniOS
//
//  Created by xxnr on 16/8/4.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//  最基本的业务工具类

#import <Foundation/Foundation.h>

@interface XNRBaseTool : NSObject

+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;


@end
