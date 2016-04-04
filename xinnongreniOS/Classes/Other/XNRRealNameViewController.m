//
//  XNRRealNameViewController.m
//  xinnongreniOS
//
//  Created by ZSC on 15/5/28.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import "XNRRealNameViewController.h"
#import "PECropViewController.h"

//科目类型
typedef enum{
    kFront = 1,  //身份证正面
    kBack = 2    //身份证反面
}IdCardType;     //身份证类型

@interface XNRRealNameViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UITextFieldDelegate>
{
    UIView *_nameBg;
    UIView *_IdCardBg;
    UIView *_IdCardFrontBg;
    UIView *_IdCardBackBg;
    IdCardType _IdCardType; //身份证类型
}
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UITextField *nameTextField;      //姓名
@property (nonatomic,strong) UITextField *IdCardTextField;    //身份证
@property (nonatomic,strong) UILabel *midTitleLabel;          //中部标题
@property (nonatomic,strong) UIButton *finishButton;          //完成
@property (nonatomic,strong) UIImageView *IdCardFrontImageView; //身份证正面图
@property (nonatomic,strong) UIImageView *IdCardBackImageView;  //身份证背面图

@end

@implementation XNRRealNameViewController

#pragma mark - 键盘躲避
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = R_G_B_16(0xf2f2f2);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];
    [self createMainScrollView];
    [self createNameTextField];
    [self createIdCardTextField];
    [self createMidTitleLabel];
    [self createIdCardFront];
    [self createIdCardBack];
    [self createFinishBtn];
    
    self.mainScrollView.contentSize = CGSizeMake(ScreenWidth, 45*5+20+5+50+30+(ScreenWidth-40)*0.63*2+20);
}

#pragma mark - 创建主滚动视图
- (void)createMainScrollView
{
    self.mainScrollView = [MyControl createUIScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) contentSize:CGSizeMake(ScreenWidth, 0) pagingEnabled:NO showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO delegate:nil];
    [self.view addSubview:self.mainScrollView];
}

#pragma mark - 真实姓名
- (void)createNameTextField
{
    //姓名背景
    _nameBg=[[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 45)];
    _nameBg.backgroundColor=[UIColor whiteColor];
    _nameBg.layer.masksToBounds=YES;
    _nameBg.layer.cornerRadius=5;
    _nameBg.layer.borderColor=[R_G_B_16(0xdcdcdc)CGColor];
    _nameBg.layer.borderWidth=.5;
    [self.mainScrollView addSubview:_nameBg];
    
    self.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, _nameBg.frame.size.width-10, _nameBg.frame.size.height)];
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.placeholder = @"请输入您的姓名";
    self.nameTextField.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    self.nameTextField.delegate = self;
    //设置键盘类型
    self.nameTextField.keyboardType=UIKeyboardTypeDefault;
    self.nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.nameTextField.textAlignment = NSTextAlignmentLeft;
    [_nameBg  addSubview:self.nameTextField];

}

#pragma mark - 身份证号
- (void)createIdCardTextField
{
    //身份证背景
    _IdCardBg =[[UIView alloc]initWithFrame:CGRectMake(10, _nameBg.frame.origin.y+_nameBg.frame.size.height+10, ScreenWidth-20, 45)];
    _IdCardBg.backgroundColor=[UIColor whiteColor];
    _IdCardBg.layer.masksToBounds=YES;
    _IdCardBg.layer.cornerRadius=5;
    _IdCardBg.layer.borderColor=[R_G_B_16(0xdcdcdc)CGColor];
    _IdCardBg.layer.borderWidth=.5;
    [self.mainScrollView addSubview:_IdCardBg];
    
    self.IdCardTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, _IdCardBg.frame.size.width-10, _IdCardBg.frame.size.height)];
    self.IdCardTextField.borderStyle = UIKeyboardTypeDefault;
    self.IdCardTextField.placeholder = @"请输入您的身份证号";
    self.IdCardTextField.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    self.IdCardTextField.delegate = self;
    //设置键盘类型
    self.IdCardTextField.keyboardType=UIKeyboardTypeDefault;
    self.IdCardTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.IdCardTextField.textAlignment = NSTextAlignmentLeft;
    [_IdCardBg  addSubview:self.IdCardTextField];
}

#pragma mark - 中部标题
- (void)createMidTitleLabel
{
    self.midTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _IdCardBg.frame.origin.y+_IdCardBg.frame.size.height, 200, 30)];
    self.midTitleLabel.textColor = R_G_B_16(0xbebebe);
    self.midTitleLabel.text = @"上传证件照";
    self.midTitleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    [self.mainScrollView addSubview:self.midTitleLabel];
}

#pragma mark - 正面
- (void)createIdCardFront
{
    _IdCardFrontBg = [[UIView alloc]initWithFrame:CGRectMake(0, self.midTitleLabel.frame.origin.y+self.midTitleLabel.frame.size.height, ScreenWidth, 45)];
    _IdCardFrontBg.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:_IdCardFrontBg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, _IdCardFrontBg.frame.size.height)];
    label.textColor = R_G_B_16(0xbebebe);
    label.text = @"身份证正面";
    label.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [_IdCardFrontBg addSubview:label];
    
    UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectMake(ScreenWidth-20-10, (45-18)/2.0, 10, 18) ImageName:@"nextArrow"];
    [_IdCardFrontBg addSubview:imageView];
    
    UIButton *frontBtn = [MyControl createButtonWithFrame:_IdCardFrontBg.bounds ImageName:nil Target:self Action:@selector(frontBtnClick:) Title:nil];
    [_IdCardFrontBg addSubview:frontBtn];
    
    self.IdCardFrontImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, _IdCardFrontBg.frame.origin.y+_IdCardFrontBg.frame.size.height+5, ScreenWidth-40, (ScreenWidth-40)*0.63)];
    self.IdCardFrontImageView.image = [UIImage imageNamed:@"idCardFont.jpg"];
    self.IdCardFrontImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainScrollView addSubview:self.IdCardFrontImageView];
}

- (void)frontBtnClick:(UIButton *)button
{
    _IdCardType = kFront;
    [self uploadImage];
    NSLog(@"正面");
}

#pragma mark - 反面
- (void)createIdCardBack
{
    _IdCardBackBg = [[UIView alloc]initWithFrame:CGRectMake(0, self.IdCardFrontImageView.frame.origin.y+self.IdCardFrontImageView.frame.size.height+5, ScreenWidth, 45)];
    _IdCardBackBg.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:_IdCardBackBg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, _IdCardBackBg.frame.size.height)];
    label.textColor = R_G_B_16(0xbebebe);
    label.text = @"身份证反面";
    label.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [_IdCardBackBg addSubview:label];
    
    UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectMake(ScreenWidth-20-10, (45-18)/2.0, 10, 18) ImageName:@"nextArrow"];
    [_IdCardBackBg addSubview:imageView];
    
    UIButton *backBtn = [MyControl createButtonWithFrame:_IdCardBackBg.bounds ImageName:nil Target:self Action:@selector(backBtnClick:) Title:nil];
    [_IdCardBackBg addSubview:backBtn];
    
    self.IdCardBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, _IdCardBackBg.frame.origin.y+_IdCardBackBg.frame.size.height+5, ScreenWidth-40, (ScreenWidth-40)*0.63)];
    self.IdCardBackImageView.image = [UIImage imageNamed:@"idCardBack.jpg"];
    self.IdCardBackImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainScrollView addSubview:self.IdCardBackImageView];
}

- (void)backBtnClick:(UIButton *)button
{
    _IdCardType = kBack;
    [self uploadImage];
    NSLog(@"反面");
}

#pragma mark - 完成
- (void)createFinishBtn
{
    self.finishButton = [MyControl createButtonWithFrame:CGRectMake(10, self.IdCardBackImageView.frame.origin.y+self.IdCardBackImageView.frame.size.height+40, ScreenWidth-20, 45) ImageName:nil Target:self Action:@selector(finishBtnClick:) Title:nil];
    self.finishButton.backgroundColor = R_G_B_16(0x11c422);
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.finishButton.layer.masksToBounds = YES;
    self.finishButton.layer.cornerRadius = 5;
    self.finishButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    [self.mainScrollView addSubview:self.finishButton];
}

//完成
- (void)finishBtnClick:(UIButton *)button
{
    int flag = 1;
    NSString *title;
    if ([self.nameTextField.text isEqualToString:@""] || self.nameTextField.text == nil) {
        flag = 0;
        title= @"姓名不能为空";
    }
    else if ([self.IdCardTextField.text isEqualToString:@""] || self.IdCardTextField.text == nil) {
        flag = 0;
        title= @"身份证不能为空";
    }
    if (flag == 0) {
        [UILabel showMessage:title];
        return;
    }
    
}

#pragma mark - textField代理方法

#pragma mark - 键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //计算插入之后的字符串
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:textField.text];
    [mstr insertString:string atIndex:range.location];
    if(mstr.length > 30)
    {
        return NO;
    }
    return YES;
}

#pragma mark - 设置导航
- (void)setNav
{
    self.navigationItem.title = @"实名认证";
    
    UIButton*backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame=CGRectMake(0, 0, 80, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchDown];
    [backButton setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

- (void)backClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark--上传头像
-(void)uploadImage
{
    UIActionSheet*action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择" ,nil];
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        
        NSLog(@"相机");
        [self showCamera];
        

    }else if(buttonIndex==1){
        
        [self openPhotoAlbum];
        
        NSLog(@"相册");
    }
}
#pragma mark -
/**
 *  获取截取图片并赋值给相应控件
 *  croppedImage截取之后的图片
 */
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    if (_IdCardType == kFront) {
        self.IdCardFrontImageView.image = croppedImage;
    }
    else if (_IdCardType == kBack) {
        self.IdCardBackImageView.image = croppedImage;
    }
}

/**
 *  跳出图片编辑界面
 *
 *
 */
- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showCamera
{
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:NULL];
    }else{
        [UILabel showMessage:@"模拟器中无法打开照相机,请在真机中使用"];
        
    }
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:controller animated:YES completion:NULL];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:image];
        
    }];
}
- (void)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image =sender;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
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
