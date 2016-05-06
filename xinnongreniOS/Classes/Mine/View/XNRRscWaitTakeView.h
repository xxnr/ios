//
//  XNRRscWaitTakeView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRRscOrderModel;
typedef void(^XNRRscWaitTakeViewBlock)(XNRRscOrderModel *model);

@interface XNRRscWaitTakeView : UIView

@property (nonatomic, copy) XNRRscWaitTakeViewBlock com;

@end
