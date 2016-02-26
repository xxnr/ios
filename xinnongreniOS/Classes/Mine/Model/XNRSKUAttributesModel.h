//
//  XNRSKUAttributesModel.h
//  xinnongreniOS
//
//  Created by xxnr on 16/2/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRSKUAttributesModel : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) NSString *name;

@property (nonatomic ,copy) NSString *_id;

@property (nonatomic ,strong) NSMutableArray *values;



@end
