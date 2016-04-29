//
//  myAlertView.m
//  lumbar
//
//  Created by Ceres on 16/3/28.
//  Copyright © 2016年 www.upupapp.com. All rights reserved.
//

#import "myAlertView.h"

@interface myAlertView()


@end
@implementation myAlertView

- (instancetype)initWithHeadTitle:(NSString *)headtitile LeftButton:(NSString *)leftTitile RightButton:(NSString *)rightTitile andDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        // 初始化alertView,在这里创建一个你需要的alertView视图,背景为全屏,背景颜色黑色半透明,然后在中间位置再创建一个view是显示用的alertView,这个alertView就是你图片里面,自己定义一下,然后左右两个button的点击事件关联下面两个方法
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(31),PX_TO_PT(440),ScreenWidth - PX_TO_PT(62),PX_TO_PT(318))];
        
        view.layer.cornerRadius = 5.0;
        view.layer.masksToBounds = YES;
        
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0,0,view.width,PX_TO_PT(217))];
        bgview.backgroundColor = [UIColor whiteColor];
        [view addSubview:bgview];
        [self addSubview:view];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, PX_TO_PT(66), ScreenWidth - PX_TO_PT(62), PX_TO_PT(40))];
        label1.text = headtitile;
        label1.textColor = R_G_B_16(0x323232);
        label1.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
        label1.textAlignment = UITextAlignmentCenter;
        [bgview addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(148), PX_TO_PT(141), PX_TO_PT(100), PX_TO_PT(30))];
        
        label2.text = [dic objectForKey:@"name"];
        label2.textColor = R_G_B_16(0x646464);
        label2.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        [bgview addSubview:label2];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame) + PX_TO_PT(30),PX_TO_PT(141),PX_TO_PT(34),PX_TO_PT(34))];
        imageView.image = [UIImage imageNamed:@"phone-icon"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [bgview addSubview:imageView];
        
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + PX_TO_PT(10), PX_TO_PT(144), PX_TO_PT(300), PX_TO_PT(30))];
        
        label3.text = [dic objectForKey:@"phone"];
        label3.textColor = R_G_B_16(0x646464);
        label3.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        [bgview addSubview:label3];

        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(215), ScreenWidth, PX_TO_PT(1))];
        line1.backgroundColor = R_G_B_16(0xE2E2E2);
        [bgview addSubview:line1];
        
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgview.frame), view.width/2, PX_TO_PT(101))];
        [leftButton setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#FFFFFF"]] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#FAFAFA"]] forState:UIControlStateHighlighted];        [leftButton setTitle:leftTitile forState:UIControlStateNormal];
        [leftButton setTitleColor:R_G_B_16(0x00B38A) forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchDown];
        [view addSubview:leftButton];
        
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(view.width/2, CGRectGetMaxY(bgview.frame), view.width/2, PX_TO_PT(101))];
        [rightButton setTitle:rightTitile forState:UIControlStateNormal];
        rightButton.backgroundColor = [UIColor whiteColor];
        [rightButton setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#FFFFFF"]] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#FAFAFA"]] forState:UIControlStateHighlighted];
//        rightButton.backgroundColor = R_G_B_16(0xFAFAFA);
        [rightButton setTitleColor:R_G_B_16(0x00B38A) forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchDown];
        [view addSubview:rightButton];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(view.width/2, CGRectGetMaxY(bgview.frame), PX_TO_PT(1), PX_TO_PT(101))];
        line2.backgroundColor =R_G_B_16(0xE2E2E2);
        [view addSubview:line2];
    }
    
    return self;
}

// 显示alertView
- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

// 移除alertView(在回调中调用该方法)
- (void)dismissLumAleatView
{
    // 这个方法也可以直接加到下面两个点击事件中
    [self removeFromSuperview];
}

// 右边按钮点击事件
-(void)rightAction{
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:Action: Dic:)]) {
        
        // 在这两个按钮的点击事件中,如果有需要传到回调里的值,就加到这个dic里,然后在外部回调中就可以取出这个dic的值使用
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        // 这个按钮是action:1的按钮
        [_delegate alertView:self Action:1 Dic:dic];
    }
}

// 左边按钮点击事件
-(void)leftAction{
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:Action: Dic:)]) {
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        // 这个按钮是action:0 的按钮
        [_delegate alertView:self Action:0 Dic:dic];
        
    }
}


@end
