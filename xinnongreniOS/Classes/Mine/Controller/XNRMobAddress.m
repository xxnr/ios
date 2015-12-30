//
//  XNRMobAddress.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/11.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRMobAddress.h"
#import "XNRAddressPickerView.h"
#import "XNRTownPickerView.h"

@interface XNRMobAddress()<XNRAddressPickerViewBtnDelegate,NSURLConnectionDelegate,XNRTownPickerViewBtnDelegate>

@property (nonatomic, weak) XNRAddressPickerView *addressPickerView;
@property (nonatomic ,weak) XNRTownPickerView *townPickerView;

@property (nonatomic ,weak) UIView *bgView;

@property (nonatomic ,weak) UIButton *addressBtn;
@property (nonatomic ,weak) UILabel *areaLabel;
@property (nonatomic ,weak) UILabel *addressLabel;

@property (nonatomic ,weak) UILabel *provinceLabel;
@property (nonatomic ,weak) UILabel *cityLabel;
@property (nonatomic ,weak) UILabel *countyLabel;
@property (nonatomic ,weak) UILabel *townLabel;

@property (nonatomic ,copy) NSString *provinceID;
@property (nonatomic ,copy) NSString *cityID;
@property (nonatomic ,copy) NSString *countyID;
@property (nonatomic ,copy) NSString *townID;

@property (nonatomic ,weak) UIButton *streetBtn;
@property (nonatomic ,weak) UILabel *strLabel;
@property (nonatomic ,weak) UILabel *streetLabel;

@end

@implementation XNRMobAddress

-(XNRAddressPickerView *)addressPickerView
{
    if (_addressPickerView == nil) {
        XNRAddressPickerView *addressPickerView = [[XNRAddressPickerView alloc] init];
        self.addressPickerView = addressPickerView;
        addressPickerView.delegate = self;
        [self.view addSubview:addressPickerView];
    }
    return _addressPickerView;
}

-(XNRTownPickerView *)townPickerView
{
    if (_townPickerView == nil) {
        XNRTownPickerView *townPickerView = [[XNRTownPickerView alloc] init];
        self.townPickerView = townPickerView;
        townPickerView.delegate = self;
        [self.view addSubview:townPickerView];
    }
    return _townPickerView;

}

-(void)XNRAddressPickerViewBtnClick:(XNRAddressPickerViewType)type
{
    if (type == leftBtnType) {
        [self.addressPickerView hide];
        
    }else if (type == rightBtnType){
        [self.addressPickerView hide];
        NSDictionary *addressDict = @{@"provinceId":@"58054e5ba551445",@"cityId":self.cityID?self.cityID:@"",@"countyId":self.countyID?self.countyID:@""};
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"IOS-v2.0" forKey:@"user-agent"];
        [dic setObject:[DataCenter account].token forKey:@"token"];
        [dic setObject:[DataCenter account].userid forKey:@"userId"];
        [dic setObject:addressDict forKey:@"address"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:KUserModify parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UserInfo *info = [DataCenter account];
            info.province = self.provinceLabel.text;
            info.city = self.cityLabel.text;
            info.county = self.countyLabel.text;
            info.town = self.townLabel.text;
            [DataCenter saveAccount:info];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyAccount" object:nil];
            if (![KSHttpRequest isBlankString:[DataCenter account].county]) {
                self.countyLabel.text = [NSString stringWithFormat:@"%@",[DataCenter account].county];
            }
            NSLog(@"------%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];


    }

}

-(void)XNRTownPickerViewBtnClick:(XNRTownPickerViewType)type
{
    if (type == eLeftBtnType) {
        [self.townPickerView hide];
    }else{
        [self.townPickerView hide];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCounty:) name:@"changeCounty" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity:) name:@"changeCity" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)changeCity:(NSNotification *)notiObj{
    self.cityLabel.text = [NSString stringWithFormat:@"%@",notiObj.object];
}
- (void)changeCounty:(NSNotification *)notiObj {
    NSLog(@"-=-=-=-%@",notiObj);
        self.countyLabel.text = [NSString stringWithFormat:@"%@",notiObj.object];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self createNav];
    [self createView];
}

-(void)createNav{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"修改所在地区";
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

-(void)createView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(24), ScreenWidth, PX_TO_PT(98)*2)];
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    [self.view addSubview:bgView];
    
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(0, 0, ScreenWidth, PX_TO_PT(98));
    addressBtn.backgroundColor = [UIColor whiteColor];
    [addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.addressBtn = addressBtn;
    [bgView addSubview:addressBtn];
    
    
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, PX_TO_PT(80), PX_TO_PT(98))];
    areaLabel.text = @"地区";
    areaLabel.textColor = R_G_B_16(0x323232);
    areaLabel.font = XNRFont(15);
    self.areaLabel = areaLabel;
    [addressBtn addSubview:areaLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.areaLabel.frame) + PX_TO_PT(32), 0, ScreenWidth-CGRectGetMaxX(self.areaLabel.frame) + PX_TO_PT(32), PX_TO_PT(98))];
    addressLabel.text = @"选择所在省市区";
    addressLabel.textColor = R_G_B_16(0x909090);
    addressLabel.font = XNRFont(15);
    self.addressLabel = addressLabel;
    [addressBtn addSubview:addressLabel];
    // 省
    UILabel *provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.areaLabel.frame) + PX_TO_PT(32), 0, PX_TO_PT(100), PX_TO_PT(98))];
    provinceLabel.textColor = R_G_B_16(0x909090);
    provinceLabel.font = XNRFont(15);
    if (![KSHttpRequest isBlankString:[DataCenter account].province]) {
        provinceLabel.text = [NSString stringWithFormat:@"%@",[DataCenter account].province];
        addressLabel.hidden = YES;
    }
    self.provinceLabel = provinceLabel;
    [addressBtn addSubview:provinceLabel];
    // 市
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.provinceLabel.frame), 0, PX_TO_PT(120), PX_TO_PT(98))];
    cityLabel.textColor = R_G_B_16(0x909090);
    cityLabel.font = XNRFont(15);
    if (![KSHttpRequest isBlankString:[DataCenter account].city ]) {
        cityLabel.text = [NSString stringWithFormat:@"%@",[DataCenter account].city];
    }
    self.cityLabel = cityLabel;
    [addressBtn addSubview:cityLabel];
    // 县
    UILabel *countyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cityLabel.frame), 0, PX_TO_PT(180), PX_TO_PT(98))];
    countyLabel.textColor = R_G_B_16(0x909090);
    countyLabel.font = XNRFont(15);
    if (![KSHttpRequest isBlankString:[DataCenter account].county]) {
        countyLabel.text = [NSString stringWithFormat:@"%@",[DataCenter account].county];
    }
    self.countyLabel = countyLabel;
    [addressBtn addSubview:countyLabel];
    // 街道
    UIButton *streetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    streetBtn.frame = CGRectMake(0, CGRectGetMaxY(self.addressBtn.frame), ScreenWidth, PX_TO_PT(98));
    streetBtn.backgroundColor = [UIColor whiteColor];
    [streetBtn addTarget:self action:@selector(streetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.streetBtn = streetBtn;
    [bgView addSubview:streetBtn];
    
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, PX_TO_PT(80), PX_TO_PT(98))];
    strLabel.text = @"街道";
    strLabel.textColor = R_G_B_16(0x323232);
    strLabel.font = XNRFont(15);
    self.strLabel = strLabel;
    [streetBtn addSubview:strLabel];
    
    UILabel *streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.strLabel.frame) + PX_TO_PT(32), 0, ScreenWidth-CGRectGetMaxX(self.strLabel.frame) + PX_TO_PT(32), PX_TO_PT(98))];
    streetLabel.text = @"选择所在街道或乡镇";
    streetLabel.textColor = R_G_B_16(0x909090);
    streetLabel.font = XNRFont(15);
    self.streetLabel = streetLabel;
    
    UILabel *townLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.strLabel.frame) + PX_TO_PT(32), 0, ScreenWidth-CGRectGetMaxX(self.strLabel.frame) + PX_TO_PT(32), PX_TO_PT(98))];
    townLabel.textColor = R_G_B_16(0x646464);
    townLabel.font = XNRFont(15);
    self.townLabel = townLabel;
    if (![KSHttpRequest isBlankString:[DataCenter account].town]) {
        streetLabel.hidden = YES;
        townLabel.text = [NSString stringWithFormat:@"%@",[DataCenter account].town];
    }
    [streetBtn addSubview:townLabel];

    [streetBtn addSubview:streetLabel];
    for (int i = 0; i<3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*PX_TO_PT(98), ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [bgView addSubview:lineView];
    }
    
    UIButton *saveAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveAddressBtn.frame = CGRectMake(PX_TO_PT(32),CGRectGetMaxY(self.bgView.frame) + PX_TO_PT(90), ScreenWidth - PX_TO_PT(32)*2,PX_TO_PT(88));
    saveAddressBtn.layer.cornerRadius = 5.0;
    saveAddressBtn.layer.masksToBounds = YES;
    saveAddressBtn.backgroundColor = R_G_B_16(0x00b38a);
    [saveAddressBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveAddressBtn setTintColor:R_G_B_16(0xffffff)];
    [saveAddressBtn addTarget:self action:@selector(saveAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveAddressBtn];
    
}
// 地区
-(void)addressBtnClick{
    
    self.addressLabel.hidden = YES;
    __weak __typeof(&*self)weakSelf = self;

    [self.addressPickerView showWith:^(NSString *province, NSString *city, NSString *county, NSString *provinceID, NSString *cityId, NSString *countyId) {
        if (province) {
            weakSelf.provinceLabel.text = [NSString stringWithFormat:@"%@",province];
            weakSelf.provinceID = provinceID;
        }
        if (city) {
            weakSelf.cityLabel.text = [NSString stringWithFormat:@"%@",city];
            weakSelf.cityID = cityId;
        }
        if (county) {
            weakSelf.countyLabel.text = [NSString stringWithFormat:@"%@",county];
            weakSelf.countyID = countyId;
        }
        UserInfo *info = [DataCenter account];
        info.cityID = cityId;
        info.countyID = countyId;
        [DataCenter saveAccount:info];
        NSLog(@"====%@====%@",info.cityID,info.countyID);
    }];
}
// 街道
-(void)streetBtnClick{
    self.streetLabel.hidden = YES;
    [self.addressPickerView hide];
    __weak __typeof(&*self)weakSelf = self;
    [self.townPickerView showWith:^(NSString *townName,NSString *townId) {
        if (townName) {
            weakSelf.townLabel.text = townName;
            weakSelf.townID = townId;
        }else{
            [weakSelf.addressPickerView hide];
        }
    }];
    
}
// 保存
-(void)saveAddressBtnClick{
    [self.addressPickerView hide];
    NSDictionary *addressDict = @{@"provinceId":@"58054e5ba551445",@"cityId":self.cityID?self.cityID:@"",@"countyId":self.countyID?self.countyID:@"",@"townId":self.townID?self.townID:@""};
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"IOS-v2.0" forKey:@"user-agent"];
    [dic setObject:[DataCenter account].token forKey:@"token"];
    [dic setObject:[DataCenter account].userid forKey:@"userId"];
    [dic setObject:addressDict forKey:@"address"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型

    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
     [manager POST:KUserModify parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
         UserInfo *info = [DataCenter account];
         info.province = self.provinceLabel.text;
         info.city = self.cityLabel.text;
         info.county = self.countyLabel.text;
         info.town = self.townLabel.text;
         [DataCenter saveAccount:info];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyAccount" object:nil];
         [self.navigationController popViewControllerAnimated:YES];
         NSLog(@"------%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
    
}



@end
