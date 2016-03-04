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

@property (nonatomic, copy) NSString *_id;

@property (nonatomic ,copy) NSString *Desc;

@property (nonatomic, copy) NSString *presale;

@property (nonatomic, copy) NSString *min;

@property (nonatomic, copy) NSString *max;

@property (nonatomic ,strong) NSMutableArray *pictures;

@property (nonatomic ,strong) NSMutableArray *SKUAttributes;

@property (nonatomic ,strong) NSMutableArray *additions;

@property (nonatomic ,copy) NSString *market_price;

@property (nonatomic ,copy) NSString *platform_price;

//附加属性
@property (nonatomic,copy) NSString *num;                 //数量
@property (nonatomic,copy) NSString *timeStamp;           //时间戳(用于显示添加购物车时间)
@property (nonatomic,copy) NSString *shoppingCarCount;    //累加数(用于商品排序)




@end
