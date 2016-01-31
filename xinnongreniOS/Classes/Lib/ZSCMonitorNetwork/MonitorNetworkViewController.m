//
//  MonitorNetworkViewController.m
//  SoEasy
//
//  Created by alwaysict on 14-12-4.
//  Copyright (c) 2014年 alwaysict. All rights reserved.
//

#import "MonitorNetworkViewController.h"
#import "AFNetworking.h"

@interface MonitorNetworkViewController ()

@end

@implementation MonitorNetworkViewController

+ (id)sharedInstance
{
    //此种单例创建优点
    //1. 线程安全。
    //2. 满足静态分析器的要求。
    //3. 兼容了ARC
    static MonitorNetworkViewController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc]init];
    });
    return controller;
}

#pragma mark - 网络监听
-(void)monitorNetworkType
{
    //iphone网络状态(WAN, Wi-Fi, 不可达)
    //基本原理: 通过一个域名去判断
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"www.baidu.com"]];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        //获取网络状态
        if(status == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            _isOpen = YES;
            NSLog(@"使用GPRS/3G");
        }
        if(status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            _isOpen = YES;
            NSLog(@"使用wifi");
        }
        if(status == AFNetworkReachabilityStatusNotReachable)
        {
            NSLog(@"未连接网络");
            _isOpen = NO;
            [self warning];
        }
    }];
    //开启网络状态监视
    [manager.reachabilityManager startMonitoring];
}

#pragma mark - 添加警告视图
- (void)warning
{
    
    [UILabel showMessage:@"未连接网络"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
