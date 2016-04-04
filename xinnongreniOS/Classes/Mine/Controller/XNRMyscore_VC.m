//
//  XNRMyscore_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyscore_VC.h"
#import "XNRMyscore_Cell.h"
#import "XNRMyScoreModel.h"
#define kMyScoreURL @"api/v2.0/point/findPointList" //我的积分

@interface XNRMyscore_VC ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray*_dataArray;
    int _currentPage;   //当前页
}
@property(nonatomic,retain)UITableView*tableview;
@property(nonatomic,retain)UILabel*myScore;
@end

@implementation XNRMyscore_VC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    
    _currentPage = 1;
    
    _dataArray = [[NSMutableArray alloc]init];
    _currentPage = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.backgroundColor=[UIColor clearColor];
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableview.showsHorizontalScrollIndicator=NO;
    self.tableview.showsVerticalScrollIndicator=NO;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableview];
    
    //创建头部视图
    [self creatHeadView];
    //获取数据
    [self getData];
    
}

#pragma mark - 获取数据
- (void)getData
{
    [KSHttpRequest post:KUserFindPointList parameters:@{@"locationUserId":[DataCenter account].userid,@"page":[NSString stringWithFormat:@"%d",_currentPage],@"rows":@"15",@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000 || [result[@"code"] integerValue] == 1002) {
            
            if (_currentPage == 1) {                
                [_dataArray removeAllObjects];
            }
            
            NSDictionary *rowsDic = result[@"datas"];
            NSArray *listArr = rowsDic[@"rows"];
            
            for (NSDictionary *subDic in listArr) {
                XNRMyScoreModel *model = [[XNRMyScoreModel alloc]init];
                [model setValuesForKeysWithDictionary:subDic];
                [_dataArray addObject:model];
            }
            self.myScore.text= [rowsDic[@"pointLaterTrade"] stringValue];
        } else{
           
            [UILabel showMessage:result[@"message"]];
        }
        
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络请求错误"];
        //刷新列表
        [self.tableview reloadData];
    }];
}

#pragma mark--创建头部视图
-(void)creatHeadView{
    
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    headView.backgroundColor=R_G_B_16(0xf4f4f4);
    [self.view addSubview:headView];
    
    UIView*myScoreBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    myScoreBg.backgroundColor=[UIColor whiteColor];
    [headView addSubview:myScoreBg];
    //我的积分
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    titleLabel.textColor=R_G_B_16(0x7e7e7e);
    titleLabel.font=[UIFont boldSystemFontOfSize:16];
    titleLabel.text=@"我的积分:";
    
    [myScoreBg addSubview:titleLabel];
    
    //积分数
    self.myScore=[[UILabel alloc]initWithFrame:CGRectMake(15, 45, ScreenWidth-30, 45)];
    self.myScore.textColor=R_G_B_16(0x00b38a);
    self.myScore.font=[UIFont systemFontOfSize:PX_TO_PT(80)] ;
    self.myScore.text=@"0";
    [myScoreBg addSubview:self.myScore];
    self.tableview.tableHeaderView=headView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID=@" XNRMyscore";
    XNRMyscore_Cell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        
        cell=[[XNRMyscore_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=[UIColor whiteColor];
    
    if (_dataArray.count) {
        [cell setCellDataWithModel:_dataArray[indexPath.row]];

    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    
}

- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的积分";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
