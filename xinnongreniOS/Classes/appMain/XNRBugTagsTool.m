//
//  XNRBugTagsTool.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRBugTagsTool.h"
#import <Bugtags/Bugtags.h>

@implementation XNRBugTagsTool

+(void)openBugTags
{
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingCrashes = YES;        // 是否收集闪退，联机 Debug 状态下默认 NO，其它情况默认 YES
    options.trackingUserSteps = YES;      // 是否跟踪用户操作步骤，默认 YES
    options.trackingConsoleLog = YES;     // 是否收集控制台日志，默认 YES
    options.trackingUserLocation = YES;   // 是否获取位置，默认 YES
    options.trackingNetwork = YES;        // 是否跟踪网络请求，默认 NO
    [Bugtags startWithAppKey:@"a059d969fd904e985d25a480b071f8cf" invocationEvent:BTGInvocationEventBubble options:options];
    [Bugtags startWithAppKey:@"a059d969fd904e985d25a480b071f8cf" invocationEvent:BTGInvocationEventBubble];
}

@end
