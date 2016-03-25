//
//  XNRCheckOrderVC.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRCheckOrderVC : UIViewController
/**
 *  我的订单类型
 */
@property (nonatomic,copy) NSString *myOrderType;

@property (nonatomic,assign) BOOL isRoot;
@property(nonatomic,copy) NSString*orderID;
@property(nonatomic,copy) NSString*orderNO;


@end
