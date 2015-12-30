//
//  XNRProductInfo_cell.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/7.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRProductInfo_model.h"

@interface XNRProductInfo_cell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) XNRProductInfo_model *model;

@end
