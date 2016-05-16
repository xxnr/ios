//
//  XNRRscCustomerTakeView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/4/28.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRRscCustomerTakeView.h"
#import "XNRRscOrderModel.h"

@interface XNRRscCustomerTakeView()<UITextFieldDelegate>

@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, weak) UIView *takeView;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) UIButton *admireBtn;

@property (nonatomic, weak) UILabel *stateLabel;

@property (nonatomic, weak) UITextField *deliverNumberTF;

@property (nonatomic, strong) XNRRscOrderModel *model;

@end

@implementation XNRRscCustomerTakeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self createMiddleView];
        [self createBottomView];
    }
    return self;
}

-(void)createBottomView
{
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(782), ScreenWidth, PX_TO_PT(100))];
        bottomView.backgroundColor = R_G_B_16(0xffffff);
        [self.takeView addSubview:bottomView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(1))];
        line.backgroundColor = R_G_B_16(0xc7c7c7);
        [bottomView addSubview:line];
        
        UIButton *admireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        admireBtn.frame = CGRectMake(0, 0, PX_TO_PT(180), PX_TO_PT(52));
        admireBtn.center = CGPointMake(ScreenWidth/2, PX_TO_PT(50));
        [admireBtn setTitleColor:R_G_B_16(0xffffff) forState:UIControlStateNormal];
        [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#c7c7c7"]] forState:UIControlStateNormal];
        [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fe9b00"]] forState:UIControlStateSelected];
        admireBtn.backgroundColor = R_G_B_16(0xfe9b00);
        admireBtn.layer.cornerRadius = 5.0;
        admireBtn.layer.masksToBounds = YES;
        [admireBtn setTitle:@"确定" forState:UIControlStateNormal];
        [admireBtn addTarget:self action:@selector(admireBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.admireBtn = admireBtn;
        [bottomView addSubview:admireBtn];

    }
}

-(void)admireBtnClick
{
    if (self.admireBtn.selected == YES) {
        if (self.admireBtn.selected == YES) {
            NSMutableArray *refArray = [NSMutableArray array];
            for (XNRRscSkusModel *model in _model.SKUs) {
                if (model.isSelected) {
                    [refArray addObject:model.ref];
                }
            }
            NSDictionary *params = @{@"orderId":_model._id,@"code":self.deliverNumberTF.text,@"SKURefs":refArray,@"token":[DataCenter account].token?[DataCenter account].token:@""};
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager POST:KRscSelfDelivery parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary *resultDic;
                if ([resultObj isKindOfClass:[NSDictionary class]]) {
                    resultDic = (NSDictionary *)resultObj;
                }
                if ([resultObj[@"code"] integerValue] == 1000) {
                    [self cancel];
                    [self setWarnViewTitle:@"自提成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
                    
                }else if([resultObj[@"code"] integerValue] == 1429){
                    [self cancel];
                    [UILabel showMessage:@"您输入错误次数较多，请一分钟后再试"];

                }else{
                    [UILabel showMessage:@"自提码错误，请重新输入"];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"===%@",error);
                
            }];
            
        }

    }else{
        [UILabel showMessage:@"请输入自提码"];
    }
    
}

-(UIView *)setWarnViewTitle:(NSString *)titleLabel{
    
    UIView *coverView = [[UIView alloc] initWithFrame:AppKeyWindow.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.6;
    [AppKeyWindow addSubview:coverView];
    
    UIView *warnView = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(180), PX_TO_PT(450), PX_TO_PT(390), PX_TO_PT(280))];
    warnView.layer.cornerRadius = PX_TO_PT(20);
    warnView.backgroundColor = [UIColor blackColor];
    [AppKeyWindow addSubview:warnView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(119), PX_TO_PT(51), PX_TO_PT(121), PX_TO_PT(121))];
    imageView.image = [UIImage imageNamed:@"success"];
    [warnView addSubview:imageView];
    
    UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(129), CGRectGetMaxY(imageView.frame)+PX_TO_PT(30), PX_TO_PT(140), PX_TO_PT(30))];
    successLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    successLabel.text = titleLabel;
    successLabel.textColor = [UIColor whiteColor];
    [warnView addSubview:successLabel];
    
    [UIView animateWithDuration:2.0 animations:^{
        warnView.alpha = 0;
        coverView.alpha = 0;
    } completion:^(BOOL finished) {
        //        [coverView removeFromSuperview];
    }];
    return coverView;
}


-(void)createMiddleView
{
    UILabel *deliverNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(40), PX_TO_PT(333), PX_TO_PT(170), PX_TO_PT(28))];
    deliverNumberLabel.textColor = R_G_B_16(0x646464);
    deliverNumberLabel.text = @"请输入自提码";
    deliverNumberLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [self.takeView addSubview:deliverNumberLabel];
    
    
    UITextField *deliverNumberTF = [[UITextField alloc] init];
    deliverNumberTF.frame = CGRectMake(CGRectGetMaxX(deliverNumberLabel.frame)+PX_TO_PT(20), PX_TO_PT(317), PX_TO_PT(360), PX_TO_PT(60));
    deliverNumberTF.layer.borderWidth = PX_TO_PT(2);
    deliverNumberTF.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    deliverNumberTF.layer.masksToBounds = YES;
    deliverNumberTF.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    deliverNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    deliverNumberTF.textAlignment = NSTextAlignmentCenter;
    deliverNumberTF.textColor = R_G_B_16(0xfe9b00);
    deliverNumberTF.alpha = 1.0;
    deliverNumberTF.delegate = self;
    self.deliverNumberTF = deliverNumberTF;
    [self.takeView addSubview:deliverNumberTF];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat offset = self.takeView.frame.size.height - (textField.frame.origin.y  + textField.frame.size.height +216+PX_TO_PT(100));
    NSLog(@"====%f",offset);
    if (offset<=0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.takeView.frame;
            frame.origin.y = PX_TO_PT(300);
            self.takeView.frame = frame;
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.takeView.frame;
        frame.origin.y = ScreenHeight-PX_TO_PT(882);
        self.takeView.frame = frame;
    }];
    return  YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.deliverNumberTF.layer.borderColor = R_G_B_16(0xfe9b00).CGColor;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.deliverNumberTF.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;

    if (self.deliverNumberTF.text.length == 7) {
        self.admireBtn.selected = YES;
    }else{
        self.admireBtn.selected = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 7)
        return NO; // return NO to not change text
    return YES;
}



-(void)createView
{
    if (!_coverView&&!_takeView) {
        UIView *coverView = [[UIView alloc] initWithFrame:AppKeyWindow.bounds];
        [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)]];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.4;
        self.coverView = coverView;
        [AppKeyWindow addSubview:coverView];
        
        UIView *takeView = [[UIView alloc] init];
        takeView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(882));
        takeView.backgroundColor = [UIColor whiteColor];
        takeView.userInteractionEnabled = YES;
        self.takeView = takeView;
        [AppKeyWindow addSubview:takeView];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
        headView.backgroundColor = R_G_B_16(0xfafafa);
        [takeView addSubview:headView];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth, PX_TO_PT(88))];
        stateLabel.textColor = R_G_B_16(0x323232);
        stateLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        stateLabel.text = @"客户自提-自提码";
        self.stateLabel = stateLabel;
        [headView addSubview:stateLabel];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(34)-PX_TO_PT(30), PX_TO_PT(27), PX_TO_PT(34), PX_TO_PT(34))];
        [cancelBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:cancelBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(88), ScreenWidth, PX_TO_PT(1))];
        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
        [headView addSubview:lineView];

    }
}

-(void)cancelBtnClick
{
    [self cancel];
}


-(void)show:(XNRRscOrderModel *)model
{
    if (_coverView == nil && _takeView == nil) {
        [self createView];
        [self createMiddleView];
        [self createBottomView];
    }
    _model = model;
    self.coverView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.takeView.frame  =  CGRectMake(0, ScreenHeight-PX_TO_PT(882), ScreenWidth, PX_TO_PT(882));
    }];
}

-(void)cancel
{
    self.admireBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.takeView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
    } completion:^(BOOL finished) {
//        self.coverView.hidden = YES;
        [self.coverView removeFromSuperview];
        [self.takeView removeFromSuperview];
    }];
    
}

- (void)changeSelfToIdentify {
    [self.coverView removeFromSuperview];
    [self.takeView removeFromSuperview];
    self.coverView = nil;
    self.takeView = nil;
}

@end
