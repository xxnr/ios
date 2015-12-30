//
//  XNROderInfo_Cell.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/5.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNROderInfo_Cell.h"

#define kMakeSureOrderUrl @"api/v2.0/order/confirmeOrder"

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
    
//    if (nil == self.makeSureBtn) {
//        self.makeSureBtn= [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-20-100-10, 10+75, 100, 30) ImageName:nil Target:self Action:@selector(makeSureBtnClick:) Title:nil];
//        self.makeSureBtn.backgroundColor=R_G_B_16(0x119f17);
//        [self.makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.makeSureBtn.titleLabel.font = XNRFont(16);
//        self.makeSureBtn.layer.masksToBounds = YES;
//        self.makeSureBtn.layer.cornerRadius = 5;
//        self.makeSureBtn.hidden = YES;
//        [self.contentView addSubview:self.makeSureBtn];
//    }
    

}

//- (void)makeSureBtnClick:(UIButton *)button
//{
//    if ([self.model.myOrderType isEqualToString:@"待收货"]) {
//        if (self.model.isSelected == NO) {
//            NSLog(@"确认收货");
//            [self requestMakeSureOrder];
//        }
//    }
//    else if ([self.model.myOrderType isEqualToString:@"已完成"])
//    {
//        if (self.model.isSelected == NO) {
//           
//            [self finfishEvaluation];
//        }
//    }
//    
//}

//#pragma mark -
//- (void)finfishEvaluation
//{
//    self.commentGoodBlock(self.model);
//}

//#pragma mark - 确认收货
//- (void)requestMakeSureOrder
//{
//    [SVProgressHUD showWithStatus:@"确认收货中" maskType:SVProgressHUDMaskTypeClear];
//    [KSHttpRequest post:KConfirmeOrder parameters:@{@"locationUserId":[DataCenter account].userid == nil?@"":[DataCenter account].userid,@"userId":[DataCenter account].userid == nil?@"":[DataCenter account].userid,@"orderSubNo":self.model.orderSubNo == nil?@"":self.model.orderSubNo,@"user-agent":@"IOS-v2.0"} success:^(id result) {
//        if ([result[@"code"] isEqualToString:@"1000"]) {
//            self.model.isSelected = YES;
//            self.refreshBlock();
//            [SVProgressHUD showSuccessWithStatus:@"确认收货成功"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"MakeSureOrderSuccess" object:nil];
//        }else{
//            [SVProgressHUD showSuccessWithStatus:@"确认收货失败"];
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD showSuccessWithStatus:@"确认收货失败"];
//    }];
//    
//}

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
//    if ([_model.myOrderType isEqualToString:@"待收货"]) {
//        if (_model.isSelected) {
//            bg.frame = CGRectMake(0, 0, ScreenWidth-20, 95);
//            self.makeSureBtn.hidden = YES;
//        }else{
//            bg.frame = CGRectMake(0, 0, ScreenWidth-20, 125);
//            self.makeSureBtn.hidden = NO;
//            [self.makeSureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//            self.makeSureBtn.backgroundColor=R_G_B_16(0x119f17);
//        }
//    }
//    else if ([_model.myOrderType isEqualToString:@"已完成"])
//    {
//        if (_model.isSelected) {
//            bg.frame = CGRectMake(0, 0, ScreenWidth-20, 95);
//            self.makeSureBtn.hidden = YES;
//        }else{
//            bg.frame = CGRectMake(0, 0, ScreenWidth-20, 125);
//            self.makeSureBtn.hidden = NO;
//            [self.makeSureBtn setTitle:@"待评价" forState:UIControlStateNormal];
//            self.makeSureBtn.backgroundColor=R_G_B_16(0x119f17);
//        }
//    }
//    else{
//        bg.frame = CGRectMake(0, 0, ScreenWidth-20, 95);
//        self.makeSureBtn.hidden = YES;
//    }
    
    
    self.productTitle.text= _model.goodsName;
    
#warning 这个字段需要确认
//TODO:
    NSString *unitPrice=@"0";
    if ([unitPrice isEqualToString:@""] || [unitPrice isEqualToString:@"0"] || unitPrice == nil){
        
        if ([_model.deposit integerValue] == 0 || _model.deposit == nil) {
            self.productPrice.text=[NSString stringWithFormat:@"￥%@",_model.originalPrice];
        }else{
            self.productPrice.text=[NSString stringWithFormat:@"￥%.2f(订金)",[_model.deposit floatValue]];
        }
        
    }else{
        self.productPrice.text=@"0";
    }
    
    self.productNum.text = [NSString stringWithFormat:@"%@",_model.goodsCount];
    
}

@end
