//
//  XNRMakeSureOrderInfo_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/7.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMakeSureOrderInfo_VC.h"
#import "XNRAddressManageViewController.h"
#import "XNROrderInfoCell.h"
#import "XNRPayType_VC.h"
#import "XNRTabBarController.h"
#import "XNROrderInfoCell.h"
@interface XNRMakeSureOrderInfo_VC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
}
    
    
@property(nonatomic,retain)UILabel*orderWordsContent;//留言内容
@property(nonatomic,retain)UILabel*addressDetail;//收货地址
@property(nonatomic,retain)UILabel*dateDetail;   //期望收货日期
@property(nonatomic,retain)UILabel*totalPriceDetail;//
@property(nonatomic,retain)UITableView*tableview;

@end

@implementation XNRMakeSureOrderInfo_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    
    //中部视图
    [self createMid];
    //创建头视图
    [self createHeadView];
    //底部视图
    [self createFoot];
    //底部视图
    [self createBottom];
}
#pragma 时间戳转化函数—精确到day
-(NSString*)timeFromSigntimeToDay:(NSString*)signTime{
    
    NSLog(@"时间戳-->%@",signTime);
    if (signTime.length == 13)//毫秒转化为秒
    {
        signTime = [NSString stringWithFormat:@"%ld",(long)signTime.integerValue/1000];
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
    
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 10+45*SCALE+10+45*SCALE+10+45*SCALE+10)];
    headView.backgroundColor=R_G_B_16(0xf4f4f4);
    
    
    UIButton*name=[MyControl createButtonWithFrame:CGRectMake(0, 10, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    name.backgroundColor=[UIColor whiteColor] ;
    [headView addSubview:name];
    
    UILabel*namelabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:self.recipientName];
    namelabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    namelabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    namelabel.textColor = TITLECOLOR;
    [name addSubview: namelabel];
    
    UILabel*phoneNum=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text: self.recipientPhone];
    
    phoneNum.center= CGPointMake(ScreenWidth-ScreenWidth/4+10, 45*SCALE/2);
    phoneNum.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    phoneNum.textColor = TITLECOLOR;
    [name addSubview: phoneNum];
    
    
    //收货地址
    UIButton*address=[MyControl createButtonWithFrame:CGRectMake(0, 10+45*SCALE+10, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    address.backgroundColor=[UIColor whiteColor] ;
    [headView addSubview:address];
    
    
    UILabel*addresslabel=[MyControl createLabelWithFrame:CGRectMake(10, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:@"收货地址"];
    addresslabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    addresslabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    addresslabel.textColor = TITLECOLOR;
    [address addSubview: addresslabel];
    
    _addressDetail=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2+30, 30*SCALE) Font:15 Text:self.building];
    _addressDetail.center= CGPointMake(90*SCALE+80*SCALE+30, 45*SCALE/2);
    _addressDetail.textAlignment=NSTextAlignmentCenter;
    _addressDetail.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    _addressDetail.textColor = TITLECOLOR;
    [address addSubview: _addressDetail];
    
    
    UIButton*addressIcon=[MyControl createButtonWithFrame:CGRectMake(0, 0, 20*SCALE, 25*SCALE) ImageName:@"chakandingdan_icon_address" Target:nil Action:nil Title:nil];
    
    addressIcon.center=CGPointMake(10+10*SCALE, 0);
    
    [address addSubview:addressIcon];
    
    //到货日期
    UIButton*date=[MyControl createButtonWithFrame:CGRectMake(0, 10+45*SCALE+10+45*SCALE+10, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    date.backgroundColor=[UIColor whiteColor] ;
    [headView addSubview:date];
    
    UILabel*datelabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 30*SCALE) Font:15 Text:@"到货日期"];
    datelabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    datelabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    datelabel.textColor = TITLECOLOR;
    [date addSubview: datelabel];
    
    _dateDetail=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2+30, 30*SCALE) Font:15 Text:self.deliveryTime];
    _dateDetail.center= CGPointMake(90*SCALE+80*SCALE+30, 45*SCALE/2);
    _dateDetail.textAlignment=NSTextAlignmentCenter;
    _dateDetail.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    _dateDetail.textColor = TITLECOLOR;
    [date addSubview: _dateDetail];
    
    
    
    UIButton*dateIcon=[MyControl createButtonWithFrame:CGRectMake(0, 0, 20*SCALE, 25*SCALE) ImageName:@"chakandingdan_icon_date"Target:nil Action:nil Title:nil];
    dateIcon.center=CGPointMake(10+10*SCALE, 0);
    [date addSubview:dateIcon];
    self.tableview.tableHeaderView=headView;
}
#pragma mark-中部视图
-(void)createMid{
    
    self.tableview.backgroundColor=[UIColor clearColor];
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20,ScreenHeight-64-40*SCALE-20 ) style:UITableViewStylePlain];
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
    UIView*footView=[[UIView alloc]initWithFrame:CGRectMake(0, self.tableview.frame.origin.y+self.tableview.frame.size.height+10, ScreenWidth-20,220*SCALE)];
    footView.backgroundColor=R_G_B_16(0xf4f4f4);
    [self.view addSubview:footView];
    

    //商品总额
    UIButton*totalPrice=[MyControl createButtonWithFrame:CGRectMake(0, 45*SCALE*0+.5, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    
    totalPrice.backgroundColor=[UIColor whiteColor] ;
    [footView addSubview:totalPrice];
    
    //商品总额
    UILabel*totalPricelabel=[MyControl createLabelWithFrame:CGRectMake(10, 0, 100, 45*SCALE) Font:15 Text:@"商品总额:"];
 
    totalPricelabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    totalPricelabel.textColor = TITLECOLOR;
    [totalPrice addSubview: totalPricelabel];
    
    _totalPriceDetail=[MyControl createLabelWithFrame:CGRectMake(totalPricelabel.frame.origin.x + totalPricelabel.frame.size.width, 0, totalPrice.frame.size.width-totalPricelabel.frame.size.width-20, 45*SCALE) Font:15 Text:[NSString stringWithFormat:@"￥%.2f",[self computeTotalPrice]]];
    _totalPriceDetail.adjustsFontSizeToFitWidth = YES;
    _totalPriceDetail.textAlignment = NSTextAlignmentRight;
    _totalPriceDetail.textColor=R_G_B_16(0xdd1b23);
    _totalPriceDetail.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    [totalPrice addSubview: _totalPriceDetail];
    
    
    //已优惠金额
    UIButton*countPrice=[MyControl createButtonWithFrame:CGRectMake(0, 45*SCALE*0+.5+45*SCALE+0.5, ScreenWidth-20, 45*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    
    countPrice.backgroundColor=[UIColor whiteColor] ;
    [footView addSubview:countPrice];
    
    
    
    //订单留言
    UIButton*orderWords=[MyControl createButtonWithFrame:CGRectMake(0, 45*SCALE*0+.5+45*SCALE+0.5+45*SCALE+0.5, ScreenWidth-20, 90*SCALE) ImageName:nil Target:self Action:nil Title:nil];
    
    orderWords.backgroundColor=[UIColor whiteColor] ;
    [footView addSubview:orderWords];
    
    //title
    UILabel*orderWordslabel=[MyControl createLabelWithFrame:CGRectMake(0, 0, ScreenWidth/2, 45*SCALE) Font:15 Text:@"订单留言:"];
    orderWordslabel.center= CGPointMake(90*SCALE, 45*SCALE/2);
    orderWordslabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    orderWordslabel.textColor = TITLECOLOR;
    [orderWords addSubview: orderWordslabel];
    _orderWordsContent=[[UILabel alloc]initWithFrame:CGRectMake(10, 35*SCALE, ScreenWidth-40, 45*SCALE)];
    _orderWordsContent.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    _orderWordsContent.numberOfLines=0;
    _orderWordsContent.textColor=TITLECOLOR;
    _orderWordsContent.text=self.leaveMessage;
    [orderWords addSubview:_orderWordsContent];
    
    CGFloat content_h=[self heightWithString:_orderWordsContent.text width:ScreenWidth-20 fontSize:16]+15;
    [self setHight:_orderWordsContent andHight:content_h];
    [self setHight:orderWords andHight:90+content_h-45*SCALE];
  
    //设定内容样式
    NSMutableAttributedString * attributedString =
    [[NSMutableAttributedString alloc] initWithString:_orderWordsContent.text];
     NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
       paragraphStyle.alignment = NSTextAlignmentJustified;
    //首行头缩进
    paragraphStyle.firstLineHeadIndent = 30;
   
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          paragraphStyle,  NSParagraphStyleAttributeName ,
                          [NSNumber numberWithFloat:0],NSBaselineOffsetAttributeName,
                          nil];
       [attributedString addAttributes:dict range:NSMakeRange(0 , [attributedString length])];
       [_orderWordsContent setAttributedText:attributedString];

    self.tableview.tableFooterView=footView;
    
}


#pragma mark-计算商品总额
-(CGFloat)computeTotalPrice{
    CGFloat totalPrice=0;
    for(XNRShoppingCartModel*model in _dataArray)
    {
        if (model.unitPrice != 0) {
            if ([model.deposit integerValue] == 0 || model.deposit == nil) {
                totalPrice = totalPrice + model.goodsCount.intValue*model.originalPrice.intValue;
            }else{
                totalPrice = totalPrice + model.goodsCount.intValue * model.deposit.intValue;

            }
            
        }else{
            totalPrice = totalPrice + model.goodsCount.intValue * model.unitPrice.floatValue;
        }
    }
    
    
    return totalPrice;
}
-(void)createBottom{
    
    //确认订单按钮
    UIButton*makeSure=[MyControl createButtonWithFrame:CGRectMake(10, ScreenHeight-64-40*SCALE-10, ScreenWidth-20, 40*SCALE) ImageName:nil Target:self Action:@selector(makeSure) Title:@"去支付"];
    
    makeSure.backgroundColor=R_G_B_16(0x11c422);
    [makeSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    makeSure.titleLabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
    makeSure.clipsToBounds=YES;
    [makeSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    makeSure.layer.cornerRadius=8;
    [self.view addSubview:makeSure];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID=@"XNROderInfo";
    XNROrderInfoCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        
        cell=[[XNROrderInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    [cell setCellDataWithModel:_dataArray[indexPath.row]];
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark- 确认订单
-(void)makeSure:(UIButton *)sender{
    XNRPayType_VC*vc=[[XNRPayType_VC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.payMoney= [NSString stringWithFormat:@"%f",[self computeTotalPrice]];
    vc.orderID = [DataCenter account].orderId;
    vc.fromType = @"确认订单";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}

-(CGFloat)heightWithString:(NSString *)string
                     width:(CGFloat)width
                  fontSize:(CGFloat)fontSize
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
}

- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单成功";
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
    
    XNRTabBarController *tab = (XNRTabBarController *)self.tabBarController;
    tab.selectedIndex = 0;
    CATransition *myTransition=[CATransition animation];
    myTransition.duration=0.3;
    myTransition.type= @"fade";
    [tab.view.superview.layer addAnimation:myTransition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
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
