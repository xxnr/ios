//
//  XNRMySetterController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/18.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRMySetterController.h"
#import "XNRMainGroup.h"
#import "XNRMainItem.h"
#import "XNRMainArrowItem.h"
#import "XNRMySetterCell.h"
#import "XNRAboutMainController.h"
#import "XNRNavigationController.h"
#import "XNRUMShareView.h"
//#import "SDImageCache.h"
#import "NSString+File.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"


@interface XNRMySetterController ()<XNRUMShareViewDelegate>

@property (nonatomic, strong) NSMutableArray *groups;

@property (nonatomic, weak) XNRUMShareView *shareView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, weak) UIImageView *circleImage;

@property(nonatomic,assign)double angle;


@end

@implementation XNRMySetterController

-(XNRUMShareView *)shareView
{
    if (!_shareView) {
        XNRUMShareView *shareView = [[XNRUMShareView alloc] init];
        shareView.delegate = self;
        self.shareView = shareView;
        [self.view addSubview:shareView];
    }
    return _shareView;
}

-(void)XNRUMShareViewBtnClick:(XNRUMShareViewType)type
{
    
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];

    UIImage *shareImage = [UIImage imageNamed:@"share_icon"];
    
    NSString *contentString = @"农业互联网综合服务领先者";
   
    if (type == wechatbtn_type) {
        [UMSocialData defaultData].extConfig.wechatSessionData.url = APPURL;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"新新农人 - 农业互联网综合服务平台";
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:contentString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [UILabel showShareMessage:@"分享成功"];
            }else{
                [UILabel showShareMessage:@"分享失败"];
            }
            [self.shareView cancel];
        }];
  

    }else if (type == wechatCirclebtn_type){
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = APPURL;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"新新农人 - 农业互联网综合服务平台";

        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:contentString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [UILabel showShareMessage:@"分享成功"];
            }else{
                [UILabel showShareMessage:@"分享失败"];
            }
            [self.shareView cancel];
        }];

    }else if (type == qqbtn_type){
        [UMSocialData defaultData].extConfig.qqData.url = APPURL;
        [UMSocialData defaultData].extConfig.qqData.title = @"新新农人 - 农业互联网综合服务平台";

        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:contentString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [UILabel showShareMessage:@"分享成功"];
            }else{
                [UILabel showShareMessage:@"分享失败"];
            }
            [self.shareView cancel];
        }];

    }else if(type == qzonebtn_type){
        [UMSocialData defaultData].extConfig.qzoneData.url = APPURL;
        [UMSocialData defaultData].extConfig.qzoneData.title = @"新新农人 - 农业互联网综合服务平台";

        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:contentString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                [UILabel showShareMessage:@"分享成功"];
            }else{
                [UILabel showShareMessage:@"分享失败"];
            }
            [self.shareView cancel];
        }];

        
    }
}

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        self.groups = [NSMutableArray array];
    }
    return _groups;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    XNRNavigationController *nav = (XNRNavigationController *)self.navigationController;
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_navbg"] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = NO;
    
    [self setNavigationbarTitle];
    
    [self setupGroups];

    
}

-(void)setupGroups
{
    [self setupGroupOne];
    [self setupGroupTwo];
    [self setupGroupThree];
    
}

-(void)setupGroupOne
{
    // 1.创建组
    XNRMainGroup *group = [XNRMainGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    XNRMainItem *messageNotify = [XNRMainItem itemWithTitle:@"消息通知" icon:@"notification"];
    messageNotify.operation = ^{
        NSURL*url=[NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
        [[UIApplication sharedApplication] openURL:url];
    };
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            NSLog(@"推送关闭");
            messageNotify.subtitle = @"已关闭";
            [self.tableView reloadData];

        }else{
            NSLog(@"推送打开");
            messageNotify.subtitle = @"已开启";
            [self.tableView reloadData];


        }
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            NSLog(@"推送关闭");
            messageNotify.subtitle = @"已关闭";
            [self.tableView reloadData];


        }else{
            NSLog(@"推送打开");
            messageNotify.subtitle = @"已开启";
            [self.tableView reloadData];
        }
    }
    group.items = @[messageNotify];
}

-(void)setupGroupTwo
{
    // 1.创建组
    XNRMainGroup *group = [XNRMainGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    XNRMainArrowItem *cleanCache = [XNRMainArrowItem itemWithTitle:@"清除缓存" icon:@"bin-"];
//    NSString *imageCachePath = [SDImageCache sharedImageCache].diskCachePath;
//    long long fileSize = [imageCachePath fileSize];
//    if (fileSize>0) {
//        cleanCache.subtitle = [NSString stringWithFormat:@"(%.1fM)", fileSize / (1000.0 * 1000.0)];
//    }
        __weak typeof(cleanCache) weakClearCache = cleanCache;
        __weak typeof(self) weakVc = self;
        cleanCache.operation = ^{
            
            BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"确定清除缓存的图片和数据吗？" chooseBtns:@[@"取消",@"确定"]];
            alertView.chooseBlock = ^void(UIButton *btn){
                if (btn.tag == 11) {
                    
                    [self createCoverView];
                    // 清除缓存
                    NSFileManager *mgr = [NSFileManager defaultManager];
//                    [mgr removeItemAtPath:imageCachePath error:nil];
                    
                    // 设置subtitle
                    weakClearCache.subtitle = nil;
                    
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            [self.circleImage removeFromSuperview];
                            self.titleLabel.text = @"缓存已经清理干净啦!";
                        });
                    
                    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delay, dispatch_get_main_queue(), ^{
                        [self.coverView removeFromSuperview];
                        [self.titleLabel removeFromSuperview];
                    });


                    // 刷新表格
                    [weakVc.tableView reloadData];                    
                }
            };
            [alertView BMAlertShow];
        };
    group.items = @[cleanCache];

}


-(void)createCoverView
{
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.6;
    self.coverView = coverView;
    [AppKeyWindow addSubview:coverView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PX_TO_PT(420), PX_TO_PT(88))];
    titleLabel.centerX = ScreenWidth/2;
    titleLabel.centerY = ScreenHeight/2;
    titleLabel.layer.cornerRadius = 5;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.alpha = 0.32;
    titleLabel.text = @"正在清除请稍后...";
    titleLabel.textColor = R_G_B_16(0xffffff);
    self.titleLabel = titleLabel;
    [AppKeyWindow addSubview:titleLabel];
    
    UIImageView *circleImage = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(10), PX_TO_PT(22), PX_TO_PT(44), PX_TO_PT(44))];
    circleImage.image = [UIImage imageNamed:@"loader-"];
    self.circleImage = circleImage;
    [titleLabel addSubview:circleImage];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(transformAction) userInfo:nil repeats:YES];

}

-(void)transformAction {
    _angle += 0.5;//angle角度 double angle;
    if (_angle > 6.28) {//大于 M_PI*2(360度) 角度再次从0开始
        _angle = 0;
    }
//        [UIView animateWithDuration:0.5 animations:^{
    self.circleImage.transform = CGAffineTransformMakeRotation(M_PI);
//        }];
}


-(void)setupGroupThree
{
    
    // 1.创建组
    XNRMainGroup *group = [XNRMainGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    XNRMainArrowItem *shareAPP = [XNRMainArrowItem itemWithTitle:@"推荐新新农人给好友" icon:@"recommended--"];
    shareAPP.operation = ^{
        [self.shareView show];
    };
    XNRMainArrowItem *about = [XNRMainArrowItem itemWithTitle:@"关于" icon:@"about"];
    about.destVcClass = [XNRAboutMainController class];

    group.items = @[shareAPP,about];

}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(88);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XNRMainGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRMySetterCell *cell = [XNRMySetterCell cellWithTableView:tableView];
    XNRMainGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    // 设置cell所处的行号 和 所处组的总行数
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(98))];
        sectionHeadView.backgroundColor = R_G_B_16(0xfafafa);
        [self.view addSubview:sectionHeadView];
        
        UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth-PX_TO_PT(60), PX_TO_PT(98))];
        sectionTitleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        sectionTitleLabel.textColor = R_G_B_16(0xA2A2A2);
        sectionTitleLabel.numberOfLines = 0;
        sectionTitleLabel.text = @"若您要关闭或开启消息通知，请在iPhone的【设置】-【通知】中，找到应用“新新农人”更改";
        [sectionHeadView addSubview:sectionTitleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, 1)];
        lineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [sectionHeadView addSubview:lineView];
        
        return sectionHeadView;
  
    }else{
        UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(98))];
        sectionHeadView.backgroundColor = R_G_B_16(0xfafafa);
        [self.view addSubview:sectionHeadView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, 1)];
        lineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [sectionHeadView addSubview:lineView];


        return sectionHeadView;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return PX_TO_PT(98);
    }else{
        return PX_TO_PT(20);
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出这行对应的item模型
    XNRMainGroup *group = self.groups[indexPath.section];
    XNRMainItem *item = group.items[indexPath.row];
    
    // 2.判断有无需要跳转的控制器
    if (item.destVcClass) {
        UIViewController *destVc = [[item.destVcClass alloc] init];
//        destVc.title = item.title;
        destVc.hidesBottomBarWhenPushed = YES;
        destVc.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        [self.navigationController pushViewController:destVc animated:YES];
    }
    
    // 3.判断有无想执行的操作
    if (item.operation) {
        item.operation();
    }
}


- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(48)];
    titleLabel.textColor = R_G_B_16(0xfbffff);

    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设置";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
