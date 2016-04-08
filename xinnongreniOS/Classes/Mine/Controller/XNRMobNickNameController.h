//
//  XNRMobNickNameController.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/10.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XNRMobNickNameControllerBlock)(NSString *nickName);


@interface XNRMobNickNameController : UIViewController


@property (nonatomic, copy) XNRMobNickNameControllerBlock com;

@end
