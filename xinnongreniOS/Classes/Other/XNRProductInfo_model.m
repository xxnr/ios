//
//  XNRProductInfo_model.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/7.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRProductInfo_model.h"

@implementation XNRProductInfo_model

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    //纠错赋值
//    if ([key isEqualToString:@"id"]) {
//        self.ID = value;
//    }
    if ([key isEqualToString:@"description"]) {
        self.Desc = value;
    }
    
    
}

- (NSMutableArray *)pictures {
    if (!_pictures) {
        _pictures = [NSMutableArray array];
    }
    return _pictures;
}

- (NSMutableArray *)SKUAttributes {
    if (!_SKUAttributes) {
        _SKUAttributes = [NSMutableArray array];
    }
    return _SKUAttributes;
}

-(NSMutableArray *)additions
{
    if (!_additions) {
        _additions = [NSMutableArray array];
    }
    return _additions;

}





@end
