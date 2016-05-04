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
#import "XNRSelWebBtn.h"
@interface XNRMakeSureView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIView *bottomView;
@property (nonatomic,weak)UIView *coverView;
@property (nonatomic,weak)UIView *makeSureView;
@property (nonatomic,weak)UIView *tatologyView;
@property (nonatomic,weak)UIView *auditView;
@property (nonatomic,weak)UIView *dispatchView;
@property (nonatomic,weak)UIButton *makeSureBtn;
@property (nonatomic,strong)NSMutableArray *selProArr;
@property (nonatomic,assign)NSInteger count;
@end

@implementation XNRMakeSureView

-(void)createWarn
{
    
}

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

-(void)getconfirmSKUReceived
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<self.modelArr.count; i++) {
        XNRMyOrderModel *model = self.modelArr[i];
        [arr addObject:model.ref];
    }
    NSDictionary *params = @{@"orderId":self.orderId,@"SKURefs":arr,@"user-agent":@"IOS-v2.0"};
    
    [manager POST:KconfirmSKUReceived parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {

            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];
    

}
-(void)createview
{    
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight-PX_TO_PT(40))];
    UIColor *color = [UIColor blackColor];
    coverView.backgroundColor = [color colorWithAlphaComponent:0.6];
    self.coverView = coverView;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:coverView];

    [self createTableView];
    [self createBottomView];
}

-(void)coverClick
{
//    [self removeFromSuperview];

}
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,PX_TO_PT(350), ScreenWidth, self.coverView.height - PX_TO_PT(350) - PX_TO_PT(99)) style:UITableViewStylePlain];
    tableView.backgroundColor = R_G_B_16(0xf9f9f9);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.coverView addSubview:tableView];
}
-(void)createBottomView
{
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), ScreenWidth, PX_TO_PT(99))];
    self.bottomView = bottom;
    bottom.backgroundColor = [UIColor whiteColor];
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-PX_TO_PT(190))/2, PX_TO_PT(24), PX_TO_PT(190), PX_TO_PT(52))];
    self.makeSureBtn = okBtn;
//    okBtn.backgroundColor = R_G_B_16(0xFE9B00);
    okBtn.backgroundColor = R_G_B_16(0xe0e0e0);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.layer.cornerRadius = PX_TO_PT(8);
    [okBtn addTarget:self action:@selector(makeSure:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:okBtn];
    [self.coverView addSubview:bottom];
}
//确认收货
-(void)makeSure:(UIButton *)sender
{
    if (self.selProArr.count == 0) {
        [UILabel showMessage:@"请选择确认收货的商品"];
        return;
    }
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
            self.tableView.hidden = YES;
            self.bottomView.hidden = YES;
            UIView *warnView = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(180), PX_TO_PT(450), PX_TO_PT(360), PX_TO_PT(280))];
            warnView.layer.cornerRadius = PX_TO_PT(20);
            warnView.backgroundColor = [UIColor blackColor];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(119), PX_TO_PT(51), PX_TO_PT(121), PX_TO_PT(121))];
            imageView.image = [UIImage imageNamed:@"success"];
            [warnView addSubview:imageView];
            
            UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(129), CGRectGetMaxY(imageView.frame)+PX_TO_PT(30), PX_TO_PT(120), PX_TO_PT(30))];
            successLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            successLabel.text = @"收货成功";
            successLabel.textColor = [UIColor whiteColor];
            [warnView addSubview:successLabel];
            
            [self.coverView addSubview:warnView];
            
            [UIView animateWithDuration:1.5f animations:^{
                warnView.alpha = 0;
          
            } completion:^(BOOL finished) {
                [self.coverView removeFromSuperview];
                [self removeFromSuperview];

                [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:self];
                if ([_iscome isEqualToString:@"XNROrderVC"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"orderVCRefresh" object:self];
                }
            }];
            //
            
        }
        else if ([resultObj[@"code"] integerValue] == 1401)
        {
            [UILabel showMessage:resultObj[@"message"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:self];
            
            [self.coverView removeFromSuperview];
            [self removeFromSuperview];

        }
        else{
            self.tableView.hidden = YES;
            self.bottomView.hidden = YES;
            UIView *warnView = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(180), PX_TO_PT(450), PX_TO_PT(360), PX_TO_PT(280))];
            warnView.layer.cornerRadius = PX_TO_PT(20);
            warnView.backgroundColor = [UIColor blackColor];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(119), PX_TO_PT(51), PX_TO_PT(121), PX_TO_PT(121))];
            imageView.image = [UIImage imageNamed:@"failure"];
            [warnView addSubview:imageView];
            
            UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(129), CGRectGetMaxY(imageView.frame)+PX_TO_PT(30), PX_TO_PT(140), PX_TO_PT(30))];
            successLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
            successLabel.text = @"请稍候重试";
            successLabel.textColor = [UIColor whiteColor];
            [warnView addSubview:successLabel];
            
            [self.coverView addSubview:warnView];
            
            [UIView animateWithDuration:2.0f animations:^{
                warnView.alpha = 0;
                
            } completion:^(BOOL finished) {
                [self.coverView removeFromSuperview];
                [self removeFromSuperview];
                
            }];
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.tableView.hidden = YES;
        self.bottomView.hidden = YES;
        UIView *warnView = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(180), PX_TO_PT(450), PX_TO_PT(360), PX_TO_PT(280))];
        warnView.layer.cornerRadius = PX_TO_PT(20);
        warnView.backgroundColor = [UIColor blackColor];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(119), PX_TO_PT(51), PX_TO_PT(121), PX_TO_PT(121))];
        imageView.image = [UIImage imageNamed:@"failure"];
        [warnView addSubview:imageView];
        
        UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(129), CGRectGetMaxY(imageView.frame)+PX_TO_PT(30), PX_TO_PT(140), PX_TO_PT(30))];
        successLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
        successLabel.text = @"请稍候重试";
        successLabel.textColor = [UIColor whiteColor];
        [warnView addSubview:successLabel];
        
        [self.coverView addSubview:warnView];
        
        [UIView animateWithDuration:2.0f animations:^{
            warnView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [self.coverView removeFromSuperview];
            [self removeFromSuperview];
            
        }];

    }];

}
//关闭
-(void)closeView:(UIButton *)sender
{
    [self.coverView removeFromSuperview];
    [self removeFromSuperview];
}
#pragma mark -- UITableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
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
    [closeBtn setImage:[UIImage imageNamed:@"shutdown"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeBtn];

    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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

    [cell setModel:model];

    XNRSelWebBtn *iconBtn = [[XNRSelWebBtn alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, cell.height)];
    [iconBtn setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [iconBtn setImage:[UIImage imageNamed:@"checkthe"] forState:UIControlStateSelected];
    [iconBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.tag = indexPath.row;
    XNRMyOrderModel *ordermodel = self.modelArr[iconBtn.tag];
    if ([self.selProArr containsObject:ordermodel.ref]) {
        iconBtn.selected = YES;
    }
    self.tableView.rowHeight = cell.height;
    
    [cell addSubview:iconBtn];
    
    return cell;

}

-(void)iconClick:(UIButton *)sender
{
    XNRMyOrderModel *model = self.modelArr[sender.tag];
   

    if (sender.selected == NO) {
        sender.selected = YES;
        _count += [model.count integerValue];
        [self.selProArr addObject:model.ref];
    }
    else
    {
        _count -= [model.count integerValue];
        sender.selected = NO;
        [self.selProArr removeObject:model.ref];
    }
    [self.bottomView removeFromSuperview];
    [self createBottomView];
    if (_count == 0) {
        [self.makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    else{
        self.makeSureBtn.backgroundColor = R_G_B_16(0xFE9B00);
        [self.makeSureBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",_count] forState:UIControlStateNormal];
    }
}


@end
