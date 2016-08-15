//
//  XNRAboutMainController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRAboutMainController.h"
#import "XNRNavigationController.h"
@implementation XNRAboutMainController

-(void)viewDidLoad
{
    [self createNavigationBar];
    [self createView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     XNRNavigationController *nav = (XNRNavigationController *)self.navigationController;
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"iOS透明导航条"] forBarMetrics:UIBarMetricsDefault];
}

-(void)createView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgImageView.image = [UIImage imageNamed:@"bj_img"];
    [self.view addSubview:bgImageView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PX_TO_PT(153), PX_TO_PT(153))];
    logoImageView.centerX = ScreenWidth/2;
    logoImageView.centerY = PX_TO_PT(296)+64;
    logoImageView.image = [UIImage imageNamed:@"xxnr-wz"];
    [bgImageView addSubview:logoImageView];
    
    UILabel *sloganLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame)+PX_TO_PT(30), ScreenWidth, PX_TO_PT(32))];
    sloganLabel.textColor = R_G_B_16(0xffffff);
    sloganLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    sloganLabel.textAlignment = NSTextAlignmentCenter;
    sloganLabel.text = @"新农业|新农村|新农人";
    [bgImageView addSubview:sloganLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sloganLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(32))];
    versionLabel.textColor = R_G_B_16(0xffffff);
    versionLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = @"V2.2.4";
    [bgImageView addSubview:versionLabel];
    
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight-64-PX_TO_PT(100), ScreenWidth, PX_TO_PT(24))];
    companyLabel.textColor = R_G_B_16(0xffffff);
    companyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.text = @"北京新新农人网络科技有限公司 版权所有";
    [bgImageView addSubview:companyLabel];
}

-(void)createNavigationBar{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"关于我们";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);

    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);

    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
