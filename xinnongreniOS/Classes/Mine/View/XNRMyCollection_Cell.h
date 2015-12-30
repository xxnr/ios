//
//  XNRMyCollection_Cell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyCollectionCellDelegate <NSObject>
@optional
-(void)deleRowWithIndex:(NSIndexPath *)indexPath;

@end


@interface XNRMyCollection_Cell : UITableViewCell

@property(nonatomic,copy)NSIndexPath *cellIndexPath;
@property(nonatomic,assign)id<MyCollectionCellDelegate>delegate;

@property(nonatomic,retain)UILabel*title;//主题
@property(nonatomic,retain)UILabel*countPrice;//折后价
@property(nonatomic,retain)UILabel*price;//原价
@property(nonatomic,retain)UILabel*score;//积分折现
@property(nonatomic,retain)UIButton*delBtn;//删除

@property(nonatomic,retain)UIImageView*titleImage;//图标

@property(nonatomic,copy)  NSDictionary*info;
-(void)setCellDataWithModel:(NSDictionary*)model;
@end
