//
//  XNRMessageCell.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/30.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMessageModel.h"
@interface XNRMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) XNRMessageModel *model;

@end
