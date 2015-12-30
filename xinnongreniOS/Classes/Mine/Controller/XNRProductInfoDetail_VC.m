//
//  XNRProductInfoDetail_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRProductInfoDetail_VC.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#define KIntroduceTag  100   //商品介绍
#define KParameterTag  101   //商品参数
#define KSeveiceTag    102   //包装售后
@interface XNRProductInfoDetail_VC ()<UIWebViewDelegate,NJKWebViewProgressDelegate>{
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property(nonatomic,retain)UIWebView*XnrProduct_web;
@property(nonatomic,copy)NSString*IntroduceUrl;
@property(nonatomic,copy)NSString*ParameterUrl;
@property(nonatomic,copy)NSString*SeveiceUrl;
@end

@implementation XNRProductInfoDetail_VC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.IntroduceUrl=@"http://app.webcars.com.cn/News.aspx?newsid=102996&page=1";
    self.ParameterUrl=@"http://app.webcars.com.cn/News.aspx?newsid=93178&page=1";
    self.SeveiceUrl=@"http://app.webcars.com.cn/News.aspx?newsid=98266&page=1";
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    [self setNavigationbarTitle];
    
    [self createTopView];
    [self createWebView];
    [self createProgressView];
    [self getData];
    
}
#pragma mark-创建进度条
-(void)createProgressView{
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _XnrProduct_web.delegate = _progressProxy;
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

#pragma mark-获取网络数据
-(void)getData{
    
    
    
    
}
#pragma mark-创建顶部视图
-(void)createTopView{
   
    //商品介绍
    UIButton*allButton=[MyControl createButtonWithFrame:CGRectMake(30, 20,(ScreenWidth-90)/3, 30) ImageName:nil Target:self Action:@selector(buttonClick:) Title:@"商品介绍"];
    [allButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    allButton.titleLabel.font= XNRFont(15);
    allButton.tag=KIntroduceTag;
    [self.view addSubview:allButton];
    //规格参数
    UIButton*outButton=[MyControl createButtonWithFrame:CGRectMake(30+(ScreenWidth-90)/3+20, 20, (ScreenWidth-90)/3, 30) ImageName:nil Target:self Action:@selector(buttonClick:) Title:@"规格参数"];
    outButton.titleLabel.font= XNRFont(15);
    outButton.tag=KParameterTag;
    [self.view addSubview:outButton];
    //转入
    UIButton*inButton=[MyControl createButtonWithFrame:CGRectMake(30+2*(ScreenWidth-90)/3+40, 20, (ScreenWidth-90)/3, 30) ImageName:nil Target:self Action:@selector(buttonClick:) Title:@"包装售后"];
    inButton.tag=KSeveiceTag;
    inButton.titleLabel.font= XNRFont(15);
    [self.view addSubview:inButton];

    
}

#pragma mark-创建web页
-(void)createWebView{
    
    self.XnrProduct_web=[[UIWebView alloc]initWithFrame:CGRectMake(10,70, ScreenWidth-20, ScreenHeight-64-70)];
    self.XnrProduct_web.scalesPageToFit = YES;//自适配
    self.XnrProduct_web.backgroundColor=[UIColor whiteColor];
    [self.XnrProduct_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.IntroduceUrl] cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60*60]];
    [self.view addSubview:self.XnrProduct_web];

}

-(void)buttonClick:(UIButton*)button{

    static int index=100;
    UIButton*lastbutton=(UIButton*)[self.view viewWithTag:index ];
    [lastbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    if(button.tag==KIntroduceTag){
        
        NSLog(@"商品介绍");
        
        
        [self.XnrProduct_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.IntroduceUrl] cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60*60]];
        
    }else if (button.tag==KParameterTag){
        
        NSLog(@"商品参数");
         [self.XnrProduct_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.ParameterUrl] cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60*60]];
        
    }else if(button.tag==KSeveiceTag){
        
        NSLog(@"包装售后");
         [self.XnrProduct_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.SeveiceUrl] cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60*60]];
        
    }

    index=(int)button.tag;

}

-(void)backClick{

    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"商品信息";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_progressView removeFromSuperview];
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
