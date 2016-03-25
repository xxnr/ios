//
//  XNRMyAllOrderFrame.h
//  xinnongreniOS
//
//  Created by xxnr on 16/3/23.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XNRMyOrderModel;

@interface XNRMyAllOrderFrame : NSObject

@property (nonatomic, strong) XNRMyOrderModel *orderModel;

@property (nonatomic ,assign ,readonly) CGRect picImageViewF;

@property (nonatomic ,assign ,readonly) CGRect productNameLabelF;

@property (nonatomic ,assign ,readonly) CGRect attributesLabelF;

@property (nonatomic ,assign ,readonly) CGRect productNumLabelF;

@property (nonatomic ,assign ,readonly) CGRect priceLabelF;

@property (nonatomic ,assign ,readonly) CGRect addtionLabelF;

@property (nonatomic ,assign ,readonly) CGRect addtionPriceLabelF;

@property (nonatomic ,assign ,readonly) CGRect sectionOneLabelF;

@property (nonatomic ,assign ,readonly) CGRect sectionTwoLabelF;

@property (nonatomic ,assign ,readonly) CGRect depositLabelF;

@property (nonatomic ,assign ,readonly) CGRect remainPriceLabelF;

@property (nonatomic ,assign ,readonly) CGRect totoalPriceLabelF;

@property (nonatomic ,assign ,readonly) CGRect goPayButtonF;

@property (nonatomic ,assign ,readonly) CGRect topLineF;
@property (nonatomic ,assign ,readonly) CGRect middleLineF;
@property (nonatomic ,assign ,readonly) CGRect bottomLineF;

// cell的高度
@property (nonatomic, assign) CGFloat cellHeight;


@end
