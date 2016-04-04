//
//  XNRMobuserName.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/11.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRMobuserNameControllerBlock)(NSString *userName);

@interface XNRMobuserName : UIViewController

@property (nonatomic, copy) XNRMobuserNameControllerBlock com;

@end
