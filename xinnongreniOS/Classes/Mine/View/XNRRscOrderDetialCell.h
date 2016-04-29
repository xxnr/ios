//
//  XNRRscOrderDetialCell.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/29.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRRscOrderDetialFrameModel;

@interface XNRRscOrderDetialCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) XNRRscOrderDetialFrameModel *frameModel;

@end
