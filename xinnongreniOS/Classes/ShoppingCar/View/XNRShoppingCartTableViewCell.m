//
//  XNRShoppingCartTableViewCell.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/26.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRShoppingCartTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XNRToolBar.h"
#import "XNRSKUAttributesModel.h"
#import "XNRShoppingCarFrame.h"
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
@property (nonatomic ,weak) UILabel *sectionOneLabel;
@property (nonatomic ,weak) UILabel *sectionTwoLabel;
@property (nonatomic ,weak)  UILabel *depositeLabel;      // 订金
@property (nonatomic ,weak) UILabel *finalPaymentLabel;   // 尾款


@property (nonatomic ,weak) UIView *topView;
@property (nonatomic ,weak) UIView *middleLine;
@property (nonatomic ,weak) UIView *bottomLine;


@property (nonatomic, weak) UIButton *bigRightBtn;

@property (nonatomic ,weak) UIImageView *selectedImage;

@property (nonatomic ,weak) UILabel *subscriptionLabel;
@property (nonatomic ,weak) UILabel *remainLabel;
@property (nonatomic, weak) UILabel *offLineLabel;

@property (nonatomic, weak) UILabel *numLabel;


@property (nonatomic ,weak) UIToolbar *toolBar;


@property (nonatomic,weak) UIButton *deleteBtn;         //删除

@property (nonatomic ,weak) UIView *textTopLine;
@property (nonatomic ,weak) UIView *textbottomLine;

@property (nonatomic, weak) UIButton *pushBtn;
@property (nonatomic, weak) UIButton *cancelBtn;

@property (nonatomic, copy) void(^com)(NSIndexPath *indexPath);
@end

@implementation XNRShoppingCartTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCom:(void (^)(NSIndexPath *))com {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.com = com;
        self.contentView.userInteractionEnabled = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
        
        // 注册消息通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_numTextField];
        // 接受编辑，删除按钮的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalBtnPresent) name:@"normalBtnPresent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBtnPresent) name:@"cancelBtnPresent" object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
-(void)cancelBtnPresent{
    if ([self.model.online integerValue] == 0) {// 下架 （点击编辑）
        self.goodNameLabel.frame = CGRectMake(CGRectGetMaxX(self.picImageView.frame)+PX_TO_PT(20), PX_TO_PT(40), ScreenWidth-CGRectGetMaxX(self.picImageView.frame)-PX_TO_PT(20)-PX_TO_PT(150), PX_TO_PT(80));
        [self createCancelBtn];
    }
    
}
-(void)normalBtnPresent{
    if ([self.model.online integerValue] == 0) {// 下架 （点击完成）
        self.goodNameLabel.frame = self.shoppingCarFrame.goodNameLabelF;
        [self.cancelBtn removeFromSuperview];
//        self.cancelBtn.hidden = YES;
    }
}


-(void)cancelBtnClick{
//    NSMutableArray *cancelArray = [NSMutableArray array];
    BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"确认要删除该商品吗?" chooseBtns:@[@"取消",@"确定"]];
    
    alertView.chooseBlock = ^void(UIButton *btn){
        
        if (btn.tag == 11) {
            if ([self.model.online integerValue] == 0) {
                if (!IS_Login) {
                    DatabaseManager *manager = [DatabaseManager sharedInstance];
                    [manager deleteShoppingCarWithModel:_model];
                    
                }else{
                    NSDictionary *params1 = @{@"userId":[DataCenter account].userid,@"SKUId":_model._id,@"quantity":@"0",@"additions":_model.additions,@"user-agent":@"IOS-v2.0"};
                    [KSHttpRequest post:KchangeShopCarNum parameters:params1 success:^(id result) {
                        if ([result[@"code"] integerValue] == 1000) {
                            [UILabel showMessage:@"删除成功"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
                         }
                    } failure:^(NSError *error) {
                        
                    }];
                    
                    
                }
                
            }

            
        
        }
    };
    [alertView BMAlertShow];
}

-(void)createCancelBtn{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(self.goodNameLabel.frame)+PX_TO_PT(80), PX_TO_PT(40), PX_TO_PT(60), PX_TO_PT(60));
    [cancelBtn setImage:[UIImage imageNamed:@"address_delete"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    [self.contentView addSubview:cancelBtn];
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
        self.rightBtn.enabled = NO;
      
    }else{
        self.rightBtn.enabled = YES;
    }
}


- (void)createUI
{

    // 选择按钮
    UIButton *selectedBtn = [[UIButton alloc] init];
    [selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectedBtn setImage:[UIImage imageNamed:@"address_circle"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"orange-icon"] forState:UIControlStateSelected];
    self.selectedBtn = selectedBtn;
    [self.contentView addSubview:selectedBtn];
    
    // 图片
    UIImageView *picImageView = [[UIImageView alloc]init];
    picImageView.contentMode = UIViewContentModeScaleAspectFit;
    picImageView.layer.borderWidth = PX_TO_PT(2);
    picImageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    self.picImageView = picImageView;
    [self.contentView addSubview:picImageView];
    
    // 商品名
    UILabel *goodNameLabel = [[UILabel alloc] init];
    goodNameLabel.textColor = R_G_B_16(0x323232);
    goodNameLabel.numberOfLines = 0;
    goodNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.goodNameLabel = goodNameLabel;
    [self.contentView addSubview:goodNameLabel];
    
    //属性
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.textColor = R_G_B_16(0x909090);
    introduceLabel.numberOfLines = 0;
    introduceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.introduceLabel = introduceLabel;
    [self.contentView addSubview:introduceLabel];
    
    // 数量
    [self createNumTextField];
    
    UILabel *presentPriceLabel = [[UILabel alloc]init];
    presentPriceLabel.textColor = R_G_B_16(0x323232);
    presentPriceLabel.textAlignment = NSTextAlignmentRight;
    presentPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.presentPriceLabel = presentPriceLabel;
    [self.contentView addSubview:self.presentPriceLabel];
    
    // 附加选项
    [self createAddtionsLabel];
    // 定金，尾款
    [self createDepositView];
    // 下架商品
    [self createSelectedBtn];
    // cell上按钮点击跳转
    [self createPushBtn];
}
-(void)createPushBtn
{
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn addTarget:self action:@selector(pushBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:pushBtn];
    self.pushBtn = pushBtn;
}

-(void)pushBtnClick{
    self.pushBlock(self.indexPath);
}

-(void)createDepositView{
    
    UILabel *sectionOneLabel = [[UILabel alloc] init];
    sectionOneLabel.text = @"阶段一: 订金";
    sectionOneLabel.textColor = R_G_B_16(0x323232);
    sectionOneLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    sectionOneLabel.textAlignment = NSTextAlignmentLeft;
    self.sectionOneLabel = sectionOneLabel;
    [self.contentView addSubview:sectionOneLabel];
        
    UILabel *sectionTwoLabel = [[UILabel alloc] init];
    sectionTwoLabel.text = @"阶段二: 尾款";
    sectionTwoLabel.textColor = R_G_B_16(0x323232);
    sectionTwoLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    sectionTwoLabel.textAlignment = NSTextAlignmentLeft;
    self.sectionTwoLabel = sectionTwoLabel;
    [self.contentView addSubview:sectionTwoLabel];
        
    UILabel *subscriptionLabel = [[UILabel alloc] init];
    subscriptionLabel.textColor = R_G_B_16(0xff4e00);
    subscriptionLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    subscriptionLabel.textAlignment = NSTextAlignmentRight;
    self.subscriptionLabel = subscriptionLabel;
    [self.contentView addSubview:subscriptionLabel];
        
    UILabel *remainLabel = [[UILabel alloc] init];
    remainLabel.textColor = R_G_B_16(0x323232);
    remainLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    remainLabel.textAlignment = NSTextAlignmentRight;
    self.remainLabel = remainLabel;
    [self.contentView addSubview:remainLabel];
    
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = R_G_B_16(0xc7c7c7);
    self.topView =  topView;
    [self.contentView addSubview:topView];
        
    UIView *middleLine = [[UIView alloc] init];
    middleLine.backgroundColor = R_G_B_16(0xc7c7c7);
    self.middleLine = middleLine;
    [self.contentView addSubview:middleLine];
        
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    self.bottomLine = bottomLine;
    [self.contentView addSubview:bottomLine];

}

#pragma mark - 下架商品
-(void)createSelectedBtn {
    
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
    UILabel *goodNameLabel = [[UILabel alloc] init];
    goodNameLabel.textColor = R_G_B_16(0x323232);
    goodNameLabel.numberOfLines = 0;
    goodNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.goodNameLabel = goodNameLabel;
    [self.contentView addSubview:goodNameLabel];
    
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.textColor = R_G_B_16(0x909090);
    introduceLabel.numberOfLines = 0;
    introduceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.introduceLabel = introduceLabel;
    [self.contentView addSubview:introduceLabel];
    
}

#pragma mark - 现价
- (void)createPresentPriceLabel
{
    UILabel *presentPriceLabel = [[UILabel alloc]init];
    presentPriceLabel.textColor = R_G_B_16(0x323232);
    presentPriceLabel.textAlignment = NSTextAlignmentRight;
    presentPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.presentPriceLabel = presentPriceLabel;
    [self.contentView addSubview:self.presentPriceLabel];
}
// 附加选项
-(void)createAddtionsLabel
{
    UILabel *addtionsLabel = [[UILabel alloc] init];
    addtionsLabel.textAlignment = NSTextAlignmentLeft;
    addtionsLabel.textColor = R_G_B_16(0x323232);
    addtionsLabel.numberOfLines = 0;
    addtionsLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    self.addtionsLabel = addtionsLabel;
    [self.contentView addSubview:addtionsLabel];
    
    UILabel *addtionPriceLabel = [[UILabel alloc]init];
    addtionPriceLabel.textColor = R_G_B_16(0x323232);
    addtionPriceLabel.textAlignment = NSTextAlignmentRight;
    addtionPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
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
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = kRightBtn;
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"icon_minus"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"discount_default1"] forState:UIControlStateHighlighted];
    [leftBtn setHighlighted:NO];
    self.leftBtn = leftBtn;
    [self.contentView addSubview:leftBtn];

    UITextField *numTextField = [[UITextField alloc]init];
    numTextField.textAlignment = NSTextAlignmentCenter;
    numTextField.borderStyle = UITextBorderStyleNone;
    numTextField.font =[UIFont systemFontOfSize:PX_TO_PT(28)];
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
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = kLeftBtn;
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    [rightBtn setImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"discount_default2"] forState:UIControlStateHighlighted];
    [rightBtn setHighlighted:NO];
    self.rightBtn = rightBtn;
    [self.contentView addSubview:rightBtn];
    
    UIView *textTopLine = [[UIView alloc] init];
    textTopLine.backgroundColor = R_G_B_16(0xc7c7c7);
    self.textTopLine = textTopLine;
    [self.contentView addSubview:textTopLine];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = R_G_B_16(0xc7c7c7);
    self.textbottomLine = bottomLine;
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
        self.model.num = @"1";
    }else if([textField.text integerValue] == 0){
        self.model.num = @"1";
        [UILabel showMessage:@"请输入正确的商品数量哦"];
        
    }else{
        self.model.num = textField.text;

    }
    
    self.changeBottomBlock();
    //刷新数据
    [self setupData];

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
    if ([self.model.num isEqualToString:@"9999"]) {
        self.rightBtn.enabled = NO;
    }else{
        self.rightBtn.enabled = YES;
    }

    self.changeBottomBlock();
    [self setupData];
    
    
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
// 设置所有控件的尺寸
-(void)setShoppingCarFrame:(XNRShoppingCarFrame *)shoppingCarFrame
{
    _shoppingCarFrame = shoppingCarFrame;
    
    // 1.设置数据
    [self setupData];
    
    // 2.设置frame
    [self setupFrame];
}

-(void)setupFrame{
    
    self.selectedBtn.frame = self.shoppingCarFrame.selectedBtnF;
    
    self.picImageView.frame = self.shoppingCarFrame.picImageViewF;
    
    self.goodNameLabel.frame = self.shoppingCarFrame.goodNameLabelF;
    
    self.introduceLabel.frame = self.shoppingCarFrame.attributesLabelF;
    
    self.leftBtn.frame = self.shoppingCarFrame.leftBtnF;
    self.numTextField.frame = self.shoppingCarFrame.numTextFieldF;
    self.rightBtn.frame = self.shoppingCarFrame.rightBtnF;
    
    self.presentPriceLabel.frame = self.shoppingCarFrame.PriceLabelF;
    
    self.addtionsLabel.frame = self.shoppingCarFrame.addtionsLabelF;
    self.addtionPriceLabel.frame = self.shoppingCarFrame.addtionPriceLabelF;
    
    self.topView.frame = self.shoppingCarFrame.topLineF;
    self.middleLine.frame = self.shoppingCarFrame.middleLineF;
    self.bottomLine.frame = self.shoppingCarFrame.bottomLineF;
    
    self.sectionOneLabel.frame = self.shoppingCarFrame.sectionOneLabelF;
    self.subscriptionLabel.frame = self.shoppingCarFrame.depositeLabelF;
    
    self.sectionTwoLabel.frame = self.shoppingCarFrame.sectionTwoLabelF;
    self.remainLabel.frame = self.shoppingCarFrame.finalPaymentLabelF;
    
    self.textTopLine.frame = self.shoppingCarFrame.textTopLineF;
    
    self.textbottomLine.frame = self.shoppingCarFrame.textbottomLineF;
    
    self.pushBtn.frame = self.shoppingCarFrame.pushBtnF;
    
    self.numLabel.frame = self.shoppingCarFrame.onlineLabelF;

}
#pragma mark - 设置现在的数据
- (void)setupData
{
    self.cancelBtn.hidden = YES;
    XNRShoppingCartModel *model = self.shoppingCarFrame.shoppingCarModel;
    _model = model;
    if (model.selectState) {
        self.selectedBtn.selected = YES;
        
    }else{
        self.selectedBtn.selected = NO;
    }

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,model.imgUrl];
    //图片
    
    if (urlStr == nil || [urlStr isEqualToString:@""]) {
        [self.picImageView setImage:[UIImage imageNamed:@"icon_placehold"]];
    }else{
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    }


    NSLog(@"-----------%@",model.additions);
    //商品名
    self.goodNameLabel.text = model.productName;

    // 属性
    NSMutableString *displayStr = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary *subDic in model.attributes) {
        [displayStr appendString:[NSString stringWithFormat:@"%@:%@;",[subDic objectForKey:@"name"],[subDic objectForKey:@"value"]]];
    }
    self.introduceLabel.text = displayStr;
    
    // 附加选项
    NSMutableString *addtionStr = [[NSMutableString alloc] initWithString:@""];
    NSString *price;
    CGFloat totalPrice = 0;
    for (NSDictionary *subDic in model.additions) {
        [addtionStr appendString:[NSString stringWithFormat:@"%@;",[subDic objectForKey:@"name"]]];
        price = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"price"]];
        totalPrice = totalPrice + [price doubleValue];
    }
    // 附加选项
    self.addtionsLabel.text = [NSString stringWithFormat:@"附加项目:%@",addtionStr];
    
    // 附加选项价格
    self.addtionPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    
    //现价
    self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price.doubleValue];

    // 订金

    self.subscriptionLabel.text = [NSString stringWithFormat:@"￥%.2f",model.deposit.doubleValue *[_model.num integerValue]];
    // 尾款
    self.remainLabel.text = [NSString stringWithFormat:@"￥%.2f",(model.price.doubleValue + totalPrice - model.deposit.doubleValue)*[model.num integerValue]];
    
    if (_model.num == 0) {
        self.numTextField.text = @"1";
    }else{
        self.numTextField.text = [NSString stringWithFormat:@"%@",model.num];
    }
    
    // 下架
    if ([model.online integerValue] == 0) {
        self.selectedBtn.hidden = YES;
        self.offLineLabel.hidden = NO;
        self.cancelBtn.hidden = NO;

        self.backgroundColor = R_G_B_16(0xf0f0f0);
        self.goodNameLabel.textColor = R_G_B_16(0x909090);
        self.presentPriceLabel.textColor = R_G_B_16(0x909090);
        self.sectionOneLabel.textColor = R_G_B_16(0x909090);
        self.sectionTwoLabel.textColor = R_G_B_16(0x909090);
        self.subscriptionLabel.textColor = R_G_B_16(0x909090);
        self.remainLabel.textColor = R_G_B_16(0x909090);
        self.addtionsLabel.textColor = R_G_B_16(0x909090);
        self.addtionPriceLabel.textColor = R_G_B_16(0x909090);
        
        self.leftBtn.hidden = YES;
        self.numTextField.hidden = YES;
        self.rightBtn.hidden = YES;
        self.textTopLine.hidden = YES;
        self.textbottomLine.hidden = YES;
        
        if (!_numLabel) {
            UILabel *numLabel = [[UILabel alloc] init];
            numLabel.textColor = R_G_B_16(0x909090);
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.text = [NSString stringWithFormat:@"x %@",model.num];
            self.numLabel = numLabel;
            [self.contentView addSubview:numLabel];

        }
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBtn.hidden = NO;
        self.offLineLabel.hidden = YES;
        self.cancelBtn.hidden = YES;
        
        self.leftBtn.hidden = NO;
        self.numTextField.hidden = NO;
        self.rightBtn.hidden = NO;
        self.textTopLine.hidden = NO;
        self.textbottomLine.hidden = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        self.goodNameLabel.textColor = R_G_B_16(0x323232);
        self.presentPriceLabel.textColor = R_G_B_16(0x323232);
        self.sectionOneLabel.textColor = R_G_B_16(0x323232);
        self.sectionTwoLabel.textColor = R_G_B_16(0x323232);
        self.subscriptionLabel.textColor = R_G_B_16(0xff4e00);
        self.remainLabel.textColor = R_G_B_16(0x323232);
        self.addtionsLabel.textColor = R_G_B_16(0x323232);
        self.addtionPriceLabel.textColor = R_G_B_16(0x323232);

    }
    
}


#pragma mark - 请求单个商品总数提交
- (void)requestShoppingCarURL
{
    [KSHttpRequest post:KchangeShopCarNum parameters:@{@"SKUId":self.model._id,@"quantity":self.numTextField.text,@"userId":[DataCenter account].userid,@"additions":_model.additions,@"update_by_add":@"ture",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        NSLog(@"=====%@",self.numTextField.text);
        NSLog(@"%@",result);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNum" object:self];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
