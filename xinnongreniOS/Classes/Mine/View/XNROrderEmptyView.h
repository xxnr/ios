//
//  XNROrderEmptyView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/1/17.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    XNROrderEmptyView_buyFer,
    XNROrderEmptyView_buyCar,
} XNROrderEmptyViewbuySort;

@protocol XNROrderEmptyViewBtnDelegate <NSObject>

@optional;
-(void)XNROrderEmptyView:(XNROrderEmptyViewbuySort) type;

@end

@interface XNROrderEmptyView : UIView

@property (nonatomic ,assign) id<XNROrderEmptyViewBtnDelegate>delegate;

-(void)show;

@end
