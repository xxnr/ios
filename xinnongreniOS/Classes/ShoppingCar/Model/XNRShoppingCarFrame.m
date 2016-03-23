//
//  XNRShoppingCarFrame.m
//  xinnongreniOS
//
//  Created by xxnr on 16/3/20.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRShoppingCarFrame.h"
#import "XNRShoppingCartModel.h"
#define margin PX_TO_PT(20)

@implementation XNRShoppingCarFrame
/**
 *  根据数据计算子控件的frame
 */
-(void)setShoppingCarModel:(XNRShoppingCartModel *)shoppingCarModel
{
    _shoppingCarModel = shoppingCarModel;
    // 选择按钮
    CGFloat selectedBtnX = PX_TO_PT(30);
    CGFloat selectedBtnY = PX_TO_PT(102);
    CGFloat selectedBtnW = PX_TO_PT(36);
    CGFloat selectedBtnH = PX_TO_PT(36);
    _selectedBtnF = CGRectMake(selectedBtnX, selectedBtnY, selectedBtnW, selectedBtnH);
    
    // 图片
    CGFloat picImageViewX = PX_TO_PT(86);
    CGFloat picImageViewY = PX_TO_PT(30);
    CGFloat picImageViewW = PX_TO_PT(180);
    CGFloat picImageViewH = PX_TO_PT(180);
    _picImageViewF = CGRectMake(picImageViewX, picImageViewY, picImageViewW, picImageViewH);
    
    // 品牌名称
    CGFloat goodNameLabelX = CGRectGetMaxX(_picImageViewF)+margin;
    CGFloat goodNameLabelY = PX_TO_PT(40);
    CGFloat goodNameLabelW = ScreenWidth - goodNameLabelX-PX_TO_PT(30);
    CGFloat goodNameLabelH = PX_TO_PT(80);
//    CGSize  goodNameLabelMaxSize = CGSizeMake(goodNameLabelW, MAXFLOAT);
//    CGSize  goodNameLabelSize = [self.shoppingCarModel.productName sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(32)] maxSize:goodNameLabelMaxSize];
    _goodNameLabelF = CGRectMake(goodNameLabelX, goodNameLabelY, goodNameLabelW, goodNameLabelH);
    
    // 商品属性
    CGFloat attributesLabelX = CGRectGetMaxX(_picImageViewF)+margin;
    CGFloat attributesLabelY = CGRectGetMaxY(_goodNameLabelF)+margin;
    CGFloat attributesLabelW = ScreenWidth - attributesLabelX-PX_TO_PT(30);
    CGSize  attributesLabelMaxSize = CGSizeMake(attributesLabelW, MAXFLOAT);
    NSMutableString *attributesStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in self.shoppingCarModel.attributes) {
        [attributesStr appendString:[NSString stringWithFormat:@"%@:%@;",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
    }
    CGSize  attributesLabelSize = [attributesStr sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(28)] maxSize:attributesLabelMaxSize];
    _attributesLabelF = (CGRect){{attributesLabelX, attributesLabelY}, attributesLabelSize};
    
    // push按钮
    CGFloat pushBntX = PX_TO_PT(86);
    CGFloat pushBntY = PX_TO_PT(30);
    CGFloat pushBntW = ScreenWidth-PX_TO_PT(86);
    CGFloat pushBntH = PX_TO_PT(180);
    _pushBtnF = CGRectMake(pushBntX, pushBntY, pushBntW, pushBntH);

    
    
    // 左边按钮
    CGFloat leftBtnX = PX_TO_PT(86);
    CGFloat leftBtnY = CGRectGetMaxY(_picImageViewF)+margin;
    CGFloat leftBtnW = PX_TO_PT(48);
    CGFloat leftBtnH = PX_TO_PT(48);
    _leftBtnF = CGRectMake(leftBtnX, leftBtnY, leftBtnW, leftBtnH);
    
    // text
    CGFloat numTextFieldX = CGRectGetMaxX(_leftBtnF);
    CGFloat numTextFieldY = CGRectGetMaxY(_picImageViewF)+margin;
    CGFloat numTextFieldW = PX_TO_PT(84);
    CGFloat numTextFieldH = PX_TO_PT(48);
    _numTextFieldF = CGRectMake(numTextFieldX, numTextFieldY, numTextFieldW, numTextFieldH);
    
    //右边按钮
    CGFloat rightBtnX = CGRectGetMaxX(_numTextFieldF);
    CGFloat rightBtnY = CGRectGetMaxY(_picImageViewF)+margin;
    CGFloat rightBtnW = PX_TO_PT(48);
    CGFloat rightBtnH = PX_TO_PT(48);
    _rightBtnF = CGRectMake(rightBtnX, rightBtnY, rightBtnW, rightBtnH);
    
    // 价格
    CGFloat PriceLabelX = ScreenWidth/2;
    CGFloat PriceLabelY = CGRectGetMaxY(_picImageViewF)+margin;
    CGFloat PriceLabelW = ScreenWidth/2-PX_TO_PT(30);
    CGFloat PriceLabelH = PX_TO_PT(48);
    _PriceLabelF = CGRectMake(PriceLabelX, PriceLabelY, PriceLabelW, PriceLabelH);
    
    // 附加选项
    if (self.shoppingCarModel.additions.count == 0){
        _addtionsLabelF = CGRectMake(0, 0, 0, 0);
        _addtionPriceLabelF = CGRectMake(0, 0, 0, 0);
    }else{
        NSMutableString *addtionsStr = [[NSMutableString alloc] initWithString:@"附加项目:"];
        NSString *price;
        CGFloat totalPrice = 0;
        for (NSDictionary *subDic in self.shoppingCarModel.additions) {
            [addtionsStr appendString:[NSString stringWithFormat:@"%@;",[subDic objectForKey:@"name"]]];
            price = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"price"]];
            totalPrice = totalPrice + [price floatValue];
        }
        CGFloat addtionsLabelX = PX_TO_PT(86);
        CGFloat addtionsLabelY = CGRectGetMaxY(_leftBtnF)+PX_TO_PT(36);
        CGFloat addtionsLabelW = PX_TO_PT(424);
        CGSize  addtionsLabelMaxSize = CGSizeMake(addtionsLabelW, MAXFLOAT);
        CGSize  addtionsLabelSize = [addtionsStr sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(24)] maxSize:addtionsLabelMaxSize];
        _addtionsLabelF = CGRectMake(addtionsLabelX, addtionsLabelY, addtionsLabelW, addtionsLabelSize.height);
        
        // 附加选项价格
        CGFloat addtionPriceLabelX = ScreenWidth/2;
        CGFloat addtionPriceLabelY = CGRectGetMaxY(_leftBtnF)+PX_TO_PT(36);
        CGFloat addtionPriceLabelW = ScreenWidth/2-PX_TO_PT(30);
        CGFloat addtionPriceLabelH = addtionsLabelSize.height;
        _addtionPriceLabelF = CGRectMake(addtionPriceLabelX, addtionPriceLabelY, addtionPriceLabelW, addtionPriceLabelH);
    }
    // 下划线
    CGFloat topLineX = 0;
    CGFloat topLineH = PX_TO_PT(1);
    CGFloat topLineW = ScreenWidth;
    CGFloat topLineY;
    if (self.shoppingCarModel.additions.count>0) {
        topLineY = CGRectGetMaxY(_addtionsLabelF)+PX_TO_PT(36);
    }else{
        topLineY =  CGRectGetMaxY(_leftBtnF)+PX_TO_PT(36);;

    }
    _topLineF = CGRectMake(topLineX, topLineY, topLineW, topLineH);

    if (self.shoppingCarModel.deposit && [self.shoppingCarModel.deposit floatValue]>0) {
        // 订金
        CGFloat sectionOneLabelX = PX_TO_PT(86);
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
        CGFloat middleLineH = PX_TO_PT(1);
        _middleLineF = CGRectMake(middleLineX, middleLineY, middleLineW, middleLineH);
        
        // 尾款
        CGFloat sectionTwoLabelX = PX_TO_PT(86);
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
        CGFloat bottomLineH = PX_TO_PT(1);
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
