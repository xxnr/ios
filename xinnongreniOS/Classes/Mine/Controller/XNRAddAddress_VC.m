//
//  XNRAddAddress_VC.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/24.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRAddAddress_VC.h"
#import "XNRAddressManageView.h"
#import "XNRTownManagerView.h"
#define MARGIN  PX_TO_PT(24)
@interface XNRAddAddress_VC()<UITextFieldDelegate,XNRAddressManageViewBtnDelegate,XNRTownManagerViewBtnDelegate>
{
    int type;
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
@property (nonatomic ,weak) UITextField *addressTF;
@property (nonatomic ,weak) UITextField *townTF;
@property (nonatomic ,weak) UITextField *detailAddressTF;
@property (nonatomic ,weak) UITextField *eMailTF;


@property (nonatomic ,weak) UIView *midView;

@property (nonatomic ,weak) XNRAddressManageView *addressManagerView;
@property (nonatomic ,weak) XNRTownManagerView *townManagerView;

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

-(XNRAddressManageView *)addressManagerView{
    if (!_addressManagerView) {
        XNRAddressManageView *addressManagerView = [[XNRAddressManageView alloc] init];
        addressManagerView.delegate = self;
        self.addressManagerView = addressManagerView;
        [self.view addSubview:addressManagerView];
    }
    return _addressManagerView;

}

-(XNRTownManagerView *)townManagerView{
    if (!_townManagerView) {
        XNRTownManagerView *townManagerView = [[XNRTownManagerView alloc] init];
        townManagerView.delegate = self;
        self.townManagerView = townManagerView;
        [self.view addSubview:townManagerView];
    }
    return _townManagerView;


}

-(void)XNRAddressManageViewBtnClick:(XNRAddressManageViewType)type
{
    if (type == leftBtnType) {
        [self.addressManagerView hide];
    }else{
        [self.addressManagerView hide];
        if (self.county) {
            self.addressTF.text = [NSString stringWithFormat:@"%@%@%@",@"河南",self.city,self.county];

        }else{
            self.addressTF.text = [NSString stringWithFormat:@"%@%@",@"河南",self.city];
        }
}
    

}

-(void)XNRTownManagerViewBtnClick:(XNRTownManagerViewType)type
{
    if (type == eLeftBtnType) {
        [self.townManagerView hide];
    }else{
        [self.townManagerView hide];
        if (self.towns) {
            self.townTF.text = [NSString stringWithFormat:@"%@",self.towns];

        }
    }

}


-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNav];
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
    recivePerson.font = XNRFont(14);
    recivePerson.textColor = R_G_B_16(0x323232);
    self.recivePerson = recivePerson;
    [topBgView addSubview:recivePerson];
   
    UITextField *recivePersonTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.recivePerson.frame), y, ScreenWidth-w, h)];
    recivePersonTF.placeholder = @"请输入收货人姓名";
    recivePersonTF.textColor = R_G_B_16(0x909090);
    recivePersonTF.font = XNRFont(14);
    recivePersonTF.text = self.model.receiptPeople;
    self.recivePersonTF = recivePersonTF;
    [topBgView addSubview:recivePersonTF];
    // 2.联系电话
    UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)+MARGIN,PX_TO_PT(180),h)];
    phoneNum.text = @"联系电话:";
    phoneNum.font = XNRFont(14);
    phoneNum.textColor = R_G_B_16(0x323232);
    self.phoneNum = phoneNum;
    [topBgView addSubview:phoneNum];
    
    UITextField *phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneNum.frame), PX_TO_PT(96)+MARGIN, ScreenWidth-w, h)];
    phoneNumTF.placeholder = @"请输入收货人电话";
    phoneNumTF.textColor = R_G_B_16(0x909090);
    phoneNumTF.font = XNRFont(14);
    phoneNumTF.text = self.model.receiptPhone;
    self.phoneNumTF = phoneNumTF;
    [topBgView addSubview:phoneNumTF];
    // 3.省市区县
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)*2+MARGIN,PX_TO_PT(180),h)];
    address.text = @"省市区县:";
    address.font = XNRFont(14);
    address.textColor = R_G_B_16(0x323232);
    self.address = address;
    [topBgView addSubview:address];
    
    UITextField *addressTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.address.frame), PX_TO_PT(96)*2+MARGIN, ScreenWidth-w, h)];
    addressTF.placeholder = @"请选择地区";
    addressTF.textColor = R_G_B_16(0x909090);
    addressTF.font = XNRFont(14);
    addressTF.delegate = self;
    addressTF.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    addressTF.tag = 1000;
    if (self.model) {
        if (self.model.countyName) {
            addressTF.text = [NSString stringWithFormat:@"%@%@%@",self.model.areaName,self.model.cityName,self.model.countyName];
        }else{
            addressTF.text = [NSString stringWithFormat:@"%@%@",self.model.areaName,self.model.cityName];
        }
    }
    

    self.addressTF = addressTF;
    [topBgView addSubview:addressTF];
    // 4.乡镇
    UILabel *town = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)*3 + MARGIN, PX_TO_PT(100), h)];
    town.text = @"乡镇:";
    town.font = XNRFont(14);
    town.textColor = R_G_B_16(0x323232);
    self.town = town;
    [topBgView addSubview:town];
    
    UITextField *townTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.town.frame), PX_TO_PT(96)*3+MARGIN, ScreenWidth-w, h)];
    townTF.placeholder = @"请选择乡镇";
    townTF.textColor = R_G_B_16(0x909090);
    townTF.font = XNRFont(14);
    townTF.delegate = self;
    townTF.inputView = [[UIView alloc] initWithFrame:CGRectZero];

    if (self.model) {
        if (self.model.townName) {
            townTF.text = self.model.townName;
        }
    }
    
    townTF.tag = 1001;
    self.townTF = townTF;
    [topBgView addSubview:townTF];
    
    // 5.详细地址
    UILabel *detailAddress = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)*4+MARGIN,PX_TO_PT(180),h)];
    detailAddress.text = @"详细地址:";
    detailAddress.font = XNRFont(14);
    detailAddress.textColor = R_G_B_16(0x323232);
    self.detailAddress = detailAddress;
    [topBgView addSubview:detailAddress];
    
    UITextField *detailAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.detailAddress.frame), PX_TO_PT(96)*4+MARGIN, ScreenWidth-w, h)];
    detailAddressTF.placeholder = @"不必重复填写省市区信息";
    detailAddressTF.textColor = R_G_B_16(0x909090);
    detailAddressTF.font = XNRFont(14);
    detailAddressTF.text = self.model.address;
    self.detailAddressTF = detailAddressTF;
    [topBgView addSubview:detailAddressTF];
    // 6.邮编
    UILabel *eMail = [[UILabel alloc] initWithFrame:CGRectMake(x, PX_TO_PT(96)*5+MARGIN,PX_TO_PT(100),h)];
    eMail.text = @"邮编:";
    eMail.font = XNRFont(14);
    eMail.textColor = R_G_B_16(0x323232);
    self.eMail = eMail;
    [topBgView addSubview:eMail];
    
    UITextField *emailTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.eMail.frame), PX_TO_PT(96)*5+MARGIN, ScreenWidth-w, h)];
    emailTF.placeholder = @"(选填)请输入邮政编码";
    emailTF.textColor = R_G_B_16(0x909090);
    emailTF.font = XNRFont(14);
//    emailTF.keyboardType = UIKeyboardTypePhonePad;
//    emailTF.returnKeyType = UIReturnKeyDone;

    if (self.model.zipCode) {
        emailTF.text = self.model.zipCode;
    }
    self.eMailTF = emailTF;
    [topBgView addSubview:emailTF];
    
    for (int i = 0; i<7; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(96)*i, ScreenWidth, PX_TO_PT(2))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [topBgView addSubview:lineView];
    }
    
}

#pragma mark --UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [textField resignFirstResponder];
//    [self.townTF resignFirstResponder];
    if (textField.tag == 1000) {
        [self.townManagerView hide];
        __weak __typeof(&*self)weakSelf = self;

        [self.addressManagerView showWith:^(NSString *province, NSString *city, NSString *county, NSString *provinceID, NSString *cityId, NSString *countyId) {
            if (province) {
                weakSelf.province = province;
                weakSelf.provinceID = provinceID;
            }
            if (city) {
                weakSelf.cityID = cityId;
                weakSelf.city = city;

            }
            if (county) {
                weakSelf.county = county;
                weakSelf.countyID = countyId;

            }
            
            UserInfo *info = [DataCenter account];
            info.cityID = cityId;
            info.countyID = countyId;
            [DataCenter saveAccount:info];
            NSLog(@"====%@====%@",info.cityID,info.countyID);

        }];
        
    }
    
    if (textField.tag == 1001) {
        [self.addressManagerView hide];
        __weak __typeof(&*self)weakSelf = self;

        [self.townManagerView showWith:^(NSString *townName, NSString *townId) {
            weakSelf.townID = townId;
            weakSelf.towns = townName;
        }];
        
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
    defaultAddress.font = XNRFont(14);
    [midView addSubview:defaultAddress];
    
    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(140), PX_TO_PT(12), PX_TO_PT(100), PX_TO_PT(40))];
    mySwitch.tintColor = R_G_B_16(0xa2a2a2);
    mySwitch.onTintColor = R_G_B_16(0x00b38a);
    [mySwitch addTarget:self action:@selector(mySwitchChange:) forControlEvents:UIControlEventTouchUpInside];
    [midView addSubview:mySwitch];
    
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98)*i, ScreenWidth, PX_TO_PT(2))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [midView addSubview:lineView];
     }
}

-(void)mySwitchChange:(UISwitch *)mySwitch{
    
    if (mySwitch.isOn) {
        type = 1;
        NSLog(@"开启");
    }else{
        type = 2;
        NSLog(@"关闭");
    }
}

-(void)createBottomView{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(PX_TO_PT(20), CGRectGetMaxY(self.midView.frame) + PX_TO_PT(100), ScreenWidth - PX_TO_PT(20)*2, PX_TO_PT(98));
    saveBtn.layer.cornerRadius = 5.0;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = R_G_B_16(0x00b38a);
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
    
    }else if ([self.addressTF.text isEqualToString:@""] || self.addressTF.text == nil){
        flag = 0;
        title = @"请选择城市";
    }
//    else if ([self.townTF.text isEqualToString:@""] || self.townTF.text == nil){
//        flag = 0;
//        title  = @"请输入您的详细地址";
//    
//    }
    else if ([self.detailAddressTF.text isEqualToString:@""] || self.detailAddressTF.text == nil){
        flag = 0;
        title = @"请输入您的详细地址";
    
    }else{
        if ([self.titleLabel isEqualToString:@"添加收货地址"]) {
            [KSHttpRequest post:KSaveUserAddress parameters:@{@"userId":[DataCenter account].userid,@"receiptPhone":self.phoneNumTF.text,@"receiptPeople":self.recivePersonTF.text,@"address":self.detailAddressTF.text,@"areaId":@"58054e5ba551445",@"cityId":self.cityID?self.cityID:@"",@"countyId":self.countyID?self.countyID:@"",@"townId":self.townID?self.townID:@"",@"zipCode":self.eMailTF.text?self.eMailTF.text:@"",@"type":[NSString stringWithFormat:@"%d",type]} success:^(id result) {
                if ([result[@"code"] integerValue] == 1000) {
                    if (type == 1) {
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
                    //                self.addressRefreshBlock();
                    
                }
                
                
            } failure:^(NSError *error) {
                
            }];

        }else{// 更新收货地址
            [KSHttpRequest post:KUpdateUserAddress parameters:@{@"userId":[DataCenter account].userid,@"addressId":self.model.addressId,@"receiptPhone":self.phoneNumTF.text,@"receiptPeople":self.recivePersonTF.text,@"address":self.detailAddressTF.text,@"areaId":@"58054e5ba551445",@"cityId":self.cityID?self.cityID:@"",@"countyId":self.countyID?self.countyID:@"",@"townId":self.townID?self.townID:@"",@"zipCode":self.eMailTF.text?self.eMailTF.text:@"",@"type":[NSString stringWithFormat:@"%d",type]} success:^(id result) {
                if ([result[@"code"] integerValue] == 1000) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addressRefresh" object:self];
                    
                    [self.navigationController popViewControllerAnimated:YES];

                }
            } failure:^(NSError *error) {
                
            }];
            
        }
            }
    
    if (flag == 0) {
//        BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:title chooseBtns:@[@"好"]];
//        [alertView BMAlertShow];
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

//-(void)setModel:(XNRAddressManageModel *)model
//{
//    _model = model;
//    self.recivePersonTF.text = _model.receiptPeople;
//
//
//}



-(void)createNav{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = R_G_B_16(0xfbffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.titleLabel;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 44);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backBtn addTarget: self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];

}



@end
