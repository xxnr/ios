//
//  XNRUMShareView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/15.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRUMShareView.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"

@interface XNRUMShareView()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIImageView *shareImage;

@property (nonatomic, weak) UILabel *shareLabel;

@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIView *shareView;
@property (nonatomic, weak) UIView *shareBtn;

@end

@implementation XNRUMShareView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createShareView];
    }
    return self;
}

-(void)createShareView
{
    UIView *coverView = [[UIView alloc] initWithFrame:AppKeyWindow.bounds];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)]];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.4;
    self.coverView = coverView;
    [AppKeyWindow addSubview:coverView];

    UIView *shareView = [[UIView alloc] init];
    shareView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(280));
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.userInteractionEnabled = YES;
    self.shareView = shareView;
    [AppKeyWindow addSubview:shareView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80));
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = R_G_B_16(0xffffff);
    titleLabel.textColor = R_G_B_16(0x323232);
    titleLabel.text = @"分享到";
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.titleLabel = titleLabel;
    [shareView addSubview:titleLabel];
    
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.frame = CGRectMake(0, PX_TO_PT(80), ScreenWidth, PX_TO_PT(3));
    lineLayer.backgroundColor = R_G_B_16(0xe2e2e2).CGColor;
    [shareView.layer addSublayer:lineLayer];
    
    [self createShareBtnView];

}


-(void)createShareBtnView
{
    NSArray *titleArray = @[@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间"];
    NSArray *imageArray;
    if ([WXApi isWXAppInstalled]&&[QQApiInterface isQQInstalled]) {
        imageArray = @[@"wechat-friends",@"wechat-circle-",@"QQ",@"qqspace"];
    }else if ([WXApi isWXAppInstalled]) {
        imageArray = @[@"wechat-friends",@"wechat-circle-",@"qqlightgray",@"qqspacel"];

    }else if([QQApiInterface isQQInstalled]){
        imageArray = @[@"wechat-friendsl",@"wechat-circle-l",@"QQ",@"qqspace"];
    }else{
        imageArray = @[@"wechat-friendsl",@"wechat-circle-l",@"qqlightgray",@"qqspacel"];

    }
    CGFloat margin = (ScreenWidth-4*PX_TO_PT(69))/8;
    for (int i = 0; i<titleArray.count; i++) {
        
        UIImageView *shareImage  = [[UIImageView alloc] init];
        shareImage.frame = CGRectMake(margin+(ScreenWidth/4)*i,PX_TO_PT(70)+ margin, PX_TO_PT(69), PX_TO_PT(69));
        shareImage.image = [UIImage imageNamed:imageArray[i]];
        self.shareImage = shareImage;
        [self.shareView addSubview:shareImage];
        
        UILabel *shareLabel = [[UILabel alloc] init];
        shareLabel.frame = CGRectMake(ScreenWidth/4*i,margin+PX_TO_PT(69), ScreenWidth/4, ScreenWidth/4);
        shareLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.text = titleArray[i];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.textColor = R_G_B_16(0x323232);
        self.shareLabel = shareLabel;
        [self.shareView addSubview:shareLabel];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(margin+(ScreenWidth/4)*i,PX_TO_PT(70)+ margin, PX_TO_PT(90), PX_TO_PT(90));
        shareBtn.tag = 1000+i;
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.shareBtn = shareBtn;
        [self.shareView addSubview:shareBtn];
    }
}

-(void)shareBtnClick:(UIButton *)button
{

    if ([self.delegate performSelector:@selector(XNRUMShareViewBtnClick:)]) {
        XNRUMShareViewType type;
        if ([WXApi isWXAppInstalled]&&[QQApiInterface isQQInstalled]) {
            if (button.tag == 1000) {
                type = wechatbtn_type;
                
            }else if(button.tag == 1001){
                type = wechatCirclebtn_type;
                
                
            }else if (button.tag == 1002){
                type = qqbtn_type;
                
                
            }else{
                type = qzonebtn_type;
            }

        }else if ([WXApi isWXAppInstalled]) {
            if (button.tag == 1000) {
                type = wechatbtn_type;
                
            }else if(button.tag == 1001){
                type = wechatCirclebtn_type;
                
                
            }else{
                button.enabled = NO;
            }
            
        }else if([QQApiInterface isQQInstalled]){
            if (button.tag == 1002) {
                type = qqbtn_type;
                
            }else if(button.tag == 1003){
                type = qzonebtn_type;
                
                
            }else {
                button.enabled = NO;
                
            }
        }else{
            button.enabled = NO;
        }
        [self.delegate XNRUMShareViewBtnClick:type];
    }

}

-(void)show
{
    self.coverView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
       self.shareView.frame  =  CGRectMake(0, ScreenHeight-PX_TO_PT(280), ScreenWidth, PX_TO_PT(280));
    }];
    
}

-(void)cancel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
    }];
    
}

@end

@implementation XNRUMShareBtn

-(instancetype)init
{
    if (self = [super init]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    UIImageView *shareImage = [[UIImageView alloc] init];
    self.shareImage = shareImage;
    [self addSubview:shareImage];
    
    UILabel *shareLabel = [[UILabel alloc] init];
    shareLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.textColor = R_G_B_16(0x323232);
    self.shareLabel = shareLabel;
    [self addSubview:self.shareLabel];

}

-(void)setFrame:(CGRect)frame
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = PX_TO_PT(69);
    self.shareImage.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat labelX = CGRectGetMinX(self.shareImage.frame);
    CGFloat labelY = CGRectGetMaxY(self.shareImage.frame);
    CGFloat labelW = self.bounds.size.width;
    CGFloat labelH = PX_TO_PT(24);
    self.shareImage.frame = CGRectMake(labelX, labelY, labelW, labelH);

}


@end
