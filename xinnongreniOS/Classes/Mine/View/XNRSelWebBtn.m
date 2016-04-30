//
//  XNRSelWebBtn.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/25.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSelWebBtn.h"

@implementation XNRSelWebBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    UIImage *image = [UIImage imageNamed:@"address_circle"];

    return CGRectMake(PX_TO_PT(31), (contentRect.size.height-image.size.height)/2, PX_TO_PT(37), PX_TO_PT(37));
}

@end
