//
//  XNRRscWaitDeliverView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRRscWaitDeliverViewBlock)(NSString *orderId);

@interface XNRRscWaitDeliverView : UIView
@property (nonatomic, copy) XNRRscWaitDeliverViewBlock com;

@end
