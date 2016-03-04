//
//  XNRSKUAttributesModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/2/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNRAddtionsModel.h"

/**
 *  分区模型 数据根据条件返回的数据类型 枚举
 */
typedef NS_OPTIONS(NSInteger, XNRSKUSecitonModelType) {
    XNRSKUModelAttributesType = 1,
    XNRSKUModelAddtionType = 1 << 1
};

@interface XNRSKUAttributesModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic ,copy) NSString *_id;

@property (nonatomic ,strong) NSMutableArray *values;

@property (nonatomic, assign) XNRSKUSecitonModelType modelSourceType;//分区模型数据来源类型

@end




@interface XNRSKUCellModel : NSObject

@property (nonatomic ,assign) BOOL isSelected;
@property (nonatomic ,assign) BOOL isEnable;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *value;
@property (nonatomic ,copy) NSString *cellValue;

@end