//
//  XNRMyEvaluationInfo_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/27.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRMyEvaluationInfo_VC.h"
#import "CWStarRateView.h"
#import "UIImageView+WebCache.h"
@interface XNRMyEvaluationInfo_VC (){
    
    
}
@property(nonatomic,retain)UIScrollView*mainScrollView;
@property(nonatomic,retain)UIImageView*titleImage;     //主题图片
@property(nonatomic,retain)UILabel* goodsTitle;        //主题
@property(nonatomic,retain)UILabel* score;             //积分
@property(nonatomic,retain)UILabel* countPrice;        //现价
@property(nonatomic,retain)UILabel* price;             //原价
@property(nonatomic,retain)CWStarRateView*starRateView;//星级

@end

@implementation XNRMyEvaluationInfo_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=R_G_B_16(0xf4f4f4);
    //创建背景图
    self.mainScrollView = [MyControl createUIScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+0) contentSize:CGSizeMake(ScreenWidth, 600*SCALE) pagingEnabled:NO showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO delegate:self];
    self.mainScrollView.backgroundColor=R_G_B_16(0xf4f4f4);
    [self.view addSubview:self.mainScrollView];

    [self setNavigationbarTitle];
    [self createTopView];
    [self createBottomView];
    //获取网络数据
    [self getData];
    
    
}
#pragma mark-获取网络数据
-(void)getData{
    
     NSString*url=[HOST stringByAppendingString:@"/app/comment/commentDetails"];
    [KSHttpRequest post:url parameters:@{@"locationUserId":[DataCenter account].userid,@"goodsId":self.infoDic.goodsId,@"commentId":self.infoDic.ID,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        NSDictionary*dic=result[@"datas"][@"rows"][0];
        NSLog(@"result-->%@",dic);
        [_titleImage sd_setImageWithURL:[NSURL  URLWithString:[HOST stringByAppendingString:dic[@"imgUrl"]]] placeholderImage:[UIImage imageNamed:@"001"]];
        _goodsTitle.text=dic[@"goodsName"];
        _countPrice.text=[NSString stringWithFormat:@"￥ %@",dic[@"goodsUnitPrice"]];
        _price.text=[NSString stringWithFormat:@"原价 ￥%@",dic[@"goodsOriginalPrice"]];
        _starRateView.scorePercent =[dic[@"starValue"]floatValue]/5;
        NSMutableAttributedString*AttributedString=[[NSMutableAttributedString alloc]initWithString:_price.text];
        
        [AttributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, AttributedString.length)];
        
        //文本赋值
        [_price setAttributedText:AttributedString];
       
   } failure:^(NSError *error) {
       
       NSLog(@"%@",error);
       
   }];
    
    
    
}
#pragma mark-顶部视图
-(void)createTopView{
    
    UIView*bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
    bg.backgroundColor=[UIColor whiteColor];
    [self.mainScrollView addSubview:bg];
//主题图片
     self.titleImage=[MyControl createImageViewWithFrame:CGRectMake(10, 20, 80, 80) ImageName:@"001"];
    self.titleImage.contentMode = UIViewContentModeScaleAspectFit;
    [bg addSubview:self.titleImage];
//主题
    _goodsTitle=[[UILabel alloc]initWithFrame:CGRectMake(110, 20,ScreenWidth-120, 20)];
    _goodsTitle.text=@"江淮汽车s560超值";
    _goodsTitle.textColor=R_G_B_16(0x636363);
    _goodsTitle.font=XNRFont(16);
    [bg addSubview:_goodsTitle];
//积分折现
//     _score=[[UILabel alloc]initWithFrame:CGRectMake(110, 42, 200, 15)];
//    _score.text=@"400积分可抵现400元";
//    _score.textColor=R_G_B_16(0x92cf94);
//    _score.font=XNRFont(13);
//    [bg addSubview:_score];
//现价
    _countPrice=[[UILabel alloc]initWithFrame:CGRectMake(110, 65, 200, 20)];
    _countPrice.text=[NSString stringWithFormat:@"￥ %@",@"180000"];
    _countPrice.textColor=R_G_B_16(0x119f17);
    _countPrice.font=XNRFont(16);
    [bg addSubview:_countPrice];
//原价
    _price=[[UILabel alloc]initWithFrame:CGRectMake(110, 85, 200, 15)];
    _price.text=[NSString stringWithFormat:@"原价 ￥%@",@"180000"];
    _price.textColor=R_G_B_16(0xb1b1b1);
    _price.font=XNRFont(11);
    
    NSMutableAttributedString*AttributedString=[[NSMutableAttributedString alloc]initWithString:_price.text];
    
    [AttributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, AttributedString.length)];
    
    //文本赋值
    [_price setAttributedText:AttributedString];
    // [bg addSubview:_price];
    
//数量
//    
//    UILabel*Num=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-40, 70, 30, 20)];
//    Num.font=XNRFont(11);
//    Num.text=@"x1";
//    Num.textColor=R_G_B_16(0x646464);
//    NSMutableAttributedString*NumAttributedString=[[NSMutableAttributedString alloc]initWithString:Num.text];
//    
//    [NumAttributedString addAttribute:NSFontAttributeName value:XNRFont(18) range:NSMakeRange(1, NumAttributedString.length-1)];
//  
//    [Num setAttributedText:NumAttributedString];
//    [bg addSubview:Num];
    
    //星级评分
    
    
    UILabel*starRate=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, 100, 20)];
    starRate.text=@"星级评价";
    starRate.textColor=R_G_B_16(0x646464);
    starRate.font=XNRFont(15);
    [bg addSubview:starRate];
    _starRateView=[[CWStarRateView alloc]initWithFrame:CGRectMake(110, 125, 120, 25)];
    _starRateView.userInteractionEnabled=NO;
    _starRateView.scorePercent = 0;
    _starRateView.allowIncompleteStar = YES;
    _starRateView.hasAnimation = YES;
    [bg addSubview:_starRateView];
}
#pragma mark-底部视图
-(void)createBottomView{
    UIView*bg=[[UIView alloc]initWithFrame:CGRectMake(10, 190, ScreenWidth-20, 100)];
    bg.backgroundColor=[UIColor whiteColor];
    [self.mainScrollView addSubview:bg];
    UILabel*content=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-40, 50)];
    content.textColor=R_G_B_16(0xb1b1b1);
    content.font=XNRFont(14);
    content.numberOfLines=0;
    content.text=self.infoDic.content;
    [bg addSubview:content];
    
    CGFloat content_h=[self heightWithString:content.text width:ScreenWidth-40 fontSize:14];
    [self setHight:content andHight:content_h];
    [ self setHight:bg andHight:50+content_h ];
    
    
}

#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}

-(CGFloat)heightWithString:(NSString *)string
                     width:(CGFloat)width
                  fontSize:(CGFloat)fontSize
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XNRFont(fontSize)} context:nil];
    
    return rect.size.height;
}


- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"评价详情";
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
