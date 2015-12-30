//
//  XNRCityList_VC.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/8.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRCityList_VC : UIViewController
@property(nonatomic,copy)void(^cityChoseBlock)(NSString*city);
@end
