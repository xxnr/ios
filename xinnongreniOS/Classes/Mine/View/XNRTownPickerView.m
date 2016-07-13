//
//  XNRTownPickerView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/16.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRTownPickerView.h"
#import "XNRTownModel.h"

@interface XNRTownPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,weak) UIPickerView *pickerView;
@property (nonatomic ,strong) NSMutableArray *townArray;

@property (nonatomic ,copy) NSString *town;
@property (nonatomic ,copy) NSString *townID;
@property (nonatomic ,copy) NSString *town_Id;


@property (nonatomic ,weak) UIButton *leftBtn;
@property (nonatomic ,weak) UIButton *rightBtn;


@end

@implementation XNRTownPickerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createBtn];
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(600));
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,PX_TO_PT(70), ScreenWidth, PX_TO_PT(500))];
        pickView.delegate = self;
        pickView.dataSource = self;
        self.pickerView = pickView;
        [self addSubview:pickView];
        _townArray = [NSMutableArray array];
        [self getTownData];
        
    }
    return self;
}

-(void)getTownData{
    [_townArray removeAllObjects];
    if (![KSHttpRequest isBlankString:[DataCenter account].countyID]) {
        [KSHttpRequest post:KGetAreaTown parameters:@{@"countyId":[DataCenter account].countyID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                NSDictionary *dict = result[@"datas"];
                NSArray *Tarr = dict[@"rows"];
                for (NSDictionary *dicts in Tarr) {
                    XNRTownModel *model = [[XNRTownModel alloc] init];
                    [model setValuesForKeysWithDictionary:dicts];
                    [_townArray addObject:model];
                }
            }
            if (_townArray.count>0) {
                XNRTownModel *model = _townArray[0];
                self.town = model.name;
                self.townID = model.ID;
                self.town_Id = model._id;
            }
           
            [self.pickerView reloadAllComponents];

        } failure:^(NSError *error) {
            
        }];
    }else{
        [KSHttpRequest post:KGetAreaTown parameters:@{@"cityId":[DataCenter account].cityID?[DataCenter account].cityID:@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                NSDictionary *dict = result[@"datas"];
                NSArray *Tarr = dict[@"rows"];
                for (NSDictionary *dicts in Tarr) {
                    XNRTownModel *model = [[XNRTownModel alloc] init];
                    [model setValuesForKeysWithDictionary:dicts];
                    [_townArray addObject:model];
                }
            }
            if (_townArray.count>0) {
                XNRTownModel *model = _townArray[0];
                self.town = model.name;
                self.townID = model.ID;
                self.town_Id = model._id;
            }
           
        [self.pickerView reloadAllComponents];
        } failure:^(NSError *error) {
            
        }];
    }
    
}

-(void)createBtn{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(70))];
    bgView.backgroundColor = R_G_B_16(0xf4f4f4);
    [self addSubview:bgView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, ScreenWidth/4, PX_TO_PT(70));
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftBtn;
    [bgView addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake((ScreenWidth/4)*3,0, ScreenWidth/4, PX_TO_PT(70));
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:R_G_B_16(0x323232) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    [bgView addSubview:rightBtn];
    
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(70)*i, ScreenWidth, 1)];
        lineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [bgView addSubview:lineView];
    }
    
}
-(void)BtnClick:(UIButton *)button{
    
    if ([self.delegate performSelector:@selector(XNRTownPickerViewBtnClick:)]) {
        XNRTownPickerViewType type;
        if (button == self.leftBtn) {
            type = eLeftBtnType;
        }else{
            type = eRightBtnType;
            self.com(self.town,self.townID,self.town_Id);
        }
        [self.delegate XNRTownPickerViewBtnClick:type];
      }
}

#pragma mark - UIPickerViewDataSource
// 告诉系统有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// 告诉系统有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _townArray.count;
}
//告诉每一行显示什么内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    XNRTownModel *town = _townArray[row];
    return town.name;
    
}

// 监听pickerView的选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_townArray.count>0) {
        XNRTownModel *town  = _townArray[row];
        self.town = town.name;
        self.townID = town.ID;
        self.town_Id = town._id;
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
