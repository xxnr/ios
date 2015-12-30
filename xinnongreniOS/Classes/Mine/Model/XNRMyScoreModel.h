//
//  XNRMyScoreModel.h
//  xinnongreniOS
//
//  Created by ZSC on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRMyScoreModel : NSObject
/**
 *  操作时间
 */
@property (nonatomic,strong) NSNumber *createTime;
/**
 *  +,-
 */
@property (copy,nonatomic) NSString *pointAction;
/**
 *  积分值
 */
@property (copy,nonatomic) NSNumber *pointNum;
/**
 *  用户ID
 */

@property (copy,nonatomic) NSString *userId;
/**
 *  我的总积分
 */
@property (copy,nonatomic) NSNumber *pointLaterTrade;

@end
