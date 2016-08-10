//
//  XNROrderStateVC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/8/8.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNROrderStateVC.h"

@interface XNROrderStateVC ()
@property (nonatomic,strong)NSMutableArray *statusArr;
@end

@implementation XNROrderStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusArr = [NSMutableArray array];
    self.view.backgroundColor = R_G_B_16(0xf0f0f0);
    [self setNavigationbarTitle];
    
    [self getorderStatus];
    [self createView];
    
}
-(void)getorderStatus
{
    NSArray *nameArr = [NSArray arrayWithObjects:@"订单已提交",@"支付成功",@"卖家已发货",@"订单完成", nil];

    UIImage *image0 = [UIImage imageNamed:@"submit_orders"];
    UIImage *image1 = [UIImage imageNamed:@"payment-0"];
    UIImage *image2 = [UIImage imageNamed:@"delivery-0"];
    UIImage *image3 = [UIImage imageNamed:@"order_finished"];

    NSArray *iconArr = [NSArray arrayWithObjects:image0,image1,image2,image3, nil];
    NSArray *warningArr = [NSArray arrayWithObjects:
                           @"尊敬的客户，您的订单还未支付完成，请尽快完成付款",
                           @"尊敬的客户，请耐心等待卖家发货，如有问题可拨打客服电话联系我们",
                           @"尊敬的客户，您的订单商品已发货，请前往网点自提或确认收货",
                           @"尊敬的客户，您的订单商品已完成收货，如有问题可拨打客服电话联系我们",nil];
    
    NSArray *timeArr = [NSArray arrayWithObjects:
                        self.orderStatusModel.dateCreated?[self transformTime:self.orderStatusModel.dateCreated]:@"",
                        self.orderStatusModel.datePaid?[self transformTime:self.orderStatusModel.datePaid]:@"",
                        self.orderStatusModel.datePendingDeliver?[self transformTime:self.orderStatusModel.datePendingDeliver]:@"",
                        self.orderStatusModel.dateDelivered?[self transformTime:self.orderStatusModel.dateDelivered]:@"",
                        self.orderStatusModel.dateCompleted?[self transformTime:self.orderStatusModel.dateCompleted]:@"",
                        nil];
    
    int count;
    if ([self.orderStatusModel.orderStatus[@"type"]integerValue] == 1 ||
        [self.orderStatusModel.orderStatus[@"type"]integerValue] == 2 ||
        [self.orderStatusModel.orderStatus[@"type"]integerValue] == 7) {
        count = 1;
    }
    else if ([self.orderStatusModel.orderStatus[@"type"]integerValue] == 3)
    {
        count = 2;
    }
    else if ([self.orderStatusModel.orderStatus[@"type"]integerValue] == 4||
             [self.orderStatusModel.orderStatus[@"type"]integerValue] == 5)
    {
        count = 3;
    }
    else if ([self.orderStatusModel.orderStatus[@"type"]integerValue] == 6)
    {
        count = 4;
    }
    else if ([self.orderStatusModel.orderStatus[@"type"]integerValue] == 0)
    {
        count = 1;
    }
    for (int i=0; i<count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:nameArr[i] forKey:@"name"];
        [dic setObject:iconArr[i] forKey:@"icon"];
        [dic setObject:warningArr[i] forKey:@"warning"];
        [dic setObject:timeArr[i] forKey:@"time"];
        
        [self.statusArr addObject:dic];
    }
    if ([self.orderStatusModel.orderStatus[@"type"]integerValue] == 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"订单已关闭" forKey:@"name"];
        [dic setObject:[UIImage imageNamed:@"shut_down-0"] forKey:@"icon"];
        [dic setObject:@"尊敬的客户，您的订单已关闭，如有问题可拨打客服电话联系我们" forKey:@"warning"];
        
        [self.statusArr addObject:dic];
    }
}
-(NSString *)transformTime:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *dateFormatted = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *locationTimeString=[dateFormatter stringFromDate:dateFormatted];
    return locationTimeString;
}
-(void)createView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(19), ScreenWidth, (self.statusArr.count-1)*PX_TO_PT(140)+PX_TO_PT(217))];
    
    if ([self.orderStatusModel.orderStatus[@"type"]integerValue] == 0) {
        view.frame = CGRectMake(0, PX_TO_PT(19), ScreenWidth, (self.statusArr.count-1)*PX_TO_PT(140)+PX_TO_PT(176));
    }
    
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIView *verticalline = [[UIView alloc]init];
    verticalline.frame = CGRectMake(PX_TO_PT(37),PX_TO_PT(65), PX_TO_PT(4), view.height-PX_TO_PT(100)-PX_TO_PT(65));
    verticalline.backgroundColor = R_G_B_16(0xe3e3e3);

    if (self.statusArr.count > 1) {
        [view addSubview:verticalline];
    }
    
    CGFloat currentY = 0;
    
    for (int i=0; i<self.statusArr.count; i++) {
        
        NSDictionary *firstDic = self.statusArr[self.statusArr.count-1-i];
        UIView *firstView = [[UIView alloc]init];
        if (i==0) {
            firstView.frame =CGRectMake(0, currentY, ScreenWidth, PX_TO_PT(217));

            if (!firstDic[@"time"] || [firstDic[@"time"]isEqualToString:@""])
            {
                firstView.frame =CGRectMake(0, currentY, ScreenWidth, PX_TO_PT(176));
            }
        }
        else
        {
            firstView.frame =CGRectMake(0, currentY, ScreenWidth, PX_TO_PT(140));

        }
        

        UIButton *icon = [[UIButton alloc]initWithFrame:CGRectMake(PX_TO_PT(19), PX_TO_PT(35), PX_TO_PT(42), PX_TO_PT(42))];
        [icon setBackgroundColor:R_G_B_16(0xB0B0B0)];
        [icon setImage:firstDic[@"icon"] forState:UIControlStateNormal];
        icon.layer.cornerRadius = PX_TO_PT(21);
        icon.layer.masksToBounds = YES;
        icon.enabled = NO;
        [firstView addSubview:icon];
        
        CGRect rect = verticalline.frame;
        rect.origin.x = icon.centerX;
        verticalline.frame = rect;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+PX_TO_PT(27), PX_TO_PT(38), ScreenWidth/3, PX_TO_PT(30))];
        titleLabel.text = firstDic[@"name"];
        titleLabel.textColor = R_G_B_16(0xB0B0B0);
        titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        [firstView addSubview:titleLabel];
        CGFloat timeLabelY = CGRectGetMaxY(titleLabel.frame)+PX_TO_PT(20);
        CGFloat lineY = CGRectGetMaxY(titleLabel.frame)+PX_TO_PT(34);

        if (i ==0) {
            UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+PX_TO_PT(18), PX_TO_PT(585), PX_TO_PT(70))];
            remarkLabel.text = firstDic[@"warning"];
            remarkLabel.textColor = R_G_B_16(0x00B38A);
            remarkLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            remarkLabel.numberOfLines = 0;
            [firstView addSubview:remarkLabel];
            
            timeLabelY =CGRectGetMaxY(remarkLabel.frame)+PX_TO_PT(20);
            lineY =CGRectGetMaxY(remarkLabel.frame)+PX_TO_PT(34);

        }
        UILabel *timeLabel =[[UILabel alloc]init];
        if (firstDic[@"time"] && ![firstDic[@"time"]isEqualToString:@""])
        {
        timeLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame), timeLabelY, ScreenWidth, PX_TO_PT(22));
        timeLabel.text = firstDic[@"time"];
        timeLabel.textColor = R_G_B_16(0xB0B0B0);
        timeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        [firstView addSubview:timeLabel];
            
            lineY =CGRectGetMaxY(timeLabel.frame)+PX_TO_PT(34);

        }
        
        if (i+1 < self.statusArr.count) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(87), lineY, PX_TO_PT(601), PX_TO_PT(2))];
            line.backgroundColor = R_G_B_16(0xe0e0e0);
            [firstView addSubview:line];
        }
        
        if (i == 0) {
            [icon setBackgroundColor:R_G_B_16(0x00B38A)];
            titleLabel.textColor = R_G_B_16(0x00B38A);
            if ([self.orderStatusModel.orderStatus[@"type"]integerValue] != 0) {
                timeLabel.textColor = R_G_B_16(0x00B38A);
            }
        }
        
        
        [view addSubview:firstView];
        currentY = CGRectGetMaxY(firstView.frame)+PX_TO_PT(2);

    }
    
    CGRect rect = view.frame;
    rect.size.height = currentY;
    view.frame = rect;
    
    for (int i=0; i<2; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0+view.height*i, ScreenWidth, PX_TO_PT(2))];
        line.backgroundColor = R_G_B_16(0xe0e0e0);
        [view addSubview:line];
    }

    
}
- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单状态";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);
    
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}
-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
