//
//  XNRRscSectionFootView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/25.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRRscOrderModel.h"

@class XNRRscFootFrameModel;

typedef void(^XNRRscSectionFootViewBlock)();

@interface XNRRscSectionFootView : UIView

-(void)upDataFootViewWithModel:(XNRRscFootFrameModel *)frameModel;

@property (nonatomic, copy) XNRRscSectionFootViewBlock com;

//@property (nonatomic, strong) XNRRscSectionFootFrameModel *frameModel;


@end
