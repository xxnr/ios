//
//  XNRFinishMineDataController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRAddLatentUserVC.h"
#import "XNRAddressPickerView.h"
#import "XNRTownPickerView.h"
#import "XNRTypeView.h"
#import "XNRSelProVC.h"

#define sexBtn  1000
@interface XNRAddLatentUserVC()<XNRAddressPickerViewBtnDelegate,XNRTownPickerViewBtnDelegate,UITextFieldDelegate,XNRTypeViewBtnDelegate>

@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UIButton *addressBtn;
@property (nonatomic ,weak) XNRAddressPickerView *addressManagerView;
@property (nonatomic ,weak) XNRTownPickerView *townManagerView;
@property (nonatomic ,weak) XNRTypeView *typeView;

@property (nonatomic, copy)NSString *province;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *county;
@property (nonatomic, copy)NSString *provinceID;
@property (nonatomic, copy)NSString *cityID;
@property (nonatomic, copy)NSString *countyID;
@property (nonatomic ,copy) NSString *towns;
@property (nonatomic ,copy) NSString *townID;
@property (nonatomic ,copy) NSString *typeName;
@property (nonatomic ,copy) NSString *typeNum;

@property (nonatomic,weak) UITextField *nameTf;
@property (nonatomic,weak) UITextField *phoneNumTextField;

//@property (nonatomic ,weak) UIButton *LocalAddressBtn;
@property (nonatomic ,weak) UILabel *LocalAddressLabel;
@property (nonatomic ,weak) UIButton *streetBtn;
@property (nonatomic ,weak) UILabel *streetLabel;
//@property (nonatomic ,weak) UIButton *userTypeBtn;
@property (nonatomic ,weak) UILabel *userTypeLabel;

@property (nonatomic ,weak)UIButton *userTypeBtn;
@property (nonatomic,weak) UIView *line;
@property (nonatomic,weak)UIView *phoneView;
@property (nonatomic,weak)UIView *bottomView;
@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,copy) UIButton *tempBtn;
@property (nonatomic,weak) UIImageView *icon;
@property (nonatomic,weak) UILabel *warnLabel;
@property (nonatomic,weak)UIView *warnView;
@property (nonatomic,assign)BOOL iswarn;
@property (nonatomic,copy)NSMutableArray *interestedProArr;
@property (nonatomic,copy)NSMutableArray *interestedProIdArr;
@property (nonatomic,assign)int nameLength;

@end

@implementation XNRAddLatentUserVC

-(NSMutableArray *)interestedProArr
{
    if (!_interestedProArr) {
        _interestedProArr = [NSMutableArray array];
    }
    return _interestedProArr;
}
-(NSMutableArray *)interestedProIdArr
{
    if (!_interestedProIdArr) {
        _interestedProIdArr = [NSMutableArray array];
    }
    return _interestedProIdArr;
}

#pragma mark - 地区
-(XNRAddressPickerView *)addressManagerView{
    if (!_addressManagerView) {
        XNRAddressPickerView *addressManagerView = [[XNRAddressPickerView alloc] init];
        addressManagerView.delegate = self;
        self.addressManagerView = addressManagerView;
        [self.view addSubview:addressManagerView];
    }
    return _addressManagerView;
    
}

-(void)XNRAddressPickerViewBtnClick:(XNRAddressPickerViewType)type
{
    if (type == leftBtnType) {
        [self.addressManagerView hide];
    }else{
        // 点确定以后，置空
        //        self.townLabel.text = @"请选择乡镇";
        self.townID = @"";
        [self.addressManagerView hide];
    }
}

#pragma mark - 乡镇
-(XNRTownPickerView *)townManagerView{
    if (!_townManagerView) {
        XNRTownPickerView *townManagerView = [[XNRTownPickerView alloc] init];
        townManagerView.delegate = self;
        self.townManagerView = townManagerView;
        [self.view addSubview:townManagerView];
    }
    return _townManagerView;
}


-(void)XNRTownPickerViewBtnClick:(XNRTownPickerViewType)type
{
    if (type == eLeftBtnType) {
        [self.townManagerView hide];
    }else{
        [self.townManagerView hide];
    }
    
}

// 类型
- (XNRTypeView *)typeView {
    if (_typeView == nil) {
        XNRTypeView *typeView = [[XNRTypeView alloc] init];
        typeView.delegate = self;
        self.typeView = typeView;
        [self.view addSubview:typeView];
    }
    return _typeView;
}

-(void)XNRTypeViewBtnClick:(XNRTypeViewType)type
{
    if (type == LeftBtnType) {
        [self.typeView hide];
        
    }else if(type == RightBtnType){
        [self.typeView hide];
        self.userTypeLabel.text = [NSString stringWithFormat:@"%@",self.typeName];
        
    }
}




-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 导航
    [self createNavigation];
    
    [self createTopView];
    
    [self createBottomView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification:) name:@"selPro" object:nil];
    
}
-(void)notification:(NSNotification *)notification
{
//    self.interestedProArr = [NSArray array];
    self.interestedProArr = [notification.userInfo valueForKey:@"selProArr"];
    
//    self.interestedProIdArr = [NSArray array];
    self.interestedProIdArr = [notification.userInfo valueForKey:@"selProId_Arr"];
    
    NSMutableString *str = [[NSMutableString alloc]init];
    for (NSString *name in self.interestedProArr) {
        [str appendString:name];
        if ([name isEqualToString:[self.interestedProArr lastObject]]) {
        }
        else
        {
            [str appendString:@","];
        }
    }
    if (str.length > 0) {
        
        self.userTypeLabel.text = str;
        CGSize size = [self.userTypeLabel.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(32)] constrainedToSize:CGSizeMake(ScreenWidth - CGRectGetMaxX(self.titleLabel.frame)-PX_TO_PT(60), MAXFLOAT)];
        self.userTypeLabel.numberOfLines = 0;
        self.userTypeLabel.frame = CGRectMake(0,PX_TO_PT(38), size.width,size.height);
        self.userTypeBtn.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+PX_TO_PT(60), CGRectGetMaxY(_streetBtn.frame), ScreenWidth - CGRectGetMaxX(self.titleLabel.frame)-PX_TO_PT(60), size.height);
        self.line.frame = CGRectMake(0, CGRectGetMaxY(self.userTypeBtn.frame) + PX_TO_PT(68), ScreenWidth, PX_TO_PT(1));
    }
    else
    {
        self.userTypeLabel.text = @"选择客户想买的商品";
    }
    [_userTypeBtn removeFromSuperview];
    [_userTypeLabel removeFromSuperview];
    [_line removeFromSuperview];
    
    [_userTypeBtn addSubview:_userTypeLabel];
    [self.bottomView addSubview:_userTypeBtn];
    [self.bottomView addSubview:_line];
    
}
-(void)keyboardWillBeHidden:(NSNotification *)note
{
    [self.addressManagerView hide];
    [self.townManagerView hide];
    
}

-(void)createTopView
{
    
    UILabel *title1Label = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(33), PX_TO_PT(130), PX_TO_PT(34))];
    title1Label.textColor = R_G_B_16(0x323232);
    title1Label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    title1Label.text = @"姓名";
    self.titleLabel = title1Label;
    [self.view addSubview:title1Label];

    // 姓名
    UITextField *nameTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+PX_TO_PT(60), PX_TO_PT(34), ScreenWidth, PX_TO_PT(36))];
    nameTf.textAlignment = NSTextAlignmentLeft;
    nameTf.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写客户的真实姓名" attributes:@{NSForegroundColorAttributeName:R_G_B_16(0x909090)}];
    nameTf.textColor = R_G_B_16(0x323232);
    nameTf.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    nameTf.delegate = self;
    self.nameTf = nameTf;
    [self.view addSubview:nameTf];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, PX_TO_PT(1))];
    line1View.backgroundColor = R_G_B_16(0xc7c7c7);
    [self.view addSubview:line1View];

    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameTf.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(99))];
    phoneView.alpha = 1;
    self.phoneView = phoneView;
    // 手机号
    UITextField *phone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+PX_TO_PT(60), PX_TO_PT(33), ScreenWidth, PX_TO_PT(36))];
    phone.textAlignment = NSTextAlignmentLeft;
    phone.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写客户联系方式" attributes:@{NSForegroundColorAttributeName:R_G_B_16(0x909090)}];

    phone.textColor = R_G_B_16(0x323232);
    phone.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    phone.delegate = self;
    //设置键盘类型
    phone.returnKeyType = UIReturnKeyDone;
    phone.keyboardType=UIKeyboardTypeNumberPad;
    phone.clearButtonMode = UITextFieldViewModeAlways;
    phone.textAlignment = NSTextAlignmentLeft;
    self.phoneNumTextField = phone;
    
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(33), PX_TO_PT(130), PX_TO_PT(34))];
    phonelabel.textColor = R_G_B_16(0x323232);
    phonelabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    phonelabel.text = @"手机号";
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98), ScreenWidth, PX_TO_PT(1))];
    line2View.backgroundColor = R_G_B_16(0xc7c7c7);
    [self.bottomView addSubview:line2View];
    
    [phoneView addSubview:line2View];
    [phoneView addSubview:phonelabel];
    [phoneView addSubview:phone];
    [self.view addSubview:_phoneView];
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneView.frame), ScreenWidth, PX_TO_PT(396))];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    NSArray *titleArray = @[@"性别",@"地区",@"街道",@"意向商品"];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(33)+i*PX_TO_PT(98), PX_TO_PT(130), PX_TO_PT(34))];
        titleLabel.textColor = R_G_B_16(0x323232);
        titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        titleLabel.text = titleArray[i];
        [self.bottomView addSubview:titleLabel];
    }

    // 性别男
    UIButton *selelctedBtnM = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+PX_TO_PT(60), PX_TO_PT(31), PX_TO_PT(36), PX_TO_PT(36))];
    [selelctedBtnM setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [selelctedBtnM setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
    selelctedBtnM.tag = sexBtn + 1;
    selelctedBtnM.selected = YES;
    [selelctedBtnM addTarget:self action:@selector(selelctedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self selelctedBtnClick:selelctedBtnM];
    [self.bottomView addSubview:selelctedBtnM];
    
    UIImageView *manImageViewM = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selelctedBtnM.frame)+PX_TO_PT(20),PX_TO_PT(19), PX_TO_PT(60), PX_TO_PT(60)) ];
    [manImageViewM setImage:[UIImage imageNamed:@"my_boy-icon"]];
    [self.bottomView addSubview:manImageViewM];
    
    UILabel *manLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(manImageViewM.frame)+PX_TO_PT(24), PX_TO_PT(31), PX_TO_PT(34), PX_TO_PT(34))];
    manLabel.textColor = R_G_B_16(0x323232);
    manLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    manLabel.text = @"男";
    [self.bottomView addSubview:manLabel];
    
    // 性别女
    UIButton *selelctedBtnW = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(manLabel.frame) + PX_TO_PT(71),PX_TO_PT(31), PX_TO_PT(36), PX_TO_PT(36))];
    [selelctedBtnW setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [selelctedBtnW setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
    selelctedBtnW.tag = sexBtn + 2;
    [selelctedBtnW addTarget:self action:@selector(selelctedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:selelctedBtnW];
    
    UIImageView *manImageViewW = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selelctedBtnW.frame)+PX_TO_PT(20),PX_TO_PT(19), PX_TO_PT(60), PX_TO_PT(60)) ];
    [manImageViewW setImage:[UIImage imageNamed:@"my_girl"]];
    [self.bottomView addSubview:manImageViewW];
    
    UILabel *womenLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(manImageViewW.frame)+PX_TO_PT(24), PX_TO_PT(31), PX_TO_PT(34), PX_TO_PT(34))];
    womenLabel.textColor = R_G_B_16(0x323232);
    womenLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    womenLabel.text = @"女";
    [self.bottomView addSubview:womenLabel];
    
    
    // 地区
    UIButton *LocalAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+PX_TO_PT(60), CGRectGetMaxY(manLabel.frame)+PX_TO_PT(28), ScreenWidth, PX_TO_PT(98))];
    [LocalAddressBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    LocalAddressBtn.tag = 1000;
    [self.bottomView addSubview:LocalAddressBtn];
    
    UILabel *LocalAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,PX_TO_PT(38), ScreenWidth, PX_TO_PT(33))];
    LocalAddressLabel.textColor = R_G_B_16(0x909090);
    LocalAddressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    LocalAddressLabel.text = @"选择所在的省市区";
    self.LocalAddressLabel = LocalAddressLabel;
    [LocalAddressBtn addSubview:LocalAddressLabel];
    
    // 街道
    UIButton *streetBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+PX_TO_PT(60), CGRectGetMaxY(LocalAddressBtn.frame), ScreenWidth, PX_TO_PT(98))];
    [streetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    streetBtn.tag = 1001;
    self.streetBtn = streetBtn;
    [self.bottomView addSubview:streetBtn];
    
    UILabel *streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,PX_TO_PT(38), ScreenWidth, PX_TO_PT(33))];
    streetLabel.textColor = R_G_B_16(0x909090);
    streetLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        streetLabel.text = @"选择所在街道或乡镇";
        self.streetLabel = streetLabel;
    [streetBtn addSubview:streetLabel];
    
    // 类型
    UIButton *userTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+PX_TO_PT(60), CGRectGetMaxY(streetBtn.frame), ScreenWidth, PX_TO_PT(98))];
    [userTypeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    userTypeBtn.tag = 1002;
    self.userTypeBtn = userTypeBtn;
//    [self.bottomView addSubview:userTypeBtn];
    
    UILabel *userTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,PX_TO_PT(38), ScreenWidth, PX_TO_PT(33))];
    userTypeLabel.textColor = R_G_B_16(0x909090);
    userTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    userTypeLabel.text = @"选择客户想买的商品";
    self.userTypeLabel = userTypeLabel;
    [_userTypeBtn addSubview:_userTypeLabel];
    [self.bottomView addSubview:_userTypeBtn];

    for (int i = 1; i<4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [self.bottomView addSubview:lineView];
    }
    UIView *lastLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98)*4, ScreenWidth, PX_TO_PT(1))];
    lastLine.backgroundColor = R_G_B_16(0xc7c7c7);
    self.line = lastLine;
    [self.bottomView addSubview:lastLine];
    
}


#pragma mark --UITextFieldDelegate
-(BOOL)btnClick:(UIButton *)button
{
    [self.nameTf resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    
    if (button.tag == 1000) {
        [self.townManagerView hide];
        [self.typeView hide];
        __weak __typeof(&*self)weakSelf = self;
        [self.addressManagerView show];
        self.addressManagerView.com = ^(NSString *province,NSString *city,NSString *county,NSString *provinceID,NSString *cityId,NSString *countyId,NSString *province_id,NSString *city_id,NSString *county_id){
            
            weakSelf.LocalAddressLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
            weakSelf.provinceID = province_id;
            weakSelf.cityID  = city_id;
            weakSelf.countyID = county_id;
            
            UserInfo *info = [DataCenter account];
            info.province = province;
            info.city = city;
            info.county = county;
            
            info.cityID = cityId;
            info.countyID = countyId;
            [DataCenter saveAccount:info];
        };
        
    }
    
    if (button.tag == 1001) {
        if ([self.LocalAddressLabel.text isEqualToString:@"选择所在的省市区"]) {
            [UILabel showMessage:@"请选择地区"];
        }else{
            [self.addressManagerView hide];
            [self.typeView hide];
            __weak __typeof(&*self)weakSelf = self;
            [self.townManagerView show];
            self.townManagerView.com = ^(NSString *townName,NSString *townId,NSString *town_id){
                weakSelf.streetLabel.text = [NSString stringWithFormat:@"%@",townName];
                weakSelf.townID = town_id;
                
            };
        }
    }
    

    if (button.tag == 1002) {
        [self.addressManagerView hide];
        [self.townManagerView hide];
        XNRSelProVC *selProVC = [[XNRSelProVC alloc]init];
        selProVC.selPro = self.interestedProArr;
        selProVC.selProId = self.interestedProIdArr;
        [self.navigationController pushViewController:selProVC animated:YES];
        
    }
    
    return YES;
}
#pragma mark - 正则表达式判断手机号格式
- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - textField代理方法

#pragma mark - 键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //验证手机号输入是否正确
    if (textField == self.phoneNumTextField) {
        [KSHttpRequest get:KGetIsAvailable parameters:@{@"phone":textField.text} success:^(id result) {
            if ([result[@"code"]integerValue] == 1000) {
                NSNumber *str =result[@"available"];
                if ([str integerValue] == 0) {
    
                    self.phoneView.frame = CGRectMake(0, CGRectGetMaxY(self.nameTf.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(198));
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(197), ScreenWidth, PX_TO_PT(2))];
                    self.warnView = line;
                    line.backgroundColor = R_G_B_16(0xc7c7c7);
                    [self.phoneView addSubview:line];
                    
                    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(191), PX_TO_PT(119), PX_TO_PT(30), PX_TO_PT(30))];
                    icon.image = [UIImage imageNamed:@"reg-prinpt"];
                    icon.contentMode = UIViewContentModeScaleAspectFit;
                    self.icon = icon;
                    [self.phoneView addSubview:icon];
                    
                    UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+PX_TO_PT(14), PX_TO_PT(120), ScreenWidth, PX_TO_PT(25))];
                    
                    warnLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
                    warnLabel.textColor = R_G_B_16(0xDF3D3E);
                    warnLabel.numberOfLines = 0;
//                    warnLabel.text = result[@"message"];
                    warnLabel.text = @"请修改填写的手机号";
                    
                    CGSize size = [warnLabel.text sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(24)] constrainedToSize:CGSizeMake(ScreenWidth - CGRectGetMaxX(icon.frame)-PX_TO_PT(14), PX_TO_PT(198))];
                    
                    warnLabel.frame = CGRectMake(CGRectGetMaxX(icon.frame)+PX_TO_PT(14), PX_TO_PT(120), ScreenWidth - CGRectGetMaxX(icon.frame)-PX_TO_PT(14) , size.height);
                    
                    self.warnLabel = warnLabel;
                    
                    [self.phoneView addSubview:warnLabel];

                    self.iswarn = YES;
                    
                    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneView.frame), ScreenWidth, PX_TO_PT(396));
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
   else if (textField == self.nameTf) {
        //                NSString * mstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //                CGSize textSize = [mstr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
        //
        //                if (textSize.width>PX_TO_PT(210)&&![string isEqualToString:@""]) {
        //                    [textField resignFirstResponder];
        //                    mstr = [mstr substringWithRange:NSMakeRange(0, 6)];
        //                    [UILabel showMessage:[NSString stringWithFormat:@"不能超过%d个汉字",(int)mstr.length]];
        
        int strlength = 0;
        char* p = (char*)[textField.text cStringUsingEncoding:NSUnicodeStringEncoding];
        for (int i=0 ; i<[textField.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
            if (*p) {
                p++;
                strlength++;
            }
            else {
                p++;
            }
            
        }
       
       self.nameLength = strlength;

        if (strlength > 11) {
            [UILabel showMessage:[NSString stringWithFormat:@"您的输入超过限制"]];
        }
   }

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.phoneNumTextField && self.iswarn == YES) {
        
        [self.warnLabel removeFromSuperview];
        [self.warnView removeFromSuperview];
        [self.icon removeFromSuperview];
        
        self.phoneView.frame = CGRectMake(0, CGRectGetMaxY(self.nameTf.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(99));
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneView.frame), ScreenWidth, PX_TO_PT(396));
    }
    
}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == self.nameTf) {
////                NSString * mstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
////                CGSize textSize = [mstr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
////        
////                if (textSize.width>PX_TO_PT(210)&&![string isEqualToString:@""]) {
////                    [textField resignFirstResponder];
////                    mstr = [mstr substringWithRange:NSMakeRange(0, 6)];
////                    [UILabel showMessage:[NSString stringWithFormat:@"不能超过%d个汉字",(int)mstr.length]];
//        
//        int strlength = 0;
//        char* p = (char*)[textField.text cStringUsingEncoding:NSUnicodeStringEncoding];
//        for (int i=0 ; i<[textField.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
//            if (*p) {
//                p++;
//                strlength++;
//            }
//            else {
//                p++;
//            }
//            
//        }
//        
//        if (strlength > 11 && ![string isEqualToString: @"\\"]) {
//        [UILabel showMessage:[NSString stringWithFormat:@"您的输入超过限制"]];
//        return NO;
//        }
//    }
//        return YES;
//}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == self.nameTf) {
////        NSString * mstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
////        CGSize textSize = [mstr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
////        
////        if (textSize.width>PX_TO_PT(210)&&![string isEqualToString:@""]) {
////            [textField resignFirstResponder];
////            mstr = [mstr substringWithRange:NSMakeRange(0, 6)];
////            [UILabel showMessage:[NSString stringWithFormat:@"不能超过%d个汉字",(int)mstr.length]];
////            return NO;
////        }
////        return YES;
//
//        if(self.nameTf.text.length > 6)
//        {
//            [UILabel showMessage:@"您的输入超出限制"];
//            return NO;
//
//        }
//        return YES;
//    }
//    
//    else
//    {
//        return YES;
//    }
//    
//    
//}
//
#pragma mark - 性别
-(void)selelctedBtnClick:(UIButton *)button
{
    [self.nameTf resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    _tempBtn.selected = NO;
    button.selected = YES;
    _tempBtn = button;
    
    if (button.tag == sexBtn + 1) {
        self.sex = @"true";
        
    }else if (button.tag == sexBtn + 2){
        self.sex = @"false";
    }
}

-(void)createBottomView
{
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(PX_TO_PT(31), ScreenHeight-PX_TO_PT(88)-64-PX_TO_PT(32), ScreenWidth-PX_TO_PT(62), PX_TO_PT(88))];
    saveBtn.backgroundColor = R_G_B_16(0x00b38a);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 5.0;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [saveBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
}

-(void)saveBtn {
    [self.phoneNumTextField resignFirstResponder];
    BOOL flag = [self validateMobile:self.phoneNumTextField.text];
    if ([self.LocalAddressLabel.text isEqualToString:@""] || [self.streetLabel.text isEqualToString:@""] || [self.phoneNumTextField.text isEqualToString:@""]||[self.userTypeLabel.text isEqualToString:@""] || [self.nameTf.text isEqualToString:@""]) {
        
        [UILabel showMessage:@"请完善信息"];
    }
    else if(!flag)
    {
    [UILabel showMessage:@"手机号输入格式不正确"];
                     
    }
    else if(self.nameLength>11)
    {
        [UILabel showMessage:@"您输入的姓名超过限制"];
    }
    else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:self.nameTf.text forKey:@"name"];
        [dic setObject:self.phoneNumTextField.text forKey:@"phone"];
        [dic setObject:self.sex forKey:@"sex"];
        NSDictionary *addressDic = @{@"province":self.provinceID,@"city":self.cityID,@"county":self.countyID,@"town":self.townID};
        [dic setObject:addressDic forKey:@"address"];
        [dic setObject:self.interestedProIdArr forKey:@"buyIntentions"];
        [dic setObject:@"IOS-v2.0" forKey:@"user-agent"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:KGetAdd parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                        NSLog(@"---------返回数据:---------%@",str);
            id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
            NSDictionary *resultDic;
            if ([resultObj isKindOfClass:[NSDictionary class]]) {
                resultDic = (NSDictionary *)resultObj;
            }
            if ([resultObj[@"code"] integerValue] == 1000) {
                [UILabel showMessage:@"客户登记成功"];
                [self.navigationController popViewControllerAnimated:NO];
            }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
//        [KSHttpRequest post:KGetAdd parameters:dic success:^(id result) {
//            
//            if ([result[@"code"]integerValue] == 1000) {
//                [UILabel showMessage:@"客户登记成功"];
//                [self.navigationController popViewControllerAnimated:NO];
//            }
//            
//        } failure:^(NSError *error) {
//            
//        }];
    }
    
}
-(void)createNavigation{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"添加潜在客户";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
