//
//  XNRMyRepresentView.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/14.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNRMyRepresentViewFrame;
@class XNRMyRepresentView;
@protocol XNRMyRepresentViewAddBtnDelegate <NSObject>
@optional;
- (void)myRepresentViewWith:(XNRMyRepresentView *)representView and:(NSString *)phoneNum;
@end

@interface XNRMyRepresentView : UIView

@property (nonatomic, strong) XNRMyRepresentViewFrame *viewF;

@property (nonatomic, assign) id<XNRMyRepresentViewAddBtnDelegate> delegate;

@end

@class XNRMyRepresentViewDataModel;
@interface XNRMyRepresentViewFrame : NSObject

@property (nonatomic, strong) XNRMyRepresentViewDataModel *model;

@property (nonatomic ,assign ,readonly) CGRect iconImageViewF;

@property (nonatomic, assign, readonly) CGRect noRepresentLabelF;

@property (nonatomic, assign, readonly) CGRect phoneTextF;

@property (nonatomic, assign, readonly) CGRect inputImageF;

@property (nonatomic, assign, readonly) CGRect addRepresentLabelF;

@property (nonatomic, assign, readonly) CGRect addRepresentBtnF;

@property (nonatomic, assign) CGFloat viewH;

@end


@interface XNRMyRepresentViewDataModel : NSObject

@property (nonatomic ,copy) NSString *iconImageViewData;

@property (nonatomic, copy) NSString *noRepresentLabelData;

@property (nonatomic, copy) NSString *phoneTextData;

@property (nonatomic, copy) NSString *inputImageData;

@property (nonatomic, copy) NSString *addRepresentLabelData;

@property (nonatomic, copy) NSString *addRepresentBtnData;

@end