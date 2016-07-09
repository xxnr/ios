//
//  XNRFinishMineDataController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRFinishMineDataController.h"
#import "XNRAddressPickerView.h"
#import "XNRTownPickerView.h"
#import "XNRTypeView.h"

#define sexBtn  1000
@interface XNRFinishMineDataController()<XNRAddressPickerViewBtnDelegate,XNRTownPickerViewBtnDelegate,UITextFieldDelegate,XNRTypeViewBtnDelegate>

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

@property (nonatomic ,weak) UITextField *nameTf;
@property (nonatomic,assign)int nameLength;
//@property (nonatomic ,weak) UIButton *LocalAddressBtn;
@property (nonatomic ,weak) UILabel *LocalAddressLabel;
//@property (nonatomic ,weak) UIButton *streetBtn;
@property (nonatomic ,weak) UILabel *streetLabel;
//@property (nonatomic ,weak) UIButton *userTypeBtn;
@property (nonatomic ,weak) UILabel *userTypeLabel;


@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,copy) UIButton *tempBtn;
@end

@implementation XNRFinishMineDataController
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
        self.streetLabel.text = @"选择所在街道或乡镇";
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
    
}

-(void)keyboardWillBeHidden:(NSNotification *)note
{
    [self.addressManagerView hide];
    [self.townManagerView hide];

}

-(void)createTopView
{
    UILabel *banaerLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth, PX_TO_PT(98))];
    banaerLabel.text = @"完善资料即获得100积分哟";
    banaerLabel.textColor = R_G_B_16(0x323232);
    banaerLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [self.view addSubview:banaerLabel];
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:banaerLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff9000),
                               NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(40)]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(7,3)];
    
    [banaerLabel setAttributedText:AttributedStringDeposit];
    
    
    NSArray *titleArray = @[@"姓名",@"性别",@"地区",@"街道",@"类型"];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(98)+i*PX_TO_PT(98), PX_TO_PT(100), PX_TO_PT(98))];
        titleLabel.textColor = R_G_B_16(0x323232);
        titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        titleLabel.text = titleArray[i];
        self.titleLabel = titleLabel;
        [self.view addSubview:titleLabel];
    }

    // 姓名
    UITextField *nameTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), PX_TO_PT(98), ScreenWidth, PX_TO_PT(98))];
    nameTf.textAlignment = NSTextAlignmentLeft;
    if ([KSHttpRequest isBlankString:[DataCenter account].name]) {
        nameTf.placeholder = @"请填写真实姓名";

    }else{
        nameTf.text = [DataCenter account].name;
    }
    nameTf.textColor = R_G_B_16(0x323232);
    nameTf.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    nameTf.delegate = self;
    self.nameTf = nameTf;
    [self.view addSubview:nameTf];
    // 性别男
    UIButton *selelctedBtnM = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(nameTf.frame)+PX_TO_PT(31), PX_TO_PT(36), PX_TO_PT(36))];
    [selelctedBtnM setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [selelctedBtnM setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
    selelctedBtnM.tag = sexBtn + 1;
    selelctedBtnM.selected = YES;
    [selelctedBtnM addTarget:self action:@selector(selelctedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self selelctedBtnClick:selelctedBtnM];
    [self.view addSubview:selelctedBtnM];
    
    UIImageView *manImageViewM = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selelctedBtnM.frame)+PX_TO_PT(20), CGRectGetMaxY(nameTf.frame) + PX_TO_PT(19), PX_TO_PT(60), PX_TO_PT(60)) ];
    [manImageViewM setImage:[UIImage imageNamed:@"my_boy-icon"]];
    [self.view addSubview:manImageViewM];
    
    UILabel *manLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(manImageViewM.frame)+PX_TO_PT(24), CGRectGetMaxY(nameTf.frame), PX_TO_PT(100), PX_TO_PT(98))];
    manLabel.textColor = R_G_B_16(0x323232);
    manLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    manLabel.text = @"男";
    [self.view addSubview:manLabel];
    
    // 性别女
    UIButton *selelctedBtnW = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetMaxY(nameTf.frame)+PX_TO_PT(31), PX_TO_PT(36), PX_TO_PT(36))];
    [selelctedBtnW setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [selelctedBtnW setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
    selelctedBtnW.tag = sexBtn + 2;
    [selelctedBtnW addTarget:self action:@selector(selelctedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selelctedBtnW];
    
    UIImageView *manImageViewW = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selelctedBtnW.frame)+PX_TO_PT(20), CGRectGetMaxY(nameTf.frame) + PX_TO_PT(19), PX_TO_PT(60), PX_TO_PT(60)) ];
    [manImageViewW setImage:[UIImage imageNamed:@"my_girl"]];
    [self.view addSubview:manImageViewW];
    
    UILabel *womenLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(manImageViewW.frame)+PX_TO_PT(24), CGRectGetMaxY(nameTf.frame), PX_TO_PT(100), PX_TO_PT(98))];
    womenLabel.textColor = R_G_B_16(0x323232);
    womenLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    womenLabel.text = @"女";
    [self.view addSubview:womenLabel];
    
    
    // 地区
    UIButton *LocalAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(manLabel.frame), ScreenWidth, PX_TO_PT(98))];
    [LocalAddressBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    LocalAddressBtn.tag = 1000;
    [self.view addSubview:LocalAddressBtn];
    
    UILabel *LocalAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(98))];
    LocalAddressLabel.textColor = R_G_B_16(0x909090);
    LocalAddressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    if ([KSHttpRequest isBlankString:[DataCenter account].province]) {
        LocalAddressLabel.text = @"选择所在的省市区";
    }else{
        if ([DataCenter account].county == nil || [[DataCenter account].county isEqualToString:@""]) {
             LocalAddressLabel.text = [NSString stringWithFormat:@"%@%@",[DataCenter account].province,[DataCenter account].city];
        }else{
        
         LocalAddressLabel.text = [NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].county];
        }
       
    }
    self.LocalAddressLabel = LocalAddressLabel;
    [LocalAddressBtn addSubview:LocalAddressLabel];

    // 街道
    UIButton *streetBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(LocalAddressBtn.frame), ScreenWidth, PX_TO_PT(98))];
    [streetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    streetBtn.tag = 1001;
    [self.view addSubview:streetBtn];
    
    UILabel *streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(98))];
    streetLabel.textColor = R_G_B_16(0x909090);
    streetLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    if ([KSHttpRequest isBlankString:[DataCenter account].town]) {
        streetLabel.text = @"选择所在街道或乡镇";
    }else{
        streetLabel.text = [DataCenter account].town;

    }
    self.streetLabel = streetLabel;
    [streetBtn addSubview:streetLabel];

    // 类型
    UIButton *userTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(streetBtn.frame), ScreenWidth, PX_TO_PT(98))];
    [userTypeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    userTypeBtn.tag = 1002;
    [self.view addSubview:userTypeBtn];
    
    UILabel *userTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, PX_TO_PT(98))];
    userTypeLabel.textColor = R_G_B_16(0x909090);
    userTypeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    if ([KSHttpRequest isBlankString:[DataCenter account].type]) {
        userTypeLabel.text = @"选择用户类型";
    }else{
        userTypeLabel.text = [DataCenter account].type;
    }
    self.userTypeLabel = userTypeLabel;
    [userTypeBtn addSubview:userTypeLabel];

    for (int i = 1; i<7; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98)*i, ScreenWidth, 1)];
        lineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [self.view addSubview:lineView];
    }
    
}


#pragma mark --UITextFieldDelegate
-(BOOL)btnClick:(UIButton *)button
{
    [self.nameTf resignFirstResponder];
    if (button.tag == 1000) {
        [self.townManagerView hide];
        [self.typeView hide];
        __weak __typeof(&*self)weakSelf = self;
        [self.addressManagerView show];
        self.addressManagerView.com = ^(NSString *province,NSString *city,NSString *county,NSString *provinceID,NSString *cityId,NSString *countyId,NSString *province_id,NSString *city_id,NSString *county_id){
            if (county == nil||[county isEqualToString:@""]) {
                weakSelf.LocalAddressLabel.text = [NSString stringWithFormat:@"%@%@",province,city];

            }else{
                weakSelf.LocalAddressLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
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
                weakSelf.townID = townId;
                
            };
        }
    }
    
    if (button.tag == 1002) {
        [self.addressManagerView hide];
        [self.townManagerView hide];
        __weak __typeof(&*self)weakSelf = self;
        [self.typeView show];
        self.typeView.com = ^(NSString *typeName,NSString *typeNum){
            
            weakSelf.typeName = typeName;
            weakSelf.typeNum = typeNum;
            UserInfo *info = [DataCenter account];
            info.typeName = typeName;
            [DataCenter saveAccount:info];
        
        };
    }
    
    return YES;
}

#pragma mark --UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.addressManagerView hide];
    [self.townManagerView hide];
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameTf) {
        
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
        
        if (strlength > 12) {
            [UILabel showMessage:[NSString stringWithFormat:@"姓名限6个汉字或12个英文字符"]];
        }
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nameTf) {
        
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
    }
    return YES;
}
#pragma mark - 性别
-(void)selelctedBtnClick:(UIButton *)button
{
    [self.nameTf resignFirstResponder];

    _tempBtn.selected = NO;
    button.selected = YES;
    _tempBtn = button;
    
    if (button.tag == sexBtn + 1) {
        self.sex = @"false";
        
    }else if (button.tag == sexBtn + 2){
        self.sex = @"ture";
    }
}

-(void)createBottomView
{
    UIButton *jumpBtn = [[UIButton alloc] initWithFrame:CGRectMake(PX_TO_PT(32), ScreenHeight-PX_TO_PT(88)-64-PX_TO_PT(32), PX_TO_PT(160), PX_TO_PT(88))];
    jumpBtn.backgroundColor = R_G_B_16(0xf8f8f8);
    [jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [jumpBtn setTitleColor:R_G_B_16(0xc7c7c7) forState:UIControlStateNormal];
    jumpBtn.layer.cornerRadius = 5.0;
    jumpBtn.layer.masksToBounds = YES;
    jumpBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [jumpBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(jumpBtn.frame) + PX_TO_PT(32), ScreenHeight-PX_TO_PT(88)-64-PX_TO_PT(32), ScreenWidth-PX_TO_PT(256), PX_TO_PT(88))];
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
    if ([self.LocalAddressLabel.text isEqualToString:@"选择所在的省市区"] || [self.streetLabel.text isEqualToString:@"选择所在街道或乡镇"] || [self.nameTf.text isEqualToString:@""]) {
        
        [UILabel showMessage:@"请完善信息"];
    }
    else if(self.nameLength>12)
    {
        [UILabel showMessage:@"姓名限6个汉字或12个英文字符"];
    }
    else{
        NSDictionary *addressDict = @{@"provinceId":self.provinceID?self.provinceID:@"",@"cityId":self.cityID?self.cityID:@"",@"countyId":self.countyID?self.countyID:@"",@"townId":self.townID?self.townID:@""};
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"IOS-v2.0" forKey:@"user-agent"];
        [dic setObject:[DataCenter account].token?[DataCenter account].token:@"" forKey:@"token"];
        [dic setObject:[DataCenter account].userid forKey:@"userId"];
        [dic setObject:addressDict forKey:@"address"];
        [dic setObject:self.nameTf.text forKey:@"userName"];
        [dic setObject:self.sex forKey:@"sex"];
        [dic setObject:self.typeNum?self.typeNum:@"" forKey:@"type"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:KUserModify parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UserInfo *info = [DataCenter account];
            info.province = self.province;
            info.city = self.city;
            info.county = self.county;
            info.town = self.towns;
            [DataCenter saveAccount:info];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyAccount" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];

            NSLog(@"------%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    }
    
}

-(void)createNavigation{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(48)];
    titleLabel.textColor = R_G_B_16(0xfbffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"完善个人资料";
    self.navigationItem.titleView = titleLabel;
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;

}

-(void)backClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
