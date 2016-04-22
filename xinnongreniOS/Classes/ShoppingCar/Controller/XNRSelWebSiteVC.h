//
//  XNRSelWebSiteVC.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRRSCModel.h"
@interface XNRSelWebSiteVC : UIViewController
@property (nonatomic,strong)NSString *proId;
@property(nonatomic,copy)void(^RSCDetailChoseBlock)(XNRRSCModel*model);

@end
