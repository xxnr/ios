//
//  XNRPayTypeAlertView.m
//  xinnongreniOS
//
//  Created by ZSC on 15/7/9.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRPayTypeAlertView.h"
#import "UILabel+ZSC.h"  //顶部对齐

#define kContentWidth  (ScreenWidth - 90*SCALE)
#define kContentHeight  (ScreenHeight*0.65)

#define kKeFuDianHuaUrl @"app/profile/getProfileBankList" //银行账户

@interface XNRPayTypeAlertView ()
{
    UILabel *payeeLabel;      //收款人
    UILabel *bankNameLabel;   //开户行名称
    UILabel *bankCardNoLabel; //开户行卡号
    
    UILabel *backNamelabelAdd;
    UILabel *bankCardNoLabelAdd; //开户行卡号

}
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation XNRPayTypeAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)createContentView
{
    _contentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kContentWidth, kContentHeight)];
    if (self.kDirection == kFromTop) {
        _contentView.center = CGPointMake(ScreenWidth/2.0, -(ScreenHeight+kContentHeight));
    }
    else if (self.kDirection == kFromBottom){
        _contentView.center = CGPointMake(ScreenWidth/2.0, ScreenHeight+kContentHeight);
    }
    else if (self.kDirection == kFromLeft){
        _contentView.center = CGPointMake(-(ScreenWidth+kContentWidth), ScreenHeight/2.0);
    }
    else if (self.kDirection == kFromRight){
        _contentView.center = CGPointMake(ScreenWidth+kContentWidth, ScreenHeight/2.0);
    }
    
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.alpha = 1;
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.cornerRadius = 10;
    [self addSubview:_contentView];
    
    _contentView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0);
    } completion:^(BOOL finished) {
        
    }];
    
    [self createContentViewSubView];
    
}


#pragma mark - 获取网络数据
- (void)networkRequest
{
    [SVProgressHUD showWithStatus:@"获取支付账户信息"];
    //key:0000关于我们,0001使用帮助,0002热线电话,0003银行账户信息
    [KSHttpRequest post:[NSString stringWithFormat:@"%@/%@",HOST,kKeFuDianHuaUrl] parameters:@{@"locationUserId":IS_Login?[DataCenter account].userid:@"",@"key":@"0003"} success:^(id result) {
        if ([result[@"code"] isEqualToString:@"1000"]) {
            [SVProgressHUD dismiss];
//            NSDictionary *datasDic = result[@"datas"];
            NSArray *datasArr = result[@"datas"][@"rows"];
            NSString *bankInfoStr1 = datasArr[0][@"value"]; //银行账户信息
            NSString *bankInfoStr2 = datasArr[1][@"value"]; //银行账户信息

            //字符串分割
            NSArray*arr1=[bankInfoStr1 componentsSeparatedByString:@"|"];
            NSArray*arr2=[bankInfoStr2 componentsSeparatedByString:@"|"];

            
            payeeLabel.text = arr1[0];     //收款人
            bankNameLabel.text = arr1[1];   //开户行名称
            bankCardNoLabel.text = arr1[2]; //开户行卡号
            
            backNamelabelAdd.text = arr2[1];
            bankCardNoLabelAdd.text = arr2[2];
            //顶部对齐
            [payeeLabel verticalUpAlignmentWithText:payeeLabel.text maxHeight:35];
            [bankNameLabel verticalUpAlignmentWithText:bankNameLabel.text maxHeight:35];
            [bankCardNoLabel verticalUpAlignmentWithText:bankCardNoLabel.text maxHeight:35];
            
//            [backNamelabelAdd verticalUpAlignmentWithText:bankNameLabel.text maxHeight:35];
            [bankCardNoLabelAdd verticalUpAlignmentWithText:bankCardNoLabel.text maxHeight:35];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取支付账户失败"];
    }];
}

- (UIView *) createContentViewSubView:(NSArray *)arr
{
    for (int i =0; i<[arr count]; i++) {
        //收款人

    }
    return nil;
}


- (void)createContentViewSubView
{
    //请求数据
    [self networkRequest];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, _contentView.frame.size.width-20, _contentView.frame.size.height-20)];
    bgView.backgroundColor = R_G_B_16(0xf4f4f4);
    [_contentView addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,IS_FourInch?40:80*SCALE, _contentView.frame.size.width, 20)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"请到银行办理";
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:titleLabel];
    
    for (int i =0; i<[_dataArr count]; i++) {
        
    }

    
    //收款人
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height+25, 50, 35)];
    label1.textColor = [UIColor blackColor];
    label1.text = @"收款人:";
    label1.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [bgView addSubview:label1];
    [label1 verticalUpAlignmentWithText:label1.text maxHeight:35];
    
    payeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x+label1.frame.size.width, titleLabel.frame.origin.y+titleLabel.frame.size.height+25, bgView.frame.size.width-label1.frame.size.width, 35)];
    payeeLabel.textColor = [UIColor blackColor];
    payeeLabel.text = @"";
    payeeLabel.numberOfLines = 0;
    payeeLabel.adjustsFontSizeToFitWidth = YES;
    payeeLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [bgView addSubview:payeeLabel];
    
    
    //开户行
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, payeeLabel.frame.origin.y+payeeLabel.frame.size.height, 50, 35)];
    label2.textColor = [UIColor blackColor];
    label2.text = @"开户行:";
    label2.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    label2.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label2];
    [label2 verticalUpAlignmentWithText:label2.text maxHeight:35];
    
    bankNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(label2.frame.origin.x+label2.frame.size.width, payeeLabel.frame.origin.y+payeeLabel.frame.size.height, bgView.frame.size.width-label2.frame.size.width, 35)];
    bankNameLabel.textColor = [UIColor blackColor];
    bankNameLabel.text = @"";
    bankNameLabel.numberOfLines = 0;
    bankNameLabel.adjustsFontSizeToFitWidth = YES;
    bankNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    bankNameLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:bankNameLabel];
    
    //开户行卡号
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, bankNameLabel.frame.origin.y+bankNameLabel.frame.size.height, 50, 35)];
    label3.textColor = [UIColor blackColor];
    label3.text = @"银行卡:";
    label3.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    label3.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label3];
    [label3 verticalUpAlignmentWithText:label3.text maxHeight:35];
    
    bankCardNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.origin.x+label3.frame.size.width, bankNameLabel.frame.origin.y+bankNameLabel.frame.size.height, bgView.frame.size.width-label3.frame.size.width, 35)];
    bankCardNoLabel.textColor = [UIColor blackColor];
    bankCardNoLabel.text = @"";
    bankCardNoLabel.numberOfLines = 0;
    bankCardNoLabel.adjustsFontSizeToFitWidth = YES;
    bankCardNoLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    bankCardNoLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:bankCardNoLabel];
    
    
    
    //开户行
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, bankCardNoLabel.frame.origin.y+bankCardNoLabel.frame.size.height, 50, 35)];
    addLabel.textColor = [UIColor blackColor];
    addLabel.text = @"开户行:";
    addLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    addLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:addLabel];
    [label2 verticalUpAlignmentWithText:addLabel.text maxHeight:35];
    
    backNamelabelAdd = [[UILabel alloc]initWithFrame:CGRectMake(addLabel.frame.origin.x+addLabel.frame.size.width, bankCardNoLabel.frame.origin.y+bankCardNoLabel.frame.size.height, bgView.frame.size.width-label2.frame.size.width, 35)];
    backNamelabelAdd.textColor = [UIColor blackColor];
    backNamelabelAdd.text = @"";
    backNamelabelAdd.numberOfLines = 0;
    backNamelabelAdd.adjustsFontSizeToFitWidth = YES;
    backNamelabelAdd.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    backNamelabelAdd.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:backNamelabelAdd];
    
    //开户行卡号
    UILabel *addlabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, backNamelabelAdd.frame.origin.y+backNamelabelAdd.frame.size.height, 50, 35)];
    addlabel3.textColor = [UIColor blackColor];
    addlabel3.text = @"银行卡:";
    addlabel3.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    addlabel3.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:addlabel3];
    [addlabel3 verticalUpAlignmentWithText:addlabel3.text maxHeight:35];
    
    bankCardNoLabelAdd = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.origin.x+label3.frame.size.width, backNamelabelAdd.frame.origin.y+backNamelabelAdd.frame.size.height, bgView.frame.size.width-label3.frame.size.width, 35)];
    bankCardNoLabelAdd.textColor = [UIColor blackColor];
    bankCardNoLabelAdd.text = @"";
    bankCardNoLabelAdd.numberOfLines = 0;
    bankCardNoLabelAdd.adjustsFontSizeToFitWidth = YES;
    bankCardNoLabelAdd.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    bankCardNoLabelAdd.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:bankCardNoLabelAdd];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, bankCardNoLabelAdd.frame.origin.y+bankCardNoLabelAdd.frame.size.height+30, _contentView.frame.size.width-40, 45);
    button.backgroundColor = R_G_B_16(0x11c422);
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius =5;
    [_contentView addSubview:button];
}

#pragma mark - 轻击屏幕
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.kDirection == kFromTop) {
            _contentView.center = CGPointMake(ScreenWidth/2.0, -(ScreenHeight+kContentHeight));
        }
        else if (self.kDirection == kFromBottom){
            _contentView.center = CGPointMake(ScreenWidth/2.0, ScreenHeight+kContentHeight);
        }
        else if (self.kDirection == kFromLeft){
            _contentView.center = CGPointMake(-(ScreenWidth+kContentWidth), ScreenHeight/2.0);
        }
        else if (self.kDirection == kFromRight){
            _contentView.center = CGPointMake(ScreenWidth+kContentWidth, ScreenHeight/2.0);
        }
    } completion:^(BOOL finished) {
        self.deleteBlock();
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
