//
//  XNRCommentOrder_Cell.h
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
#import "XNRShoppingCartModel.h"
@interface XNRCommentOrder_Cell : UITableViewCell<CWStarRateViewDelegate>
/**
 *  主题图片
 */
@property(nonatomic,retain)UIImageView*titleImage;
/**
 *  主题
 */
@property(nonatomic,retain)UILabel*title;
/**
 *  
 */
@property(nonatomic,retain)UILabel*score;
/**
 *  现价
 */
@property(nonatomic,retain)UILabel*countPrice;
/**
 *  原价
 */
@property(nonatomic,retain)UILabel*price;
/**
 *  星级评分
 */
@property(nonatomic,retain)UILabel*starRate;
/**
 *  评分
 */
@property(nonatomic,retain)CWStarRateView*starRateView;
@property(nonatomic,strong) XNRShoppingCartModel*info;
-(void)setCellDataWithModel:(NSDictionary*)dic;
@end
