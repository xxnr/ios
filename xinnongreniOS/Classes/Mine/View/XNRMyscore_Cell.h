//
//  XNRMyscore_Cell.h
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyScoreModel.h"
@interface XNRMyscore_Cell : UITableViewCell
@property(nonatomic,retain)UILabel*date;
//@property(nonatomic,retain)UILabel*custom;
@property(nonatomic,retain)UILabel*score;
@property(nonatomic,strong)  XNRMyScoreModel*info;
-(void)setCellDataWithModel:(XNRMyScoreModel*)model;
@end
