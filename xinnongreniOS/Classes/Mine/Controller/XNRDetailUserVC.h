//
//  XNRDetailUserVC.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRBookUser.h"
@interface XNRDetailUserVC : UIViewController
@property (nonatomic,copy)NSString *_id;
@property (nonatomic,strong)XNRBookUser *model;
@property (nonatomic,strong)void(^refreshListBlock)(BOOL isrefresh);
@end
