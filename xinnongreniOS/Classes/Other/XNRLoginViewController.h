//
//  XNRLoginViewController.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XNRLoginViewController : UIViewController

//@property (nonatomic,copy) NSString*loginFrom;
@property (nonatomic, copy) void(^com)();
@property (nonatomic,assign) BOOL loginFrom;
@property (nonatomic,copy) NSString *loginName;
@property (nonatomic, assign) BOOL loginFromProductInfo;

@property (nonatomic, copy) NSString *userNumber;

@end
