//
//  MonitorNetworkViewController.h
//  SoEasy
//
//  Created by alwaysict on 14-12-4.
//  Copyright (c) 2014年 alwaysict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitorNetworkViewController : UIViewController

//共享实例
+ (id)sharedInstance;
//网络监听
-(void)monitorNetworkType;
//是否连接网络
@property (nonatomic,assign) BOOL isOpen;

@end
