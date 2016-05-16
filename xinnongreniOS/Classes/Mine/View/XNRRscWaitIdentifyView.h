//
//  XNRRscWaitIdentifyView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/22.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNRRscOrderModel;
typedef void(^XNRRscWaitIdentifyViewBlock)(XNRRscOrderModel *model);

@interface XNRRscWaitIdentifyView : UIView

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) XNRRscWaitIdentifyViewBlock com;

@end
