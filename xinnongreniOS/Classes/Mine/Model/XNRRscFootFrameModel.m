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
        [self createHaveButtonView];
    }else if ([self.model.type integerValue] == 5||[self.model.type integerValue] == 6){
        [self createNoButtonView];
        for (XNRRscSkusModel *skuModel in self.model.SKUs) {
            if ([skuModel.deliverStatus integerValue] == 4) {
                [self createHaveButtonView];
            }
        }
    }else {
        [self createNoButtonView];
    }
    _footViewHeight = CGRectGetMaxY(_footViewF);

}
-(void)createHaveButtonView
{
    CGFloat footViewX = 0;
    CGFloat footViewY = 0;
    CGFloat footViewW = ScreenWidth;
    CGFloat footViewH = PX_TO_PT(196);
    _footViewF = CGRectMake(footViewX, footViewY, footViewW, footViewH);
    
    CGFloat deliverStyleLabelX = PX_TO_PT(30);
    CGFloat deliverStyleLabelY = PX_TO_PT(0);
    CGFloat deliverStyleLabelW = ScreenWidth/2;
    CGFloat deliverStyleLabelH = PX_TO_PT(88);
    _deliverStyleLabelF = CGRectMake(deliverStyleLabelX, deliverStyleLabelY, deliverStyleLabelW, deliverStyleLabelH);

    CGFloat totalPriceLabelX = ScreenWidth/2;
    CGFloat totalPriceLabelY = PX_TO_PT(0);
    CGFloat totalPriceLabelW = ScreenWidth/2-PX_TO_PT(30);
    CGFloat totalPriceLabelH = PX_TO_PT(88);
    _totalPriceLabelF = CGRectMake(totalPriceLabelX, totalPriceLabelY, totalPriceLabelW, totalPriceLabelH);
    
    CGFloat middleLineViewX = 0;
    CGFloat middleLineViewY = PX_TO_PT(88);
    CGFloat middleLineViewW = ScreenWidth;
    CGFloat middleLineViewH;
    if (IS_FourInch) {
        middleLineViewH = PX_TO_PT(2);
    }else{
        middleLineViewH = PX_TO_PT(1);
    }
    _middleLineViewF = CGRectMake(middleLineViewX, middleLineViewY, middleLineViewW, middleLineViewH);
    
    CGFloat footButtonX = ScreenWidth-PX_TO_PT(170);
    CGFloat footButtonY = CGRectGetMaxY(_middleLineViewF)+PX_TO_PT(14);
    CGFloat footButtonW = PX_TO_PT(140);
    CGFloat footButtonH = PX_TO_PT(60);
    _footButtonF = CGRectMake(footButtonX, footButtonY, footButtonW, footButtonH);
    
    CGFloat marginViewX = 0;
    CGFloat marginViewY = PX_TO_PT(176);
    CGFloat marginViewW = ScreenWidth;
    CGFloat marginViewH = PX_TO_PT(20);
    _marginViewF = CGRectMake(marginViewX, marginViewY, marginViewW, marginViewH);
    
    CGFloat bottomLineViewX = 0;
    CGFloat bottomLineViewY = PX_TO_PT(176);
    CGFloat bottomLineViewW = ScreenWidth;
    CGFloat bottomLineViewH;
    if (IS_FourInch) {
        bottomLineViewH = PX_TO_PT(2);
    }else{
        bottomLineViewH = PX_TO_PT(1);
    }
    _bottomLineViewF = CGRectMake(bottomLineViewX, bottomLineViewY, bottomLineViewW, bottomLineViewH);

}

-(void)createNoButtonView
{
    CGFloat footViewX = 0;
    CGFloat footViewY = 0;
    CGFloat footViewW = ScreenWidth;
    CGFloat footViewH = PX_TO_PT(108);
    _footViewF = CGRectMake(footViewX, footViewY, footViewW, footViewH);
    
    CGFloat deliverStyleLabelX = PX_TO_PT(30);
    CGFloat deliverStyleLabelY = PX_TO_PT(0);
    CGFloat deliverStyleLabelW = ScreenWidth/2;
    CGFloat deliverStyleLabelH = PX_TO_PT(88);
    _deliverStyleLabelF = CGRectMake(deliverStyleLabelX, deliverStyleLabelY, deliverStyleLabelW, deliverStyleLabelH);
    
    
    CGFloat totalPriceLabelX = ScreenWidth/2;
    CGFloat totalPriceLabelY = PX_TO_PT(0);
    CGFloat totalPriceLabelW = ScreenWidth/2-PX_TO_PT(30);
    CGFloat totalPriceLabelH = PX_TO_PT(88);
    _totalPriceLabelF = CGRectMake(totalPriceLabelX, totalPriceLabelY, totalPriceLabelW, totalPriceLabelH);
    
    CGFloat middleLineViewX = 0;
    CGFloat middleLineViewY = PX_TO_PT(88);
    CGFloat middleLineViewW = ScreenWidth;
    CGFloat middleLineViewH = PX_TO_PT(1);
    _middleLineViewF = CGRectMake(middleLineViewX, middleLineViewY, middleLineViewW, middleLineViewH);

    CGFloat marginViewX = 0;
    CGFloat marginViewY = PX_TO_PT(88);
    CGFloat marginViewW = ScreenWidth;
    CGFloat marginViewH = PX_TO_PT(20);
    _marginViewF = CGRectMake(marginViewX, marginViewY, marginViewW, marginViewH);

}






@end
