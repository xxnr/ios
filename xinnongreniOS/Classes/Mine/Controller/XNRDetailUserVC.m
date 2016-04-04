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
@interface XNRDetailUserVC ()
@property (nonatomic,strong)XNRCustomer *customer;
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
//-(NSMutableArray *)intentionArr
//{
//    if (!_intentionArr) {
//        _intentionArr = [NSMutableArray array];
//    }
//    return _intentionArr;
//}
//-(NSMutableArray *)detailLabels
//{
//    if (!_detailLabels) {
//        _detailLabels = [NSMutableArray array];
//    }
//    return _detailLabels;
//}
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
        
        [self.view addSubview:cell];
    }
}
-(void)getData
{
    [KSHttpRequest get:KGetPotentialCustomer parameters:@{@"_id":self._id} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            XNRCustomer *user = [[XNRCustomer alloc]init];
            user = [XNRCustomer objectWithKeyValues:result[@"potentialCustomer"]];
            self.customer = user;
            _intentionArr = [NSMutableArray arrayWithArray:[XNRBuyIntentionModel objectArrayWithKeyValuesArray:result[@"potentialCustomer"][@"buyIntentions"]]];
            
//            for (int i=0; i<user.buyIntentions.count; i++) {
//                XNRBuyIntentionModel *model = [[XNRBuyIntentionModel alloc]init];
//                model._id = result[@"potentialCustomer"][@"buyIntentions"][i][@"_id"];
//                model.name = result[@"potentialCustomer"][@"buyIntentions"][i][@"name"];
//                [_intentionArr addObject:model];
//            }
            NSMutableString *pro = [[NSMutableString alloc]init];
            for (int i=0; i<self.intentionArr.count; i++) {
                XNRBuyIntentionModel *intent = self.intentionArr[i];
                NSString *str = intent.name;
                [pro appendString:str];
                [pro appendString:@";"];
            }
            NSString *sex = @"";
            if ([user.sex integerValue] == 1) {
                sex = @"女";
            }
            else
            {
                sex = @"男";
            }
            NSMutableString *city = [NSMutableString string];
            [city appendString:result[@"potentialCustomer"][@"address"][@"province"][@"uppername"]];
            [city appendString:@" "];

            [city appendString:result[@"potentialCustomer"][@"address"][@"city"][@"uppername"]];
            [city appendString:@" "];
            [city appendString:result[@"potentialCustomer"][@"address"][@"county"][@"uppername"]];
            
            NSString *town = [NSString stringWithString:result[@"potentialCustomer"][@"address"][@"town"][@"name"]];
            
            NSArray *arr1 = [NSArray arrayWithObjects:user.name,user.phone,sex,city,town,pro,nil];
            
            for (int i=0; i < 6; i++) {
            
                UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(192), PX_TO_PT(35)+PX_TO_PT(99)*i, ScreenWidth - PX_TO_PT(192), PX_TO_PT(35))];
                detailLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
                detailLabel.textColor = R_G_B_16(0x646464);
                detailLabel.text = arr1[i];
                [self.view addSubview:detailLabel];
                NSLog(@"%@",self.view.subviews);
            }
            

            
//            UILabel *label1 = _detailLabels[0];
//            label1.text = user.name;
//            
//            UILabel *label2 = _detailLabels[1];
//            label2.text = user.phone;
//            UILabel *label3 = _detailLabels[2];
//            label3.text = user.sex;
//            UILabel *label4 = _detailLabels[3];
//            label4.text = user.remarks;
//            UILabel *label5 = _detailLabels[4];
//            
//            label5.text = pro;
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
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
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
