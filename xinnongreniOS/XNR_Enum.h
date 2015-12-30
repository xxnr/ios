//
//  XNR_Enum.h
//  xinnongreniOS
//
//  Created by marks on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#ifndef xinnongreniOS_XNR_Enum_h
#define xinnongreniOS_XNR_Enum_h

//科目类型
typedef enum{
    kOrderPay     = 1,//待付款
    kOrderSend    = 2,//待发货
    kOrderRecieve = 3,//待收货
    kOrderComment = 4,//待评论
    kOrderSever   = 5 //售后
}orderType;

#endif
