//
//  XNRSubOrderCell.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRNSubOrdersModel.h"
@interface XNRSubOrderCell : UITableViewCell
@property (nonatomic,copy) NSString *value;

-(void)setCellDataWithModel:(XRNSubOrdersModel *)model;
+(void)isFirstPay;
@end
