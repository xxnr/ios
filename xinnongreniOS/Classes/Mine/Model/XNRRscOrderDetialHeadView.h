//
//  XNRRscOrderDetialHeadView.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNRRscOrderDetailModel;

@interface XNRRscOrderDetialHeadView : UIView

@property (nonatomic, assign) CGFloat headViewHeight;

-(void)updataWithModel:(XNRRscOrderDetailModel *)model;

@end
