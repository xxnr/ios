//
//  XNRAddressManageView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/25.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRAddressManageViewBlock)(NSString *province,NSString *city,NSString *county,NSString *provinceID,NSString *cityId,NSString *countyId);

typedef enum : NSUInteger {
    leftBtnType,
    rightBtnType,
} XNRAddressManageViewType;

@protocol XNRAddressManageViewBtnDelegate <NSObject>
@optional;
-(void)XNRAddressManageViewBtnClick:(XNRAddressManageViewType)type;

@end
@interface XNRAddressManageView : UIView

@property (nonatomic, weak) UILabel *provinceLabel;

@property (nonatomic ,weak) UILabel *cityLabel;

@property (nonatomic, weak) UILabel *countyLabel;

@property (nonatomic ,assign) id<XNRAddressManageViewBtnDelegate>delegate;

-(void)showWith:(XNRAddressManageViewBlock)com;

-(void)hide;



@end
