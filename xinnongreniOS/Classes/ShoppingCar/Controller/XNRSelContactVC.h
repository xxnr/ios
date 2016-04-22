//
//  XNRSelContactVC.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/20.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRConsigneeModel.h"
@interface XNRSelContactVC : UIViewController
@property (nonatomic,copy)void(^setRSCContactChoseBlock)(XNRConsigneeModel *model);
@property (nonatomic,strong)XNRConsigneeModel *model;
@end
