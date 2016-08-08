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
#import "XNRInterestGroup.h"
#import "XNRInterestProModel.h"

@interface XNRSelProVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UILabel *selLabel;
@property (nonatomic,strong)NSMutableArray *allProGroup;
@property (nonatomic,strong)NSMutableArray *selProArr;
@property (nonatomic,weak)UIButton *isSelBtn;
@property (nonatomic,weak)UIButton *saveBtn;
@property (nonatomic,weak)UIView *bottomview;
@end

@implementation XNRSelProVC
-(NSMutableArray *)selPro
{
    if (!_selPro) {
        _selPro = [NSMutableArray array];
    }
    return _selPro;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigation];
    [self createBottomView];
    
    self.allProGroup = [NSMutableArray array];
    self.selProArr = [NSMutableArray array];
    [self.selProArr addObjectsFromArray:self.selPro];
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
    [KSHttpRequest get:KGetIntentionProductsTwo parameters:nil success:^(id result) {
        if ([result[@"code"]integerValue] == 1000) {
            self.allProGroup = (NSMutableArray *)[XNRInterestGroup objectArrayWithKeyValuesArray:result[@"intentionProducts"]];
            
            [self.tableView reloadData];
        }
        else
        {
            [UILabel showMessage:result[@"message"]];
        }
    } failure:^(NSError *error) {
    }];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, PX_TO_PT(89))];
    sectionView.backgroundColor = [UIColor whiteColor];
    XNRInterestGroup *groupModel = self.allProGroup[section];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:sectionView.bounds];
    [button setTag:section];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:button];

    UIImage *groupimage= [UIImage imageNamed:@"bar"];
    UIImageView *btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(27), groupimage.size.width, groupimage.size.height)];
    btnImage.image = groupimage;
    [sectionView addSubview:btnImage];
    
    UILabel *groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btnImage.frame)+PX_TO_PT(20), PX_TO_PT(28), ScreenWidth/2, PX_TO_PT(30))];
    groupLabel.text= groupModel.brand;
    groupLabel.textColor = R_G_B_16(0x323232);
    groupLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [sectionView addSubview:groupLabel];
    
    UIImage *image = [UIImage imageNamed:@"arrowt-1"];
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(32)-image.size.width, (button.frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
    arrow.image = image;
    [sectionView addSubview:arrow];
    
    UILabel *selLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-PX_TO_PT(73), sectionView.height)];
    self.selLabel  = selLabel;
    selLabel.textAlignment = NSTextAlignmentRight;
    selLabel.textColor = R_G_B_16(0x909090);
    selLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    [self alrealySel:section];
    
    [sectionView addSubview:selLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, sectionView.height-PX_TO_PT(2), ScreenWidth, PX_TO_PT(2))];
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [sectionView addSubview:line];
    
    if (groupModel.isOpen) {
        arrow.image = [UIImage imageNamed:@"arrowt2"];
    }else{
        arrow.image = [UIImage imageNamed:@"arrowt-1"];
    }
    
    return sectionView;
}
-(void)alrealySel:(NSInteger)section
{
    self.selLabel.hidden = NO;
    int count = 0;
    XNRInterestGroup *group = self.allProGroup[section];
    for (int i=0; i<group.products.count; i++) {
        if ([self.selPro containsObject:group.products[i]]) {
            count+=1;
        }
    }
    if (count == 0) {
        self.selLabel.hidden = YES;
    }
    else
    {
        self.selLabel.text = [NSString stringWithFormat:@"已选%d项",count];
    }
    

}
- (void)buttonPress:(UIButton *)sender//headButton点击
{
    XNRInterestGroup *groupModel = self.allProGroup[sender.tag];

    groupModel.isOpen = !groupModel.isOpen;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PX_TO_PT(89);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allProGroup.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XNRInterestGroup *group = self.allProGroup[section];
    return group.isOpen?group.products.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString static *cellID = @"cell";
   XNRSelPro_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XNRSelPro_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    XNRInterestGroup *group = self.allProGroup[indexPath.section];
    NSDictionary *model = group.products[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;

    XNRBtn *iconBtn = [[XNRBtn alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(89))];
    iconBtn.contentMode = UIViewContentModeScaleAspectFit;
    UIImageView *selImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth -PX_TO_PT(27)- PX_TO_PT(32), PX_TO_PT(30), PX_TO_PT(28), PX_TO_PT(19))];
    selImageView.image = [UIImage imageNamed:@"tick"];
    selImageView.hidden = YES;
    [iconBtn addSubview:selImageView];
    [iconBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchDown];
    iconBtn.indexPath = indexPath;
    
    XNRInterestGroup *item = self.allProGroup[iconBtn.indexPath.section];
    if ([self.selPro containsObject:item.products[iconBtn.indexPath.row]]) {
        iconBtn.selected = YES;
    }
    [cell.contentView addSubview:iconBtn];

    NSString *name = model[@"name"];
    cell.name = name;
    
    if (iconBtn.selected) {
        selImageView.hidden = NO;
        cell.proName.textColor = R_G_B_16(0x00B38A);
        
    }
    else
    {
        cell.proName.textColor = R_G_B_16(0x323232);
    }
    return cell;

}
-(void)iconClick:(XNRBtn*)sender
{
    XNRInterestGroup *group = self.allProGroup[sender.indexPath.section];

    if (sender.selected == NO) {
        sender.selected = YES;
        [self.selPro addObject:group.products[sender.indexPath.row]];
    }
    else
    {
        sender.selected = NO;
        [self.selPro removeObject:group.products[sender.indexPath.row]];
    }

    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.indexPath.row inSection:sender.indexPath.section];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self alrealySel:sender.indexPath.section];
    if (self.selPro.count>0) {
    [self.saveBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",self.selPro.count] forState:UIControlStateNormal];
    }
    else
    {
        [self.saveBtn setTitle:@"确定" forState:UIControlStateNormal];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(89);
}

-(void)createBottomView
{
    UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-PX_TO_PT(111), ScreenWidth, PX_TO_PT(111))];
    [self.view addSubview:bottomview];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(2))];
    line.backgroundColor = R_G_B_16(0xe0e0e0);
    [bottomview addSubview:line];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(15), PX_TO_PT(657), PX_TO_PT(81))];
    saveBtn.backgroundColor = R_G_B_16(0x00b38a);
    self.saveBtn = saveBtn;
    
    if (self.selPro.count>0) {
        [self.saveBtn setTitle:[NSString stringWithFormat:@"确定(%ld)",self.selPro.count] forState:UIControlStateNormal];
    }
    else
    {
        [self.saveBtn setTitle:@"确定" forState:UIControlStateNormal];
        
    }
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = PX_TO_PT(10);
    saveBtn.layer.masksToBounds = YES;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [saveBtn addTarget:self action:@selector(OKBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:saveBtn];
    
}


-(void)OKBtn
{
    NSMutableArray *selpro = [[NSMutableArray alloc]init];
    NSMutableArray *selproid = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in self.selPro) {
        [selpro addObject:dic[@"name"]];
        [selproid addObject:dic[@"_id"]];
    }
    NSDictionary *dic = @{@"selPro":self.selPro,@"selProArr":selpro,@"selProId_Arr":selproid};
    NSNotification *notification = [[NSNotification alloc]initWithName:@"selPro" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createNavigation{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(40)];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择意向商品";
    self.navigationItem.titleView = titleLabel;
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 30, 44);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"arrow_press"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(32), 0, 0);

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
