//
//  XNRRscSearchController.h
//  xinnongreniOS
//
//  Created by xxnr on 16/5/3.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRRscAllOrderViewBlock)(NSString *orderId);

@interface XNRRscSearchController : UIViewController

@property (nonatomic, copy) XNRRscAllOrderViewBlock com;

@end
