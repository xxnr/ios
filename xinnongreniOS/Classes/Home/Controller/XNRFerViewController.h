//
//  XNRFerViewController.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/28.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRShoppingCartModel;
#import "XNRHomeSelectBrandView.h"

@interface XNRFerViewController : UIViewController

@property (nonatomic,copy) NSString *tempTitle;

@property (nonatomic, copy) NSString *classId;

@property (nonatomic, strong) XNRShoppingCartModel *model;

@property (nonatomic ,assign) XNRType type;



@end
