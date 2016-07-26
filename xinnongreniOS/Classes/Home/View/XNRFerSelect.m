//
//  XNRFerSelect.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/25.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRFerSelect.h"

@interface XNRFerSelect()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) NSString *morePruductBtn;
@end

@implementation XNRFerSelect

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
//        self.backgroundColor = R_G_B_16(0xc7c7c7);
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
    imageView.image = [UIImage imageNamed:@"icon_green"];
    self.imageView = imageView;
    [self addSubview:imageView];
    
    UILabel *ferLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+PX_TO_PT(12), littleY, ScreenWidth/2, littleH)];
    ferLabel.text = @"汽车精选";
    ferLabel.textColor = R_G_B_16(0x323232);
    ferLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    [self addSubview:ferLabel];
    
    UIButton *morePruductBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    morePruductBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, PX_TO_PT(90));
    [morePruductBtn setImage:[UIImage imageNamed:@"icon_right_arrow"] forState:UIControlStateNormal];
    morePruductBtn.imageView.contentMode = UIViewContentModeCenter;
    [morePruductBtn setTitle:@"更多产品" forState:UIControlStateNormal];
    [morePruductBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    morePruductBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(22)];
    morePruductBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, -(ScreenWidth/2)-PX_TO_PT(8));
//    morePruductBtn.titleEdgeInsets = UIEdgeInsetsMake(0, PX_TO_PT(ScreenWidth/2)-PX_TO_PT(22), 0, 0);
    CGSize size = [morePruductBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(22)]];
    
    morePruductBtn.titleEdgeInsets = UIEdgeInsetsMake(0, [UIImage imageNamed:@"icon_right_arrow"].size.width+size.width+PX_TO_PT(60), 0,0);

    [morePruductBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:morePruductBtn];
}

-(void)moreClick
{
    
    if (self.com) {
        self.com();
    }
    
}
@end
