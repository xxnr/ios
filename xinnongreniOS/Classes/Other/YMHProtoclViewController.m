//
//  YMHProtoclViewController.m
//  TP008_4
//
//  Created by mac on 14-9-14.
//  Copyright (c) 2014年 end. All rights reserved.
//

#import "YMHProtoclViewController.h"

@interface YMHProtoclViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation YMHProtoclViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self._scrollView.showsVerticalScrollIndicator = NO;
    self._scrollView.showsHorizontalScrollIndicator = NO;
    [self makeNav];
}

- (void)makeNav
{
    self.title = @"用户协议";
    //导航返回按钮
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame=CGRectMake(0, 0, 30, 44);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];

    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
