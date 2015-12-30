//
//  XNRSelectBusinessCircle_VC.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRSelectBusinessCircle_VC : UIViewController
@property(nonatomic,copy)void(^BusinessCircleChoseBlock)(NSString*BusinessCircle,NSString*BusinessID);
@property(nonatomic,copy)NSString*currentCity;
@end
