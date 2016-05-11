//
//  CommonTool.m
//  qianxiheiOS
//
//  Created by ZSC on 15/6/11.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "CommonTool.h"
#import "XNRLoginViewController.h"
#import "XNRNavigationController.h"
@interface CommonTool ()<UIAlertViewDelegate>

@property (nonatomic,strong) UIViewController *controller;

@end

@implementation CommonTool

//=======================上传头像==================
+ (NSString *)uploadPicUrl:(NSString *)urlString params:(id)param file:(NSString *)file picImage:(UIImage *)picImage success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    NSData*image_data;
    
    if (UIImagePNGRepresentation(picImage) == nil) {
        image_data = UIImageJPEGRepresentation(picImage, 1.0);
    } else {
        image_data = UIImagePNGRepresentation(picImage);
    }
    image_data=[Photo scaleData:image_data toWidth:100 toHeight:100];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    [dic setObject:[DataCenter account].token?[DataCenter account].token:@"" forKey:@"token"];
    [dic setObject:@"IOS-v2.0" forKey:@"user-agent"];

    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:image_data name:file fileName:@"icon.png" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    
    //NSLog(@"url-->%@",urlString);
    NSString*image_path=[NSTemporaryDirectory() stringByAppendingString:@"tempPic.png"];
    //NSLog(@"image_path-->%@",image_path);
    [image_data writeToFile:image_path atomically:YES];
    
    NSFileManager*fileManager=[NSFileManager defaultManager];
    //获取某一指定文件的信息
    NSString *size = [NSString stringWithFormat:@"%.2fK",[[fileManager attributesOfItemAtPath:image_path error:nil] fileSize]/1024.0];
    ;
    
    return size;
}

//获取时间戳
+ (NSString *)timeSp
{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];
    return timeSp;
}

//获取时间间隔
+ (NSString *)timeInterval:(NSString *)timeSp
{
    if (timeSp.length == 13)//毫秒转化为秒
    {
        //截取前10位
        timeSp = [timeSp substringToIndex:10];
    }
    
    NSDate *datenow = [NSDate date];
    NSString *currentTimeSp = [NSString stringWithFormat:@"%d", (int)[datenow timeIntervalSince1970]];
    //2个时间戳之间的差值(当前减过去)
    NSTimeInterval timeInterval = currentTimeSp.integerValue - timeSp.integerValue;
    
    if (timeInterval < 60) {
        return @"1分钟内";
    } else if (timeInterval < 3600) {
        return [NSString stringWithFormat:@"%.f分钟前", timeInterval / 60];
    } else if (timeInterval < 86400) {
        return [NSString stringWithFormat:@"%.f小时前", timeInterval / 3600];
    } else if (timeInterval < 2592000) {//30天内
        return [NSString stringWithFormat:@"%.f天前", timeInterval / 86400];
    } else if (timeInterval < 31536000) {//30天至1年内
        double lastactivityInterval = timeSp.floatValue;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        //[formatter setDateFormat:@"MM月dd日 HH:mm"];
        [formatter setDateFormat:@"M月d日"];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
        NSString* dateString = [formatter stringFromDate:date];
        return dateString;
    } else {
        return [NSString stringWithFormat:@"%.f年前", timeInterval / 31536000];
    }
}

//获取当前时间
+ (NSString *)currentTime
{
    //<1>获取当前时间
    //细节: 获取的是国际标准时(与中国时间相差8小时)
    NSDate *date = [NSDate date];
    //<2>获取本地时间,格式化时间
    //NSDateFormatter功能是格式化时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //设置了时间的格式---格式由文档规定的
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:date];
}

//  将请求获取的时间改成标准时间
+ (NSString *)standardTime:(NSNumber *)numTime
{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *tmpTime = [numberFormatter stringFromNumber:numTime];
    
    if (tmpTime.length == 13)
    {
        tmpTime = [tmpTime substringToIndex:10];
    }
    double lastactivityInterval = [tmpTime floatValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


//===========================签到============================
//是否签到
+ (BOOL)isSignIn
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    //获取当前日期
    NSString *locationString=[dateformatter stringFromDate:senddate];
    return ![locationString isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"timeStr"]];
}
//本地保存签到状态(当前日期与本地日期一致则不能签到)
+ (void)saveSignIn
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    //获取当前日期
    NSString *locationString=[dateformatter stringFromDate:senddate];
    [[NSUserDefaults standardUserDefaults] setObject:locationString forKey:@"timeStr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  创建数据模型
 *
 *  @param dict      创建模型的依据字典
 *  @param className 模型名（可以设为空）
 */
+(void)createModelFromDictionary:(NSDictionary *)dict className:(NSString *)className
{
    //创建数据模型
    printf("@interface  %s : NSObject\n",className.UTF8String);
    for (NSString *key in dict)
    {
        printf("@property (copy,nonatomic) NSString *%s;\n",key.UTF8String);
    }
    printf("@end\n");
}

+(BOOL)checkLengthWithString:(NSString *)text andMinLength:(NSInteger)minLength andMaxLength:(NSInteger)maxLength
{
    if (text.length >= minLength && text.length <= maxLength) {
        return YES;
    }else{
        return NO;
    }
}

+ (id)sharedInstance
{
    //此种单例创建优点
    //1. 线程安全。
    //2. 满足静态分析器的要求。
    //3. 兼容了ARC
    static DataCenter *dataCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataCenter = [[self alloc]init];
    });
    return dataCenter;
}

- (void)openLogin:(UIViewController *)controller
{
    self.controller = controller;
    if (IS_Login) {
        NSLog(@"已登录");
    }else{
        NSLog(@"未登录");
        
        BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"您还没有登录，是否登录？" chooseBtns:@[@"取消",@"确定"]];
        alertView.chooseBlock = ^void(UIButton *btn){
            if (btn.tag == 11) {
            XNRLoginViewController *login = [[XNRLoginViewController alloc]init];
            login.hidesBottomBarWhenPushed = YES;
            [self.controller.navigationController pushViewController:login animated:YES];

            }
        };
        [alertView BMAlertShow];
    }
}


@end
