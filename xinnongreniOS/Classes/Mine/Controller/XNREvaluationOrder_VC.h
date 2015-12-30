//
//  XNREvaluationOrder_VC.h
//  xinnongreniOS
//
//  Created by marks on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRCheckOrderModel.h"
@interface XNREvaluationOrder_VC : UIViewController
@property(nonatomic,strong)XNRCheckOrderModel*model;
@property(nonatomic,strong)NSString *orderNO;
@property (nonatomic, copy) NSString *orderId;
@end
