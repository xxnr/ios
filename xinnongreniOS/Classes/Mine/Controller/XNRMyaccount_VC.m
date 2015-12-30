
//  XNRMyaccount_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyaccount_VC.h"
#import "PECropViewController.h"
#import "XNRWrightSendAddress_VC.h"
#import "XNRCityList_VC.h"
#import "XNRModPassword_VC.h"
#import "XNRAddressSelect_VC.h"
#import "XNRAddressManageViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "XNRMobNickNameController.h"
#import "XNRMobuserName.h"
#import "XNRMobAddress.h"
#import "XNRTypeModel.h"
#import "XNRTypeView.h"
#define uploadImageTag  2000   //上传头像
#define KbtnTag 1000
#define kUploadHeadImgUrl @"http://101.200.194.203/api/v2.0/user/uploadPortrait"      //上传头像
#define kUpdateUserAddressUrl @"app/user/updateUserAddress"  //更新地址

@interface XNRMyaccount_VC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UIAlertViewDelegate,XNRTypeViewBtnDelegate>{
    
    
}
@property (nonatomic,weak) UIScrollView *mainScrollView;
@property (nonatomic,weak) UIButton *iconBtn;
@property (nonatomic,weak) UIButton *icon;
@property (nonatomic,weak) UIButton *nickNameBtn;
@property (nonatomic,weak) UIButton *button;

@property (nonatomic,weak) UIButton *pwdBtn;

@property (nonatomic ,weak) UIButton *bottomBtn;

@property (nonatomic,weak) UILabel *nickNameLabel;
@property (nonatomic,weak) UIAlertView *al;

@property (nonatomic ,weak) UILabel *sendAddressTip;
@property (nonatomic ,weak) UILabel *userNameLabel;


@property (nonatomic ,weak) UILabel *nameLabel;
@property (nonatomic ,weak) UILabel *sexLabel;
@property (nonatomic ,weak) UILabel *typeLabel;
@property (nonatomic ,weak) UILabel *areaLabel;

@property (nonatomic ,copy) NSString *typeNum;

@property (nonatomic ,weak) XNRTypeView *typeView;
@end

@implementation XNRMyaccount_VC

- (XNRTypeView *)typeView {
    if (_typeView == nil) {
        XNRTypeView *typeView = [[XNRTypeView alloc] init];
        typeView.delegate = self;
        self.typeView = typeView;
        [self.view addSubview:typeView];
    }
    return _typeView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    //创建背景图
    UIScrollView *mainScrollView = [MyControl createUIScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) contentSize:CGSizeMake(ScreenWidth, 600*SCALE) pagingEnabled:NO showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO delegate:self];
    mainScrollView.backgroundColor=R_G_B_16(0xf4f4f4);
    self.mainScrollView = mainScrollView;
    [self.view addSubview:mainScrollView];
    // 设置导航栏
    [self setNavigationbarTitle];
    //创建头视图
    [self createTop];
    //中部视图
    [self createMid];
    //底部视图
    [self createBottom];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshMyAccount) name:@"RefreshMyAccount" object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//刷新默认发货地址
- (void)RefreshMyAccount
{
    self.userNameLabel.text = [DataCenter account].name?[DataCenter account].name:@"添加";
    self.nickNameLabel.text = [DataCenter account].nickname?[DataCenter account].nickname:@"新新农人";
//    self.sexLabel.text = [DataCenter account].sex?[NSString stringWithFormat:@"%@",[DataCenter account].sex]:@"添加";
//    NSString *address = [NSString stringWithFormat:@"%@%@",[DataCenter account].county,[DataCenter account].town];
    if ([KSHttpRequest isBlankString:[DataCenter account].county]) {
        if ([KSHttpRequest isBlankString:[DataCenter account].town]) {
            self.areaLabel.text = [NSString stringWithFormat:@"%@%@",[DataCenter account].province,[DataCenter account].city];
        }else{
            self.areaLabel.text = [NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].town];
        
        }
        self.areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].town]:@"选择";
    }else{
        if ([KSHttpRequest isBlankString:[DataCenter account].town]){
            self.areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].county]:@"选择";

        }else{
            NSString *address = [NSString stringWithFormat:@"%@%@",[DataCenter account].county,[DataCenter account].town];
            self.areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,address]:@"选择";
        }
    }
}
-(void)createTop{
    
    CGFloat margin = PX_TO_PT(20);
    // 头像
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(120));
    headBtn.backgroundColor = [UIColor whiteColor];
    [headBtn addTarget:self action:@selector(uploadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:headBtn];

    UIButton *iconBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBnt.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(75)*0.5, PX_TO_PT(45), PX_TO_PT(45));
    [iconBnt setImage:[UIImage imageNamed:@"my_head"] forState:UIControlStateNormal];
    self.iconBtn = iconBnt;
    [headBtn addSubview:iconBnt];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconBtn.frame) +margin , PX_TO_PT(30), ScreenWidth/2, PX_TO_PT(60))];
    headLabel.text = @"我的头像";
    headLabel.textColor = R_G_B_16(0x323232);
    headLabel.font = XNRFont(14);
    [headBtn addSubview:headLabel];
    
    UIButton *icon =[MyControl createButtonWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(174), PX_TO_PT(10), PX_TO_PT(100), PX_TO_PT(100)) ImageName:@"my_heagView" Target:self Action:@selector(uploadImage) Title:nil];
    icon.clipsToBounds=YES;
    icon.layer.cornerRadius=PX_TO_PT(100)/2;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMAGEHOST,[DataCenter account].photo];
    if (![KSHttpRequest isBlankString:[DataCenter account].photo]) {
        NSURL *url = [NSURL URLWithString:urlStr];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            [icon setImage:image forState:UIControlStateNormal];
        }];
    }
    self.icon = icon;
    [headBtn addSubview:icon];
    
    UIImageView *arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+PX_TO_PT(10), PX_TO_PT(39), PX_TO_PT(24), PX_TO_PT(42))];
    [arrow1 setImage:[UIImage imageNamed:@"my_return"]];
    [headBtn addSubview:arrow1];
    
    // 昵称
    UIButton *nickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nickBtn.frame = CGRectMake(0, PX_TO_PT(120), ScreenWidth, PX_TO_PT(88));
    nickBtn.backgroundColor = [UIColor whiteColor];
    [nickBtn addTarget:self action:@selector(nickBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:nickBtn];
    
    UIImageView *arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+PX_TO_PT(10), PX_TO_PT(23), PX_TO_PT(24), PX_TO_PT(42))];
    [arrow2 setImage:[UIImage imageNamed:@"my_return"]];
    [nickBtn addSubview:arrow2];
    
    UIButton *nickNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nickNameBtn setImage:[UIImage imageNamed:@"my_nickname"] forState:UIControlStateNormal];
    nickNameBtn.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(43)*0.5, PX_TO_PT(45), PX_TO_PT(45));
    self.nickNameBtn = nickNameBtn;
    [nickBtn addSubview:nickNameBtn];
    
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameBtn.frame) + margin, PX_TO_PT(14), ScreenWidth/2, PX_TO_PT(60))];
    nickLabel.text = @"我的昵称";
    nickLabel.textColor = R_G_B_16(0x323232);
    nickLabel.font = XNRFont(14);
    [nickBtn addSubview:nickLabel];
    
    
    // 显示昵称
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(14), ScreenWidth/2-PX_TO_PT(70), PX_TO_PT(60))];
    nickNameLabel.textAlignment = NSTextAlignmentRight;
    nickNameLabel.textColor = R_G_B_16(0x909090);
    if ([KSHttpRequest isBlankString:[DataCenter account].nickname]) {
        nickNameLabel.text = [NSString stringWithFormat:@"新新农人"];
    }else{
        nickNameLabel.text = [DataCenter account].nickname;
    }
    self.nickNameLabel = nickNameLabel;
    [nickBtn addSubview:nickNameLabel];
    
    
    UIView *topLine=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(120),ScreenWidth,PX_TO_PT(1))];
    topLine.backgroundColor=R_G_B_16(0xc7c7c7);
    [self.mainScrollView addSubview:topLine];
    
    UIView*bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(208), ScreenWidth, PX_TO_PT(1))];
    bottomLine.backgroundColor=R_G_B_16(0xc7c7c7);
    [self.mainScrollView addSubview:bottomLine];
}

-(void)nickBtnClick
{
    XNRMobNickNameController *nickNameVC = [[XNRMobNickNameController alloc] init];
    nickNameVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nickNameVC animated:YES];
    
}
#pragma mark--中部视图
-(void)createMid{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(240), ScreenWidth, PX_TO_PT(88)*4)];
    [self.mainScrollView addSubview:bgView];
    
    NSArray *array = @[@"姓名",@"性别",@"所在地区",@"类型"];
    for (int i=0; i<array.count; i++) {
        UIButton *button=[MyControl createButtonWithFrame:CGRectMake(0,i*PX_TO_PT(88) ,ScreenWidth, PX_TO_PT(88)) ImageName:nil Target:self Action:@selector(buttonClick:) Title:nil];
        button.backgroundColor=[UIColor whiteColor];
        button.tag = KbtnTag+i;
        self.button = button;
        [bgView addSubview:button];
        //图标
        CGFloat iconW = PX_TO_PT(45.0),iconH = iconW;
        CGFloat iconX = PX_TO_PT(32.0),iconY = (button.frameHeight_Ext-iconH)*0.5;
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX,iconY,iconW,iconH)];
        [iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"my%d",i+1]]];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:iconImageView];
        //主题
        UILabel*titleLabel=[MyControl createLabelWithFrame:CGRectMake(PX_TO_PT(112), iconY,ScreenWidth - PX_TO_PT(112),iconH) Font:16 Text:array[i]];
        titleLabel.textColor=R_G_B_16(0x323232);
        titleLabel.font = XNRFont(14);
        [button addSubview:titleLabel];
        
        UIImageView *arrow3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+PX_TO_PT(10), PX_TO_PT(23), PX_TO_PT(24), PX_TO_PT(42))];
        [arrow3 setImage:[UIImage imageNamed:@"my_return"]];
        [button addSubview:arrow3];


        //分割线
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,PX_TO_PT(240)+i*PX_TO_PT(88), ScreenWidth, .5)];
        line2.backgroundColor=[UIColor lightGrayColor];
        [self.mainScrollView addSubview:line2];
}
    // 显示姓名
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(14), ScreenWidth/2-PX_TO_PT(70), PX_TO_PT(60))];
    userNameLabel.textAlignment = NSTextAlignmentRight;
    userNameLabel.textColor = R_G_B_16(0x909090);
    if ([KSHttpRequest isBlankString:[DataCenter account].name]) {
        userNameLabel.text = [NSString stringWithFormat:@"添加"];
    }else{
        userNameLabel.text = [DataCenter account].name;
    }

    self.userNameLabel = userNameLabel;
    [bgView addSubview:userNameLabel];
    
    // 显示性别
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(14)+PX_TO_PT(88), ScreenWidth/2-PX_TO_PT(70), PX_TO_PT(60))];
    sexLabel.textAlignment = NSTextAlignmentRight;
    sexLabel.textColor = R_G_B_16(0x909090);
    if ([KSHttpRequest isNULL:[DataCenter account].sex]) {
        sexLabel.text = [NSString stringWithFormat:@"选择"];
    }
    else{
        if ([[DataCenter account].sex integerValue] == 0) {
            sexLabel.text = @"男";
        }else if([[DataCenter account].sex integerValue] == 1){
            sexLabel.text = @"女";
        }else{
            sexLabel.text = @"选择";
        }
    
    }
    
    
    
    
    
    self.sexLabel = sexLabel;
    [bgView addSubview:sexLabel];

    // 显示所在地区
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-PX_TO_PT(30), PX_TO_PT(14)+PX_TO_PT(88)*2, ScreenWidth/2-PX_TO_PT(40), PX_TO_PT(60))];
    areaLabel.font = [UIFont systemFontOfSize:10];
    areaLabel.numberOfLines = 0;
    areaLabel.textAlignment = NSTextAlignmentRight;
    areaLabel.textColor = R_G_B_16(0x909090);
    [areaLabel fitTextHeight_Ext];
    self.areaLabel = areaLabel;
//    if ([KSHttpRequest isBlankString:[DataCenter account].county]) {
//        areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].town]:@"选择";
//    }
//    if ([DataCenter account].town == nil) {
//    areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].county]:@"选择";
//    }else{
//    NSString *address = [NSString stringWithFormat:@"%@%@",[DataCenter account].county,[DataCenter account].town];
//    areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,address]:@"选择";
//    }
    if ([KSHttpRequest isBlankString:[DataCenter account].county]) {
        if ([KSHttpRequest isBlankString:[DataCenter account].town]) {
            self.areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@",[DataCenter account].province,[DataCenter account].city]:@"选择";
        }else{
            self.areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].town]:@"选择";
            
        }
    }else{
        if ([KSHttpRequest isBlankString:[DataCenter account].town]){
            self.areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].county]:@"选择";
            
        }else{
            NSString *address = [NSString stringWithFormat:@"%@%@",[DataCenter account].county,[DataCenter account].town];
            self.areaLabel.text = [DataCenter account].province?[NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,address]:@"选择";
        }
    }

    

    [bgView addSubview:areaLabel];

    // 显示类型
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(14) + PX_TO_PT(88)*3, ScreenWidth/2-PX_TO_PT(70), PX_TO_PT(60))];
    typeLabel.textAlignment = NSTextAlignmentRight;
    typeLabel.textColor = R_G_B_16(0x909090);
    self.typeLabel = typeLabel;
    if ([[DataCenter account].type integerValue] == 1) {
        typeLabel.text = [DataCenter account].type?[NSString stringWithFormat:@"其它"]:@"选择";
    }else if ([[DataCenter account].type integerValue] == 2){
        typeLabel.text = [DataCenter account].type?[NSString stringWithFormat:@"种植大户"]:@"选择";

    }else if ([[DataCenter account].type integerValue] == 3){
        typeLabel.text = [DataCenter account].type?[NSString stringWithFormat:@"村级经销商"]:@"选择";

    }else if ([[DataCenter account].type integerValue] == 4){
        typeLabel.text = [DataCenter account].type?[NSString stringWithFormat:@"乡镇经销商"]:@"选择";

    }else{
        typeLabel.text = [DataCenter account].type?[NSString stringWithFormat:@"县级经销商"]:@"选择";

    }
    [bgView addSubview:typeLabel];

}

-(void)buttonClick:(UIButton *)button
{
    if (button.tag == KbtnTag) {
        XNRMobuserName *userNameVC = [[XNRMobuserName alloc] init];
        userNameVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userNameVC animated:YES];
        
    }else if (button.tag == KbtnTag + 1){
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"选择性别" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女",nil];
        [al show];
    
    }else if (button.tag == KbtnTag +2 ){
        XNRMobAddress *addressVC = [[XNRMobAddress alloc] init];
        addressVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressVC animated:YES];
    }else if (button.tag == KbtnTag + 3){
        [self.typeView showWith:^(NSString *typeName,NSString *typeNum) {
            self.typeLabel.text = typeName;
            self.typeNum = typeNum;
            
        }];
    }
}

-(void)XNRTypeViewBtnClick:(XNRTypeViewType)type
{
    if (type == leftBtnType) {
        [self.typeView hide];
    }else if(type == rightBtnType){
        [self.typeView hide];
        [KSHttpRequest post:KUserModify parameters:@{@"userId":[DataCenter account].userid,@"type":self.typeNum} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                UserInfo *info = [DataCenter account];
                info.type = self.typeLabel.text;
                [DataCenter saveAccount:info];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshMyAccount) name:@"RefreshMyAccount" object:nil];

            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        
    }else if (buttonIndex == 1){
        [KSHttpRequest post:KUserModify parameters:@{@"userId":[DataCenter account].userid,@"sex":@"false"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                self.sexLabel.text = @"男";
                UserInfo *info = [DataCenter account];
                info.sex = self.sexLabel.text;
                [DataCenter saveAccount:info];
             }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [KSHttpRequest post:KUserModify parameters:@{@"userId":[DataCenter account].userid,@"sex":@"true"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                self.sexLabel.text = @"女";
                UserInfo *info = [DataCenter account];
                info.sex = self.sexLabel.text;
                [DataCenter saveAccount:info];

            }
        } failure:^(NSError *error) {
            
        }];

    }
        
    

}
#pragma mark--底部视图
-(void)createBottom{
    CGFloat margin = 10;
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(0, PX_TO_PT(632), ScreenWidth, PX_TO_PT(88));
    bottomBtn.backgroundColor = [UIColor whiteColor];
    [bottomBtn addTarget: self action:@selector(ModPassword) forControlEvents:UIControlEventTouchUpInside];

    self.bottomBtn = bottomBtn;
    [self.mainScrollView addSubview:bottomBtn];
    
    UIImageView *arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+PX_TO_PT(10), PX_TO_PT(30), PX_TO_PT(24), PX_TO_PT(42))];
    [arrow2 setImage:[UIImage imageNamed:@"my_return"]];
    [bottomBtn addSubview:arrow2];
    
    UIButton *pwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pwdBtn setImage:[UIImage imageNamed:@"my_password"] forState:UIControlStateNormal];
    pwdBtn.frame = CGRectMake(PX_TO_PT(32), PX_TO_PT(14), PX_TO_PT(45), PX_TO_PT(45));
    self.pwdBtn = pwdBtn;
    [bottomBtn addSubview:pwdBtn];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameBtn.frame) + margin, PX_TO_PT(14), ScreenWidth/2, PX_TO_PT(60))];
    pwdLabel.text = @"修改密码";
    pwdLabel.textColor = R_G_B_16(0x323232);
    pwdLabel.font = XNRFont(14);
    [bottomBtn addSubview:pwdLabel];
    
    UIView *topLine=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(632),ScreenWidth,PX_TO_PT(1))];
    topLine.backgroundColor=R_G_B_16(0xc7c7c7);
    [self.mainScrollView addSubview:topLine];
    
    UIView*bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(720), ScreenWidth, PX_TO_PT(1))];
    bottomLine.backgroundColor=R_G_B_16(0xc7c7c7);
    [self.mainScrollView addSubview:bottomLine];
    
    
    UIButton *resignLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resignLoginBtn.layer.cornerRadius = 5.0;
    resignLoginBtn.layer.masksToBounds = YES;
    resignLoginBtn.frame = CGRectMake(PX_TO_PT(32),CGRectGetMaxY(self.bottomBtn.frame) + PX_TO_PT(100), ScreenWidth-PX_TO_PT(32)*2, PX_TO_PT(88));
    resignLoginBtn.backgroundColor = [UIColor redColor];
    [resignLoginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [resignLoginBtn setTitleColor:R_G_B_16(0xffffff) forState:UIControlStateNormal];
    [resignLoginBtn setBackgroundColor:R_G_B_16(0x00b38a)];
    [resignLoginBtn addTarget:self action:@selector(resignLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:resignLoginBtn];
   
}
#pragma mark - 退出当前账号
-(void)resignLoginBtnClick
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出当前账号" otherButtonTitles: nil];
        actionSheet.tag = 1000;
        [actionSheet showInView:self.view];
}

#pragma mark-修改密码
-(void)ModPassword{
    
    XNRModPassword_VC*vc=[[XNRModPassword_VC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark--上传头像
-(void)uploadImage{
    UIActionSheet*action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择" ,nil];
    action.tag = uploadImageTag;
    [action showInView:self.view];
    
}
#pragma mark-填写用户送货地址
-(void)wirhtSendAddress {
    
    XNRAddressManageViewController*vc=[[XNRAddressManageViewController alloc]init];
    [vc setAddressChoseBlock:^(XNRAddressManageModel *model) {
        _sendAddressTip.text = model.address;
        
        UserInfo *info = [DataCenter account];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@",model.areaName,model.address] forKey:@"shopAddress"];
        info.address = [NSString stringWithFormat:@"%@%@",model.areaName,model.address];
        [DataCenter saveAccount:info];
        
//        修改地址(服务器改为默认地址)
//        [self updateAddress:model];
    }];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 修改地址
- (void)updateAddress:(XNRAddressManageModel *)model
{
    //userId:用户ID, areaId：省份ID,address:手动填写的具体地址,type:（1.默认地址2.非默认地址）,receiptPhone:收货人手机号,receiptPeople：收货人名称
    NSString *address = [model.address stringByReplacingCharactersInRange:NSMakeRange(0, model.areaName.length) withString:@""];
    [KSHttpRequest post:KUpdateUserAddress parameters:@{@"userId":[DataCenter account].userid,@"areaId":model.address,@"address":address,@"type":@"1",@"receiptPhone":model.receiptPhone,@"receiptPeople":model.receiptPeople,@"addressId":model.addressId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] isEqualToString:@"1000"]) {
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark-昵称
-(void)nickNameClick{
    
    UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"请输入昵称" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    al.alertViewStyle=UIAlertViewStylePlainTextInput;
    [al show];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == uploadImageTag){
    if(buttonIndex==0){
        NSLog(@"相机");
        [self showCamera];
        
    }else if(buttonIndex==1){
        
        [self openPhotoAlbum];
        NSLog(@"相册");
    }
    }else if (actionSheet.tag == 1000){
        if (buttonIndex == 0) {
            //本地用户信息状态设为非登录
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            //发送刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PageRefresh" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
    }
}

#pragma mark -截取
/**
 *  获取截取图片并赋值给相应控件
 *  croppedImage截取之后的图片
 */
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [SVProgressHUD showWithStatus:@"正在上传请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    [controller dismissViewControllerAnimated:YES completion:NULL];
    NSString *userId = [DataCenter account].userid;
    NSString *urlString = [NSString stringWithFormat:@"%@",KUserUploadPortrait];
    NSString *url = [NSString stringWithFormat:@"%@?userId=%@",urlString,userId];
    NSString *picSize = [CommonTool uploadPicUrl:url params:@{@"user-agent":@"IOS-v2.0",@"token":[DataCenter account].token} file:@"resFile" picImage:croppedImage success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            [KSHttpRequest post:KUserModify parameters:@{@"userPhoto":result[@"imageUrl"]} success:^(id result) {
                if ([result[@"code"] integerValue] == 1000) {
                    UserInfo *info = [DataCenter account];
                    info.photo = [NSString stringWithFormat:@"%@",result[@"imageUrl"]];
                    [DataCenter saveAccount:info];
                    // 刷新
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshMyAccount) name:@"RefreshMyAccount" object:nil];
                    
                    [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
                    [_icon setImage:croppedImage forState:UIControlStateNormal];
                }
            } failure:^(NSError *error) {
                
            }];
                    }
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
      
        NSLog(@"error = %@",error);
    }];
    NSLog(@"头像图片大小%@",picSize);
}
/**
 *  跳出图片编辑界面
 *
 *
 */
- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:NULL];
    }else{
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"模拟其中无法打开照相机,请在真机中使用" message:nil delegate:nil cancelButtonTitle:@"ok"otherButtonTitles:nil];
        [al show];
        
    }
}
- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:controller animated:YES completion:NULL];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:image];
        
    }];
}
- (void)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image =sender;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}


- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我";
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

-(void)getTypeData
{
    [KSHttpRequest get:Kusertypes parameters:nil success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dicts = result[@"datas"];
            XNRTypeModel *model = [[XNRTypeModel alloc] init];
            [model setValuesForKeysWithDictionary:dicts];
            UserInfo *info = [DataCenter account];
            info.type = dicts[@"1"];
        }
        
    } failure:^(NSError *error) {
        
    }];
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
