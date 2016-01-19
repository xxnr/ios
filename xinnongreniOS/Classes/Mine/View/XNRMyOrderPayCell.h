//
//  XNRMyOrderPayCell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderModel.h"

@interface XNRMyOrderPayCell : UITableViewCell

@property (nonatomic,strong) XNRMyOrderModel*info;
@property (nonatomic,copy)   void(^checkOrderBlock)(NSString*orderID);
- (void)setCellDataWithShoppingCartModel:(XNRMyOrderModel*)info;
@end
