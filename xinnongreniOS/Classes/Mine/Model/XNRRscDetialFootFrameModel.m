//
//  XNRRscDetialFootFrameModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/5/3.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscDetialFootFrameModel.h"
#import "XNRRscOrderDetailModel.h"
#import "XNRRscOrderModel.h"
@implementation XNRRscDetialFootFrameModel

-(void)setModel:(XNRRscOrderDetailModel *)model
{
    _model = model;
    
    NSDictionary *dict = self.model.orderStatus;
    if ([dict[@"type"] integerValue] == 2 || [dict[@"type"] integerValue] == 4) {
        _footViewHeight =  PX_TO_PT(160);
        
    }else if ([dict[@"type"] integerValue] == 5 || [dict[@"type"] integerValue] == 6){
        for (XNRRscSkusModel *skuModel in self.model.SKUList) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                _footViewHeight =  PX_TO_PT(160);
                
            }else{
                _footViewHeight =  PX_TO_PT(80);
            }
        }
    }else{
        _footViewHeight =  PX_TO_PT(80);
    }

}

@end
