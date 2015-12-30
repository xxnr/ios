//
//  XNRAddressEmptyView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/28.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRAddressEmptyView.h"

@interface XNRAddressEmptyView ()

@property (nonatomic ,weak) UIImageView *addressEmptyView;

@end

@implementation XNRAddressEmptyView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
    }
    return self;
    
}
-(void)createView{
    
    UIImageView *addressEmptyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PX_TO_PT(221), PX_TO_PT(241))];
    addressEmptyView.image = [UIImage imageNamed:@"noAddress_icon"];
    addressEmptyView.center = CGPointMake(ScreenWidth/2, ScreenHeight/3);
    self.addressEmptyView = addressEmptyView;
    [self addSubview:addressEmptyView];
    
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressEmptyView.frame) + PX_TO_PT(32), ScreenWidth, PX_TO_PT(100))];
    emptyLabel.text = @"您还没有收货地址哦，添加一个吧~";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    
    emptyLabel.textColor = R_G_B_16(0xc7c7c7);
    emptyLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:emptyLabel];


}

-(void)show{
    self.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight-44);
}


@end
