//
//  XNRAddress.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/7.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRAddress : NSObject
@property (nonatomic,strong)NSMutableDictionary *province;
@property (nonatomic,strong)NSMutableDictionary *city;
@property (nonatomic,strong)NSMutableDictionary *county;
@property (nonatomic,strong)NSMutableDictionary *town;
@end
