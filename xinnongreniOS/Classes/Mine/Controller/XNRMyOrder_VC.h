//
//  XNRMyOrder_VC.h
//  xinnongreniOS
//
//  Created by marks on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XNRPayViewtype,
    XNRSendViewType,
    XNRReciveViewType,
    XNRCommentViewType,
} XNROrderType;

@interface XNRMyOrder_VC : UIViewController


@property (nonatomic, assign) XNROrderType type;

@property (nonatomic, assign) BOOL isForm0rderBtn;

@end
