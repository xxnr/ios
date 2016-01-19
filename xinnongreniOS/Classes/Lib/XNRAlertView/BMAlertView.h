//
//  BMAlertView.h
//  ibabyMap
//
//  Created by 柏杨 on 15/10/13.
//  Copyright © 2015年 柏杨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BMCover;
typedef void (^ChooseBlock)(UIButton *btn);

@interface BMAlertView : UIView
@property(nonatomic,weak)BMCover *cover;
@property(nonatomic,copy)ChooseBlock chooseBlock;
-(void)BMAlertShow;
-(void)BmAlertDisappear;
-(instancetype)initTextAlertWithTitle:(NSString *)title content:(NSString *)content chooseBtns:(NSArray *)btns;
-(instancetype)initCustomAlertWithTitle:(NSString *)title view:(UIView *)customView chooseBtns:(NSArray *)btns;
@end
