//
//  XNRMakeSureView.m
//  xinnongreniOS
//
//  Created by 杨宁 on 16/4/14.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRMakeSureView.h"
#import "XNRMyOrderModel.h"
#import "XNRMakeSureCell.h"
@interface XNRMakeSureView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIView *bottomView;
@property (nonatomic,strong)NSMutableArray *selProArr;
@end

@implementation XNRMakeSureView

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)selProArr
{
    if (!_selProArr) {
        _selProArr = [NSMutableArray array];
    }
    return _selProArr;
}
-(void)createview
{
    [self createTableView];
    [self createBottomView];
    
    UIButton *coverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, PX_TO_PT(40), ScreenWidth, ScreenHeight-PX_TO_PT(40))];
    UIColor *color = [UIColor blackColor];
    coverBtn.backgroundColor = [color colorWithAlphaComponent:0.6];
    [coverBtn addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:coverBtn];
    
}
-(void)coverClick
{
    [self removeFromSuperview];
}
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,ScreenHeight-PX_TO_PT(880), ScreenWidth, PX_TO_PT(880)-PX_TO_PT(99)) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self addSubview:tableView];
}
-(void)createBottomView
{
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), ScreenWidth, PX_TO_PT(99))];
    self.bottomView = bottom;
    bottom.backgroundColor = [UIColor whiteColor];
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(190))/2, PX_TO_PT(24), PX_TO_PT(190), PX_TO_PT(52))];
    okBtn.backgroundColor = R_G_B_16(0xFE9B00);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(makeSure:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
}
//确认收货
-(void)makeSure:(UIButton *)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *dic = @{@"orderId":self.orderId,@"SKURefs":self.selProArr};
    [manager POST:KconfirmSKUReceived parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            [UILabel showMessage:@"确认成功"];
            [self removeFromSuperview];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
//关闭
-(void)closeView:(UIButton *)sender
{
    [self removeFromSuperview];
}
#pragma mark -- UITableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 89)];
    headView.backgroundColor = R_G_B_16(0xFAFAFA);
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(29), ScreenWidth/2, PX_TO_PT(33))];
    titleLabel.text = @"确认收货";
    titleLabel.textColor = R_G_B_16(0x323232);
    titleLabel.font =[UIFont systemFontOfSize:PX_TO_PT(32)];
    [headView addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - PX_TO_PT(28) - PX_TO_PT(32), PX_TO_PT(29), PX_TO_PT(32), PX_TO_PT(32))];
    [closeBtn setImage:[UIImage imageNamed:@"close_x"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeBtn];

    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView HeightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(89);
}
-(CGFloat)tableView:(UITableView *)tableView HeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRMyOrderModel *model = self.modelArr[indexPath.row];

    static NSString *cellID = @"cellID";
    XNRMakeSureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XNRMakeSureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(89))];
    [iconBtn setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [iconBtn setImage:[UIImage imageNamed:@"address_right"] forState:UIControlStateSelected];
    [iconBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchDown];
    iconBtn.tag = indexPath.row;
    
    if ([self.selProArr containsObject:self.modelArr[iconBtn.tag]]) {
        iconBtn.selected = YES;
    }

    [cell addSubview:iconBtn];
    [cell setModel:model];
    
    return cell;

}

-(void)iconClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        [self.selProArr addObject:self.modelArr[sender.tag]];
    }
    else
    {
        sender.selected = NO;
        [self.selProArr removeObject:self.modelArr[sender.tag]];
    }
}


@end
