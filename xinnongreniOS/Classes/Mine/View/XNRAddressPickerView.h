//
//  XNRAddressPickerView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/14.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRAddressPickerViewBlock)(NSString *province,NSString *city,NSString *county,NSString *provinceID,NSString *cityId,NSString *countyId,NSString *province_id,NSString *city_id,NSString *county_id);

typedef enum : NSUInteger {
    leftBtnType,
    rightBtnType,
} XNRAddressPickerViewType;

@protocol XNRAddressPickerViewBtnDelegate <NSObject>
@optional;
-(void)XNRAddressPickerViewBtnClick:(XNRAddressPickerViewType)type;
@end
@interface XNRAddressPickerView : UIView

@property (nonatomic ,copy) XNRAddressPickerViewBlock com;


@property (nonatomic ,assign) id<XNRAddressPickerViewBtnDelegate>delegate;

-(void)show;

-(void)hide;


@end
