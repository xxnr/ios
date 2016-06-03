//
//  XNRMyRepresent_cell.h
//  xinnongreniOS
//
//  Created by xxnr on 15/11/15.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyRepresentModel.h"

@interface XNRMyRepresent_cell : UITableViewCell

@property (nonatomic, strong) XNRMyRepresentModel *model;
@property (nonatomic ,weak) UIImageView *redImageView;

//- (void)setCellDataWithRepresentModel:(XNRMyRepresentModel *)model;

@end
