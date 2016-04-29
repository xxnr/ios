//
//  XNRRscSectionFootView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/25.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRRscOrderModel.h"
@class XNRRscSectionFootFrameModel;

typedef void(^XNRRscSectionFootViewBlock)();

@interface XNRRscSectionFootView : UIView

-(void)upDataHeadViewWithModel:(XNRRscOrderModel *)model;

@property (nonatomic, copy) XNRRscSectionFootViewBlock com;

@property (nonatomic, strong) XNRRscSectionFootFrameModel *frameModel;


@end
