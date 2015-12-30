//
//  XNRShoppingCartTableViewCell.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRShoppingCartTableViewCell.h"
#import "UIImageView+WebCache.h"

#define kLeftBtn  1000
#define kRightBtn 2000

@interface XNRShoppingCartTableViewCell ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIView *_bgView;                  //键盘遮罩
    NSMutableArray*_tempShopCarArr;   //本地临时数据
    float *siglePrice;
}
@property (nonatomic,strong) XNRShoppingCartModel *model;
@property (nonatomic,strong) UIImageView *picImageView;   //图片
@property (nonatomic,strong) UILabel *goodNameLabel;      //商品
@property (nonatomic,strong) UILabel *originalPriceLabel; //原价格
@property (nonatomic,strong) UILabel *presentPriceLabel;  //现价格
@property (nonatomic,strong) UITextField *numTextField;   //数量
@property (nonatomic,strong) UIButton *deleteBtn;         //删除
@property (nonatomic ,weak)  UILabel *depositeLabel;

@end

@implementation XNRShoppingCartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self createPicImageView];
    [self createGoodNameLabel];
    [self createPresentPriceLabel];
    [self createOriginalPriceLabel];
    [self createNumTextField];
    [self createDeleteBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 89, ScreenWidth-20, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    [self.contentView addSubview:lineView];
}
#pragma mark - 图片
- (void)createPicImageView
{
    self.picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.picImageView];
}

#pragma mark - 商品名
- (void)createGoodNameLabel
{
    self.goodNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.picImageView.frame.origin.x+self.picImageView.frame.size.width+10, 10, ScreenWidth-45-70-10, 20)];
    self.goodNameLabel.textColor = [UIColor blackColor];
    self.goodNameLabel.numberOfLines = 0;
    self.goodNameLabel.font = XNRFont(14);
    [self.contentView addSubview:self.goodNameLabel];
}

#pragma mark - 现价
- (void)createPresentPriceLabel
{
    self.presentPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.picImageView.frame.origin.x+self.picImageView.frame.size.width+10, CGRectGetMaxY(self.goodNameLabel.frame)+ 20, 200, 20)];

    self.presentPriceLabel.textColor = R_G_B_16(0x119f17);
    self.presentPriceLabel.font = XNRFont(18);
    [self.contentView addSubview:self.presentPriceLabel];
}

#pragma mark - 原价
- (void)createOriginalPriceLabel
{
    self.originalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.picImageView.frame.origin.x+self.picImageView.frame.size.width+10, self.presentPriceLabel.frame.origin.y+self.presentPriceLabel.frame.size.height, 200, 20)];
    self.originalPriceLabel.textColor = [UIColor lightGrayColor];
    self.originalPriceLabel.font = XNRFont(12);
    [self.contentView addSubview:self.originalPriceLabel];
}


#pragma mark - 删除
- (void)createDeleteBtn
{
    UIImageView *deleteImg = [MyControl createImageViewWithFrame:CGRectMake(ScreenWidth-30, 10, 15, 15) ImageName:@"close_x"];
    [self.contentView addSubview:deleteImg];
    
    self.deleteBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-50, 0, 50, 40) ImageName:@"" Target:self Action:@selector(deleteClick:) Title:nil];
    self.deleteBtn.alpha = 0.5;
    [self.contentView addSubview:self.deleteBtn];
}

- (void)deleteClick:(UIButton *)button
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除该商品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
     
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else if (buttonIndex == 1){
        self.deleteBlock();
        
        if (IS_Login) {
            self.numTextField.text = @"0";
            [self requestShoppingCarURL];
        }
    }
}


#pragma mark - 数量
- (void)createNumTextField
{
    UIButton *leftBtn = [MyControl createButtonWithFrame:CGRectMake(ScreenWidth-60-40-10-10, 50, 30,30) ImageName:nil Target:self Action:@selector(btnClick:) Title:nil];
    leftBtn.tag = kLeftBtn;
    [leftBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [leftBtn setHighlighted:NO];
    [self.contentView addSubview:leftBtn];
    
    _numTextField = [[UITextField alloc]initWithFrame:CGRectMake(leftBtn.frame.origin.x+leftBtn.frame.size.width+5,50,40,30)];
    _numTextField.textAlignment = NSTextAlignmentCenter;
    _numTextField.borderStyle = UITextBorderStyleNone;
//    _numTextField.placeholder = @"0";
    _numTextField.font = XNRFont(14);
    _numTextField.delegate = self;
    _numTextField.textColor = [UIColor redColor];
    _numTextField.returnKeyType = UIReturnKeyDone;
    //设置键盘类型
    _numTextField.keyboardType=UIKeyboardTypeNumberPad;
    _numTextField.backgroundColor = R_G_B_16(0xf6f6f6);
    [self.contentView addSubview:_numTextField];
    
    UIButton *rightBtn = [MyControl createButtonWithFrame:CGRectMake(_numTextField.frame.origin.x+_numTextField.frame.size.width+5, 50, 30,30) ImageName:nil Target:self Action:@selector(btnClick:) Title:nil];
    rightBtn.tag = kRightBtn;
    [rightBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [rightBtn setHighlighted:NO];
    [self.contentView addSubview:rightBtn];
    
}

#pragma mark - textField代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.3;
    [AppKeyWindow addSubview:_bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTap:)];
    [_bgView addGestureRecognizer:tap];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0";
//        self.model.num = @"1";
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"数量不能再减少了" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//        [alert show];
        
    }else if([textField.text integerValue] == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入正确的商品数量哦" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        
    }else{
        self.model.num = textField.text;

    }
    self.changeBottomBlock();
    //刷新数据
    [self setSubViews];
    
    
    if (IS_Login) {
        //单次申请购物车接口
        [self requestShoppingCarURL];
    }else{
        DatabaseManager *manager = [DatabaseManager sharedInstance];
        self.model.timeStamp = [CommonTool timeSp];
        //更新数据库
        [manager updateShoppingCarWithModel:self.model];
    }
}

- (void)dealTap:(UITapGestureRecognizer *)tap
{
    [_bgView removeFromSuperview];
    _bgView = nil;
    [_numTextField resignFirstResponder];
}

- (void)btnClick:(UIButton *)button
{
    button.selected = !button.selected;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        button.selected = NO;
    });
    
    if (button.tag == kLeftBtn){
        self.model.num = [NSString stringWithFormat:@"%d",self.model.num.intValue-1];
        if (self.model.num.intValue<1) {
            self.model.num = @"1";
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"数量不能再减少了" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }
    }
    else  if (button.tag == kRightBtn) {
        self.model.num = [NSString stringWithFormat:@"%d",self.model.num.intValue+1];
    }
    
    self.changeBottomBlock();
    [self setSubViews];
    
    
    if (IS_Login) {
        //单次申请购物车接口
        [self requestShoppingCarURL];
    }else{
        DatabaseManager *manager = [DatabaseManager sharedInstance];
        self.model.timeStamp = [CommonTool timeSp];
        //更新数据库
        [manager updateShoppingCarWithModel:self.model];
    }
}

#pragma mark - 设置model数据模型的数据
- (void)setCellDataWithShoppingCartModel:(XNRShoppingCartModel *)model
{
    _model = model;
    [self resetSubViews];
    [self setSubViews];
}

#pragma mark - 清空以前的数据
- (void)resetSubViews
{
    
}

#pragma mark - 设置现在的数据
- (void)setSubViews
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl];
    //图片
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    
    //商品名
    self.goodNameLabel.text = self.model.goodsName;

    //现价
        if(!([self.model.deposit floatValue] > 0.00) || self.model.deposit == nil){
            self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.unitPrice];
            
        }else{
            self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.deposit.floatValue];
        }

    
    self.numTextField.text = [NSString stringWithFormat:@"%@",self.model.num];
    
    if ([self.numTextField.text isEqualToString:@"0"]) {
        self.numTextField.textColor = [UIColor lightGrayColor];
    }else{
        self.numTextField.textColor = [UIColor redColor];
    }
}


#pragma mark - 请求单个商品总数提交
- (void)requestShoppingCarURL
{
    [KSHttpRequest post:KchangeShopCarNum parameters:@{@"goodsId":self.model.goodsId,@"quantity":self.numTextField.text,@"userId":[DataCenter account].userid,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        NSLog(@"=====%@",self.numTextField.text);
        NSLog(@"%@",result);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNum" object:self];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"购物车提交失败"];
    }];
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
