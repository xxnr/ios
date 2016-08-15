//
//  XNRShoppingCartTableViewCell.h
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRShoppingCartModel.h"
@class XNRShoppingCarFrame;

typedef void(^XNRShoppingCartTableViewCellBlock)(NSIndexPath *indexP);

typedef void(^XNRShoppingCartTableViewCellDeleteBtnBlock)(NSIndexPath *indexP);



@protocol XNRShoppingCartTableViewCellDelegate <NSObject>
@optional;
-(void)XNRShoppingCartTableViewCellBtnClickWith:(UITextField *) numTextField;

@end
@interface XNRShoppingCartTableViewCell : UITableViewCell

@property (nonatomic ,assign) id<XNRShoppingCartTableViewCellDelegate>delegate;

//改变底部总计和已节省
@property (nonatomic, copy) void(^changeBottomBlock)();
//删除
@property (nonatomic, copy) void(^deleteBlock)();

@property(assign,nonatomic) BOOL selectState;//选中状态

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) XNRShoppingCarFrame *shoppingCarFrame;

@property (nonatomic, copy) XNRShoppingCartTableViewCellBlock pushBlock;

@property (nonatomic, copy) XNRShoppingCartTableViewCellDeleteBtnBlock deleteBtnBlock;


@property (nonatomic, copy) NSString *rightString;

-(void)reframeToNormal;



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCom:(void(^)(NSIndexPath *indexPath))com;
@end
