//
//  XNRRscDetialDeliverView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/6/6.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRRscOrderModel;
@class XNRRscOrderDetailModel;

typedef enum : NSUInteger {
    isFromDetialDeliverController,
    isFromDetialTakeController,
} XNRRscDetialConfirmDeliverViewType;

@interface XNRRscDetialDeliverView : UIView

-(void)show:(XNRRscOrderDetailModel *)model andType:(XNRRscDetialConfirmDeliverViewType)type;

@end
