//
//  XNRMessageCell.m
//  xinnongreniOS
//
//  Created by xxnr on 15/11/30.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRMessageCell.h"
#import "UIImageView+WebCache.h"

@interface XNRMessageCell()

@property (nonatomic, weak) UIImageView *imgView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic ,weak) UILabel *datecreatedLabel;

@end

@implementation XNRMessageCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellID";
    XNRMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XNRMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    CGFloat margin = PX_TO_PT(24);
    CGFloat marginLabel = PX_TO_PT(26);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(20), PX_TO_PT(200), PX_TO_PT(150))];
    imgView.layer.borderWidth = 1.0;
    imgView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;

    self.imgView = imgView;
    [self addSubview:imgView];
    
    CGFloat titleLabelX = CGRectGetMaxX(self.imgView.frame) + margin;
    CGFloat titleLabelY = PX_TO_PT(30);
    CGFloat titleLabelW = ScreenWidth - titleLabelX-PX_TO_PT(32);
    CGFloat titleLabelH = PX_TO_PT(80);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX,titleLabelY,titleLabelW,titleLabelH)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.tintColor = R_G_B_16(0xc5c5c5);
    titleLabel.numberOfLines = 0;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UILabel *datecreatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX,CGRectGetMaxY(self.titleLabel.frame) + marginLabel,titleLabelW,PX_TO_PT(20))];
    datecreatedLabel.font = [UIFont systemFontOfSize:12];
    datecreatedLabel.tintColor = R_G_B_16(0x646464);
    self.datecreatedLabel = datecreatedLabel;
    [self addSubview:datecreatedLabel];

}
-(void)setModel:(XNRMessageModel *)model{
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    self.titleLabel.text = model.title;
    
    NSString *netDateString = [NSString stringWithFormat:@"%@",model.datecreated];
    NSArray *dateArr = [netDateString componentsSeparatedByString:@"T"];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dataFormatter stringFromDate:[dataFormatter dateFromString:[dateArr firstObject]]];
    self.datecreatedLabel.text = [NSString stringWithFormat:@"%@",date];
}
@end
