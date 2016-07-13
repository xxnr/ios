//
//  XNRMyAllOrderFrame.m
//  xinnongreniOS
//
//  Created by xxnr on 16/3/23.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRMyAllOrderFrame.h"
#import "XNRMyOrderModel.h"

@implementation XNRMyAllOrderFrame

-(void)setOrderModel:(XNRMyOrderModel *)orderModel
{
    _orderModel = orderModel;
    
    _iconTopLineF = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1));
    
    // 图片
    CGFloat picImageViewX = PX_TO_PT(30);
    CGFloat picImageViewY = PX_TO_PT(30);
    CGFloat picImageViewW = PX_TO_PT(180);
    CGFloat picImageViewH = PX_TO_PT(180);
    _picImageViewF = CGRectMake(picImageViewX, picImageViewY, picImageViewW, picImageViewH);
    
    // 品牌名称
    CGFloat goodNameLabelX = CGRectGetMaxX(_picImageViewF)+PX_TO_PT(24);
    CGFloat goodNameLabelY = PX_TO_PT(42);
    CGFloat goodNameLabelW = ScreenWidth - goodNameLabelX-PX_TO_PT(30);
    CGFloat goodNameLabelH = PX_TO_PT(80);
    _productNameLabelF = CGRectMake(goodNameLabelX, goodNameLabelY, goodNameLabelW, goodNameLabelH);
    
    // 商品属性
    CGFloat attributesLabelX = CGRectGetMaxX(_picImageViewF)+PX_TO_PT(24);
    CGFloat attributesLabelY = CGRectGetMaxY(_productNameLabelF)+PX_TO_PT(20);
    CGFloat attributesLabelW = ScreenWidth - attributesLabelX - PX_TO_PT(30);
    CGSize  attributesLabelMaxSize = CGSizeMake(attributesLabelW, MAXFLOAT);
    NSMutableString *attributesStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in self.orderModel.attributes) {
        [attributesStr appendString:[NSString stringWithFormat:@"%@:%@;",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
    }
    CGSize  attributesLabelSize = [attributesStr sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(28)] maxSize:attributesLabelMaxSize];
    _attributesLabelF = (CGRect){{attributesLabelX, attributesLabelY}, attributesLabelSize};
    
    if (CGRectGetMaxY(_attributesLabelF)>CGRectGetMaxY(_picImageViewF)) {
        // 数量
        CGFloat productNumLabelX = PX_TO_PT(30);
        CGFloat productNumLabelY =  CGRectGetMaxY(_attributesLabelF) + PX_TO_PT(30);
        CGFloat productNumLabelW = PX_TO_PT(180);
        CGFloat productNumLabelH = PX_TO_PT(36);
        _productNumLabelF = CGRectMake(productNumLabelX, productNumLabelY, productNumLabelW, productNumLabelH);
        
        // 价格
        CGFloat priceLabelX = ScreenWidth/2;
        CGFloat priceLabelY =  CGRectGetMaxY(_attributesLabelF) + PX_TO_PT(30);
        CGFloat priceLabelW = ScreenWidth/2-PX_TO_PT(30);
        CGFloat priceLabelH = PX_TO_PT(32);
        _priceLabelF = CGRectMake(priceLabelX, priceLabelY, priceLabelW, priceLabelH);
    }else{
        // 数量
        CGFloat productNumLabelX = PX_TO_PT(30);
        CGFloat productNumLabelY =  CGRectGetMaxY(_picImageViewF) + PX_TO_PT(30);
        CGFloat productNumLabelW = PX_TO_PT(180);
        CGFloat productNumLabelH = PX_TO_PT(36);
        _productNumLabelF = CGRectMake(productNumLabelX, productNumLabelY, productNumLabelW, productNumLabelH);
        
        // 价格
        CGFloat priceLabelX = ScreenWidth/2;
        CGFloat priceLabelY =  CGRectGetMaxY(_picImageViewF) + PX_TO_PT(30);
        CGFloat priceLabelW = ScreenWidth/2-PX_TO_PT(30);
        CGFloat priceLabelH = PX_TO_PT(32);
        _priceLabelF = CGRectMake(priceLabelX, priceLabelY, priceLabelW, priceLabelH);
    }
    
    // 附加选项
    if (self.orderModel.additions.count == 0){
        _addtionLabelF = CGRectMake(0, 0, 0, 0);
        _addtionPriceLabelF = CGRectMake(0, 0, 0, 0);
    }else{
        NSMutableString *addtionsStr = [[NSMutableString alloc] initWithString:@"附加项目:"];
        NSString *price;
        CGFloat totalPrice = 0;
        for (NSDictionary *subDic in self.orderModel.additions) {
            [addtionsStr appendString:[NSString stringWithFormat:@"%@;",[subDic objectForKey:@"name"]]];
            price = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"price"]];
            totalPrice = totalPrice + [price floatValue];
        }
        CGFloat addtionsLabelX = PX_TO_PT(30);
        CGFloat addtionsLabelY = CGRectGetMaxY(_productNumLabelF)+PX_TO_PT(32);
        CGFloat addtionsLabelW = PX_TO_PT(424);
        CGSize  addtionsLabelMaxSize = CGSizeMake(addtionsLabelW, MAXFLOAT);
        CGSize  addtionsLabelSize = [addtionsStr sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(24)] maxSize:addtionsLabelMaxSize];
        _addtionLabelF = CGRectMake(addtionsLabelX, addtionsLabelY, addtionsLabelW, addtionsLabelSize.height);
        
        // 附加选项价格
        CGFloat addtionPriceLabelX = ScreenWidth/2;
        CGFloat addtionPriceLabelY = CGRectGetMaxY(_productNumLabelF)+PX_TO_PT(32);
        CGFloat addtionPriceLabelW = ScreenWidth/2-PX_TO_PT(30);
        CGFloat addtionPriceLabelH = addtionsLabelSize.height;
        _addtionPriceLabelF = CGRectMake(addtionPriceLabelX, addtionPriceLabelY, addtionPriceLabelW, addtionPriceLabelH);


    }
    
    // 下划线
    CGFloat topLineX = 0;
    CGFloat topLineH;
    if (IS_FourInch) {
        topLineH = PX_TO_PT(1.5);
        
    }else{
        topLineH = PX_TO_PT(1);
    }

    CGFloat topLineW = ScreenWidth;
    CGFloat topLineY;
 
    if (self.orderModel.additions.count>0) {
        topLineY = CGRectGetMaxY(_addtionLabelF)+PX_TO_PT(36);
    }
    else if([self.orderModel.deposit floatValue] > 0.00f){
        topLineY =  CGRectGetMaxY(_productNumLabelF)+PX_TO_PT(36);
    }

    else{
        topLineY =  CGRectGetMaxY(_productNumLabelF)+PX_TO_PT(36);
        topLineH = 0;
    }
    _topLineF = CGRectMake(topLineX, topLineY, topLineW, topLineH);

    
    if (self.orderModel.deposit && [self.orderModel.deposit floatValue]>0.00) {
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
        _depositLabelF = CGRectMake(depositeLabelX, depositeLabelY, depositeLabelW, depositeLabelH);
        
        
        // 中间线
        CGFloat middleLineX = PX_TO_PT(30);
        CGFloat middleLineY = CGRectGetMaxY(_depositLabelF);
        CGFloat middleLineW = ScreenWidth-PX_TO_PT(30);
        CGFloat middleLineH;
        if (IS_FourInch) {
            middleLineH = PX_TO_PT(1.5);
            
        }else{
            middleLineH = PX_TO_PT(1);
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
        _remainPriceLabelF = CGRectMake(finalPaymentLabelX, finalPaymentLabelY, finalPaymentLabelW, finalPaymentLabelH);
        
        // 尾部划线
        CGFloat bottomLineX = 0;
        CGFloat bottomLineY = CGRectGetMaxY(_remainPriceLabelF);
        CGFloat bottomLineW = ScreenWidth;
        CGFloat bottomLineH;
        if (IS_FourInch) {
            bottomLineH = PX_TO_PT(1.5);
            
        }else{
            bottomLineH = PX_TO_PT(1);
        }

        _bottomLineF = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
        
//        // 合计
//        CGFloat totalPriceLabelX = ScreenWidth/2;
//        CGFloat totalPriceLabelY = CGRectGetMaxY(_bottomLineF);
//        CGFloat totalPriceLabelW = ScreenWidth/2-PX_TO_PT(30);
//        CGFloat totalPriceLabelH = PX_TO_PT(80);
//        _remainPriceLabelF = CGRectMake(totalPriceLabelX, totalPriceLabelY, totalPriceLabelW, totalPriceLabelH);

        
        
    }
    
    else{
//        // 合计
//        CGFloat totalPriceLabelX = ScreenWidth/2;
//        CGFloat totalPriceLabelY = CGRectGetMaxY(_topLineF);
//        CGFloat totalPriceLabelW = ScreenWidth/2-PX_TO_PT(30);
//        CGFloat totalPriceLabelH = PX_TO_PT(80);
//        _remainPriceLabelF = CGRectMake(totalPriceLabelX, totalPriceLabelY, totalPriceLabelW, totalPriceLabelH);

    }
    
//    // 支付按钮
//    CGFloat goPayButtonX = ScreenWidth-PX_TO_PT(170);
//    CGFloat goPayButtonY = CGRectGetMaxY(_remainPriceLabelF)+PX_TO_PT(10);
//    CGFloat goPayButtonW = ScreenWidth/2-PX_TO_PT(30);
//    CGFloat goPayButtonH = PX_TO_PT(60);
//    _goPayButtonF = CGRectMake(goPayButtonX, goPayButtonY, goPayButtonW, goPayButtonH);

    
    // cell的高度
    if (self.orderModel.deposit && [self.orderModel.deposit floatValue]>0) {
        _cellHeight = CGRectGetMaxY(_sectionTwoLabelF);

    }else{
        _cellHeight = CGRectGetMaxY(_topLineF);
    }

    
    
}


@end
