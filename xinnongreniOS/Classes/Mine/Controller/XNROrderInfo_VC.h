//
//  XNROrderInfo_VC.h
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNROrderInfo_VC : UIViewController

@property (nonatomic ,copy) NSString *shopCarID;

@property(nonatomic,copy) NSString *productId;

@property (nonatomic ,copy) NSString *num;

@property(nonatomic, assign) CGFloat totalPrice;

@property(nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) NSMutableArray *idArray;

@property (nonatomic ,assign) BOOL isRoot;

@end
