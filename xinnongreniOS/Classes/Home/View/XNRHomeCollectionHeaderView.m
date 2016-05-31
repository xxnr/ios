//
//  XNRHomeCollectionHeaderView.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/27.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRHomeCollectionHeaderView.h"
#import "SDCycleScrollView.h"
#define kMenuTag 1000
#define kTitleLabelTag 2000

@interface XNRHomeCollectionHeaderView ()<XNRFerSelectAddBtnDelegate>
@property (nonatomic, weak) XNRFerSelect *ferView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation XNRHomeCollectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(350)) ImageName:@"icon_home_banner"];
    [self addSubview:imageView];
    self.imageView = imageView;
    [self createMenu];
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
}

#pragma mark - 创建菜单
- (void)createMenu
{
    UIButton *ferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ferBtn.backgroundColor = [UIColor whiteColor];
    ferBtn.frame = CGRectMake(0,CGRectGetMaxY(self.imageView.frame), ScreenWidth/2,PX_TO_PT(100));
    [ferBtn setTitle:@"化肥专场" forState:UIControlStateNormal];
    [ferBtn setImage:[UIImage imageNamed:@"fertilizer"] forState:UIControlStateNormal];
    ferBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -150);
    ferBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
    [ferBtn setTitleColor:R_G_B_16(0x66ccee) forState:UIControlStateNormal];
    ferBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [ferBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    ferBtn.tag = 1000;
    self.ferBtn = ferBtn;
    [self addSubview:ferBtn];
    
    UIButton *carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    carBtn.backgroundColor = [UIColor whiteColor];
    carBtn.frame = CGRectMake(ScreenWidth/2,CGRectGetMaxY(self.imageView.frame), ScreenWidth/2, PX_TO_PT(100));
    [carBtn setTitle:@"汽车专场" forState:UIControlStateNormal];
    [carBtn setImage:[UIImage imageNamed:@"car"] forState:UIControlStateNormal];
    carBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -150);
    carBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
    [carBtn setTitleColor:R_G_B_16(0xff7700) forState:UIControlStateNormal];
    carBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [carBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.carBtn = carBtn;
    carBtn.tag = 1001;
    [self addSubview:carBtn];
    
    UIView *midLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetMaxY(self.imageView.frame), 1, PX_TO_PT(100))];
    midLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [self addSubview:midLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ferBtn.frame), ScreenWidth, 1)];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [self addSubview:bottomLine];

    XNRFerSelect *ferView = [[XNRFerSelect alloc] initWithFrame:CGRectMake(0, PX_TO_PT(450), ScreenWidth, PX_TO_PT(90))];
    [self addSubview:ferView];
    self.ferView = ferView;
}
- (void)setCom:(void (^)())com {
    _com = com;
    self.ferView.com = com;
}

- (void)btnClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(HomeCollectionHeaderViewWith:)]) {
        [self.delegate HomeCollectionHeaderViewWith:button];
    }
}
#pragma mark--创建轮播
-(void)createCycleScrollViewWith:(NSArray *)imagesURL{

    // 网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(350)) delegate:nil placeholderImage:[UIImage imageNamed:@"icon_home_banner"]];
    self.cycleScrollView.imageURLStringsGroup = imagesURL;
    self.cycleScrollView.autoScrollTimeInterval = 3.0;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"-current-0"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"default-0"];
//    self.cycleScrollView.currentPageDotColor = R_G_B_16(0x00ebb4); // 自定义分页控件小圆标颜色
//    self.cycleScrollView.pageDotColor = [UIColor clearColor];
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [self addSubview:self.cycleScrollView];
}

@end
