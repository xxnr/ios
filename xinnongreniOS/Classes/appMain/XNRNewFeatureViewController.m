//
//  XNRNewFeatureViewController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/23.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRNewFeatureViewController.h"
#define XNRNewfeatureImageCount 3

@interface XNRNewFeatureViewController()<UIScrollViewDelegate>

@property (nonatomic ,weak) UIPageControl *pageControl;

@property (nonatomic ,weak) UIImageView *selectImageView;

@end

@implementation XNRNewFeatureViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    // 1.添加scrollView
    [self setupScrollView];
    // 2.添加pageControl
    [self setupPageControl];
}

-(void)setupScrollView
{
    // 1.添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (int i = 0; i<XNRNewfeatureImageCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        if (IS_IPHONE4) { // 4inch  需要手动去加载4inch对应的-568h图片
            name = [name stringByAppendingString:@"-568h"];
        }
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 设置frame
        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i * imageW;
        
        // 给最后一个imageView添加按钮
        if (i == XNRNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
}
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(XNRNewfeatureImageCount * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;

}

/**
 设置最后一个UIImageView中的内容
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    // 添加开始按钮
    [self setupStartButton:imageView];
    
}

/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [imageView addSubview:startButton];
    
    // 2.设置背景图片
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button"] forState:UIControlStateNormal];
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [startButton setBackgroundColor:R_G_B_16(0x3dd5b2)];
    startButton.layer.borderWidth = 5.0;
    startButton.layer.cornerRadius = 20.0;
    startButton.layer.borderColor = R_G_B_16(0xade3df).CGColor;
    startButton.layer.masksToBounds = YES;
    
    startButton.frame = CGRectMake(0, 0, PX_TO_PT(300), PX_TO_PT(84));
    startButton.center = CGPointMake(self.view.width *0.5, self.view.height * 0.7);
    
    // 3.设置frame
//    startButton.size = startButton.currentBackgroundImage.size;
//    startButton.centerX = self.view.width * 0.5;
//    startButton.centerY = self.view.height * 0.5;
    
    // 4.设置文字
    [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}




/**
 *  添加pageControl
 */
- (void)setupPageControl
{
//    // 1.添加
//    UIPageControl *pageControl = [[UIPageControl alloc] init];
//    pageControl.numberOfPages = XNRNewfeatureImageCount;
//    pageControl.centerX = self.view.width * 0.5;
//    pageControl.centerY = self.view.height - 30;
//    [self.view addSubview:pageControl];
//    
//    // 2.设置圆点的颜色
//    pageControl.currentPageIndicatorTintColor = R_G_B_16(0x3dd5b2); // 当前页的小圆点颜色
//    pageControl.layer.borderWidth = 1.0;
//    pageControl.layer.borderColor = [UIColor whiteColor].CGColor;
////    pageControl.pageIndicatorTintColor = HMColor(189, 189, 189); // 非当前页的小圆点颜色
//    self.pageControl = pageControl;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, PX_TO_PT(240), PX_TO_PT(4));
    lineView.center = CGPointMake(self.view.width * 0.5, self.view.height - PX_TO_PT(100));
    lineView.backgroundColor = R_G_B_16(0x00b38a);
    [self.view addSubview:lineView];
    
    for (int i = 0; i<XNRNewfeatureImageCount; i++) {
        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(240))*0.5 + PX_TO_PT(86) + i*PX_TO_PT(32), self.view.height - PX_TO_PT(100), PX_TO_PT(20), PX_TO_PT(20))];
        roundView.centerY = self.view.height - PX_TO_PT(100);
        roundView.backgroundColor = R_G_B_16(0x3dd5ba);
        roundView.layer.cornerRadius = PX_TO_PT(10);
        roundView.layer.masksToBounds = YES;
        [self.view addSubview:roundView];
    }
    
    UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(240))*0.5 + PX_TO_PT(86), self.view.height-PX_TO_PT(137), PX_TO_PT(24), PX_TO_PT(47))];
//    imageView.centerY = self.view.height-PX_TO_PT(117);
    [selectImageView setImage:[UIImage imageNamed:@"new_feature_green"]];
    self.selectImageView = selectImageView;
    [self.view addSubview:selectImageView];
    
}

/**
 *  进入首页
 */
- (void)start
{
    // 显示主控制器（HMTabBarController）
    XNRTabBarController *vc = [[XNRTabBarController alloc] init];
    
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = vc;
    // push : [self.navigationController pushViewController:vc animated:NO];
    // modal : [self presentViewController:vc animated:NO completion:nil];
    // window.rootViewController : window.rootViewController = vc;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.selectImageView.frame = CGRectMake(((ScreenWidth-PX_TO_PT(240))*0.5 + PX_TO_PT(86))+ PX_TO_PT(32)*intPage,self.view.height-PX_TO_PT(137), PX_TO_PT(24), PX_TO_PT(47));
    }];
    
}




@end
