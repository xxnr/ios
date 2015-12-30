//
//  XNRSignInView.h
//  xinnongreniOS
//
//  Created by ZSC on 15/6/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRSignInView : UIView

@property (nonatomic,copy) void (^deleteBlock)();

/**
 *  签到成功
 *
 *  @param pointNum 积分数
 */
- (void)createSignSucessImageView:(NSString *)pointNum;

@end
