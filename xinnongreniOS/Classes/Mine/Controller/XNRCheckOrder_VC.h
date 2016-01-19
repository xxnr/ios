//
//  XNRCheckOrder_VC.h
//  xinnongreniOS
//
//  Created by marks on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XNRCheckOrder_VC : UIViewController
/**
 *  我的订单类型
 */
@property (nonatomic,copy) NSString *myOrderType;

@property (nonatomic,assign) BOOL isRoot;
@property(nonatomic,copy) NSString*orderID;
@property(nonatomic,copy) NSString*orderNO;

//@property (nonatomic, copy) NSString *recieveName;
//@property (nonatomic, copy) NSString *recievePhone;
//@property (nonatomic, copy) NSString *recieveAddress;


@end
