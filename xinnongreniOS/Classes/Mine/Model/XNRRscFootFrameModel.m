//
//  XNRRscFootFrameModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/5/3.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscFootFrameModel.h"
#import "XNRRscOrderModel.h"

@implementation XNRRscFootFrameModel

-(void)setModel:(XNRRscOrderModel *)model
{
    _model = model;
    if ([self.model.type integerValue] == 2||[self.model.type integerValue] == 4) {
        _footViewHeight = PX_TO_PT(196);
    }else if ([self.model.type integerValue] == 5||[self.model.type integerValue] == 6){
        for (XNRRscSkusModel *skuModel in self.model.SKUs) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                _footViewHeight = PX_TO_PT(196);
            }else{
                _footViewHeight = PX_TO_PT(108);
            }
        }
    }else {
        _footViewHeight = PX_TO_PT(108);
    }

}

@end
