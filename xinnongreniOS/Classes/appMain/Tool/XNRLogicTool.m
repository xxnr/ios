//
//  XNRLogicTool.m
//  xinnongreniOS
//
//  Created by xxnr on 16/8/4.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRLogicTool.h"

@implementation XNRLogicTool

+ (void)getProductListWithParam:(XNRGetProductListParam *)param success:(void (^)(XNRShoppingCartModel *))success failure:(void (^)(NSError *error))failure{

    [self getWithUrl:KHomeGetProductsListPage param:param resultClass:[XNRShoppingCartModel class] success:success failure:failure];


}

@end
