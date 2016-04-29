//
//  AppDelegate.m
//  qianxiheiOS
//
//  Created by Scarecrow on 15/5/18.
//  Copyright (c) 2015年 XNRiOS. All rights reserved.
//

#import "AppDelegate.h"
#import "XNRTabBarController.h"
#import "GBAlipayManager.h"
#import "XNRNewFeatureViewController.h"
#import "UMessage.h"
#import "IQKeyboardManager.h"
#import <Bugtags/Bugtags.h>

#import "XNRControllerTool.h"
#import "XNRNetWorkTool.h"
#import "XNRBugTagsTool.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "XNRCheckOrderVC.h"
#import "XNRNavigationController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>
{
    BOOL _is_Notification;
}
@end

@implementation AppDelegate

+ (AppDelegate *)shareAppDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [UMessage startWithAppkey:UM_APPKEY launchOptions:launchOptions];

    self.launchOptions = launchOptions;
    // 键盘的管理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    
    // 网络监听
    [XNRNetWorkTool monitorNetwork];
    // 根控制器
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    _tabBarController = [[XNRTabBarController alloc]init];
    _tabBarController.delegate = self;
    
    // 设置窗口的根控制器
    NSString *versionKey = @"CFBundleVersion";
    // 从沙盒中取出上次存储的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        self.window.rootViewController = _tabBarController;
    }else{
        self.window.rootViewController = [[XNRNewFeatureViewController alloc] init];
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
    
    //    友盟分享
    [UMSocialData setAppKey:UM_APPKEY];
    
    [UMSocialWechatHandler setWXAppId:wechatAppId appSecret:wechatAppSecret url:APPURL];
    
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:APPURL];

    [UMessage setLogEnabled:YES];
    


    // 启动bugtags
    [XNRBugTagsTool openBugTags];
    

    //友盟注册通知
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    [UMessage setLogEnabled:YES];

    
    // 判断是否是推送进来的
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification != nil) {
        _is_Notification = YES;
    }

    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        NSLog(@"result = %@",resultDic);
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"alipayResult" object:[resultDic objectForKey:@"resultStatus"]];
        
        
    }];
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    // 友盟分享
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;

    return YES;
}

- (UIViewController *)getTopViewController {
    UINavigationController *nav = [_tabBarController selectedViewController];
    return [nav topViewController];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"---------------------Failed to get token, error:%@", error_str);
    
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    
    NSLog(@"%@",userInfo);
    
    NSString *alert = [userInfo objectForKey:@"page"];
    NSString *orderId = [userInfo objectForKey:@"orderId"];
    
//    if (application.applicationState == UIApplicationStateActive) { // 此时app在前台运行
//        application.applicationIconBadgeNumber++;
//
//    } else { // 后台运行时
    if (!_is_Notification) {
            application.applicationIconBadgeNumber++;
    }
    else
    {
        if ([alert isEqualToString:@"userOrderDetail"]) {
    
            XNRCheckOrderVC*vc=[[XNRCheckOrderVC alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.orderID = orderId;
            
            XNRNavigationController *orderNavVC = [[XNRNavigationController alloc]initWithRootViewController:vc];
            

            
            UIViewController *currentVC = [self getCurrentVC];
            
            while (currentVC.presentedViewController != nil) {
                currentVC = currentVC.presentedViewController;
            }
            
            [currentVC presentViewController:orderNavVC animated:NO completion:nil];
            
            [application setApplicationIconBadgeNumber:0];

        }

    }
    _is_Notification = NO;

}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    _is_Notification = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)applicatio
{
    _is_Notification = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}



@end
