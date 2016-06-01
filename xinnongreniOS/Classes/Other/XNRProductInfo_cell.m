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
#import "AppDelegate.h"
#import "XNRProductInfo_frame.h"

#define KbtnTag 1000
#define KlabelTag 2000
@interface XNRProductInfo_cell()<UIScrollViewDelegate>
{
    NSString *_presale;
    BOOL type;
}

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
            NSLog(@"=========+++++==&&&&&&=====++%@+",marketPrice);

            if (marketPrice != nil) {
                self.marketPriceLabel.text = [NSString stringWithFormat:@"%@",marketPrice];
                
                CGSize marketPriceSize = [marketPrice sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
                [self.originLineView removeFromSuperview];
                // 划掉的线
                UIView *originLineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(100), PX_TO_PT(19), marketPriceSize.width-PX_TO_PT(100), PX_TO_PT(2))];
                originLineView.backgroundColor = R_G_B_16(0x909009);
                self.originLineView = originLineView;
                [self.marketPriceLabel addSubview:originLineView];

            }
            
            if (marketPrice == nil) {
                type = YES;
                [self setupFrame];
                [self upDataWithModel];
            }
        
            if ([marketPrice isEqualToString:@""]) {
                [self.originLineView removeFromSuperview];
                
                [self.marketPriceLabel setHidden:YES];
                if (!([_model.Desc isEqualToString:@""] || _model.Desc == nil)) {
                    self.descriptionLabel.frame = CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
                    self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.descriptionLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
                }else{
                    self.descriptionLabel.hidden =  YES;
                    self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
                }

            }
            
            if (![marketPrice isEqualToString:@""] && marketPrice != nil) {
                [self.marketPriceLabel setHidden:NO];
                self.marketPriceLabel.text = [NSString stringWithFormat:@"%@",marketPrice];
                if (!([_model.Desc isEqualToString:@""] || _model.Desc == nil)) {
                    self.descriptionLabel.frame = CGRectMake(0, CGRectGetMaxY(self.marketPriceLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
                    self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.descriptionLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));

                }else{
                    self.descriptionLabel.hidden =  YES;
                    self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.marketPriceLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
                }
            }
            // 价格
            CGFloat priceLabelX = PX_TO_PT(30);
            CGFloat priceLabelY = CGRectGetMaxY(self.goodNameLabel.frame)+PX_TO_PT(28);
            //    CGFloat priceLabelW = ScreenWidth/2;
            CGFloat priceLabelH = PX_TO_PT(38);
            CGSize priceLabelMaxSize = CGSizeMake(MAXFLOAT, priceLabelH);
            CGSize priceLabelSize = [price sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(38)] maxSize:priceLabelMaxSize];
            self.priceLabel.frame = (CGRect){{priceLabelX, priceLabelY}, priceLabelSize};

            self.priceLabel.text = [NSString stringWithFormat:@"%@",price];
            
            NSString *  attributeStr = [attributes lastObject];
            NSString *addtionStr = [addtions lastObject];
            
            if (attributes.count>0&&addtions.count == 0) {
                weakSelf.propertyLabel.text = [NSString stringWithFormat:@"%@",attributeStr];
            }else if (attributes.count == 0&&addtions.count>0){
                weakSelf.propertyLabel.text = [NSString stringWithFormat:@"%@",addtionStr];
            }else if (attributes.count>0&&addtions.count>0){
                weakSelf.propertyLabel.text = [NSString stringWithFormat:@"%@ %@",attributeStr,addtionStr];
            }else{
                weakSelf.propertyLabel.text = @"请选择商品属性";
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
        self.contentView.userInteractionEnabled = YES;
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
    
    if (self.photoBrowsercom) {
        self.photoBrowsercom(self.pageControl.currentPage);
    }

}

-(void)createUI
{
    [self createHeadView];
    [self createMidView];
    [self setupHeadView];

}

-(void)createHeadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.tag = 1000;
    scrollView.delegate = self;
//    scrollView.userInteractionEnabled = YES;
    self.scrollView = scrollView;
    [self.contentView addSubview:scrollView];
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
        [self.contentView addSubview:noLabel];
        
        // 1.添加
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(700)-PX_TO_PT(60), ScreenWidth, PX_TO_PT(60))];
        bgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:bgView];
        
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

    }else{
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(700), ScreenWidth, 1)];
        bgView.backgroundColor = R_G_B_16(0xc7c7c7);
    [self.contentView addSubview:bgView];
    }
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
//    presaleLabel.backgroundColor = [UIColor redColor];
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
    if (!([_model.app_body_url isEqualToString:@""] &&[_model.app_support_url isEqualToString:@""] && [_model.app_standard_url isEqualToString:@""]) ) {
        self.scrollLabel.frame = self.infoFrame.drawViewF;
    }else{
        [self.scrollLabel removeFromSuperview];
    }
    self.midView.frame = self.infoFrame.describtionViewF;
//    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.midView.frame), ScreenWidth, ScreenHeight-64-PX_TO_PT(160));
    
}

-(void)setupHeadView
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
        self.headView = headView;
        [self.scrollView addSubview:headView];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
        [headView addGestureRecognizer:gestureRecognizer];    //商品图片
        XNRProductPhotoModel *photoModel = self.model.pictures[i];
        
        NSString *imageUrl=[HOST stringByAppendingString:photoModel.imgUrl];
        [headView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
            [headView setImage:[UIImage imageNamed:@"icon_placehold"]];
        }else{
            [headView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
        }}];
    
    }
    // 3.设置其他属性
    self.scrollView.contentSize = CGSizeMake(self.model.pictures.count * imageW, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self setupPageController];


}

-(void)upDataWithModel
{
    NSLog(@"=========+++%@++=======+++",_marketPrice);
    [self setupHeadView];
    
    self.goodNameLabel.text = [NSString stringWithFormat:@"%@",self.model.name];
    // 商品描述
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",self.model.Desc];
    
    NSString *minStr = [NSString stringWithFormat:@"%@",self.model.min];
    NSString *maxStr = [NSString stringWithFormat:@"%.2f",[self.model.max doubleValue]];

    if ([self.model.min doubleValue]== [self.model.max doubleValue]) {
        NSString *price = [NSString stringWithFormat:@"￥%@ - %@",minStr,maxStr];

        // 价格
        CGFloat priceLabelX = PX_TO_PT(30);
        CGFloat priceLabelY = CGRectGetMaxY(self.goodNameLabel.frame)+PX_TO_PT(28);
        //    CGFloat priceLabelW = ScreenWidth/2;
        CGFloat priceLabelH = PX_TO_PT(38);
        CGSize priceLabelMaxSize = CGSizeMake(MAXFLOAT, priceLabelH);
        CGSize priceLabelSize = [price sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(38)] maxSize:priceLabelMaxSize];
        self.priceLabel.frame = (CGRect){{priceLabelX, priceLabelY}, priceLabelSize};

        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.min];

    }else{
        NSString *price = [NSString stringWithFormat:@"￥%@ - %@",maxStr,maxStr];
        // 价格
        CGFloat priceLabelX = PX_TO_PT(30);
        CGFloat priceLabelY = CGRectGetMaxY(self.goodNameLabel.frame)+PX_TO_PT(28);
        CGFloat priceLabelH = PX_TO_PT(38);
        CGSize priceLabelMaxSize = CGSizeMake(MAXFLOAT, priceLabelH);
        CGSize priceLabelSize = [price sizeWithFont_BSExt:[UIFont systemFontOfSize:PX_TO_PT(38)] maxSize:priceLabelMaxSize];
        self.priceLabel.frame = (CGRect){{priceLabelX, priceLabelY}, priceLabelSize};
            if ([maxStr rangeOfString:@".00"].length == 3) {
                maxStr = [maxStr substringToIndex:maxStr.length-3];
            }

        self.priceLabel.text = [NSString stringWithFormat:@"￥%@ - %@",minStr,maxStr];

    }
    
    
    if ([_model.online integerValue] != 0 || _model.online == nil) {
        self.depositLabel.text = [NSString stringWithFormat:@"订金:￥%.2f",self.model.deposit];
        
        if ([self.depositLabel.text rangeOfString:@".00"].length == 3) {
            self.depositLabel.text = [self.depositLabel.text substringToIndex:self.depositLabel.text.length-3];
        }
        NSMutableAttributedString *AttributedStringDeposit = [[NSMutableAttributedString alloc]initWithString:self.depositLabel.text];
        NSDictionary *depositStr=@{
                                   
                                   NSForegroundColorAttributeName:R_G_B_16(0xff4e00),
                                   NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(38)]
                                   
                                   };
        
        [AttributedStringDeposit addAttributes:depositStr range:NSMakeRange(3,AttributedStringDeposit.length-3)];
        
        [_depositLabel setAttributedText:AttributedStringDeposit];


    }else{
        [self.bgView removeFromSuperview];
    }
    
    
    CGSize marketPriceSize;
        if (![KSHttpRequest isNULL:self.model.marketMin]) {
          if (self.model.marketMin == self.model.marketMax) {
             self.marketPriceLabel.text = [NSString stringWithFormat:@"市场价￥%@",self.model.marketMin];
            marketPriceSize = [self.marketPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];

            }else{
            self.marketPriceLabel.text = [NSString stringWithFormat:@"市场价￥%@ - %@",self.model.marketMin,self.model.marketMax];
            marketPriceSize = [self.marketPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
        }
            // 划掉的线
            [self.originLineView removeFromSuperview];
            UIView *originLineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(100), PX_TO_PT(19), marketPriceSize.width-PX_TO_PT(100), PX_TO_PT(2))];
            originLineView.backgroundColor = R_G_B_16(0x909090);
            self.originLineView = originLineView;
            [self.marketPriceLabel addSubview:originLineView];
    }
    
      if (_marketPrice != nil) {
        self.marketPriceLabel.text = [NSString stringWithFormat:@"%@",_marketPrice];
        
        CGSize marketPriceSize = [_marketPrice sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
        [self.originLineView removeFromSuperview];
        // 划掉的线
        UIView *originLineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(100), PX_TO_PT(19), marketPriceSize.width-PX_TO_PT(100), PX_TO_PT(2))];
        originLineView.backgroundColor = R_G_B_16(0x909009);
        self.originLineView = originLineView;
        [self.marketPriceLabel addSubview:originLineView];
        
    }
    if (type == NO) {
        if ([_marketPrice isEqualToString:@""]) {
            [self.originLineView removeFromSuperview];
            [self.marketPriceLabel setHidden:YES];
            if (!([_model.Desc isEqualToString:@""] || _model.Desc == nil)) {
                self.descriptionLabel.frame = CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
                self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.descriptionLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
            }else{
                self.descriptionLabel.hidden =  YES;
                self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
            }
        }
    }else{
        self.marketPriceLabel.hidden = NO;
        CGSize marketPriceSize;
        if (![KSHttpRequest isNULL:self.model.marketMin]) {
            if (self.model.marketMin == self.model.marketMax) {
                self.marketPriceLabel.text = [NSString stringWithFormat:@"市场价￥%@",self.model.marketMin];
                marketPriceSize = [self.marketPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
            }else{
                _marketPrice = @"";
                _marketPrice = nil;
                self.marketPriceLabel.text = [NSString stringWithFormat:@"市场价￥%@ - %@",self.model.marketMin,self.model.marketMax];
                marketPriceSize = [self.marketPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(32)]}];
            }
            [self.originLineView removeFromSuperview];
            // 划掉的线
            UIView *originLineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(100), PX_TO_PT(19), marketPriceSize.width-PX_TO_PT(100), PX_TO_PT(2))];
            originLineView.backgroundColor = R_G_B_16(0x909009);
            self.originLineView = originLineView;
            [self.marketPriceLabel addSubview:originLineView];
        }
    }
    
    if (![_marketPrice isEqualToString:@""] && _marketPrice != nil) {
        [self.marketPriceLabel setHidden:NO];
        self.marketPriceLabel.text = [NSString stringWithFormat:@"%@",_marketPrice];
        if (!([_model.Desc isEqualToString:@""] || _model.Desc == nil)) {
            self.descriptionLabel.frame = CGRectMake(0, CGRectGetMaxY(self.marketPriceLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
            self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.descriptionLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
            
        }else{
            self.descriptionLabel.hidden =  YES;
            self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.marketPriceLabel.frame)+PX_TO_PT(20), ScreenWidth, PX_TO_PT(80));
        }
    }

    // 从控制器传回来的属相展示
   
    NSString *  attributeStr = [_attributes lastObject];
    NSString *addtionStr = [_additions lastObject];
    
    if (_attributes.count>0&&_additions.count == 0) {
        self.propertyLabel.text = [NSString stringWithFormat:@"%@",attributeStr];
    }else if (_attributes.count == 0&&_additions.count>0){
        self.propertyLabel.text = [NSString stringWithFormat:@"%@",addtionStr];
    }else if (_attributes.count>0&&_additions.count>0){
        self.propertyLabel.text = [NSString stringWithFormat:@"%@ %@",attributeStr,addtionStr];
    }else{
        self.propertyLabel.text = @"请选择商品属性";
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
        
//        if (self.webView.scrollView.contentOffset.y<-40) {
//            if ([self.delegate performSelector:@selector(XNRProductInfo_cellScroll)] ) {
//                [self.delegate XNRProductInfo_cellScroll];
//                
//            }
//        }

    
    }
    
}



@end
