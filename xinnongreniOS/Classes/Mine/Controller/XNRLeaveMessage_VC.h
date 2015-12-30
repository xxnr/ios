//
//  XNRLeaveMessage_VC.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/5.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRLeaveMessage_VC : UIViewController
@property(nonatomic,strong)NSString*orderDataId;//预处理订单id
@property(nonatomic,strong)NSString*leaveMessageStr;
@property(nonatomic,copy)void(^MessageBlock)(NSString*message);
@end
