//
//  DataCenter.h
//  qianxiheiOS
//
//  Created by ZSC on 15/6/25.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
//单例
@interface DataCenter : NSObject

/**
 *  是否登录
 */
@property (nonatomic,assign) BOOL isLogin;
/**
 *  首页是否不允许展示登录界面
 */
@property (nonatomic,assign) BOOL isMainLoginNoShow;


//共享实例
+ (id)sharedInstance;

/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (BOOL)saveAccount:(UserInfo *)account;

/**
 *  返回存储的账号信息
 */
+ (UserInfo *)account;

/**
 *  存储购物车信息
 *
 *  @param account 购物车model数组
 */
+ (BOOL)saveShopCar:(NSMutableArray *)shopCarMarr;

/**
 *  购物车model数组
 */
+ (NSMutableArray *)shopCarMarr;
/**
 *  清除账号信息
 */
+(void)clean;

@end
