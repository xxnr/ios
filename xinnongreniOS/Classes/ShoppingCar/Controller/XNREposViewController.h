//
//  XNREposViewController.h
//  xinnongreniOS
//
//  Created by xxnr on 16/7/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRRSCDetailModel.h"
#import "XNRCompanyAddressModel.h"
@interface XNREposViewController : UIViewController

@property(nonatomic, copy) NSString *orderId;

@property(nonatomic, copy) NSString *price;

@property (nonatomic, strong) XNRRSCDetailModel *rscModel;

@property (nonatomic, assign) BOOL isfromOrderVC;

@end
