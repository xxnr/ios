//
//  CommonTool.h
//  qianxiheiOS
//
//  Created by ZSC on 15/6/11.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"   //头像上传压缩图片
#import "AFNetworking.h"

@interface CommonTool : NSObject

/**
 *  上传头像
 *
 *  @param urlString 上传地址
 *  @param param     参数(常用字典)
 *  @param file      文件名(服务器规定的)
 *  @param picImage  图片
 *  @param success   成功回调
 *  @param failure   失败回调
 *
 *  @return 压缩后图片大小
 */
+ (NSString *)uploadPicUrl:(NSString *)urlString params:(id)param file:(NSString *)file picImage:(UIImage *)picImage success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

/**
 *  获取时间戳
 *
 *  @return 时间戳
 */
+ (NSString *)timeSp;

/**
 *  获取时间间隔(时间戳与当前时间间隔,如论坛发帖时间)
 *
 *  @param timeSp 时间戳
 *
 *  @return 时间
 */
+ (NSString *)timeInterval:(NSString *)timeSp;

/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
+ (NSString *)currentTime;

/**
 *  转换成标准时间
 *  @param numTime 请求获取时间number型
 *  @return 标准时间
 */
+ (NSString *)standardTime:(NSNumber *)numTime;

/**
 *  是否签到
 *
 *  @return yes为已签到
 */
+ (BOOL)isSignIn;
/**
 *  本地保存签到状态(当前日期与本地日期一致则不能签到)
 */
+ (void)saveSignIn;

/**
 *  创建数据模型字段
 *
 *  @param dict      字典
 *  @param className 类名
 */
+(void)createModelFromDictionary:(NSDictionary *)dict className:(NSString *)className;
/**
 *  检查长度
 *
 *  @param text      文本
 *  @param minLength 最小长度
 *  @param maxLength 最大长度
 *
 *  @return yes为符合no为不符合
 */
+(BOOL)checkLengthWithString:(NSString *)text andMinLength:(NSInteger)minLength andMaxLength:(NSInteger)maxLength;

//共享实例
+ (id)sharedInstance;
/**
 *  提示去登录
 *
 *  @param controller 空
 */
- (void)openLogin:(UIViewController *)controller;

@end
