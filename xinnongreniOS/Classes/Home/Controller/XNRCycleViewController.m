//
//  XNRCycleViewController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/5/26.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCycleViewController.h"

@interface XNRCycleViewController()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pageController;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XNRCycleViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
}

-(void)createView
{
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = ScreenWidth;
    CGFloat scrollViewH = PX_TO_PT(350);

    UIScrollView *scrollView = [[UIScrollView alloc] init];
       scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];

    
}

-(void)createCycleScrollViewWith:(NSArray *)imagesURL{
    
    
}

@end
