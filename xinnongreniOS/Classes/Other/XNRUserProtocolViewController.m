//
//  XNRUserProtocolViewController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/7/5.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRUserProtocolViewController.h"

@interface XNRUserProtocolViewController()


@end

@implementation XNRUserProtocolViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:webView];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yonghuxieyi" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

}

-(void)setNavigationBar
{
    self.title = @"用户协议";
    //导航返回按钮
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;

}
//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
