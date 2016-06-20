//
//  XNRRscDetialDeliverCell.h
//  xinnongreniOS
//
//  Created by xxnr on 16/6/6.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRRscDeliverFrameModel;

@interface XNRRscDetialDeliverCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic ,strong) XNRRscDeliverFrameModel *frameModel;


@end
