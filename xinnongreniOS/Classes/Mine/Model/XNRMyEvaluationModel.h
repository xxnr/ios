//
//  XNRMyEvaluationModel.h
//  xinnongreniOS
//
//  Created by ZSC on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRMyEvaluationModel : NSObject
/**
 *  评价内容
 */
@property (nonatomic,copy) NSString *content;
/**
 *  商品名称
 */
@property (copy,nonatomic) NSString *goodsName;
/**
 *  commentID
 */
@property (copy,nonatomic) NSString *ID;
/**
 *  商品图片
 */
@property (copy,nonatomic) NSString *imgUrl;
/**
 *  goodsId
 */
@property (copy,nonatomic) NSString *goodsId;
@end
