//
//  XNRMakeSureView.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRMyOrderSectionModel.h"
@interface XNRMakeSureView : UIView
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong)NSString *orderId;
-(void)createview;
@end
