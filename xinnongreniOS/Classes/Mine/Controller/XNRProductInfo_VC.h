//
//  XNRProductInfo_VC.h
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.

#import <UIKit/UIKit.h>

@class XNRShoppingCartModel;
@interface XNRProductInfo_VC : UIViewController

@property(nonatomic,strong)XNRShoppingCartModel*model;

@property (nonatomic, assign) BOOL isFrom;

-(void)synchShoppingCarDataWith:(XNRShoppingCartModel *)model;

@end
