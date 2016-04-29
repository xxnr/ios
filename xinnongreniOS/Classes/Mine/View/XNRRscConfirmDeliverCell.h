//
//  XNRRscConfirmDeliverCell.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/27.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRRscDeliverFrameModel;
@interface XNRRscConfirmDeliverCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic ,strong) XNRRscDeliverFrameModel *frameModel;  


@end
