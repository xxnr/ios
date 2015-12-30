//
//  XNRProductInfo_model.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/7.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRProductInfo_model : NSObject
/**
 *  品牌
 */
@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *datecreated;

@property (nonatomic, assign) float deposit;

@property (nonatomic, copy) NSString *discountPrice;

@property (nonatomic, copy) NSString *engine;

@property (nonatomic, copy) NSString *gearbox;

@property (nonatomic, copy) NSString *imgUrl;
/**
 *  商品名称
 */

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *originalUrl;

@property (nonatomic ,copy) NSString *thumbnail;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *app_body_url;

@property (nonatomic, copy) NSString *app_standard_url;

@property (nonatomic, copy) NSString *app_support_url;

@property (nonatomic, copy) NSString *model;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic ,copy) NSString *Desc;

@property (nonatomic, copy) NSString *presale;



@end
