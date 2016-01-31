//
//  XNRAddressManageView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/25.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRAddressManageView.h"
#import "XNRProviceModel.h"
#import "XNRCityModel.h"
#import "XNRCountyModel.h"

@interface XNRAddressManageView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,weak) UIPickerView *pickerView;
@property (nonatomic ,weak) UIButton *leftBtn;
@property (nonatomic ,weak) UIButton *rightBtn;

@property (nonatomic ,weak) UIView *maskView;

@property (nonatomic ,strong) NSMutableArray *provinceArr;

@property (nonatomic ,strong) NSMutableArray *cityArr;

@property (nonatomic ,strong) NSMutableArray *countyArr;

@property (nonatomic ,copy) XNRAddressManageViewBlock com;
@end

@implementation XNRAddressManageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBtn];
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(500));
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,PX_TO_PT(50), ScreenWidth, PX_TO_PT(300))];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        self.pickerView = pickerView;
        [self addSubview:pickerView];
        
        _provinceArr = [NSMutableArray array];
        _cityArr = [NSMutableArray array];
        _countyArr = [NSMutableArray array];
        
        
        [self getPData];
        
    }
    return self;
    
}
#pragma mark - 创建按钮
-(void)createBtn{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, ScreenWidth/4, PX_TO_PT(50));
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:R_G_B_16(0x646464) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftBtn;
    [self addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake((ScreenWidth/4)*3,0, ScreenWidth/4, PX_TO_PT(50));
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:R_G_B_16(0x646464) forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    [self addSubview:rightBtn];
    
}
-(void)BtnClick:(UIButton *)button{
    if ([self.delegate performSelector:@selector(XNRAddressManageViewBtnClick:)]) {
        XNRAddressManageViewType type;
        if (button == self.leftBtn) {
            type = leftBtnType;
        }else{
            type = rightBtnType;
        }
        [self.delegate XNRAddressManageViewBtnClick:type];
    }
}
#pragma mark - 获得省得数据
-(void)getPData{
    [KSHttpRequest post:KGetAreaList parameters:nil success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"datas"];
            NSArray *CArr = dict[@"rows"];
            for (NSDictionary *Pdict in CArr) {
                XNRProviceModel *province = [[XNRProviceModel alloc] init];
                [province setValuesForKeysWithDictionary:Pdict];
                [_provinceArr addObject:province];
            }
        }
        [self.pickerView reloadComponent:0];
    } failure:^(NSError *error) {
        
    }];

}

- (void)getCityDataWith:(NSString *)provinceId {
    [KSHttpRequest post:KGetBusinessByAreaId parameters:@{@"areaId":@"58054e5ba551445"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"datas"];
            NSArray *CArr = dict[@"rows"];
            int i = 0;
            for (NSDictionary *Cdict in CArr) {
                XNRCityModel *city = [[XNRCityModel alloc] init];
                [city setValuesForKeysWithDictionary:Cdict];
                [_cityArr addObject:city];
                if (i==0) {
                    [self getCountyDataWith:city.ID];
                }
                i++;
            }
        }
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)getCountyDataWith:(NSString *)cityId {
    [KSHttpRequest post:KGetBuildByBusiness parameters:@{@"businessId":cityId} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dict = result[@"datas"];
            NSArray *CArr = dict[@"rows"];
            for (NSDictionary *Cdict in CArr) {
                XNRCountyModel *county = [[XNRCountyModel alloc] init];
                [county setValuesForKeysWithDictionary:Cdict];
                [_countyArr addObject:county];
            }
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
        return _countyArr.count;
    }
}
// 告诉系统每一行显示什么内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == component) {// 省
        XNRProviceModel *province = _provinceArr[row];
        return province.name;
    }else if (1 == component){// 市
        XNRCityModel *city = _cityArr[row];
        return city.name;
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
    // 判断是否修改了第0列
    NSString *provinceName;
    NSString *provinceId;
    if (0 == component) {
        NSInteger selelctIndex = [self.pickerView selectedRowInComponent:0];
        XNRProviceModel *province = _provinceArr[selelctIndex];
        [_cityArr removeAllObjects];
        [_countyArr removeAllObjects];
        [self getCityDataWith:province.ID];
        [self.pickerView reloadAllComponents];
        self.provinceLabel.text = provinceName;
        provinceName = province.name;
        provinceId = province.ID;
        
    }
    NSString *cityName;
    NSString *cityId;
    if (1 == component){
        // 获取第一列选中的行
        [_countyArr removeAllObjects];
        NSInteger selectIndex = [self.pickerView selectedRowInComponent:1];
        // 获取第一列选中的行对应的城市
        XNRCityModel *city = _cityArr[selectIndex];
        cityName = city.name;
        self.cityLabel.text = cityName;
        cityId = city.ID;
        // 获取对应的县
        [self getCountyDataWith:city.ID];
        [self.pickerView reloadComponent:2];
    }
    NSString *countyName;
    NSString *countyId;
    if (2 == component) {
        NSInteger selectIndex = [self.pickerView selectedRowInComponent:2];
        if (_countyArr.count>0) {
            XNRCountyModel *county = _countyArr[selectIndex];
            countyName = county.name;
            self.countyLabel.text = countyName;
            countyId = county.ID;
            [self.pickerView reloadAllComponents];
        }
        
    }
    NSString *address = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,countyName];
    NSLog(@"%@====",address);
    if (self.com) {
        self.com(provinceName,cityName,countyName,provinceId?provinceId:@"58054e5ba551445",cityId,countyId);
    }
}

#pragma  mark - function

- (void)showWith:(XNRAddressManageViewBlock)com{
    
    self.com = com;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, ScreenHeight-PX_TO_PT(500), ScreenWidth, PX_TO_PT(500));
        [self getCityDataWith:@"58054e5ba551445"];
        
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(500));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
