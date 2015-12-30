//
//  XNRHowToEarnScore_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/4.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRHowToEarnScore_VC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface XNRHowToEarnScore_VC ()<NJKWebViewProgressDelegate,UIWebViewDelegate>{

    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property(nonatomic,retain)UIWebView*XNREarnScoreWeb;
@end

@implementation XNRHowToEarnScore_VC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    NSString* IntroduceUrl=@"http://app.webcars.com.cn/News.aspx?newsid=102996&page=1";
    _XNREarnScoreWeb=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    
     _XNREarnScoreWeb.scalesPageToFit = YES;//自适配
     _XNREarnScoreWeb.backgroundColor=[UIColor whiteColor];
    [ _XNREarnScoreWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:IntroduceUrl] cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60*60]];
    
    [self.view addSubview:_XNREarnScoreWeb];
    
    //设置导航
    [self setNav];
    //创建进度条
    [self createProgressView];

    
}
#pragma mark-创建进度条
-(void)createProgressView{
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _XNREarnScoreWeb.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 3.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
}


#pragma mark-设置导航
- (void)setNav
{
    self.navigationItem.title = @"赚取积分";
    
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
