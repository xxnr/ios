//
//  XNRControllerTool.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRControllerTool.h"
#import "XNRTabBarController.h"
#import "XNRNewFeatureViewController.h"


@implementation XNRControllerTool

+(void)jumpToRootViewController
{
    // 设置窗口的根控制器
    NSString *versionKey = @"CFBundleVersion";
    // 从沙盒中取出上次存储的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        AppKeyWindow.rootViewController = [[XNRTabBarController alloc] init];
    }else{
        AppKeyWindow.rootViewController = [[XNRNewFeatureViewController alloc] init];
        // 存储这次试用的版本
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }
    // 再次登录的时候得记住上次的状态
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isEnterAgain"] == NO
        ) {
        UserInfo *info = [[UserInfo alloc]init];
        info.loginState = NO;
        [DataCenter saveAccount:info];
        // 本地存储,存储一个是否再次进入的状态值(布尔型)
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isEnterAgain"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

@end
