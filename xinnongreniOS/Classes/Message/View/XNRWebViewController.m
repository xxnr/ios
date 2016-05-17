//
//  XNRWebViewController.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/5.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRWebViewController.h"
#import "XNRUMShareView.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface XNRWebViewController ()<XNRUMShareViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, strong) XNRUMShareView *shareView;

@end

@implementation XNRWebViewController

-(XNRUMShareView *)shareView
{
    if (!_shareView) {
        self.shareView = [[XNRUMShareView alloc] init];
        self.shareView.delegate = self;
        [self.view addSubview:self.shareView];
    }
    return _shareView;
}

-(void)XNRUMShareViewBtnClick:(XNRUMShareViewType)type
{
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.image]];
        UIImage *shareImage = [UIImage imageWithData:data];
    if (_model.image == nil || [_model.image isEqualToString:@""]) {
        shareImage = [UIImage imageNamed:@"share_icon"];
    }
    
    NSString *contentString = [NSString stringWithFormat:@"%@",_model.newsabstract];
    if (_model.newsabstract == nil || [_model.newsabstract isEqualToString:@""]) {
        contentString = @"分享自@新新农人";
    }
    if (type == wechatbtn_type) {
        [UMSocialData defaultData].extConfig.wechatSessionData.url = _model.shareurl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = _model.title;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:contentString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [UILabel showMessage:@"分享成功"];
            }else{
                [UILabel showMessage:@"分享失败"];
            }
            [self.shareView cancel];
        }];
     }else if (type == wechatCirclebtn_type){
         [UMSocialData defaultData].extConfig.wechatTimelineData.url = _model.shareurl;
         [UMSocialData defaultData].extConfig.wechatTimelineData.title = _model.title;

         [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:_model.newsabstract image:shareImage location:nil urlResource:nil  presentedController:self completion:^(UMSocialResponseEntity *response) {
             if (response.responseCode == UMSResponseCodeSuccess) {
                 [UILabel showShareMessage:@"分享成功"];
             }else{
                 [UILabel showShareMessage:@"分享失败"];
             }
             [self.shareView cancel];

         }];

    
     }else if (type == qqbtn_type){
         [UMSocialData defaultData].extConfig.qqData.url = _model.shareurl;
         [UMSocialData defaultData].extConfig.qqData.title = _model.title;

         [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_model.newsabstract image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
             if (response.responseCode == UMSResponseCodeSuccess) {
                 [UILabel showShareMessage:@"分享成功"];
             }else{
                 [UILabel showShareMessage:@"分享失败"];
             }
             [self.shareView cancel];

         }];
    
     }else if(type == qzonebtn_type){
         [UMSocialData defaultData].extConfig.qzoneData.url = _model.shareurl;
         [UMSocialData defaultData].extConfig.qzoneData.title = _model.title;
         [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_model.newsabstract image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
             if (response.responseCode == UMSResponseCodeSuccess) {
                 [UILabel showShareMessage:@"分享成功"];
             }else{
                 [UILabel showShareMessage:@"分享失败"];
             }
             [self.shareView cancel];

         }];
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
<<<<<<< HEAD
    backBtn.frame = CGRectMake(0, 0, 30, 44);
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
=======
    [backBtn setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    backBtn.frame = CGRectMake(0, 0, 80, 40);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
>>>>>>> origin/master
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
     [backBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#009975"]] forState:UIControlStateHighlighted];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *shanreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shanreBtn.frame = CGRectMake(0, 0, 30, 30);
    [shanreBtn setImage:[UIImage imageNamed:@"share-ios-"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:shanreBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [shanreBtn addTarget:self action:@selector(shanreBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)shanreBtnClick
{
    [self.shareView show];
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setModel:(XNRMessageModel *)model
{
    _model = model;
}
@end
