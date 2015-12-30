//
//  UserInfo.m
//  qianxiheiOS
//
//  Created by ZSC on 15/5/19.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.

#import "UserInfo.h"
#import "MJExtension.h"

@implementation UserInfo
//防止kvc由于缺少属性报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"ture"]) {
        _sex = @"男";
    }
    if ([key isEqualToString:@"flase"]) {
        _sex = @"女";
    }
   
}

/**
 *  从文件中解析对象的时候调
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self decode:decoder];
    }
    return self;
}
/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [self encode:encoder];
}

- (NSString *)description
{
    return [self allKeyValues].description;
}

- (NSString *)address {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"shopAddress"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"shopAddress"];
    } else {
        return nil;
    }
}
@end
