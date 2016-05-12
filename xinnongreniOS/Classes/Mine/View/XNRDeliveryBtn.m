//
//  XNRDeliveryBtn.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRDeliveryBtn.h"

@implementation XNRDeliveryBtn
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = PX_TO_PT(6);
        self.layer.masksToBounds = YES;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    UIImage *iamge = [UIImage imageNamed:@"check-the"];
    CGFloat imageW = iamge.size.width;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageX = contentRect.size.width-imageW;
    CGFloat imageY = contentRect.size.height - imageH;
    //self.imageView.contentMode = UIViewContentModeCenter;
    return CGRectMake(imageX,imageY, imageW, imageH);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
