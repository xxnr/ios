//
//  XNRMakeSureOrderInfo_VC.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/7.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNROrderInfoModel.h"
@interface XNRMakeSureOrderInfo_VC : UIViewController

@property (nonatomic,strong) XNROrderInfoModel *model;
/**
 *  订单编号
 */
@property (nonatomic,copy) NSString *orderNo;
/**
 *  收货人
 */
@property (nonatomic,copy) NSString *recipientName;
/**
 *  收货电话
 */
@property (nonatomic,copy) NSString *recipientPhone;

@property(nonatomic,copy)NSString*orderId;//已生成订单id
@property(nonatomic,copy)NSString*building;//地址
@property(nonatomic,copy)NSString*deliveryTime;//期望收货日期
@property(nonatomic,strong)NSMutableArray*dataArray;//保存订单数据
@property(nonatomic,strong)NSString*leaveMessage;//留言

@property(nonatomic, copy) NSString *paymentId;//支付id

@end
