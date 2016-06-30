//
//  XNRRscDeliverFrameModel.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/27.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscDeliverFrameModel.h"
#import "XNRRscOrderModel.h"

@implementation XNRRscDeliverFrameModel

-(void)setModel:(XNRRscSkusModel *)model
{
    _model = model;
    
    CGFloat goodsNameLabelX = PX_TO_PT(100);
    CGFloat goodsNameLabelY = PX_TO_PT(30);
    CGFloat goodsNameLabelW = ScreenWidth-PX_TO_PT(180);
    CGFloat goodsNameLabelH = PX_TO_PT(32);
    _goodsNameLabelF = CGRectMake(goodsNameLabelX, goodsNameLabelY, goodsNameLabelW, goodsNameLabelH);
    
    CGFloat goodsNumberLabelX = ScreenWidth/2;
    CGFloat goodsNumberLabelY = PX_TO_PT(30);
    CGFloat goodsNumberLabelW = ScreenWidth/2-PX_TO_PT(30);
    CGFloat goodsNumberLabelH = PX_TO_PT(26);
    _goodsNumberLabelF  =CGRectMake(goodsNumberLabelX, goodsNumberLabelY, goodsNumberLabelW, goodsNumberLabelH);
    
    CGFloat attributesLabelX = PX_TO_PT(100);
    CGFloat attributesLabelY = CGRectGetMaxY(_goodsNameLabelF)+PX_TO_PT(20);
    CGFloat attributesLabelW = ScreenWidth - attributesLabelX - PX_TO_PT(30);
    CGSize  attributesLabelMaxSize = CGSizeMake(attributesLabelW, MAXFLOAT);
    NSMutableString *attributesStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in self.model.attributes) {
        [attributesStr appendString:[NSString stringWithFormat:@"%@:%@;",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
    }
    CGSize  attributesLabelSize = [attributesStr sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(28)] maxSize:attributesLabelMaxSize];
    _attributesLabelF = (CGRect){{attributesLabelX, attributesLabelY}, attributesLabelSize};
    
    if (self.model.additions.count == 0) {
        CGFloat bottomLineX = 0;
        CGFloat bottomLineY = CGRectGetMaxY(_attributesLabelF)+PX_TO_PT(30);
        CGFloat bottomLineW = ScreenWidth;
        CGFloat bottomLineH = 1;
        _bottomLineF = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    }else{
        NSMutableString *addtionsStr = [[NSMutableString alloc] initWithString:@"附加项目:"];
        for (NSDictionary *subDic in self.model.additions) {
            [addtionsStr appendString:[NSString stringWithFormat:@"%@;",[subDic objectForKey:@"name"]]];
        }
        CGFloat addtionsLabelX = PX_TO_PT(100);
        CGFloat addtionsLabelY = CGRectGetMaxY(_attributesLabelF)+PX_TO_PT(20);
        CGFloat addtionsLabelW = ScreenWidth-PX_TO_PT(60);
        CGSize  addtionsLabelMaxSize = CGSizeMake(addtionsLabelW, MAXFLOAT);
        CGSize  addtionsLabelSize = [addtionsStr sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(24)] maxSize:addtionsLabelMaxSize];
        _addtionsLabelF = CGRectMake(addtionsLabelX, addtionsLabelY, addtionsLabelW, addtionsLabelSize.height);
        
        CGFloat bottomLineX = 0;
        CGFloat bottomLineY = CGRectGetMaxY(_addtionsLabelF)+PX_TO_PT(30);
        CGFloat bottomLineW = ScreenWidth;
        CGFloat bottomLineH;
        if (IS_FourInch) {
             bottomLineH = PX_TO_PT(2);
        }else{
             bottomLineH = 1;
        }
        _bottomLineF = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
        
    }
    CGFloat imageViewX = PX_TO_PT(30);
    CGFloat imageViewY = CGRectGetMaxY(_bottomLineF)/2-PX_TO_PT(18);
    CGFloat imageViewW = PX_TO_PT(36);
    CGFloat imageViewH = PX_TO_PT(36);
    _imageViewF = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    _cellHeight = CGRectGetMaxY(_bottomLineF);
    
}

@end
