//
//  XNRUserInfoModel.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/16.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRUserInfoModel : NSObject

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic ,copy) NSString *nickname;

@property (nonatomic ,copy) NSString *name;


@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *userid;
/**
 *  代表的电话号码
 */
@property (nonatomic, copy) NSString *inviter;
/**
 *  代表昵称
 */
@property (nonatomic, copy) NSString *inviterNickname;

@property (nonatomic, copy) NSString *inviterPhoto;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *typeVerified;

@property (nonatomic ,copy) NSString *sex;

@property (nonatomic ,copy) NSString *userType;
@property (nonatomic ,copy) NSString *userTypeInName;

@property (nonatomic ,copy) NSString *province;
@property (nonatomic ,copy) NSString *city;
@property (nonatomic ,copy) NSString *county;
@property (nonatomic ,copy) NSString *town;

@property (nonatomic ,copy) NSString *townID;
/**
 *  正在审核为县级经销商
 */
@property (nonatomic ,copy) NSString *RSCInfoVerifing;
/**
 *  是否认证为县级经销商
 */
@property (nonatomic ,copy) NSString *isRSC;



@end


