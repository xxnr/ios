//
//  XNRRscSectionFootFrameModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/28.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XNRRscOrderModel;

@interface XNRRscSectionFootFrameModel : NSObject

@property (nonatomic, strong) XNRRscOrderModel *model;

@property (nonatomic, assign, readonly) CGRect footViewF;

@property (nonatomic, assign, readonly) CGRect deliverStyleLabelF;

@property (nonatomic, assign, readonly) CGRect totalPriceLabelF;

@property (nonatomic, assign, readonly) CGRect footButtonF;

@property (nonatomic, assign, readonly) CGRect marginViewF;

@property (nonatomic, assign, readonly) CGRect middleLineViewF;
@property (nonatomic, assign, readonly) CGRect bottomLineViewF;


@property (nonatomic, assign, readonly) CGFloat viewHeight;


@end