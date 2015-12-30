//
//  XNREvaluationOrder_VC.m
//  xinnongreniOS
//
//  Created by marks on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNREvaluationOrder_VC.h"
#import "CWStarRateView.h"
#import "XNRMineController.h"
#import "XNRTabBarController.h"
#import "UIImageView+WebCache.h"
#define TEXT_MAST_COUNT 50
@interface XNREvaluationOrder_VC ()<UITextViewDelegate,CWStarRateViewDelegate>{
    CGFloat starValue;
    
}
@property(nonatomic,strong)UITextView*textView;
@property(nonatomic,retain)UILabel*placehold;
@property(nonatomic,retain)UILabel*count_label;
@property(nonatomic,retain)UIScrollView*mainScrollView;
@property(nonatomic,retain)CWStarRateView*starRateView;
@end

@implementation XNREvaluationOrder_VC

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
   
    
}
#pragma mark-顶部视图
-(void)createTopView{
    
    UIView*bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
    bg.backgroundColor=[UIColor whiteColor];
    [self.mainScrollView addSubview:bg];
    //主题图片
    UIImageView*titleImage=[MyControl createImageViewWithFrame:CGRectMake(10, 20, 80, 80) ImageName:nil];
    [bg addSubview:titleImage];
   
    [titleImage sd_setImageWithURL:[NSURL URLWithString:[HOST stringByAppendingString:self.model.imgs]] placeholderImage:[UIImage imageNamed:@"dingcan_image_product"]];
    //主题
    UILabel* title=[[UILabel alloc]initWithFrame:CGRectMake(110, 15,ScreenWidth-130 , 50)];
    title.text=self.model.goodsName;
    title.numberOfLines=2;
    title.textColor=R_G_B_16(0x636363);
    title.font=XNRFont(16);
    [bg addSubview:title];
//    //积分折现
//    UILabel* score=[[UILabel alloc]initWithFrame:CGRectMake(110, 42, 200, 15)];
//    score.text=@"400积分可抵现400元";
//    score.textColor=R_G_B_16(0x92cf94);
//    score.font=XNRFont(13);
//    [bg addSubview:score];
    //现价
    UILabel*countPrice=[[UILabel alloc]initWithFrame:CGRectMake(110, 65, 200, 20)];
    countPrice.text=[NSString stringWithFormat:@"￥ %@",self.model.unitPrice];
    countPrice.textColor=R_G_B_16(0x119f17);
    countPrice.font=XNRFont(16);
    [bg addSubview:countPrice];
    //原价
    UILabel* price=[[UILabel alloc]initWithFrame:CGRectMake(110, 85, 200, 15)];
    price.text=[NSString stringWithFormat:@"原价 ￥%@",self.model.originalPrice];
    price.textColor=R_G_B_16(0xb1b1b1);
    price.font=XNRFont(11);
    
    NSMutableAttributedString*AttributedString=[[NSMutableAttributedString alloc]initWithString:price.text];
    
    [AttributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, AttributedString.length)];
    
    //文本赋值
    [price setAttributedText:AttributedString];
    [bg addSubview:price];
    
    //数量
    
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
    _starRateView.scorePercent = 0;
    _starRateView.delegate=self;
    _starRateView.allowIncompleteStar = NO;
    _starRateView.hasAnimation = NO;
    [bg addSubview:_starRateView];
    
    
}
#pragma mark-底部视图
-(void)createBottomView{
    
    UIView*bg=[[UIView alloc]initWithFrame:CGRectMake(10, 190, ScreenWidth-20, 120*SCALE)];
    bg.backgroundColor=[UIColor whiteColor];
    
    [self.mainScrollView addSubview:bg];
    //输入文本
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20,110*SCALE )];
    _textView.backgroundColor=[UIColor clearColor];
    _textView.delegate=self;
    _textView.textColor=R_G_B_16(0x717171);
    _textView.font=XNRFont(18);
    [bg addSubview:_textView];
    //记录输入字数文本
    _count_label=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-30-150,10+90*SCALE , 150, 30*SCALE)];
    _count_label.textColor=[UIColor grayColor];
    
    _count_label.textAlignment=NSTextAlignmentRight ;
    _count_label.font=XNRFont(12);
    
    [bg addSubview:_count_label];
    _placehold=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 30*SCALE)];
    _placehold.text=@"亲，写点评价吧";
    _placehold.textColor=R_G_B_16(0x717171);
    _placehold.font=XNRFont(18);
    [bg addSubview:_placehold];
    
    
    UIButton*submit=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth-20-100, 200+120*SCALE, 100, 25) ImageName:nil Target:self Action:@selector(submit) Title:@"发表评价"];
    submit.backgroundColor=R_G_B_16(0x119f17);
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.clipsToBounds=YES;
    submit.layer.cornerRadius=5;
    submit.titleLabel.font=XNRFont(15);
    
    [self.mainScrollView addSubview:submit];
    //添加回收按钮的操作
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _textView.inputAccessoryView = toolBar;
    //工具栏上添加按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dealKeyBoard:)];
    item.tintColor = [UIColor blackColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[space,item];
    

}
-(void)dealKeyBoard:(UIBarButtonItem *)item
{
    [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
    [_textView resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.mainScrollView setContentOffset:CGPointMake(0, (190)) animated:NO];
    return YES;
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    
    starValue=newScorePercent*5;
    
    
}
-(void)submit{
  //提交评价
    
    NSLog(@"提交评价");
    
    
    if(_starRateView.scorePercent ==0){
        
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message: @"亲,你还没有打分呢" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [al show];

        
    }else if (_textView.text.length==0){
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message: @"亲,赏个脸说评论几句吧\(^o^)/~" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [al show];
    }else{

        [self commentGoodsRequest];
    }

}
#pragma mark-提交用户评价数据
-(void)commentGoodsRequest{
    NSString *url=[HOST stringByAppendingString:@"/app/comment/addGoodsComment"];
   [SVProgressHUD showWithStatus:@"评价提交中..."];
    [KSHttpRequest post:url parameters:@{@"locationUserId":[DataCenter account].userid,@"userId":[DataCenter account].userid,@"starValue": [NSString stringWithFormat:@"%.f",starValue],@"nickName":[DataCenter account].nickname,@"goodsId":self.model.goodsId.stringValue,@"content":[KSHttpRequest isBlankString:_textView.text]?@"":_textView.text,@"orderNo":self.orderNO,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if([result[@"code"] integerValue] == 1000){
            
            [SVProgressHUD  showSuccessWithStatus:@"提交成功"];
            
            [self stepIntoMine];
        }            else {
            [SVProgressHUD  showSuccessWithStatus:result[@"message"]];

        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        [SVProgressHUD  showErrorWithStatus:@"请求失败"];
        
    }];
    
}
-(void)stepIntoMine{
    
    XNRTabBarController *tabBarController = (XNRTabBarController*)self.tabBarController;
    tabBarController.selectedIndex=3;
    CATransition *myTransition=[CATransition animation];
    myTransition.duration=0.3;
    myTransition.type= @"fade";
    [tabBarController.view.superview.layer addAnimation:myTransition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
-(void)textViewDidChange:(UITextView *)textView{
    
    _count_label.text=[NSString stringWithFormat:@"可输入字数%d",TEXT_MAST_COUNT-(int)_textView.text.length];
    
    if(TEXT_MAST_COUNT-(int)_textView.text.length<20&&TEXT_MAST_COUNT-(int)_textView.text.length>10){
        
        _count_label.textColor=[UIColor orangeColor];
    }else if (TEXT_MAST_COUNT-(int)_textView.text.length<10){
        
        _count_label.textColor=[UIColor redColor];
    }else if (TEXT_MAST_COUNT-(int)_textView.text.length>20){
        
         _count_label.textColor=R_G_B_16(0x717171);
        
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    
    if (![text isEqualToString:@""])
        
    {
        
        _placehold.hidden = YES;
        
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        _placehold.hidden = NO;
        
    }
    
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = TEXT_MAST_COUNT-[new length];
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[text length]+res};
        if (rg.length>0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

#pragma mark-释放键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_textView endEditing:YES];
    
    
}

- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"评价订单";
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
