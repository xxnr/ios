//
//  XNRHomeController.m
//  qianxiheiOS
//
//  Created by Scarecrow on 15/5/18.
//  Copyright (c) 2015年 XNRiOS. All rights reserved.
//

#import "XNRHomeController.h"
#import "XNRShoppingCartModel.h"
#import "XNRHomeCollectionViewCell.h"
#import "XNRHomeCollectionHeaderView.h"
#import "XNRHomeCollectionFooterView.h"
#import "XNRSignInView.h"
#import "XNRProductInfo_VC.h"
#import "XNRLoginViewController.h"
#import "XNRCyclePicModel.h"
#import "XNRSpecialViewController.h"
#import "XNRCarSelect.h"
#import "XNRHomeSelectBrandView.h"
#import "AppDelegate.h"
#import "XNRRemaindUserUpdataTool.h"
#import "XNRUMengPushTool.h"
#import "XNRCheckOrderVC.h"
#import "BSHelper.h"
#define kStoreAppId  @"1021223448"  // （appid数字串）

@interface XNRHomeController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UICollectionViewDelegate,XNRHomeCollectionHeaderViewAddBtnDelegate,XNRFerSelectAddBtnDelegate>
{
    NSMutableArray *_huafeiArr; //化肥数据
    NSMutableArray *_carArr;    //农用车数据
}
@property (nonatomic,strong) NSMutableArray*cyclePicArr;//轮播图数组
@property (nonatomic,strong) XNRSignInView *signInView;  //签到
@property (nonatomic,strong) UICollectionView *homeCollectionView;
@property (nonatomic,strong) XNRHomeCollectionHeaderView *headView;
@property (nonatomic, weak) UIButton *backtoTopBtn;
@property (nonatomic, weak) NSString *message;
@property (nonatomic, weak) NSString *version;

@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIView *upDataAlertView;
@end

@implementation XNRHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置参数
    [self setTheParameters];
    // 创建列表
    [self createHomeCollectionView];
    // 创建导航栏按钮
    [self setNavigationbarBtn];
    // 创建轮播数据
    [self getCircleData];
    // 获取网络数据
    [self getFerData];
    // 设置返回到顶部按钮
    [self createbackBtn];
    

    // 调用友盟的方法
    NSDictionary *launchOptions = [AppDelegate shareAppDelegate].launchOptions;
    [XNRUMengPushTool umengTrack:launchOptions];

    
    //接收登录界面传递的页面刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPageRefresh) name:@"PageRefresh" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openOrderIdController:) name:@"openOrderIDController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openWebSiteController:) name:@"openWebSiteController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remaindUserToUpdate) name:@"remaindUserToUpdate" object:nil];
}

-(void)remaindUserToUpdate
{
    // 提示用户更新
    NSString *deviceToken = [AppDelegate shareAppDelegate].deviceToken;
    NSString *UUID = [BSHelper saveKeyString];
    NSLog(@"UUID ===== %@",UUID);
    // 获得当前软件的版本号
    NSString *versionKey = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    NSLog(@"currentVersion== %@",currentVersion);

    // 提示更新
    [KSHttpRequest post:KuserUpData parameters:@{@"version":currentVersion,@"device_token":deviceToken?deviceToken:@"",@"device_id":UUID?UUID:deviceToken,@"user_agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            _version = result[@"version"];
            _message = result[@"message"];
            [self createUpdataAlertView:_message];

        }
    } failure:^(NSError *error) {
        
    }];

//    [XNRRemaindUserUpdataTool remaindUserUpData:deviceToken];
}

-(void)createUpdataAlertView:(NSString *)message
{
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.6;
    self.coverView = coverView;
    [AppKeyWindow addSubview:coverView];
    
    UIView *upDataAlertView = [[UIView alloc] init];
//                               WithFrame:CGRectMake(PX_TO_PT(80), (ScreenHeight-PX_TO_PT(432))*0.5, PX_TO_PT(590), PX_TO_PT(432))];
    upDataAlertView.backgroundColor = [UIColor whiteColor];
    upDataAlertView.layer.cornerRadius = 5.0;
    upDataAlertView.layer.masksToBounds = YES;
    self.upDataAlertView = upDataAlertView;
    [AppKeyWindow addSubview:upDataAlertView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(42), PX_TO_PT(590), PX_TO_PT(36))];
    titleLabel.text = @"版本更新";
    titleLabel.textColor = R_G_B_16(0x323232);
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [upDataAlertView addSubview:titleLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), CGRectGetMaxY(titleLabel.frame)+PX_TO_PT(28), PX_TO_PT(590), PX_TO_PT(36))];
    versionLabel.text = [NSString stringWithFormat:@"V%@",_version];
    versionLabel.textColor = R_G_B_16(0x323232);
    versionLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [upDataAlertView addSubview:versionLabel];
    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), CGRectGetMaxY(versionLabel.frame)+PX_TO_PT(32), PX_TO_PT(530), PX_TO_PT(126))];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.separatorStyle = NO;
//    _messageArray = [NSMutableArray array];
//    [upDataAlertView addSubview:tableView];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(versionLabel.frame)+PX_TO_PT(32), PX_TO_PT(530), PX_TO_PT(500))];
    messageLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    messageLabel.textColor = R_G_B_16(0x323232);
    messageLabel.numberOfLines = 0;
    [upDataAlertView addSubview:messageLabel];
    
    messageLabel.text = message;
    CGSize messageSize = [messageLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(30)]}];
    messageLabel.frame = CGRectMake(PX_TO_PT(30), CGRectGetMaxY(versionLabel.frame)+PX_TO_PT(32), PX_TO_PT(530), messageSize.height);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:PX_TO_PT(12)];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [messageLabel.text length])];
    messageLabel.attributedText = attributedString;
    [messageLabel sizeToFit];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(messageLabel.frame)+PX_TO_PT(32), PX_TO_PT(590), PX_TO_PT(1))];
    lineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [upDataAlertView addSubview:lineView];


    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), PX_TO_PT(295), PX_TO_PT(100))];
    [cancelBtn setTitle:@"以后再说" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [cancelBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#ffffff"]] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fafafa"]] forState:UIControlStateHighlighted];
    [cancelBtn addTarget: self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [upDataAlertView addSubview:cancelBtn];
    
    
    UIButton *admireBtn = [[UIButton alloc] initWithFrame:CGRectMake(PX_TO_PT(295), CGRectGetMaxY(lineView.frame), PX_TO_PT(295), PX_TO_PT(100))];
    [admireBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [admireBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];
    admireBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#ffffff"]] forState:UIControlStateNormal];
    [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fafafa"]] forState:UIControlStateHighlighted];
    [admireBtn addTarget: self action:@selector(admireBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [upDataAlertView addSubview:admireBtn];
    
    
    UIView *devidelineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(295), CGRectGetMaxY(lineView.frame), PX_TO_PT(1), PX_TO_PT(100))];
    devidelineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [upDataAlertView addSubview:devidelineView];
    
    upDataAlertView.frame = CGRectMake(PX_TO_PT(80), (ScreenHeight-CGRectGetMaxY(admireBtn.frame))*0.5, PX_TO_PT(590), CGRectGetMaxY(admireBtn.frame));
}

-(void)cancelBtnClick{
    [self.coverView removeFromSuperview];
    [self.upDataAlertView removeFromSuperview];
}

-(void)admireBtnBtnClick{
    // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/xin-xin-nong-ren-hu-lian-wang/id%@?l=en&mt=8", kStoreAppId]];
    [[UIApplication sharedApplication] openURL:url]; 
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *message = [_messageArray firstObject];
//    CGSize messageSize = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(24)]}];
//    return messageSize.height;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//    XNRUpdataCell *cell = [XNRUpdataCell cellWithTableView:tableView];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    [cell upDataWithData:_messageArray];
//    
//    return cell;
//}

-(void)openOrderIdController:(NSNotification *)notification
{
    
    XNRCheckOrderVC *orderVC = [[XNRCheckOrderVC alloc]init];
    orderVC.orderID = (NSString *)notification.userInfo;
    [self.navigationController pushViewController:orderVC animated:orderVC];
}

-(void)openWebSiteController:(NSNotification *)notification
{

}

#pragma mark - 页面刷新
- (void)dealPageRefresh
{
    [self getFerData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 滑动到顶部按钮
-(void)createbackBtn
{
    UIButton *backtoTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backtoTopBtn.frame = CGRectMake(ScreenWidth-PX_TO_PT(60)-PX_TO_PT(32), ScreenHeight-PX_TO_PT(360), PX_TO_PT(100), PX_TO_PT(100));
    [backtoTopBtn setImage:[UIImage imageNamed:@"icon_home_backTop"] forState:UIControlStateNormal];
    [backtoTopBtn addTarget:self action:@selector(backtoTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backtoTopBtn = backtoTopBtn;
    self.backtoTopBtn.hidden = YES;
    [self.view addSubview:backtoTopBtn];
}

-(void)backtoTopBtnClick{
    [self.homeCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 0) {
        self.backtoTopBtn.hidden = YES;
    }else{
        self.backtoTopBtn.hidden = NO;
    }
}

#pragma mark - 导航栏
-(void)setNavigationbarBtn{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"新新农人";
    self.navigationItem.titleView = titleLabel;
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(0, 0, 30, 30);
    [signBtn setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:signBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 请求签到
-(void)signBtnClick{
    __weak __typeof(self)weakSelf = self;
    if (IS_Login) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [weakSelf requestSignIn];
        });
    }
    //非登录提示登录
    else{
        [[CommonTool sharedInstance] openLogin:weakSelf];
    }
}

- (void)requestSignIn
{
    [BMProgressView showCoverWithTarget:self.view color:nil isNavigation:YES];
    [KSHttpRequest post:KUserSign parameters:@{@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *datasDic = result[@"datas"];
            NSNumber *pointNum = datasDic[@"pointAdded"];
            NSString *pointStr = pointNum.stringValue;
            self.signInView = [[XNRSignInView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [self.signInView createSignSucessImageView:pointStr];
            __weak __typeof(self)weakSelf = self;
            self.signInView.deleteBlock = ^{
                [weakSelf.signInView removeFromSuperview];
                weakSelf.signInView = nil;
            };
            [BMProgressView LoadViewDisappear:self.view];
            //保存签到
            [CommonTool saveSignIn];
        }
        else if([result[@"code"] integerValue] == 1010){
            [UILabel showMessage:result[@"message"]];
            [BMProgressView LoadViewDisappear:self.view];
        }else{
            [UILabel showMessage:@"未查询到积分规则"];
            [BMProgressView LoadViewDisappear:self.view];

        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [UILabel showMessage:@"签到失败"];
        [BMProgressView LoadViewDisappear:self.view];


    }];
}

#pragma mark - 设置参数
- (void)setTheParameters
{
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _cyclePicArr=[[NSMutableArray alloc]init];// 轮播图
    _huafeiArr = [[NSMutableArray alloc]init];// 化肥
    _carArr = [[NSMutableArray alloc]init];// 汽车
}


#pragma mark - 获取轮播数据
-(void)getCircleData{
    [_cyclePicArr removeAllObjects];
    [KSHttpRequest post:KHomeGetAdList parameters:@{@"user-agent":@"IOS-v2.0"} success:^(id result) {
       if ([result[@"code"] integerValue] == 1000) {
           NSDictionary *datasDic = result[@"datas"];
           NSArray *rowsArr = datasDic[@"rows"];
           for (NSDictionary *subDic in rowsArr) {
               XNRCyclePicModel *model = [[XNRCyclePicModel alloc]init];
               [model setValuesForKeysWithDictionary:subDic];
               [_cyclePicArr addObject:model];
           }
       }
      
       [self.homeCollectionView reloadData];
    

   } failure:^(NSError *error) {
       
   }];
}
#pragma mark - 创建列表
- (void)createHomeCollectionView {
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-49) collectionViewLayout:flowLayout];
    self.homeCollectionView.showsVerticalScrollIndicator = NO;

    self.homeCollectionView.backgroundColor = [UIColor clearColor];
    self.homeCollectionView.delegate = self;
    self.homeCollectionView.dataSource = self;
    // 注册cell
    [self.homeCollectionView registerClass:[XNRHomeCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    
    [self.homeCollectionView registerClass:[XNRHomeCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderIdentifierFirst"];
    
    [self.homeCollectionView registerClass:[XNRCarSelect class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderIdentifierSecond"];
    
    [self.homeCollectionView registerClass:[XNRHomeCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterIdentifier"];
    
    [self.view addSubview:self.homeCollectionView];
    
        
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFerData)];
    
    NSMutableArray *idleImage = [NSMutableArray array];
    for (int i = 1; i<21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
        
        [idleImage addObject:image];
    }
    NSMutableArray *RefreshImage = [NSMutableArray array];
    
    for (int i = 1; i<21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d", i]];
        
        [RefreshImage addObject:image];
        
    }
    [header setImages:idleImage forState:MJRefreshStateIdle];
    [header setImages:RefreshImage forState:MJRefreshStatePulling];
    [header setImages:RefreshImage forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    self.homeCollectionView.mj_header = header;

}

#pragma mark -- collectionView的代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenWidth, PX_TO_PT(540));
    } else {
        return CGSizeMake(ScreenWidth, PX_TO_PT(90));
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, PX_TO_PT(5));
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            XNRHomeCollectionHeaderView  *headView = (XNRHomeCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderIdentifierFirst" forIndexPath:indexPath];
            headView.com = ^(){
                XNRSpecialViewController *specialCar_VC = [[XNRSpecialViewController alloc] init];
                specialCar_VC.type = eXNRCarType;
                specialCar_VC.hidesBottomBarWhenPushed = YES;
                specialCar_VC.tempTitle = @"汽车";
                specialCar_VC.classId = @"6C7D8F66";

                for (int i = 0; i<_huafeiArr.count; i++) {
                    specialCar_VC.model = _huafeiArr[i];
                }

                [self.navigationController pushViewController:specialCar_VC animated:YES];
            };
            headView.delegate = self;
            if (_cyclePicArr.count != 0) {
                NSMutableArray *urlArr = [NSMutableArray array];
                for (XNRCyclePicModel *model in _cyclePicArr) {
                    [urlArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,model.imgUrl]]];
                }
                [headView createCycleScrollViewWith:urlArr];
            }
            
            return headView;
        }else{
            XNRCarSelect *headView = (XNRCarSelect *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderIdentifierSecond" forIndexPath:indexPath];
            
            headView.con = ^(){
                 XNRSpecialViewController *specialFer_VC = [[XNRSpecialViewController alloc] init];
                specialFer_VC.type = eXNRFerType;
                specialFer_VC.hidesBottomBarWhenPushed = YES;
                specialFer_VC.tempTitle = @"化肥";
                specialFer_VC.classId = @"531680A5";
                for (int i = 0; i<_carArr.count; i++) {
                specialFer_VC.model = _carArr[i];
                }

                [self.navigationController pushViewController:specialFer_VC animated:YES];
 
            
            };
//            self.headView.cycleScrollView.hidden = YES;
            self.headView.ferBtn.hidden = YES;
            self.headView.carBtn.hidden = YES;
            self.headView.imageView.hidden = YES;
            
            return headView;
        }
    }else{
        XNRHomeCollectionFooterView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterIdentifier" forIndexPath:indexPath];
        return footView;
        
    }
}

-(void)dismiss
{
     [BMProgressView LoadViewDisappear:self.view];
}
// 展示Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_carArr.count>6) {
            return 6;
        }else{
            return _carArr.count;
        }
        
    }else{
        if (_huafeiArr.count>6) {
            return 6;
        }else{
            return _huafeiArr.count;
        }
    }
}
//返回某个indexPath对应的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XNRHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.backgroundColor =[UIColor clearColor];

    if (indexPath.section == 0) {
        if (_carArr.count>0) {
            XNRShoppingCartModel *model = _carArr[indexPath.row];
            [cell setCellDataWithShoppingCartModel:model];

        }
    }else{
        if (_huafeiArr.count>0) {
            XNRShoppingCartModel *model = _huafeiArr[indexPath.row];
            [cell setCellDataWithShoppingCartModel:model];

        }
    }
    return cell;
}
//设定指定Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(PX_TO_PT(330),PX_TO_PT(480));
}

//设定collectionView(指定区)的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, PX_TO_PT(32), 0, PX_TO_PT(32));
}

//设定指定区内Cell的最小行距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return PX_TO_PT(13);
}

//设定指定区内Cell的最小列距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return PX_TO_PT(13);
}

//按钮点击响应
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XNRProductInfo_VC*vc=[[XNRProductInfo_VC alloc]init];
    if (indexPath.section == 0) {
        vc.model=_carArr[indexPath.row];
    }else{
        vc.model=_huafeiArr[indexPath.row];
    }
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 专场按钮
-(void)HomeCollectionHeaderViewWith:(UIButton *)button
{
    if (!button) {
    } else {
        if (button.tag == 1000) {
            XNRSpecialViewController *specialFer_VC = [[XNRSpecialViewController alloc] init];
            specialFer_VC.type = eXNRFerType;
            specialFer_VC.classId = @"531680A5";
            specialFer_VC.tempTitle = @"化肥";
            for (int i = 0; i<_huafeiArr.count; i++) {
            specialFer_VC.model = _huafeiArr[i];
            }
            specialFer_VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialFer_VC animated:YES];
        }else{
            XNRSpecialViewController *specialCar_VC = [[XNRSpecialViewController alloc] init];
            specialCar_VC.type = eXNRCarType;
            specialCar_VC.tempTitle = @"汽车";
            specialCar_VC.classId = @"6C7D8F66";
            for (int i = 0; i<_carArr.count; i++) {
                specialCar_VC.model = _carArr[i];
            }
            specialCar_VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:specialCar_VC animated:YES];
        }
    }
}
#pragma mark - 获取汽车化肥数据
-(void)getFerData
{
    [_huafeiArr removeAllObjects];
    [KSHttpRequest post:KHomeGetProductsListPage parameters:@{@"locationUserId":IS_Login?[DataCenter account].userid:@"",@"classId":@"531680A5",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dicts = result[@"datas"];
            NSArray *arr = dicts[@"rows"];
            for (NSDictionary *dict in arr) {
                XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_huafeiArr addObject:model];
            }
        }
        [self getCarData];
        } failure:^(NSError *error) {
    }];
}
-(void)getCarData
{
    [_carArr removeAllObjects];
    [KSHttpRequest post:KHomeGetProductsListPage parameters:@{@"locationUserId":IS_Login?[DataCenter account].userid:@"",@"classId":@"6C7D8F66",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dicts = result[@"datas"];
            NSArray *arr = dicts[@"rows"];
            for (NSDictionary *dict in arr) {
                XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_carArr addObject:model];
            }
        }
        [self.homeCollectionView reloadData];
        [self.homeCollectionView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
