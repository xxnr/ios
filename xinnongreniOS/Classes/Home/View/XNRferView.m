//
//  XNRferView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/27.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRferView.h"
@interface XNRferView()
{
    BOOL isDerictor;
}
@property (nonatomic, weak) UIButton *totalBtn;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UIButton *priceBtn;

@property (nonatomic, weak) UIButton *tempBtn;

@property (nonatomic, weak) UIImageView *arrowView;

@property (nonatomic ,weak) UIImageView *imageView1;

@property (nonatomic ,weak) UIImageView *imageView2;

@end

@implementation XNRferView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self createUI];
        // 有筛选条件的时候，筛选按钮变色
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectBtnChange) name:@"selectBtnChange" object:nil];
    }
    return self;
}

-(void)selectBtnChange{
    [self.selectedBtn setImage:[UIImage imageNamed:@"icon_select_orange"] forState:UIControlStateSelected];
    [self.selectedBtn setTitleColor:R_G_B_16(0xff4e00) forState:UIControlStateSelected];
}

-(void)createUI{
    UIButton *totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalBtn.frame = CGRectMake(0,0, ScreenWidth/3, PX_TO_PT(100));
    [totalBtn setTitle:@"综合" forState:UIControlStateNormal];
    totalBtn.titleLabel.font = [UIFont systemFontOfSize:(18)];
    [totalBtn setTitleColor:R_G_B_16(0xff4e00) forState:UIControlStateSelected];
    [totalBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [totalBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.totalBtn = totalBtn;
    [self btnClick:totalBtn];
    [self addSubview:totalBtn];

    UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    priceBtn.frame = CGRectMake(CGRectGetMaxX(self.totalBtn.frame),0, ScreenWidth/3, PX_TO_PT(100));
    [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    priceBtn.adjustsImageWhenHighlighted = NO;
    priceBtn.titleLabel.font = [UIFont systemFontOfSize:(18)];
    [priceBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [priceBtn setTitleColor:R_G_B_16(0xff4e00) forState:UIControlStateSelected];
    priceBtn.adjustsImageWhenHighlighted = NO;
    [priceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.priceBtn = priceBtn;
    [self addSubview:priceBtn];
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedBtn.frame = CGRectMake(CGRectGetMaxX(self.priceBtn.frame),0, ScreenWidth/3, PX_TO_PT(100));
    [selectedBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"icon_select_gray"] forState:UIControlStateNormal];
    selectedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -90);
    selectedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    priceBtn.adjustsImageWhenHighlighted = NO;
    selectedBtn.titleLabel.font = [UIFont systemFontOfSize:(18)];
    [selectedBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [selectedBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedBtn = selectedBtn;
    [self addSubview:selectedBtn];
    
    for (int i = 1; i<3; i++) {
        UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(i*(ScreenWidth/3), 0, 1, PX_TO_PT(100))];
        midView.backgroundColor = R_G_B_16(0xc7c7c7);
        [self addSubview:midView];
    }
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, 1)];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [self addSubview:bottomLine];

}
-(void)btnClick:(UIButton *)button
{
//    self.tempBtn.selected = NO;
    button.selected = YES;
//    self.tempBtn = button;
    if ([self.delegate performSelector:@selector(ferView:)]) {
        XNRferViewDoType type;
        if (button == self.totalBtn) {
            self.priceBtn.selected = NO;
            [self.imageView1 removeFromSuperview];
            [self.imageView2 removeFromSuperview];
            type = XNRferView_DoTotalType;
        } else if (button == self.priceBtn) {
            self.totalBtn.selected = NO;
            type = XNRferView_DoPriceType;
            isDerictor = !isDerictor;
            if (isDerictor == YES) {
                [self.imageView2 removeFromSuperview];
                UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/3)*2-PX_TO_PT(64), PX_TO_PT(41), PX_TO_PT(32), PX_TO_PT(18))];
                [imageView1 setImage:[UIImage imageNamed:@"icon_orange_toparrow"]];
                self.imageView1 = imageView1;
                [self addSubview:imageView1];
            }else{
                [self.imageView1 removeFromSuperview];
                UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/3)*2-PX_TO_PT(64), PX_TO_PT(41), PX_TO_PT(32), PX_TO_PT(18))];
                [imageView2 setImage:[UIImage imageNamed:@"icon_orange_downarrow"]];
                self.imageView2 = imageView2;
                [self addSubview:imageView2];
            }
        } else {
            type = XNRferView_DoSelectType;
            NSLog(@"++++++++++++=========");
//            [self.imageView1 removeFromSuperview];
//            [self.imageView2 removeFromSuperview];

        }
        [self.delegate ferView:type];
    }
    

}
@end
