//
//  XNRToolBar.h
//  xinnongreniOS
//
//  Created by xxnr on 16/1/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XNRToolBarBtnDelegate <NSObject>

@optional;

-(void)XNRToolBarBtnClick;

@end

@interface XNRToolBar : UIView

@property (nonatomic ,assign) id<XNRToolBarBtnDelegate>delegate;

@end
