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
#import "MJPhoto.h"
#import "XNRProductPhotoModel.h"
#import "XNRPropertyView.h"
#define KbtnTag 1000
#define KlabelTag 2000
@interface XNRProductInfo_cell()<UIScrollViewDelegate>

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

@property (nonatomic ,weak) UIScrollView *scrollView;

@property (nonatomic ,weak) UIPageControl *pageControl;

@property (nonatomic, strong) XNRProductInfo_model *model;

@property (nonatomic ,weak) XNRPropertyView *propertyView;

@property (nonatomic ,weak) UILabel *noLabel;


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

-(XNRPropertyView *)propertyView{
    if (!_propertyView) {
        XNRPropertyView *propertyView = [[XNRPropertyView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) model:self.shopcarModel];
//        propertyView.goodsId = self.goodsId;
//        _propertyView = propertyView;
        self.propertyView = propertyView;
        [self addSubview:propertyView];
    }
    return _propertyView;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = R_G_B_16(0xfafafa);
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
    
    [self createHeadView];
    [self createMidView];
    [self createBottomView];
    
}

-(void)photoTap:(UITapGestureRecognizer *)tap{

     // 创建浏览器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    NSInteger count = _model.pictures.count;
    for (int i = 0; i<count; i++) {
        XNRProductPhotoModel *photoModel = _model.pictures[i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[HOST stringByAppendingString:photoModel.originalUrl]];
        
//        photo.srcImageView = self.subviews[i];

        [photos addObject:photo];
    }
    browser.photos = photos;
    
    [browser show];
    
}

-(void)createHeadView
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
    scrollView.tag = 1000;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
}
-(void)setupPageController
{
    UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(112), ScreenWidth-80, PX_TO_PT(80), PX_TO_PT(80))];
    noLabel.text = [NSString stringWithFormat:@"1/%tu",_model.pictures.count];
    noLabel.textAlignment = NSTextAlignmentCenter;
    noLabel.layer.cornerRadius = PX_TO_PT(40);
    noLabel.layer.masksToBounds = YES;
    noLabel.backgroundColor = R_G_B_16(0x00b38a);
    noLabel.textColor = [UIColor whiteColor];
    self.noLabel = noLabel;
    [self addSubview:noLabel];
    // 1.添加
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth-30, ScreenWidth, 30)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bgView];
    
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = _model.pictures.count;
        pageControl.centerX = self.width/2;
        pageControl.centerY = ScreenWidth - 15;
        [self addSubview:pageControl];
    
        // 2.设置圆点的颜色
        pageControl.currentPageIndicatorTintColor = R_G_B_16(0x3dd5b2); // 当前页的小圆点颜色
        pageControl.layer.borderWidth = 1.0;
        pageControl.layer.borderColor = [UIColor whiteColor].CGColor;
        pageControl.pageIndicatorTintColor = [UIColor whiteColor]; // 非当前页的小圆点颜色
        self.pageControl = pageControl;

}

-(void)createMidView
{
    UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth, ScreenWidth, PX_TO_PT(1))];
    headLineView.backgroundColor  = R_G_B_16(0xc7c7c7);
    [self addSubview:headLineView];
    
    UIView *bgTopView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth, ScreenWidth, PX_TO_PT(145))];
    bgTopView.backgroundColor = R_G_B_16(0xfafafa);
    [self.contentView addSubview:bgTopView];

    UILabel *goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), ScreenWidth+PX_TO_PT(20), ScreenWidth-PX_TO_PT(32), PX_TO_PT(70))];
    goodNameLabel.textColor = R_G_B_16(0x323232);
    goodNameLabel.font = XNRFont(16);
    goodNameLabel.numberOfLines = 0;
    self.goodNameLabel = goodNameLabel;
    [self addSubview:goodNameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(goodNameLabel.frame) + PX_TO_PT(20), ScreenWidth, PX_TO_PT(30))];
    priceLabel.font = XNRFont(14);
    priceLabel.textColor = R_G_B_16(0x646464);
    self.priceLabel = priceLabel;
    [self addSubview:priceLabel];
    
    UILabel *marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(priceLabel.frame) + PX_TO_PT(10), ScreenWidth, PX_TO_PT(24))];
    marketPriceLabel.font = XNRFont(12);
    marketPriceLabel.textColor = R_G_B_16(0x646464);
//    self.marketPriceLabel = marketPriceLabel;
    [self addSubview:priceLabel];

    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth + PX_TO_PT(100), ScreenWidth, PX_TO_PT(1))];
//    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
//    [self addSubview:lineView];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgTopView.frame), ScreenWidth, PX_TO_PT(80))];
    descriptionLabel.backgroundColor = R_G_B_16(0xf2f2f2);
    descriptionLabel.textColor = R_G_B_16(0x00b38a);
    descriptionLabel.font = XNRFont(14);
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel = descriptionLabel;
    [self addSubview:descriptionLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.descriptionLabel.frame), ScreenWidth, PX_TO_PT(110))];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    
    UIButton *propertyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, PX_TO_PT(20), ScreenWidth, PX_TO_PT(90))];
    propertyBtn.backgroundColor = R_G_B_16(0xf2f2f2);
    [propertyBtn addTarget: self action:@selector(propertyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:propertyBtn];
    
    
    UILabel *propertyLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), 0, ScreenWidth, PX_TO_PT(90))];
    propertyLabel.text = @"请选择商品属性";
    propertyLabel.textAlignment = NSTextAlignmentLeft;
    propertyLabel.textColor = R_G_B_16(0x323232);
    propertyLabel.font = XNRFont(14);
    [propertyBtn addSubview:propertyLabel];
    
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(56), PX_TO_PT(24), PX_TO_PT(24), PX_TO_PT(42))];
    [iconImageView setImage:[UIImage imageNamed:@"icon_arrow"]];
    [propertyBtn addSubview:iconImageView];
    
    
//    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.descriptionLabel.frame) +PX_TO_PT(20), ScreenWidth, PX_TO_PT(110))];
//    priceLabel.textColor = R_G_B_16(0x646464);
//    priceLabel.font = XNRFont(16);
//    self.priceLabel = priceLabel;
//    [self addSubview:priceLabel];
    
//    UILabel *depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, CGRectGetMaxY(self.descriptionLabel.frame) + PX_TO_PT(20), ScreenWidth*0.5, PX_TO_PT(110))];
//    depositLabel.textColor = R_G_B_16(0x646464);
//    priceLabel.font = XNRFont(16);
//    self.depositLabel = depositLabel;
//    [self addSubview:depositLabel];
//    
//    UILabel *presaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(32), CGRectGetMaxY(self.descriptionLabel.frame), ScreenWidth, PX_TO_PT(110))];
//    presaleLabel.textColor = R_G_B_16(0xff4e00);
//    presaleLabel.font = XNRFont(16);
//    self.presaleLabel = presaleLabel;
//    [self addSubview:presaleLabel];
    
    UILabel *scrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), ScreenWidth, PX_TO_PT(120))];
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
    webView.scrollView.delegate = self;
    [self addSubview:webView];
    
}
#pragma mark - 商品属性按钮点击
-(void)propertyBtnClick
{
    [self.propertyView show];
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
    
    for (int i = 1; i<3; i++) {
        UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3*i, PX_TO_PT(20), PX_TO_PT(1), PX_TO_PT(40))];
        dividedLine.backgroundColor = R_G_B_16(0xc7c7c7);
        [midView addSubview:dividedLine];
        
    }
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
        [BMProgressView showCoverWithTarget:self color:nil isNavigation:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.app_body_url]];
        [self.webView loadRequest:request];
        [BMProgressView LoadViewDisappear:self];
        
    }else if (button.tag == KbtnTag + 1)
    {
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;

        [BMProgressView showCoverWithTarget:self color:nil isNavigation:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.app_standard_url]];
        [self.webView loadRequest:request];
        [BMProgressView LoadViewDisappear:self];

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
        
        [BMProgressView showCoverWithTarget:self color:nil isNavigation:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.app_support_url]];
        [self.webView loadRequest:request];
        [BMProgressView LoadViewDisappear:self];

    }
}

-(void)upDataWithModel:(XNRProductInfo_model *)model
{
    _model = model;
        // 添加图片
        CGFloat imageW = self.scrollView.width;
        CGFloat imageH = self.scrollView.height;
        for (int i = 0; i<model.pictures.count; i++) {
            UIImageView *headView = [[UIImageView alloc] init];
            // 设置frame
            headView.y = 0;
            headView.width = imageW;
            headView.height = imageH;
            headView.x =i * imageW;
            
            headView.userInteractionEnabled = YES;
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
            [headView addGestureRecognizer:gestureRecognizer];    //商品图片
            XNRProductPhotoModel *photoModel = model.pictures[i];
            NSString *imageUrl=[HOST stringByAppendingString:photoModel.imgUrl];
            [self.headView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];

            self.headView = headView;
            [self.scrollView addSubview:headView];
            
            
        }
        
        // 3.设置其他属性
        self.scrollView.contentSize = CGSizeMake(model.pictures.count * imageW, 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        
        [self setupPageController];

    
    self.goodNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",model.Desc];
    if ([model.min floatValue]== [model.max floatValue]) {
        self.priceLabel.text = [NSString stringWithFormat:@"新农价：￥%@",model.min];

    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"新农价：￥%@ - ￥%@",model.min,model.max];

    }
    
    
    NSMutableAttributedString *AttributedStringPrice = [[NSMutableAttributedString alloc]initWithString:self.priceLabel.text];
    NSDictionary *priceStr=@{
                          
                          NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
                          
                          };
    
    [AttributedStringPrice addAttributes:priceStr range:NSMakeRange(4,AttributedStringPrice.length - 4)];
    
    [_priceLabel setAttributedText:AttributedStringPrice];
    
//    NSRange range = [self.depositLabel.text rangeOfString:@"."];
//    if (self.depositLabel.text.length - range.location > 0) {
//        
//    }else{
//        self.depositLabel.text = [NSString stringWithFormat:@"订金:¥%@",[NSString stringWithFormat:@"%f",model.deposit]];
//    }
    
    self.depositLabel.text = [NSString stringWithFormat:@"订金:￥%.2f",model.deposit];
    if ([self.depositLabel.text rangeOfString:@".00"].length == 3) {
        self.depositLabel.text = [self.depositLabel.text substringToIndex:self.depositLabel.text.length-3];
    }
//    NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.depositLabel.text];
//    NSDictionary *depositStr=@{
//                               
//                               NSForegroundColorAttributeName:R_G_B_16(0xff4e00)
//                               
//                               };
//    
//    [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
//    
//    [_depositLabel setAttributedText:AttributedStringDeposit];

    
    
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
#pragma scrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1000) {
        // 获得页码
        CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
        int intPage = (int)(doublePage + 0.5);
        
        [UIView animateWithDuration:.3 animations:^{
            
            // 设置页码
            self.pageControl.currentPage = intPage;
            self.noLabel.text = [NSString stringWithFormat:@"%d/%tu",intPage+1,_model.pictures.count];
            
        }];

    }else{
        
        if (self.webView.scrollView.contentOffset.y<-40) {
            if ([self.delegate performSelector:@selector(XNRProductInfo_cellScroll)] ) {
                [self.delegate XNRProductInfo_cellScroll];
                
            }
        }

    
    }
    
}



@end
