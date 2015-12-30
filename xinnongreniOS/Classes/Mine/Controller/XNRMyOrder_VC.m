//
//  XNRMyOrder_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyOrder_VC.h"
#import "XNRPayTypeViewController.h"
#import "XNRSendView.h"          //待发货
#import "XNRReciveView.h"        //待收货
#import "XNRPayView.h"           //代付款
#import "XNRServeView.h"         // 全部
#import "XNRCommentView.h"       //已完成
#import "XNREvaluationOrder_VC.h"//评价订单
#import "XNRCheckOrder_VC.h"     //查看订单
#import "XNRTabBarController.h"
#define KbtnTag          1000
#define kLabelTag        2000
@interface XNRMyOrder_VC ()<UIScrollViewDelegate>{
    UIButton *_tempBtn;
    UILabel *_tempLabel;
}
@property (nonatomic,retain) UIView         *selectLine;
@property (nonatomic,retain) XNRCommentView *CommentView;//4
@property (nonatomic,retain) XNRReciveView  *ReciveView;//3
@property (nonatomic,retain) XNRSendView    *SendView; //2
@property (nonatomic,retain) XNRServeView   *ServeView;
@property (nonatomic,retain) XNRPayView     *PayView; //1

@property(nonatomic,retain)UIScrollView*mainScrollView;
@end

@implementation XNRMyOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    
    [self setNavigationbarTitle];
    [self createTopView];
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60*SCALE+5,ScreenWidth+10*SCALE,ScreenHeight-64-60*SCALE-5+100)];
    self.mainScrollView.contentSize=CGSizeMake((ScreenWidth+10*SCALE)*5, ScreenHeight-64-60*SCALE-5);
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.userInteractionEnabled = YES;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    self.mainScrollView.backgroundColor =R_G_B_16(0xf4f4f4);
    //取消反弹效果
    self.mainScrollView.bounces = NO;
    
    [self.view addSubview:self.mainScrollView];
 
    [self createMidView];
    
    //联系客服
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lianXiKeFu) name:@"LianXiKeFu" object:nil];
}

- (void)lianXiKeFu
{
    if(TARGET_IPHONE_SIMULATOR){
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"模拟器不支持打电话，请用真机测试\(^o^)/~" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [al show];
        
    }else {
        //请求客服电话接口
        [self networkRequest];
    }

}

-(void)networkRequest
{
    UIWebView*phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"4000560371"]];
    // NSLog(@"电话%@",datasDic[@"value"]);
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
}
#pragma mark--创建中部视图
-(void)createMidView{
    if(nil==self.PayView){
        
        self.PayView=[[XNRPayView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-60*SCALE-5) UrlString:@"pay"];
        __weak __typeof(&*self)weakSelf=self;
        //全部结算
        [self.PayView setAllPayBlock:^(CGFloat allMoney){
            
            XNRPayTypeViewController*vc=[[XNRPayTypeViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.money = [NSString stringWithFormat:@"%f",allMoney] ;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        //单笔结算
        [self.PayView setPayBlock:^(CGFloat money,NSString *orderID,NSString *orderNO){
            [KSHttpRequest post:KUnionpay parameters:@{@"consumer":@"app",@"responseStyle":@"v1.0",@"orderId":orderNO,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                
                [SVProgressHUD dismiss];
                XNRPayTypeViewController*vc=[[XNRPayTypeViewController alloc]init];
                vc.hidesBottomBarWhenPushed=YES;
                vc.money = [NSString stringWithFormat:@"%f",money];
                vc.paymentId = orderID;
                vc.orderID = orderNO;
                vc.tn = result[@"tn"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
        
                
                
            } failure:^(NSError *error) {
                NSLog(@"+++++%@",error);
            }];
        }];
        
        
        [self.PayView setCheckOrderBlock:^(NSString *orderID,NSString*orderNO) {
            XNRCheckOrder_VC*vc=[[XNRCheckOrder_VC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.orderID=orderID;
            vc.orderNO=orderNO;
            vc.recieveName = [DataCenter account].nickname;
            vc.recievePhone = [DataCenter account].phone;
            vc.recieveAddress = [DataCenter account].address;

            vc.myOrderType = @"待付款";
            vc.isRoot = YES ;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
    }
    if(nil == self.SendView){
        
        self.SendView=[[XNRSendView alloc]initWithFrame:CGRectMake( 0, 0, ScreenWidth,ScreenHeight-64-60*SCALE-5) UrlString:@"send"];
        __weak __typeof(&*self)weakSelf=self;
        [self.SendView setCheckOrderBlock:^(NSString *orderID,NSString*orderNO) {
            XNRCheckOrder_VC*vc=[[XNRCheckOrder_VC alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.orderID= orderID;
            vc.orderNO= orderNO;
            vc.isRoot = YES ;
            vc.myOrderType = @"待发货";
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
    }
    if(nil==self.ReciveView){
        
        self.ReciveView=[[XNRReciveView alloc]initWithFrame:CGRectMake( 0, 0, ScreenWidth,ScreenHeight-64-60*SCALE-5) UrlString:@"recive"];
        __weak __typeof(&*self)weakSelf=self;
        //查看订单
        [self.ReciveView setCheckOrderBlock:^(NSString *orderID,NSString*orderNO) {
            XNRCheckOrder_VC*vc=[[XNRCheckOrder_VC alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.isRoot = YES ;
            vc.orderID=orderID;
            vc.orderNO=orderNO;
            vc.myOrderType = @"待收货";
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        //确认收货
        
        [self.ReciveView setPayBlock:^(XNRMyOrderModel *model){
            XNRPayTypeViewController*vc=[[XNRPayTypeViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.money = model.totalPrice;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    if(nil==self.CommentView){
        
        self.CommentView =[[XNRCommentView alloc]initWithFrame:CGRectMake( 0, 0, ScreenWidth,ScreenHeight-64-60*SCALE-5) UrlString:@"comment"];
        __weak __typeof(&*self)weakSelf=self;

        [self.CommentView setCommentBlock:^{
        
            //评价
            XNREvaluationOrder_VC*vc=[[XNREvaluationOrder_VC alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        [self.CommentView setCheckOrderBlock:^(NSString *orderID,NSString*orderNO) {
            XNRCheckOrder_VC*vc=[[XNRCheckOrder_VC alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.isRoot = YES ;
            vc.orderID=orderID;
            vc.orderNO=orderNO;
            vc.myOrderType = @"已完成";
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];

        
        
    }
    if(nil==self.ServeView){
        
        self.ServeView=[[XNRServeView alloc]initWithFrame:CGRectMake( 0, 0, ScreenWidth,ScreenHeight-64-60*SCALE-5) UrlString:@"serve"];
        __weak __typeof(&*self)weakSelf=self;
        [self.ServeView setCheckOrderBlock:^(NSString *orderID,NSString*orderNO) {
            XNRCheckOrder_VC*vc=[[XNRCheckOrder_VC alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.orderID = orderID;
            vc.orderNO = orderNO;
            vc.isRoot = YES ;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];

        
    }
    NSArray*arr=@[self.ServeView,self.PayView,self.SendView,self.ReciveView,self.CommentView];
    
    //滚动视图上添加5个表格视图
    for (int i=0; i<arr.count; i++)
    {
        UIView *view = arr[i];
        
        view.frame = CGRectMake((ScreenWidth+10*SCALE)*i, 0, ScreenWidth, ScreenHeight-64-PX_TO_PT(100));
        [self.mainScrollView addSubview:view];
    }
    
}
#pragma mark-创建顶部视图
-(void)createTopView{
    UIView*midBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(100))];
    midBg.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:midBg];
    
    NSArray *arr1 = @[@"全部",@"待付款",@"待发货",@"已发货",@"已完成"];
    CGFloat x = 0*SCALE;
    CGFloat y = 0*SCALE;
    CGFloat w = ScreenWidth/5.0;
    CGFloat h = PX_TO_PT(100);
    for (int i = 0; i<arr1.count; i++) {
        
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(x+i*w, y, w, h)];
       
//        button.imageEdgeInsets = UIEdgeInsetsMake(-15*SCALE, 0, 0, 0);
        
        button.tag = KbtnTag + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [midBg addSubview:button];
        
        UILabel *tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth/5.0)*i, PX_TO_PT(30),ScreenWidth/5.0 , PX_TO_PT(40))];
        tempTitleLabel.textColor = R_G_B_16(0x323232);
        tempTitleLabel.textAlignment = NSTextAlignmentCenter;
        tempTitleLabel.font = [UIFont systemFontOfSize:16];
        tempTitleLabel.text = arr1[i];
        tempTitleLabel.tag = kLabelTag+i;
        [midBg addSubview:tempTitleLabel];
        
        if (i==0) {
            button.selected = YES;
            _tempBtn = button;
            
            tempTitleLabel.textColor = R_G_B_16(0x00b38a);
            _tempLabel = tempTitleLabel;
        }
    }
    _selectLine=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(100)-1, ScreenWidth/5.0, 1)];
    _selectLine.backgroundColor=R_G_B_16(0x00b38a);
    [midBg addSubview:_selectLine];
    
    
}
-(void)buttonClick:(UIButton*)button{
    
    static int index = KbtnTag;

    UILabel *label = (UILabel *)[self.view viewWithTag:button.tag+1000];
    
    [UIView animateWithDuration:.3 animations:^{
        self.selectLine.frame=CGRectMake((button.tag-KbtnTag)*ScreenWidth/5.0,  PX_TO_PT(100)-1, ScreenWidth/5.0, 1);
    
        
   }];
    [self.mainScrollView setContentOffset:CGPointMake((ScreenWidth+10*SCALE)*(button.tag-KbtnTag),0) animated:NO];
    
    index = (int)button.tag;
    
    if(button.tag == KbtnTag){
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x00b38a);
        _tempLabel = label;
    }
    if(button.tag==KbtnTag+1){
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x00b38a);
        _tempLabel = label;
    }

    if(button.tag==KbtnTag+2){
        
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x00b38a);
        _tempLabel = label;
    }

    if(button.tag==KbtnTag+3){
        
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x00b38a);
        _tempLabel = label;
    }

    if(button.tag==KbtnTag+4){
        
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x00b38a);
        _tempLabel = label;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset = self.mainScrollView.contentOffset.x/(ScreenWidth+10*SCALE);
    
      static int tag = 0;

    if(0<=offset&&offset<0.5){
        tag=0;
        UIButton *button = (UIButton *)[self.view viewWithTag:KbtnTag+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        UILabel *label = (UILabel *)[self.view viewWithTag:kLabelTag +tag];
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x11c420);
        _tempLabel = label;
        
    }else if (0.5<=offset&&offset<1.5){
        tag=1;
        UIButton *button = (UIButton *)[self.view viewWithTag:KbtnTag+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        UILabel *label = (UILabel *)[self.view viewWithTag:kLabelTag +tag];
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x11c420);
        _tempLabel = label;
    }else if (1.5<=offset&&offset<2.5){
        tag=2;
        UIButton *button = (UIButton *)[self.view viewWithTag:KbtnTag+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        UILabel *label = (UILabel *)[self.view viewWithTag:kLabelTag +tag];
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x11c420);
        _tempLabel = label;
    }else if (2.5<=offset&&offset<3.5){
        tag=3;
        UIButton *button = (UIButton *)[self.view viewWithTag:KbtnTag+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        UILabel *label = (UILabel *)[self.view viewWithTag:kLabelTag +tag];
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x11c420);
        _tempLabel = label;
    }else{
        tag=4;
        UIButton *button = (UIButton *)[self.view viewWithTag:KbtnTag+tag];
        _tempBtn.selected = NO;
        button.selected = YES;
        _tempBtn = button;
        
        UILabel *label = (UILabel *)[self.view viewWithTag:kLabelTag +tag];
        _tempLabel.textColor = [UIColor blackColor];
        label.textColor = R_G_B_16(0x11c420);
        _tempLabel = label;
    }
    
    
    [UIView animateWithDuration:.3 animations:^{
        
    self.selectLine.frame=CGRectMake((ScreenWidth/5.0)*offset,  PX_TO_PT(100)-1, ScreenWidth/5.0, 1);
    }];

    
}

- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的订单";
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
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
