//
//  XNRMyOrderPayCell.m
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyOrderPayCell.h"
#import "UIImageView+WebCache.h"
@interface XNRMyOrderPayCell()<UIGestureRecognizerDelegate>{
    
    
}

@end
@implementation XNRMyOrderPayCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIView*bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 115)];
    bg.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:bg];
    
    //订单号
    self.orderNum=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, ScreenWidth-20, 30)];
    self.orderNum.font=XNRFont(15);
    self.orderNum.userInteractionEnabled=YES;
   UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkOrderClick:)];
    tap.delegate=self;
    tap.numberOfTouchesRequired=1;
    [self.orderNum addGestureRecognizer:tap];
    
    self.orderNum.textColor=R_G_B_16(0x4a4a4a);
    [bg addSubview:self.orderNum];
    //中间线
    UIView*mid_line=[[UIView alloc]initWithFrame:CGRectMake(10,115/2, ScreenWidth-20, .5)];
    mid_line.backgroundColor=[UIColor lightGrayColor];
    [bg addSubview:mid_line];
    //合计
    self.allPrice=[[UILabel alloc]initWithFrame:CGRectMake(10, 75, 130, 20)];
    self.allPrice.font=XNRFont(13);
    self.allPrice.textColor=R_G_B_16(0xb1b1b1);
    [bg addSubview:self.allPrice];
    
    //去结算
    self.goPay=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth-80, 70, 70, 30) ImageName:nil Target:self Action:@selector(goPayClick) Title:@"去结算"];
    [self.goPay setTitleColor:R_G_B_16(0x0da014) forState:UIControlStateNormal];
    self.goPay.layer.borderWidth=1.0;
    self.goPay.titleLabel.font=XNRFont(11);
    self.goPay.layer.borderColor=R_G_B_16(0x0da014).CGColor;
    self.goPay.clipsToBounds=YES;
    self.goPay.layer.cornerRadius=5;
    [bg addSubview:self.goPay];
    
    //取消订单
    self.cancelOrder=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth-80, 70, 70, 30) ImageName:nil Target:self Action:@selector(cancelOrderClick) Title:@"取消订单"];
    [self.cancelOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelOrder.titleLabel.font=XNRFont(11);
    self.cancelOrder.clipsToBounds=YES;
    self.cancelOrder.layer.cornerRadius=5;
    self.cancelOrder.backgroundColor=[UIColor lightGrayColor];
    // [bg addSubview:self.cancelOrder];
    
 
    

    
}

#pragma mark-去结算
-(void)goPayClick{
    
    NSLog(@"去付款");
    self.goPayBlock();
    
    
}
#pragma mark-取消订单
-(void)cancelOrderClick{
    
    NSLog(@"取消订单");
    
    self.deleteBlock();
}
#pragma mark-查看订单
-(void)checkOrderClick:(UITapGestureRecognizer*)TapGesture{
    
    NSLog(@"查看订单");
    
    self .checkOrderBlock(self.info.orderId,self.info.orderNo);
  
}
#pragma mark - 设置model数据模型的数据
- (void)setCellDataWithShoppingCartModel:(XNRMyOrderModel *)info
{
    self.info = info;
    [self resetSubViews];
    [self setSubViews];
}

#pragma mark - 清空以前的数据
- (void)resetSubViews
{
    
}

#pragma mark - 设置现在的数据
- (void)setSubViews
{
    self.orderNum.text=[NSString stringWithFormat:@"订单号：%@",self.info.orderId];
    self.allPrice.text=[NSString stringWithFormat:@"合计：￥%@",self.info.deposit];
    
    NSMutableAttributedString*Attributed_orderNum=[[NSMutableAttributedString alloc]initWithString:self.orderNum.text];
    NSDictionary*att_order=@{
                       NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                       NSForegroundColorAttributeName:R_G_B_16(0x31b1be),
                      
                       };
    
    [Attributed_orderNum addAttributes:att_order range:NSMakeRange(4, Attributed_orderNum.length-4)];
    
    [self.orderNum setAttributedText:Attributed_orderNum];
    

    NSMutableAttributedString*Attributed_allPrice=[[NSMutableAttributedString alloc]initWithString: self.allPrice.text];
    [Attributed_allPrice addAttribute:NSFontAttributeName value:XNRFont(10) range:NSMakeRange(3, Attributed_allPrice.length-3)];
    [Attributed_allPrice addAttribute:NSForegroundColorAttributeName value:R_G_B_16(0x0da014) range:NSMakeRange(3, Attributed_allPrice.length-3)];
    
    [self.allPrice setAttributedText:Attributed_allPrice];
    
    
    
}

@end
