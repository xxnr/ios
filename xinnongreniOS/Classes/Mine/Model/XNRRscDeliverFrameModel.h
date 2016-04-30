//
//  XNRRscDeliverFrameModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/27.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XNRRscSkusModel;

@interface XNRRscDeliverFrameModel : NSObject

@property (nonatomic ,strong) XNRRscSkusModel *model;

@property (nonatomic ,assign ,readonly) CGRect imageViewF;

@property (nonatomic ,assign ,readonly) CGRect goodsNameLabelF;

@property (nonatomic ,assign ,readonly) CGRect goodsNumberLabelF;

@property (nonatomic ,assign ,readonly) CGRect attributesLabelF;

@property (nonatomic ,assign ,readonly) CGRect addtionsLabelF;

@property (nonatomic ,assign ,readonly) CGRect bottomLineF;

@property (nonatomic ,assign ,readonly) CGFloat cellHeight;


@end
