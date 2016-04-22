//
//  XNRMySetterCell.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRMainItem;

@interface XNRMySetterCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** cell对应的item数据 */
@property (nonatomic, strong) XNRMainItem *item;


@end
