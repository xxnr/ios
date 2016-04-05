//
//  XNRTownManagerView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/25.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRTownManagerView.h"
#import "XNRTownModel.h"

@interface XNRTownManagerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,weak) UIPickerView *pickerView;
@property (nonatomic ,strong) NSMutableArray *townArray;

@property (nonatomic ,weak) UIButton *leftBtn;
@property (nonatomic ,weak) UIButton *rightBtn;

@property (nonatomic ,copy) XNRTownManagerViewBlock com;


@end

@implementation XNRTownManagerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createBtn];
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(500));
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,PX_TO_PT(50), ScreenWidth, PX_TO_PT(300))];
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
    if (![KSHttpRequest isBlankString:[DataCenter account].cityID]) {
        [KSHttpRequest post:KGetAreaTown parameters:@{@"cityId":[DataCenter account].cityID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                NSDictionary *dict = result[@"datas"];
                NSArray *Tarr = dict[@"rows"];
                for (NSDictionary *dicts in Tarr) {
                    XNRTownModel *model = [[XNRTownModel alloc] init];
                    [model setValuesForKeysWithDictionary:dicts];
                    [_townArray addObject:model];
                }
            }
            [self.pickerView reloadAllComponents];
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        [KSHttpRequest post:KGetAreaTown parameters:@{@"countyId":[DataCenter account].countyID?[DataCenter account].countyID:@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
            if ([result[@"code"] integerValue] == 1000) {
                NSDictionary *dict = result[@"datas"];
                NSArray *Tarr = dict[@"rows"];
                for (NSDictionary *dicts in Tarr) {
                    XNRTownModel *model = [[XNRTownModel alloc] init];
                    [model setValuesForKeysWithDictionary:dicts];
                    [_townArray addObject:model];
                }
            }
            
            [self.pickerView reloadAllComponents];
        } failure:^(NSError *error) {
            
        }];
    }
    
}

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
    
    if ([self.delegate performSelector:@selector(XNRTownManagerViewBtnClick:)]) {
        XNRTownManagerViewType type;
        if (button == self.leftBtn) {
            type = eLeftBtnType;
        }else{
            type = eRightBtnType;
        }
        [self.delegate XNRTownManagerViewBtnClick:type];
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
        NSString *name = town.name;
        NSString *townID = town._id;
        self.townLabel.text = name;
        self.com(name,townID);
        
        NSLog(@"---%@",name);
    }
    
}


#pragma  mark - function

- (void)showWith:(XNRTownManagerViewBlock)com{
    self.com = com;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, ScreenHeight-PX_TO_PT(500), ScreenWidth, PX_TO_PT(500));
        
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
