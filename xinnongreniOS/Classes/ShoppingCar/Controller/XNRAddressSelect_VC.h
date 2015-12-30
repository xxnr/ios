//
//  XNRAddressSelect_VC.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
///**

#import <UIKit/UIKit.h>
#import "CityModel.h"
#import "XNRAddressManageModel.h"
@interface XNRAddressSelect_VC : UIViewController
@property(nonatomic,copy)NSString*from;
@property(nonatomic,retain)XNRAddressManageModel*model;
@property(nonatomic,copy)void(^addressRefreshBlock)(); //界面刷新

@end
