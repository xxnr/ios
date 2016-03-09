//
//  XNRPayType_VC.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRPayType_VC : UIViewController
@property (nonatomic,copy) NSString *fromType; //来自哪个界面
@property (nonatomic, copy) NSString *paymentId;
@property (nonatomic,copy) NSString *payMoney;    //价钱
@property (nonatomic,copy) NSString *orderID;  //订单号
@property (nonatomic, copy) NSString *recieveName;
@property (nonatomic, copy) NSString *recievePhone;
@property (nonatomic, copy) NSString *recieveAddress;

@end
