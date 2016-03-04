//
//  XNRPropertyCollectionViewCell.m
//  xinnongreniOS
//
//  Created by xxnr on 16/2/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRPropertyCollectionViewCell.h"

@implementation XNRPropertyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    UILabel *itemTitleLabel = [[UILabel alloc] init];
    itemTitleLabel.frame = self.bounds;
    itemTitleLabel.layer.cornerRadius = 5.0;
    itemTitleLabel.layer.masksToBounds = YES;
    itemTitleLabel.textColor = R_G_B_16(0x646464);
    itemTitleLabel.backgroundColor = R_G_B_16(0xf0f0f0);
    itemTitleLabel.font = [UIFont systemFontOfSize:12.0];
    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
//    itemTitleLabel.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
//    itemTitleLabel.layer.borderWidth = .5;
    self.itemTitleLabel = itemTitleLabel;
    [self.contentView addSubview:itemTitleLabel];

}

- (void)updateCellWithCellModel:(NSObject *)cellM {
    
    if ([cellM isKindOfClass:[XNRSKUCellModel class]]) {
        XNRSKUCellModel *skuCellModel = (XNRSKUCellModel *)cellM;
        self.itemTitleLabel.text = skuCellModel.cellValue;
        self.itemTitleLabel.textColor = skuCellModel.isEnable?R_G_B_16(0x323232):R_G_B_16(0xD0D0D0);
        self.itemTitleLabel.backgroundColor = skuCellModel.isSelected?R_G_B_16(0xfe9b00):R_G_B_16(0xf0f0f0);
        if (skuCellModel.isEnable) {
            self.itemTitleLabel.textColor = skuCellModel.isSelected?R_G_B_16(0xffffff):R_G_B_16(0x323232);
        }
    } else {
        
        XNRAddtionsModel *addModel = (XNRAddtionsModel *)cellM;
        self.itemTitleLabel.text = [NSString stringWithFormat:@"%@(%@)",addModel.name,addModel.price];
        self.itemTitleLabel.backgroundColor = addModel.isSelected?R_G_B_16(0xfe9b00):R_G_B_16(0xf0f0f0);
        self.itemTitleLabel.textColor = addModel.isSelected?R_G_B_16(0xffffff):R_G_B_16(0x323232);
    }
}

@end
