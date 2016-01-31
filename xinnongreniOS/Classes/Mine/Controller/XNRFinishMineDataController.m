//
//  XNRFinishMineDataController.m
//  xinnongreniOS
//
//  Created by xxnr on 16/1/21.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRFinishMineDataController.h"
#import "XNRAddressManageView.h"
#import "XNRTownManagerView.h"
#import "XNRTypeView.h"

#define sexBtn  1000
@interface XNRFinishMineDataController()<XNRAddressManageViewBtnDelegate,XNRTownManagerViewBtnDelegate,UITextFieldDelegate,XNRTypeViewBtnDelegate>

@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UIButton *addressBtn;
@property (nonatomic ,weak) XNRAddressManageView *addressManagerView;
@property (nonatomic ,weak) XNRTownManagerView *townManagerView;
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
@property (nonatomic ,weak) UITextField *addressTF;
@property (nonatomic ,weak) UITextField *streetTF;
@property (nonatomic ,weak) UITextField *userTypeTF;

@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,copy) UIButton *tempBtn;
@end

@implementation XNRFinishMineDataController
#pragma mark - 地区
-(XNRAddressManageView *)addressManagerView{
    if (!_addressManagerView) {
        XNRAddressManageView *addressManagerView = [[XNRAddressManageView alloc] init];
        addressManagerView.delegate = self;
        self.addressManagerView = addressManagerView;
        [self.view addSubview:addressManagerView];
    }
    return _addressManagerView;
    
}

-(void)XNRAddressManageViewBtnClick:(XNRAddressManageViewType)type
{
    if (type == leftBtnType) {
        [self.addressManagerView hide];
    }else if (type == rightBtnType){
        [self.addressManagerView hide];
        if (self.county) {
            self.addressTF.text = [NSString stringWithFormat:@"%@%@%@",@"河南",self.city,self.county];
//            [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@",@"河南",self.city,self.county] forState:UIControlStateNormal];
            
        }else{
            if (self.city) {
                self.addressTF.text = [NSString stringWithFormat:@"%@%@",@"河南",self.city];

            }else{
                self.addressTF.text = @"";
            }
//            [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@",@"河南",self.city] forState:UIControlStateNormal];
        }
    }

    
}

#pragma mark - 街道

-(XNRTownManagerView *)townManagerView{
    if (!_townManagerView) {
        XNRTownManagerView *townManagerView = [[XNRTownManagerView alloc] init];
        townManagerView.delegate = self;
        self.townManagerView = townManagerView;
        [self.view addSubview:townManagerView];
    }
    return _townManagerView;
}


-(void)XNRTownManagerViewBtnClick:(XNRTownManagerViewType)type
{
    if (type == LeftBtnType) {
        [self.townManagerView hide];
    }else if (type == RightBtnType){
        [self.townManagerView hide];

        if (self.towns) {
            self.streetTF.text = [NSString stringWithFormat:@"%@",self.towns];
        }
    
    }
    
    
}

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
        self.userTypeTF.text = [NSString stringWithFormat:@"%@",self.typeName];
        
        }
}

#pragma mark - 键盘回收

-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return YES;
}




-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 导航
    [self createNavigation];
    
    [self createTopView];
    
    [self createBottomView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(keyboardWillBeHidden:)
//     
//                                                 name:UIKeyboardWillHideNotification object:nil];
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
    banaerLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:banaerLabel];
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:banaerLabel.text];
    NSDictionary *depositStr=@{
                               
                               NSForegroundColorAttributeName:R_G_B_16(0xff9000),
                               NSFontAttributeName:[UIFont systemFontOfSize:20]
                               
                               };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(7,3)];
    
    [banaerLabel setAttributedText:AttributedStringDeposit];
    
    
    NSArray *titleArray = @[@"姓名",@"性别",@"地区",@"街道",@"类型"];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(98)+i*PX_TO_PT(98), PX_TO_PT(100), PX_TO_PT(98))];
        titleLabel.textColor = R_G_B_16(0x323232);
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = titleArray[i];
        self.titleLabel = titleLabel;
        [self.view addSubview:titleLabel];
    }

    // 姓名
    UITextField *nameTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), PX_TO_PT(98), ScreenWidth, PX_TO_PT(98))];
    nameTf.textAlignment = NSTextAlignmentLeft;
    nameTf.placeholder = @"请填写真实姓名";
    nameTf.textColor = R_G_B_16(0x323232);
    nameTf.font = [UIFont systemFontOfSize:16];
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
    manLabel.font = [UIFont systemFontOfSize:16];
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
    womenLabel.font = [UIFont systemFontOfSize:16];
    womenLabel.text = @"女";
    [self.view addSubview:womenLabel];
    
    
    // 地区
    UITextField *addressTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(manLabel.frame), ScreenWidth, PX_TO_PT(98))];
    addressTF.placeholder = @"选择所在的省市区";
    addressTF.textColor = R_G_B_16(0x323232);
    addressTF.font = [UIFont systemFontOfSize:16];
    addressTF.tag = 1000;
    addressTF.delegate = self;
    addressTF.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.addressTF = addressTF;
    [self.view addSubview:addressTF];
    
    // 街道
    UITextField *streetTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(addressTF.frame), ScreenWidth, PX_TO_PT(98))];
    streetTF.placeholder = @"选择所在街道或乡镇";
    streetTF.tag = 1001;
    streetTF.delegate = self;
    streetTF.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.streetTF = streetTF;
    [self.view addSubview:streetTF];
    
    // 用户类型
    UITextField *userTypeTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(streetTF.frame), ScreenWidth, PX_TO_PT(98))];
    userTypeTF.placeholder = @"选择用户类型";
    userTypeTF.tag = 1002;
    userTypeTF.delegate = self;
    userTypeTF.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.userTypeTF = userTypeTF;
    [self.view addSubview:userTypeTF];

    
    for (int i = 1; i<7; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(98)*i, ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [self.view addSubview:lineView];
    }
    
}

#pragma mark --UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 1000) {
        [self.townManagerView hide];
        [self.typeView hide];
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
        [self.typeView hide];
        if (self.addressTF.text.length>0) {
            __weak __typeof(&*self)weakSelf = self;
            [self.townManagerView showWith:^(NSString *townName, NSString *townId) {
                weakSelf.townID = townId;
                weakSelf.towns = townName;
            }];

        }
    }
    
    if (textField.tag == 1002) {
        [self.addressManagerView hide];
        [self.townManagerView hide];
        __weak __typeof(&*self)weakSelf = self;
        [self.typeView showWith:^(NSString *typeName, NSString *typeNum) {
            weakSelf.typeName  = typeName;
            weakSelf.typeNum = typeNum;
            
        }];

    }
    
    return YES;
}

#pragma mark - 性别
-(void)selelctedBtnClick:(UIButton *)button
{
    _tempBtn.selected = NO;
    button.selected = YES;
    _tempBtn = button;
    
    if (button.tag == sexBtn + 1) {
        self.sex = @"flase";
        
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
    jumpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [jumpBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(jumpBtn.frame) + PX_TO_PT(32), ScreenHeight-PX_TO_PT(88)-64-PX_TO_PT(32), ScreenWidth-PX_TO_PT(256), PX_TO_PT(88))];
    saveBtn.backgroundColor = R_G_B_16(0x00b38a);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 5.0;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [saveBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];

}

-(void)saveBtn {
    if ([self.addressTF.text isEqualToString:@""] || [self.streetTF.text isEqualToString:@""] || [self.userTypeTF.text isEqualToString:@""] || [self.nameTf.text isEqualToString:@""]) {
        
        [UILabel showMessage:@"请完善信息"];
    }else{
//        NSDictionary *param = @{@"provinceId":self.provinceID?self.provinceID:@"58054e5ba551445",@"cityId":self.cityID?self.cityID:@"",@"countyId":self.countyID?self.countyID:@""};
//        NSDictionary *params = @{@"userId":[DataCenter account].userid,@"userName":self.nameTf.text,@"sex":self.sex,@"type":self.typeNum,@"address":param};
//        [KSHttpRequest post:KUserModify parameters:params success:^(id result) {
//            if ([result[@"code"] integerValue] == 1000) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
//                
//            }
//            
//        } failure:^(NSError *error) {
//            
//        }];
        NSDictionary *addressDict = @{@"provinceId":@"58054e5ba551445",@"cityId":self.cityID?self.cityID:@"",@"countyId":self.countyID?self.countyID:@"",@"townId":self.townID?self.townID:@""};
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"IOS-v2.0" forKey:@"user-agent"];
        [dic setObject:[DataCenter account].token forKey:@"token"];
        [dic setObject:[DataCenter account].userid forKey:@"userId"];
        [dic setObject:addressDict forKey:@"address"];
        [dic setObject:self.nameTf.text forKey:@"userName"];
        [dic setObject:self.sex forKey:@"sex"];
        [dic setObject:self.typeNum forKey:@"type"];
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
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"完善个人资料";
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 键盘躲避

-(void)viewDidAppear:(BOOL)animated{
    
    
    
    [super viewDidAppear:animated];
    
    
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        
        
        TFModel *tfm1=[TFModel modelWithTextFiled:self.nameTf inputView:nil name:@"" insetBottom:0];
        
//        TFModel *tfm2=[TFModel modelWithTextFiled:self.userTypeTF inputView:nil name:@"" insetBottom:0];
        
        return @[tfm1];
        
        
        
    }];
    
}



-(void)viewDidDisappear:(BOOL)animated{
    
    
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
    
    
    
}

//消失时回收键盘

- (void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.nameTf resignFirstResponder];
    
//    [self.userTypeTF resignFirstResponder];
    
}


@end
