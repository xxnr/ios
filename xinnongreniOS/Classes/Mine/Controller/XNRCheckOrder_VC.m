//
//  XNRCheckOrder_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRCheckOrder_VC.h"
#import "XNRAddressManageViewController.h"
#import "XNROderInfo_Cell.h"
#import "XNRPayTypeViewController.h"
#import "XNRCheckFee_VC.h"
#import "XNRLeaveMessage_VC.h"
#import "XNRCheckOrderModel.h"
#import "XNREvaluationOrder_VC.h"
@interface XNRCheckOrder_VC ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray*_dataArray;
    UILabel*namelabel; //收货人
    UILabel*phoneNum;  //收货电话
}

@property(nonatomic,retain)UITableView*tableview;
@property (nonatomic,strong) UILabel *dateDetail;
@property (nonatomic,strong) UILabel*addressDetail;
@property (nonatomic,strong)UILabel*leaveMessage;
@property (nonatomic,strong)UILabel*countPriceDetail;
@property (nonatomic,strong)UILabel*totalPriceDetail;

@end

@implementation XNRCheckOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    _dataArray=[[NSMutableArray alloc]init];
    //中部视图
    [self createMid];
    //创建头视图
    [self createHeadView];
    //底部视图
    [self createFoot];
    //获取网络数据
    [self getDataWithUrl:@"order"];
    
    [self createBottomView];
    
    
}
#pragma mark-创建底部视图
-(void)createBottomView{
    
    UIView *bootomView=[[UIView alloc]initWithFrame:CGRectMake(10, ScreenHeight-64-49, ScreenWidth-20, 49)];
    bootomView.backgroundColor=[UIColor whiteColor];

    //取消订单
    UIButton*cancelOrder=[MyControl createButtonWithFrame:CGRectMake(30, 10, 100, 30) ImageName:nil Target:self Action:@selector(cancelOrder) Title:@"取消订单"];
    [cancelOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelOrder.clipsToBounds=YES;
    cancelOrder.layer.cornerRadius=5;
    cancelOrder.backgroundColor=[UIColor lightGrayColor];
    cancelOrder.titleLabel.font=XNRFont(14);
    [bootomView addSubview:cancelOrder];
    
    //去结算
    UIButton*goPay=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth-150, 10, 100, 30) ImageName:nil Target:self Action:@selector(goPay) Title:@"全部结算"];
    goPay.titleLabel.font=XNRFont(14);
    goPay.clipsToBounds=YES;
    goPay.layer.cornerRadius=5;
    goPay.backgroundColor=R_G_B_16(0x0e9f14);
    [goPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bootomView addSubview:goPay];
    
}
#pragma mark--去结算
-(void)goPay{
    
    NSLog(@"去结算");
}
-(void)cancelOrder{
    
     NSLog(@"取消订单");
    
}
- (void)getDataWithUrl:(NSString *)urlStr
{
    [KSHttpRequest post:KGetOrderDetails parameters:@{@"userId":[DataCenter account].userid,@"orderId":self.orderID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        NSDictionary *datasDic = result[@"datas"];
        
        namelabel.text = datasDic[@"rows"][@"recipientName"];   //收货人
        phoneNum.text = datasDic[@"rows"][@"recipientPhone"];   //收货电话
        _dateDetail.text = datasDic[@"rows"][@"deliveryTime"];  //期望到货日期
        _addressDetail.text=datasDic[@"rows"][@"address"];      //地址
        _leaveMessage.text=datasDic[@"rows"][@"remarks"];       //留言
        
        for(NSDictionary*dic in datasDic[@"rows"][@"orderGoodsList"]){
            
            XNRCheckOrderModel*model=[[XNRCheckOrderModel alloc]init];
            model.myOrderType = self.myOrderType;
            [model setValuesForKeysWithDictionary:dic];
            
            if ([self.myOrderType isEqualToString:@"待收货"]) {
                //9.可以确认收货的
                if ([model.orderSubType isEqualToString:@"9"]) {
                    [_dataArray addObject:model];
                }else{
                    model.isSelected = YES;
                    [_dataArray addObject:model];
                }
            }
            else if ([self.myOrderType isEqualToString:@"已完成"]) {
                //6.可以去评价的
                if ([model.orderSubType isEqualToString:@"6"]) {
                    [_dataArray addObject:model];
                } else {
                    model.isSelected = YES;
                    [_dataArray addObject:model];
                }
            }
            else{
                [_dataArray addObject:model];
            }
        }

//        XNRCheckOrderModel*model=[_dataArray firstObject];
//        NSString*unitPrice=model.unitPrice.stringValue;


        CGFloat totalPrice=0;
        for(XNRCheckOrderModel*model in _dataArray)
        {
            if ([model.unitPrice isEqualToString:@""] || [model.unitPrice isEqualToString:@"0"] || model.unitPrice == nil) {
                if ([model.deposit integerValue] == 0 || model.deposit == nil) {
                    totalPrice = totalPrice + model.goodsCount.intValue * model.originalPrice.floatValue;

                }else{
                    totalPrice = totalPrice + model.goodsCount.intValue * model.deposit.integerValue;

                }
            }
            else{
                if ([model.deposit integerValue] == 0 || model.deposit == nil) {
                    totalPrice = totalPrice + model.goodsCount.intValue*model.unitPrice.floatValue;
                }else{
                    totalPrice = totalPrice + model.goodsCount.intValue*model.deposit.integerValue;

                }
            }
        }
        
        _totalPriceDetail.text=[NSString stringWithFormat:@"￥%.2f",totalPrice];
        if (namelabel.text.length == 0) {
            namelabel.text = self.recieveName;
        }
        if (phoneNum.text.length == 0) {
            phoneNum.text = self.recievePhone;
        }
        if (_addressDetail.text.length == 0) {
            _addressDetail.text = self.recieveAddress;
        }
        
        [_tableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    
    
    
    
}

#pragma 时间戳转化函数—精确到day
-(NSString*)timeFromSigntimeToDay:(NSString*)signTime{
    
    NSLog(@"时间戳-->%@",signTime);
    if (signTime.length == 13)//毫秒转化为秒
    {
        signTime = [NSString stringWithFormat:@"%d",(int)signTime.integerValue/1000];
    }
    int signTime_NUM=[signTime intValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:signTime_NUM ];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString*time=[formatter stringFromDate:confromTimesp];
    
    return time;
    
}

#pragma mark-创建头视图
-(void)createHeadView{
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 10+45*SCALE+10+45*SCALE+10+45*SCALE+10+10+45*SCALE)];
    headView.backgroundColor=R_G_B_16(0xf4f4f4);
    
    
    UIButton*name=[MyControl createButtonWithFrame:CGRectMake(0, 10, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    name.backgroundColor=[UIColor whiteColor] ;
    [headView addSubview:name];
    
    
    namelabel=[MyControl createLabelWithFrame:CGRectMake(10, 0,name.frame.size.width/2.0-10, 45*SCALE) Font:15 Text:@""];
    namelabel.font=XNRFont(16);
    namelabel.adjustsFontSizeToFitWidth = YES;
    namelabel.textColor = TITLECOLOR;
    [name addSubview: namelabel];
    
    phoneNum=[MyControl createLabelWithFrame:CGRectMake(name.frame.size.width/2.0+10, 0, name.frame.size.width/2.0-20, 45*SCALE) Font:15 Text:@""];
    phoneNum.adjustsFontSizeToFitWidth = YES;
    phoneNum.textAlignment = NSTextAlignmentCenter;
    phoneNum.font=XNRFont(16);
    phoneNum.textColor = TITLECOLOR;
    [name addSubview: phoneNum];
    
    //订单号
    
    UIButton*order=[MyControl createButtonWithFrame:CGRectMake(0, 10+45*SCALE+10, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    order.backgroundColor=[UIColor whiteColor] ;
    [headView addSubview:order];
    
    
    UILabel*orderlabel=[MyControl createLabelWithFrame:CGRectMake(10, 45*SCALE/2-15*SCALE, 100, 30*SCALE) Font:15 Text:@"订单号 ："];
    orderlabel.font=XNRFont(16);
    orderlabel.textColor = TITLECOLOR;
    [order addSubview: orderlabel];
    
    UILabel*orderNum=[MyControl createLabelWithFrame:CGRectMake(90, 45*SCALE/2-15*SCALE, ScreenWidth-115, 30*SCALE) Font:15 Text:self.orderID];
    orderNum.text=self.orderID;
    orderNum.adjustsFontSizeToFitWidth=YES;
    orderNum.font=XNRFont(16);
    orderNum.textColor = TITLECOLOR;
    [order addSubview: orderNum];
    

    
    //收货地址
    UIButton*address=[MyControl createButtonWithFrame:CGRectMake(0, 10+45*SCALE+10+45*SCALE+10, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    
    address.backgroundColor=[UIColor whiteColor] ;
    [headView addSubview:address];
    
    
    UILabel*addresslabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:@"收货地址"];
    addresslabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    addresslabel.font=XNRFont(16);
    addresslabel.textColor = TITLECOLOR;
    [address addSubview: addresslabel];
    
   _addressDetail=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:@""];
    _addressDetail.center= CGPointMake(90*SCALE+80*SCALE, 45*SCALE/2);
    _addressDetail.font=XNRFont(16);
    _addressDetail.textColor = TITLECOLOR;
    [address addSubview: _addressDetail];
    
    
    UIButton*addressIcon=[MyControl createButtonWithFrame:CGRectMake(0, 0, 20*SCALE, 25*SCALE) ImageName:@"chakandingdan_icon_address" Target:nil Action:nil Title:nil];
    
    addressIcon.center=CGPointMake(10+10*SCALE, 0);
    
    [address addSubview:addressIcon];
    
    //配送日期(注掉)
    UIButton*date=[MyControl createButtonWithFrame:CGRectMake(0, 10+45*SCALE+10+45*SCALE+10+45*SCALE+10, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    date.backgroundColor=[UIColor whiteColor] ;
    // [headView addSubview:date];
    
    UILabel*datelabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:@"到货日期"];
    datelabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    datelabel.font=XNRFont(16);
    datelabel.textColor = TITLECOLOR;
    [date addSubview: datelabel];
    
    _dateDetail=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:@""];
    _dateDetail.center= CGPointMake(90*SCALE+80*SCALE, 45*SCALE/2);
    _dateDetail.font=XNRFont(16);
    _dateDetail.textColor = TITLECOLOR;
    [date addSubview: _dateDetail];
    //self.dateDetail = dateDetail;
    

    UIButton*dateIcon=[MyControl createButtonWithFrame:CGRectMake(0, 0, 20*SCALE, 25*SCALE) ImageName:@"chakandingdan_icon_date"Target:nil Action:nil Title:nil];
    dateIcon.center=CGPointMake(10+10*SCALE, 0);
    [date addSubview:dateIcon];
    self.tableview.tableHeaderView=headView;
}
#pragma mark-中部视图
-(void)createMid{
    
    self.tableview.backgroundColor=[UIColor clearColor];
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20,ScreenHeight-64 ) style:UITableViewStylePlain];
    self.tableview.showsHorizontalScrollIndicator=NO;
    self.tableview.showsVerticalScrollIndicator=NO;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundColor=R_G_B_16(0xf4f4f4);
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableview];
}
#pragma mark-创建底部视图
-(void)createFoot{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, self.tableview.frame.origin.y+self.tableview.frame.size.height+10, ScreenWidth-20,220*SCALE)];
    footView.backgroundColor=R_G_B_16(0xf4f4f4);
    [self.view addSubview:footView];
    
//    //积分使用
//    UIButton*useScore=[MyControl createButtonWithFrame:CGRectMake(0, 0, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
//    
//    useScore.backgroundColor=[UIColor whiteColor] ;
//    [footView addSubview:useScore];
//    
//    UILabel*useScorelabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:@"积分使用"];
//    useScorelabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
//    useScorelabel.font=XNRFont(16);
//    useScorelabel.textColor = TITLECOLOR;
//    [useScore addSubview: useScorelabel];
//    
//    UILabel*useScoreDetail=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:[NSString stringWithFormat:@"%d",300]];
//    
//    useScoreDetail.textColor=R_G_B_16(0xdd1b23);
//    useScoreDetail.center= CGPointMake(ScreenWidth-ScreenWidth/4+60, 45*SCALE/2);
//    useScoreDetail.font=XNRFont(16);
//    [useScore addSubview: useScoreDetail];
    
    
    //商品总额
    UIButton*totalPrice=[MyControl createButtonWithFrame:CGRectMake(0, 45*SCALE*0+.5, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    
    totalPrice.backgroundColor=[UIColor whiteColor] ;
    [footView addSubview:totalPrice];
    
    
    UILabel*totalPricelabel=[MyControl createLabelWithFrame:CGRectMake(10, 0, totalPrice.frame.size.width/2.0-10, 45*SCALE) Font:15 Text:@"商品总额:"];
    //totalPricelabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    totalPricelabel.font=XNRFont(16);
    totalPricelabel.textColor = TITLECOLOR;
    [totalPrice addSubview: totalPricelabel];
    
    _totalPriceDetail=[MyControl createLabelWithFrame:CGRectMake(totalPrice.frame.size.width/2.0, 0, totalPrice.frame.size.width/2.0-10, 45*SCALE) Font:15 Text:[NSString stringWithFormat:@"%.2f",0.0]];
    _totalPriceDetail.textAlignment = NSTextAlignmentRight;
    _totalPriceDetail.textColor=R_G_B_16(0xdd1b23);
    //_totalPriceDetail.center= CGPointMake(ScreenWidth-ScreenWidth/4+60, 45*SCALE/2);
    _totalPriceDetail.font=XNRFont(16);
    [totalPrice addSubview: _totalPriceDetail];
    
    //已优惠金额
    UIButton*countPrice=[MyControl createButtonWithFrame:CGRectMake(0, 45*SCALE*0+.5+45*SCALE+0.5, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    
    countPrice.backgroundColor=[UIColor whiteColor] ;
    // [footView addSubview:countPrice];
    
    
    UILabel*countPricelabel=[MyControl createLabelWithFrame:CGRectMake(10, 0, countPrice.frame.size.width/2.0-10, 45*SCALE) Font:15 Text:@"已优惠金额:"];
    //countPricelabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    countPricelabel.font=XNRFont(16);
    countPricelabel.textColor = TITLECOLOR;
    [countPrice addSubview: countPricelabel];
    
   
    _countPriceDetail=[MyControl createLabelWithFrame:CGRectMake(countPrice.frame.size.width/2.0, 0, countPrice.frame.size.width/2.0-10, 45*SCALE) Font:15 Text:[NSString stringWithFormat:@"%.2f",0.0]];
    _countPriceDetail.textAlignment = NSTextAlignmentRight;
    _countPriceDetail.textColor=R_G_B_16(0x30cd24);
    //_countPriceDetail.center= CGPointMake(ScreenWidth-ScreenWidth/4+60, 45*SCALE/2);
    _countPriceDetail.font=XNRFont(16);
    [countPrice addSubview: _countPriceDetail];
    
    //订单留言
    UIButton*orderWords=[MyControl createButtonWithFrame:CGRectMake(0, 45*SCALE*0+.5+45*SCALE+0.5+45*SCALE+0.5, ScreenWidth-20, 90*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    
    orderWords.backgroundColor=[UIColor whiteColor] ;
    // [footView addSubview:orderWords];
    
    UILabel*orderWordslabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:@"订单留言:"];
    orderWordslabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    orderWordslabel.font=XNRFont(16);
    orderWordslabel.textColor = TITLECOLOR;
    [orderWords addSubview: orderWordslabel];
    _leaveMessage=[[UILabel alloc]initWithFrame:CGRectMake(10, 35*SCALE, ScreenWidth-20, 45*SCALE)];
    
    _leaveMessage.font=XNRFont(16);
    _leaveMessage.textColor=TITLECOLOR;
    _leaveMessage.text=@"您好请快点运送，谢谢";
    [orderWords addSubview:_leaveMessage];
    //设定内容样式
    NSMutableAttributedString * attributedString =
    [[NSMutableAttributedString alloc] initWithString:_leaveMessage.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    //首行头缩进
    paragraphStyle.firstLineHeadIndent = 30;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          paragraphStyle, NSParagraphStyleAttributeName ,
                          [NSNumber numberWithFloat:0],NSBaselineOffsetAttributeName,
                          nil];
    [attributedString addAttributes:dict range:NSMakeRange(0 , [attributedString length])];
    [_leaveMessage setAttributedText:attributedString];
    self.tableview.tableFooterView=footView;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.myOrderType isEqualToString:@"待收货"] || [self.myOrderType isEqualToString:@"已完成"]) {
        XNRCheckOrderModel *model = _dataArray[indexPath.row];
        return model.isSelected?100:130;
    }else{
        return 100;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID=@"XNROderInfo";
    XNROderInfo_Cell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        
        cell=[[XNROderInfo_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.refreshBlock = ^{
        [self.tableview reloadData];
    };
    
    [cell setCommentGoodBlock:^(XNRCheckOrderModel*goodModel) {
        
        XNREvaluationOrder_VC*vc=[[XNREvaluationOrder_VC alloc]init];
        vc.model=goodModel;
        vc.orderId = _orderID;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    [cell setCellDataWithModel:_dataArray[indexPath.row]];
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"查看订单";
    self.navigationItem.titleView = titleLabel;

    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
     backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
}

-(void)backClick{

    if (self.isRoot) {
        [self.navigationController popViewControllerAnimated:YES];

    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
