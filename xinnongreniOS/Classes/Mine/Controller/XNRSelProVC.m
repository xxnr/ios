//
//  XNRSelProVC.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRSelProVC.h"
#import "XNRSelPro_Cell.h"
#import "XNRBtn.h"
@interface XNRSelProVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *allProArr;
@property (nonatomic,strong)NSMutableArray *selProArr;
@property (nonatomic,strong)NSMutableArray *allProId_Arr;
@property (nonatomic,strong)NSMutableArray*selProId_Arr;
@property (nonatomic,weak)UIButton *isSelBtn;
@end

@implementation XNRSelProVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigation];
    [self createBottomView];
    
    self.allProArr = [NSMutableArray array];
    self.selProArr = [NSMutableArray array];
    self.allProId_Arr = [NSMutableArray array];
    self.selProId_Arr = [NSMutableArray array];
    [self.selProArr addObjectsFromArray:self.selPro];
    [self.selProId_Arr addObjectsFromArray:self.selProId];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - PX_TO_PT(88)-PX_TO_PT(32)) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [self getData];
    
}

-(void)getData
{
    [KSHttpRequest get:KGetIntentionProducts parameters:nil success:^(id result) {
        NSArray *arr = result[@"intentionProducts"];
        for (int i=0; i<arr.count; i++) {
            [self.allProId_Arr addObject:result[@"intentionProducts"][i][@"_id"]];
            [self.allProArr addObject:result[@"intentionProducts"][i][@"name"]];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allProArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString static *cellID = @"cell";
   XNRSelPro_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XNRSelPro_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    XNRBtn *iconBtn = [[XNRBtn alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(89))];
    [iconBtn setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [iconBtn setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
    [iconBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchDown];
    iconBtn.tag = indexPath.row;
    
    if ([self.selProArr containsObject:self.allProArr[iconBtn.tag]]) {
        iconBtn.selected = YES;
    }
    [cell addSubview:iconBtn];

    
    NSString *name = [self.allProArr objectAtIndex:indexPath.row];
    cell.name = name;
    return cell;

}
-(void)iconClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        [self.selProId_Arr addObject:self.allProId_Arr[sender.tag]];
        [self.selProArr addObject:self.allProArr[sender.tag]];
    }
    else
    {
        sender.selected = NO;
        [self.selProId_Arr removeObject:self.allProId_Arr[sender.tag]];
        [self.selProArr removeObject:self.allProArr[sender.tag]];
    }
 }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(89);
}
-(void)createBottomView
{
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(PX_TO_PT(31), ScreenHeight-PX_TO_PT(88)-64-PX_TO_PT(32), ScreenWidth-PX_TO_PT(62), PX_TO_PT(88))];
    saveBtn.backgroundColor = R_G_B_16(0x00b38a);
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 5.0;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [saveBtn addTarget:self action:@selector(OKBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
}
-(void)OKBtn
{
    NSDictionary *dic = @{@"selProArr":self.selProArr,@"selProId_Arr":self.selProId_Arr};
    NSNotification *notification = [[NSNotification alloc]initWithName:@"selPro" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createNavigation{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择意向商品";
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
