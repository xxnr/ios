//
//  XNRRscOrderDetialFrameModel.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XNRRscSkusModel;

@interface XNRRscOrderDetialFrameModel : NSObject

@property (nonatomic, strong) XNRRscSkusModel *model;

@property (nonatomic ,assign ,readonly) CGRect imageViewF;

@property (nonatomic ,assign ,readonly) CGRect goodsNameLabelF;

@property (nonatomic ,assign ,readonly) CGRect deliverStateLabelF;

@property (nonatomic ,assign ,readonly) CGRect goodsNumberLabelF;

@property (nonatomic ,assign ,readonly) CGRect attributesLabelF;

@property (nonatomic ,assign ,readonly) CGRect addtionsLabelF;

@property (nonatomic ,assign ,readonly) CGRect bottomLineF;

@property (nonatomic ,assign ,readonly) CGFloat cellHeight;


@end
