//
//  XNRProductInfo_cell.h
//  xinnongreniOS
//
//  Created by xxnr on 15/12/7.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNRProductInfo_model.h"
#import "XNRShoppingCartModel.h"
@class XNRProductInfo_frame;
typedef void(^XNRProductInfo_cellBlock)(NSMutableArray *_dataArray,CGFloat totalPrice,NSString *totalNumber);
typedef void(^XNRProductInfo_cellLoginBlock)();



@protocol XNRProductInfo_cellDelegate <NSObject>

@optional;

-(void)XNRProductInfo_cellScroll:(UIViewController *)photoBroser;

@end

@interface XNRProductInfo_cell : UITableViewCell

@property (nonatomic ,copy) XNRProductInfo_cellBlock con;

@property (nonatomic ,copy) XNRProductInfo_cellLoginBlock logincom;

@property (nonatomic ,copy) NSString *goodsId;

@property (nonatomic ,strong) XNRShoppingCartModel *shopcarModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) XNRProductInfo_frame *infoFrame;

@property (nonatomic ,assign) id<XNRProductInfo_cellDelegate>delegate;

@property (nonatomic ,strong) NSMutableArray *attributes;
@property (nonatomic ,strong) NSMutableArray *additions;
@property (nonatomic ,copy) NSString *marketPrice;
@property (nonatomic ,copy) NSString *Price;


@end
