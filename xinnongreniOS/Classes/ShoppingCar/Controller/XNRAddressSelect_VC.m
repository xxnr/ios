//
//  XNRAddressSelect_VC.m
//  xinnongreniOS
//
//  Created by 张国兵 on 15/7/1.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRAddressSelect_VC.h"
#import "XNRSelectCity_VC.h"//城市选择
#import "XNRSelectBuliding_VC.h"//
#import "XNRSelectBusinessCircle_VC.h"
#import "ZSCLabel.h"

#define TEXT_MAST_COUNT 100
#define kSaveAddressUrl @"api/v2.0/user/saveUserAddress"
#define kUpdateUserAddressUrl @"api/v2.0/user/updateUserAddress"

@interface XNRAddressSelect_VC ()<UITextFieldDelegate,UITextViewDelegate>{

        NSString*areaId;      //行政区域id
        NSString*BusinessId;  //商圈ID
        NSString*address;     //
        NSString*buildingID;  //楼宇ID
        UIView*textBg;
}
@property (nonatomic,strong) UIScrollView *  mainScrollView;
@property (nonatomic,strong) UITextField * recipientTextField; //收货人
@property (nonatomic,strong) UITextField * phoneNumTextField;  //电话号
@property (nonatomic,strong) UILabel * provincesLabel;         //省份
@property (nonatomic,strong) UILabel * cityLabel;              //城市
@property (nonatomic,strong) UILabel * countyLabel;            //区县
@property (nonatomic,strong) UITextField * addressTextField;   //地址
@property (nonatomic,strong) UIButton *selectBtn;              //默认地址按钮
@property(nonatomic,strong) UITextView*textView;
@property(nonatomic,strong) UILabel*placehold;
@property(nonatomic,strong) UILabel*count_label;

@end

@implementation XNRAddressSelect_VC

//消失时回收键盘
- (void)viewWillDisappear:(BOOL)animated
{
    [self.addressTextField resignFirstResponder];
    [self.recipientTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    areaId = self.model.areaId;
    
    //创建背景图
    self.mainScrollView = [MyControl createUIScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) contentSize:CGSizeMake(ScreenWidth, ScreenHeight-64+(20*4+45*3)) pagingEnabled:NO showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO delegate:self];
    self.mainScrollView.bounces = YES;
    self.mainScrollView.backgroundColor=R_G_B_16(0xf8f8f8);
    [self.view addSubview:self.mainScrollView];
    
    self.view.backgroundColor=R_G_B_16(0xf4f4f4);
    [self setNavigationbarTitle];
    [self createUI];
}

-(void)createUI{
   
    //收货人
    [self createRecipient];
    //手机号码
    [self createPhoneNum];
    //省份
    [self createProvinces];
    //城市
//    [self createCity];
    //区县
//    [self createCounty];
    //地址
    [self createAddress];
    //默认地址
    [self createSelectBtn];
    //提交按钮
    [self createCommitBtn];
    
    // 点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard:)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
}

#pragma mark - 收货人
- (void)createRecipient
{
    UILabel*recipientTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, 100, 45)];
    recipientTitle.text=@"收货人 :";
    recipientTitle.adjustsFontSizeToFitWidth=YES;
    recipientTitle.textAlignment=NSTextAlignmentLeft;
    recipientTitle.textColor=R_G_B_16(0x646464);
    recipientTitle.font=XNRFont(18);
    
    //设定内容样式
    NSMutableAttributedString * attributedString =
    [[NSMutableAttributedString alloc] initWithString:recipientTitle.text];
    //字符间距 2pt
    [attributedString addAttribute:NSKernAttributeName value:@10 range:NSMakeRange(0, attributedString.length-3)];
    [recipientTitle setAttributedText:attributedString];
   
    [self.mainScrollView addSubview:recipientTitle];
    
    UIButton*recipientBtn=[MyControl createButtonWithFrame:CGRectMake(recipientTitle.frame.origin.x+recipientTitle.frame.size.width+10, 20, ScreenWidth-recipientTitle.frame.size.width-40, 45) ImageName:nil Target:self Action:nil Title:nil];
    recipientBtn.backgroundColor=[UIColor whiteColor];
    [self.mainScrollView addSubview:recipientBtn];
    
    self.recipientTextField=[[UITextField alloc]initWithFrame:CGRectMake(recipientBtn.frame.origin.x+20, recipientBtn.frame.origin.y, recipientBtn.frame.size.width-45, recipientBtn.frame.size.height)];
    self.recipientTextField.placeholder=@"请填写收货人";
    if (self.model) {
        self.recipientTextField.text=self.model.receiptPeople;
    }
    [self.recipientTextField setValue:R_G_B_16(0xb7b7b7) forKeyPath:@"_placeholderLabel.textColor"];
    [self.recipientTextField setValue:XNRFont(15) forKeyPath:@"_placeholderLabel.font"];
    self.recipientTextField.keyboardType = UIKeyboardTypeDefault;
    self.recipientTextField.returnKeyType = UIReturnKeyDone;
    self.recipientTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.recipientTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.recipientTextField.delegate=self;

    [self.mainScrollView addSubview:self.recipientTextField];
}

#pragma mark - 手机号
- (void)createPhoneNum
{
    UILabel*phoneNumTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, self.recipientTextField.frame.origin.y+self.recipientTextField.frame.size.height+20, 100, 45)];
    phoneNumTitle.text=@"手机号码 :";
    phoneNumTitle.adjustsFontSizeToFitWidth=YES;
    phoneNumTitle.textAlignment=NSTextAlignmentLeft;
    phoneNumTitle.textColor=R_G_B_16(0x646464);
    phoneNumTitle.font=XNRFont(18);
    [self.mainScrollView addSubview:phoneNumTitle];
    
    UIButton*phoneNumBtn=[MyControl createButtonWithFrame:CGRectMake(phoneNumTitle.frame.origin.x+phoneNumTitle.frame.size.width+10,phoneNumTitle.frame.origin.y, ScreenWidth-phoneNumTitle.frame.size.width-40,45) ImageName:nil Target:self Action:nil Title:nil];
    phoneNumBtn.clipsToBounds=YES;
    phoneNumBtn.backgroundColor=[UIColor whiteColor];
    [self.mainScrollView addSubview:phoneNumBtn];
    
    self.phoneNumTextField=[[UITextField alloc]initWithFrame:CGRectMake(phoneNumBtn.frame.origin.x+20, phoneNumBtn.frame.origin.y, phoneNumBtn.frame.size.width-45, phoneNumBtn.frame.size.height)];
    self.phoneNumTextField.placeholder=@"请填写手机号";
    if (self.model) {
        self.phoneNumTextField.text=self.model.receiptPhone;
    }
    [self.phoneNumTextField setValue:R_G_B_16(0xb7b7b7) forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneNumTextField setValue:XNRFont(15) forKeyPath:@"_placeholderLabel.font"];
    self.phoneNumTextField.keyboardType=UIKeyboardTypePhonePad;
    self.phoneNumTextField.returnKeyType=UIReturnKeyDone;
    self.phoneNumTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.phoneNumTextField.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    self.phoneNumTextField.delegate=self;
    
    [self.mainScrollView addSubview:self.phoneNumTextField];
}

#pragma mark - 省份
- (void)createProvinces
{
    UILabel*provincesTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, self.phoneNumTextField.frame.origin.y+self.phoneNumTextField.frame.size.height+20, 100, 45)];
    provincesTitle.text=@"选择省份 :";
    provincesTitle.textAlignment=NSTextAlignmentLeft;
    provincesTitle.textColor=R_G_B_16(0x646464);
    provincesTitle.font=XNRFont(18);
    [self.mainScrollView addSubview:provincesTitle];
   
    UIButton*provincesBtn=[MyControl createButtonWithFrame:CGRectMake(provincesTitle.frame.origin.x+provincesTitle.frame.size.width+10,provincesTitle.frame.origin.y, ScreenWidth-provincesTitle.frame.size.width-40,45) ImageName:nil Target:self Action:@selector(provincesBtnClick:)  Title:nil];
    provincesBtn.backgroundColor=[UIColor whiteColor];
    [self.mainScrollView addSubview:provincesBtn];
    
    //主题
    self.provincesLabel=[[UILabel alloc]initWithFrame:CGRectMake(provincesBtn.frame.origin.x+20, provincesBtn.frame.origin.y, provincesBtn.frame.size.width-45, provincesBtn.frame.size.height)];
    self.provincesLabel.adjustsFontSizeToFitWidth=YES;
    self.provincesLabel.textAlignment=NSTextAlignmentLeft;
    self.provincesLabel.text=@"请选择省份";
    self.provincesLabel.textColor=R_G_B_16(0xb7b7b7);
    if (self.model) {
        self.provincesLabel.text=self.model.areaName;
        self.provincesLabel.textColor=[UIColor blackColor];
    }
    self.provincesLabel.font=XNRFont(15);
    [self.mainScrollView addSubview:self.provincesLabel];
    
    //箭头
    UIButton*arrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.frame=CGRectMake(provincesBtn.frame.size.width-20, 12*SCALE, 10, 18*SCALE);
    [arrowButton addTarget:self action:@selector(provincesBtnClick:) forControlEvents:UIControlEventTouchDown];
    [arrowButton setBackgroundImage:[UIImage imageNamed:@"未标题-1_05"] forState:UIControlStateNormal];
    [provincesBtn addSubview:arrowButton];
}

#pragma mark - 城市
- (void)createCity
{
    UILabel*cityTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, self.provincesLabel.frame.origin.y+self.provincesLabel.frame.size.height+20, 100, 45)];
    cityTitle.text=@"选择城市 :";
    cityTitle.adjustsFontSizeToFitWidth=YES;
    cityTitle.textAlignment=NSTextAlignmentLeft;
    cityTitle.textColor=R_G_B_16(0x646464);
    cityTitle.font=XNRFont(18);
    [self.mainScrollView addSubview:cityTitle];
    
    //城市背景
    UIButton*cityBtn=[MyControl createButtonWithFrame:CGRectMake(cityTitle.frame.origin.x+cityTitle.frame.size.width+10,cityTitle.frame.origin.y, ScreenWidth-cityTitle.frame.size.width-40,45) ImageName:nil Target:self Action:@selector(cityBtnClick:) Title:nil];
    cityBtn.clipsToBounds=YES;
    cityBtn.backgroundColor=[UIColor whiteColor];
    [self.mainScrollView addSubview:cityBtn];
    
    //主题
    self.cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(cityBtn.frame.origin.x+20, cityBtn.frame.origin.y, cityBtn.frame.size.width-45, cityBtn.frame.size.height)];
    self.cityLabel.adjustsFontSizeToFitWidth=YES;
    self.cityLabel.text=@"请选择城市";
    self.cityLabel.textAlignment=NSTextAlignmentLeft;
    self.cityLabel.font=XNRFont(15);
    self.cityLabel.textColor=R_G_B_16(0xb7b7b7);
    [self.mainScrollView addSubview:self.cityLabel];
    
    //箭头
    UIButton*arrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [arrowButton addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchDown];
    arrowButton.frame=CGRectMake(cityBtn.frame.size.width-20, 12*SCALE, 10, 18*SCALE);
    [arrowButton setBackgroundImage:[UIImage imageNamed:@"未标题-1_05"] forState:UIControlStateNormal];
    [cityBtn addSubview:arrowButton];
}

#pragma mark - 区县
- (void)createCounty
{
    UILabel*countyTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, self.cityLabel.frame.origin.y+self.cityLabel.frame.size.height+20, 100, 45)];
    countyTitle.text=@"选择区县 :";
    countyTitle.textAlignment=NSTextAlignmentLeft;
    countyTitle.textColor=R_G_B_16(0x646464);
    countyTitle.font=XNRFont(18);
    [self.mainScrollView addSubview:countyTitle];
    
    UIButton*countyBtn=[MyControl createButtonWithFrame:CGRectMake(countyTitle.frame.origin.x+countyTitle.frame.size.width+10,countyTitle.frame.origin.y, ScreenWidth-countyTitle.frame.size.width-40,45) ImageName:nil Target:self Action:@selector(countyBtnClick:) Title:nil];
    countyBtn.clipsToBounds=YES;
    countyBtn.backgroundColor=[UIColor whiteColor];
    [self.mainScrollView addSubview:countyBtn];
    
    self.countyLabel=[[UILabel alloc]initWithFrame:CGRectMake(countyBtn.frame.origin.x+20, countyBtn.frame.origin.y, countyBtn.frame.size.width-45, countyBtn.frame.size.height)];
    self.countyLabel.textAlignment=NSTextAlignmentLeft;
    self.countyLabel.adjustsFontSizeToFitWidth=YES;
    self.countyLabel.text=@"请选择区/县";
    self.countyLabel.font=XNRFont(15);
    self.countyLabel.textColor=R_G_B_16(0xb7b7b7);
    [self.mainScrollView addSubview:self.countyLabel];
    
    //箭头
    UIButton*arrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.frame=CGRectMake(countyBtn.frame.size.width-20, 12*SCALE, 10, 18*SCALE);
    [arrowButton addTarget:self action:@selector(countyBtnClick:) forControlEvents:UIControlEventTouchDown];
    [arrowButton setBackgroundImage:[UIImage imageNamed:@"未标题-1_05"] forState:UIControlStateNormal];
    [countyBtn addSubview:arrowButton];
}

#pragma mark - 地址
- (void)createAddress
{
    UILabel *addressTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, self.provincesLabel.frame.origin.y+self.provincesLabel.frame.size.height+20, 100, 45)];
    addressTitle.text=@"详细地址 :";
    addressTitle.adjustsFontSizeToFitWidth=YES;
    addressTitle.textAlignment=NSTextAlignmentLeft;
    addressTitle.textColor=R_G_B_16(0x646464);
    addressTitle.font=XNRFont(18);
    [self.mainScrollView addSubview:addressTitle];
   
    textBg=[[UIView alloc]initWithFrame:CGRectMake(addressTitle.frame.origin.x+addressTitle.frame.size.width+10,addressTitle.frame.origin.y, ScreenWidth-addressTitle.frame.size.width-40,100)];
    textBg.backgroundColor=[UIColor whiteColor];
    textBg.clipsToBounds=YES;
    textBg.layer.cornerRadius=0;
    [self.mainScrollView addSubview:textBg];
    
    
    //默认地址
    //输入文本
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(10,0, ScreenWidth-addressTitle.frame.size.width-50,70)];
    _textView.backgroundColor=[UIColor clearColor];
    _textView.delegate=self;
    NSString *defaultAddress=self.model.address;//[self.model.address stringByReplacingCharactersInRange:NSMakeRange(0, self.model.areaName.length) withString:@""];
    _textView.text=defaultAddress;
    
    _textView.font=XNRFont(15);
    [textBg addSubview:_textView];
    //记录输入字数文本
    _count_label=[[UILabel alloc]initWithFrame:CGRectMake(_textView.frame.size.width-150,70 , 140, 30)];
    _count_label.textColor=[UIColor grayColor];
    _count_label.text=@"可输入字数100";
    _count_label.hidden=YES;
    _count_label.textAlignment=NSTextAlignmentRight ;
    _count_label.font=XNRFont(12);
    [textBg addSubview:_count_label];
    
    _placehold=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    _placehold.text=@"请填写详细地址";
    _placehold.adjustsFontSizeToFitWidth=YES;
    _placehold.textColor=R_G_B_16(0xb7b7b7);
    _placehold.font=XNRFont(15);
    if(_textView.text.length!=0){
        _placehold.hidden=YES;
    }
    [textBg addSubview:_placehold];

    //添加回收按钮的操作
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _textView.inputAccessoryView = toolBar;
    //工具栏上添加按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dealKeyBoard:)];
    item.tintColor = [UIColor blackColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[space,item];
}

#pragma mark - 选择默认地址按钮
- (void)createSelectBtn
{
    UILabel *addressTitle=[[UILabel alloc]initWithFrame:CGRectMake(20,textBg.frame.origin.y+ textBg.frame.size.height+20, 100, 45)];
    addressTitle.text=@"默认地址 :";
    addressTitle.adjustsFontSizeToFitWidth=YES;
    addressTitle.textAlignment=NSTextAlignmentLeft;
    addressTitle.textColor=R_G_B_16(0x646464);
    addressTitle.font=XNRFont(18);
    [self.mainScrollView addSubview:addressTitle];
    
    _selectBtn = [MyControl createButtonWithFrame:CGRectMake(addressTitle.frame.origin.x+addressTitle.frame.size.width+10,addressTitle.frame.origin.y, 45,45) ImageName:nil Target:self Action:@selector(selectBtnClick:) Title:nil];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"dx_checkbox_off"] forState:UIControlStateNormal];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"dx_checkbox_on"] forState:UIControlStateSelected];
    if (self.model) {
        _selectBtn.selected = [self.model.type integerValue] == 1?YES:NO;
    }
    [self.mainScrollView addSubview:_selectBtn];
}

#pragma mark - 提交
- (void)createCommitBtn
{
    UIButton*commit_Button=[MyControl createButtonWithFrame:CGRectMake(20,_selectBtn.frame.origin.y+ _selectBtn.frame.size.height+20, ScreenWidth-40, 45) ImageName:@"nil" Target:self Action:@selector(commitClick) Title:@"完成"];
    commit_Button.clipsToBounds=YES;
    commit_Button.layer.cornerRadius=8;
    commit_Button.backgroundColor=R_G_B_16(0x11c422);
    [commit_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commit_Button.titleLabel.font=XNRFont(18);
    [self.mainScrollView addSubview:commit_Button];
}

#pragma mark - 默认地址被选中
- (void)selectBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
}

#pragma  mark-- 选择省份
-(void)provincesBtnClick:(UIButton *)button
{
    NSLog(@"省份");
    XNRSelectCity_VC *vc = [[XNRSelectCity_VC  alloc]init];
    [vc setCityChoseBlock:^(CityModel *model) {
        
        NSLog(@"city-->%@",model.name);
        self.provincesLabel.text=model.name;
        areaId=model.ID;
        
        self.cityLabel.text = @"请选择城市";
        self.countyLabel.text = @"请选择区/县";
        
        self.provincesLabel.textColor = [UIColor blackColor];
        self.cityLabel.textColor = R_G_B_16(0xb7b7b7);
        self.countyLabel.textColor = R_G_B_16(0xb7b7b7);
        
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

#pragma mark-选择城市
-(void)cityBtnClick:(UIButton *)button
{
    NSLog(@"城市");
    
    if([self.provincesLabel.text isEqualToString:@"请选择省份"]){
        
        
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"请先选择省份" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [al show];
    }else{
        
        XNRSelectBusinessCircle_VC*vc=[[XNRSelectBusinessCircle_VC alloc]init];
        
        vc.currentCity=areaId;
        
        
        [vc setBusinessCircleChoseBlock:^(NSString *BusinessCircle, NSString *BusinessID) {
            self.cityLabel.text=BusinessCircle;
            
            BusinessId=BusinessID;
            
            self.countyLabel.text = @"请选择区/县";
            
            self.provincesLabel.textColor = [UIColor blackColor];
            self.cityLabel.textColor =[UIColor blackColor];
            self.countyLabel.textColor = R_G_B_16(0xb7b7b7);
            
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark-选择县区
-(void)countyBtnClick:(UIButton *)button
{
    
    NSLog(@"选择县区");
    
    if([self.cityLabel.text isEqualToString:@"请选择城市"]){
        
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"请先选择城市" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [al show];
    }else{
        
        XNRSelectBuliding_VC*vc=[[XNRSelectBuliding_VC alloc]init];
        vc.BusinessId=BusinessId;
        
        [vc setAddressChoseBlock:^(XNRBuildingModel*model) {
            self.countyLabel.text=model.name ;
            buildingID=model.ID;
            
            self.provincesLabel.textColor = [UIColor blackColor];
            self.cityLabel.textColor =[UIColor blackColor];
            self.countyLabel.textColor = [UIColor blackColor];
            
            NSLog(@"%@",model.ID);
            
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark-完成
-(void)commitClick{
    
    NSLog(@"完成");
    
    if(self.recipientTextField.text.length!=0&&self.phoneNumTextField.text.length!=0&&![self.provincesLabel.text isEqualToString:@"请选择省份"]&&self.textView.text.length!=0){
        
        //验证手机号输入是否正确
        if (![self validateMobile:self.phoneNumTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号输入格式不正确" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        
        //if([self.from isEqualToString:@"新增地址"]||[self.from isEqualToString:@"编辑点击"]){
        
        if ([self.from isEqualToString:@"新增地址"]) {
            //保存地址
            [self saveAddress];
        }else{
            //修改地址
            [self updateAddress];
        }
        
        
        
       
            
        //}
//        else{
//
//        address=[NSString stringWithFormat:@"%@%@%@%@",self.provincesLabel.text,self.cityLabel.text,self.countyLabel.text,self.addressTextField.text];
//        
//        NSLog(@"address-->%@",address);
//        
//        [USER setObject:address forKey:@"QXHAddress"];
//        [USER synchronize];
//        self.addressBlockBlock();
//        }
    
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else{
        
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"请完善地址信息" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [al show];
        
    }
    
}

#pragma mark - 保存地址
//userId:用户ID, areaId：省份ID,address:手动填写的具体地址,type:（1.默认地址2.非默认地址）,receiptPhone:收货人手机号,receiptPeople：收货人名称
- (void)saveAddress
{
    [KSHttpRequest post:KSaveUserAddress parameters:@{@"userId":[DataCenter account].userid,@"areaId":areaId,@"address":_textView.text,@"type":_selectBtn.selected?@"1":@"2",@"receiptPhone":self.phoneNumTextField.text,@"receiptPeople":self.recipientTextField.text,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        LogRed(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            
            //默认地址被选中,则更新本地
            if (_selectBtn.selected) {
                UserInfo *info = [DataCenter account];
//                info.address = _textView.text;
                [NSString stringWithFormat:@"%@%@",self.provincesLabel.text,_textView.text];
                [DataCenter saveAccount:info];
                
                //刷新我的帐户默认发货地址
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyAccount" object:nil];
            }
            
            self.addressRefreshBlock();
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 修改地址
- (void)updateAddress
{

    //userId:用户ID, areaId：省份ID,address:手动填写的具体地址,type:（1.默认地址2.非默认地址）,receiptPhone:收货人手机号,receiptPeople：收货人名称
    
    [KSHttpRequest post:KUpdateUserAddress parameters:@{@"userId":[DataCenter account].userid,@"areaId":areaId,@"address":_textView.text,@"type":_selectBtn.selected?@"1":@"2",@"receiptPhone":self.phoneNumTextField.text,@"receiptPeople":self.recipientTextField.text,@"addressId":self.model.addressId,@"user-agent":@"IOS-v2.0"} success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            //默认地址被选中,则更新本地
            if (_selectBtn.selected) {
                UserInfo *info = [DataCenter account];
                info.address = [NSString stringWithFormat:@"%@%@",self.provincesLabel.text,_textView.text];
                [DataCenter saveAccount:info];
                
                //刷新我的帐户默认发货地址
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyAccount" object:nil];
            }
            self.addressRefreshBlock();
        }
        } failure:^(NSError *error) {
        
    }];
}

- (void)setNavigationbarTitle{
    
    self.navigationItem.title = @"选择地址";
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}


-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 正则表达式判断手机号格式
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
    
    
}

#pragma mark - 代理方法

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    [self.view endEditing:YES];
    return YES;
    
}

//点击屏幕收起键盘
- (void)hiddenKeyboard:(UITapGestureRecognizer *)tap
{
    //回收键盘
    [self.addressTextField resignFirstResponder];
    [self.recipientTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
}

#pragma mark -- UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    //回收键盘
//    [_homeNumField resignFirstResponder];
//
//}

-(void)dealKeyBoard:(UIBarButtonItem *)item
{
    [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
    [_textView resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.mainScrollView setContentOffset:CGPointMake(0, (20*4+45*3)) animated:NO];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (![textView.text isEqualToString:@""])
        
    {
        _placehold.hidden = YES;
        
    }
    
  

    _count_label.text=[NSString stringWithFormat:@"可输入字数%d",TEXT_MAST_COUNT-(int)_textView.text.length];
    
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    _count_label.hidden=NO;
    _count_label.text=[NSString stringWithFormat:@"可输入字数%d",TEXT_MAST_COUNT-(int)_textView.text.length];
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    _count_label.hidden=YES;
    
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
