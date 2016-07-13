//
//  XNRCustomerOrderEmptyView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/5/24.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRCustomerOrderEmptyView.h"
@interface XNRCustomerOrderEmptyView ()

@property (nonatomic ,weak) UIImageView *orderEmptyImageView;

@end

@implementation XNRCustomerOrderEmptyView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
    }
    return self;
    
}
-(void)createView{
    
    UIImageView *addressEmptyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PX_TO_PT(152), PX_TO_PT(165))];
    addressEmptyView.image = [UIImage imageNamed:@"dingdani-con"];
    addressEmptyView.center = CGPointMake(ScreenWidth/2, ScreenHeight/3);
    self.orderEmptyImageView = addressEmptyView;
    [self addSubview:addressEmptyView];
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.orderEmptyImageView.frame) + PX_TO_PT(32), ScreenWidth, PX_TO_PT(100))];
    emptyLabel.text = @"这位顾客暂无订单记录";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    
    emptyLabel.textColor = R_G_B_16(0xc7c7c7);
    emptyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [self addSubview:emptyLabel];
}

-(void)show{
    self.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight-44-PX_TO_PT(140));
}


@end
