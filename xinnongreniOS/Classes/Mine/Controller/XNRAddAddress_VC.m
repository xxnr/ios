//
//  XNRAddAddress_VC.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/24.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRAddAddress_VC.h"
#import "XNRAddressPickerView.h"
#import "XNRTownPickerView.h"
#define MARGIN  PX_TO_PT(24)
#define textFieldTag 1000
@interface XNRAddAddress_VC()<UITextFieldDelegate,XNRAddressPickerViewBtnDelegate,XNRTownPickerViewBtnDelegate>
{
    NSString *addressType;
}

@property (nonatomic ,weak) UIView *topBgView;

@property (nonatomic ,weak) UILabel *recivePerson;

@property (nonatomic ,weak) UILabel *phoneNum;

@property (nonatomic ,weak) UILabel *address;

@property (nonatomic ,weak) UILabel *town;

@property (nonatomic ,weak) UILabel *detailAddress;

@property (nonatomic ,weak) UILabel *eMail;

@property (nonatomic ,weak) UITextField *recivePersonTF;
@property (nonatomic ,weak) UITextField *phoneNumTF;
@property (nonatomic ,weak) UILabel *addressLabel;
@property (nonatomic ,weak) UILabel *townLabel;
@property (nonatomic ,weak) UITextField *detailAddressTF;
@property (nonatomic ,weak) UITextField *eMailTF;
@property (nonatomic ,weak) UIView *midView;
@property (nonatomic ,weak) XNRAddressPickerView *addressManagerView;
@property (nonatomic ,weak) XNRTownPickerView *townManagerView;
@property (nonatomic ,copy) NSString *province;
@property (nonatomic ,copy) NSString *city;
@property (nonatomic ,copy) NSString *county;
@property (nonatomic ,copy) NSString *towns;
@property (nonatomic ,copy) NSString *provinceID;
@property (nonatomic ,copy) NSString *cityID;
@property (nonatomic ,copy) NSString *countyID;
@property (nonatomic ,copy) NSString *townID;
@end

@implementation XNRAddAddress_VC
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
        self.townLabel.text = @"请选择乡镇";
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
#pragma mark - 键盘回收

-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return YES;
}



-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNav];
    addressType = self.model.type;
    [self createTopView];
    [self createMidView];
    [self createBottomView];
}


-(void)createTopView{
    CGFloat x = PX_TO_PT(20);
    CGFloat y = PX_TO_PT(28);
    CGFloat w = PX_TO_PT(140);
    CGFloat h = PX_TO_PT(40);
    
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, MARGIN, ScreenWidth, PX_TO_PT(96)*6)];
    topBgView.backgroundColor = [UIColor whiteColor];
    self.topBgView = topBgView;
    [self.view addSubview:topBgView];
    
    // 1.收货人
    UILabel *recivePerson = [[UILabel alloc] initWithFrame:CGRectMake(x,y,w,h)];
    recivePerson.text = @"收货人:";
    recivePerson.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    recivePerson.textColor = R_G_B_16(0x323232);
    self.recivePerson = recivePerson;
    [topBgView addSubview:recivePerson];
   
    UITextField *recivePersonTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.recivePerson.frame), y, ScreenWidth-w, h)];
    recivePersonTF.placeholder = @"请输入收货人姓名";
    recivePersonTF.textColor = R_G_B_16(0x909090);
    [recivePersonTF setValue:R_G_B_16(0x909090) forKeyPath:@"_placeholderLabel.textColor"];
    recivePersonTF.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    recivePersonTF.text = self.model.receiptPeople;
    recivePersonTF.delegate = self;
    recivePersonTF.tag = textFieldTag;
    self.recivePersonTF = recivePersonTF;
    [topBgView addSubview:recivePersonTF];
    // 2.联系电话
    UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)+MARGIN,PX_TO_PT(180),h)];
    phoneNum.text = @"联系电话:";
    phoneNum.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    phoneNum.textColor = R_G_B_16(0x323232);
    self.phoneNum = phoneNum;
    [topBgView addSubview:phoneNum];
    
    UITextField *phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneNum.frame), PX_TO_PT(96)+MARGIN, ScreenWidth-w, h)];
    phoneNumTF.placeholder = @"请输入收货人电话";
    phoneNumTF.textColor = R_G_B_16(0x909090);
    [phoneNumTF setValue:R_G_B_16(0x909090) forKeyPath:@"_placeholderLabel.textColor"];
    phoneNumTF.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    phoneNumTF.keyboardType = UIKeyboardTypePhonePad;
    phoneNumTF.text = self.model.receiptPhone;
    phoneNumTF.delegate = self;
    phoneNumTF.tag = textFieldTag +1;
    self.phoneNumTF = phoneNumTF;
    [topBgView addSubview:phoneNumTF];
    // 3.省市区县
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)*2+MARGIN,PX_TO_PT(180),h)];
    address.text = @"省市区县:";
    address.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    address.textColor = R_G_B_16(0x323232);
    self.address = address;
    [topBgView addSubview:address];
    
    UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.address.frame), PX_TO_PT(96)*2, ScreenWidth-w, PX_TO_PT(96))];
    [addressBtn addTarget:self action:@selector(addressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:addressBtn];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(96))];
    addressLabel.textColor = R_G_B_16(0x909090);
    addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    if (self.model.areaName) {
        if (self.model.countyName) {
            UserInfo *info = [DataCenter account];
            info.countyID = self.model.countyId;
            [DataCenter saveAccount:info];
            
            addressLabel.text = [NSString stringWithFormat:@"%@%@%@",_model.areaName,_model.cityName,_model.countyName];
        }else{
            UserInfo *info = [DataCenter account];
            info.cityID = self.model.cityId;
            [DataCenter saveAccount:info];
            addressLabel.text = [NSString stringWithFormat:@"%@%@",_model.areaName,_model.cityName];
        }
    }else{
        addressLabel.text = @"请选择地区";
    }

    self.addressLabel = addressLabel;
    [addressBtn addSubview:addressLabel];
    
    // 4.乡镇
    UILabel *town = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)*3 + MARGIN, PX_TO_PT(100), h)];
    town.text = @"乡镇:";
    town.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    town.textColor = R_G_B_16(0x323232);
    self.town = town;
    [topBgView addSubview:town];
    
    UIButton *townBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.town.frame), PX_TO_PT(96)*3, ScreenWidth-w, PX_TO_PT(96))];
    [townBtn addTarget: self action:@selector(townBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:townBtn];
    
    UILabel *townLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(96))];
    townLabel.text = @"请选择乡镇";
    townLabel.textColor = R_G_B_16(0x909090);
    townLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    
    if (self.model) {
        if (self.model.townName) {
            townLabel.text = self.model.townName;
        }
    }
    
    self.townLabel = townLabel;
    [townBtn addSubview:townLabel];
    
    // 5.详细地址
    UILabel *detailAddress = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)*4+MARGIN,PX_TO_PT(180),h)];
    detailAddress.text = @"详细地址:";
    detailAddress.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    detailAddress.textColor = R_G_B_16(0x323232);
    self.detailAddress = detailAddress;
    [topBgView addSubview:detailAddress];
    
    UITextField *detailAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.detailAddress.frame), PX_TO_PT(96)*4+MARGIN, ScreenWidth-w, h)];
    detailAddressTF.placeholder = @"不必重复填写省市区信息";
    detailAddressTF.textColor = R_G_B_16(0x909090);
    [detailAddressTF setValue:R_G_B_16(0x909090) forKeyPath:@"_placeholderLabel.textColor"];
    detailAddressTF.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    detailAddressTF.text = self.model.address;
    detailAddressTF.delegate = self;
    detailAddressTF.tag = textFieldTag + 2;
    self.detailAddressTF = detailAddressTF;
    [topBgView addSubview:detailAddressTF];
    
    // 6.邮编
    UILabel *eMail = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)*5+MARGIN,PX_TO_PT(100),h)];
    eMail.text = @"邮编:";
    eMail.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    eMail.textColor = R_G_B_16(0x323232);
    self.eMail = eMail;
    [topBgView addSubview:eMail];
    
    UITextField *emailTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.eMail.frame), PX_TO_PT(96)*5+MARGIN, ScreenWidth-w, h)];
    emailTF.placeholder = @"(选填)请输入邮政编码";
    emailTF.textColor = R_G_B_16(0x909090);
    [emailTF setValue:R_G_B_16(0x909090) forKeyPath:@"_placeholderLabel.textColor"];
    emailTF.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    emailTF.tag = textFieldTag + 3;
    emailTF.delegate = self;

    if (self.model.zipCode) {
        emailTF.text = self.model.zipCode;
    }
    self.eMailTF = emailTF;
    [topBgView addSubview:emailTF];
    
    for (int i = 0; i<7; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(96)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [topBgView addSubview:lineView];
    }
    
}
#pragma mark - Block的回调
-(void)addressBtnClick:(UIButton *)button
{
    [self.townManagerView hide];
    [self.recivePersonTF resignFirstResponder];
    [self.phoneNumTF resignFirstResponder];
    [self.detailAddressTF resignFirstResponder];
    [self.eMailTF resignFirstResponder];
    __weak __typeof(&*self)weakSelf = self;
    [self.addressManagerView show];
    self.addressManagerView.com = ^(NSString *province,NSString *city,NSString *county,NSString *provinceID,NSString *cityId,NSString *countyId,NSString *province_id,NSString *city_id,NSString *county_id){
        if (county == nil || [county isEqualToString:@""]) {
            weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@%@",province,city];

        }else{
            weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
        }
        weakSelf.provinceID = provinceID;
        weakSelf.cityID  = cityId;
        weakSelf.countyID = countyId;
        
        UserInfo *info = [DataCenter account];
        info.province = province;
        info.city = city;
        info.county = county;
        info.cityID = cityId;
        info.countyID = countyId;
        [DataCenter saveAccount:info];
    };
}

-(void)townBtnClick:(UIButton *)button
{
    [self.addressManagerView hide];
    [self.recivePersonTF resignFirstResponder];
    [self.phoneNumTF resignFirstResponder];
    [self.detailAddressTF resignFirstResponder];
    [self.eMailTF resignFirstResponder];

    __weak __typeof(&*self)weakSelf = self;
    [self.townManagerView show];
    self.townManagerView.com = ^(NSString *townName,NSString *townId,NSString *town_id){
        
        weakSelf.townLabel.text = townName;
        weakSelf.townID = townId;
    
    };
}
#pragma mark --UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.addressManagerView hide];
    [self.townManagerView hide];
    
    if (textField.tag == textFieldTag) {
        
    }else if (textField.tag == textFieldTag + 1){
    
    }else if (textField.tag == textFieldTag + 2){
    
    }else{
    
    
    }
    return YES;
}

-(void)createMidView{
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBgView.frame) + MARGIN, ScreenWidth, PX_TO_PT(98))];
    midView.backgroundColor = [UIColor whiteColor];
    self.midView = midView;
    [self.view addSubview:midView];
    
    UILabel *defaultAddress = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(20), PX_TO_PT(29), PX_TO_PT(240), PX_TO_PT(40))];
    defaultAddress.text = @"设为默认地址";
    defaultAddress.textColor = R_G_B_16(0x323232);
    defaultAddress.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [midView addSubview:defaultAddress];
    
    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(140), PX_TO_PT(12), PX_TO_PT(100), PX_TO_PT(40))];
    mySwitch.tintColor = R_G_B_16(0xa2a2a2);
    mySwitch.onTintColor = R_G_B_16(0x00b38a);
    [mySwitch addTarget:self action:@selector(mySwitchChange:) forControlEvents:UIControlEventTouchUpInside];
    if ([_model.type integerValue] ==  1) {
        mySwitch.on = YES;
    }
    [midView addSubview:mySwitch];
    
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [midView addSubview:lineView];
     }
}

-(void)mySwitchChange:(UISwitch *)mySwitch{
    if (mySwitch.isOn) {
        addressType = @"1";
        NSLog(@"开启");
    }else{
        addressType = @"2";
        NSLog(@"关闭");
    }
}

-(void)createBottomView{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(PX_TO_PT(20), CGRectGetMaxY(self.midView.frame) + PX_TO_PT(100), ScreenWidth - PX_TO_PT(20)*2, PX_TO_PT(98));
    saveBtn.layer.cornerRadius = 5.0;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#66d1b9"]] forState:UIControlStateHighlighted];
    [saveBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateNormal];

    [saveBtn setTintColor:[UIColor whiteColor]];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];

}

-(void)saveBtnClick{
    int flag = 1;
    NSString *title;
    if ([self.recivePersonTF.text isEqualToString:@""] || self.recivePersonTF.text == nil) {
        flag = 0;
        title = @"收货人不能为空";
    }else if ([self.phoneNumTF.text isEqualToString:@""] || self.phoneNumTF.text == nil){
        flag = 0;
        title = @"电话号码不能为空";
    
    }else if ([self validateMobile:self.phoneNumTF.text] == NO){
        flag = 0;
        title = @"手机格式错误";
    
    }else if ([self.addressLabel.text isEqualToString:@""] || self.addressLabel.text == nil){
        flag = 0;
        title = @"请选择城市";
    }else if ([self.detailAddressTF.text isEqualToString:@""] || self.detailAddressTF.text == nil){
        flag = 0;
        title = @"请输入您的详细地址";
    
    }else{
        if ([self.titleLabel isEqualToString:@"添加收货地址"]) {
            
            NSDictionary *params = @{@"userId":[DataCenter account].userid,@"receiptPhone":self.phoneNumTF.text,@"receiptPeople":self.recivePersonTF.text,@"address":self.detailAddressTF.text,@"areaId":@"58054e5ba551445",@"cityId":self.cityID?self.cityID:@"",@"countyId":self.countyID?self.countyID:@"",@"townId":self.townID?self.townID:@"",@"zipCode":self.eMailTF.text?self.eMailTF.text:@"",@"type":[NSString stringWithFormat:@"%@",addressType],@"user-agent":@"IOS-v2.0"};
            
            [KSHttpRequest post:KSaveUserAddress parameters:params success:^(id result) {
                if ([result[@"code"] integerValue] == 1000) {
                    if ([addressType isEqualToString:@"1"]) {
                        UserInfo *info = [DataCenter account];
                        NSString *address1 = [NSString stringWithFormat:@"%@%@",self.model.areaName,self.model.cityName];
                        NSString *address2 = [NSString stringWithFormat:@"%@%@%@",self.model.areaName,self.model.cityName,self.model.countyName];
                        if ([self.model.countyName isEqualToString:@""] || self.model.countyName == nil) {
                            if ([self.model.townName isEqualToString:@""] || self.model.townName == nil) {
                                info.address = [NSString stringWithFormat:@"%@%@",address1,self.model.address];
                            }else{
                                info.address = [NSString stringWithFormat:@"%@%@%@",address1,self.model.townName,self.model.address];
                                
                            }
                            
                        }else{
                            if ([self.model.townName isEqualToString:@""]|| self.model.townName == nil) {
                                info.address = [NSString stringWithFormat:@"%@%@",address2,self.model.address];
                            }else{
                                info.address = [NSString stringWithFormat:@"%@%@%@",address2,self.model.townName,self.model.address];
                                
                            }
                            
                        }
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addressRefresh" object:self];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
                
            } failure:^(NSError *error) {
                
            }];

        }else{// 更新收货地址
            NSDictionary *params = @{@"userId":[DataCenter account].userid,@"addressId":self.model.addressId,@"receiptPhone":self.phoneNumTF.text,@"receiptPeople":self.recivePersonTF.text,@"address":self.detailAddressTF.text,@"areaId":@"58054e5ba551445",@"cityId":self.cityID?self.cityID:self.model.cityId,@"countyId":self.countyID?self.countyID:self.model.countyId,@"townId":self.townID?self.townID:self.model.townId,@"zipCode":self.eMailTF.text?self.eMailTF.text:@"",@"type":addressType,@"user-agent":@"IOS-v2.0"};
            
            [KSHttpRequest post:KUpdateUserAddress parameters:params success:^(id result) {
                if ([result[@"code"] integerValue] == 1000) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addressRefresh" object:self];
                    
                    [self.navigationController popViewControllerAnimated:YES];

                }
            } failure:^(NSError *error) {
                
            }];
            
        }
            }
    
    if (flag == 0) {
        
        [UILabel showMessage:title];
        
        return;
    }
}

#pragma mark - 正则表达式判断手机号格式
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


-(void)createNav{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = R_G_B_16(0xfbffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.titleLabel;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 44);
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backBtn addTarget: self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


@end
