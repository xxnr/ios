//
//  XNRCityList_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/8.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRCityList_VC.h"

@interface XNRCityList_VC ()<UITableViewDataSource,UITableViewDelegate>{
    
    
}
@property (nonatomic, strong) NSMutableDictionary *cities;
@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation XNRCityList_VC

- (id)init
{
    self = [super init];
    if (self) {
        
        self.keys = [NSMutableArray array];
        self.arrayCitys = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    [self getCityData];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self setNavigationbarTitle];
    
    [self.view addSubview:_tableView];
    
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    
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
    
    NSString *key = [_keys objectAtIndex:section];
    
    titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    self.cityChoseBlock([[_cities objectForKey:key] objectAtIndex:indexPath.row]);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = XNRFont(18);
    }
    cell.textLabel.text = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    return cell;
}
- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择城市";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
     backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
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
