//
//  XNRProductInfo_frame.m
//  xinnongreniOS
//
//  Created by xxnr on 16/3/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRProductInfo_frame.h"
#import "XNRProductInfo_model.h"

@implementation XNRProductInfo_frame

-(void)setInfoModel:(XNRProductInfo_model *)infoModel
{
    _infoModel = infoModel;
    
    // 图片
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    CGFloat imageViewW = ScreenWidth;
    CGFloat imageViewH = PX_TO_PT(700);
    _imageViewF = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);

    
    // 商品名
    CGFloat productNameLabelX = PX_TO_PT(30);
    CGFloat productNameLabelY = CGRectGetMaxY(_imageViewF)+PX_TO_PT(20);
    CGFloat productNameLabelW = ScreenWidth-PX_TO_PT(60);
    CGSize productNameLabelMaxSize = CGSizeMake(productNameLabelW, MAXFLOAT);
    CGSize productNameLabelSize = [self.infoModel.name sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(38)] maxSize:productNameLabelMaxSize];
    _productNameLabelF = (CGRect){{productNameLabelX, productNameLabelY}, productNameLabelSize};
    
    
    // 价格
    CGFloat priceLabelX = PX_TO_PT(30);
    CGFloat priceLabelY = CGRectGetMaxY(_productNameLabelF)+PX_TO_PT(28);
    CGFloat priceLabelW = ScreenWidth/2;
    CGFloat priceLabelH = PX_TO_PT(38);
    _priceLabelF = CGRectMake(priceLabelX, priceLabelY, priceLabelW, priceLabelH);
    
    // 订金
    CGFloat depositLabelX = CGRectGetMaxX(_priceLabelF)+PX_TO_PT(20);
    CGFloat depositLabelY = CGRectGetMaxY(_productNameLabelF)+PX_TO_PT(28);
    CGFloat depositLabelW = ScreenWidth/2;
    CGFloat depositLabelH = PX_TO_PT(38);
    _depositLabelF = CGRectMake(depositLabelX, depositLabelY, depositLabelW, depositLabelH);
    
    // 市场价 ,商品简介
//    self.infoModel.marketMin =
    NSLog(@"self.infoModel.marketMin = %@",self.infoModel.marketMin);
        if ([KSHttpRequest isNULL:self.infoModel.marketMin]) {
            _marketPriceLabelF = CGRectMake(0, 0, 0, 0);
            CGFloat introduceLabelX = 0;
            CGFloat introduceLabelY = CGRectGetMaxY(_depositLabelF)+PX_TO_PT(24);
            CGFloat introduceLabelW = ScreenWidth;
            CGFloat introduceLabelH = PX_TO_PT(80);
            _introduceLabelF = CGRectMake(introduceLabelX, introduceLabelY, introduceLabelW, introduceLabelH);
            
        }else{
            CGFloat marketPriceLabelX = PX_TO_PT(30);
            CGFloat marketPriceLabelY = CGRectGetMaxY(_depositLabelF)+PX_TO_PT(14);
            CGFloat marketPriceLabelW = ScreenWidth;
            CGFloat marketPriceLabelH = PX_TO_PT(38);
            _marketPriceLabelF = CGRectMake(marketPriceLabelX, marketPriceLabelY, marketPriceLabelW, marketPriceLabelH);
            
            CGFloat introduceLabelX = 0;
            CGFloat introduceLabelY = CGRectGetMaxY(_marketPriceLabelF)+PX_TO_PT(24);
            CGFloat introduceLabelW = ScreenWidth;
            CGFloat introduceLabelH = PX_TO_PT(80);
            _introduceLabelF = CGRectMake(introduceLabelX, introduceLabelY, introduceLabelW, introduceLabelH);
            
        }

    // 商品属性
    if (self.infoModel.Desc == nil || [self.infoModel.Desc isEqualToString:@""]) {// 商品描述为空
        if ([KSHttpRequest isNULL:self.infoModel.marketMin]) {
            CGFloat attributeLabelX = 0;
            CGFloat attributeLabelY = CGRectGetMaxY(_depositLabelF)+PX_TO_PT(28);
            CGFloat attributeLabelW = ScreenWidth;
            CGFloat attributeLabelH = PX_TO_PT(80);
            _attributeLabelF = CGRectMake(attributeLabelX, attributeLabelY, attributeLabelW, attributeLabelH);

        }else{
            CGFloat attributeLabelX = 0;
            CGFloat attributeLabelY = CGRectGetMaxY(_marketPriceLabelF)+PX_TO_PT(28);
            CGFloat attributeLabelW = ScreenWidth;
            CGFloat attributeLabelH = PX_TO_PT(80);
            _attributeLabelF = CGRectMake(attributeLabelX, attributeLabelY, attributeLabelW, attributeLabelH);
        }
    }else{
        CGFloat attributeLabelX = 0;
        CGFloat attributeLabelY = CGRectGetMaxY(_introduceLabelF)+PX_TO_PT(28);
        CGFloat attributeLabelW = ScreenWidth;
        CGFloat attributeLabelH = PX_TO_PT(80);
        _attributeLabelF = CGRectMake(attributeLabelX, attributeLabelY, attributeLabelW, attributeLabelH);
    }
    
    
    // 拖动
    if ([self.infoModel.online integerValue] != 0 || self.infoModel.online == nil) {// 非下架
        CGFloat drawViewX = 0;
        CGFloat drawViewY = CGRectGetMaxY(_attributeLabelF);
        CGFloat drawViewW = ScreenWidth;
        CGFloat drawViewH = PX_TO_PT(120);
        _drawViewF = CGRectMake(drawViewX, drawViewY, drawViewW, drawViewH);
    }else{// 下架
        _attributeLabelF = CGRectMake(0, 0, 0, 0);
        if (self.infoModel.Desc == nil || [self.infoModel.Desc isEqualToString:@""]) {// 商品描述为空
            if ([KSHttpRequest isNULL:self.infoModel.marketMin])
            {
                CGFloat drawViewX = 0;
                CGFloat drawViewY = CGRectGetMaxY(_priceLabelF);
                CGFloat drawViewW = ScreenWidth;
                CGFloat drawViewH = PX_TO_PT(120);
                _drawViewF = CGRectMake(drawViewX, drawViewY, drawViewW, drawViewH);
            }else{
                CGFloat drawViewX = 0;
                CGFloat drawViewY = CGRectGetMaxY(_marketPriceLabelF);
                CGFloat drawViewW = ScreenWidth;
                CGFloat drawViewH = PX_TO_PT(120);
                _drawViewF = CGRectMake(drawViewX, drawViewY, drawViewW, drawViewH);
            }
            
        
        }else{
            CGFloat drawViewX = 0;
            CGFloat drawViewY = CGRectGetMaxY(_introduceLabelF);
            CGFloat drawViewW = ScreenWidth;
            CGFloat drawViewH = PX_TO_PT(120);
            _drawViewF = CGRectMake(drawViewX, drawViewY, drawViewW, drawViewH);
        }
    
    }
    // 商品描述
    CGFloat describtionViewX = 0;
    CGFloat describtionViewY = CGRectGetMaxY(_drawViewF);
    CGFloat describtionViewW = ScreenWidth;
    CGFloat describtionViewH = PX_TO_PT(80);
    _describtionViewF = CGRectMake(describtionViewX, describtionViewY, describtionViewW, describtionViewH);
    
    // view的高度
    _viewHeight = CGRectGetMaxY(_drawViewF);


}


@end
