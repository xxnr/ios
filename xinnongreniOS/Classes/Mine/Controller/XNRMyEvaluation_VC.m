//
//  XNRMyEvaluation_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/27.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyEvaluation_VC.h"
#import "XNRMyEvaluation_Cell.h"
#import "XNRMyEvaluationInfo_VC.h"
#import "MJRefresh.h"
#import "XNRMyEvaluationModel.h"
#define kMyCommentURL @"app/comment/MyJudgeList"  // 我的评价

@interface XNRMyEvaluation_VC ()<UITableViewDataSource,UITableViewDelegate,MyEvaluationCellDelegate>{
    
     NSMutableArray*_dataArray;
    int _currentPage;
}
@property(nonatomic,retain)UITableView*tableview;
@end

@implementation XNRMyEvaluation_VC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=R_G_B_16(0xf4f4f4);
    _dataArray = [[NSMutableArray alloc]init];
    _currentPage = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.backgroundColor=[UIColor clearColor];
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.showsHorizontalScrollIndicator=NO;
    self.tableview.showsVerticalScrollIndicator=NO;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundColor=R_G_B_16(0xf4f4f4);
    [self.view addSubview:self.tableview];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self setNavigationbarTitle];
    
    //头部刷新
    __weak __typeof(&*self)weakSelf = self;
    [self.tableview addLegendHeaderWithRefreshingBlock:^{
        _currentPage = 1;
        [weakSelf getData];
    }];
    
    //尾部刷新
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        _currentPage = _currentPage + 1;
        [weakSelf getData];
    }];
    
    [self getData];
}

#pragma mark - 获取数据
- (void)getData
{
    NSLog(@"%@",[DataCenter account].userid);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,kMyCommentURL];
    [KSHttpRequest post:urlStr parameters:@{@"locationUserId":[DataCenter account].userid,@"page":[NSString stringWithFormat:@"%d",_currentPage],@"rows":@"10",@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
       
        if ([result[@"code"] isEqualToString:@"1000"]) {
            
            if (_currentPage == 1) {
                [_dataArray removeAllObjects];
            }
            
            NSDictionary *datasDic = result[@"datas"];
            NSArray *rowsArr = datasDic[@"rows"];
            
            NSLog(@"商品列表————>%@",rowsArr);
            for (NSDictionary *subDic in rowsArr) {
                XNRMyEvaluationModel *model = [[XNRMyEvaluationModel alloc]init];
                [model setValuesForKeysWithDictionary:subDic];
                [_dataArray addObject:model];
            }
        } else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:result[@"message"] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
        }
        
        //刷新头部
        [self.tableview.legendHeader endRefreshing];
        //刷新尾部
        [self.tableview.legendFooter endRefreshing];
        //刷新列表
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络请求错误"];
        //刷新头部
        [self.tableview.legendHeader endRefreshing];
        //刷新尾部
        [self.tableview.legendFooter endRefreshing];
        //刷新列表
        [self.tableview reloadData];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 105;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID=@"QHXMy_evaluation";
    
    XNRMyEvaluation_Cell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        
        cell=[[ XNRMyEvaluation_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        
    }
    cell.cellIndexPath=indexPath;
    cell.delegate=self;
    cell.backgroundColor=[UIColor whiteColor];
    [cell setCellDataWithModel:_dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XNRMyEvaluationInfo_VC*vc=[[XNRMyEvaluationInfo_VC alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.infoDic=_dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)deleRowWithIndex:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",indexPath.row);
    
    
    [_dataArray removeObjectAtIndex:indexPath.row];
    [_tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [_tableview reloadData];
    
    
    
    
}

- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的评价";
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
