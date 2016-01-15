//
//  XNRMyOrderSend_Cell.m
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyOrderSend_Cell.h"
#import "UIImageView+WebCache.h"
@implementation XNRMyOrderSend_Cell
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
    //self.allPrice.backgroundColor=[UIColor blackColor];
    [bg addSubview:self.allPrice];
    
    //发货中...
    self.orderState=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-170, 70, 70, 30)];
    
    self.orderState.textColor=[UIColor blackColor];
    self.orderState.textAlignment = NSTextAlignmentCenter;
    self.orderState.font=XNRFont(16);
    [bg addSubview:self.orderState];
    

    
}


#pragma mark-查看订单
-(void)checkOrderClick:(UITapGestureRecognizer*)TapGesture{
    
    NSLog(@"查看订单");
    
//     self .checkOrderBlock(self.info.orderId,self.info.orderNo);
    
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
//    self.allPrice.text=[NSString stringWithFormat:@"合计：￥%@",self.info.totalPrice];
    self.orderState.text=@"发货中";
    NSMutableAttributedString*Attributed_orderNum=[[NSMutableAttributedString alloc]initWithString:self.orderNum.text];
    NSDictionary*att_order=@{
                             NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                             NSForegroundColorAttributeName:R_G_B_16(0x31b1be),
                             
                             };
    
    [Attributed_orderNum addAttributes:att_order range:NSMakeRange(4, Attributed_orderNum.length-4)];
    
    [self.orderNum setAttributedText:Attributed_orderNum];
    
    
    
//    NSMutableAttributedString*Attributed_allPrice=[[NSMutableAttributedString alloc]initWithString: self.allPrice.text];
//    [Attributed_allPrice addAttribute:NSFontAttributeName value:XNRFont(10) range:NSMakeRange(3, Attributed_allPrice.length-3)];
//    [Attributed_allPrice addAttribute:NSForegroundColorAttributeName value:R_G_B_16(0x0da014) range:NSMakeRange(3, Attributed_allPrice.length-3)];
//    
//    [self.allPrice setAttributedText:Attributed_allPrice];
    
    
    
}
@end
