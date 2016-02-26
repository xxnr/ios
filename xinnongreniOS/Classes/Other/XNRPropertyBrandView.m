//
//  XNRPropertyBrandView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/2/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRPropertyBrandView.h"

@implementation XNRPropertyBrandView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        titleLabel.textColor = R_G_B_16(0x646464);
        titleLabel.backgroundColor = [UIColor clearColor];
        self.selectTitleLabel = titleLabel;
        [self addSubview:self.selectTitleLabel];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)-PX_TO_PT(20), ScreenWidth, PX_TO_PT(2))];
//        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
//        [self addSubview:lineView];
    }
    return self;
}


@end
