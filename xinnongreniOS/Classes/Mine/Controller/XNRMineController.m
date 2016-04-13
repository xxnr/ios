//
//  XNRMineController.m
//  qianxiheiOS
//
//  Created by Scarecrow on 15/5/18.
//  Copyright (c) 2015年 XNRiOS. All rights reserved.
//

#import "XNRMineController.h"
#import "XNRLoginViewController.h" // 登录
#import "XNRMyscore_VC.h"          // 我的积分
#import "XNRMyaccount_VC.h"        // 我的账户
#import "XNROrderInfo_VC.h"        // 订单信息
#import "XNRProductInfo_VC.h"      // 商品信息
#import "XNRCheckOrderVC.h"       // 查看订单
#import "XNRMyOrder_VC.h"          // 我的订单
#import "SJAvatarBrowser.h"       // 浏览头像
#import "UIImageView+WebCache.h"
#import "XNRMyRepresentViewController.h"
#import "XNRUserInfoModel.h"

#define KbtnTag          1000

@interface XNRMineController ()<UIActionSheetDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *bgNotLoginView;
@property (nonatomic, weak) UIImageView *bgLoginView;

@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIButton *registBtn;
@property (nonatomic, weak) UILabel *introduceLabel; // 昵称
@property (nonatomic, weak) UILabel *typeLabel;  // 类型
@property (nonatomic, weak) UILabel *addressLabel;     // 地址
@property (nonatomic, weak) UIScrollView *mainScrollView;

@property (nonatomic, weak) UIButton *orderBtn;
@property (nonatomic, weak) UIImageView *arrowImg;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) UIImageView *badgeImage;
@property (nonatomic, strong) NSMutableArray *verifiedTypes;
@property (nonatomic, assign) BOOL isBroker;
@property (nonatomic, strong) NSMutableArray *userArray;
@end

@implementation XNRMineController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(IS_Login == YES){
    [_userArray removeAllObjects];
    [KSHttpRequest post:KUserGet parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"x-v2.0"} success:^(id result) {
        
    if([result[@"code"] integerValue] == 1000){
            
        NSDictionary *dict = result[@"datas"];
        NSDictionary *address = dict[@"address"];
        NSDictionary *province = address[@"province"];
        NSDictionary *city = address[@"city"];
        NSDictionary *county = address[@"county"];
        NSDictionary *town = address[@"town"];

        UserInfo *info = [DataCenter account];
        info.photo = dict[@"photo"];
        info.phone = dict[@"phone"];
        info.nickname = dict[@"nickname"];
        info.name = dict[@"name"];
        info.type = dict[@"userType"];
        info.typeName = dict[@"userTypeInName"];
        info.sex = dict[@"sex"];
        
        NSArray *Arr = dict[@"verifiedTypesInJson"];
        [self.verifiedTypes removeAllObjects];
        self.isBroker = NO;
        for (int i=0 ; i<Arr.count; i++) {
            NSString *name =dict[@"verifiedTypesInJson"][i][@"typeName"];
            [self.verifiedTypes addObject:name];
            if ([name isEqualToString:@"新农经纪人"]) {
                self.isBroker = YES;
            }
        }
        
        info.provinceID = province[@"id"];
        info.cityID = city[@"id"];
        info.countyID = county[@"id"];
        [DataCenter saveAccount:info];
            
        
        XNRUserInfoModel *model = [[XNRUserInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [_userArray addObject:model];
            
        model.province = province[@"name"];
        model.city = city[@"name"];
            
        if (![KSHttpRequest isNULL:county]) {
            model.county = county[@"name"];

        }
        if (![KSHttpRequest isNULL:town]) {
            model.town = town[@"name"];
        }
        // 设置视图的数据
        [self setupDatas:model];
        
        }
        
    } failure:^(NSError *error) {
        
        [UILabel showMessage:@"网络请求失败"];
            
        }];
        [self createLoginTopView];
        
        }else{
            [self createNotLoginTopView];
    
    }

}

-(void)setupDatas:(XNRUserInfoModel *)model
{
    // 头像
    if ([KSHttpRequest isBlankString:model.photo]) {// 没有头像
        self.icon.image=[UIImage imageNamed:@"icon_head"];
        
    }else{
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",HOST,model.photo];
        
        if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
            [self.icon setImage:[UIImage imageNamed:@"icon_head"]];
        }else{
            [self.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_head"]];
        }
    }
    // 昵称
    if ([KSHttpRequest isBlankString:model.nickname]) {
        self.introduceLabel.text = [NSString stringWithFormat:@"昵称:新新农人"];
    }else{
        self.introduceLabel.text = [NSString stringWithFormat:@"昵称:%@",model.nickname];
    }
    // 地址
    if ([KSHttpRequest isBlankString:model.province]) {
        self.addressLabel.text = [NSString stringWithFormat:@"地区:%@",@"还没有填写哦~"];
    }else{
        if ([KSHttpRequest isBlankString:model.county]) {
            if ([KSHttpRequest isNULL:model.town]) {
                self.addressLabel.text = [NSString stringWithFormat:@"地区:%@%@",model.province,model.city];
            }else{
                self.addressLabel.text = [NSString stringWithFormat:@"地区:%@%@%@",model.province,model.city,model.town];
            }
            
        }else{
            if ([KSHttpRequest isNULL:model.town]) {
                NSString *address = [NSString stringWithFormat:@"%@",model.county];
                self.addressLabel.text = [NSString stringWithFormat:@"地区:%@%@%@",model.province,model.city,address];
            }else{
                NSString *address = [NSString stringWithFormat:@"%@%@",model.county,model.town];
                self.addressLabel.text = [NSString stringWithFormat:@"地区:%@%@%@",model.province,model.city,address];
            }
        }
    }
    
    // 类型
    self.typeLabel.text = model.userTypeInName?[NSString stringWithFormat:@"类型:%@",model.userTypeInName]:@"类型:还没有填写哦~";
    CGSize size = [self.typeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(26)]}];
    self.typeLabel.frame = CGRectMake(PX_TO_PT(200), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(16), size.width, PX_TO_PT(24));
    
    
    //徽章
    if (model.userTypeInName) {
        for (int i=0; i<self.verifiedTypes.count; i++) {
            if ([self.verifiedTypes[i] isEqualToString:model.userTypeInName]) {
                self.badgeImage.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) + PX_TO_PT(14), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(16), PX_TO_PT(28), PX_TO_PT(36));
                
                self.badgeImage.hidden = NO;
                break;
            }
        }
    }


}
-(void)viewWillDisappear:(BOOL)animated
{
    self.badgeImage.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建scrollView
    [self createScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavigationbarTitle];
    
    //底部视图
    [self createMiddleView];
    self.userArray = [NSMutableArray array];
    self.verifiedTypes = [NSMutableArray array];
   
}

-(void)createScrollView{
    UIScrollView *mainScrollView =[MyControl createUIScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) contentSize:CGSizeMake(ScreenWidth, 600*SCALE) pagingEnabled:NO showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO delegate:self];
    mainScrollView.backgroundColor=R_G_B_16(0xf4f4f4);
    self.mainScrollView = mainScrollView;
    [self.view addSubview:mainScrollView];
}

-(void)createLoginTopView
{
    UIImageView *bgLoginView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(320))];
    [bgLoginView setImage:[UIImage imageNamed:@"icon_bgView"]];
    bgLoginView.userInteractionEnabled  = YES;
    self.bgLoginView = bgLoginView;
    [self.mainScrollView addSubview:bgLoginView];
    
    
    //头像
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(100), PX_TO_PT(150), PX_TO_PT(150))];
    icon.clipsToBounds=YES;
    icon.layer.cornerRadius=PX_TO_PT(75);
    icon.layer.borderColor= [UIColor whiteColor].CGColor ;
    icon.layer.borderWidth=3;
    icon.userInteractionEnabled = YES;
    icon.image=[UIImage imageNamed:@"icon_head"];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconClick:)];
    [bgLoginView addGestureRecognizer:tap];
    self.icon = icon;
    [bgLoginView addSubview:icon];


    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200), PX_TO_PT(150), ScreenWidth, PX_TO_PT(30))];
    introduceLabel.textColor = R_G_B_16(0xffffff);
    introduceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    self.introduceLabel = introduceLabel;
    [self.bgLoginView addSubview:introduceLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200),(CGRectGetMaxY(self.introduceLabel.frame) + PX_TO_PT(16)), ScreenWidth - PX_TO_PT(200), PX_TO_PT(40))];
    addressLabel.textColor = R_G_B_16(0xffffff);
    addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(26)];
    addressLabel.numberOfLines = 0;
    self.addressLabel = addressLabel;
    [self.bgLoginView addSubview:addressLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(16), ScreenWidth, PX_TO_PT(20))];
    typeLabel.textColor = R_G_B_16(0xffffff);
    typeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(26)];
    typeLabel.numberOfLines = 0;
    self.typeLabel = typeLabel;
    [self.bgLoginView addSubview:typeLabel];
    
    
    UIImageView *BadgeImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(typeLabel.frame) + PX_TO_PT(14), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(16), PX_TO_PT(28), PX_TO_PT(37))];
    BadgeImage.contentMode = UIViewContentModeScaleAspectFit;
    BadgeImage.image = [UIImage imageNamed:@"badge"];
    BadgeImage.hidden = YES;
    self.badgeImage = BadgeImage;
    [self.bgLoginView addSubview:BadgeImage];

    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(50), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(10), PX_TO_PT(18), PX_TO_PT(32))];
    [arrowImg setImage:[UIImage imageNamed:@"icon_arrow_back"]];
    self.arrowImg = arrowImg;
    [self.bgLoginView addSubview:arrowImg];
}
#pragma mark--创建未登录的顶部视图
-(void)createNotLoginTopView
{
    CGFloat margin = PX_TO_PT(20);
    // 背景
    UIImageView *bgNotLoginView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(320))];
    [bgNotLoginView setImage:[UIImage imageNamed:@"icon_bgView"]];
    bgNotLoginView.userInteractionEnabled  = YES;
    self.bgNotLoginView = bgNotLoginView;
    [self.mainScrollView addSubview:bgNotLoginView];
    
    //头像
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PX_TO_PT(150), PX_TO_PT(150))];
    icon.clipsToBounds=YES;
    icon.center = CGPointMake(ScreenWidth/2, PX_TO_PT(125));
    icon.layer.cornerRadius=PX_TO_PT(75);
    icon.layer.borderColor= [UIColor whiteColor].CGColor ;
    icon.layer.borderWidth=3;
    icon.userInteractionEnabled = YES;
    icon.image=[UIImage imageNamed:@"icon_head"];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconClick:)];
    [bgNotLoginView addGestureRecognizer:tap];
    self.icon = icon;
    [bgNotLoginView addSubview:icon];
    
    // 登录，注册按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake((ScreenWidth-PX_TO_PT(332))*0.5, CGRectGetMaxY(self.icon.frame) + margin, PX_TO_PT(136), PX_TO_PT(48));
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    loginBtn.tintColor = [UIColor whiteColor];
    loginBtn.backgroundColor = [UIColor clearColor];
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    loginBtn.layer.borderWidth = 2;
    loginBtn.layer.cornerRadius = 5.0;
    loginBtn.clipsToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn  = loginBtn;
    [bgNotLoginView addSubview:loginBtn];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake((ScreenWidth-PX_TO_PT(332))*0.5 + PX_TO_PT(196), CGRectGetMaxY(self.icon.frame) + margin, PX_TO_PT(136), PX_TO_PT(48));
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    registBtn.tintColor = [UIColor whiteColor];
    registBtn.backgroundColor = [UIColor clearColor];
    registBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    registBtn.layer.borderWidth = 2;
    registBtn.layer.cornerRadius = 5.0;
    registBtn.clipsToBounds = YES;
    [registBtn addTarget: self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.registBtn = registBtn;
    [bgNotLoginView addSubview:registBtn];

}

-(void)orderBtnClick
{
    if (IS_Login == YES) {
        // 我的订单
        XNRMyOrder_VC *orderVC=[[XNRMyOrder_VC alloc]init];
        orderVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        [[CommonTool sharedInstance]openLogin:self];
    }
}

-(void)loginBtnClick
{
    XNRLoginViewController *loginView = [[XNRLoginViewController alloc] init];
    loginView.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:loginView animated:YES];
    
}

-(void)registBtnClick
{
    XNRRegisterViewController *registerView = [[XNRRegisterViewController  alloc] init];
    registerView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerView animated:YES];

}
#pragma mark--创建底部视图
-(void)createMiddleView{
    
    // 我的订单
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(0, PX_TO_PT(320), ScreenWidth, PX_TO_PT(96));
    orderBtn.backgroundColor = [UIColor whiteColor];
    [orderBtn addTarget:self action:@selector(orderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.orderBtn = orderBtn;
    [self.mainScrollView addSubview:orderBtn];
    
    // 图标
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(18), PX_TO_PT(60), PX_TO_PT(60))];
    [imgView setImage:[UIImage imageNamed:@"icon_order"]];
    [orderBtn addSubview:imgView];
    
    // 主题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(112), PX_TO_PT(18), ScreenWidth-PX_TO_PT(112), PX_TO_PT(60))];
    titleLabel.text = @"我的订单";
    titleLabel.textColor = R_G_B_16(0x323232);
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    [orderBtn addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + PX_TO_PT(120), PX_TO_PT(18), ScreenWidth/2, PX_TO_PT(60))];
    detailLabel.text = @"查看全部订单";
    detailLabel.textColor = R_G_B_16(0x909090);
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(26)];
    [orderBtn addSubview:detailLabel];
    
    // 箭头
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(50), PX_TO_PT(32), PX_TO_PT(18), PX_TO_PT(32));
    [arrowBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [orderBtn addSubview:arrowBtn];

    
    NSArray*arr1=@[@"我的积分",@"新农代表",@"客服电话"];
    
    
    for (int i=0; i<arr1.count; i++) {
        UIButton *button=[MyControl createButtonWithFrame:CGRectMake(0,PX_TO_PT(416) + i*PX_TO_PT(88) ,ScreenWidth, PX_TO_PT(88)) ImageName:nil Target:self Action:@selector(buttonClick:) Title:nil];
        button.backgroundColor=[UIColor whiteColor];
        button.tag=KbtnTag+i;
        self.button = button;
        [self.mainScrollView addSubview:button];
        //图标
        UIImageView *iconImage=[MyControl createImageViewWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(11), PX_TO_PT(60),PX_TO_PT(60)) ImageName:[NSString stringWithFormat:@"icon_mine%d",i+1]];
        [button addSubview:iconImage];
        //主题
        UILabel*titleLabel=[MyControl createLabelWithFrame:CGRectMake(PX_TO_PT(112), PX_TO_PT(11),ScreenWidth - PX_TO_PT(112), PX_TO_PT(60)) Font:16 Text:arr1[i]];
        titleLabel.textColor=R_G_B_16(0x323232);
        titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
        [button addSubview:titleLabel];
        
        // 分割线
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(416), ScreenWidth, PX_TO_PT(1))];
        line1.backgroundColor = R_G_B_16(0xc7c7c7);
        [self.mainScrollView addSubview:line1];
        //分割线
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,PX_TO_PT(416)+i*PX_TO_PT(88), ScreenWidth, PX_TO_PT(1))];
        line2.backgroundColor=R_G_B_16(0xc7c7c7);
        [self.mainScrollView addSubview:line2];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(416)+2*PX_TO_PT(88) + PX_TO_PT(87), ScreenWidth, PX_TO_PT(1))];
        line3.backgroundColor = R_G_B_16(0xc7c7c7);
        [self.mainScrollView addSubview:line3];
    }
}

-(void)buttonClick:(UIButton*)btn{
    
    if(btn.tag == KbtnTag){
        if (IS_Login==YES) {
        //我的积分
        XNRMyscore_VC* scoreVC = [[XNRMyscore_VC alloc]init];
        scoreVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:scoreVC animated:YES];
         }else{
        [[CommonTool sharedInstance] openLogin:self];
    }
      
    }else if (btn.tag==KbtnTag+1){
        if (IS_Login == YES) {
        //新农代表
        XNRMyRepresentViewController *representVC=[[XNRMyRepresentViewController alloc]init];
        representVC.isBroker = self.isBroker;
        representVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:representVC animated:YES];
        }else{
            [[CommonTool sharedInstance] openLogin:self];
    }

    }else if (btn.tag == KbtnTag +2){
        // 客服电话
        if(TARGET_IPHONE_SIMULATOR){
            [UILabel showMessage:@"模拟器不支持打电话，请用真机测试"];
        } else {
            //请求客服电话接口
            [self phoneRequest];
        }
    }
}

-(void)phoneRequest
{
    UIWebView*phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"4000560371"]];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //本地用户信息状态设为非登录
        UserInfo *infos = [[UserInfo alloc]init];
        infos.loginState = NO;
        [DataCenter saveAccount:infos];
        //发送刷新通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageRefresh" object:nil];
        XNRLoginViewController *vc = [[XNRLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        XNRLoginViewController *login = [[XNRLoginViewController alloc]init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        
    }
}

-(void)iconClick:(UIButton*)button{
    if(IS_Login == YES){
        XNRMyaccount_VC*vc = [[XNRMyaccount_VC alloc]init];
        XNRUserInfoModel *Usermodel = [_userArray firstObject];
        vc.model  = Usermodel;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
       [[CommonTool sharedInstance]openLogin:self];
    }
    
}
- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(48)];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的新农人";
    self.navigationItem.titleView = titleLabel;
    
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
