//
//  XNRControllerTool.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/10.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRControllerTool.h"
#import "UMessage.h"
#import "MobClick.h"
#import <Bugtags/Bugtags.h>
#import "XNRNewFeatureViewController.h"
#import "XNRTabBarController.h"

#define GET_PROFILE_LIST app/profile/getProfileList
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@implementation XNRControllerTool


+(void)umengTrack:(NSDictionary *)launchOptions{
#pragma mark -- UM推送

        
    [MobClick startWithAppkey:UM_APPKEY reportPolicy:BATCH channelId:nil];
        // version标识
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        // 自有账号登陆
        [MobClick profileSignInWithPUID:@"playerID"];
        
        
        //友盟推送
        //set AppKey and LaunchOptions
        [UMessage startWithAppkey:UM_APPKEY launchOptions:launchOptions];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            //register remoteNotification types
            UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
            action1.identifier = @"action1_identifier";
            action1.title=@"Accept";
            action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
            
            UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
            action2.identifier = @"action2_identifier";
            action2.title=@"Reject";
            action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = YES;
            
            UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
            categorys.identifier = @"category1";//这组动作的唯一标示
            [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
            
            UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                         categories:[NSSet setWithObject:categorys]];
            [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
            
        } else{
            //register remoteNotification types
            [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
             |UIRemoteNotificationTypeSound
             |UIRemoteNotificationTypeAlert];
        }
#else
        
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
        
#endif
        //for log
        [UMessage setLogEnabled:YES];
    
}

+(void)monitorNetwork{
    //开启网络监听
    MonitorNetworkViewController *mnvc = [MonitorNetworkViewController sharedInstance];
    [mnvc monitorNetworkType];


}

+(void)runBugtags{
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingCrashes = YES;        // 是否收集闪退，联机 Debug 状态下默认 NO，其它情况默认 YES
    options.trackingUserSteps = YES;      // 是否跟踪用户操作步骤，默认 YES
    options.trackingConsoleLog = YES;     // 是否收集控制台日志，默认 YES
    options.trackingUserLocation = YES;   // 是否获取位置，默认 YES
    options.trackingNetwork = YES;        // 是否跟踪网络请求，默认 NO
    [Bugtags startWithAppKey:@"a059d969fd904e985d25a480b071f8cf" invocationEvent:BTGInvocationEventBubble options:options];
    [Bugtags startWithAppKey:@"a059d969fd904e985d25a480b071f8cf" invocationEvent:BTGInvocationEventBubble];
}

+(void)chooseRootViewController{
    // 设置窗口的根控制器
    NSString *versionKey = @"CFBundleVersion";
    // 从沙盒中取出上次存储的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    XNRTabBarController *tabBarController = [[XNRTabBarController alloc]init];
    XNRNewFeatureViewController *newFeatureController = [[XNRNewFeatureViewController alloc] init];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        AppKeyWindow.rootViewController = tabBarController;
    }else{
        AppKeyWindow.rootViewController = newFeatureController;
        
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
