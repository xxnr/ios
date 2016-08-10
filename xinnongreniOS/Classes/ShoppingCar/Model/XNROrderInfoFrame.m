//
//  XNROrderInfoFrame.m
//  xinnongreniOS
//
//  Created by xxnr on 16/3/30.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNROrderInfoFrame.h"
#import "XNRShoppingCartModel.h"
#define margin PX_TO_PT(20)

@implementation XNROrderInfoFrame

-(void)setShoppingCarModel:(XNRShoppingCartModel *)shoppingCarModel
{
    _shoppingCarModel = shoppingCarModel;
    
    // 图片
    CGFloat picImageViewX = PX_TO_PT(30);
    CGFloat picImageViewY = PX_TO_PT(30);
    CGFloat picImageViewW = PX_TO_PT(180);
    CGFloat picImageViewH = PX_TO_PT(180);
    _picImageViewF = CGRectMake(picImageViewX, picImageViewY, picImageViewW, picImageViewH);
    
    // 品牌名称
    CGFloat goodNameLabelX = CGRectGetMaxX(_picImageViewF)+margin;
    CGFloat goodNameLabelY = PX_TO_PT(40);
    CGFloat goodNameLabelW = ScreenWidth - goodNameLabelX-PX_TO_PT(30);
    CGFloat goodNameLabelH = PX_TO_PT(80);
     _goodNameLabelF = CGRectMake(goodNameLabelX, goodNameLabelY, goodNameLabelW, goodNameLabelH);
    
    
    // 商品属性
    CGFloat attributesLabelX = CGRectGetMaxX(_picImageViewF)+margin;
    CGFloat attributesLabelY = CGRectGetMaxY(_goodNameLabelF);
    CGFloat attributesLabelW = ScreenWidth - attributesLabelX-PX_TO_PT(30);
    CGSize  attributesLabelMaxSize = CGSizeMake(attributesLabelW, MAXFLOAT);
    NSMutableString *attributesStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in self.shoppingCarModel.attributes) {
        [attributesStr appendString:[NSString stringWithFormat:@"%@:%@;",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
    }
    CGSize  attributesLabelSize = [attributesStr sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(28)] maxSize:attributesLabelMaxSize];
    _attributesLabelF = (CGRect){{attributesLabelX, attributesLabelY}, attributesLabelSize};

    if (CGRectGetMaxY(_attributesLabelF) >CGRectGetMaxY(_picImageViewF)) {
        // 数量
        CGFloat numberLabelX = PX_TO_PT(30);
        CGFloat numberLabelY = CGRectGetMaxY(_attributesLabelF)+margin;
        CGFloat numberLabelW = PX_TO_PT(180);
        CGFloat numberLabelH = PX_TO_PT(80);
        _numberLabelF = CGRectMake(numberLabelX, numberLabelY, numberLabelW, numberLabelH);
        
        // 价格
        CGFloat PriceLabelX = ScreenWidth/2;
        CGFloat PriceLabelY = CGRectGetMaxY(_attributesLabelF)+margin;
        CGFloat PriceLabelW = ScreenWidth/2-PX_TO_PT(30);
        CGFloat PriceLabelH = PX_TO_PT(80);
        _PriceLabelF = CGRectMake(PriceLabelX, PriceLabelY, PriceLabelW, PriceLabelH);

    }else{
        // 数量
        CGFloat numberLabelX = PX_TO_PT(30);
        CGFloat numberLabelY = CGRectGetMaxY(_picImageViewF)+margin;
        CGFloat numberLabelW = PX_TO_PT(180);
        CGFloat numberLabelH = PX_TO_PT(80);
        _numberLabelF = CGRectMake(numberLabelX, numberLabelY, numberLabelW, numberLabelH);
        
        // 价格
        CGFloat PriceLabelX = ScreenWidth/2;
        CGFloat PriceLabelY = CGRectGetMaxY(_picImageViewF)+margin;
        CGFloat PriceLabelW = ScreenWidth/2-PX_TO_PT(30);
        CGFloat PriceLabelH = PX_TO_PT(80);
        _PriceLabelF = CGRectMake(PriceLabelX, PriceLabelY, PriceLabelW, PriceLabelH);

    }
    

    
    // 商品附加选型
    CGFloat additionalLabelY = CGRectGetMaxY(_PriceLabelF)+margin;

    for (int i = 0; i<self.shoppingCarModel.additions.count; i++) {
        
        NSDictionary *subDic = self.shoppingCarModel.additions[i];
        
        CGSize size = [subDic[@"name"] sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(24)] constrainedToSize:CGSizeMake(ScreenWidth/2, MAXFLOAT)];

        
        CGFloat attributesLabelX = PX_TO_PT(30);
//        CGFloat attributesLabelY = PX_TO_PT(44) * i+CGRectGetMaxY(_PriceLabelF)+margin;
        CGFloat attributesLabelW = ScreenWidth -PX_TO_PT(60);
        CGFloat  attributesLabelH = size.height+PX_TO_PT(20);
        _addtionsLabelF = CGRectMake(attributesLabelX, additionalLabelY, attributesLabelW, attributesLabelH);
        
        CGFloat attributesLineViewX = PX_TO_PT(30);
        CGFloat attributesLineViewY = CGRectGetMaxY(_addtionsLabelF);
        CGFloat attributesLineViewW = ScreenWidth - PX_TO_PT(60);
        CGFloat  attributesLineViewH = PX_TO_PT(4);
        _addtionslineViewF = CGRectMake(attributesLineViewX, attributesLineViewY, attributesLineViewW, attributesLineViewH);
        
        additionalLabelY = CGRectGetMaxY(_addtionslineViewF);
        
    }
    
   
    
    // push按钮
    CGFloat pushBntX = PX_TO_PT(86);
    CGFloat pushBntY = PX_TO_PT(30);
    CGFloat pushBntW = ScreenWidth-PX_TO_PT(86);
    CGFloat pushBntH = PX_TO_PT(180);
    _pushBtnF = CGRectMake(pushBntX, pushBntY, pushBntW, pushBntH);
    
    
    // 下划线
    CGFloat topLineX = 0;
    CGFloat topLineH;
    if (IS_FourInch) {
        topLineH = PX_TO_PT(1.5);
        
    }else{
        topLineH = 1;
    }
    CGFloat topLineW = ScreenWidth;
    CGFloat topLineY;
    if (self.shoppingCarModel.additions.count>0) {
        topLineY = CGRectGetMaxY(_addtionslineViewF);
    }else{
        topLineY =  CGRectGetMaxY(_PriceLabelF);
        
    }
    _topLineF = CGRectMake(topLineX, topLineY, topLineW, topLineH);
    
    if (self.shoppingCarModel.deposit && [self.shoppingCarModel.deposit floatValue]>0.00) {
        // 订金
        CGFloat sectionOneLabelX = PX_TO_PT(30);
        CGFloat sectionOneLabelY = CGRectGetMaxY(_topLineF);
        CGFloat sectionOneLabelW = ScreenWidth/2;
        CGFloat sectionOneLabelH = PX_TO_PT(80);
        _sectionOneLabelF = CGRectMake(sectionOneLabelX, sectionOneLabelY, sectionOneLabelW, sectionOneLabelH);
        
        CGFloat depositeLabelX = ScreenWidth/2;
        CGFloat depositeLabelY = CGRectGetMaxY(_topLineF);
        CGFloat depositeLabelW = ScreenWidth/2-PX_TO_PT(30);
        CGFloat depositeLabelH = PX_TO_PT(80);
        _depositeLabelF = CGRectMake(depositeLabelX, depositeLabelY, depositeLabelW, depositeLabelH);
        
        
        // 中间线
        CGFloat middleLineX = PX_TO_PT(30);
        CGFloat middleLineY = CGRectGetMaxY(_depositeLabelF);
        CGFloat middleLineW = ScreenWidth-PX_TO_PT(60);
        CGFloat middleLineH;
        if (IS_FourInch) {
            middleLineH = PX_TO_PT(1.5);
            
        }else{
            middleLineH = 1;
        }
        _middleLineF = CGRectMake(middleLineX, middleLineY, middleLineW, middleLineH);
        
        // 尾款
        CGFloat sectionTwoLabelX = PX_TO_PT(30);
        CGFloat sectionTwoLabelY = CGRectGetMaxY(_middleLineF);
        CGFloat sectionTwoLabelW = ScreenWidth/2;
        CGFloat sectionTwoLabelH = PX_TO_PT(80);
        _sectionTwoLabelF = CGRectMake(sectionTwoLabelX, sectionTwoLabelY, sectionTwoLabelW, sectionTwoLabelH);
        
        
        CGFloat finalPaymentLabelX = ScreenWidth/2;
        CGFloat finalPaymentLabelY = CGRectGetMaxY(_middleLineF);
        CGFloat finalPaymentLabelW = ScreenWidth/2-PX_TO_PT(30);
        CGFloat finalPaymentLabelH = PX_TO_PT(80);
        _finalPaymentLabelF = CGRectMake(finalPaymentLabelX, finalPaymentLabelY, finalPaymentLabelW, finalPaymentLabelH);
        
        // 尾部划线
        CGFloat bottomLineX = 0;
        CGFloat bottomLineY = CGRectGetMaxY(_finalPaymentLabelF);
        CGFloat bottomLineW = ScreenWidth;
        CGFloat bottomLineH;
        if (IS_FourInch) {
            bottomLineH = PX_TO_PT(1.5);
            
        }else{
            bottomLineH = 1;
        }
        _bottomLineF = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
        
        
    }
    
    
    // 计算cell的高度
    if (self.shoppingCarModel.deposit && [self.shoppingCarModel.deposit floatValue]>0) {
        _cellHeight = CGRectGetMaxY(_bottomLineF);
    }else{
        _cellHeight = CGRectGetMaxY(_topLineF) ;
        
    }

}

@end
