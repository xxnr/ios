//
//  XNRHomeCollectionViewCell.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/27.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRShoppingCartModel.h"

@interface XNRHomeCollectionViewCell : UICollectionViewCell

- (void)setCellDataWithShoppingCartModel:(XNRShoppingCartModel *)model;

@end
