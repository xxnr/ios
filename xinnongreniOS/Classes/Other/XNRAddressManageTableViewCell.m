//
//  XNRAddressManageTableViewCell.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRAddressManageTableViewCell.h"

@interface XNRAddressManageTableViewCell ()
 
@property (nonatomic,strong) XNRAddressManageModel *model;

@property (nonatomic ,weak) UIView *bgView;

@property (nonatomic ,weak) UILabel *defaultLabel;

@property (nonatomic ,weak) UIButton *selectBtn;

@property (nonatomic,weak) UILabel *addressNamelabel;

@property (nonatomic ,weak) UILabel *phoneLabel;

@property (nonatomic ,weak) UILabel *nameLabel;

@property (nonatomic,weak) UIButton *editorBtn;

@property (nonatomic,weak) UIButton *deleteBtn;


@end
@implementation XNRAddressManageTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createUI];
//        self.selectBtn.selected = self.model.selected;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += PX_TO_PT(20);//整体向下 移动10
    frame.size.height -= 10;//间隔为10
    [super setFrame:frame];
}



- (void)createUI
{
    [self createAddressNamelabel];

}


#pragma mark - 地址
- (void)createAddressNamelabel
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(20), 0, ScreenWidth-PX_TO_PT(40), PX_TO_PT(220))];
    bgView.layer.borderWidth = PX_TO_PT(2);
    bgView.layer.cornerRadius = 5.0;
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderColor = R_G_B_16(0xe0e0e0).CGColor;
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor =[UIColor whiteColor];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    // 选择按钮
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(PX_TO_PT(26), PX_TO_PT(50), PX_TO_PT(36), PX_TO_PT(36));
    [selectBtn setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn = selectBtn;
    [bgView addSubview:selectBtn];
    // 姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectBtn.frame) + PX_TO_PT(22), PX_TO_PT(30), PX_TO_PT(150), PX_TO_PT(36))];
    nameLabel.textColor = R_G_B_16(0x323232);
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    self.nameLabel = nameLabel;
    [bgView addSubview:nameLabel];
    // 电话
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + PX_TO_PT(22), PX_TO_PT(30), PX_TO_PT(220), PX_TO_PT(36))];
    phoneLabel.textColor = R_G_B_16(0x323232);
    phoneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    self.phoneLabel = phoneLabel;
    [bgView addSubview:phoneLabel];
    
    // 默认
    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneLabel.frame) + PX_TO_PT(24), PX_TO_PT(30), PX_TO_PT(90), PX_TO_PT(36))];
    defaultLabel.layer.cornerRadius = 3.0;
    defaultLabel.layer.masksToBounds = YES;
    defaultLabel.textAlignment = NSTextAlignmentCenter;
    defaultLabel.backgroundColor = R_G_B_16(0xfe9b00);
    defaultLabel.textColor = [UIColor whiteColor];
    defaultLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    defaultLabel.text = @"默认";
    self.defaultLabel = defaultLabel;
    [bgView addSubview:defaultLabel];
    
    // 地址
    UILabel *addressNamelabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.selectBtn.frame) + PX_TO_PT(22), CGRectGetMaxY(self.nameLabel.frame), ScreenWidth-CGRectGetMaxX(self.selectBtn.frame) -PX_TO_PT(22)-PX_TO_PT(64), 36)];
    addressNamelabel.textColor = R_G_B_16(0x909090);
//    addressNamelabel.adjustsFontSizeToFitWidth = YES;
//    addressNamelabel.backgroundColor = [UIColor redColor];
//    addressNamelabel.numberOfLines = 0;
    addressNamelabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    addressNamelabel.textAlignment = NSTextAlignmentLeft;
    self.addressNamelabel = addressNamelabel;
    [bgView addSubview:addressNamelabel];
    
    UIButton *editorBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth/2,CGRectGetMaxY(self.addressNamelabel.frame),PX_TO_PT(130),PX_TO_PT(32)) ImageName:@"" Target:self Action:@selector(editorBtnClick:) Title:nil];
    [editorBtn setImage:[UIImage imageNamed:@"address_edit"] forState:UIControlStateNormal];
    [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editorBtn.titleLabel.textColor = R_G_B_16(0x323232);
    editorBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [editorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    self.editorBtn = editorBtn;
    [bgView addSubview:editorBtn];
    
    UIButton *deleteBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.editorBtn.frame)+ PX_TO_PT(24),CGRectGetMaxY(self.addressNamelabel.frame),PX_TO_PT(130),PX_TO_PT(32)) ImageName:@"" Target:self Action:@selector(deleteBtnClick:) Title:nil];
    [deleteBtn setImage:[UIImage imageNamed:@"address_delete"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.textColor = R_G_B_16(0x323232);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    self.deleteBtn = deleteBtn;
    [bgView addSubview:deleteBtn];
}

-(void)selectBtnClick:(UIButton *)button{
    
    
//    button.selected = !button.selected;
//    self.selectedBlock();

}


- (void)editorBtnClick:(UIButton *)button
{
    self.editorBtnBlock();
}

- (void)deleteBtnClick:(UIButton *)button
{
    BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"确认要删除该地址吗?" chooseBtns:@[@"取消",@"确定"]];
    alertView.chooseBlock = ^void(UIButton *btn){
        if (btn.tag == 11) {
            self.deleteCellBlock();
        }
    };
    [alertView BMAlertShow];
}

#pragma mark - 设置model数据模型的数据
- (void)setCellDataWithAddressManageModel:(XNRAddressManageModel *)model {
    _model = model;
    
    self.selectBtn.selected = _model.selected;
    
    [self setSubViews];
}


#pragma mark - 设置现在的数据
- (void)setSubViews
{
    NSString *address1 = [NSString stringWithFormat:@"%@%@",_model.areaName,_model.cityName];
    NSString *address2 = [NSString stringWithFormat:@"%@%@%@",_model.areaName,_model.cityName,_model.countyName];
    if ([_model.countyName isEqualToString:@""] || _model.countyName == nil) {
        if ([_model.townName isEqualToString:@""] || _model.townName == nil) {
            self.addressNamelabel.text = [NSString stringWithFormat:@"%@%@",address1,_model.address];
        }else{
            self.addressNamelabel.text = [NSString stringWithFormat:@"%@%@%@",address1,_model.townName,_model.address];

        }

    }else{
        if ([_model.townName isEqualToString:@""] || _model.townName == nil) {
            self.addressNamelabel.text = [NSString stringWithFormat:@"%@%@",address2,_model.address];
        }else{
            self.addressNamelabel.text = [NSString stringWithFormat:@"%@%@%@",address2,_model.townName,_model.address];
        }
    
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_model.receiptPeople];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",_model.receiptPhone];
    
    if ([_model.type integerValue] == 1) {
        self.defaultLabel.hidden = NO;
    }else{
        self.defaultLabel.hidden = YES;
    }
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
