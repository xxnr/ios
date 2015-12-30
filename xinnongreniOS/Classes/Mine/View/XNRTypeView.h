//
//  XNRTypeView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/12.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XNRTypeViewBlock)(NSString *typeName,NSString *typeNum);

typedef enum : NSUInteger {
    leftBtnType,
    rightBtnType,
} XNRTypeViewType;

@protocol XNRTypeViewBtnDelegate <NSObject>
@optional;
-(void)XNRTypeViewBtnClick:(XNRTypeViewType)type;

@end

@interface XNRTypeView : UIView

@property (nonatomic ,weak) UILabel *typeLabel;

@property (nonatomic ,assign) id<XNRTypeViewBtnDelegate>delegate;

-(void)showWith:(XNRTypeViewBlock)com;
-(void)hide;

@end
