//
//  XNRCarSelect.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/25.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRCarSelect.h"
@interface XNRCarSelect()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) NSString *morePruductBtn;
@end

@implementation XNRCarSelect

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self createUI];
        
    }
    return self;
}
-(void)createUI{
    
    CGFloat littleX = PX_TO_PT(32);
    CGFloat littleW = 5;
    CGFloat littleH = 14;
    CGFloat littleY = (PX_TO_PT(90)-littleH)*0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(littleX, littleY, littleW, littleH)];
    imageView.image = [UIImage imageNamed:@"icon_orange"];
    self.imageView = imageView;
    [self addSubview:imageView];
    
    UILabel *ferLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+PX_TO_PT(12), littleY, ScreenWidth/2, littleH)];
    ferLabel.text = @"化肥精选";
    ferLabel.textColor = R_G_B_16(0x323232);
    ferLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:ferLabel];
    
    UIButton *morePruductBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    morePruductBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, PX_TO_PT(90));
    [morePruductBtn setImage:[UIImage imageNamed:@"icon_right_arrow"] forState:UIControlStateNormal];
    morePruductBtn.imageView.contentMode = UIViewContentModeCenter;
    [morePruductBtn setTitle:@"更多产品" forState:UIControlStateNormal];
    [morePruductBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    morePruductBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    morePruductBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, -160);
    morePruductBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [morePruductBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:morePruductBtn];
    
}

-(void)moreClick{
    
    if (self.con) {
        self.con();
    }
    
}


@end
