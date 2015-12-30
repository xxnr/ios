
//
//  XNRTownModel.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/16.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRTownModel.h"

@implementation XNRTownModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //纠错赋值
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    
    
    
}

@end
