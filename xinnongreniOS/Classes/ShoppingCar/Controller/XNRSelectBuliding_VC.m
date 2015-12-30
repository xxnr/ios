//
//  XNRSelectBuliding_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRSelectBuliding_VC.h"
#define TEXT_MAST_COUNT 100
@interface XNRSelectBuliding_VC ()<UITextViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
     NSMutableArray*_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation XNRSelectBuliding_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=R_G_B_16(0xf8f8f8);
    
    NSLog(@"businessID-->%@",self.BusinessId);
    _dataArray=[NSMutableArray arrayWithObjects: nil];
    [self setNavigationbarTitle];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //获取商圈数据
    [self getData];

    // Do any additional setup after loading the view.
}
#pragma mark--获取商圈数据
-(void)getData{
    
    NSString *urlString = [HOST stringByAppendingString:@"app/build/getBuildByBusiness"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlString parameters:@{@"businessId":self.BusinessId,@"user-agent":@"IOS-v2.0"}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              //JSON解析
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              
              NSLog(@"dict = %@",dict);
              if([dict[@"code"] isEqualToString:@"1000"]){
                  
                  for(NSDictionary*dic in dict[@"datas"][@"rows"]){
                      
                      [CommonTool createModelFromDictionary:dic className:nil];
                      XNRBuildingModel*model=[[XNRBuildingModel alloc]init];
                      [model setValuesForKeysWithDictionary:dic];
                      [_dataArray addObject:model];
                      
                  }
                  [_tableView reloadData];
              }else{
                  
                  UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                  [al show];
                  
              }
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error = %@",error);
              [SVProgressHUD showErrorWithStatus:@"请求失败"];
          }];
    
    
}


#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XNRBuildingModel*model=_dataArray[indexPath.row];
    
    self.addressChoseBlock(model);
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
    XNRBuildingModel*model=_dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)setNavigationbarTitle{
    
    self.navigationItem.title = @"选择区";
    
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
