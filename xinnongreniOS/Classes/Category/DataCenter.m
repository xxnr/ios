//
//  DataCenter.m
//  qianxiheiOS
//
//  Created by ZSC on 15/6/25.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "DataCenter.h"
#import "UMessage.h"
#define QXHAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QXHMJAccount.data"]
#define ShopCarMarrFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ShopCarMarr.data"]
@implementation DataCenter

+ (id)sharedInstance
{
    //此种单例创建优点
    //1. 线程安全。
    //2. 满足静态分析器的要求。
    //3. 兼容了ARC
    static DataCenter *dataCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataCenter = [[self alloc]init];
    });
    return dataCenter;
}

+(BOOL)saveAccount:(UserInfo *)account
{
    if (!account.loginState) {
        [UMessage removeAlias:[DataCenter account].userid type:kUMessageAliasTypexxnr response:^(id responseObject, NSError *error) {
            NSLog(@"友盟消息推送 error: %@" ,error);

        }];
    }
   return [NSKeyedArchiver archiveRootObject:account toFile:QXHAccountFile];
}

+(UserInfo *)account
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:QXHAccountFile];
}

/**
 *  存储购物车信息
 *
 *  @param account 购物车model数组
 */
+ (BOOL)saveShopCar:(NSMutableArray *)shopCarMarr
{
    return [NSKeyedArchiver archiveRootObject:shopCarMarr toFile:ShopCarMarrFile];
}

/**
 *  购物车model数组
 */
+ (NSMutableArray *)shopCarMarr
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:ShopCarMarrFile];
}

+(void)clean{
    UserInfo *userInfo = [[UserInfo alloc] init];
    [NSKeyedArchiver archiveRootObject:userInfo toFile:QXHAccountFile];
}

@end
