//
//  XNRBookUser.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/31.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRBookUser : NSObject
@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *remarks;
@property (nonatomic,copy)NSNumber *isRegistered;
@property (nonatomic,copy)NSNumber *sex;
@end
