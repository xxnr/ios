//
//  XNRAddressManageTableViewCell.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRAddressManageModel.h"

@interface XNRAddressManageTableViewCell : UITableViewCell

@property (nonatomic,copy) void (^editorBtnBlock)();  //编辑
@property (nonatomic,copy) void (^deleteCellBlock)(); //删除

- (void)setCellDataWithAddressManageModel:(XNRAddressManageModel *)model;

@end
