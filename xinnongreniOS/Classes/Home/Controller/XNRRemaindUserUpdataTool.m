//
//  XNRRemaindUserUpdataTool.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRemaindUserUpdataTool.h"

#define kStoreAppId  @"1021223448"  // （appid数字串）

@interface XNRRemaindUserUpdataTool ()<UIAlertViewDelegate>

@end

@implementation XNRRemaindUserUpdataTool

+(void)remaindUserUpData:(NSString *)deviceToken
{
    // 获得当前软件的版本号
    NSString *versionKey = @"CFBundleVersion";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    // 提示更新
    [KSHttpRequest post:KuserUpData parameters:@{@"version":currentVersion,@"device_token":deviceToken?deviceToken:@"",@"user_agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:result[@"message"]delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
            alert.delegate = self;
            [alert show];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
            // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/xin-xin-nong-ren-hu-lian-wang/id%@?l=en&mt=8", kStoreAppId]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
