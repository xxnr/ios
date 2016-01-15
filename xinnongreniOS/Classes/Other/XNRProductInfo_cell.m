//
//  XNRProductInfo_cell.m
//  xinnongreniOS
//
//  Created by xxnr on 15/12/7.
//  Copyright © 2015年 qxhiOS. All rights reserved.
//

#import "XNRProductInfo_cell.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"

#define KbtnTag 1000
#define KlabelTag 2000
@interface XNRProductInfo_cell()

@property (nonatomic, weak) UIImageView *headView;
@property (nonatomic, weak) UIView *midView;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) UIButton *tempBtn;
@property (nonatomic, weak) UILabel *tempLabel;
@property (nonatomic, weak) UIView *selectLine;

@property (nonatomic, weak) UILabel *goodNameLabel;

@property (nonatomic,weak) UILabel *descriptionLabel;

@property (nonatomic,weak) UILabel *priceLabel;

@property (nonatomic,weak) UILabel *scrollLabel;

@property (nonatomic, weak) UILabel *depositLabel;

@property (nonatomic, weak) UILabel *presaleLabel;

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic ,weak) BMProgressView *progressView;

@end

@implementation XNRProductInfo_cell

-(BMProgressView *)progressView{
    if (!_progressView) {
        BMProgressView *progressView = [[BMProgressView alloc] init];
        self.progressView = progressView;
        [self addSubview:progressView];
    }
    return _progressView;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellID";
    XNRProductInfo_cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XNRProductInfo_cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


-(void)createUI
{
    UIImageView *headView = [[UIImageView alloc] init];
    headView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
    headView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
    [headView addGestureRecognizer:gestureRecognizer];    //商品图片
    self.headView = headView;
    [self addSubview:headView];

    [self createMidView];
    [self createBottomView];
    
}

-(void)photoTap:(UITapGestureRecognizer *)tap{
    // 创建浏览器对象
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    [BMProgressView showImage:self.headView];

}

-(void)createMidView
{
    UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth, ScreenWidth, PX_TO_PT(1))];
    headLineView.backgroundColor  = R_G_B_16(0xc7c7c7);
    [self addSubview:headLineView];

    UILabel *goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), ScreenWidth, ScreenWidth-PX_TO_PT(32), PX_TO_PT(120))];
    goodNameLabel.textColor = R_G_B_16(0x323232);
    goodNameLabel.font = XNRFont(16);
    goodNameLabel.numberOfLines = 0;
    self.goodNameLabel = goodNameLabel;
    [self addSubview:goodNameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth + PX_TO_PT(100), ScreenWidth, PX_TO_PT(1))];
    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
    [self addSubview:lineView];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodNameLabel.frame), ScreenWidth, PX_TO_PT(80))];
    descriptionLabel.textColor = R_G_B_16(0x00b38a);
    descriptionLabel.font = XNRFont(14);
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel = descriptionLabel;
    [self addSubview:descriptionLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.descriptionLabel.frame), ScreenWidth, PX_TO_PT(110))];
    bgView.backgroundColor = R_G_B_16(0xf2f2f2);
    [self addSubview:bgView];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.descriptionLabel.frame), ScreenWidth, PX_TO_PT(110))];
    priceLabel.textColor = R_G_B_16(0x646464);
    priceLabel.font = XNRFont(16);
    self.priceLabel = priceLabel;
    [self addSubview:priceLabel];
    
    UILabel *depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetMaxY(self.descriptionLabel.frame), ScreenWidth*0.5, PX_TO_PT(110))];
    depositLabel.textColor = R_G_B_16(0x646464);
    priceLabel.font = XNRFont(16);
    self.depositLabel = depositLabel;
    [self addSubview:depositLabel];
    
    UILabel *presaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.descriptionLabel.frame), ScreenWidth, PX_TO_PT(110))];
    presaleLabel.textColor = R_G_B_16(0xff4e00);
    presaleLabel.font = XNRFont(16);
    self.presaleLabel = presaleLabel;
    [self addSubview:presaleLabel];
    
    UILabel *scrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame), ScreenWidth, PX_TO_PT(120))];
    scrollLabel.textColor = R_G_B_16(0x323232);
    scrollLabel.font = XNRFont(14);
    scrollLabel.text = @"继续拖动，查看商品详情";
    scrollLabel.textAlignment = NSTextAlignmentCenter;
    self.scrollLabel = scrollLabel;
    [self addSubview:scrollLabel];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(60), PX_TO_PT(160), PX_TO_PT(2))];
    leftLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [scrollLabel addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(192), PX_TO_PT(60), PX_TO_PT(170), PX_TO_PT(2))];
    rightLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [scrollLabel addSubview:rightLine];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollLabel.frame) + PX_TO_PT(80), ScreenWidth, ScreenHeight-64-PX_TO_PT(160))];
    self.webView = webView;
    [self addSubview:webView];
    
}

-(void)createBottomView
{
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollLabel.frame), ScreenWidth, PX_TO_PT(80))];
    midView.backgroundColor = R_G_B_16(0xf2f2f2);
    self.midView = midView;
    [self addSubview:midView];
    
    NSArray *array = @[@"商品描述",@"详细参数",@"服务说明"];
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = ScreenWidth/3.0;
    CGFloat H = PX_TO_PT(80);
    
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(X+i*W, Y, W, H);
        button.tag = KbtnTag+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.button = button;
        [midView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(W*i, 0, W, H)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = R_G_B_16(0x646464);
        label.text = array[i];
        label.tag = KlabelTag + i;
        [midView addSubview:label];
        
        if (i == 0) {
            button.selected =YES;
            self.tempBtn = button;
            
            
            label.textColor = R_G_B_16(0x00b38a);
            self.tempLabel = label;
        }
    }
    UIView *selectLine = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(35), PX_TO_PT(77), PX_TO_PT(180), PX_TO_PT(3))];
    selectLine.backgroundColor = R_G_B_16(0x00b38a);
    self.selectLine = selectLine;
    [midView addSubview:selectLine];
    
}

-(void)buttonClick:(UIButton *)button
{
    static int index = 1000;
    UILabel *titleLabel = (UILabel *)[self viewWithTag:button.tag + KbtnTag];
    [UIView animateWithDuration:.3 animations:^{
        self.selectLine.frame = CGRectMake((button.tag - KbtnTag)*ScreenWidth/3 + PX_TO_PT(35), PX_TO_PT(77), PX_TO_PT(180), PX_TO_PT(3));
        
    }];
    index = (int)button.tag;
    if (button.tag == KbtnTag) {
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
        
        
        self.tempLabel.textColor = R_G_B_16(0x646464);
        titleLabel.textColor = R_G_B_16(0x00b38a);
        self.tempLabel = titleLabel;
        [SVProgressHUD show];
//        [self.progressView initWithTarget:self color:nil isNavigation:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.app_body_url]];
        [self.webView loadRequest:request];
        [SVProgressHUD dismiss];
//        [self.progressView LoadViewDisappear];
        
    }else if (button.tag == KbtnTag + 1)
    {
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
//        [SVProgressHUD show];
        [self.progressView initWithTarget:self color:nil isNavigation:YES];


        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.app_standard_url]];
        [self.webView loadRequest:request];
//        [SVProgressHUD dismiss];
        [self.progressView LoadViewDisappear];


        
        
        self.tempLabel.textColor = R_G_B_16(0x646464);
        titleLabel.textColor = R_G_B_16(0x00b38a);
        self.tempLabel = titleLabel;
    }else{
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
        
        
        self.tempLabel.textColor = R_G_B_16(0x646464);
        titleLabel.textColor = R_G_B_16(0x00b38a);
        self.tempLabel = titleLabel;
//        [SVProgressHUD show];
        [self.progressView initWithTarget:self color:nil isNavigation:YES];


        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.app_support_url]];
        [self.webView loadRequest:request];
        [self.progressView LoadViewDisappear];
//        [SVProgressHUD dismiss];

    }
}

-(void)setModel:(XNRProductInfo_model *)model
{
    _model = model;
    
    NSString *imageUrl=[HOST stringByAppendingString:model.imgUrl];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:imageUrl ] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
    self.goodNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",model.Desc];
    self.priceLabel.text = [NSString stringWithFormat:@"新农价:￥%@",model.price];
    
    NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:self.priceLabel.text];
    NSDictionary *priceStr=@{
                          
                          NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
                          
                          };
    
    [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(4,AttributedStringPrice.length-4)];
    
    [_priceLabel setAttributedText:AttributedStringPrice];
    
    self.depositLabel.text = [NSString stringWithFormat:@"定金:￥%.2f",model.deposit];
    
    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.depositLabel.text];
    NSDictionary *depositStr=@{
                          
                          NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
                          
                          };
    
    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
    
    [_depositLabel setAttributedText:AttributedStringDeposit];
    
    if (model.deposit == 0.00) {
        self.depositLabel.hidden = YES;
    }else{
        self.depositLabel.hidden  = NO;
    }
    
    if ([model.presale integerValue] == 1) {
        self.priceLabel.hidden = YES;
        self.depositLabel.hidden = YES;
        self.presaleLabel.text = @"即将上线";
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.app_body_url]];
    [self.webView loadRequest:request];
    NSLog(@"=====%@",self.model.app_body_url);

    
}



@end
