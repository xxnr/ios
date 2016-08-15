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
#import "XNRMyRepresentViewController.h"
#import "XNRMySetterController.h"
#import "XNROrderInfo_VC.h"        // 订单信息
#import "XNRProductInfo_VC.h"      // 商品信息
#import "XNRCheckOrderVC.h"       // 查看订单
#import "XNRMyOrder_VC.h"          // 我的订单
#import "XNRMyStoreOrderController.h"
#import "SJAvatarBrowser.h"       // 浏览头像
#import "UIImageView+WebCache.h"
#import "XNRUserInfoModel.h"
#import "XNROffLine_VC.h"

#import "XNRMainGroup.h"
#import "XNRMainItem.h"
#import "XNRMainArrowItem.h"
#import "XNRMainCell.h"
#import "XNRNavigationController.h"

#import "XNRPayView.h"           //代付款
#import "XNRSendView.h"          //待发货
#import "XNRReciveView.h"        //待收货
#import "XNRCommentView.h"       //已完成

#define KbtnTag          1000

@interface XNRMineController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UIImageView *bgNotLoginView;
@property (nonatomic, weak) UIImageView *bgLoginView;

@property (nonatomic, weak) UITableView *mainTabelView;
@property (nonatomic, weak) UIView *topBgView;


@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIButton *registBtn;
@property (nonatomic, weak) UILabel *introduceLabel; // 昵称
@property (nonatomic, weak) UILabel *typeLabel;  // 类型
@property (nonatomic, weak) UILabel *addressLabel;     // 地址

@property (nonatomic, weak) UIButton *orderBtn;
@property (nonatomic, weak) UIImageView *arrowImg;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) UIImageView *badgeImage;
@property (nonatomic, strong) NSMutableArray *verifiedTypes;
@property (nonatomic, assign) BOOL isBroker;
@property (nonatomic, strong) NSMutableArray *userArray;

@property (nonatomic, weak) UIView *orderStateView;

@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation XNRMineController
- (NSMutableArray *)groups
{
    if (_groups == nil) {
        self.groups = [NSMutableArray array];
    }
    return _groups;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.view.backgroundColor = R_G_B_16(0xffffff);
    [_userArray removeAllObjects];
    XNRNavigationController *nav = (XNRNavigationController *)self.navigationController;
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_navbg"] forBarMetrics:UIBarMetricsDefault];
    
    if(IS_Login == YES){
        [_userArray addObject:[DataCenter account]];
        
        //初始化类型列表
        NSArray *Arr = [DataCenter account].verifiedTypes;
        [self.verifiedTypes removeAllObjects];
        [XNRMyRepresentViewController SetisBroker:NO];
        
        if ([DataCenter account].verifiedTypes.count > 0) {
            if ([[DataCenter account].verifiedTypes[0] isKindOfClass:[NSDictionary class]]) {
                for (int i=0 ; i<Arr.count; i++) {
                    NSString *name =[DataCenter account].verifiedTypes[i][@"typeName"];
                    [self.verifiedTypes addObject:name];
                    if ([name isEqualToString:@"新农经纪人"]) {
                        [XNRMyRepresentViewController SetisBroker:YES];
                    }
                }
            }
        }
        
        if (_userArray.count>0) {
            if (IS_Login) {
                [self createMainTableView];
                [self createLoginTopView];
                [self createMiddleView];
                
            }
            [self setupDatasWithcache];
        }else{
            [KSHttpRequest post:KUserGet parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
                
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
                    info.isRSC = dict[@"isRSC"];
                    info.verifiedTypes = dict[@"verifiedTypesInJson"];
                    
                    NSArray *Arr = dict[@"verifiedTypesInJson"];
                    [self.verifiedTypes removeAllObjects];
                    [XNRMyRepresentViewController SetisBroker:NO];
                    
                    for (int i=0 ; i<Arr.count; i++) {
                        NSString *name =dict[@"verifiedTypesInJson"][i][@"typeName"];
                        [self.verifiedTypes addObject:name];
                        if ([name isEqualToString:@"新农经纪人"]) {
                            [XNRMyRepresentViewController SetisBroker:YES];
                        }
                    }
                    
                    info.provinceID = province[@"id"];
                    info.cityID = city[@"id"];
                    info.countyID = county[@"id"];
                    [DataCenter saveAccount:info];
                    
                    [_userArray removeAllObjects];
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
                    if (IS_Login) {
                        [self createMainTableView];
                        [self createLoginTopView];
                        [self createMiddleView];
                        [self refreshTop];
                        
                    }
                    //设置视图的数据
                    [self setupDatas:model];
                }
                
            } failure:^(NSError *error) {
                [self createMainTableView];
                [self createLoginTopView];
                [self createMiddleView];
                [self refreshTop];
                
                [UILabel showMessage:@"网络请求失败"];
                
            }];
        }

    }else{
        // 创建TabelView
        
        [_userArray removeAllObjects];
        [self createMainTableView];
        [self createNotLoginTopView];
        [self createMiddleView];
    }
}

-(void)setupDatasWithcache
{
    // 头像
    if ([KSHttpRequest isBlankString:[DataCenter account].photo]) {// 没有头像
        self.icon.image=[UIImage imageNamed:@"icon_head"];
        
    }else{
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",HOST,[DataCenter account].photo];
        
        if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
            [self.icon setImage:[UIImage imageNamed:@"icon_head"]];
        }else{
            [self.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_head"]];
        }
    }
    // 昵称
    if ([KSHttpRequest isBlankString:[DataCenter account].nickname]) {
        self.introduceLabel.text = [NSString stringWithFormat:@"昵称: 新新农人"];
    }else{
        self.introduceLabel.text = [NSString stringWithFormat:@"昵称: %@",[DataCenter account].nickname];
    }
    // 地址
    if ([KSHttpRequest isBlankString:[DataCenter account].province]) {
        self.addressLabel.text = [NSString stringWithFormat:@"地区: %@",@"还没有填写哦~"];
    }else{
        if ([KSHttpRequest isBlankString:[DataCenter account].county]) {
            if ([KSHttpRequest isNULL:[DataCenter account].town]) {
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@",[DataCenter account].province,[DataCenter account].city];
            }else{
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].town];
            }
            
        }else{
            if ([KSHttpRequest isNULL:[DataCenter account].town]) {
                NSString *address = [NSString stringWithFormat:@"%@",[DataCenter account].county];
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@%@",[DataCenter account].province,[DataCenter account].city,address];
            }else{
                NSString *address = [NSString stringWithFormat:@"%@%@",[DataCenter account].county,[DataCenter account].town];
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@%@",[DataCenter account].province,[DataCenter account].city,address];
            }
        }
    }
    
    // 类型
    self.typeLabel.text = [DataCenter account].typeName?[NSString stringWithFormat:@"类型: %@",[DataCenter account].typeName]:@"类型: 还没有填写哦~";
    CGSize size = [self.typeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(26)]}];
    self.typeLabel.frame = CGRectMake(PX_TO_PT(200), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(16), size.width, PX_TO_PT(24));
    // 徽章
    if ([DataCenter account].type) {
        NSArray *Arr = [DataCenter account].verifiedTypes;
        if ([DataCenter account].verifiedTypes.count>0) {
            if ([[DataCenter account].verifiedTypes[0] isKindOfClass:[NSDictionary class]]) {
                for (int i=0; i<Arr.count; i++) {
                    NSString *name =[DataCenter account].verifiedTypes[i][@"typeName"];
                    if ([name isEqualToString:[DataCenter account].typeName]) {
                        self.badgeImage.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) + PX_TO_PT(14), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(16), PX_TO_PT(28), PX_TO_PT(36));
                        
                        self.badgeImage.hidden = NO;
                        break;
                    }
                }
            }

        }
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
        self.introduceLabel.text = [NSString stringWithFormat:@"昵称: 新新农人"];
    }else{
        self.introduceLabel.text = [NSString stringWithFormat:@"昵称: %@",model.nickname];
    }
    // 地址
    if ([KSHttpRequest isBlankString:model.province]) {
        self.addressLabel.text = [NSString stringWithFormat:@"地区: %@",@"还没有填写哦~"];
    }else{
        if ([KSHttpRequest isBlankString:model.county]) {
            if ([KSHttpRequest isNULL:model.town]) {
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@",model.province,model.city];
            }else{
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@%@",model.province,model.city,model.town];
            }
            
        }else{
            if ([KSHttpRequest isNULL:model.town]) {
                NSString *address = [NSString stringWithFormat:@"%@",model.county];
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@%@",model.province,model.city,address];
            }else{
                NSString *address = [NSString stringWithFormat:@"%@%@",model.county,model.town];
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@%@",model.province,model.city,address];
            }
        }
    }
    
    // 类型
    self.typeLabel.text = model.userTypeInName?[NSString stringWithFormat:@"类型: %@",model.userTypeInName]:@"类型: 还没有填写哦~";
    CGSize size = [self.typeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(26)]}];
    self.typeLabel.frame = CGRectMake(PX_TO_PT(200), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(16), size.width, PX_TO_PT(24));
    
    
    // 徽章
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
    [self.mainTabelView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationbarTitle];
    
    self.userArray = [NSMutableArray array];
    self.verifiedTypes = [NSMutableArray array];
    
    [self setupGroup];
}

-(void)setupGroup
{
    // 创建组
    XNRMainGroup *group = [XNRMainGroup group];
    [self.groups addObject:group];
    // 设置所有组的行数据
    XNRMainItem *myScore = [XNRMainItem itemWithTitle:@"我的积分" icon:@"icon_mine1"];
    myScore.destVcClass = [XNRMyscore_VC class];
    XNRMainItem *myRepresent = [XNRMainItem itemWithTitle:@"新农代表" icon:@"icon_mine2"];
    myRepresent.destVcClass = [XNRMyRepresentViewController class];
    XNRMainItem *myPhone = [XNRMainItem itemWithTitle:@"客服电话" icon:@"icon_mine3"];
    myPhone.subtitle = @"400-056-0371";
    myPhone.operation = ^{
        // 客服电话
        
        if(TARGET_IPHONE_SIMULATOR){
            [UILabel showMessage:@"模拟器不支持打电话，请用真机测试"];
        } else {
            //请求客服电话接口
            [self phoneRequest];
        }
    };
    XNRMainItem *mySet = [XNRMainItem itemWithTitle:@"设置" icon:@"icon_mine4"];
    mySet.destVcClass = [XNRMySetterController class];
    group.items = @[myScore,myRepresent,myPhone,mySet];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XNRMainGroup *group = self.groups[section];
    return group.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(88);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRMainCell *cell = [XNRMainCell cellWithTableView:tableView];
    XNRMainGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出这行对应的item模型
    XNRMainGroup *group = self.groups[indexPath.section];
    XNRMainItem *item = group.items[indexPath.row];
    
    // 2.判断有无需要跳转的控制器
    if (item.destVcClass) {
        if (indexPath.row == 3) {
            UIViewController *destVc = [[item.destVcClass alloc] init];
            destVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:destVc animated:YES];
        }else{
            if (IS_Login) {
//                UIViewController *destVc = [[item.destVcClass alloc] init];
                if (indexPath.row == 1) {
                   XNRMyRepresentViewController *destVc = (XNRMyRepresentViewController *)[[item.destVcClass alloc] init];
                    destVc.fromMine = YES;
                    destVc.bookfromMine = YES;
                    destVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:destVc animated:YES];
                }
                else
                {
                    UIViewController *destVc = [[item.destVcClass alloc] init];
                    destVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:destVc animated:YES];

                }
            }else{
                [[CommonTool sharedInstance]openLogin:self];
                
            }
        }
    }
    
    // 3.判断有无想执行的操作
    if (item.operation) {
        item.operation();
    }
}
-(void)createMainTableView{
    
    XNRUserInfoModel *infoMdoel = [_userArray firstObject];
    UIView *topBgView;
    if ([infoMdoel.isRSC integerValue] == 1) {
        topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(512))];
        topBgView.backgroundColor = [UIColor whiteColor];
        self.topBgView = topBgView;
        [self.view addSubview:topBgView];
    }else{
        topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(546))];
        topBgView.backgroundColor = [UIColor whiteColor];
        self.topBgView = topBgView;
        [self.view addSubview:topBgView];
    }
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    self.mainTabelView = mainTableView;
    mainTableView.delegate = self;
    mainTableView.dataSource  = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.tableHeaderView = topBgView;
    [self.view addSubview:mainTableView];
}
-(void)refreshTop
{
    // 头像
    if (![DataCenter account].photo) {// 没有头像
        self.icon.image=[UIImage imageNamed:@"icon_head"];
        
    }else{
        NSString *imageUrl = [DataCenter account].photo;
        
        if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
            [self.icon setImage:[UIImage imageNamed:@"icon_head"]];
        }else{
            [self.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_head"]];
        }
    }
    // 昵称
        self.introduceLabel.text = [DataCenter account].nickname?[DataCenter account].nickname:[NSString stringWithFormat:@"昵称: 新新农人"];
    // 地址
    if (![DataCenter account].province) {
        self.addressLabel.text = [NSString stringWithFormat:@"地区: %@",@"还没有填写哦~"];
    }else{
        if (![DataCenter account].county) {
            if (![DataCenter account].town) {
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@",[DataCenter account].province,[DataCenter account].city];
            }else{
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].town];
            }
            
        }else{
            if (![DataCenter account].town) {
                NSString *address = [NSString stringWithFormat:@"%@",[DataCenter account].county];
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@%@",[DataCenter account].province,[DataCenter account].city,address];
            }else{
                NSString *address = [NSString stringWithFormat:@"%@%@",[DataCenter account].county,[DataCenter account].town];
                self.addressLabel.text = [NSString stringWithFormat:@"地区: %@%@%@",[DataCenter account].province,[DataCenter account].city,address];
            }
        }
    }
    
    // 类型
    self.typeLabel.text = [DataCenter account].typeName?[NSString stringWithFormat:@"类型: %@",[DataCenter account].typeName]:@"类型: 还没有填写哦~";
    CGSize size = [self.typeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(26)]}];
    self.typeLabel.frame = CGRectMake(PX_TO_PT(200), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(16), size.width, PX_TO_PT(24));
    
    
    // 徽章
    if ([DataCenter account].typeName) {
        for (int i=0; i<self.verifiedTypes.count; i++) {
            if ([self.verifiedTypes[i] isEqualToString:[DataCenter account].typeName]) {
                self.badgeImage.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) + PX_TO_PT(14), CGRectGetMaxY(self.addressLabel.frame) + PX_TO_PT(16), PX_TO_PT(28), PX_TO_PT(36));
                
                self.badgeImage.hidden = NO;
                break;
            }
        }
    }
}
-(void)createLoginTopView
{
    UIImageView *bgLoginView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(320))];
    [bgLoginView setImage:[UIImage imageNamed:@"icon_bgView"]];
    bgLoginView.userInteractionEnabled  = YES;
    self.bgLoginView = bgLoginView;
    [self.topBgView addSubview:bgLoginView];
    
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


    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200), PX_TO_PT(120), ScreenWidth, PX_TO_PT(30))];
    introduceLabel.textColor = R_G_B_16(0xffffff);
    introduceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    self.introduceLabel = introduceLabel;
    [self.bgLoginView addSubview:introduceLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200),(CGRectGetMaxY(self.introduceLabel.frame) + PX_TO_PT(16)), ScreenWidth - PX_TO_PT(70)-PX_TO_PT(200), PX_TO_PT(40))];
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

    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(50), CGRectGetMaxY(self.introduceLabel.frame) + PX_TO_PT(18), PX_TO_PT(18), PX_TO_PT(32))];
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
    [self.topBgView addSubview:bgNotLoginView];
    
    //头像
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PX_TO_PT(150), PX_TO_PT(150))];
    icon.clipsToBounds=YES;
    icon.center = CGPointMake(ScreenWidth/2, PX_TO_PT(125));
    icon.layer.cornerRadius=PX_TO_PT(75);
//    icon.layer.borderColor= [UIColor whiteColor].CGColor ;
//    icon.layer.borderWidth=3;
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
    loginBtn.layer.borderWidth = PX_TO_PT(2);
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
    registBtn.layer.borderWidth = PX_TO_PT(2);
    registBtn.layer.cornerRadius = 5.0;
    registBtn.clipsToBounds = YES;
    [registBtn addTarget: self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.registBtn = registBtn;
    [bgNotLoginView addSubview:registBtn];
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
    XNRUserInfoModel *infoModel = [_userArray firstObject];
    UIButton *myStoreBtn;
    UIButton *orderBtn;
    if ([infoModel.isRSC integerValue] == 1) {
        // 我的网点
        myStoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        myStoreBtn.frame = CGRectMake(0, PX_TO_PT(320), ScreenWidth, PX_TO_PT(96));
        myStoreBtn.backgroundColor = [UIColor whiteColor];
        [myStoreBtn addTarget:self action:@selector(myStoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.topBgView addSubview:myStoreBtn];
        
        // 我的订单
        orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(0, PX_TO_PT(416), ScreenWidth, PX_TO_PT(96));
        orderBtn.backgroundColor = [UIColor whiteColor];
        [orderBtn addTarget:self action:@selector(orderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.orderBtn = orderBtn;
        [self.topBgView addSubview:orderBtn];
        
    }else{
        orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(0, PX_TO_PT(320), ScreenWidth, PX_TO_PT(96));
        orderBtn.backgroundColor = [UIColor whiteColor];
        [orderBtn addTarget:self action:@selector(orderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.orderBtn = orderBtn;
        [self.topBgView addSubview:orderBtn];
    }
    // 图标
    UIImageView *storeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(18), PX_TO_PT(60), PX_TO_PT(60))];
    [storeImgView setImage:[UIImage imageNamed:@"branch_icon"]];
    [myStoreBtn addSubview:storeImgView];
    
    // 主题
    UILabel *storeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(112), PX_TO_PT(18), ScreenWidth-PX_TO_PT(112), PX_TO_PT(60))];
    storeTitleLabel.text = @"我的网点";
    storeTitleLabel.textColor = R_G_B_16(0x323232);
    storeTitleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [myStoreBtn addSubview:storeTitleLabel];
    
    // 箭头
    UIButton *storeArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    storeArrowBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(50), PX_TO_PT(32), PX_TO_PT(18), PX_TO_PT(32));
    [storeArrowBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [myStoreBtn addSubview:storeArrowBtn];
    
    CALayer *storeLineLayer = [[CALayer alloc] init];
    storeLineLayer.frame = CGRectMake(0, PX_TO_PT(94), ScreenWidth, 1);
    storeLineLayer.backgroundColor = R_G_B_16(0xe0e0e0).CGColor;
    [myStoreBtn.layer addSublayer:storeLineLayer];

    // 图标
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(18), PX_TO_PT(60), PX_TO_PT(60))];
    [imgView setImage:[UIImage imageNamed:@"icon_order"]];
    [orderBtn addSubview:imgView];
    
    // 主题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(112), PX_TO_PT(18), ScreenWidth-PX_TO_PT(112), PX_TO_PT(60))];
    titleLabel.text = @"我的订单";
    titleLabel.textColor = R_G_B_16(0x323232);
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [orderBtn addSubview:titleLabel];
    
    
    // 箭头
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(50), PX_TO_PT(32), PX_TO_PT(18), PX_TO_PT(32));
    [arrowBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [orderBtn addSubview:arrowBtn];
    
   CGFloat width = [UIImage imageNamed:@"arrow"].size.width + PX_TO_PT(32)+PX_TO_PT(10);
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PX_TO_PT(18), ScreenWidth-width, PX_TO_PT(60))];
    detailLabel.text = @"查看全部订单";
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.textColor = R_G_B_16(0x909090);
    detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(26)];
    [orderBtn addSubview:detailLabel];

    
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.frame = CGRectMake(0, PX_TO_PT(95), ScreenWidth, 1);
    lineLayer.backgroundColor = R_G_B_16(0xe0e0e0).CGColor;
    [orderBtn.layer addSublayer:lineLayer];

    // 我的订单的状态
    UIView *orderStateView ;
    if ([infoModel.isRSC integerValue] == 1) {
        return;
    }else{
        orderStateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(orderBtn.frame), ScreenWidth, PX_TO_PT(130))];
        orderStateView.backgroundColor = [UIColor whiteColor];
        self.orderStateView = orderStateView;
        [self.topBgView addSubview:orderStateView];
    }
    NSArray *orderStateImage = @[@"待付款icon-拷贝",@"代发货icon1-拷贝",@"已发货icon-拷贝",@"已完成icon-拷贝"];
    NSArray *orderStateTitle = @[@"待付款",@"待发货",@"待收货",@"已完成"];
    
    CGFloat margin = (ScreenWidth-4*PX_TO_PT(49)-PX_TO_PT(64))/8;
    CGFloat imageY = PX_TO_PT(16);
    CGFloat imageW = PX_TO_PT(49);
    CGFloat imageH = PX_TO_PT(47);
    
    for (int i = 0; i<orderStateImage.count; i++) {
        UIImageView *orderStateImageView = [[UIImageView alloc] init];
        orderStateImageView.frame = CGRectMake(((ScreenWidth-PX_TO_PT(64))/4)*i+margin+PX_TO_PT(32),imageY, imageW, imageH);
        orderStateImageView.image = [UIImage imageNamed:orderStateImage[i]];
        [orderStateView addSubview:orderStateImageView];
        
        UILabel *orderStateTitleLabel = [[UILabel alloc] init];
        orderStateTitleLabel.frame = CGRectMake(((ScreenWidth-PX_TO_PT(64))/4)*i+PX_TO_PT(32), CGRectGetMaxY(orderStateImageView.frame)+margin*0.3, ScreenWidth/4, PX_TO_PT(28));
        orderStateTitleLabel.text = orderStateTitle[i];
        orderStateTitleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        orderStateTitleLabel.textColor = R_G_B_16(0x323232);
        orderStateTitleLabel.textAlignment = NSTextAlignmentCenter;
        [orderStateView addSubview:orderStateTitleLabel];
        
        UIButton *orderStateBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth/4)*i, 0, ScreenWidth/4, PX_TO_PT(130))];
        [orderStateBtn addTarget:self action:@selector(orderStateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        orderStateBtn.tag = 1000+i;
        [orderStateView addSubview:orderStateBtn];

    }
    
    CALayer *orderlineLayer = [[CALayer alloc] init];
    orderlineLayer.frame = CGRectMake(0, PX_TO_PT(129), ScreenWidth, 1);
    orderlineLayer.backgroundColor = R_G_B_16(0xe0e0e0).CGColor;
    [orderStateView.layer addSublayer:orderlineLayer];

    
}

-(void)orderBtnClick
{
    if (IS_Login == YES) {
        // 我的订单
        XNRMyOrder_VC *orderVC = [[XNRMyOrder_VC alloc]init];
        orderVC.isForm0rderBtn = YES;
        orderVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        [[CommonTool sharedInstance]openLogin:self];
    }
}

-(void)myStoreBtnClick
{
    if (IS_Login == YES) {
        // 我的网点
        XNRMyStoreOrderController *orderVC = [[XNRMyStoreOrderController alloc]init];
        orderVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        [[CommonTool sharedInstance]openLogin:self];
    }
}


-(void)orderStateBtnClick:(UIButton *)button
{
    if (IS_Login) {
        XNRMyOrder_VC *orderVC = [[XNRMyOrder_VC alloc] init];
        orderVC.hidesBottomBarWhenPushed = YES;
        if (button.tag == 1000) {
            orderVC.type = XNRPayViewtype;
            [self.navigationController pushViewController:orderVC animated:YES];
            
        }else if(button.tag == 1001){
            orderVC.type = XNRSendViewType;
            [self.navigationController pushViewController:orderVC animated:YES];
            
            
        }else if (button.tag == 1002){
            orderVC.type = XNRReciveViewType;
            [self.navigationController pushViewController:orderVC animated:YES];
            
            
        }else{
            orderVC.type = XNRCommentViewType;
            [self.navigationController pushViewController:orderVC animated:YES];
        }

    }else{
        [[CommonTool sharedInstance] openLogin:self];
    }
}

-(void)phoneRequest
{
    UIWebView*phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"4000560371"]];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
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
        XNRMyaccount_VC *vc = [[XNRMyaccount_VC alloc]init];
        XNRUserInfoModel *Usermodel = [_userArray firstObject];
        vc.model  = Usermodel;
        vc.hidesBottomBarWhenPushed=YES;
        vc.isfromMineVC = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
       [[CommonTool sharedInstance] openLogin:self];
    }
    
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

- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
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
