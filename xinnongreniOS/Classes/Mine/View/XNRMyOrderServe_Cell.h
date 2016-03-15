//
//  XNRMyOrderServe_Cell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderModel.h"
@interface XNRMyOrderServe_Cell : UITableViewCell

@property (nonatomic,strong) UILabel *orderNum;       //订单号
@property (nonatomic,strong) UILabel *allPrice;
@property (nonatomic,copy)   void(^checkOrderBlock)(NSString*orderID);                                        //查看订单                                       //查看订单
- (void)setCellDataWithShoppingCartModel:(XNRMyOrderModel*)info;

@property (nonatomic ,strong) NSMutableArray *attributesArray;

@property (nonatomic ,strong) NSMutableArray *addtionsArray;




@end
