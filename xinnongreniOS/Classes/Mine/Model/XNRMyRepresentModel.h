//
//  XNRMyRepresentModel.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/15.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRMyRepresentModel : NSObject
/**
 *  账号
 */
@property (nonatomic, copy) NSString *account;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  
 */
@property (nonatomic, copy) NSString *photo;
/**
 *  姓名
 */
@property (nonatomic ,copy) NSString *name;

@property (nonatomic ,copy) NSString *userId;

@property (nonatomic ,assign) int newOrdersNumber;

@property (nonatomic,assign) BOOL sex;
@end
