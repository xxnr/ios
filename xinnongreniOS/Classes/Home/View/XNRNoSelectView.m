//
//  XNRNoSelectView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/22.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRNoSelectView.h"

@interface XNRNoSelectView ()

@property (nonatomic ,weak) UIImageView *selectView;

@end

@implementation XNRNoSelectView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
    }
    return self;

}

-(void)createView{
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PX_TO_PT(221), PX_TO_PT(241))];
    selectView.image = [UIImage imageNamed:@"selected"];
    selectView.center = CGPointMake(ScreenWidth/2, ScreenHeight/3);
    self.selectView = selectView;
    [self addSubview:selectView];
    
    
    UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectView.frame) + PX_TO_PT(32), ScreenWidth, PX_TO_PT(100))];
    selectLabel.text = @"抱歉，没有找到合适的商品";
    selectLabel.textAlignment = NSTextAlignmentCenter;

    selectLabel.textColor = R_G_B_16(0xc7c7c7);
    selectLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:selectLabel];
    
}

-(void)show{
    self.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight-44);
}

@end
