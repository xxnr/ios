//
//  UILabel+ZSC.h
//  xinnongreniOS
//
//  Created by ZSC on 15/7/11.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZSC)

/**
 *  顶部对齐
 *  @param text      文本内容
 *  @param maxHeight 最大高度
 */
- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight;
@end
