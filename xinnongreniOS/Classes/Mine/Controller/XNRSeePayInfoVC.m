//
//  XNRSeePayInfoVC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/3/23.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSeePayInfoVC.h"
#import "XNRPayInfoModel.h"
#import "XNRPayInfoTableViewCell.h"

@interface XNRSeePayInfoVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;

@end

@implementation XNRSeePayInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationbarTitle];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-PX_TO_PT(88)) style:UITableViewStyleGrouped];
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.payments.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(353))];
    
    UIView *headViewTop = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(19), ScreenWidth, PX_TO_PT(250))];
    headViewTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headViewTop];
    
    UILabel *orderIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(27), PX_TO_PT(500), PX_TO_PT(30))];
    orderIdLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    orderIdLabel.text = [NSString stringWithFormat:@"订单号：%@",self.model.orderId];
    [headViewTop addSubview:orderIdLabel];
    
    UILabel *jdLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(81), PX_TO_PT(200), PX_TO_PT(32))];
    jdLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    
    if ([self.model.type isEqualToString:@"deposit"]) {
        jdLabel.text = @"阶段一：订金";
    }
    else if ([self.model.type isEqualToString:@"balance"])
    {
        jdLabel.text = @"阶段二：尾款";
    }
    else if ([self.model.type isEqualToString:@"full"])
    {
        jdLabel.text = @"订单总额";
    }
    [headViewTop addSubview:jdLabel];
    
    //应付款金额
    UILabel *shouldPayMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(150), ScreenWidth - PX_TO_PT(34), PX_TO_PT(28))];
    shouldPayMoneyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    shouldPayMoneyLabel.textColor = R_G_B_16(0x646464);
    shouldPayMoneyLabel.text = [NSString stringWithFormat:@"应支付金额：¥%.2f",[self.model.price doubleValue]];

    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:shouldPayMoneyLabel.text];
    NSDictionary *dict=@{
                         
                         NSForegroundColorAttributeName:R_G_B_16(0xFF4E00),
                                                        NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                         
                         };
    
    [AttributedStringDeposit addAttributes:dict range:NSMakeRange(6,AttributedStringDeposit.length-6)];
    
    [shouldPayMoneyLabel setAttributedText:AttributedStringDeposit];

    
    [headViewTop addSubview:shouldPayMoneyLabel];
    
    //已付款金额
    UILabel *alreadyPayMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), CGRectGetMaxY(shouldPayMoneyLabel.frame) + PX_TO_PT(25),ScreenWidth - PX_TO_PT(34), PX_TO_PT(28))];
    alreadyPayMoneyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    alreadyPayMoneyLabel.textColor = R_G_B_16(0x646464);
    alreadyPayMoneyLabel.text = [NSString stringWithFormat:@"已支付金额：¥%.2f",[self.model.paidPrice doubleValue]];
    
    NSMutableAttributedString *AttributedStringDeposit1 = [[NSMutableAttributedString alloc]initWithString:alreadyPayMoneyLabel.text];
    NSDictionary *dict1=@{
                         
                         NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]
                         
                         };
    
    [AttributedStringDeposit1 addAttributes:dict1 range:NSMakeRange(6,AttributedStringDeposit1.length-6)];
    
    [alreadyPayMoneyLabel setAttributedText:AttributedStringDeposit1];
    

    [headViewTop addSubview:alreadyPayMoneyLabel];
    
    //付款状态
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(0), PX_TO_PT(84), ScreenWidth - PX_TO_PT(33), PX_TO_PT(26))];
    statusLabel.textAlignment = UITextAlignmentRight;
    statusLabel.textColor = R_G_B_16(0xFE9B00);
    
    //付款状态
    NSInteger status = [self.model.payStatus integerValue];
    
    if (status == 1) {
        statusLabel.text = @"待付款";
    }
    else if (status == 2)
    {
        statusLabel.text = @"已付款";
    }
    else if (status == 3)
    {
        statusLabel.text = @"部分付款";
    }

    statusLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    [headViewTop addSubview:statusLabel];
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(1),ScreenWidth, PX_TO_PT(1))];
    line0.backgroundColor = R_G_B_16(0xc7c7c7);

    [headViewTop addSubview:line0];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(127),ScreenWidth - PX_TO_PT(66), PX_TO_PT(1))];
    line1.backgroundColor = R_G_B_16(0xc7c7c7);
    [headViewTop addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(249),ScreenWidth, PX_TO_PT(1))];
    line2.backgroundColor = R_G_B_16(0xc7c7c7);
    [headViewTop addSubview:line2];
    
    
    UIView *viewTop2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headViewTop.frame) + PX_TO_PT(24), ScreenWidth, PX_TO_PT(81))];
    viewTop2.backgroundColor = R_G_B_16(0xF0F0F0);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(33), PX_TO_PT(26), PX_TO_PT(130), PX_TO_PT(32))];
    label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    label.text = @"支付详情";
    [viewTop2 addSubview:label];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(1),ScreenWidth, PX_TO_PT(1))];
    line3.backgroundColor = R_G_B_16(0xc7c7c7);
    [viewTop2 addSubview:line3];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(79),ScreenWidth, PX_TO_PT(1))];
    line4.backgroundColor = R_G_B_16(0xc7c7c7);
    [viewTop2 addSubview:line4];
    
    [headView addSubview:headViewTop];
    [headView addSubview:viewTop2];
    
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(372);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"XNRPayInfo";
    XNRPayInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        
        cell=[[XNRPayInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    XNRPayInfoModel *model = [[XNRPayInfoModel alloc]init];
    [model setValuesForKeysWithDictionary:self.model.payments[indexPath.row]];
    [cell setCellDataWithModel:model];
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRPayInfoModel *model = [[XNRPayInfoModel alloc]init];
    [model setValuesForKeysWithDictionary:self.model.payments[indexPath.row]];
    
    if (model.payType == 1 || model.payType == 2 || model.payType == 3|| model.payType == 4) {
        return PX_TO_PT(223);
    }
    else
    {
        return PX_TO_PT(183);
    }
}

- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"查看支付详情";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
