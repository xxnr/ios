//
//  XNROrderInfoCell.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRCheckOrderModel.h"
@interface XNROrderInfoCell : UITableViewCell
@property (nonatomic,assign)CGFloat height;

-(void)setCellDataWithModel:(XNRCheckOrderModel *)model;
+(CGFloat)cellHeight;
@end
