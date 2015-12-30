//
//  XNRMyCollection_Cell.m
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyCollection_Cell.h"

@implementation XNRMyCollection_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    
    if(nil==self.titleImage){
        self.titleImage=[MyControl createImageViewWithFrame:CGRectMake(10, 10, 80, 80) ImageName:@"dingcan_image_product"];
    
        [self.contentView addSubview:self.titleImage];
  
    }
    if(nil==self.title){
        
        self.title=[[UILabel alloc]initWithFrame:CGRectMake(120, 10, 200, 20)];
        self.title.textColor=R_G_B_16(0x636363);
        self.title.font=XNRFont(16);
       // self.title.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.title];
        
    }
    if(nil==self.score){
        
        self.score=[[UILabel alloc]initWithFrame:CGRectMake(120, 32, 200, 15)];
        self.score.textColor=R_G_B_16(0x92cf94);
        self.score.font=XNRFont(13);
        //self.score.backgroundColor=[UIColor yellowColor];
        [self.contentView addSubview:self.score];
        
        
    }
    if(nil==self.countPrice){
        
        self.countPrice=[[UILabel alloc]initWithFrame:CGRectMake(120, 58, 200, 20)];
        self.countPrice.textColor=R_G_B_16(0x119f17);
        self.countPrice.font=XNRFont(16);
        //self.countPrice.backgroundColor=[UIColor greenColor];
        [self.contentView addSubview:self.countPrice];
        
    }
    if(nil==self.price){
    
        self.price=[[UILabel alloc]initWithFrame:CGRectMake(120, 75, 200, 15)];
        self.price.textColor=R_G_B_16(0xb1b1b1);
        self.price.font=XNRFont(12);
        //self.price.backgroundColor=[UIColor purpleColor];
        [self.contentView addSubview:self.price];
        
        
    }
    
    if(nil==self.delBtn){
        
        self.delBtn=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth-20, 10, 15, 15) ImageName:@"close_x" Target:self Action:@selector(deleCell) Title:nil];
        //[self.contentView addSubview:self.delBtn];
        
    }
    
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(10, 105-.5, ScreenWidth-20, 0.5)];
    line.backgroundColor=R_G_B_16(0x92cf94);
    [self.contentView addSubview:line];
    

}

-(void)deleCell{
    
    //删除当前cell
    NSLog(@"dele");
    [self.delegate deleRowWithIndex:self.cellIndexPath];
    
    
}
-(void)setCellDataWithModel:(NSDictionary*)dic{
    
    self.info=dic;
    [self resetSubViews];
    [self setSubViews];
    
    
}
#pragma mark - 清空以前的数据
- (void)resetSubViews
{
    self.title.text=@"";
    self.countPrice.text=@"";
    self.price.text=@"";
    self.score.text=@"";
    
    
}

#pragma mark - 设置现在的数据

- (void)setSubViews{
    
    self.title.text=@"江淮汽车s560超值";
    self.countPrice.text=[NSString stringWithFormat:@"￥ %@",self.info[@"countPrice"]];
    self.price.text=[NSString stringWithFormat:@"原价 ￥%@",self.info[@"price"]];
    NSMutableAttributedString*AttributedString=[[NSMutableAttributedString alloc]initWithString: self.price.text];
    
   [AttributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, AttributedString.length)];
    
    //文本赋值
    [self.price setAttributedText:AttributedString];



    self.score.text=@"400积分可抵现400元";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
