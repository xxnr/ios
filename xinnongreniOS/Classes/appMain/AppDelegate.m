//
//  AppDelegate.m
//  qianxiheiOS
//
//  Created by Scarecrow on 15/5/18.
//  Copyright (c) 2015年 XNRiOS. All rights reserved.
//

#import "AppDelegate.h"
#import "XNRTabBarController.h"
#import "GuideView.h"
#import "XNRLoginViewController.h"
#import "GBAlipayManager.h"
#import "XNROrderSuccessViewController.h"
#import "XNRHomeController.h"
#import "XNRferView.h"
#import "MobClick.h"
#import "XNRNewFeatureViewController.h"
#import "UMessage.h"
//#import "IQKeyboardManager.h"
#define GET_PROFILE_LIST app/profile/getProfileList
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate ()<UITabBarControllerDelegate>
{
    NSInteger currentIndex;
}
@property (nonatomic,strong)GuideView *guideView;
@property (nonatomic, copy) NSString *pubKey;

@end

@implementation AppDelegate

+ (AppDelegate *)shareAppDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 调用友盟的方法
    [self umengTrack:launchOptions];
    // 友盟推送
    
    currentIndex = 0;
    // 网络监听
    [self monitorNetwork];
    // 根控制器
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _tabBarController = [[XNRTabBarController alloc]init];
    _tabBarController.delegate = self;
    [self.window makeKeyAndVisible];
    
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
        //本地存储,存储一个是否再次进入的状态值(布尔型)
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isEnterAgain"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    // 键盘的管理
//    [IQKeyboardManager sharedManager].enable = YES;
    
    return YES;
}

#pragma mark -- UM
-(void)umengTrack:(NSDictionary *)launchOptions {
    
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
//    [UMessage setLogEnabled:YES];
    
}

#pragma mark-->引导页
- (void)createGuideView
{
    self.guideView = [[GuideView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    __weak __typeof(&*self)weakSelf = self;
    self.guideView.startBlock = ^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.guideView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.guideView removeFromSuperview];
            weakSelf.guideView = nil;
        }];
    };
    
    [AppKeyWindow addSubview:self.guideView];
  
}

#pragma mark - 设置网络监听
- (void)monitorNetwork
{
    //开启网络监听
    MonitorNetworkViewController *mnvc = [MonitorNetworkViewController sharedInstance];
    [mnvc monitorNetworkType];
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
    return YES;
    /*
     //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
     if ([url.host isEqualToString:@"safepay"]) {
     [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
     //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
     NSLog(@"result = %@",resultDic);
     }];
     }
     if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
     
     [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
     //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
     NSLog(@"result = %@",resultDic);
     }];
     }
     return YES;
    */
}

- (UIViewController *)getTopViewController {
    UINavigationController *nav = [_tabBarController selectedViewController];
    return [nav topViewController];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}


- (void)applicationWillResignActive:(UIApplication *)application {


}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)applicatio
{
  
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
