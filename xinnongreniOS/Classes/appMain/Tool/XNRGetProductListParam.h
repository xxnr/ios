//
//  XNRGetProductListParam.h
//  xinnongreniOS
//
//  Created by xxnr on 16/8/4.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNRBaseParam.h"

@interface XNRGetProductListParam : XNRBaseParam
/**
 *  分类名称 或 分类ID（如 化肥、汽车等）
 */
@property (nonatomic, copy) NSString *classId;
/*
 *品牌id，从获取的品牌列表中读取.可多选，用英文逗号分隔"江淮,中化"
 */
@property (nonatomic, copy) NSString *brand;
/**
 *  排序方法 price-desc 价格倒序 price-asc 价格正序
 */
@property (nonatomic, copy) NSString *sort;
/**
 *  价格区间（英文逗号分隔） minprice,maxprice（如：“100,200”）
 */
@property (nonatomic, copy) NSString *reservePrice;
/**
 *  页码
 */
@property (nonatomic, assign) int page;
/**
 *  每页返回数
 */
@property (nonatomic, assign) int rowCount;

@end
