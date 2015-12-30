//
//  XNRMyEvaluation_Cell.m
//  xinnongreniOS
//
//  Created by marks on 15/5/27.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyEvaluation_Cell.h"
#import "UIImageView+WebCache.h"
@implementation XNRMyEvaluation_Cell

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
        self.titleImage=[MyControl createImageViewWithFrame:CGRectMake(10, 10, 80, 80) ImageName:@"001"];
        self.titleImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.titleImage];
        
    }
    if(nil==self.title){
        
        self.title=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 200, 20)];
        self.title.textColor=R_G_B_16(0x636363);
        self.title.font=XNRFont(16);
        [self.contentView addSubview:self.title];
        
    }
    if(nil==self.content){
        
        self.content=[[UILabel alloc]initWithFrame:CGRectMake(110, 40, ScreenWidth-110-30, 40)];
        self.content.textColor=R_G_B_16(0xbdbdbd);
        self.content.font=XNRFont(14);
        self.content.numberOfLines=0;
        [self.contentView addSubview:self.content];
        
    }
    
    if(nil==self.delBtn){
        
        self.delBtn=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth-20, 45, 15, 15) ImageName:@"close_x" Target:self Action:@selector(deleCell) Title:nil];
      
        
    }
    
    
    _line=[[UIView alloc]initWithFrame:CGRectMake(10, 105-.5, ScreenWidth-20, 0.5)];
    _line.backgroundColor=R_G_B_16(0x92cf94);
    [self.contentView addSubview:_line];
    
}

-(void)deleCell{
    
    //删除当前cell
    NSLog(@"dele");
    [self.delegate deleRowWithIndex:self.cellIndexPath];
    
    
}
-(void)setCellDataWithModel:(XNRMyEvaluationModel*)dic{
    
    self.info=dic;
    [self resetSubViews];
    [self setSubViews];
    
    
}
#pragma mark - 清空以前的数据
- (void)resetSubViews
{
    self.title.text=@"";
    self.content.text=@"";

}

#pragma mark - 设置现在的数据

- (void)setSubViews{
    
    self.title.text=self.info.goodsName;
    self.content.text=self.info.content;
    //图片
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,self.info.imgUrl]] placeholderImage:[UIImage imageNamed:@"001.png"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
