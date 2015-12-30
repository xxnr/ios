//
//  XNRferView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/27.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    XNRferView_DoTotalType,//push next vc
    XNRferView_DoPriceType,//pop a view
    XNRferView_DoSelectType,//dismiss self
} XNRferViewDoType;


@protocol XNRferViewAddBtnDelegate <NSObject>
@optional;
-(void)ferView:(XNRferViewDoType)type;

@end

@interface XNRferView : UIView

@property (nonatomic, assign) id<XNRferViewAddBtnDelegate>delegate;

@end
