//
//  XNRRscAllOrderView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNRRscOrderModel;
typedef void(^XNRRscAllOrderViewBlock)(XNRRscOrderModel *model);

@interface XNRRscAllOrderView : UIView

@property (nonatomic, copy) XNRRscAllOrderViewBlock com;

@end
