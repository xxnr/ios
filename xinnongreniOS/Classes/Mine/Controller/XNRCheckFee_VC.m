//
//  XNRCheckFee_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/5.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRCheckFee_VC.h"
#import "XNRCheckFee_Cell.h"
#import "SJAvatarBrowser.h"
#import "ZSCPicShowView.h"
#import "PicInfo.h"
@interface XNRCheckFee_VC ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray*_dataArray;
}
@property(nonatomic,retain)UITableView*tableview;
@property(nonatomic,retain) UIImageView*feeImage;
@property (nonatomic,strong)ZSCPicShowView *zscPicShowView;
@end

@implementation XNRCheckFee_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray=[[NSMutableArray alloc]init];
    
    [self setNavigationbarTitle];
    [self createTab];
    [self createHeadView];
    [self createFootView];
    [self getData];
    

}
#pragma mark-获取模拟数据
-(void)getData{
    

    NSArray*arr=self.goodsArr;
    [_dataArray addObjectsFromArray:arr];

    
}
#pragma mark-创建tab
-(void)createTab{
    
    self.tableview.backgroundColor=[UIColor clearColor];
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
    self.tableview.showsHorizontalScrollIndicator=NO;
    self.tableview.showsVerticalScrollIndicator=NO;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    [self.view addSubview:self.tableview];

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID=@"XNRCheck";
    XNRCheckFee_Cell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        
        cell=[[XNRCheckFee_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.endAddress = self.endAddress;
    [cell setCellDataWithModel:_dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark-创建头部视图
-(void)createHeadView{
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    UILabel*productName=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 80, 20)];
    productName.text=@"产品名称";
    productName.font=XNRFont(12);
    productName.textColor=[UIColor blackColor];
    [headView addSubview:productName];
    UILabel*productNum=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 80, 20)];
    productNum.center=CGPointMake(ScreenWidth/2, 15);
    productNum.text=@"产品数量";
    productNum.textAlignment=NSTextAlignmentCenter;
    productNum.font=XNRFont(12);
    productNum.textColor=[UIColor blackColor];
    [headView addSubview:productNum];
    
    UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-80-40, 5, 80, 20)];
    line.text=@"运输路线";
    line.textAlignment=NSTextAlignmentRight;
    line.font=XNRFont(12);
    line.textColor=[UIColor blackColor];
    [headView addSubview:line];
    self.tableview.tableHeaderView=headView;
                                    
    
}
#pragma mark-底部视图
-(void)createFootView{
    
    UIView*footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    footView.backgroundColor=[UIColor whiteColor];
    
   _feeImage=[MyControl createImageViewWithFrame:CGRectMake(0,0, ScreenWidth, ScreenWidth) ImageName:@"feeinfo"];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTap)];
    tap.numberOfTapsRequired=1;
    [_feeImage addGestureRecognizer:tap];
    [footView addSubview:_feeImage];
    self.tableview.tableFooterView=footView;
    
}
#pragma mark-图片放大
-(void)dealTap{
    
    NSLog(@"图片放大");
   
    _zscPicShowView = [[ZSCPicShowView alloc]init];
    PicInfo *info = [[PicInfo alloc]init];
    info.picUrlStr = @"feeinfo";
    info.picOldFrame=[_feeImage convertRect:_feeImage.bounds toView:[UIApplication sharedApplication].keyWindow];
    _zscPicShowView.isNetWork = NO;
    NSMutableArray *marr = [[NSMutableArray alloc]initWithObjects:info, nil];
    [_zscPicShowView createUIWithPicInfoArr:marr andIndex:0];
    
    //[SJAvatarBrowser showImage:self.feeImage];
}
- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"运费说明";
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
