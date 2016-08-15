//
//  XNRHttpTool.h
//  xinnongreniOS
//
//  Created by xxnr on 16/8/4.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRHttpTool : NSObject

/**
 *  一般的get请求
 *
 *  @param url     传入的地址Url
 *  @param param   参数(可有可无)
 *  @param success 成功回调函数
 *  @param failure 失败回调函数
 */
+ (void)get:(NSString *)url
 params:(id)param
    success:(void (^)(id responseObj))success
    failure:(void (^)(NSError *error))failure;
/**
 *  基本用来上传参数的post请求
 *
 *  @param url     传入的地址Url
 *  @param param   参数（required）
 *  @param success 成功回调函数
 *  @param failure 失败回调函数
 */
+ (void)post:(NSString *)url
  params:(id)param
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError *error))failure;


@end
