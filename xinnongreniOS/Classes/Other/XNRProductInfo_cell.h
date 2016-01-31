//
//  XNRProductInfo_cell.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/7.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRProductInfo_model.h"

@protocol XNRProductInfo_cellDelegate <NSObject>

@optional;

-(void)XNRProductInfo_cellScroll;

@end

@interface XNRProductInfo_cell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) XNRProductInfo_model *model;

@property (nonatomic ,assign) id<XNRProductInfo_cellDelegate>delegate;

@end
