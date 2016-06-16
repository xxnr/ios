//
//  XNRShoppingCarFrame.h
//  xinnongreniOS
//
//  Created by xxnr on 16/3/20.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XNRShoppingCartModel;

@interface XNRShoppingCarFrame : NSObject
/**
 *  购物车数据
 */
@property (nonatomic, strong) XNRShoppingCartModel *shoppingCarModel;

/**
 *  子控件的frame数据
 */
@property (nonatomic ,assign ,readonly) CGRect selectedBtnF;
@property (nonatomic ,assign ,readonly) CGRect picImageViewF;
@property (nonatomic ,assign ,readonly) CGRect goodNameLabelF;
@property (nonatomic ,assign ,readonly) CGRect attributesLabelF;
@property (nonatomic ,assign ,readonly) CGRect PriceLabelF;
@property (nonatomic ,assign ,readonly) CGRect numTextFieldF;
@property (nonatomic ,assign ,readonly) CGRect leftBtnF;
@property (nonatomic ,assign ,readonly) CGRect rightBtnF;
@property (nonatomic ,assign ,readonly) CGRect addtionsLabelF;
@property (nonatomic ,assign ,readonly) CGRect addtionPriceLabelF;
@property (nonatomic ,assign ,readonly) CGRect sectionOneLabelF;
@property (nonatomic ,assign ,readonly) CGRect sectionTwoLabelF;
@property (nonatomic ,assign ,readonly) CGRect depositeLabelF;
@property (nonatomic ,assign ,readonly) CGRect finalPaymentLabelF;

@property (nonatomic ,assign ,readonly) CGRect topLineF;
@property (nonatomic ,assign ,readonly) CGRect middleLineF;
@property (nonatomic ,assign ,readonly) CGRect bottomLineF;

@property (nonatomic ,assign ,readonly) CGRect pushBtnF;

@property (nonatomic ,assign ,readonly) CGRect onlineLabelF;


@property (nonatomic ,assign ,readonly) CGRect textTopLineF;
@property (nonatomic ,assign ,readonly) CGRect textbottomLineF;
@property (nonatomic ,assign ,readonly) CGRect cancelBtnF;


// cell的高度
@property (nonatomic, assign) CGFloat cellHeight;


@end
