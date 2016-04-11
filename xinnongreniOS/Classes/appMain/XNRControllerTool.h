//
//  XNRControllerTool.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/10.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRControllerTool : NSObject
// 友盟
+(void)umengTrack:(NSDictionary *)launchOptions;

// 网络监听
+(void)monitorNetwork;

// bugTags
+(void)runBugtags;

/**
 *  选择根控制器
 */
+ (void)chooseRootViewController;




@end
