//
//  XNRMobAddress.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/11.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRUserInfoModel.h"

typedef void(^XNRMobAddressBlock)(NSString *address,NSString *street);


@interface XNRMobAddress : UIViewController

@property (nonatomic ,strong) XNRUserInfoModel *model;

@property (nonatomic ,copy) XNRMobAddressBlock com;


@end
