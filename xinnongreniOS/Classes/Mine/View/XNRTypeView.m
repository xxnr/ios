//
//  XNRTypeView.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/12.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRTypeView.h"
@interface XNRTypeView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,weak) UIPickerView *pickerView;
@property (nonatomic, strong) NSDictionary *subDic;
@property (nonatomic ,strong) NSMutableArray *typeArray;
@property (nonatomic ,strong) NSMutableArray *numArray;

@property (nonatomic ,weak) UIButton *leftBtn;
@property (nonatomic ,weak) UIButton *rightBtn;

@property (nonatomic ,copy) XNRTypeViewBlock com;

@end
@implementation XNRTypeView

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
//        _typeArray = @[@"其它",@"种植大户",@"村级经销商",@"乡镇经销商",@"县级经销商"];
//        _numArray = @[@"1",@"2",@"3",@"4",@"5"];
        _typeArray = [[NSMutableArray alloc] init];
        self.subDic = [NSMutableDictionary dictionary];
        [self getData];
        
    }
    return self;
}

-(void)getData
{
    [KSHttpRequest get:Kusertypes parameters:nil success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            
            NSDictionary *subDic = result[@"data"];
            
            for (id key in subDic) {
                [self.subDic setValue:[NSString stringWithFormat:@"%@",key] forKey:[subDic objectForKey:key]];
                [_typeArray addObject:[subDic objectForKey:key]];
            }
        }
        
        [self.pickerView reloadAllComponents];
    } failure:^(NSError *error) {
        [UILabel showMessage:@"网络加载失败"];
    }];

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
    
    if ([self.delegate performSelector:@selector(XNRTypeViewBtnClick:)]) {
        XNRTypeViewType type;
        if (button == self.leftBtn) {
            type = LeftBtnType;
        }else{
            type = RightBtnType;
        }
        [self.delegate XNRTypeViewBtnClick:type];
}


}
#pragma mark - UIPickerViewDataSource
// 告诉系统有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// 告诉系统有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _typeArray.count;

}
//告诉每一行显示什么内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _typeArray[row];
    
}

// 监听pickerView的选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *name  = _typeArray[row];

    self.typeLabel.text = name;
    
    if (self.com) {
        self.com(name,[self.subDic objectForKey:name]);
    }
//    self.typeLabel.text = _typeArray[row];
    NSLog(@"---%@----%@",name,[self.subDic objectForKey:name]);
}


#pragma  mark - function

- (void)showWith:(XNRTypeViewBlock)com{
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
