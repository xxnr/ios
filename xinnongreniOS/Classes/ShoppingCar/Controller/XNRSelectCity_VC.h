//
//  XNRSelectCity_VC.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
@interface XNRSelectCity_VC : UIViewController
@property(nonatomic,copy)void(^cityChoseBlock)(CityModel*model);
@end
