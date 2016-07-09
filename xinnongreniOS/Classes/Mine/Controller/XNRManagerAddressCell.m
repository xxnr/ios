//
//  XNRManagerAddressCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/5/10.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRManagerAddressCell.h"
#import "XNRAddressManageModel.h"

@interface XNRManagerAddressCell()

@property (nonatomic, strong) XNRAddressManageModel *model;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *phoneLabel;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, weak) UIButton *editorBtn;
@property (nonatomic, weak) UIButton *deleteBtn;


@end

@implementation XNRManagerAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createView];
    }
    return self;
}

-(void)createView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(20), ScreenWidth-PX_TO_PT(60), PX_TO_PT(260))];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1;
    bgView.layer.cornerRadius = 5.0;
    bgView.layer.borderColor = R_G_B_16(0xe0e0e0).CGColor;
    bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:bgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(20), PX_TO_PT(20), ScreenWidth, PX_TO_PT(32))];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = R_G_B_16(0x323232);
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.nameLabel = nameLabel;
    [bgView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(30), PX_TO_PT(20), ScreenWidth/2-PX_TO_PT(50), PX_TO_PT(32))];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.textColor = R_G_B_16(0x323232);
    phoneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.phoneLabel = phoneLabel;
    [bgView addSubview:phoneLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(20), CGRectGetMaxY(nameLabel.frame)+PX_TO_PT(20), ScreenWidth-PX_TO_PT(100), PX_TO_PT(28))];
    addressLabel.textColor = R_G_B_16(0x909090);
    addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.addressLabel = addressLabel;
    [bgView addSubview:addressLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(160), ScreenWidth-PX_TO_PT(60), 1)];
    lineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [bgView addSubview:lineView];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(PX_TO_PT(20), CGRectGetMaxY(lineView.frame)+PX_TO_PT(32), PX_TO_PT(36), PX_TO_PT(36));
    [selectBtn setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
//    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn = selectBtn;
    [bgView addSubview:selectBtn];
    
    UILabel *defaultAddress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame)+PX_TO_PT(10), CGRectGetMaxY(lineView.frame)+PX_TO_PT(36), ScreenWidth/2, PX_TO_PT(28))];
    defaultAddress.text = @"设为默认地址";
    defaultAddress.textColor = R_G_B_16(0x323232);
    defaultAddress.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [bgView addSubview:defaultAddress];
    
    
    UIButton *editorBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth/2,CGRectGetMaxY(lineView.frame)+PX_TO_PT(34),PX_TO_PT(130),PX_TO_PT(32)) ImageName:@"" Target:self Action:@selector(editorBtnClick:) Title:nil];
    [editorBtn setImage:[UIImage imageNamed:@"address_edit"] forState:UIControlStateNormal];
    [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editorBtn.titleLabel.textColor = R_G_B_16(0x323232);
    editorBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [editorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    self.editorBtn = editorBtn;
    [bgView addSubview:editorBtn];
    
    UIButton *deleteBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(editorBtn.frame)+ PX_TO_PT(24),CGRectGetMaxY(lineView.frame)+PX_TO_PT(34),PX_TO_PT(130),PX_TO_PT(32)) ImageName:@"" Target:self Action:@selector(deleteBtnClick:) Title:nil];
    [deleteBtn setImage:[UIImage imageNamed:@"address_delete"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.textColor = R_G_B_16(0x323232);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    self.deleteBtn = deleteBtn;
    [bgView addSubview:deleteBtn];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), ScreenWidth, PX_TO_PT(20))];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:footerView];
}

-(void)editorBtnClick:(UIButton *)button
{
    if (self.editorBtnBlock) {
        self.editorBtnBlock();
    }

}

-(void)deleteBtnClick:(UIButton *)button
{
    if (self.deleteCellBlock) {
        self.deleteCellBlock();
    }
}

-(void)selectBtnClick:(UIButton *)button
{

}

-(void)setCellDataWithAddressManageModel:(XNRAddressManageModel *)model
{
    _model = model;
    NSString *address1 = [NSString stringWithFormat:@"%@%@",_model.areaName,_model.cityName];
    
    NSString *address2 = [NSString stringWithFormat:@"%@%@%@",_model.areaName,_model.cityName,_model.countyName];
    if ([_model.countyName isEqualToString:@""] || _model.countyName == nil) {
        if ([_model.townName isEqualToString:@""] || _model.townName == nil) {
            self.addressLabel.text = [NSString stringWithFormat:@"%@%@",address1,_model.address];
        }else{
            self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",address1,_model.townName,_model.address];
            
        }
        
    }else{
        if ([_model.townName isEqualToString:@""] || _model.townName == nil) {
            self.addressLabel.text = [NSString stringWithFormat:@"%@%@",address2,_model.address];
        }else{
            self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",address2,_model.townName,_model.address];
        }
        
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_model.receiptPeople];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",_model.receiptPhone];
    
    if ([_model.type integerValue] == 1) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }


}




@end
