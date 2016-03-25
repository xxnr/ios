//
//  XNRPayInfoModel.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRPayInfoModel : NSObject
@property (nonatomic,copy) NSString *dateCreated;
@property (nonatomic,copy) NSString *payId;
@property (nonatomic,assign) int payStatus;
@property (nonatomic,assign) int payType;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,assign) int slice;
@property (nonatomic,copy) NSString *suborderId;
@property (nonatomic,copy) NSString *datePaid;
@end
