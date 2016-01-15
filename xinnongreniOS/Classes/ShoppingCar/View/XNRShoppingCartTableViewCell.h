//
//  XNRShoppingCartTableViewCell.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRShoppingCartModel.h"

@protocol XNRShoppingCartTableViewCellDelegate <NSObject>
@optional;
-(void)XNRShoppingCartTableViewCellBtnClickWith:(NSIndexPath *)indexPath;

@end
@interface XNRShoppingCartTableViewCell : UITableViewCell

@property (nonatomic ,assign) id<XNRShoppingCartTableViewCellDelegate>delegate;

//改变底部总计和已节省
@property (nonatomic, copy) void(^changeBottomBlock)();
//删除
@property (nonatomic, copy) void(^deleteBlock)();

@property(assign,nonatomic)BOOL selectState;//选中状态
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setCellDataWithShoppingCartModel:(XNRShoppingCartModel *)model;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCom:(void(^)(NSIndexPath *indexPath))com;
@end
