//
//  XNRLeaveMessage_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/6/5.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRLeaveMessage_VC.h"
#define TEXT_MAST_COUNT 100
@interface XNRLeaveMessage_VC ()<UITextViewDelegate>{
    
    
}
@property(nonatomic,strong)UITextView*textView;
@property(nonatomic,retain)UILabel*placehold;
@property(nonatomic,retain)UILabel*count_label;
@end

@implementation XNRLeaveMessage_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = R_G_B_16(0xf4f4f4);
    
    [self setNavigationbarTitle];
    [self createUI];

}
-(void)createUI{
    
    UIView*textBg=[[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 120*SCALE)];
    textBg.backgroundColor=[UIColor whiteColor];
    textBg.clipsToBounds=YES;
    textBg.layer.cornerRadius=5;
    [self.view addSubview:textBg];
    
    //输入文本
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20,110*SCALE )];
    _textView.backgroundColor=[UIColor clearColor];
    _textView.delegate=self;
    _textView.font=XNRFont(18);
    [textBg addSubview:_textView];
    //记录输入字数文本
    _count_label=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-30-150,10+90*SCALE , 150, 30*SCALE)];
    _count_label.textColor=[UIColor grayColor];
    
    _count_label.textAlignment=NSTextAlignmentRight ;
    _count_label.font=XNRFont(12);
    
    [textBg addSubview:_count_label];
    _placehold=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 250, 30*SCALE)];
    if ([_leaveMessageStr isEqualToString:@""]) {
        _placehold.text=@"请输入您想对卖家说的话";

    }
    else {
        _textView.text = _leaveMessageStr;
        _placehold.hidden = YES;
//        _placehold.text=_leaveMessageStr;

    }
    _placehold.adjustsFontSizeToFitWidth=YES;
    _placehold.textColor=R_G_B_16(0x717171);
    _placehold.font=XNRFont(18);
    [textBg addSubview:_placehold];
    
    //提交按钮
    
    UIButton*submit_button=[MyControl createButtonWithFrame:CGRectMake(20,140*SCALE+10 , ScreenWidth-40, 40*SCALE) ImageName:nil Target:self Action:@selector(submitClick) Title:@"提交"];
    [submit_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    submit_button.titleLabel.textColor=[UIColor whiteColor];
    submit_button.backgroundColor=R_G_B_16(0x11c422);
    submit_button.clipsToBounds=YES;
    submit_button.layer.cornerRadius=5;
    submit_button.titleLabel.font=XNRFont(18);
    [self.view addSubview:submit_button];
    
    
}

-(void)submitClick{
    
    if(self.textView.text.length==0){
        
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有输入任何内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"返回", nil];
        
        [al show];
        
    }else{
        NSString*url=[HOST stringByAppendingString:@"/app/order/addRemarksByOrderId"];
        [KSHttpRequest post:url parameters:@{@"locationUserId":[DataCenter account].userid,@"orderDataId":self.orderDataId,@"remarks":self.textView.text,@"user-agent":@"IOS-v2.0"} success:^(id result) {
            
            NSLog(@"%@",result);
            if([result[@"code"] integerValue] == 1000){
                
                
                self.MessageBlock(self.textView.text);
                [self.navigationController popViewControllerAnimated:YES];
                
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                
            }else{
                
                [UILabel showMessage:result[@"message"]];
                

            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error);
            self.MessageBlock(@"");
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"网络请求失败"];
        }];
        
        
        
        
        
        
    
    }
    
}
-(void)textViewDidChange:(UITextView *)textView{
    
    _count_label.text=[NSString stringWithFormat:@"可输入字数%d",TEXT_MAST_COUNT-(int)_textView.text.length];
    
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
    
}

- (void)setNavigationbarTitle{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1.0];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单留言";
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
