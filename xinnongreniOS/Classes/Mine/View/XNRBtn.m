//
//  XNRBtn.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRBtn.h"

@implementation XNRBtn
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(PX_TO_PT(31), PX_TO_PT(25), PX_TO_PT(37), PX_TO_PT(37));
}

//-(UIImage *)imageForState:(UIControlState)state
//{
//    if (state == UIControlStateSelected) {
//        return [UIImage imageNamed:@"address_right"];
//    }
//    else
//    {
//        return [UIImage imageNamed:@"address_circle"];
//    }
//}
@end
