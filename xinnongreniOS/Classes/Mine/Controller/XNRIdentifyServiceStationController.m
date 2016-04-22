//
//  XNRIdentifyServiceStationController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/20.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRIdentifyServiceStationController.h"
#import "XNRAddressPickerView.h"
#import "XNRTownPickerView.h"

@interface XNRIdentifyServiceStationController ()<XNRAddressPickerViewBtnDelegate,XNRTownPickerViewBtnDelegate,UITextFieldDelegate>

@property (nonatomic, weak) XNRAddressPickerView *addressManagerView;
@property (nonatomic, weak) XNRTownPickerView *townManagerView;

@property (nonatomic, weak) UITextField *nameTF;
@property (nonatomic, weak) UITextField *idCardNumTF;
@property (nonatomic, weak) UITextField *storeNameTF;
@property (nonatomic, weak) UITextField *phoneNumTF;
@property (nonatomic, weak) UITextField *detailAddressTF;
@property (nonatomic, weak) UILabel *areaLabel;
@property (nonatomic, weak) UILabel *streetLabel;
@property (nonatomic, weak) UILabel *warnLabel;
@property (nonatomic, weak) UIButton *submitbtn;

@property (nonatomic, copy) NSString *provinceID;
@property (nonatomic, copy) NSString *cityID;
@property (nonatomic, copy) NSString *countyID;
@property (nonatomic, copy) NSString *townID;

@property (nonatomic, assign) int nameLength;
@property (nonatomic, assign) int storeNameLength;
@property (nonatomic, assign) int detailAddressLength;

@end

@implementation XNRIdentifyServiceStationController

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

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xffffff);
    [self setNavigationBar];
    [self createView];
    // 只有填写了认证信息才请求数据
    if (!_notWriteIdentifyInfo) {
        self.view.userInteractionEnabled = NO;
        [self.warnLabel removeFromSuperview];
        [self.submitbtn removeFromSuperview];
        [self getRSCData];
    }
}

-(void)getRSCData
{
    [KSHttpRequest get:KRscInfoGet parameters:@{@"token":[DataCenter account].token} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"RSCInfo"];
            NSDictionary *companyAddress = dict[@"companyAddress"];
            NSDictionary *province = companyAddress[@"province"];
            NSDictionary *city = companyAddress[@"city"];
            NSDictionary *county = companyAddress[@"county"];
            NSDictionary *town = companyAddress[@"town"];
            if (![KSHttpRequest isNULL:dict[@"name"]]) {
                self.nameTF.text = dict[@"name"];
            }
            if (![KSHttpRequest isNULL:dict[@"IDNo"]]) {
                self.idCardNumTF.text = dict[@"IDNo"];
            }
            if (![KSHttpRequest isNULL:dict[@"companyName"]]) {
                self.storeNameTF.text = dict[@"companyName"];
            }
            if (![KSHttpRequest isNULL:dict[@"phone"]]) {
                self.phoneNumTF.text = dict[@"phone"];
            }
            if (![KSHttpRequest isNULL:companyAddress[@"details"]]) {
                [self.detailAddressTF removeFromSuperview];
                UILabel *detailAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200), PX_TO_PT(20)+PX_TO_PT(88)*6, ScreenWidth-PX_TO_PT(200), PX_TO_PT(88))];
                detailAddressLabel.textColor = R_G_B_16(0x646464);
                detailAddressLabel.numberOfLines = 0;
                detailAddressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
                detailAddressLabel.text = companyAddress[@"details"];
                [self.view addSubview:detailAddressLabel];
            }
            if (![KSHttpRequest isNULL:province]) {
                if (![KSHttpRequest isNULL:county]) {
                    self.areaLabel.text = [NSString stringWithFormat:@"%@%@%@",province[@"name"],city[@"name"],county[@"name"]];
                }else{
                    self.areaLabel.text = [NSString stringWithFormat:@"%@%@",province[@"name"],city[@"name"]];
                }
                self.areaLabel.textColor = R_G_B_16(0x646464);
            }else{
                self.areaLabel.text = @"选择所在省市区县";
            }
            if (![KSHttpRequest isNULL:town]) {
                self.streetLabel.text = [NSString stringWithFormat:@"%@",town[@"name"]];
                self.streetLabel.textColor = R_G_B_16(0x646464);

            }
        }else if ([result[@"code"] integerValue] == 1401){
            [UILabel showMessage:result[@"message"]];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            XNRLoginViewController *loginVC = [[XNRLoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)createView
{
    NSArray *titleArray = @[@"姓名",@"身份证号",@"门店名称",@"联系电话",@"地区",@"街道",@"详细地址"];
    CGFloat margin = PX_TO_PT(20);
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32),margin+PX_TO_PT(88)*i, ScreenWidth, PX_TO_PT(88))];
        titleLabel.textColor = R_G_B_16(0x323232);
        titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        titleLabel.text = titleArray[i];
        [self.view addSubview:titleLabel];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, margin+PX_TO_PT(88)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [self.view addSubview:lineView];
    }
    
    UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(PX_TO_PT(200), margin, ScreenWidth-PX_TO_PT(200), PX_TO_PT(88))];
    nameTF.placeholder = @"请填写真实姓名";
    nameTF.textColor = R_G_B_16(0x646464);
    [nameTF setValue:R_G_B_16(0x909090) forKeyPath:@"_placeholderLabel.textColor"];
    self.nameTF = nameTF;
    nameTF.delegate = self;
    [self.view addSubview:nameTF];

    UITextField *idCardNumTF = [[UITextField alloc] initWithFrame:CGRectMake(PX_TO_PT(200), margin+PX_TO_PT(88), ScreenWidth-PX_TO_PT(200), PX_TO_PT(88))];
    idCardNumTF.textColor = R_G_B_16(0x646464);
    idCardNumTF.placeholder = @"请填写身份证号";
    idCardNumTF.delegate = self;
    [idCardNumTF setValue:R_G_B_16(0x909090) forKeyPath:@"_placeholderLabel.textColor"];
    self.idCardNumTF = idCardNumTF;
    [self.view addSubview:idCardNumTF];

    UITextField *storeNameTF = [[UITextField alloc] initWithFrame:CGRectMake(PX_TO_PT(200), margin+PX_TO_PT(88)*2, ScreenWidth-PX_TO_PT(200), PX_TO_PT(88))];
    storeNameTF.textColor = R_G_B_16(0x646464);
    storeNameTF.delegate = self;
    storeNameTF.placeholder = @"请填写您的门店名称";
    [storeNameTF setValue:R_G_B_16(0x909090) forKeyPath:@"_placeholderLabel.textColor"];
    self.storeNameTF = storeNameTF;
    [self.view addSubview:storeNameTF];

    UITextField *phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(PX_TO_PT(200), margin+PX_TO_PT(88)*3, ScreenWidth-PX_TO_PT(200), PX_TO_PT(88))];
    phoneNumTF.textColor = R_G_B_16(0x646464);
    phoneNumTF.placeholder = @"请填写负责人手机号";
    phoneNumTF.delegate = self;
    [phoneNumTF setValue:R_G_B_16(0x909090) forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneNumTF = phoneNumTF;
    [self.view addSubview:phoneNumTF];
    
    NSArray *addressArray = @[@"选择所在省市区县",@"选择所在街道或者乡镇"];
    for (int i = 0; i<addressArray.count; i++) {
        
        UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, margin+PX_TO_PT(88)*4+PX_TO_PT(88)*i, ScreenWidth, PX_TO_PT(88))];
        [addressBtn addTarget:self action:@selector(addressBtnCick:) forControlEvents:UIControlEventTouchUpInside];
        addressBtn.tag = 1000+i;
        [self.view addSubview:addressBtn];
    }
    
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200), margin+PX_TO_PT(88)*4, ScreenWidth-PX_TO_PT(200), PX_TO_PT(88))];
    areaLabel.text = @"选择所在省市区县";
    areaLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    areaLabel.textColor = R_G_B_16(0x909090);
    self.areaLabel = areaLabel;
    [self.view addSubview:areaLabel];
    
    UILabel *streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(200), margin+PX_TO_PT(88)*5, ScreenWidth-PX_TO_PT(200), PX_TO_PT(88))];
    streetLabel.text = @"选择所在街道或者乡镇";
    streetLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    streetLabel.textColor = R_G_B_16(0x909090);
    self.streetLabel = streetLabel;
    [self.view addSubview:streetLabel];
    
    UITextField *detailAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(PX_TO_PT(200), margin + PX_TO_PT(88)*6, ScreenWidth-PX_TO_PT(200), PX_TO_PT(88))];
    detailAddressTF.placeholder = @"请填写门店的详细地址";
    detailAddressTF.textColor = R_G_B_16(0x646464);
    detailAddressTF.delegate = self;
    [detailAddressTF setValue:R_G_B_16(0x909090) forKeyPath:@"_placeholderLabel.textColor"];
    self.detailAddressTF = detailAddressTF;
    [self.view addSubview:detailAddressTF];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, margin+PX_TO_PT(88)*7, ScreenWidth, PX_TO_PT(1))];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [self.view addSubview:lineView];
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), CGRectGetMaxY(lineView.frame)+margin, ScreenWidth-PX_TO_PT(60), PX_TO_PT(60))];
    warnLabel.textColor = R_G_B_16(0xff9000);
    warnLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    warnLabel.text = @"*资料提交后不可修改，若认证成功，“我的新农人”页面会展示认证徽章哟";
    warnLabel.numberOfLines = 0;
    NSMutableAttributedString *warnLabelString = [[NSMutableAttributedString alloc]initWithString:warnLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0x646464),
                               };
    
    [warnLabelString addAttributes:depositStr range:NSMakeRange(1,warnLabelString.length-1)];
    
    [warnLabel setAttributedText:warnLabelString];
    
    self.warnLabel = warnLabel;

    [self.view addSubview:warnLabel];
    
    
    UIButton *submitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitbtn.frame = CGRectMake(PX_TO_PT(30), ScreenHeight-64-PX_TO_PT(30)-PX_TO_PT(88), ScreenWidth-PX_TO_PT(60), PX_TO_PT(88));
    submitbtn.backgroundColor = R_G_B_16(0x00b38a);
    submitbtn.layer.cornerRadius = 5.0;
    submitbtn.layer.masksToBounds = YES;
    [submitbtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitbtn setTitleColor:R_G_B_16(0xffffff) forState:UIControlStateNormal];
    submitbtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [submitbtn addTarget:self action:@selector(submitbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.submitbtn = submitbtn;
    [self.view addSubview:submitbtn];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == self.nameTF) {
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
            [UILabel showMessage:[NSString stringWithFormat:@"您的输入超过限制"]];
        }

    }else if (textField == self.storeNameTF){
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
        self.storeNameLength = strlength;
        if (strlength > 20) {
            [UILabel showMessage:[NSString stringWithFormat:@"您的输入超过限制"]];
        }

    
    }else if (textField == self.detailAddressTF){
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
        self.detailAddressLength = strlength;
        if (strlength > 30) {
            [UILabel showMessage:[NSString stringWithFormat:@"您的输入超过限制"]];
        }

    
    }
    

}

-(void)submitbtnClick
{
    
    if ([self.nameTF.text isEqualToString:@""]||[self.idCardNumTF.text isEqualToString:@""]||[self.storeNameTF.text isEqualToString:@""]||[self.phoneNumTF.text isEqualToString:@""]||[self.areaLabel.text isEqualToString:@"选择所在省市区县"]||[self.streetLabel.text isEqualToString:@"选择所在街道或者乡镇"]||[self.detailAddressTF.text isEqualToString:@""]) {
        [UILabel showMessage:@"请填写完整信息"];
    }else if ([self validateIdentityCard:self.idCardNumTF.text] == NO){
        [UILabel showMessage:@"请填写正确的身份证号码"];
    }else if ([self validateMobile:self.phoneNumTF.text] == NO){
        [UILabel showMessage:@"请填写正确的手机号"];
    }else if (self.nameLength>12){
        [UILabel showMessage:@"您的输入超过限制"];
    
    }else if (self.storeNameLength>20){
        [UILabel showMessage:@"您的输入超过限制"];
    
    }else if (self.detailAddressLength>30){
        [UILabel showMessage:@"您的输入超过限制"];
    
    }else{
        NSDictionary *addressDic;
        if (self.countyID == nil|| [self.countyID isEqualToString:@""]) {
            addressDic = @{@"province":self.provinceID,@"city":self.cityID,@"town":self.townID,@"details":self.detailAddressTF.text};
        }else{
            addressDic = @{@"province":self.provinceID,@"city":self.cityID,@"county":self.countyID,@"town":self.townID,@"details":self.detailAddressTF.text};
        }
        NSDictionary *params = @{@"name":self.nameTF.text,@"IDNo":self.idCardNumTF.text,@"companyName":self.storeNameTF.text,@"companyAddress":addressDic,@"phone":self.phoneNumTF.text,@"user-agent":@"IOS-v2.0"};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:KRscInfoFill parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *resultDic;
            if ([resultObj isKindOfClass:[NSDictionary class]]) {
                resultDic = (NSDictionary *)resultObj;
            }
            if ([resultObj[@"code"] integerValue] == 1000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshIdentifyState" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"----%@",error);
        }];
    }

}
// 身份证号码验证
-(BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - 正则表达式判断手机号格式
- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


-(void)addressBtnCick:(UIButton *)button
{
    [self.nameTF resignFirstResponder];
    [self.idCardNumTF resignFirstResponder];
    [self.storeNameTF resignFirstResponder];
    [self.phoneNumTF resignFirstResponder];
    [self.detailAddressTF resignFirstResponder];
    if (button.tag == 1000) {
        [self.townManagerView hide];
        [self.addressManagerView show];
        __weak __typeof(&*self)weakSelf = self;
        self.addressManagerView.com = ^(NSString *province,NSString *city,NSString *county,NSString *provinceID,NSString *cityId,NSString *countyId,NSString *province_id,NSString *city_id,NSString *county_id){
            if (county == nil||[county isEqualToString:@""]) {
                weakSelf.areaLabel.text = [NSString stringWithFormat:@"%@%@",province,city];
                
            }else{
                weakSelf.areaLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
            }
            weakSelf.areaLabel.textColor = R_G_B_16(0x646464);
            
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

        
    }else{
        if ([self.areaLabel.text isEqualToString:@"选择所在省市区县"]) {
            [UILabel showMessage:@"请选择地区"];
        }else{
            [self.addressManagerView hide];
            [self.townManagerView show];
            __weak __typeof(&*self)weakSelf = self;
            self.townManagerView.com = ^(NSString *townName,NSString *townId,NSString *town_id){
                weakSelf.streetLabel.text = [NSString stringWithFormat:@"%@",townName];
                weakSelf.townID = town_id;
                weakSelf.streetLabel.textColor = R_G_B_16(0x646464);
            };
        }
    }
}

-(void)setNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (_notWriteIdentifyInfo) {
        titleLabel.text = @"服务站认证";
    }else{
        titleLabel.text = @"查看服务站信息";
    }
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
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

@end
