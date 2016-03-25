//
//  XRNSubOrdersModel.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XRNSubOrdersModel : NSObject
@property (nonatomic ,copy)NSString *id;//自订单ID
@property (nonatomic,copy) NSString *price;//自订单付款金额
@property (nonatomic,copy) NSString *type;//自订单类型
@property (nonatomic,copy)NSString *payStatus;//自订单付款状态
@property (nonatomic,assign)int paidCount;// 之前付款次数
@property (nonatomic,copy) NSString *paidPrice;//已付款金额
@property (nonatomic,assign)int payType;//付款方式
@property (nonatomic,strong)NSMutableArray *payments;//每次付款详情


@end
