//
//  XNRNavigationController.m
//  qianxiheiOS
//
//  Created by Scarecrow on 15/5/18.
//  Copyright (c) 2015年 XNRiOS. All rights reserved.
//

#import "XNRNavigationController.h"

@interface XNRNavigationController ()

@end

@implementation XNRNavigationController

+(void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"icon_navbg"] forBarMetrics:UIBarMetricsDefault];

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    navBar.shadowImage = [[UIImage alloc] init];
    navBar.barTintColor = R_G_B_16(0x00b38a);
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    dic[NSFontAttributeName] = [UIFont boldSystemFontOfSize:24];
    [navBar setTitleTextAttributes:dic];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    CATransition *trans=[CATransition animation];
    trans.type=@"cube";
    trans.subtype=@"fromLeft";
    trans.duration = .35;
//    [self.view.layer addAnimation:trans forKey:nil];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    CATransition *trans=[CATransition animation];
    trans.type=@"suckEffect";
    trans.duration = .35;
//    [self.view.layer addAnimation:trans forKey:nil];
    return [super popViewControllerAnimated:animated];
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
