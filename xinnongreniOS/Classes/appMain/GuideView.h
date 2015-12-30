//
//  GuideView.h
//  xinnongreniOS
//
//  Created by ZSC on 15/6/10.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView

//点击开始的回调
@property (nonatomic,copy) void (^startBlock)();

@end
