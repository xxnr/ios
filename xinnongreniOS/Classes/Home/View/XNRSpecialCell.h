//
//  XNRSpecialCell.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/27.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRShoppingCartModel.h"

@interface XNRSpecialCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setCellDataWithShoppingCartModel:(XNRShoppingCartModel *)model;


@end
