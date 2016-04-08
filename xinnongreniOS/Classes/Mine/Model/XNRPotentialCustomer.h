//
//  XNRPotentialCustomer.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/7.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRPotentialCustomer : NSObject
@property (nonatomic,copy)NSString *_id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *remarks;
@property (nonatomic,strong)NSMutableArray *buyIntentions;
@property (nonatomic,strong)NSMutableDictionary *address;
@property (nonatomic,copy)NSString *sex;
@end
