//
//  XNRCustomer.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRCustomer : NSObject
@property(nonatomic,copy)NSString *_id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *remarks;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,strong)NSArray *buyIntentions;
@end
