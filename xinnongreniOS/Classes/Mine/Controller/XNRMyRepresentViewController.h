//
//  XNRMyRepresentViewController.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/13.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRMyRepresentViewController : UIViewController
@property (nonatomic,assign)BOOL fromMine;
@property (nonatomic,assign)BOOL bookfromMine;
@property (nonatomic,assign)BOOL isBroker;
+(void)SetisBroker:(BOOL)isbroker;
@end
