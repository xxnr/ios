//
//  XNRWebViewController.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/5.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRWebViewController.h"

@interface XNRWebViewController ()

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation XNRWebViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNav];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.url]];
    [self.view addSubview:webView];
    [webView loadRequest:request];

}
-(void)setNav{
    self.navigationItem.title = @"资讯详情";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 80, 40);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
