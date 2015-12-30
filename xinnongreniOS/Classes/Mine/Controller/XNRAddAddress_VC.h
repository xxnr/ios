//
//  XNRAddAddress_VC.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/24.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRAddressManageModel.h"
@interface XNRAddAddress_VC : UIViewController

@property(nonatomic,copy) NSString *titleLabel;
@property(nonatomic,retain)XNRAddressManageModel*model;
@property(nonatomic,copy)void(^addressRefreshBlock)(); //界面刷新

@end
