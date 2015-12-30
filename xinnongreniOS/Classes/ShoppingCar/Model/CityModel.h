//
//  CityModel.h
//  ZSC城市列表
//
//  Created by ZSC on 15/6/15.
//  Copyright (c) 2015年 ZSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

/**
 *  唯一id
 */
@property (nonatomic,copy) NSString *ID;
/**
 *  城市名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  首字母
 */
@property (nonatomic,copy) NSString *shortName;

@end
