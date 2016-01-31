//
//  XNRAddressManageViewController.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRAddressManageModel.h"
@interface XNRAddressManageViewController : UIViewController
@property (nonatomic, strong) XNRAddressManageModel *addressModel;
@property(nonatomic,copy)void(^addressChoseBlock)(XNRAddressManageModel*model);
@end
