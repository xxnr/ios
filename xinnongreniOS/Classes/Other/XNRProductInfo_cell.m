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
#import "MWPhotoBrowser.h"
#import "AppDelegate.h"
#import "XNRProductInfo_frame.h"

#define KbtnTag 1000
#define KlabelTag 2000
@interface XNRProductInfo_cell()<UIScrollViewDelegate,MWPhotoBrowserDelegate>
{
    NSString *_presale;
}
@property (nonatomic, strong) NSMutableArray *picBrowserList;

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

@property (nonatomic ,weak) UILabel *marketPriceLabel;

@property (nonatomic, weak) UILabel *presaleLabel;

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic ,weak) BMProgressView *progressView;

@property (nonatomic ,weak) UIScrollView *scrollView;

@property (nonatomic ,weak) UIPageControl *pageControl;

@property (nonatomic, strong) XNRProductInfo_model *model;

@property (nonatomic ,weak) XNRPropertyView *propertyView;

@property (nonatomic ,weak) UILabel *noLabel;

@property (nonatomic, weak) UILabel *propertyLabel;

@property (nonatomic, weak) UIView *originLineView;

@property (nonatomic, weak) UIView *bgTopView;

@property (nonatomic, weak) UIView *bgView;

@end

@implementation XNRProductInfo_cell
- (NSMutableArray *)picBrowserList {
    if (!_picBrowserList) {
        _picBrowserList = [NSMutableArray array];
    }
    return _picBrowserList;
}
-(BMProgressView *)progressView{
    if (!_progressView) {
        BMProgressView *progressView = [[BMProgressView alloc] init];
        self.progressView = progressView;
        [self addSubview:progressView];
    }
    return _progressView;
}

-(XNRPropertyView *)propertyView{
    XNRPropertyView *propertyView = [XNRPropertyView sharedInstanceWithModel:_shopcarModel];
    if (!_propertyView) {
        __weak __typeof(self)weakSelf = self;
        // 传回来的属性
        propertyView.valueBlock = ^(NSMutableArray *attributes,NSMutableArray *addtions,NSString *price,NSString *marketPrice){
           
            self.marketPriceLabel.text = [NSString stringWithFormat:@"%@",marketPrice];
            self.priceLabel.text = [NSString stringWithFormat:@"%@",price];
            CGSize marketPriceSize = [marketPrice sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
            [self.originLineView removeFromSuperview];
            // 划掉的线
            UIView *originLineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(100), PX_TO_PT(19), marketPriceSize.width-PX_TO_PT(100), PX_TO_PT(2))];
            originLineView.backgroundColor = R_G_B_16(0x909009);
            self.originLineView = originLineView;
            [self.marketPriceLabel addSubview:originLineView];
            
            NSString *  attributeStr = [attributes lastObject];
            NSString *addtionStr = [addtions lastObject];

            if ([attributeStr isEqualToString:@""] && [addtionStr isEqualToString:@""]) {
                weakSelf.propertyLabel.text = @"请选择商品属性";
            }
            if ([addtionStr isEqualToString:@""] || addtionStr == nil) {
                weakSelf.propertyLabel.text = [NSString stringWithFormat:@"%@",attributeStr];
            }else{
                weakSelf.propertyLabel.text = [NSString stringWithFormat:@"%@ %@",attributeStr,addtionStr];
            }
        };
             // 立即购买的跳转，包括传值
        propertyView.com = ^(NSMutableArray *dataArray,CGFloat totalPrice,NSString *totalNum){
            weakSelf.con(dataArray,totalPrice,totalNum);
        };
        // 登录页面的跳转
        propertyView.loginBlock = ^(){
            weakSelf.logincom();
        
        };
        self.propertyView = propertyView;
        [self addSubview:propertyView];
    }
    return _propertyView;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
#pragma mark - 大图的点击
-(void)photoTap:(UITapGestureRecognizer *)tap{
    
    // 创建浏览器对象
    [self.picBrowserList removeAllObjects];
    NSInteger count = _model.pictures.count;
    for (int i = 0; i<count; i++) {
        XNRProductPhotoModel *photoModel = _model.pictures[i];
        MWPhoto *photo=[MWPhoto photoWithURL:[NSURL URLWithString:[HOST stringByAppendingString:photoModel.originalUrl]]];
        [self.picBrowserList addObject:photo];
    }
    
    MWPhotoBrowser *photoBrowser=[[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton=NO;
    photoBrowser.alwaysShowControls=NO;
    [photoBrowser setCurrentPhotoIndex:self.pageControl.currentPage];
    [[[AppDelegate shareAppDelegate].tabBarController selectedViewController] pushViewController:photoBrowser animated:YES];
    
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [_picBrowserList count];
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    return _picBrowserList[index];
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    return [NSString stringWithFormat:@"%ld/%ld",(long)index+1,(long)[_picBrowserList count]];
}

-(void)createUI
{
    [self createHeadView];
    [self createMidView];
    [self createBottomView];
}

-(void)createHeadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.tag = 1000;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
}
-(void)setupPageController
{
    if (_model.pictures.count>1) {
        UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(112), PX_TO_PT(700)-80, PX_TO_PT(80), PX_TO_PT(80))];
        noLabel.text = [NSString stringWithFormat:@"1/%tu",_model.pictures.count];
        noLabel.textAlignment = NSTextAlignmentCenter;
        noLabel.layer.cornerRadius = PX_TO_PT(40);
        noLabel.layer.masksToBounds = YES;
        noLabel.backgroundColor = R_G_B_16(0x00b38a);
        noLabel.textColor = [UIColor whiteColor];
        self.noLabel = noLabel;
        [self addSubview:noLabel];
    }
    // 1.添加
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(700)-PX_TO_PT(60), ScreenWidth, PX_TO_PT(60))];
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bgView];
    
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = _model.pictures.count;
        pageControl.centerX = ScreenWidth/2;
        pageControl.centerY = PX_TO_PT(30);
        [bgView addSubview:pageControl];
    
        // 2.设置圆点的颜色
        pageControl.currentPageIndicatorTintColor = R_G_B_16(0x3dd5b2); // 当前页的小圆点颜色
        pageControl.layer.borderWidth = 1.0;
        pageControl.layer.borderColor = [UIColor whiteColor].CGColor;
        pageControl.pageIndicatorTintColor = [UIColor whiteColor]; // 非当前页的小圆点颜色
        self.pageControl = pageControl;
}

-(void)createMidView
{
    UILabel *goodNameLabel = [[UILabel alloc] init];
    goodNameLabel.textColor = R_G_B_16(0x323232);
    goodNameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
    goodNameLabel.numberOfLines = 0;
    self.goodNameLabel = goodNameLabel;
    [self.contentView addSubview:goodNameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(38)];
    priceLabel.textColor = R_G_B_16(0xff4e00);
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    UILabel *presaleLabel = [[UILabel alloc] init];
    presaleLabel.textColor = R_G_B_16(0x989898);
    presaleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.presaleLabel = presaleLabel;
    [self.contentView addSubview:presaleLabel];

    UILabel *depositLabel = [[UILabel alloc] init];
    depositLabel.textColor = R_G_B_16(0x323232);
    depositLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    self.depositLabel = depositLabel;
    [self.contentView addSubview:depositLabel];
    
    UILabel *marketPriceLabel = [[UILabel alloc] init];
    marketPriceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    marketPriceLabel.textColor = R_G_B_16(0x909090);
    self.marketPriceLabel = marketPriceLabel;
    [self.contentView addSubview:marketPriceLabel];

    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.backgroundColor = R_G_B_16(0xf2f2f2);
    descriptionLabel.textColor = R_G_B_16(0x00b38a);
    descriptionLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel = descriptionLabel;
    [self.contentView addSubview:descriptionLabel];

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];

    UIButton *propertyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80))];
    propertyBtn.backgroundColor = R_G_B_16(0xf2f2f2);
    [propertyBtn addTarget: self action:@selector(propertyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:propertyBtn];
    
    
    UILabel *propertyLabel = [[UILabel alloc] initWithFrame:CGRectMake(PX_TO_PT(30), 0, ScreenWidth-PX_TO_PT(56)-PX_TO_PT(32), PX_TO_PT(80))];
    NSString *  attributeStr = [_attributes lastObject];
    NSString *addtionStr = [_additions lastObject];
    
    if (attributeStr == nil) {
        propertyLabel.text = @"请选择商品属性";
    }
    if (addtionStr == nil&&attributeStr != nil) {
        propertyLabel.text = [NSString stringWithFormat:@"%@",attributeStr];
    }
    if (addtionStr!=nil&&attributeStr!=nil) {
        propertyLabel.text = [NSString stringWithFormat:@"%@ %@",attributeStr,addtionStr];

    }
    propertyLabel.textAlignment = NSTextAlignmentLeft;
    propertyLabel.numberOfLines = 0;
    propertyLabel.textColor = R_G_B_16(0x323232);
    propertyLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    self.propertyLabel = propertyLabel;
    [propertyBtn addSubview:propertyLabel];
    
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(56), PX_TO_PT(24), PX_TO_PT(24), PX_TO_PT(42))];
    [iconImageView setImage:[UIImage imageNamed:@"icon_arrow"]];
    [propertyBtn addSubview:iconImageView];
    

    UILabel *scrollLabel = [[UILabel alloc] init];
    scrollLabel.textColor = R_G_B_16(0x323232);
    scrollLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    scrollLabel.text = @"继续拖动，查看商品详情";
    scrollLabel.textAlignment = NSTextAlignmentCenter;
    self.scrollLabel = scrollLabel;
    [self.contentView addSubview:scrollLabel];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(32), PX_TO_PT(60), PX_TO_PT(160), PX_TO_PT(2))];
    leftLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [scrollLabel addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(192), PX_TO_PT(60), PX_TO_PT(170), PX_TO_PT(2))];
    rightLine.backgroundColor = R_G_B_16(0xc7c7c7);
    [scrollLabel addSubview:rightLine];
    
    UIWebView *webView = [[UIWebView alloc] init];
    self.webView = webView;
    webView.scrollView.delegate = self;
    [self.contentView addSubview:webView];
    
}
#pragma mark - 商品属性按钮点击
-(void)propertyBtnClick
{
    [self.propertyView show:XNRisFormType];
}

-(void)createBottomView
{
    UIView *midView = [[UIView alloc] init];
    midView.backgroundColor = R_G_B_16(0xf2f2f2);
    self.midView = midView;
    [self.contentView addSubview:midView];
    
    
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
        label.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
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
// 设置frame和数据
-(void)setInfoFrame:(XNRProductInfo_frame *)infoFrame
{
    _infoFrame = infoFrame;
    
    XNRProductInfo_model *model = infoFrame.infoModel;
    _model = model;
   
    
   // 设置frame
    [self setupFrame];
    // 设置数据
    [self upDataWithModel];

}

-(void)setupFrame
{
    self.scrollView.frame = self.infoFrame.imageViewF;
    self.goodNameLabel.frame = self.infoFrame.productNameLabelF;
    self.priceLabel.frame = self.infoFrame.priceLabelF;
    self.presaleLabel.frame = self.infoFrame.priceLabelF;
    self.marketPriceLabel.frame = self.infoFrame.marketPriceLabelF;
    self.depositLabel.frame = self.infoFrame.depositLabelF;
    self.descriptionLabel.frame = self.infoFrame.introduceLabelF;
    self.bgView.frame = self.infoFrame.attributeLabelF;
    self.scrollLabel.frame = self.infoFrame.drawViewF;
    self.midView.frame = self.infoFrame.describtionViewF;
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.midView.frame), ScreenWidth, ScreenHeight-64-PX_TO_PT(160));
    
}

-(void)upDataWithModel
{
        // 添加图片
        CGFloat imageW = self.scrollView.width;
        CGFloat imageH = self.scrollView.height;
        for (int i = 0; i<self.model.pictures.count; i++) {
            UIImageView *headView = [[UIImageView alloc] init];
             // 设置frame
            headView.y = 0;
            headView.width = imageW;
            headView.height = imageH;
            headView.x =i * imageW;
            headView.userInteractionEnabled = YES;
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
            [headView addGestureRecognizer:gestureRecognizer];    //商品图片
            XNRProductPhotoModel *photoModel = self.model.pictures[i];
            
            NSString *imageUrl=[HOST stringByAppendingString:photoModel.imgUrl];
            [headView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
            self.headView = headView;
            [self.scrollView addSubview:headView];
        }
        // 3.设置其他属性
        self.scrollView.contentSize = CGSizeMake(self.model.pictures.count * imageW, 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        [self setupPageController];
    
    self.goodNameLabel.text = [NSString stringWithFormat:@"%@",self.model.name];
    // 商品描述
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",self.model.Desc];
    
    
    if ([self.model.min floatValue]== [self.model.max floatValue]) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.min];

    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@ - %@",self.model.min,self.model.max];
    }
    
    if ([_shopcarModel.online integerValue] != 0 || _shopcarModel.online == nil) {
        self.depositLabel.text = [NSString stringWithFormat:@"订金:￥%.2f",self.model.deposit];
        
        if ([self.depositLabel.text rangeOfString:@".00"].length == 3) {
            self.depositLabel.text = [self.depositLabel.text substringToIndex:self.depositLabel.text.length-3];
            NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.depositLabel.text];
            NSDictionary *depositStr=@{
                                       
                                       NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                       NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(38)]
                                       
                                       };
            
            [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
            
            [_depositLabel setAttributedText:AttributedStringDeposit];
            
        }

    }
    
    
    CGSize marketPriceSize;
    if ([self.model.marketMin floatValue]==[self.model.marketMax floatValue]) {
        if ([self.model.marketMin floatValue] == 0.00 && [self.model.marketMax floatValue] == 0.00) {
            self.marketPriceLabel.hidden = YES;
        }else{
            self.marketPriceLabel.text = [NSString stringWithFormat:@"市场价￥%@",self.model.marketMin];
        }
        marketPriceSize = [self.marketPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
        
    }else{
        self.marketPriceLabel.text = [NSString stringWithFormat:@"市场价￥%@ - %@",self.model.marketMin,self.model.marketMax];
         marketPriceSize = [self.marketPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
    }
    
    // 划掉的线
    if (!_originLineView) {
        UIView *originLineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(100), PX_TO_PT(19), marketPriceSize.width-PX_TO_PT(100), PX_TO_PT(2))];
        originLineView.backgroundColor = R_G_B_16(0x909090);
        self.originLineView = originLineView;
        [self.marketPriceLabel addSubview:originLineView];

    }
    // 从控制器传回来的属相展示
    NSString *  attributeStr = [_attributes lastObject];
    NSString *addtionStr = [_additions lastObject];
    
    if (attributeStr == nil) {
        self.propertyLabel.text = @"请选择商品属性";
    }
    if (addtionStr == nil&&attributeStr != nil) {
        self.propertyLabel.text = [NSString stringWithFormat:@"%@",attributeStr];
    }
    if (addtionStr!=nil&&attributeStr!=nil) {
        self.propertyLabel.text = [NSString stringWithFormat:@"%@ %@",attributeStr,addtionStr];
        
    }

    // 当_marketPrice有值得时候加载
    if (_marketPrice) {
        [self.originLineView removeFromSuperview];
        self.marketPriceLabel.text = [NSString stringWithFormat:@"%@",_marketPrice];
        marketPriceSize = [self.marketPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
        
        UIView *originLineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(100), PX_TO_PT(19), marketPriceSize.width-PX_TO_PT(100), PX_TO_PT(2))];
        originLineView.backgroundColor = R_G_B_16(0x909090);
        self.originLineView = originLineView;
        [self.marketPriceLabel addSubview:originLineView];
    }
    if (_Price) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@",_Price];
    }
    
    if (self.model.deposit == 0.00) {
        self.depositLabel.hidden = YES;
    }else{
        self.depositLabel.hidden  = NO;
    }
    
    if ([self.model.presale integerValue] == 1) {
        self.priceLabel.hidden = YES;
        self.depositLabel.hidden = YES;
        self.marketPriceLabel.hidden = YES;
        self.presaleLabel.text = @"即将上线";
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.app_body_url]];
    [self.webView loadRequest:request];
    NSLog(@"=====%@",self.model.app_body_url);
}

#pragma mark -  scrollView的代理
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
