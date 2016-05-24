//
//  XNRDetailUserVC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRDetailUserVC.h"
#import "XNRCustomer.h"
#import "XNRBuyIntentionModel.h"
#import "XNRMyRepresentViewController.h"
#import "XNRPotentialCustomer.h"
#import "XNRAddressModel.h"
#import "XNRAddressDetail.h"
#import "MJExtension.h"
@interface XNRDetailUserVC ()
@property (nonatomic,strong)XNRPotentialCustomer *customer;
@property (nonatomic,strong)NSMutableArray *intentionArr;
@property (nonatomic,strong)NSMutableArray *detailLabels;
@end

@implementation XNRDetailUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigation];
    _intentionArr = [NSMutableArray array];
    _detailLabels = [NSMutableArray array];
    
    [self createView];
    [self getData];

    // Do any additional setup after loading the view.
}
-(void)createView
{
    NSArray *nameArr = @[@"姓名",@"手机号",@"性别",@"地区",@"街道",@"意向商品"];
    
    for (int i=0; i<nameArr.count; i++) {
        UIView *cell = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(99)*i, PX_TO_PT(140), PX_TO_PT(99))];
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(35), PX_TO_PT(140), PX_TO_PT(35))];
        name.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        name.textColor = R_G_B_16(0x323232);
        name.text = nameArr[i];
        [cell addSubview:name];
        
        if (i+1 < nameArr.count) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(99)*i+PX_TO_PT(98),ScreenWidth, PX_TO_PT(1.5))];
            line.backgroundColor = R_G_B_16(0xE0E0E0);
            [self.view addSubview:line];
        }
        [self.view addSubview:cell];
    }
}
-(void)getData
{
    [KSHttpRequest get:KGetPotentialCustomer parameters:@{@"_id":self._id} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            XNRPotentialCustomer *user = [[XNRPotentialCustomer alloc]init];
            user = [XNRPotentialCustomer objectWithKeyValues:result[@"potentialCustomer"]];
            self.customer = user;
            _intentionArr = [NSMutableArray arrayWithArray:[XNRBuyIntentionModel objectArrayWithKeyValuesArray:result[@"potentialCustomer"][@"buyIntentions"]]];
            NSMutableString *pro = [[NSMutableString alloc]init];
            [pro appendString:@""];
            if (user.buyIntentions) {
                for (int i=0; i<self.intentionArr.count; i++) {
                    XNRBuyIntentionModel *intent = self.intentionArr[i];
                    NSString *str = intent.name;
                    [pro appendString:str];
                    if (i+1 == self.intentionArr.count) {
                        
                    }
                    else{
                        
                        [pro appendString:@";"];}
                }
            }
          
            NSString *sex = @"";
            if (user.sex) {
                if ([user.sex integerValue] == 0) {
                    sex = @"男";
                }
                else
                {
                    sex = @"女";
                }
            }
            XNRAddressModel *address = [XNRAddressModel objectWithKeyValues:result[@"potentialCustomer"][@"address"] ];
            
            
            NSMutableString *city = [NSMutableString string];
            [city appendString:@""];
            if (address.province != 0) {
                [city appendString:result[@"potentialCustomer"][@"address"][@"province"][@"name"]];
                [city appendString:@" "];
            }
            if (address.city != 0) {
                [city appendString:result[@"potentialCustomer"][@"address"][@"city"][@"name"]];
                [city appendString:@" "];
            }
            if (address.county.count != 0) {
                [city appendString:result[@"potentialCustomer"][@"address"][@"county"][@"name"]];
            }
            NSString *town = @"";
            if (address.town.count != 0) {
                town = [NSString stringWithString:result[@"potentialCustomer"][@"address"][@"town"][@"name"]];
            }
            
            NSArray *arr1 = [NSArray arrayWithObjects:user.name,user.phone,sex,city,town,nil];
            
            for (int i=0; i < 5; i++) {
            
                UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(192), PX_TO_PT(35)+PX_TO_PT(99)*i, ScreenWidth - PX_TO_PT(192), PX_TO_PT(35))];
                detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
                detailLabel.textColor = R_G_B_16(0x646464);
                detailLabel.text = arr1[i];
                [self.view addSubview:detailLabel];
                NSLog(@"%@",self.view.subviews);
            }
           
            CGSize size = [pro sizeWithFont:[UIFont systemFontOfSize:PX_TO_PT(32)] constrainedToSize:CGSizeMake(ScreenWidth - PX_TO_PT(192), MAXFLOAT)];

            UILabel *interestLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(192), PX_TO_PT(35)+PX_TO_PT(99)*5, ScreenWidth - PX_TO_PT(192),size.height)];
            interestLabel.numberOfLines = 0;
            interestLabel.text = pro;
            interestLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
            interestLabel.textColor = R_G_B_16(0x646464);
            [self.view addSubview:interestLabel];
            
            
            UIView *lastLine = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(99)*5+size.height+PX_TO_PT(68),ScreenWidth, PX_TO_PT(1.5))];
            lastLine.backgroundColor = R_G_B_16(0xE0E0E0);
            [self.view addSubview:lastLine];

            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastLine.frame)+PX_TO_PT(1), ScreenWidth, ScreenHeight -CGRectGetMaxY(lastLine.frame)-PX_TO_PT(1))];
            bgView.backgroundColor = R_G_B_16(0xf8f8f8);
            [self.view addSubview:bgView];
        }
        else
        {
            [UILabel showMessage:result[@"message"]];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            //发送刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PageRefresh" object:nil];
            
            XNRLoginViewController *vc = [[XNRLoginViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
      } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createNavigation{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"客户详情";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];

    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
