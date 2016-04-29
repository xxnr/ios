//
//  XNRRscOrderDetialFrameModel.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscOrderDetialFrameModel.h"
#import "XNRRscOrderModel.h"

@implementation XNRRscOrderDetialFrameModel

-(void)setModel:(XNRRscSkusModel *)model
{
    _model = model;
    CGFloat imageViewX = PX_TO_PT(30);
    CGFloat imageViewY = PX_TO_PT(30);
    CGFloat imageViewW = PX_TO_PT(180);
    CGFloat imageViewH = PX_TO_PT(180);
    _imageViewF = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    CGFloat goodsNameLabelX = CGRectGetMaxX(_imageViewF)+PX_TO_PT(20);
    CGFloat goodsNameLabelY = PX_TO_PT(40);
    CGFloat goodsNameLabelW = ScreenWidth - goodsNameLabelX-PX_TO_PT(100);
    CGFloat goodsNameLabelH = PX_TO_PT(80);
    _goodsNameLabelF  =CGRectMake(goodsNameLabelX, goodsNameLabelY, goodsNameLabelW, goodsNameLabelH);
    
    
    CGFloat goodsNumberLabelX = ScreenWidth/2;
    CGFloat goodsNumberLabelY = PX_TO_PT(40);
    CGFloat goodsNumberLabelW = ScreenWidth/2-PX_TO_PT(30);
    CGFloat goodsNumberLabelH = PX_TO_PT(26);
    _goodsNumberLabelF  =CGRectMake(goodsNumberLabelX, goodsNumberLabelY, goodsNumberLabelW, goodsNumberLabelH);
    
    CGFloat attributesLabelX = CGRectGetMaxX(_imageViewF)+PX_TO_PT(20);
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
        CGFloat bottomLineY = CGRectGetMaxY(_imageViewF)+PX_TO_PT(30);
        CGFloat bottomLineW = ScreenWidth;
        CGFloat bottomLineH = PX_TO_PT(1);
        _bottomLineF = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    }else{
        NSMutableString *addtionsStr = [[NSMutableString alloc] initWithString:@"附加项目:"];
        for (NSDictionary *subDic in self.model.additions) {
            [addtionsStr appendString:[NSString stringWithFormat:@"%@;",[subDic objectForKey:@"name"]]];
        }
        CGFloat addtionsLabelX = PX_TO_PT(30);
        CGFloat addtionsLabelY = CGRectGetMaxY(_imageViewF)+PX_TO_PT(20);
        CGFloat addtionsLabelW = ScreenWidth-PX_TO_PT(60);
        CGSize  addtionsLabelMaxSize = CGSizeMake(addtionsLabelW, MAXFLOAT);
        CGSize  addtionsLabelSize = [addtionsStr sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(24)] maxSize:addtionsLabelMaxSize];
        _addtionsLabelF = CGRectMake(addtionsLabelX, addtionsLabelY, addtionsLabelW, addtionsLabelSize.height);
        
        CGFloat bottomLineX = 0;
        CGFloat bottomLineY = CGRectGetMaxY(_addtionsLabelF)+PX_TO_PT(30);
        CGFloat bottomLineW = ScreenWidth;
        CGFloat bottomLineH = PX_TO_PT(1);
        _bottomLineF = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
        
    }
    
    _cellHeight = CGRectGetMaxY(_bottomLineF);

}


@end
