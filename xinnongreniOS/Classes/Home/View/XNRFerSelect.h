//
//  XNRFerSelect.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/25.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XNRFerSelectAddBtnDelegate <NSObject>
@optional;
-(void)FerSelectWith;

@end

@interface XNRFerSelect : UIView

@property (nonatomic, assign) id<XNRFerSelectAddBtnDelegate>delegate;
@property (nonatomic, copy) void(^com)();

@end
