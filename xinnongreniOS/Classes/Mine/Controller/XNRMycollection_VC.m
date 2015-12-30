//
//  XNRMycollection_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMycollection_VC.h"
#import "XNRMyCollection_Cell.h"
@interface XNRMycollection_VC ()<UITableViewDataSource,UITableViewDelegate,MyCollectionCellDelegate>{
    
     NSMutableArray*_dataArray;
    
}
@property(nonatomic,retain)UITableView*tableview;
@end

@implementation XNRMycollection_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=R_G_B_16(0xf4f4f4);
    //模拟数据
    _dataArray=[[NSMutableArray alloc]initWithObjects:
                @{@"price":@"20000",
                  @"countPrice":@"12000"},
                
                @{@"price":@"10000",
                  @"countPrice":@"8000"},
                
                @{@"price":@"180000",
                  @"countPrice":@"130000"},
                
                @{@"price":@"130000",
                  @"countPrice":@"10000"},
        
                @{@"price":@"100000",
                  @"countPrice":@"80000"},
                
                @{@"price":@"103000",
                  @"countPrice":@"85000"},
                
                @{@"price":@"200500",
                  @"countPrice":@"208000"},nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.backgroundColor=[UIColor clearColor];
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableview.showsHorizontalScrollIndicator=NO;
    self.tableview.showsVerticalScrollIndicator=NO;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundColor=R_G_B_16(0xf4f4f4);
    [self.view addSubview:self.tableview];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self setNavigationbarTitle];
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    return 105;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID=@"QHXMy_evaluation";
    
   XNRMyCollection_Cell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        
        cell=[[ XNRMyCollection_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.cellIndexPath=indexPath;
    cell.delegate=self;
    cell.backgroundColor=[UIColor whiteColor];
    [cell setCellDataWithModel:_dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor=R_G_B_16(0xf4f4f4);
    
}

-(CGFloat)heightWithString:(NSString *)string
                     width:(CGFloat)width
                  fontSize:(CGFloat)fontSize
{
    
    
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:XNRFont(fontSize)} context:nil];
    
    return rect.size.height;
}

-(void)deleRowWithIndex:(NSIndexPath *)indexPath{
    
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
    titleLabel.text = @"我的收藏";
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
