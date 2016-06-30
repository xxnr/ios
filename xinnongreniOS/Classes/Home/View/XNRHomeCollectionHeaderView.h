//
//  XNRHomeCollectionHeaderView.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/27.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SDCycleScrollView.h"
#import "XNRSignInView.h"
#import "XNRFerSelect.h"

@protocol  XNRHomeCollectionHeaderViewAddBtnDelegate <NSObject>

@optional
-(void)HomeCollectionHeaderViewWith:(UIButton *)button;
@end

@interface XNRHomeCollectionHeaderView : UICollectionReusableView

//轮播
@property (nonatomic, copy) void(^scrBlock)(NSInteger index);
@property(nonatomic ,assign) id delegate;
@property (nonatomic, copy) void(^com)();


//@property (nonatomic, assign) id<XNRHomeCollectionHeaderViewAddBtnDelegate>delegate;

- (void)createCycleScrollViewWith:(NSArray *)imagesURL;


@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *ferBtn;
@property (nonatomic, weak) UIButton *carBtn;
@property (nonatomic, weak) XNRFerSelect *ferSelectView;
@end
