//
//  myAlertView.h
//  lumbar
//
//  Created by Ceres on 16/3/28.
//  Copyright © 2016年 www.upupapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class myAlertView;
@protocol LumAlertViewDelegate <NSObject>

// 这个alertView的协议方法,遵守协议调用下面的回调,在回调里调用dismissLumAleatView来移除alertView
- (void)alertView:(myAlertView *)lumAlertView
           Action:(NSInteger)index Dic:(NSDictionary *)dic;

@end

@interface myAlertView : UIView

@property (nonatomic,assign)id<LumAlertViewDelegate>delegate;

// 初始化方法,传一个标题和两个按钮名称,不需要标题就不传,改掉或者不用都行
-(instancetype)initWithHeadTitle:(NSString *)headtitile
                      LeftButton:(NSString *)leftTitile
                     RightButton:(NSString *)rightTitile
                         andDic:(NSDictionary *)dic;

- (void)show;
- (void)dismissLumAleatView;


@end
