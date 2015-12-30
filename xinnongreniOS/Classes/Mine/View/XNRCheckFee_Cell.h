//
//  XNRCheckFee_Cell.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/5.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.

#import <UIKit/UIKit.h>

@interface XNRCheckFee_Cell : UITableViewCell

@property (nonatomic,copy) NSString *endAddress;

@property(nonatomic,retain)UILabel*productName;
@property(nonatomic,retain)UILabel*sendLine;
@property(nonatomic,retain)UILabel*productNum;
@property(nonatomic,strong) NSDictionary*info;
-(void)setCellDataWithModel:(NSDictionary*)dic;
@end
