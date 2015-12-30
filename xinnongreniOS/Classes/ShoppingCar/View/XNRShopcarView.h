//
//  XNRShopcarView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/4.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XNRShopcarView_buyFer,
    XNRShopcarView_buyCar,
} XNRShopcarViewbuySort;

@protocol XNRShopcarViewBtnDelegate <NSObject>
@optional;

-(void)ShopcarViewWith:(XNRShopcarViewbuySort) type;

@end

@interface XNRShopcarView : UIView

@property (nonatomic, assign) id<XNRShopcarViewBtnDelegate>delegate;

- (void)show;
@end
