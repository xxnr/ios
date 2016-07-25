//
//  XNRUpdataCell.h
//  xinnongreniOS
//
//  Created by xxnr on 16/7/25.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRUpdataCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;


-(void)upDataWithData:(NSMutableArray *)messageArray;


@end
