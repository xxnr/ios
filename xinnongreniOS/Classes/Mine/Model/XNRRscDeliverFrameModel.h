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

@property (nonatomic ,assign) CGRect imageViewF;
@property (nonatomic ,assign) CGRect nameLabelF;
@property (nonatomic ,assign) CGRect numberLabelF;
@property (nonatomic ,assign) CGRect attributeLabelF;
@property (nonatomic ,assign) CGRect addtionLabelF;
@property (nonatomic ,assign) CGRect LineF;

@property (nonatomic ,assign) CGFloat cellHeight;

@end
