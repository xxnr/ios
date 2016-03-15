//
//  XNRSelectItemArrModel.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/15.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRSelectItemArrModel : NSObject

@property (nonatomic, strong) NSMutableArray* XNRSelectItemArr;
@property (nonatomic, strong) NSMutableDictionary* XNRSelectItemDict;

- (void)cancel;

+ (XNRSelectItemArrModel*)defaultModel;

@end
