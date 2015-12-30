//
//  XNROderInfo_Cell.h
//  xinnongreniOS
//  Created by 张国兵 on 15/6/5.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.


#import <UIKit/UIKit.h>
#import "XNRCheckOrderModel.h"
#import "XNRShoppingCartModel.h"
@interface XNROderInfo_Cell : UITableViewCell
@property(nonatomic,retain)UILabel*productTitle;
@property(nonatomic,retain)UILabel*productPrice;
@property(nonatomic,retain)UILabel*productNum;
@property(nonatomic,copy)void(^commentGoodBlock)(XNRCheckOrderModel*goodModel);//商品详情
@property (nonatomic,copy) void(^refreshBlock)();
@property(nonatomic,strong)  XNRCheckOrderModel*model;
-(void)setCellDataWithModel:(XNRCheckOrderModel*)model;
//
//@property (nonatomic ,strong) XNRShoppingCartModel *model;
//-(void)setCellDataWithModel:(XNRShoppingCartModel *)model;
@end
