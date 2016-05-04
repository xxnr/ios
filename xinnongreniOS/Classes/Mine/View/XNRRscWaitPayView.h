//
//  XNRRscWaitPayView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRRscWaitPayViewBlock)(NSString *orderId);

@interface XNRRscWaitPayView : UIView
@property (nonatomic, copy) XNRRscWaitPayViewBlock com;

@end
