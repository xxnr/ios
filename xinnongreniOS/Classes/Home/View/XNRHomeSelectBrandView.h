//
//  XNRHomeSelectBrandView.h
//  UIColectionView
//
//  Created by 董富强 on 15/12/9.
//  Copyright © 2015年 董富强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    eXNRCarType,
    eXNRFerType,
} XNRType;

typedef void(^brandViewBlock)(NSString *param1,NSString *param2,NSArray *selectedParams);

@interface XNRHomeSelectBrandView : UIView

+ (void)showSelectedBrandViewWith:(brandViewBlock)com andTarget:(UIView *)target andType:(XNRType)type andParam:(NSArray *)param;

+(void)cancelSelectedBrandView;


@end
