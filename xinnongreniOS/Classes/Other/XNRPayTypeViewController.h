//
//  XNRPayTypeViewController.h
//  xinnongreniOS

//  Created by ZSC on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XNRPayTypeViewController : UIViewController
@property (nonatomic,copy) NSString *fromType; //来自哪个界面
@property (nonatomic, copy) NSString *paymentId;
@property (nonatomic,copy) NSString *money;    //价钱
@property (nonatomic,copy) NSString *orderID;  //订单号
@property (nonatomic, copy) NSString *recieveName;
@property (nonatomic, copy) NSString *recievePhone;
@property (nonatomic, copy) NSString *recieveAddress;

@end
