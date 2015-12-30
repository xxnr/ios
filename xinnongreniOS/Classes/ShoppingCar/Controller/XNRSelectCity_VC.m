//
//  XNRSelectCity_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRSelectCity_VC.h"
#define kCityListUrl @"api/v2.0/area/getAreaList"
@interface XNRSelectCity_VC ()<UITableViewDataSource,UITableViewDelegate>{
    
    
    NSMutableArray *_keyMarr;      //首字母
    NSMutableDictionary *_cityMdic;//城市字典
    NSMutableArray *_cityMarr;     //城市数组
}
@property (nonatomic,strong) UITableView *cityListTableView;//城市列表
@end

@implementation XNRSelectCity_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationbarTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    _cityMarr = [[NSMutableArray alloc]init];
    _cityMdic = [[NSMutableDictionary alloc]init];
    [self createCityListTableView];
    [self getData];
}

- (void)getData
{
    [KSHttpRequest post:KGetAreaList parameters:@{@"locationUserId":IS_Login?[DataCenter account].userid:@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        NSDictionary *datasDic = result[@"datas"];
        NSArray *rowArr = datasDic[@"rows"];
        
        NSMutableArray *tempCityMarr = [[NSMutableArray alloc]init];
        NSMutableArray *tempKeyMarr = [[NSMutableArray alloc]init];
        for (NSDictionary *subDic in rowArr) {
            CityModel *model = [[CityModel alloc]init];
            //KVC
            for (NSString *key in subDic)
            {
                [model setValue:([subDic[key] isKindOfClass:[NSNull class]]?@"＃":subDic[key]) forKey:key];
            }
            [tempCityMarr addObject:model];
            [tempKeyMarr addObject:model.shortName];
        }
        
        //数组去重
        NSSet *set = [NSSet setWithArray:tempKeyMarr];
        NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]]; //YES为升序,NO为降序
        NSArray *sortSetArray = [set sortedArrayUsingDescriptors:sortDesc];
        _keyMarr = [NSMutableArray arrayWithArray:sortSetArray];
        
        for (int i=0; i<_keyMarr.count; i++) {
            NSMutableArray *marr = [[NSMutableArray alloc]init];
            [_cityMdic setObject:marr forKey:_keyMarr[i]];
        }
        
        for (CityModel *model in tempCityMarr) {
            
            NSMutableArray *marr = _cityMdic[model.shortName];
            [marr addObject:model];
        }
        
        for (int i=0; i<_keyMarr.count; i++) {
            [_cityMarr addObject:_cityMdic[_keyMarr[i]]];
        }
        
        [self.cityListTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)createCityListTableView
{
    self.cityListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.cityListTableView.backgroundColor = [UIColor clearColor];
    self.cityListTableView.showsVerticalScrollIndicator = YES;
    self.cityListTableView.delegate = self;
    self.cityListTableView.dataSource = self;
    self.cityListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cityListTableView];
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    bgView.backgroundColor = R_G_B_16(0xf4f4f4);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 5, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = R_G_B_16(0x7f7f7f);
    titleLabel.font = XNRFont(16);
    
    NSString *key = [_keyMarr objectAtIndex:section];
    
    titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keyMarr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keyMarr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *marr = _cityMarr[section];
    return [marr count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityModel *model = _cityMarr[indexPath.section][indexPath.row];
    self.cityChoseBlock(model);
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = XNRFont(18);
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
    lineView.backgroundColor = R_G_B_16(0xf4f4f4);
    [cell.contentView addSubview:lineView];
    
    CityModel *model = _cityMarr[indexPath.section][indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}

- (void)setNavigationbarTitle{
    self.navigationItem.title = @"选择省份";
    
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
