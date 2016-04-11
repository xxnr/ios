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

@property (nonatomic ,weak) UIButton *streetBtn;
@property (nonatomic ,weak) UILabel *strLabel;
@property (nonatomic ,weak) UILabel *streetLabel;

@property (nonatomic ,copy) NSString *provinceID;
@property (nonatomic ,copy) NSString *cityID;
@property (nonatomic ,copy) NSString *countyID;
@property (nonatomic ,copy) NSString *townID;

@property (nonatomic ,weak) UIButton *saveAddressBtn;


@end

@implementation XNRMobAddress
#pragma mark - 地区选择器
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

-(void)XNRAddressPickerViewBtnClick:(XNRAddressPickerViewType)type
{
    if (type == leftBtnType) {
        [self.addressPickerView hide];
        
    }else if (type == rightBtnType){
        self.streetLabel.text = @"";
        [self.addressPickerView hide];
    }
}

#pragma mark - 街道选择器

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

-(void)XNRTownPickerViewBtnClick:(XNRTownPickerViewType)type
{
    if (type == eLeftBtnType) {
        [self.townPickerView hide];
    }else{
        [self.townPickerView hide];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self createNav];
    [self createView];
}

#pragma mark - 街道，地区
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
    areaLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    self.areaLabel = areaLabel;
    [addressBtn addSubview:areaLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.areaLabel.frame) + PX_TO_PT(32), 0, ScreenWidth-CGRectGetMaxX(self.areaLabel.frame) + PX_TO_PT(32), PX_TO_PT(98))];
    addressLabel.textColor = R_G_B_16(0x909090);
    addressLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    if ([DataCenter account].province) {
        
        if ([DataCenter account].county) {
             addressLabel.text = [NSString stringWithFormat:@"%@%@%@",[DataCenter account].province,[DataCenter account].city,[DataCenter account].county];
        }else{
             addressLabel.text = [NSString stringWithFormat:@"%@%@",[DataCenter account].province,[DataCenter account].city];
        }
       
    }else{
        addressLabel.text = @"选择所在省市区";
        self.streetBtn.enabled = NO;
    }
    self.addressLabel = addressLabel;
    [addressBtn addSubview:addressLabel];
    
    // 街道
    UIButton *streetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    streetBtn.frame = CGRectMake(0, CGRectGetMaxY(self.addressBtn.frame), ScreenWidth, PX_TO_PT(98));
    streetBtn.backgroundColor = [UIColor whiteColor];
    [streetBtn addTarget:self action:@selector(streetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.streetBtn = streetBtn;
    [bgView addSubview:streetBtn];
    
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, PX_TO_PT(80), PX_TO_PT(98))];
    strLabel.textColor = R_G_B_16(0x323232);
    strLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    strLabel.text = @"街道";
    self.strLabel = strLabel;
    [streetBtn addSubview:strLabel];
    
    UILabel *streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.strLabel.frame) + PX_TO_PT(32), 0, ScreenWidth-CGRectGetMaxX(self.strLabel.frame) + PX_TO_PT(32), PX_TO_PT(98))];
    streetLabel.textColor = R_G_B_16(0x909090);
    streetLabel.font = [UIFont systemFontOfSize:PX_TO_PT(30)];
    if ([DataCenter account].town) {
        streetLabel.text = [DataCenter account].town;
    }else{
        streetLabel.text = @"选择所在街道或乡镇";

    }
    self.streetLabel = streetLabel;
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
    self.saveAddressBtn = saveAddressBtn;
    [self.view addSubview:saveAddressBtn];
    
}
// 地区按钮点击
-(void)addressBtnClick{
    [self.townPickerView hide];
    [self.addressPickerView show];
    __weak __typeof(&*self)weakSelf = self;
    self.addressPickerView.com = ^(NSString *province,NSString *city,NSString *county,NSString *provinceID,NSString *cityId,NSString *countyId,NSString *province_id,NSString *city_id,NSString *county_id){
        
        if (county == nil || [county isEqualToString:@""]) {
            weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@%@",province,city];

        }else{
            weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];

        }
        
        weakSelf.provinceID = provinceID;
        weakSelf.cityID = cityId;
        weakSelf.countyID = countyId;
        // 保存一下省，市，县的地址和ID
        UserInfo *info = [DataCenter account];
        info.provinceID = provinceID;
        info.cityID = cityId;
        info.countyID = countyId;
        
        info.province = province;
        info.city = city;
        info.county = county;
        [DataCenter saveAccount:info];
    };

}
// 街道按钮点击
-(void)streetBtnClick{
    
    [self.addressPickerView hide];
    [self.townPickerView show];
    
    __weak __typeof(&*self)weakSelf = self;

    self.townPickerView.com = ^(NSString *townName,NSString *townId,NSString *town_id){
        
        weakSelf.streetLabel.text = [NSString stringWithFormat:@"%@",townName];
        weakSelf.townID = townId;
        // 保存一下镇的ID
        UserInfo *info = [DataCenter account];
        info.townID = townId;
        info.town = townName;
        [DataCenter saveAccount:info];
    };
}
// 保存地址按钮点击
-(void)saveAddressBtnClick{
    [self.addressPickerView hide];
    if ([self.addressLabel.text isEqualToString:@""]||[self.streetLabel.text isEqualToString:@""]) {
        [UILabel showMessage:@"地址不能为空"];
    }else{
        self.saveAddressBtn.enabled = YES;
        NSDictionary *addressDict = @{@"provinceId":[DataCenter account].provinceID?[DataCenter account].provinceID:@"",@"cityId":[DataCenter account].cityID?[DataCenter account].cityID:@"",@"countyId":[DataCenter account].countyID?[DataCenter account].countyID:@"",@"townId":[DataCenter account].townID?[DataCenter account].townID:@""};
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
            
            
            self.com(self.addressLabel.text,self.streetLabel.text);
            
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"------%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    
    }
}

-(void)createNav{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(48)];
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
@end
