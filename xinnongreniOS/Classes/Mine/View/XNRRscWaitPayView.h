//
//  XNRRscWaitPayView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRRscOrderModel;
typedef void(^XNRRscWaitPayViewBlock)(XNRRscOrderModel *model);

@interface XNRRscWaitPayView : UIView
@property (nonatomic, copy) XNRRscWaitPayViewBlock paycom;
@property (nonatomic,assign)BOOL isRefresh;

@end
