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
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    //首页
    XNRHomeController *home = [[XNRHomeController alloc]init];
    [self addChildViewController:home title:@"首页" image:@"index_default-0" selImage:@"index_-select"];
    
    //咨询
     XNRChatController *chat = [[XNRChatController alloc]init];
     [self addChildViewController:chat title:@"资讯" image:@"information_default-0" selImage:@"information_select"];
    
    //购物车
    XNRShoppingCarController *shoppingCar = [[XNRShoppingCarController alloc]init];
    [self addChildViewController:shoppingCar title:@"购物车" image:@"shopping_default-0" selImage:@"shopping_select"];
    
    //我的
    XNRMineController *mine = [[XNRMineController alloc]init];
    [self addChildViewController:mine title:@"我的" image:@"my_default" selImage:@"my_select-0"];
    
    
    UITabBarItem *item = [UITabBarItem appearance];
    //设置未选中状态tabbaritem字体颜色
    NSMutableDictionary *norDic = [NSMutableDictionary dictionary];
    norDic[NSFontAttributeName] = [UIFont systemFontOfSize:PX_TO_PT(24)];
    norDic[NSForegroundColorAttributeName] = R_G_B_16(0x646464);
    [item setTitleTextAttributes:norDic forState:UIControlStateNormal];
    
    //设置选中状态tabbaritem字体颜色
    NSMutableDictionary *selDic = [NSMutableDictionary dictionary];
    selDic[NSFontAttributeName] = [UIFont systemFontOfSize:PX_TO_PT(24)];
    selDic[NSForegroundColorAttributeName] = R_G_B_16(0x00b38a);
    [item setTitleTextAttributes:selDic forState:UIControlStateSelected];


    [item setTitlePositionAdjustment:UIOffsetMake(0, -PX_TO_PT(3))];
}
/**
 *  设置子控制器
 */
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage
{
    childController.title = title;
//    [childController.tabBarItem setImage:[UIImage imageNamed:image]];
    UIImage *noSel = [UIImage imageNamed:image];
    childController.tabBarItem.image = [noSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *sel = [UIImage imageNamed:selImage];

    childController.tabBarItem.selectedImage = [sel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [childController.tabBarItem setSelectedImage:sel];

    childController.tabBarItem.imageInsets = UIEdgeInsetsMake(-PX_TO_PT(3), 0, PX_TO_PT(3), 0);
    XNRNavigationController *nav = [[XNRNavigationController alloc]initWithRootViewController:childController];

    [self addChildViewController:nav];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
