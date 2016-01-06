//
//  XNRShopCarSectionModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/1/6.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XNRShoppingCartModel;


@interface XNRShopCarSectionModel : NSObject

@property (nonatomic, strong) NSMutableArray *cellModelArray;

/**
 *  品牌名
 */
@property (copy,nonatomic) NSString *brandName;


@property (nonatomic ,assign) BOOL isSelected;
@end
