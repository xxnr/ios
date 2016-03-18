//
//  XNRShoppingCartTableViewCell.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRShoppingCartTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CoreTFManagerVC.h"
#import "XNRToolBar.h"
#import "XNRSKUAttributesModel.h"
#define kLeftBtn  1000
#define kRightBtn 2000

@interface XNRShoppingCartTableViewCell ()<UITextFieldDelegate,UIAlertViewDelegate,XNRToolBarBtnDelegate>
{
    UIView *_bgView;                  //键盘遮罩
    NSMutableArray*_tempShopCarArr;   //本地临时数据
    float *siglePrice;
    BOOL sort;
    int _keyBoardHeight;
}
@property (nonatomic,strong) XNRShoppingCartModel *model;
@property (nonatomic ,weak) UIButton *selectedBtn;
@property (nonatomic,weak) UIImageView *picImageView;   //图片
@property (nonatomic,weak) UILabel *goodNameLabel;      //商品
@property (nonatomic,weak) UILabel *introduceLabel;     // 商品介绍
@property (nonatomic,weak) UILabel *presentPriceLabel;  //现价格
@property (nonatomic,weak) UITextField *numTextField;   //数量
@property (nonatomic,weak) UILabel *addtionsLabel;
@property (nonatomic,weak) UILabel *addtionPriceLabel;
@property (nonatomic ,weak) UIButton *leftBtn;
@property (nonatomic ,weak) UIButton *rightBtn;
@property (nonatomic, weak) UIButton *bigRightBtn;

@property (nonatomic ,weak) UIImageView *selectedImage;

@property (nonatomic ,weak) UILabel *sectionOneLabel;
@property (nonatomic ,weak) UILabel *sectionTwoLabel;
@property (nonatomic ,weak) UIView *middleLine;
@property (nonatomic ,weak) UIView *bottomLine;

@property (nonatomic ,weak) UILabel *subscriptionLabel;
@property (nonatomic ,weak) UILabel *remainLabel;
@property (nonatomic, weak) UILabel *offLineLabel;

@property (nonatomic ,weak) UIToolbar *toolBar;


@property (nonatomic,weak) UIButton *deleteBtn;         //删除
@property (nonatomic ,weak)  UILabel *depositeLabel;      // 订金
@property (nonatomic ,weak) UILabel *finalPaymentLabel;   // 尾款

@property (nonatomic, weak) UIView *topView;


@property (nonatomic, copy) void(^com)(NSIndexPath *indexPath);
@end

@implementation XNRShoppingCartTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCom:(void (^)(NSIndexPath *))com {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.com = com;
        self.contentView.userInteractionEnabled = YES;
        [self createUI];
        
        // 注册消息通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_numTextField];
    }
    return self;
}

-(void)textFieldChanged:(NSNotification*)noti {
    
    if([self.numTextField.text isEqualToString:@"0"]){
        self.numTextField.text = @"1";
    }else{
        
    }
    if (self.numTextField.text.length>4) {
        self.numTextField.text = [self.numTextField.text substringToIndex:4];
    }
    if ([self.numTextField.text isEqualToString:@"9999"]) {
      
    }
}


- (void)createUI
{
    // 选择按钮
    [self createSelectedBtn];
    // 图片
    [self createPicImageView];
    // 商品名
    [self createGoodNameLabel];
    // 价格
    [self createPresentPriceLabel];
    // 数量
    [self createNumTextField];
    // 附加选项
//    [self createAddtionsLabel];
    // 订金，尾款
//    [self createDepositView:];
    
}

-(void)createDepositView:(XNRShoppingCartModel *)model{
    
    if (model.additions.count == 0) {
        UILabel *sectionOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectedBtn.frame) + PX_TO_PT(20), PX_TO_PT(300), ScreenWidth, PX_TO_PT(80))];
        sectionOneLabel.text = @"阶段一: 订金";
        sectionOneLabel.textColor = R_G_B_16(0x323232);
        sectionOneLabel.font = [UIFont systemFontOfSize:14];
        sectionOneLabel.textAlignment = NSTextAlignmentLeft;
        self.sectionOneLabel = sectionOneLabel;
        [self.contentView addSubview:sectionOneLabel];
        
        UILabel *sectionTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectedBtn.frame) + PX_TO_PT(20), PX_TO_PT(380), ScreenWidth, PX_TO_PT(80))];
        sectionTwoLabel.text = @"阶段二: 尾款";
        sectionTwoLabel.textColor = R_G_B_16(0x323232);
        sectionTwoLabel.font = [UIFont systemFontOfSize:14];
        sectionTwoLabel.textAlignment = NSTextAlignmentLeft;
        self.sectionTwoLabel = sectionTwoLabel;
        [self.contentView addSubview:sectionTwoLabel];
        
        UILabel *subscriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(300), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
        subscriptionLabel.textColor = R_G_B_16(0xff4e00);
        subscriptionLabel.font = [UIFont systemFontOfSize:16];
        subscriptionLabel.textAlignment = NSTextAlignmentRight;
        self.subscriptionLabel = subscriptionLabel;
        [self.contentView addSubview:subscriptionLabel];
        
        UILabel *remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth /2, PX_TO_PT(380), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
        remainLabel.textColor = R_G_B_16(0x323232);
        remainLabel.font = [UIFont systemFontOfSize:16];
        remainLabel.textAlignment = NSTextAlignmentRight;
        self.remainLabel = remainLabel;
        [self.contentView addSubview:remainLabel];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(300), ScreenWidth, PX_TO_PT(1))];
        topView.backgroundColor = R_G_B_16(0xc7c7c7);
        self.topView = topView;
        [self.contentView addSubview:topView];
        
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(380), ScreenWidth-PX_TO_PT(64), PX_TO_PT(1))];
        middleLine.backgroundColor = R_G_B_16(0xc7c7c7);
        self.middleLine = middleLine;
        [self.contentView addSubview:middleLine];
        
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(460), ScreenWidth, PX_TO_PT(1))];
        bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
        self.bottomLine = bottomLine;
        [self.contentView addSubview:bottomLine];

    }else{
        UILabel *sectionOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectedBtn.frame) + PX_TO_PT(20), PX_TO_PT(350), ScreenWidth, PX_TO_PT(80))];
        sectionOneLabel.text = @"阶段一: 订金";
        sectionOneLabel.textColor = R_G_B_16(0x323232);
        sectionOneLabel.font = [UIFont systemFontOfSize:14];
        sectionOneLabel.textAlignment = NSTextAlignmentLeft;
        self.sectionOneLabel = sectionOneLabel;
        [self.contentView addSubview:sectionOneLabel];
        
        
        UILabel *sectionTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectedBtn.frame) + PX_TO_PT(20), PX_TO_PT(430), ScreenWidth, PX_TO_PT(80))];
        sectionTwoLabel.text = @"阶段二: 尾款";
        sectionTwoLabel.textColor = R_G_B_16(0x323232);
        sectionTwoLabel.font = [UIFont systemFontOfSize:14];
        sectionTwoLabel.textAlignment = NSTextAlignmentLeft;
        self.sectionTwoLabel = sectionTwoLabel;
        [self.contentView addSubview:sectionTwoLabel];
        
        
        UILabel *subscriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(350), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
        subscriptionLabel.textColor = R_G_B_16(0xff4e00);
        subscriptionLabel.font = [UIFont systemFontOfSize:16];
        subscriptionLabel.textAlignment = NSTextAlignmentRight;
        self.subscriptionLabel = subscriptionLabel;
        [self.contentView addSubview:subscriptionLabel];
        
        UILabel *remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth /2, PX_TO_PT(430), ScreenWidth/2-PX_TO_PT(32), PX_TO_PT(80))];
        remainLabel.textColor = R_G_B_16(0x323232);
        remainLabel.font = [UIFont systemFontOfSize:16];
        remainLabel.textAlignment = NSTextAlignmentRight;
        self.remainLabel = remainLabel;
        [self.contentView addSubview:remainLabel];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(350), ScreenWidth, PX_TO_PT(1))];
        topView.backgroundColor = R_G_B_16(0xc7c7c7);
//        topView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:topView];
        
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(430), ScreenWidth-PX_TO_PT(64), PX_TO_PT(1))];
        middleLine.backgroundColor = R_G_B_16(0xc7c7c7);
        self.middleLine = middleLine;
        [self.contentView addSubview:middleLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(510), ScreenWidth, PX_TO_PT(1))];
        bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
        self.bottomLine = bottomLine;
        [self.contentView addSubview:bottomLine];

    }

}

#pragma mark - 选择按钮
-(void)createSelectedBtn {
    
    UIButton *backgroundBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, PX_TO_PT(30), PX_TO_PT(100), PX_TO_PT(180))];
    [backgroundBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:backgroundBtn];
    
    UIButton *selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(102), PX_TO_PT(36), PX_TO_PT(36))];
    [selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectedBtn setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"orange-icon"] forState:UIControlStateSelected];
    self.selectedBtn = selectedBtn;
    [backgroundBtn addSubview:selectedBtn];
    
    // 下架
    UILabel *offLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(75), PX_TO_PT(42), PX_TO_PT(90))];
    offLineLabel.backgroundColor = R_G_B_16(0xc0c0c0);
    offLineLabel.text = @"已下架";
    offLineLabel.textColor = [UIColor whiteColor];
    offLineLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    offLineLabel.numberOfLines = 0;
    offLineLabel.layer.cornerRadius = 5.0;
    offLineLabel.layer.masksToBounds = YES;
    offLineLabel.textAlignment = NSTextAlignmentCenter;
    self.offLineLabel = offLineLabel;
    [self.contentView addSubview:offLineLabel];

}

-(void)selectedBtnClick:(UIButton *)sender {
    
    
    self.model.selectState = !self.model.selectState;
    if (self.com) {
        self.com(self.indexPath);
    }
    self.changeBottomBlock();

}

#pragma mark - 图片
- (void)createPicImageView
{
    UIImageView *picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.selectedBtn.frame) + PX_TO_PT(20), PX_TO_PT(30), PX_TO_PT(180), PX_TO_PT(180))];
    picImageView.contentMode = UIViewContentModeScaleAspectFit;
    picImageView.layer.borderWidth = PX_TO_PT(2);
    picImageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    self.picImageView = picImageView;
    [self.contentView addSubview:picImageView];
}

#pragma mark - 商品名
- (void)createGoodNameLabel
{
//    UILabel *goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.picImageView.frame) + PX_TO_PT(20), PX_TO_PT(30), ScreenWidth-CGRectGetMaxX(self.picImageView.frame) - PX_TO_PT(52), PX_TO_PT(100))];
    UILabel *goodNameLabel = [[UILabel alloc] init];
    goodNameLabel.textColor = R_G_B_16(0x323232);
    goodNameLabel.numberOfLines = 0;
    goodNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
//    goodNameLabel.backgroundColor = [UIColor redColor];
    self.goodNameLabel = goodNameLabel;
    [self.contentView addSubview:goodNameLabel];
    
    
    UILabel *introduceLabel = [[UILabel alloc] init];
                               
//    introduceLabel.backgroundColor = [UIColor redColor];
    introduceLabel.textColor = R_G_B_16(0x909090);
    introduceLabel.numberOfLines = 0;
    introduceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.introduceLabel = introduceLabel;
    [self.contentView addSubview:introduceLabel];
    
}

#pragma mark - 现价
- (void)createPresentPriceLabel
{
    UILabel *presentPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2,CGRectGetMaxY(self.picImageView.frame) + PX_TO_PT(20),ScreenWidth/2-PX_TO_PT(32),PX_TO_PT(48))];
    presentPriceLabel.textColor = R_G_B_16(0x323232);
    presentPriceLabel.textAlignment = NSTextAlignmentRight;
    presentPriceLabel.font = [UIFont systemFontOfSize:16];
    self.presentPriceLabel = presentPriceLabel;
    [self.contentView addSubview:self.presentPriceLabel];
}
// 附加选项
-(void)createAddtionsLabel
{
    UILabel *addtionsLabel = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.selectedBtn.frame) + PX_TO_PT(20), CGRectGetMaxY(self.presentPriceLabel.frame)+PX_TO_PT(10), ScreenWidth-PX_TO_PT(340), PX_TO_PT(68)) Font:PX_TO_PT(28) Text:nil];
    addtionsLabel.textAlignment = NSTextAlignmentLeft;
    addtionsLabel.textColor = R_G_B_16(0x323232);
//    addtionsLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
//    addtionsLabel.backgroundColor = [UIColor redColor];
    addtionsLabel.numberOfLines = 0;
    self.addtionsLabel = addtionsLabel;
    [self.contentView addSubview:addtionsLabel];
    
    UILabel *addtionPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2,CGRectGetMaxY(self.presentPriceLabel.frame)+PX_TO_PT(10),ScreenWidth/2-PX_TO_PT(32),PX_TO_PT(68))];
    addtionPriceLabel.textColor = R_G_B_16(0x323232);
    addtionPriceLabel.textAlignment = NSTextAlignmentRight;
    addtionPriceLabel.font = [UIFont systemFontOfSize:16];
    self.addtionPriceLabel = addtionPriceLabel;
    [self.contentView addSubview:self.addtionPriceLabel];
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
    UIButton *bigLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bigLeftBtn.frame = CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.picImageView.frame), CGRectGetMaxX(self.selectedBtn.frame) + PX_TO_PT(48), PX_TO_PT(88));
    bigLeftBtn.tag = kRightBtn;
//    bigLeftBtn.backgroundColor = [UIColor redColor];
    [bigLeftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:bigLeftBtn];
    
    UIButton *leftBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.selectedBtn.frame) + PX_TO_PT(20),CGRectGetMaxY(self.picImageView.frame) + PX_TO_PT(20),PX_TO_PT(48),PX_TO_PT(48)) ImageName:nil Target:self Action:nil Title:nil];
    leftBtn.tag = kRightBtn;
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"icon_minus"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"discount_default1"] forState:UIControlStateHighlighted];
    [leftBtn setHighlighted:NO];
    self.leftBtn = leftBtn;
    [self.contentView addSubview:leftBtn];

    UITextField *numTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame),CGRectGetMaxY(self.picImageView.frame) + PX_TO_PT(20),PX_TO_PT(84),PX_TO_PT(48))];
    numTextField.textAlignment = NSTextAlignmentCenter;
    numTextField.borderStyle = UITextBorderStyleNone;
    numTextField.font = XNRFont(14);
    numTextField.delegate = self;
    numTextField.text = @"1";
    numTextField.textColor = R_G_B_16(0x323232);
    numTextField.returnKeyType = UIReturnKeyDone;
    //设置键盘类型
    numTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.numTextField = numTextField;
    [self.contentView addSubview:numTextField];
    // 自定义工具栏
    XNRToolBar *toolBar = [[XNRToolBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(88))];
    toolBar.delegate = self;
    numTextField.inputAccessoryView = toolBar;
    
    
    UIButton *bigRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bigRightBtn.frame = CGRectMake(CGRectGetMaxX(self.numTextField.frame), CGRectGetMaxY(self.picImageView.frame), PX_TO_PT(88), PX_TO_PT(88));
    bigRightBtn.tag = kLeftBtn;
//    bigRightBtn.backgroundColor = [UIColor redColor];
    [bigRightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.bigRightBtn = bigRightBtn;
    [self.contentView addSubview:bigRightBtn];

    
    UIButton *rightBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.numTextField.frame), CGRectGetMaxY(self.picImageView.frame) + PX_TO_PT(20), PX_TO_PT(48),PX_TO_PT(48)) ImageName:nil Target:self Action:nil Title:nil];
    rightBtn.tag = kLeftBtn;
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    [rightBtn setImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"discount_default2"] forState:UIControlStateHighlighted];
    [rightBtn setHighlighted:NO];
    self.rightBtn = rightBtn;
    [self.contentView addSubview:rightBtn];
    
    UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame), CGRectGetMaxY(self.picImageView.frame) + PX_TO_PT(21), PX_TO_PT(84), PX_TO_PT(1))];
    topline.backgroundColor = R_G_B_16(0xc7c7c7);
    [self.contentView addSubview:topline];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame),  CGRectGetMaxY(self.picImageView.frame) + PX_TO_PT(66), PX_TO_PT(84), PX_TO_PT(1))];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [self.contentView addSubview:bottomLine];
}

-(void)XNRToolBarBtnClick
{
    [self dealTap:nil];
}

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
//        textField.text = @"0";
        self.model.num = @"1";
    }else if([textField.text integerValue] == 0){
//        textField.text = @"1";
        self.model.num = @"1";
        [UILabel showMessage:@"请输入正确的商品数量哦"];
        
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
        self.model.num = [NSString stringWithFormat:@"%d",self.model.num.intValue+1];

        }else if (button.tag == kRightBtn) {
        self.model.num = [NSString stringWithFormat:@"%d",self.model.num.intValue-1];
        if (self.model.num.intValue<1) {
            self.model.num = @"1";
            [UILabel showMessage:@"数量不能再减少了"];
        }

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
    
    self.addtionsLabel.hidden = YES;
    self.addtionPriceLabel.hidden = YES;
    
    self.sectionOneLabel.hidden = YES;
    self.sectionTwoLabel.hidden = YES;
    self.subscriptionLabel.hidden = YES;
    self.remainLabel.hidden = YES;
    
//    self.topView.hidden = YES;
//    self.middleLine.hidden = YES;
//    self.bottomLine.hidden = YES;
    
    _model = model;
    if (_model.additions.count>0) {
        [self createAddtionsLabel];
    }
    [self createDepositView:_model];
    [self setSubViews];
    
    if (model.selectState) {
        self.selectedBtn.selected = YES;
    }else{
        self.selectedBtn.selected = NO;
    }
}

#pragma mark - 设置现在的数据
- (void)setSubViews
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,self.model.imgUrl];
    //图片
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    NSLog(@"-----------%@",self.model.additions);
    //商品名
    CGSize maxSize = CGSizeMake(ScreenWidth-CGRectGetMaxX(self.picImageView.frame) - PX_TO_PT(52), MAXFLOAT);
    CGSize goodNameLabelSize = [self.model.productName sizeWithFont_BSExt:self.goodNameLabel.font maxSize:maxSize];
    self.goodNameLabel.frame = CGRectMake(CGRectGetMaxX(self.picImageView.frame) + PX_TO_PT(20), PX_TO_PT(40),goodNameLabelSize.width, goodNameLabelSize.height);
    self.goodNameLabel.text = self.model.productName;

    // 属性
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in self.model.attributes) {
        [displayStr appendString:[NSString stringWithFormat:@"%@:%@;",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
    }
    CGSize maxSize1 = CGSizeMake(ScreenWidth-CGRectGetMaxX(self.picImageView.frame) - PX_TO_PT(52), MAXFLOAT);
    CGSize introduceLabelSize = [displayStr sizeWithFont_BSExt:self.introduceLabel.font maxSize:maxSize1];
    self.introduceLabel.frame = CGRectMake(CGRectGetMaxX(self.picImageView.frame) + PX_TO_PT(20), CGRectGetMaxY(self.goodNameLabel.frame)+PX_TO_PT(20),introduceLabelSize.width, introduceLabelSize.height);
    self.introduceLabel.text = displayStr;
    
    
    // 附加选项
    NSMutableString *addtionStr = [[NSMutableString alloc] initWithString:@""];
    NSString *price;
    CGFloat totalPrice = 0;
    for (NSDictionary *subDic in self.model.additions) {
        [addtionStr appendString:[NSString stringWithFormat:@"%@;",[subDic objectForKey:@"name"]]];
        price = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"price"]];
        totalPrice = totalPrice + [price floatValue];
    }
    // 附加选项
    self.addtionsLabel.text = [NSString stringWithFormat:@"附加项目:%@",addtionStr];
    // 附加选项价格
    self.addtionPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    //现价
    self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.price.floatValue];

    // 订金
    self.subscriptionLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.deposit.floatValue *[_model.num floatValue]];
    
    // 尾款
    self.remainLabel.text = [NSString stringWithFormat:@"￥%.2f",(self.model.price.floatValue + totalPrice - self.model.deposit.floatValue)*[_model.num floatValue]];
    
    if (self.model.additions.count == 0) {
        self.addtionsLabel.hidden = YES;
        self.addtionPriceLabel.hidden  = YES;
    }else{
        self.addtionsLabel.hidden = NO;
        self.addtionPriceLabel.hidden  = NO;
    
    }
    if(self.model.deposit &&[self.model.deposit floatValue]> 0){
        self.sectionOneLabel.hidden = NO;
        self.sectionTwoLabel.hidden = NO;
        self.subscriptionLabel.hidden = NO;
        self.remainLabel.hidden = NO;
        self.middleLine.hidden = NO;
        self.bottomLine.hidden = NO;
        self.presentPriceLabel.textColor = R_G_B_16(0x323232);


    }else{
        
        self.sectionOneLabel.hidden = YES;
        self.sectionTwoLabel.hidden = YES;
        self.subscriptionLabel.hidden = YES;
        self.remainLabel.hidden = YES;
        self.middleLine.hidden  = YES;
        self.bottomLine.hidden = YES;
        
        self.presentPriceLabel.textColor = R_G_B_16(0xff4e00);

    }
    if (_model.num == 0) {
        self.numTextField.text = @"1";
    }else{
        self.numTextField.text = [NSString stringWithFormat:@"%@",self.model.num];
    }
    // 下架
    if ([_model.online integerValue] == 0) {
        self.selectedBtn.hidden = YES;
        self.offLineLabel.hidden = NO;
        self.backgroundColor = R_G_B_16(0xf0f0f0);
        self.goodNameLabel.textColor = R_G_B_16(0x909090);
        self.presentPriceLabel.textColor = R_G_B_16(0x909090);
        self.sectionOneLabel.textColor = R_G_B_16(0x909090);
        self.sectionTwoLabel.textColor = R_G_B_16(0x909090);
        self.subscriptionLabel.textColor = R_G_B_16(0x909090);
        self.remainLabel.textColor = R_G_B_16(0x909090);

    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBtn.hidden = NO;
        self.offLineLabel.hidden = YES;
    }
    
}


#pragma mark - 请求单个商品总数提交
- (void)requestShoppingCarURL
{
    [KSHttpRequest post:KchangeShopCarNum parameters:@{@"SKUId":self.model._id,@"quantity":self.numTextField.text,@"userId":[DataCenter account].userid,@"additions":_model.additions,@"update_by_add":@"ture",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        NSLog(@"=====%@",self.numTextField.text);
        NSLog(@"%@",result);
//        [UILabel showMessage:@"购物车提交成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNum" object:self];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
//        [UILabel showMessage:@"购物车提交失败"];
    }];
}

- (void)awakeFromNib {
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
