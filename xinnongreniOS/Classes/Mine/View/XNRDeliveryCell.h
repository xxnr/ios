//
//  XNRDeliveryCell.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderModel.h"

@interface XNRDeliveryCell : UITableViewCell
@property (nonatomic,strong)XNRMyOrderModel *model;
@property (nonatomic,assign)CGFloat height;
@end
