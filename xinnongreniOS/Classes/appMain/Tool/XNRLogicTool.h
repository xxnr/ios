//
//  XNRLogicTool.h
//  xinnongreniOS
//
//  Created by xxnr on 16/8/4.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNRGetProductListParam.h"
#import "XNRShoppingCartModel.h"
#import "XNRBaseTool.h"

@interface XNRLogicTool : XNRBaseTool

+ (void)getProductListWithParam:(XNRGetProductListParam *)param success:(void (^)(XNRShoppingCartModel *result))success failure:(void (^)(NSError *error))failure;


@end
