//
//  XNRRscConfirmDeliverView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/27.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRRscOrderModel;
@class XNRRscOrderDetailModel;

typedef enum : NSUInteger {
    isFromDeliverController,
    isFromTakeController,
} XNRRscConfirmDeliverViewType;

@interface XNRRscConfirmDeliverView : UIView

-(void)show:(XNRRscOrderModel *)model andType:(XNRRscConfirmDeliverViewType)type;

-(void)show:(XNRRscOrderDetailModel *)model andDetialType:(XNRRscConfirmDeliverViewType)type;

@end
