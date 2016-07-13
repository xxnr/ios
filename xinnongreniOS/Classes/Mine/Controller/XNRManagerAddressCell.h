//
//  XNRManagerAddressCell.h
//  xinnongreniOS
//
//  Created by xxnr on 16/5/10.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRAddressManageModel;

@interface XNRManagerAddressCell : UITableViewCell

@property (nonatomic, copy) void (^editorBtnBlock)();  // 编辑
@property (nonatomic, copy) void (^deleteCellBlock)(); // 删除

-(void)setCellDataWithAddressManageModel:(XNRAddressManageModel *)model;

@end
