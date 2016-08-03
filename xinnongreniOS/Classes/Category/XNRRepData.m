//
//  XNRRepData.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/8/2.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRepData.h"
#import "FMDB.h"
@implementation XNRRepData
+(NSString *)createDB
{
    
    NSArray *dics = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [dics lastObject];

    NSString *dbPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[DataCenter account].userid]];
    
   NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"sameUserId"];
    
    if (![[DataCenter account].userid isEqualToString: userid]) {
        
        dbPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[DataCenter account].userid]];
        
    [[NSUserDefaults standardUserDefaults]setValue:[DataCenter account].userid forKey:@"sameUserId"];

    }
    
    return dbPath;
}

//+(void)createCustomerTable:(FMDatabase *)db
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        //创建数据库表
//        if(![db executeUpdate:@"create table if not exists myCustomerTable(sex bool,red int,name text,phone text)"])
//        {
//            NSLog(@"表创建失败");
//        }
//    });
//}
//
//+(void)createReprentTable:(FMDatabase *)db
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        //创建数据库表
//        if(![db executeUpdate:@"create table if not exists registerCustomerTable(sex int,name text,register int)"])
//        {
//            NSLog(@"表创建失败");
//        }
//    });
//}
@end
