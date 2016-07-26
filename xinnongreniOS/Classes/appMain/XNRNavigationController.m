//
//  XNRNavigationController.m
//  qianxiheiOS
//
//  Created by Scarecrow on 15/5/18.
//  Copyright (c) 2015年 XNRiOS. All rights reserved.
//

#import "XNRNavigationController.h"

@interface XNRNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
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
    
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:PX_TO_PT(48)];
    [navBar setTitleTextAttributes:dic];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate =self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    CATransition *trans=[CATransition animation];
    trans.type=@"cube";
    trans.subtype=@"fromLeft";
    trans.duration = .35;
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    CATransition *trans=[CATransition animation];
    trans.type=@"suckEffect";
    trans.duration = .35;
    return [super popViewControllerAnimated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
       
        if (navigationController.viewControllers.count ==1) {
            self.interactivePopGestureRecognizer.enabled =NO;
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
    
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
