//
//  XNRRscOrderDetialController.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNRRscOrderModel;

@interface XNRRscOrderDetialController : UIViewController

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, strong) XNRRscOrderModel *orderModel;

@end
