//
//  XNROderInfo_Cell.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/5.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNROderInfo_Cell.h"

@interface XNROderInfo_Cell ()
{
    UIView*bg;
}

@property (nonatomic,strong) UIButton *makeSureBtn;
@property (nonatomic ,weak) UILabel *num;

@end

@implementation XNROderInfo_Cell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 95)];
    bg.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:bg];
    
    UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 25)];
    title.font=XNRFont(16);
    title.textColor=TITLECOLOR;
    title.text=@"商品名称:";
    [bg addSubview:title];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+25, 100, 25)];
    price.font=XNRFont(16);
    price.textColor=TITLECOLOR;
    price.text=@"商品单价:";
    [bg addSubview:price];
    
    UILabel*num=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+50, 100, 25)];
    num.font=XNRFont(16);
    num.textColor=TITLECOLOR;
    num.text=@"商品数量:";
    self.num = num;
    [bg addSubview:num];
    
    
    if(nil==self.productTitle){
        
        self.productTitle=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.size.width, 10, ScreenWidth-20-10-title.frame.size.width, 25)];
        self.productTitle.textColor=R_G_B_16(0x8b8b8b);
        self.productTitle.font=XNRFont(16) ;
        self.productTitle.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.productTitle];
    }
    if(nil==self.productPrice){
        
        self.productPrice=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.size.width, 10+25, ScreenWidth-20-10-title.frame.size.width, 25)];
        self.productPrice.font=XNRFont(15);
        self.productPrice.textAlignment=NSTextAlignmentRight;
        self.productPrice.textColor=R_G_B_16(0x068c0f);
        
        [self.contentView addSubview:self.productPrice];
        
    }
    if(nil==self.productNum){
        
        self.productNum=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.size.width, 10+50, ScreenWidth-20-10-title.frame.size.width, 25)];
        self.productNum.textColor=R_G_B_16(0x068c0f);
        self.productNum.font=XNRFont(15);
        self.productNum.textAlignment=NSTextAlignmentRight;
        
        [self.contentView addSubview:self.productNum];
        
    }

}


-(void)setCellDataWithModel:(XNRCheckOrderModel*)model{
    
    _model = model;
    [self resetSubViews];
    [self setSubViews];
    
    
}
#pragma mark - 清空以前的数据
- (void)resetSubViews
{
    self.makeSureBtn.selected = NO;
}

#pragma mark - 设置现在的数据
- (void)setSubViews {    
    
    self.productTitle.text= _model.goodsName;
    
#warning 这个字段需要确认
//TODO:
    NSString *unitPrice=@"0";
    if ([unitPrice isEqualToString:@""] || [unitPrice isEqualToString:@"0"] || unitPrice == nil){
        
        if ([_model.deposit integerValue] == 0 || _model.deposit == nil) {
            self.productPrice.text=[NSString stringWithFormat:@"￥%@",_model.originalPrice];
        }else{
            self.productPrice.text=[NSString stringWithFormat:@"￥%.2f(定金)",[_model.deposit floatValue]];
        }
        
    }else{
        self.productPrice.text=@"0";
    }
    
    self.productNum.text = [NSString stringWithFormat:@"%@",_model.goodsCount];
    
}

@end
