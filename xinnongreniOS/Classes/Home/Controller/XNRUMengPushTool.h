//
//  XNRUMengPushTool.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRUMengPushTool : NSObject
/**
 *  友盟推送
 */

+(void)umengTrack:(NSDictionary *)launchOptions;

@end
