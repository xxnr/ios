//
//  XNRCountyModel.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/14.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRCountyModel.h"

@implementation XNRCountyModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //纠错赋值
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }



}
@end
