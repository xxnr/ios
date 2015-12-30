//
//  XNRAddressPickerView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/14.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRAddressPickerViewBlock)(NSString *province,NSString *city,NSString *county,NSString *provinceID,NSString *cityId,NSString *countyId);

typedef enum : NSUInteger {
    leftBtnType,
    rightBtnType,
} XNRAddressPickerViewType;

@protocol XNRAddressPickerViewBtnDelegate <NSObject>
@optional;
-(void)XNRAddressPickerViewBtnClick:(XNRAddressPickerViewType)type;
@end
@interface XNRAddressPickerView : UIView

@property (nonatomic, weak) UILabel *provinceLabel;

@property (nonatomic ,weak) UILabel *cityLabel;

@property (nonatomic, weak) UILabel *countyLabel;

@property (nonatomic ,assign) id<XNRAddressPickerViewBtnDelegate>delegate;

-(void)showWith:(XNRAddressPickerViewBlock)com;

-(void)hide;


@end
