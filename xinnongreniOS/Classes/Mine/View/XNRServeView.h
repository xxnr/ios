//
//  XNRServeView.h
//  xinnongreniOS
//
//  Created by marks on 15/5/29.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRServeView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_dataArr;   //模拟数据
    int _currentPage;            //当前页
}

@property (nonatomic, copy) void(^payBlock)();//去付款
@property(nonatomic,copy)void(^allPayBlock)();//全部结算
@property(nonatomic,copy)void(^checkOrderBlock)(NSString*orderID,NSString*orderNO);//查看订单
@property (nonatomic,strong) UIView *footView;//底部视图
@property (nonatomic,strong) UITableView*tableView;//信息列表
@property (retain,nonatomic) NSString *urlString;
@property (nonatomic,strong) UILabel *allNum;//所有商品数量
@property (nonatomic,strong) UILabel *score;//积分抵现
@property (nonatomic,strong) UILabel *totoalMoney;//总价

/**
 *  重写init方法传入数据流所需要的url
 *
 */
-(id)initWithFrame:(CGRect)frame UrlString:(NSString *)urlString;
@end
