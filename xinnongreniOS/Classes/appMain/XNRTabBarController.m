//
//  XNRTabBarController.m
//  qianxiheiOS
//
//  Created by Scarecrow on 15/5/18.
//  Copyright (c) 2015年 XNRiOS. All rights reserved.
//

#import "XNRTabBarController.h"
#import "XNRNavigationController.h"
#import "XNRHomeController.h"
#import "XNRChatController.h"
#import "XNRShoppingCarController.h"
#import "XNRMineController.h"
@interface XNRTabBarController ()

@end

@implementation XNRTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //首页
    XNRHomeController *home = [[XNRHomeController alloc]init];
    [self addChildViewController:home title:@"首页" image:@"icon_home" selImage:@"icon_home_selelcted"];
    
    //咨询
     XNRChatController *chat = [[XNRChatController alloc]init];
     [self addChildViewController:chat title:@"资讯" image:@"icon_message" selImage:@"icon_message_selected"];
    
    //购物车
    XNRShoppingCarController *shoppingCar = [[XNRShoppingCarController alloc]init];
    [self addChildViewController:shoppingCar title:@"购物车" image:@"icon_shopcar" selImage:@"icon_shopcar_selected"];
    
    //我的
    XNRMineController *mine = [[XNRMineController alloc]init];
    [self addChildViewController:mine title:@"我的" image:@"icon_profile" selImage:@"icon_profile_selected"];
    
    
    UITabBarItem *item = [UITabBarItem appearance];
    //设置未选中状态tabbaritem字体颜色
    NSMutableDictionary *norDic = [NSMutableDictionary dictionary];
    norDic[NSFontAttributeName] = [UIFont systemFontOfSize:12.0];
    norDic[NSForegroundColorAttributeName] = R_G_B_16(0x646464);
    [item setTitleTextAttributes:norDic forState:UIControlStateNormal];
    
    //设置选中状态tabbaritem字体颜色
    NSMutableDictionary *selDic = [NSMutableDictionary dictionary];
    selDic[NSFontAttributeName] = [UIFont systemFontOfSize:12.0];
    selDic[NSForegroundColorAttributeName] = R_G_B_16(0x00b38a);
    [item setTitleTextAttributes:selDic forState:UIControlStateSelected];

}
/**
 *  设置子控制器
 */
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage
{
    childController.title = title;
    [childController.tabBarItem setImage:[UIImage imageNamed:image]];
    UIImage *sel = [UIImage imageNamed:selImage];
    sel = [sel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childController.tabBarItem setSelectedImage:sel];
    XNRNavigationController *nav = [[XNRNavigationController alloc]initWithRootViewController:childController];
    [self addChildViewController:nav];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
