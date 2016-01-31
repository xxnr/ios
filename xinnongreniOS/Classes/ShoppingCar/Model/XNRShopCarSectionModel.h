//
//  XNRShopCarSectionModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/1/6.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNRShoppingCartModel.h"

@interface XNRShopCarSectionModel : NSObject
/**
 *  品牌名
 */
@property (copy,nonatomic) NSString *brandName;

@property (nonatomic, strong) NSMutableArray *goodsList;

@property (nonatomic ,assign) BOOL isSelected;

@property (nonatomic ,copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *unitPrice;

@property (nonatomic,copy) NSString *deposit;
@end
