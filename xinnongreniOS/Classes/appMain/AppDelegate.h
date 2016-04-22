//
//  AppDelegate.h
//  qianxiheiOS
//
//  Created by Scarecrow on 15/5/18.
//  Copyright (c) 2015年 XNRiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) XNRTabBarController *tabBarController;

@property (nonatomic, strong) NSDictionary *launchOptions;

+ (AppDelegate *)shareAppDelegate;

- (UIViewController *)getTopViewController;

@end

