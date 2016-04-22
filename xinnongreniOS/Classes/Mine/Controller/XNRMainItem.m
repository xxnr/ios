//
//  XNRMainItem.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/17.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRMainItem.h"

@implementation XNRMainItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    XNRMainItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithTitle:title icon:nil];
}


@end
