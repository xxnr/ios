//
//  XNRCheckFee_Cell.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/5.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRCheckFee_Cell.h"

@implementation XNRCheckFee_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI{

    
    if(nil==self.productName){
        
        self.productName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 135, 44)];
        self.productName.numberOfLines = 0;
        self.productName.textColor=R_G_B_16(0x0e7919);
        self.productName.font=XNRFont(12) ;
        
        self.productName.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.productName];
    }
    if(nil==self.productNum){
        
        self.productNum=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-20-110, 10+25, 70, 25)];
        self.productNum.font=XNRFont(13);
        self.productNum.center=CGPointMake(ScreenWidth/2, 45/2);
        self.productNum.textAlignment=NSTextAlignmentCenter;
        self.productNum.textColor=R_G_B_16(0x068c0f);
        self.productNum.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.productNum];
        
    }
    if(nil==self.sendLine){
        
        self.sendLine=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-10-130, 10, 130, 25)];
        self.sendLine.textColor=R_G_B_16(0x757575);
        self.sendLine.font=XNRFont(13);
        
        self.sendLine.textAlignment=NSTextAlignmentRight;
      
        [self.contentView addSubview:self.sendLine];
        
    }
    
    
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(0, 45-.3, ScreenWidth, .3)];
    line.alpha=.3;
    line.backgroundColor=[UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    
}


-(void)setCellDataWithModel:(NSDictionary*)dic{
    
    self.info=dic;
    [self resetSubViews];
    [self setSubViews];
    
    
}
#pragma mark - 清空以前的数据
- (void)resetSubViews
{
    
}

#pragma mark - 设置现在的数据
- (void)setSubViews{
    
    self.productName.text=self.info[@"goodsName"];
    self.productNum.text=[NSString stringWithFormat:@"x %@",self.info[@"goodsCount"]];
    NSLog(@"shsidhsids%@",self.info[@"habitatName"]);
    self.sendLine.text=[NSString stringWithFormat:@"%@ —— %@",self.info[@"habitatName"],self.endAddress];
    
    NSString *habitatname = self.info[@"habitatName"];
    
    NSMutableAttributedString*AttributedString=[[NSMutableAttributedString alloc]initWithString:self.sendLine.text];
    [AttributedString addAttribute:NSForegroundColorAttributeName value:R_G_B_16(0x13c322) range:NSMakeRange(habitatname.length, 4)];
    [self.sendLine setAttributedText:AttributedString];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
