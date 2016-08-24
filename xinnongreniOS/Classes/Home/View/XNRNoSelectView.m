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
    UIImage *image = [UIImage imageNamed:@"selected"];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-image.size.width)/2, PX_TO_PT(200), image.size.width,image.size.height)];
    selectView.image = image;
//    selectView.image = [UIImage imageNamed:@"selected"];
//    selectView.center = CGPointMake(ScreenWidth/2, ScreenHeight/3);
    self.selectView = selectView;
    [self addSubview:selectView];
    
    
    NSString *warning =@"没有找到合适的商品";
    CGSize size = [warning sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(32)] constrainedToSize:CGSizeMake(ScreenWidth, CGFLOAT_MAX)];

    UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectView.frame) + PX_TO_PT(66), ScreenWidth, size.height)];
    selectLabel.text = warning;
    selectLabel.textAlignment = NSTextAlignmentCenter;

    selectLabel.textColor = R_G_B_16(0x909090);
    selectLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    
    
    [self addSubview:selectLabel];
    
}

-(void)show{
    self.backgroundColor = R_G_B_16(0xf8f8f8);
    self.frame = CGRectMake(0, PX_TO_PT(89), ScreenWidth, ScreenHeight-PX_TO_PT(89));
}

@end
