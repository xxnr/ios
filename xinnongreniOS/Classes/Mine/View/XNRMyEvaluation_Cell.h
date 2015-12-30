//
//  XNRMyEvaluation_Cell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/27.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.


#import <UIKit/UIKit.h>
#import "XNRMyEvaluationModel.h"
@protocol MyEvaluationCellDelegate <NSObject>
@optional
-(void)deleRowWithIndex:(NSIndexPath *)indexPath;

@end
@interface XNRMyEvaluation_Cell : UITableViewCell
@property(nonatomic,copy)NSIndexPath *cellIndexPath;
@property(nonatomic,assign)id<MyEvaluationCellDelegate>delegate;

@property(nonatomic,retain)UILabel*title;//主题
@property(nonatomic,retain)UILabel*content;//评价内容
@property(nonatomic,retain)UIButton*delBtn;//删除
@property(nonatomic,retain)UIImageView*titleImage;//图标
@property(nonatomic,retain) UIView*line;
@property(nonatomic,strong)  XNRMyEvaluationModel*info;
-(void)setCellDataWithModel:(XNRMyEvaluationModel*)model;
@end
