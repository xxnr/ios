//
//  XNRShoppingCartTableViewCell.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRShoppingCartModel.h"

@interface XNRShoppingCartTableViewCell : UITableViewCell

//改变底部总计和已节省
@property (nonatomic, copy) void(^changeBottomBlock)();
//删除
@property (nonatomic, copy) void(^deleteBlock)();

- (void)setCellDataWithShoppingCartModel:(XNRShoppingCartModel *)model;

@end
