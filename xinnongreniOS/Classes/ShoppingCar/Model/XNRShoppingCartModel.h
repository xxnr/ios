//
//  XNRShoppingCartModel.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRShoppingCartModel : NSObject


@property (nonatomic,copy) NSString *picUrl;         //图片
@property (nonatomic,copy) NSString *goodName;       //商品
@property (nonatomic,copy) NSString *presentPrice;   //现价格
@property (nonatomic,copy) NSString *productDesc;//商品描述
@property (nonatomic,copy) NSString *orderState;     //完成状态(0->已完成；1->待评价)
@property (nonatomic,copy) NSString *model;
/**
 *  类型名
 */
@property (nonatomic,copy) NSString *category;
/**
 *  单价
 */
@property (assign,nonatomic) float unitPrice;
/**
 *  购买可获得积分
 */
@property (copy,nonatomic) NSString *awardPoint;
/**
 *  图片url
 */
@property (copy,nonatomic) NSString *imgUrl;
/**
 *  积分抵用信息
 */
@property (copy,nonatomic) NSString *allowScore;
/**
 *  商品销售数
 */
@property (copy,nonatomic) NSString *goodsSellCount;
/**
 *  原价
 */
@property (copy,nonatomic) NSString *originalPrice;
/**
 *  品牌ID
 */
@property (copy,nonatomic) NSString *brandId;
/**
 *  商品赞数
 */
@property (copy,nonatomic) NSString *goodsGreatCount;
/**
 *  品牌名
 */
@property (copy,nonatomic) NSString *brandName;
/**
 *  商品ID
 */
@property (copy,nonatomic) NSString *goodsId;
/**
 *  商品排序
 */
@property (copy,nonatomic) NSString *goodsSort;
/**
 *  商品名
 */
@property (copy,nonatomic) NSString *goodsName;
/**
 *  预售
 */
@property(nonatomic, copy) NSString *presale;

//附加属性
@property (nonatomic,copy) NSString *num;                 //数量
@property (nonatomic,copy) NSString *timeStamp;           //时间戳(用于显示添加购物车时间)
@property (nonatomic,copy) NSString *shoppingCarCount;    //累加数(用于商品排序)
@property (nonatomic,copy) NSString *isMark;              //记录是否打分
@property (nonatomic,copy) NSString *myOrderType;
/**
 *  子订单状态
 */
@property (nonatomic,copy) NSNumber *orderSubType;

//购物车接口
/**
 *  可抵积分
 */
@property (copy,nonatomic) NSString *point;
/**
 *  商品数
 */
@property (copy,nonatomic) NSString *goodsCount;
/**
 *  订金
 */

@property (nonatomic, copy) NSString *deposit;

@property (nonatomic ,copy) NSString *price;

@property (nonatomic ,copy) NSString *brands;

@property (nonatomic ,copy )NSString *name;

@property (nonatomic, assign) BOOL selectState;

@property (nonatomic, assign, getter=ischecking) BOOL checking;


@end
