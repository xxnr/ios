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
#define GET_PROFILE_LIST app/profile/getProfileList
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
    [self umengTrack];
    currentIndex = 0;
    // 网络监听
    [self monitorNetwork];
    // 根控制器
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _tabBarController = [[XNRTabBarController alloc]init];
    _tabBarController.delegate = self;
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isEnterAgain"] == NO
        ) {
        UserInfo *info = [[UserInfo alloc]init];
        info.loginState=NO;
        [DataCenter saveAccount:info];
        //创建引导页(在keyWindow上的会挡住后创建的登录页)
        [self createGuideView];
        //本地存储,存储一个是否再次进入的状态值(布尔型)
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isEnterAgain"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

#pragma mark -- UM
-(void)umengTrack{
    
    [MobClick startWithAppkey:UM_APPKEY reportPolicy:BATCH channelId:nil];
    // version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    // 自有账号登陆
    [MobClick profileSignInWithPUID:@"playerID"];
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
