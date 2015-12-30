//
//  XNRMyscore_Cell.m
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyscore_Cell.h"

@implementation XNRMyscore_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    if(nil==self.date){
        
        self.date=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 130, 20)];
        self.date.textColor=R_G_B_16(0x8b8b8b);
        self.date.font=XNRFont(13) ;
        //self.date.backgroundColor=[UIColor yellowColor];
        [self.contentView addSubview:self.date];
    }
//    if(nil==self.custom){
//        
//        
//        self.custom=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-20, 15, 100, 20)];
//        self.custom.font=XNRFont(13);
//        
//        self.custom.textColor=R_G_B_16(0x8b8b8b);
//        //self.custom.backgroundColor=[UIColor redColor];
//        [self.contentView addSubview:self.custom];
//        
//    }
    if(nil==self.score){
        
        self.score=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-200, 15, 150, 20)];
        
        self.score.textColor=R_G_B_16(0x8b8b8b);
        self.score.font=XNRFont(13);
        [self.contentView addSubview:self.score];
        
    }
    
    
}
-(void)setCellDataWithModel:(XNRMyScoreModel*)dic{
    
    self.info=dic;
    [self resetSubViews];
    [self setSubViews];
    
    
}
#pragma mark - 清空以前的数据
- (void)resetSubViews
{
    self.score.text          = @"";
  
    self.date.text           = @"";
    
}

#pragma mark - 设置现在的数据
- (void)setSubViews{
      BOOL flag = [self.info.pointAction isEqualToString:@"1"];
    NSLog(@"flag-->%d",flag);
    self.date.text= [CommonTool standardTime:self.info.createTime];
  
    self.score.text=[NSString stringWithFormat:@"%@%@积分",flag?@"获得":@"消费",self.info.pointNum];

    NSMutableAttributedString*AttributedString2=[[NSMutableAttributedString alloc]initWithString:self.score.text];
    
    [AttributedString2 addAttribute:NSForegroundColorAttributeName value:!flag?[UIColor redColor]:[UIColor greenColor] range:NSMakeRange(2, self.score.text.length-4)];
    [self.score setAttributedText:AttributedString2];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
