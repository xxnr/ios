//
//  XNRProductInfo_frame.h
//  xinnongreniOS
//
//  Created by xxnr on 16/3/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XNRProductInfo_model;
@interface XNRProductInfo_frame : NSObject

@property (nonatomic, strong) XNRProductInfo_model *infoModel;
/** 图片 */
@property (nonatomic, assign, readonly) CGRect imageViewF;

/** 商品名 */
@property (nonatomic, assign, readonly) CGRect productNameLabelF;

/** 价格 */
@property (nonatomic, assign, readonly) CGRect priceLabelF;

/** 订金 */
@property (nonatomic, assign, readonly) CGRect depositLabelF;

/** 市场价 */
@property (nonatomic, assign, readonly) CGRect marketPriceLabelF;
/** 市场价的划线 */
@property (nonatomic, assign, readonly) CGRect marketPriceLineF;


/** 商品描述 */
@property (nonatomic, assign, readonly) CGRect introduceLabelF;

/** 商品属性 */
@property (nonatomic, assign, readonly) CGRect attributeLabelF;

/** 商品拖动 */
@property (nonatomic, assign, readonly) CGRect drawViewF;

/** 商品拖动 */
@property (nonatomic, assign, readonly) CGRect describtionViewF;




/** view的高度 */
@property (nonatomic, assign, readonly) CGFloat viewHeight;

@end
