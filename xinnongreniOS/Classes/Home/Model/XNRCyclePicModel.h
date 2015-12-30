//
//  XNRCyclePicModel.h
//  xinnongreniOS
//
//  Created by ZSC on 15/7/3.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRCyclePicModel : NSObject

/**
 *  轮播图ID
 */
@property (copy,nonatomic) NSString *ID;
/**
 *  轮播图url
 */
@property (copy,nonatomic) NSString *imgUrl;
/**
 *  点击链接
 */
@property (copy,nonatomic) NSString *url;

@end
