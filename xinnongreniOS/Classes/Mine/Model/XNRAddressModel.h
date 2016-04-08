//
//  XNRAddressModel.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/7.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRAddressModel : NSObject
@property (nonatomic,strong)NSDictionary *province;
@property (nonatomic,strong)NSDictionary *city;
@property (nonatomic,strong)NSDictionary *county;
@property (nonatomic,strong)NSDictionary *town;

@end
