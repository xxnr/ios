//
//  XNRTownPickerView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/16.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRTownPickerViewBlock)(NSString *townName,NSString *townId);

typedef enum : NSUInteger {
    eLeftBtnType,
    eRightBtnType,
} XNRTownPickerViewType;

@protocol XNRTownPickerViewBtnDelegate <NSObject>
@optional;
-(void)XNRTownPickerViewBtnClick:(XNRTownPickerViewType)type;

@end


@interface XNRTownPickerView : UIView

@property (nonatomic ,weak) UILabel *townLabel;

@property (nonatomic ,assign) id<XNRTownPickerViewBtnDelegate>delegate;

-(void)showWith:(XNRTownPickerViewBlock)com;
-(void)hide;



@end
