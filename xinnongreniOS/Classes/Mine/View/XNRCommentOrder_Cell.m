//
//  XNRCommentOrder_Cell.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRCommentOrder_Cell.h"

@implementation XNRCommentOrder_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI{

    UIView*bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
    bg.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:bg];
    //主题图片
    self.titleImage=[MyControl createImageViewWithFrame:CGRectMake(10, 20, 80, 80) ImageName:@"dingcan_image_product"];
    [bg addSubview:self.titleImage];
    //主题
    self.title=[[UILabel alloc]initWithFrame:CGRectMake(110, 20, 200, 20)];
    self.title.textColor=R_G_B_16(0x636363);
    self.title.font=XNRFont(16);
    [bg addSubview:self.title];
    //现价
    self.countPrice=[[UILabel alloc]initWithFrame:CGRectMake(110, 65, 200, 20)];
    self.countPrice.textColor=R_G_B_16(0x119f17);
    self.countPrice.font=XNRFont(16);
    [bg addSubview:self.countPrice];
    //原价
    self.price=[[UILabel alloc]initWithFrame:CGRectMake(110, 85, 200, 15)];
    self.price.textColor=R_G_B_16(0xb1b1b1);
    self.price.font=XNRFont(11);
    [bg addSubview:self.price];
    
        _starRateView=[[CWStarRateView alloc]initWithFrame:CGRectMake(110, 125, 120, 25)];
    _starRateView.scorePercent = 0;
    _starRateView.delegate=self;
    _starRateView.allowIncompleteStar = NO;
    _starRateView.hasAnimation = NO;
    [bg addSubview:_starRateView];
}
-(void)setCellDataWithModel:(XNRShoppingCartModel*)dic{
    
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
    self.title.text=self.info.goodName;
    self.countPrice.text=[NSString stringWithFormat:@"￥ %.2f",self.info.unitPrice];
    self.price.text=[NSString stringWithFormat:@"原价￥%@",self.info.originalPrice];
    NSMutableAttributedString*AttributedString=[[NSMutableAttributedString alloc]initWithString:self.price.text];
    
    [AttributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, AttributedString.length)];
    
    //文本赋值
    [self.price setAttributedText:AttributedString];
 
    
       
}
- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    
    NSLog(@"newScorePercent-->%f",newScorePercent);
    
    if(newScorePercent==0){
        
        [self.info setValue:@"0" forKey:@"isMark"];
        
    }else{
        
        [self.info setValue:@"1" forKey:@"isMark"];
    }

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
