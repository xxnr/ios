//
//  XNRCompanyAddressModel.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRCompanyAddressModel : NSObject
@property (nonatomic,strong)NSMutableDictionary *province;
@property (nonatomic,strong)NSMutableDictionary *town;
@property (nonatomic,strong)NSString *details;
@property (nonatomic,strong)NSMutableDictionary *county;
@property (nonatomic,strong)NSMutableDictionary *city;
@end
