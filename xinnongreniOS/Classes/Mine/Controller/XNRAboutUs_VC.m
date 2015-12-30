//
//  XNRAboutUs_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/30.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRAboutUs_VC.h"
#import "ZSCLabel.h"

#define kAboutUs @"app/profile/getProfileList"

@interface XNRAboutUs_VC ()

@property (nonatomic,strong) UILabel *aboutUsLabel;
@property (nonatomic,strong) UIScrollView *mainScrollView;

@end

@implementation XNRAboutUs_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];
    [self createMainScrollView];
    [self createAboutUsLabel];
    [self networkRequest];
}

#pragma mark - 主滚动视图
- (void)createMainScrollView
{
    self.mainScrollView = [MyControl createUIScrollViewWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) contentSize:CGSizeMake(ScreenWidth, ScreenHeight-64) pagingEnabled:NO showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO delegate:self];
    [self.view addSubview:self.mainScrollView];
}

#pragma mark - 关于我们
- (void)createAboutUsLabel
{
    self.aboutUsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 0)];
    self.aboutUsLabel.textColor = [UIColor blackColor];
    self.aboutUsLabel.font = [UIFont systemFontOfSize:16];
    self.aboutUsLabel.numberOfLines = 0;
    [self.view addSubview:self.aboutUsLabel];
}

#pragma mark - 获取网络数据
- (void)networkRequest
{
    //key:0000关于我们,0001使用帮助,0002热线电话,0003银行账户信息
    [KSHttpRequest post:[NSString stringWithFormat:@"%@/%@",HOST,kAboutUs] parameters:@{@"locationUserId":IS_Login?[DataCenter account].userid:@"",@"key":@"0000",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datasDic = result[@"datas"];
            self.aboutUsLabel.text = datasDic[@"value"];
            if (![KSHttpRequest isBlankString:self.aboutUsLabel.text]) {
                [ZSCLabel setZSCNSTextAlignmentJustifiedWithLabel:self.aboutUsLabel andFirstLineHeadIndent:0];
                CGFloat h = [ZSCLabel getZSCTextHight:self.aboutUsLabel.text andWidth:ScreenWidth-20 andTextFontSize:16];
                self.aboutUsLabel.frame = CGRectMake(10, 10, ScreenWidth-20, h);
                self.mainScrollView.contentSize = CGSizeMake(ScreenWidth, self.aboutUsLabel.frame.size.height+50);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark-设置导航
- (void)setNav
{
    self.navigationItem.title = @"关于我们";
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchDown];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

- (void)backClick:(UIButton *)btn
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
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
