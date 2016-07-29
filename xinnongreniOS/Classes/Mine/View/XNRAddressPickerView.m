//
//  XNRAddressPickerView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/14.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRAddressPickerView.h"
#import "XNRProviceModel.h"
#import "XNRCityModel.h"
#import "XNRCountyModel.h"

@interface XNRAddressPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,weak) UIPickerView *pickerView;
@property (nonatomic ,weak) UIButton *leftBtn;
@property (nonatomic ,weak) UIButton *rightBtn;

@property (nonatomic ,strong) NSMutableArray *provinceArr;

@property (nonatomic ,strong) NSMutableArray *cityArr;

@property (nonatomic ,strong) NSMutableArray *countyArr;

@property (nonatomic ,copy) NSString *province;

@property (nonatomic ,copy) NSString *city;

@property (nonatomic ,copy) NSString *county;

@property (nonatomic ,copy) NSString *provinceID;
@property (nonatomic ,copy) NSString *cityID;
@property (nonatomic ,copy) NSString *countyID;

@property (nonatomic ,copy) NSString *province_Id;
@property (nonatomic ,copy) NSString *city_Id;
@property (nonatomic ,copy) NSString *county_Id;


@end

@implementation XNRAddressPickerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self) {
        [self createBtn];
         [self createPickView];
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(600));
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        _provinceArr = [NSMutableArray array];
        _cityArr = [NSMutableArray array];
        _countyArr = [NSMutableArray array];
       //  获得省的数据
        [self getProvinceData];
    }
    return self;
}

-(void)createBtn
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(70))];
    bgView.backgroundColor = R_G_B_16(0xf4f4f4);
    [self addSubview:bgView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, ScreenWidth/4, PX_TO_PT(70));
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:R_G_B_16(0x646464) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftBtn;
    [bgView addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake((ScreenWidth/4)*3,0, ScreenWidth/4, PX_TO_PT(70));
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:R_G_B_16(0x646464) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    [bgView addSubview:rightBtn];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    topView.backgroundColor = R_G_B_16(0xe0e0e0);
    [bgView addSubview:topView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(70), ScreenWidth, 1)];
    lineView.backgroundColor = R_G_B_16(0xe0e0e0);
    [bgView addSubview:lineView];
}

-(void)BtnClick:(UIButton *)button
{
    if ([self.delegate performSelector:@selector(XNRAddressPickerViewBtnClick:)]) {
        XNRAddressPickerViewType type;
        if (button == self.leftBtn) {
            type = leftBtnType;
            
        }else{
            
            type = rightBtnType;
            
            if (self.com) {
                self.com(self.province,self.city,self.county,self.provinceID,self.cityID,self.countyID,self.province_Id,self.city_Id,self.county_Id);
            }
            
        }
        [self.delegate XNRAddressPickerViewBtnClick:type];
    }


}

-(void)createPickView
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,PX_TO_PT(50), ScreenWidth, PX_TO_PT(500))];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    [self addSubview:pickerView];
}

-(void)getProvinceData{
    [_provinceArr removeAllObjects];
    [KSHttpRequest post:KGetAreaList parameters:@{@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
                NSDictionary *dict = result[@"datas"];
                NSArray *CArr = dict[@"rows"];
                for (NSDictionary *Pdict in CArr) {
                    XNRProviceModel *province = [[XNRProviceModel alloc] init];
                    [province setValuesForKeysWithDictionary:Pdict];
                    [_provinceArr addObject:province];
                }
        }
        XNRProviceModel *province = _provinceArr[0];
        self.province = province.name;
        self.province_Id = province._id;
        self.provinceID = province.ID;
        [self getCityDataWith:province.ID];
        
        [self.pickerView reloadComponent:0];
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
    } failure:^(NSError *error) {
        
    }];

}

- (void)getCityDataWith:(NSString *)provinceId{
    [_cityArr removeAllObjects];
    [KSHttpRequest post:KGetBusinessByAreaId parameters:@{@"areaId":provinceId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"datas"];
            NSArray *CArr = dict[@"rows"];
            for (NSDictionary *Cdict in CArr) {
                XNRCityModel *city = [[XNRCityModel alloc] init];
                [city setValuesForKeysWithDictionary:Cdict];
                [_cityArr addObject:city];
            }
        }
        XNRCityModel *city = _cityArr [0];
        self.city = city.name;
        self.city_Id = city._id;
        self.cityID = city.ID;
        [self getCountyDataWith:city.ID];
        
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        
    } failure:^(NSError *error) {
        
 }];

}

- (void)getCountyDataWith:(NSString *)cityId{
    [_countyArr removeAllObjects];
    [KSHttpRequest post:KGetBuildByBusiness parameters:@{@"businessId":cityId?cityId:@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"datas"];
            NSArray *CArr = dict[@"rows"];
            for (NSDictionary *Cdict in CArr) {
                XNRCountyModel *county = [[XNRCountyModel alloc] init];
                [county setValuesForKeysWithDictionary:Cdict];
                [_countyArr addObject:county];
            }
        }
        if (_countyArr.count>0) {
            XNRCountyModel *county = _countyArr[0];
            self.county = county.name;
            self.countyID = county.ID;
            self.county_Id = county._id;
 
        }
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UIPickerViewDataSource
// 告诉系统有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
// 告诉系统有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (0 == component) {// 省份
        return _provinceArr.count;
    }else if (1 == component){// 城市列
        return _cityArr.count;
    }else{// 县列表
        if (_countyArr.count>0) {
            return _countyArr.count;
        }else{
            return 0;
        }
    }
}
#pragma mark - UIPickerViewDelegate
// 告诉系统每一行显示什么内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == component) {// 省
        if (_provinceArr.count>0) {
            XNRProviceModel *province = _provinceArr[row];
            return province.name;
        }else{
            return nil;
        }
       }else if (1 == component){// 市
           if (_cityArr.count>0) {
               XNRCityModel *city = _cityArr[row];
               return city.name;
           }else{
               return nil;
           }
  
    }else{// 县
        if (_countyArr.count>0) {
            XNRCountyModel *county = _countyArr[row];
            return county.name;
        }else{
            return nil;
        }
    }
}
// 监听pickerView的选中
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component) {
        XNRProviceModel *province = _provinceArr[row];
        [self getProvinceData];
        self.province = province.name;
        self.province_Id = province._id;
        self.provinceID = province.ID;
        [self getCityDataWith:province.ID];
        
        if (_cityArr.count>0) {
            if (_cityArr.count>0) {
                XNRCityModel *city = _cityArr [0];
                [self getCountyDataWith:city.ID];
                self.city = city.name;
                self.city_Id = city._id;
                self.cityID = city.ID;

            }
        }

        if (_countyArr.count>0) {
            XNRCountyModel *county = _countyArr[0];
            self.county = county.name;
            self.county_Id = county._id;
            self.countyID = county.ID;


        }
        
        NSLog(@"+++%@====%@+++%@",province.name,self.city,self.county);

    }
    if (1 == component){
        self.county = @"";
        self.countyID = @"";
        self.county_Id = @"";
        
        // 获取第一列选中的行对应的城市
        if (_cityArr.count>0) {
            XNRCityModel *city = _cityArr[row];
            // 获取对应的县
            [self getCountyDataWith:city.ID];
            self.city = city.name;
            self.city_Id = city._id;
            self.cityID = city.ID;
            
    }
        
       
        if (_countyArr.count>0) {
            XNRCountyModel *county = [_countyArr objectAtIndex:0];
            self.county = county.name;
            self.county_Id = county._id;
            self.countyID = county.ID;

        }
        
    
    }
    if (2 == component) {
        if (_countyArr.count>0) {
            XNRCountyModel *county = _countyArr[row];
            self.county = county.name;
            self.county_Id = county._id;
            self.countyID = county.ID;

            
        }
       
        
        
    }
}

#pragma  mark - function

- (void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, ScreenHeight-PX_TO_PT(600), ScreenWidth, PX_TO_PT(600));
        
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(600));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
