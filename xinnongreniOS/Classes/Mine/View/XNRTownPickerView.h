//
//  XNRTownPickerView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/16.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRTownPickerViewBlock)(NSString *townName,NSString *townId,NSString *town_id);

typedef enum : NSUInteger {
    eLeftBtnType,
    eRightBtnType,
} XNRTownPickerViewType;

@protocol XNRTownPickerViewBtnDelegate <NSObject>
@optional;
-(void)XNRTownPickerViewBtnClick:(XNRTownPickerViewType)type;

@end

@interface XNRTownPickerView : UIView

@property (nonatomic ,assign) id<XNRTownPickerViewBtnDelegate>delegate;

@property (nonatomic ,copy) XNRTownPickerViewBlock com;

-(void)show;
-(void)hide;



@end
