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

@property (nonatomic ,weak) UIButton *leftBtn;
@property (nonatomic ,weak) UIButton *rightBtn;

@property (nonatomic ,copy) NSString *typeName;


@end
@implementation XNRTypeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBtn];
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(600));
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,PX_TO_PT(50), ScreenWidth, PX_TO_PT(500))];
        pickView.delegate = self;
        pickView.dataSource = self;
        self.pickerView = pickView;
        [self addSubview:pickView];

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
        self.typeName  = _typeArray[0];

        [self.pickerView reloadAllComponents];
    } failure:^(NSError *error) {
        [UILabel showMessage:@"网络加载失败"];
    }];

}
-(void)createBtn{
    
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
    
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(70)*i, ScreenWidth, 1)];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [bgView addSubview:lineView];
    }

}
-(void)BtnClick:(UIButton *)button{
    
    if ([self.delegate performSelector:@selector(XNRTypeViewBtnClick:)]) {
        XNRTypeViewType type;
        if (button == self.leftBtn) {
            type = LeftBtnType;
        }else{
            type = RightBtnType;
            if (self.com) {
                self.com(self.typeName,[self.subDic objectForKey:self.typeName]);
            }
//            NSLog(@"---%@----%@",name,[self.subDic objectForKey:name]);

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
    self.typeName  = _typeArray[row];
    
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
