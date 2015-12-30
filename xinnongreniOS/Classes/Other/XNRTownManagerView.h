//
//  XNRTownManagerView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/25.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XNRTownManagerViewBlock)(NSString *townName,NSString *townId);

typedef enum : NSUInteger {
    eLeftBtnType,
    eRightBtnType,
} XNRTownManagerViewType;

@protocol XNRTownManagerViewBtnDelegate <NSObject>
@optional;
-(void)XNRTownManagerViewBtnClick:(XNRTownManagerViewType)type;

@end
@interface XNRTownManagerView : UIView

@property (nonatomic ,weak) UILabel *townLabel;

@property (nonatomic ,assign) id<XNRTownManagerViewBtnDelegate>delegate;

-(void)showWith:(XNRTownManagerViewBlock)com;
-(void)hide;


@end
