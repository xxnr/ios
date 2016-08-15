//
//  XNRHttpTool.m
//  xinnongreniOS
//
//  Created by xxnr on 16/8/4.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRHttpTool.h"
#import "AppDelegate.h"

@implementation XNRHttpTool
static int loginCount = 0;

/**
 *  一般的get请求
 *  @param url     传入的地址Url
 *  @param param   参数(可有可无)
 *  @param success 成功回调函数
 *  @param failure 失败回调函数
 */
+ (void)get:(NSString *)url
 parameters:(id)param
    success:(void (^)(id))success
    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    [dic setObject:[DataCenter account].token?[DataCenter account].token:@"" forKey:@"token"];
    [dic setObject:@"IOS-v2.0" forKey:@"user-agent"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //网络请求时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSLog(@"=========【get】上传数据：=========%@",[NSString stringWithFormat:@"%@",dic]);
    NSString *URL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:URL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---------返回数据:---------%@",str);
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        
        success(resultObj);
        if ([[resultObj objectForKey:@"code"] intValue] == 1401) {
            [UILabel showMessage:resultObj[@"message"]];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            XNRLoginViewController *vc = [[XNRLoginViewController alloc]init];
            vc.com = ^(){
                loginCount = 0;
            };
            vc.hidesBottomBarWhenPushed = YES;
            UIViewController *currentVc = [[AppDelegate shareAppDelegate] getTopViewController];
            NSLog(@"currentVc===%@",currentVc);
            if (loginCount<1) {
                [currentVc.navigationController pushViewController:vc animated:YES];
                loginCount++;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    
}
/**
 *  基本用来上传参数的post请求
 *
 *  @param url     传入的地址Url
 *  @param param   参数（required）
 *  @param success 成功回调函数
 *  @param failure 失败回调函数
 */
+ (void)post:(NSString *)url
  parameters:(id)param
     success:(void (^)(id))success
     failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    [dic setObject:[DataCenter account].token?[DataCenter account].token:@"" forKey:@"token"];
    [dic setObject:@"IOS-v2.0" forKey:@"user-agent"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSLog(@"=========上传数据：=========%@",[NSString stringWithFormat:@"%@",dic]);
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---------返回数据:---------%@",str);
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        
        success(resultObj);
        
        if ([[resultObj objectForKey:@"code"] intValue] == 1401) {
            [UILabel showMessage:resultObj[@"message"]];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            XNRLoginViewController *vc = [[XNRLoginViewController alloc]init];
            vc.com = ^(){
                loginCount = 0;
            };
            vc.hidesBottomBarWhenPushed = YES;
            UIViewController *currentVc = [[AppDelegate shareAppDelegate] getTopViewController];
            NSLog(@"currentVc===%@",currentVc);
            if (loginCount<1) {
                [currentVc.navigationController pushViewController:vc animated:YES];
                loginCount++;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
    }];
    
}


@end
