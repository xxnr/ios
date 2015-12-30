//
//  BMProgressView.h
//  ibabyMap
//
//  Created by 柏杨 on 15/10/21.
//  Copyright © 2015年 柏杨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^errorBlock)();
@interface BMProgressView : UIView
@property(nonatomic,copy)errorBlock block;
+(BMProgressView *)showCoverWithTarget:(UIView *)target color:(UIColor *)bcColor isNavigation:(BOOL)isNavigation;
-(instancetype)initWithTarget:(UIView *)target color:(UIColor *)bcColor isNavigation:(BOOL)isNavigation;
+(BMProgressView *)showErrorViewWtihTarget:(UIView *)target;
+(BMProgressView *)showEmptyWithTarget:(UIView *)target;
-(void)LoadViewDisappear;
+(void)LoadViewDisappear;

+(void)showImage:(UIImageView*)avatarImageView;
@end
