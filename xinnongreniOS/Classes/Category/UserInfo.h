//
//  UserInfo.h
//  qianxiheiOS
//
//  Created by ZSC on 15/5/19.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.


#import <Foundation/Foundation.h>
@class XNRShoppingCartModel;

@interface UserInfo : NSObject

/**
 *  登录账号
 */
@property (copy,nonatomic) NSString *loginName;
/**
 *  姓名(昵称)
 */
@property (copy,nonatomic) NSString *nickname;
/**
 *  会员账号
 */
@property (copy,nonatomic) NSString *no;
/**
 *  电话
 */
@property (copy,nonatomic) NSString *phone;
/**
 *  头像
 */
@property (copy,nonatomic) NSString *photo;
/**
 *  用户类型
 */
@property (copy,nonatomic) NSString *userType;
/**
 *  用户唯一标志
 */
@property (copy,nonatomic) NSString *userid;
/**
 *  性别
 */
@property (copy,nonatomic) NSString *sex;
/**
 *  用户所在地
 */
@property (copy,nonatomic) NSString *userAaddress;
/**
 *  用户默认送货地址
 */
@property (copy,nonatomic) NSString *address;

@property (nonatomic ,copy) NSString *province;
@property (nonatomic ,copy) NSString *city;
@property (nonatomic ,copy) NSString *county;
@property (nonatomic ,copy) NSString *town;

@property (nonatomic ,copy) NSString *cityID;
@property (nonatomic ,copy) NSString *countyID;
@property (nonatomic ,copy) NSString *provinceID;
@property (nonatomic ,copy) NSString *townID;


//附加属性
/**
 *  登录密码
 */
@property (copy,nonatomic) NSString *password;
/**
 *  登录状态(NO没登录,YES登录)
 */
@property (assign,nonatomic) BOOL loginState;
/**
 *  token
 */
@property (nonatomic,copy) NSString *token;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic ,copy) NSString *userName;

@property (nonatomic ,copy) NSString *ID;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *typeNum;

/**
 *  姓名
 */
@property (nonatomic ,copy) NSString *name;


@property (nonatomic ,copy) NSString *sexName;

@property (nonatomic ,copy) NSString *cartId;

@property (nonatomic ,copy) NSString *currentVersion;

@property (nonatomic,copy)NSString *isRSC;

@property (nonatomic,strong)NSMutableArray *verifiedTypes;


@end
