//
//  XNRSelectBusinessCircle_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRSelectBusinessCircle_VC.h"

@interface XNRSelectBusinessCircle_VC ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray*_dataArray;
    NSMutableArray*_areaDataArray;
}
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation XNRSelectBusinessCircle_VC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //模拟数据
    
    
    
    _dataArray=[[NSMutableArray alloc]init];
    _areaDataArray =[[NSMutableArray alloc]init];
    NSLog(@"currentCity-->%@",self.currentCity);
    self.view.backgroundColor=R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //获取商圈数据
    [self getData];
    
}

#pragma mark--获取商圈数据
-(void)getData{
    
    NSString *urlString = [HOST stringByAppendingString:@"app/businessDistrict/getBusinessByAreaId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlString parameters:@{@"areaId":self.currentCity,@"locationUserId":@"",@"user-agent":@"IOS-v2.0"}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              //JSON解析
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              
              NSLog(@"dict = %@",dict[@"message"]);
              if([dict[@"code"] isEqualToString:@"1000"])
              {
                  for(NSDictionary*dic in dict[@"datas"][@"rows"]){
                      
                      [_dataArray addObject:dic];
                      [_areaDataArray addObject:dic[@"name"]];
                  }
                  
                  [_tableView reloadData];
              }
              else
              {
                  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                  [alert show];
                  
              }
              
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error = %@",error);
          }];
    
    
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _areaDataArray.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.BusinessCircleChoseBlock(_dataArray[indexPath.row][@"name"],_dataArray[indexPath.row][@"id"]);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"selectBusiness";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = XNRFont(18);
    }
    cell.textLabel.text = _areaDataArray[indexPath.row];
    return cell;
}

- (void)setNavigationbarTitle{
    
    self.navigationItem.title = @"选择城市";
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
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
