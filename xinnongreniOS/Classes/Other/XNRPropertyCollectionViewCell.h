//
//  XNRPropertyCollectionViewCell.h
//  xinnongreniOS
//
//  Created by xxnr on 16/2/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XNRSKUAttributesModel.h"


@interface XNRPropertyCollectionViewCell : UICollectionViewCell

@property (nonatomic ,weak) UILabel *itemTitleLabel;

- (void)updateCellWithCellModel:(NSObject *)cellM;
@end
