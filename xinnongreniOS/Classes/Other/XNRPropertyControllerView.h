//
//  XNRPropertyControllerView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/3/9.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    XNRBuyType,
    XNRAddToCartType,
} XNRPropertyViewControllerType ;

typedef void(^XNRPropertyControllerViewValueBlock)(NSMutableArray *dataArray,CGFloat totalPrice);
typedef void(^XNRPropertyControllerViewBlock)(NSMutableArray *attributes,NSMutableArray *additions);


@protocol XNRPropertyControllerViewDelegate <NSObject>

@optional

-(void)XNRPropertyControllerViewAdmireBtnClick;

@end


@interface XNRPropertyControllerView : UIView

-(void)show:(XNRPropertyViewControllerType)type;

-(instancetype)initWithFrame:(CGRect)frame model:(XNRShoppingCartModel *)shopcarModel;

@property (nonatomic ,copy) XNRPropertyControllerViewBlock com;

@property (nonatomic ,copy) XNRPropertyControllerViewValueBlock valueBlock;


@property (nonatomic ,assign) id<XNRPropertyControllerViewDelegate>delegate;


@end
