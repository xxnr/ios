//
//  XNRRscMyOrderStateCell.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/25.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRRscSkusFrameModel;

@interface XNRRscMyOrderStateCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong) XNRRscSkusFrameModel *frameModel;

@end
