//
//  XNRSelectBuliding_VC.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRBuildingModel.h"
@interface XNRSelectBuliding_VC : UIViewController
@property(nonatomic,copy)void(^addressChoseBlock)(XNRBuildingModel*address);
@property(nonatomic,copy)NSString*BusinessId;
@end
