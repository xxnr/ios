//
//  XNRSendView.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRSendView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_dataArr;   //数据
    int _currentPage;            //当前页
}

@property(nonatomic,copy)void(^checkOrderBlock)(NSString*orderID);//查看订单
@property (nonatomic,strong) UITableView *tableView;//信息列表
@property (retain,nonatomic) NSString *urlString;
/**
 *  重写init方法传入数据流所需要的url
 *
 */
-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString;
@end
