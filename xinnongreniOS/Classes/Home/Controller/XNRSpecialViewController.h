//
//  XNRSpecialViewController.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/12.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRShoppingCartModel;
#import "XNRHomeSelectBrandView.h"

@interface XNRSpecialViewController : UIViewController

@property (nonatomic,copy) NSString *tempTitle;

@property (nonatomic, copy) NSString *classId;

@property (nonatomic, strong) XNRShoppingCartModel *model;

@property (nonatomic ,assign) XNRType type;


@end
