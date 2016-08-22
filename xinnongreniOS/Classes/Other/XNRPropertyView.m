
//
//  XNRPropertyView.m
//  xinnongreniOS
//
//  Created by xxnr on 16/2/19.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import "XNRPropertyView.h"
#import "XNRPropertyBrandView.h"
#import "XNRPropertyFootView.h"
#import "XNRPropertyEmptyView.h"
#import "XNRPropertyCollectionViewCell.h"
#import "XNRProductInfo_model.h"
#import "XNRProductPhotoModel.h"
#import "XNRSKUAttributesModel.h"
#import "UIImageView+WebCache.h"
#import "XNRShopCarSectionModel.h"
#import "IQKeyboardManager.h"
#import "AppDelegate.h"
#import "XNRCollectionViewFlowLayout.h"
#import "XNRShoppingCartModel.h"
#import "XNRProductInfo_VC.h"

#define coll_cell_margin  PX_TO_PT(20)
#define coll_section_margin PX_TO_PT(40)
#define cellId @"selected_cell"
#define headerViewId @"selectedHeaderView"
#define footViewId @"selectedFootView"
#define emptyViewId @"emptyFootView"
#define buyBtnTag 1000

@interface XNRPropertyView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    CGSize currentSize;
    NSString *_id;
    NSString *_SKUId;
    NSString *_numText;
    NSString * _min;
    NSString * _max;
    CGFloat _totalPrice;
    NSString *_deposit;
    NSInteger _recordeSelected;
    NSString *_presale;
    BOOL _state;
    NSString *_isForm;
}

@property (nonatomic ,weak) UIView *coverView;

@property (nonatomic ,weak) UIView *attributesView;

@property (nonatomic ,weak) UICollectionView *collectionView;

@property (nonatomic ,weak) UIImageView *imageView;

@property (nonatomic ,weak) UILabel *nameLabel;

@property (nonatomic ,weak) UILabel *priceLabel;

@property (nonatomic ,strong) NSMutableArray *goodsArray;

@property (nonatomic ,strong) XNRShoppingCartModel *shopcarModel;

@property (nonatomic ,weak) UIButton *buyBtn;

@property (nonatomic ,weak) UIButton *addBuyCarBtn;

@property (nonatomic ,weak) UIButton *cancelBtn;

@property (nonatomic ,strong) NSMutableArray *dataArr;

@property (nonatomic ,weak) UIView *bgExpectView;

@property (nonatomic , weak) UIView *bgView;

@property (nonatomic , weak) UIView *bgViewF;

@property (nonatomic ,assign) XNRPropertyViewType type;

@property (nonatomic ,copy) NSString *marketPrice;

@property (nonatomic ,strong) NSMutableArray *addtionsArray;

@end

@implementation XNRPropertyView
// 单例
+(id)sharedInstanceWithModel:(XNRShoppingCartModel *)shopcarModel {
    static XNRPropertyView *dm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dm = [[self alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    });
    dm.shopcarModel = shopcarModel;
    [dm initBaseViewAndData];
    return dm;
}

// 懒加载（立即购买的时候，把所有的附加选项_id添加到数组里面）
-(NSMutableArray *)addtionsArray {
    if (!_addtionsArray) {
        _addtionsArray = [NSMutableArray array];
    }
    return _addtionsArray;
}

- (void)changeSelfToIdentify {
    [self.coverView removeFromSuperview];
    [self.attributesView removeFromSuperview];
    self.coverView = nil;
    self.attributesView = nil;
}

- (void)initBaseViewAndData {
   
    if (!self.coverView && !self.attributesView) {
        // 初始化一下
        _recordeSelected = 0;
        _numText = 0;
        [self.addtionsArray removeAllObjects];
        self.goodsArray = [NSMutableArray array];
        _dataArr = [NSMutableArray array];
        if (_isForm) {
            
        }else{
            [self innitialAddtions];
        }

        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UIView *coverView = [[UIView alloc] initWithFrame:window.bounds];
        [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnClick)]];
        coverView.tag = 123;
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.4;
        self.coverView = coverView;
        [window addSubview:coverView];
        
        UIView *attributesView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, PX_TO_PT(980))];
        attributesView.backgroundColor = R_G_B_16(0xfafafa);
        self.attributesView = attributesView;
        [window addSubview:attributesView];
        
        [self createTopView];
        // 获得商品属性数据
        [self getData];
    }
}
-(void)innitialAddtions{
    self.shopcarModel.additions = [NSMutableArray array];
}

#pragma mark - 数据请求
-(void)getData
{
    [KSHttpRequest post:KHomeGetAppProductDetails parameters:@{@"productId":self.shopcarModel.goodsId?self.shopcarModel.goodsId:@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dic =result[@"datas"];
            XNRProductInfo_model *model = [[XNRProductInfo_model alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            _id = dic[@"_id"];
            _deposit = dic[@"deposit"];
            _presale = dic[@"presale"];// 预售商品
            
            model.pictures = (NSMutableArray *)[XNRProductPhotoModel objectArrayWithKeyValuesArray:dic[@"pictures"]];
            model.SKUAttributes = (NSMutableArray *)[XNRSKUAttributesModel objectArrayWithKeyValuesArray:dic[@"SKUAttributes"]];
            
            _recordeSelected = 0;
            NSMutableArray *attributesArray = [NSMutableArray array];
            for (XNRSKUAttributesModel *skuModel in model.SKUAttributes) {
                for (int i = 0; i < skuModel.values.count; i++) {
                    XNRSKUCellModel *cellModel = [[XNRSKUCellModel alloc] init];
                    cellModel.cellValue = [skuModel.values[i] copy];
                    cellModel.name = skuModel.name;
                    cellModel.isEnable = YES;
                    [skuModel.values replaceObjectAtIndex:i withObject:cellModel];
                    // 只有一个属性的SKU商品
                    if (skuModel.values.count == 1) {
                        cellModel.isSelected = YES;
                        [self.collectionView reloadData];
                    if (cellModel.isSelected) {
                            NSDictionary *param = @{@"name":cellModel.name,@"value":cellModel.cellValue};
                            [attributesArray addObject:param];
                            _recordeSelected ++;
                            NSLog(@"_recordeSelected%tu",_recordeSelected);
                            
                        }
                        // 每一个section只有一个属性的sku的时候，自动生成请求参数
                        [self selectedAttributesTOCreateParams:attributesArray andInfoModel:model];
                    }
                 }
            }
            
            
            self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            
            // 价格
            if ([dic[@"SKUPrice"][@"min"] doubleValue] == [dic[@"SKUPrice"][@"max"] doubleValue]) {
                self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[dic[@"SKUPrice"][@"min"] doubleValue]];
                if ([self.priceLabel.text rangeOfString:@".00"].length == 3) {
                    self.priceLabel.text = [self.priceLabel.text substringToIndex:self.priceLabel.text.length-3];
                }

            }else{
                NSString *minPrice = [NSString stringWithFormat:@"%@",dic[@"SKUPrice"][@"min"]];
                NSString *maxPrice = [NSString stringWithFormat:@"%.2f",[dic[@"SKUPrice"][@"max"] doubleValue]];
                
//                if ([minPrice rangeOfString:@".00"].length == 3) {
//                    minPrice = [minPrice substringToIndex:minPrice.length-3];
//                }
                if ([maxPrice rangeOfString:@".00"].length == 3) {
                    maxPrice = [maxPrice substringToIndex:maxPrice.length-3];
                }
                self.priceLabel.text = [NSString stringWithFormat:@"¥ %@ - %@",minPrice,maxPrice];

            }
            
             // 判断是否是预售商品
            if ([_presale integerValue] ==  1) {// 预售
                [self createExpectedView];
                self.priceLabel.text = @"即将上线";
                self.priceLabel.textColor = R_G_B_16(0x909090);

            }else{
                if (_type == XNRBuyType ) {// 立即购买
                    [self createSecondView];
                }else if (_type == XNRAddCartType){// 加入购物车
                    [self createSecondView];
                }else if(_type == XNRisFormType){// 属性选择
                    [self createFirstView];
                }
            }
            
            NSString *imageUrl=[HOST stringByAppendingString:dic[@"thumbnail"]];
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            if (imageUrl == nil || [imageUrl isEqualToString:@""]) {
                [self.imageView setImage:[UIImage imageNamed:@"icon_placehold"]];
            }else{
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
            }}];


            [self.goodsArray addObject:model];
           
            [self createCollectionView];
            
            [self.collectionView reloadData];
       }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)selectedAttributesTOCreateParams:(NSMutableArray *)attributesArray andInfoModel:(XNRProductInfo_model *)model
{
    // 3.生成请求参数
    NSDictionary *params = @{@"product":[NSString stringWithFormat:@"%@",_id],@"attributes":attributesArray,@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
    NSLog(@"【请求参数:】%@",params);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:KSkuquery parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---------返回数据:---------%@",str);
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            NSDictionary *datas = resultObj[@"data"];
            NSDictionary *price = datas[@"price"];
            NSDictionary *marketPrice = datas[@"market_price"];
            
            NSArray *attributes = datas[@"attributes"];
            NSDictionary *skuDict = datas[@"SKU"];
            NSArray *addtions = datas[@"additions"];
            NSDictionary *SKUprice = skuDict[@"price"];
            _SKUId = skuDict[@"_id"];
            if (skuDict[@"_id"]) {
                self.shopcarModel._id = skuDict[@"_id"];
//                self.shopcarModel._id = _id;
                self.shopcarModel.product = skuDict[@"product"];
                
            }

            // 市场价
            if (![KSHttpRequest isNULL:marketPrice[@"min"]] && ![KSHttpRequest isNULL:marketPrice[@"max"]] && [marketPrice[@"min"] integerValue] != 0) {
                if ([marketPrice[@"min"] floatValue] == [marketPrice[@"max"] floatValue]) {
                    _marketPrice = [NSString stringWithFormat:@"市场价¥ %@",marketPrice[@"min"]];
                    if ([_marketPrice rangeOfString:@".00"].length == 3) {
                        _marketPrice = [_marketPrice substringToIndex:_marketPrice.length-3];
                    }
                    
                }else{
                    NSString *minPrice = [NSString stringWithFormat:@"%@",marketPrice[@"min"]];
                    NSString *maxPrice = [NSString stringWithFormat:@"%.2f",[marketPrice[@"max"] doubleValue]];
                    if ([maxPrice rangeOfString:@".00"].length == 3) {
                        maxPrice = [maxPrice substringToIndex:maxPrice.length-3];
                    }
                    _marketPrice = [NSString stringWithFormat:@"市场价¥ %@ - %@",minPrice,maxPrice];
                }
                
            }else{
                _marketPrice = @"";
            }
            
            // 价格区间改变
            if ([price[@"min"] floatValue] == [price[@"max"] floatValue]) {
                
                // 判断是否是预售商品
                if ([_presale integerValue] ==  1) {// 预售
                    self.priceLabel.text = @"即将上线";
                    self.priceLabel.textColor = R_G_B_16(0x909090);
                    
                }else{
                    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[price[@"min"] doubleValue]];
                    if ([self.priceLabel.text rangeOfString:@".00"].length == 3) {
                        self.priceLabel.text = [self.priceLabel.text substringToIndex:self.priceLabel.text.length-3];
                        
                    }
                    
                    
                    if (_deposit != nil) {
                        if ([_deposit floatValue] == 0.00) {
                            _totalPrice = [[[self.priceLabel.text componentsSeparatedByString:@" "] lastObject] floatValue];
                        }else{
                            _totalPrice = [_deposit floatValue];
                            
                        }
                        
                    }else{
                        _totalPrice = [[[self.priceLabel.text componentsSeparatedByString:@" "] lastObject] floatValue];
                    }
                }
                
            } else {
                NSString *minPrice = [NSString stringWithFormat:@"%@",price[@"min"]];
                NSString *maxPrice = [NSString stringWithFormat:@"%.2f",[price[@"max"] doubleValue]];
//                if ([minPrice rangeOfString:@".00"].length == 3) {
//                    minPrice = [minPrice substringToIndex:minPrice.length-3];
//                }
                if ([maxPrice rangeOfString:@".00"].length == 3) {
                    maxPrice = [maxPrice substringToIndex:maxPrice.length-3];
                }
                
                // 判断是否是预售商品
                if ([_presale integerValue] ==  1) {// 预售
                    self.priceLabel.text = @"即将上线";
                    self.priceLabel.textColor = R_G_B_16(0x909090);
                    
                }else{
                    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@ - %@",minPrice,maxPrice];
                }
    
                if (_deposit != nil) {
                    if ([_deposit floatValue] == 0.00) {
                        _totalPrice = [[[self.priceLabel.text componentsSeparatedByString:@" "] lastObject] floatValue];
                    }else{
                        _totalPrice = [_deposit floatValue];
                        
                    }
                    
                }else{
                    _totalPrice = [[[self.priceLabel.text componentsSeparatedByString:@" "] lastObject] floatValue];
                }
                
            }
            
            // 添加到购物车模型里面，方便加入到数据库
            XNRProductInfo_model *newInfoModel = [[XNRProductInfo_model alloc] init];
            newInfoModel.SKUAttributes = (NSMutableArray *)[XNRSKUAttributesModel objectArrayWithKeyValuesArray:attributes];
            newInfoModel.market_price = SKUprice[@"market_price"];
            newInfoModel.platform_price = SKUprice[@"platform_price"];
            newInfoModel._id = skuDict[@"_id"];
            
            _min = SKUprice[@"market_price"];
            NSLog(@"=+__++%@",_min);
            
            if (addtions.count>0) {
                newInfoModel.additions = (NSMutableArray *)[XNRAddtionsModel objectArrayWithKeyValuesArray:addtions];
            }
            
            //5. 添加辅助分区（选完所有的基本分区后添加 少于所有基本分区数量就取消辅助分区）
            if (attributesArray.count == model.SKUAttributes.count) {
                model.additions = newInfoModel.additions;
            } else {
                model.additions = [NSMutableArray array];
                [self.shopcarModel.additions removeAllObjects];
            }
            
            
            [self.collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];
    
}


-(void)createTopView{
    
    UIView *bgTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(220))];
    bgTopView.backgroundColor = R_G_B_16(0xffffff);
    [self.attributesView addSubview:bgTopView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), -PX_TO_PT(30), PX_TO_PT(200), PX_TO_PT(200))];
    imageView.image = [UIImage imageNamed:@"icon_loading-wrong"];
    imageView.layer.borderColor = R_G_B_16(0xe0e0e0).CGColor;
    imageView.layer.borderWidth = 1.0;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;
    imageView.clipsToBounds = YES;
    self.imageView = imageView;
    [self.attributesView addSubview:imageView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(70), PX_TO_PT(20), PX_TO_PT(50), PX_TO_PT(50))];
    [cancelBtn setImage:[UIImage imageNamed:@"details--close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    [self.attributesView addSubview:cancelBtn];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + PX_TO_PT(20), 0, ScreenWidth-CGRectGetMaxX(imageView.frame)-PX_TO_PT(20)-PX_TO_PT(66), PX_TO_PT(100))];
    nameLabel.textColor = R_G_B_16(0x323232);
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
    nameLabel.numberOfLines = 0;
    self.nameLabel = nameLabel;
    [self.attributesView addSubview:nameLabel];
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + PX_TO_PT(20), CGRectGetMaxY(nameLabel.frame), ScreenWidth-CGRectGetMaxX(imageView.frame)-PX_TO_PT(20), PX_TO_PT(38))];
    priceLabel.textColor = R_G_B_16(0xff4e00);
    priceLabel.font = [UIFont systemFontOfSize:PX_TO_PT(38)];
    self.priceLabel = priceLabel;
    [self.attributesView addSubview:priceLabel];
    
}

-(void)createFirstView{
    if (!_bgViewF) {
        UIView *bgViewF=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(980)-PX_TO_PT(80), ScreenWidth, PX_TO_PT(80))];
        bgViewF.backgroundColor=[UIColor whiteColor];
        self.bgViewF = bgViewF;
        [self.attributesView addSubview:bgViewF];
        
        // 立即购买
        UIButton *buyBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, ScreenWidth/2, PX_TO_PT(80)) ImageName:nil Target:self Action:@selector(buyBtnClick) Title:@"立即购买"];
        buyBtn.backgroundColor = [UIColor whiteColor];
        [buyBtn setTitleColor:R_G_B_16(0xfe9b00) forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(32)];
        buyBtn.tag = buyBtnTag;
        self.buyBtn = buyBtn;
        [bgViewF addSubview:buyBtn];
        
        //加入购物车
        UIButton *addBuyCarBtn=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(2), ScreenWidth/2, PX_TO_PT(81)) ImageName:nil Target:self Action:@selector(addBuyCar) Title:@"加入购物车"];
//        addBuyCarBtn.backgroundColor = R_G_B_16(0xfe9b00);
        [addBuyCarBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fe9b00"]] forState:UIControlStateNormal];
        [addBuyCarBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fec366"]] forState:UIControlStateHighlighted];
        addBuyCarBtn.adjustsImageWhenHighlighted = NO;
        [addBuyCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addBuyCarBtn.titleLabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
        self.addBuyCarBtn = addBuyCarBtn;
        [bgViewF addSubview:addBuyCarBtn];

        //分割线
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,1 )];
        line.backgroundColor=R_G_B_16(0xe0e0e0);
        [bgViewF addSubview:line];
    }
}

-(void)createExpectedView
{
    if (!_bgExpectView) {
        UIView *bgExpectView = [[UIView alloc] initWithFrame:CGRectMake(0, PX_TO_PT(980)-PX_TO_PT(80), ScreenWidth, PX_TO_PT(80))];
        bgExpectView.backgroundColor = R_G_B_16(0xe2e2e2);
        self.bgExpectView = bgExpectView;
        [self.attributesView addSubview:bgExpectView];
        
        UILabel *expectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80))];
        expectLabel.text = @"敬请期待";
        expectLabel.textAlignment = NSTextAlignmentCenter;
        expectLabel.textColor = R_G_B_16(0x909090);
        expectLabel.font = [UIFont systemFontOfSize:PX_TO_PT(36)];
        [bgExpectView addSubview:expectLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        lineView.backgroundColor = R_G_B_16(0xe0e0e0);
        [bgExpectView addSubview:lineView];
        
    }
}
-(void)createSecondView{
    if (!_bgView) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(980)-PX_TO_PT(80), ScreenWidth, PX_TO_PT(80))];
        bgView.backgroundColor=[UIColor whiteColor];
        self.bgView = bgView;
        [self.attributesView addSubview:bgView];
        
        // 确定
        UIButton *admireBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(80)) ImageName:nil Target:self Action:@selector(admireBtnClick) Title:@"确定"];
//        admireBtn.backgroundColor = R_G_B_16(0xfe9b00);
        [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fe9b00"]] forState:UIControlStateNormal];
        [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#fec366"]] forState:UIControlStateHighlighted];
        [admireBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        admireBtn.titleLabel.font=[UIFont systemFontOfSize:PX_TO_PT(32)];
        [bgView addSubview:admireBtn];
    }
}
#pragma mark - 确定
-(void)admireBtnClick
{
    if (_type == XNRBuyType) {// 立即购买
        [self buyBtnClick];
        
    }else if (_type == XNRAddCartType){// 加入购物车
        [self addBuyCar];
    }
}
#pragma mark - 立即购买
-(void)buyBtnClick
{
    XNRProductInfo_model *model = [self.goodsArray lastObject];
    if (model.SKUAttributes.count == _recordeSelected) {
        if (!IS_Login) {
            BMAlertView *alertView = [[BMAlertView alloc] initTextAlertWithTitle:nil content:@"您还没有登录，是否登录？" chooseBtns:@[@"取消",@"确定"]];
            __weak __typeof(self)weakSelf = self;
            alertView.chooseBlock = ^void(UIButton *btn){
                if (btn.tag == 11) {
                    [self cancelBtnClick];
                    weakSelf.loginBlock();
                }
            };
            [alertView BMAlertShow];
            
        }else{
            // 先加入购物车
            _state = YES;
            [self synchShoppingCarDataWithoutToast];
            NSMutableArray *SKUs = [NSMutableArray array];
            [SKUs removeAllObjects];
            NSDictionary *param = @{@"_id":self.shopcarModel._id?self.shopcarModel._id:@"",@"count":_numText?_numText:@"1",@"additions":self.shopcarModel.additions,@"product":self.shopcarModel.product?self.shopcarModel.product:@"",@"token":[DataCenter account].token?[DataCenter account].token:@""};
            [SKUs addObject:param];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            [manager POST:KGetShoppingCartOffline parameters:@{@"SKUs":SKUs,@"user-agent":@"IOS-v2.0"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary *resultDic;
                if ([resultObj isKindOfClass:[NSDictionary class]]) {
                    resultDic = (NSDictionary *)resultObj;
                }
                if ([resultObj[@"code"] integerValue] == 1000) {
                    NSDictionary *datasDic = resultDic[@"datas"];
                    NSArray *rowsArr = datasDic[@"rows"];
                    for (NSDictionary *subDic in rowsArr) {
                        XNRShopCarSectionModel *sectionModel = [[XNRShopCarSectionModel alloc] init];
                        sectionModel.brandName = subDic[@"brandName"];
                        
                        NSArray *SKUList = subDic[@"SKUList"];
                        for (NSDictionary *dict in SKUList) {
                            sectionModel.goodsCount = dict[@"count"];
                            sectionModel.deposit = dict[@"deposit"];
                            sectionModel.unitPrice = dict[@"price"];
                        }
                        
                        sectionModel.SKUList = (NSMutableArray *)[XNRShoppingCartModel objectArrayWithKeyValuesArray:subDic[@"SKUList"]];
                        [_dataArr addObject:sectionModel];
                        
                        for (int i = 0; i<sectionModel.SKUList.count; i++) {
                            XNRShoppingCartModel *model = sectionModel.SKUList[i];
                            model.num = model.totalCount;
                        }
                    }
                    // 订单页的跳转
                    [self cancelBtnClick];
        
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
                    if (_state == YES) {
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            self.com(SKUs,_totalPrice*([_numText floatValue]?[_numText floatValue]:[@"1" intValue]),_numText?_numText:@"1");
                        });
                    }
                }else{
                    
                    [UILabel showMessage:resultObj[@"message"]];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"===%@",error);
                
            }];
        }
    }else{
        [UILabel showMessage:@"请选择商品信息"];
    }
    
}

#pragma mark-加入购物车
-(void)addBuyCar
{
//    [self XNRAddShoppingCarBlock];
    
    XNRProductInfo_model *model = [self.goodsArray lastObject];
    if (model.SKUAttributes.count == _recordeSelected) {
        if(IS_Login == YES) {
            [self synchShoppingCarData];
            
        } else {
            [self cancelBtnClick];
            [self successOrfail];
        }

    }else{
        [UILabel showMessage:@"请选择商品信息"];

    }

}
-(void)successOrfail
{
    BOOL b;
    DatabaseManager *manager = [DatabaseManager sharedInstance];
    // 查询数据库是否有该商品
    NSArray *modelArr = [manager queryGoodWithModel:self.shopcarModel];
    // 数据库没有该商品(插入)
    if (modelArr.count == 0) {
        self.shopcarModel.timeStamp = [CommonTool timeSp];  //时间戳
        self.shopcarModel.num = _numText?_numText:@"1";
        self.shopcarModel.shoppingCarCount = [manager shoppingCarCount];
        b = [manager insertShoppingCarWithModel:self.shopcarModel];
        self.shopcarModel.num = @"0";
    }
    //数据库有该商品(更新)
    else{
        XNRShoppingCartModel *model = [modelArr firstObject];
        model.num = [NSString stringWithFormat:@"%d",model.num.intValue+([_numText intValue]?[_numText intValue]:[@"1" intValue])];
        model.timeStamp = [CommonTool timeSp];  //时间戳
        model.shoppingCarCount = [manager shoppingCarCount];
        model.additions = self.shopcarModel.additions;
        b = [manager updateShoppingCarWithModel:model];
    }
    if (b) {
        self.XNRAddShoppingCarBlock();
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [UILabel showMessage:@"加入购物车成功"];
        });
    }else{
        
        [UILabel showMessage:@"加入购物车失败"];
    }

}
-(void)synchShoppingCarDataWithoutToast
{
    XNRProductInfo_model *infoModel = [self.goodsArray lastObject];
    NSMutableArray *addtionArray = [NSMutableArray array];
    for (XNRAddtionsModel *addtionModel in infoModel.additions) {
        
        if (addtionModel.isSelected) {
            [addtionArray addObject:addtionModel.ref];
        }
    }
    NSDictionary *params;
    if (self.shopcarModel._id) {
        params = @{@"SKUId":self.shopcarModel._id?self.shopcarModel._id:@"",@"quantity":_numText?_numText:@"1",@"additions":addtionArray,@"update_by_add":@"true",@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:KAddToCart parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            // 把选择的属性值传过去
            [self pressAttributes];
            [self cancelBtnClick];
        }else{
            [UILabel showMessage:resultObj[@"message"]];
            [self cancelBtnClick];
            UserInfo *infos = [[UserInfo alloc]init];
            infos.loginState = NO;
            [DataCenter saveAccount:infos];
            //发送刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PageRefresh" object:nil];
            
            XNRLoginViewController *vc = [[XNRLoginViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            UIViewController *currentVc = [[AppDelegate shareAppDelegate] getTopViewController];
            [currentVc.navigationController pushViewController:vc animated:YES];
            _state = NO;

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];

}

// 上传购物车数据
- (void)synchShoppingCarData
{
    XNRProductInfo_model *infoModel = [self.goodsArray lastObject];
    NSMutableArray *addtionArray = [NSMutableArray array];
    for (XNRAddtionsModel *addtionModel in infoModel.additions) {
        
        if (addtionModel.isSelected) {
            [addtionArray addObject:addtionModel.ref];
            NSLog(@"0-=9=90%@",addtionArray);
        }
    }
    NSDictionary *params;
    if (self.shopcarModel._id) {
        params = @{@"SKUId":self.shopcarModel._id?self.shopcarModel._id:@"",@"quantity":_numText?_numText:@"1",@"additions":addtionArray,@"update_by_add":@"true",@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
        
        NSLog(@"())__)%@",params);
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:KAddToCart parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
//            [UILabel showMessage:@"加入购物车成功"];
            // 把选择的属性值传过去
            [self pressAttributes];
            [self cancelBtnClick];
<<<<<<< HEAD
            
        }else{
        [self cancelBtnClick];
        _state = NO;
=======
            [self successOrfail];
            [BMProgressView LoadViewDisappear:self];
            
            
        }
        else{
            [UILabel showMessage:resultDic[@"message"]];
            [self cancelBtnClick];
            [BMProgressView LoadViewDisappear:self];
            _state = NO;
>>>>>>> ynn_ios
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];
}
#pragma mark - 把属性值传过去
-(void)pressAttributes{
    XNRProductInfo_model *infoModel = [self.goodsArray lastObject];
    NSMutableArray *attributesArray = [NSMutableArray array];
    NSString * attributeStr = @"已选择";
    for (XNRSKUAttributesModel *skuModel in infoModel.SKUAttributes) {
        for (XNRSKUCellModel *cellModel in skuModel.values) {
            if (cellModel.isSelected) {
                attributeStr = [attributeStr stringByAppendingString:[NSString stringWithFormat:@"“%@”",cellModel.cellValue]];
                [attributesArray addObject:attributeStr];
                NSLog(@"0-=--------9909%@",attributesArray);
            }
            NSLog(@"9090%@", attributeStr);
        }
    }
    NSString *addtionStr = @"";
    NSMutableArray *addtionArray = [NSMutableArray array];
    [addtionArray removeAllObjects];
    for (XNRAddtionsModel *addtionModel in infoModel.additions) {
        
        if (addtionModel.isSelected) {
            addtionStr = [addtionStr stringByAppendingString:[NSString stringWithFormat:@"“%@”",addtionModel.name]];
            [addtionArray addObject:addtionStr];
            NSLog(@"0-=9=90%@",addtionArray);
        }
    }
    if (attributesArray.count == 0) {
        _marketPrice = nil;
    }

        self.valueBlock(attributesArray,addtionArray,self.priceLabel.text,_marketPrice);
    
}
#pragma mark - createCollectionView
-(void)createCollectionView
{
    if (!_collectionView) {
        XNRCollectionViewFlowLayout *collectionViewLayout = [[XNRCollectionViewFlowLayout alloc] init];
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(220), ScreenWidth-2*PX_TO_PT(30), PX_TO_PT(680)) collectionViewLayout:collectionViewLayout];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[XNRPropertyBrandView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId];
        [collectionView registerClass:[XNRPropertyFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewId];
        [collectionView registerClass:[XNRPropertyEmptyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:emptyViewId];
        [collectionView registerClass:[XNRPropertyCollectionViewCell class] forCellWithReuseIdentifier:cellId];
        [collectionView registerClass:[XNRPropertyCollectionViewCell class] forCellWithReuseIdentifier:@"addtionCell"];
        collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView = collectionView;
        self.collectionView.collectionViewLayout = collectionViewLayout;
        [self.attributesView addSubview:collectionView];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (self.goodsArray.count>0) {
        
        XNRProductInfo_model *infoModel = [self.goodsArray lastObject];
        NSLog(@"%tu++++__",infoModel.additions.count);
        if (infoModel.additions.count>0) {
            return infoModel.SKUAttributes.count + 1;

        }else{
            return infoModel.SKUAttributes.count;
        }
       
    } else {
        
        return 0;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    XNRProductInfo_model *model = [self.goodsArray lastObject];
    
    if (model.SKUAttributes.count>section) {
        
        XNRSKUAttributesModel *skuModel = model.SKUAttributes[section];
        return skuModel.values.count;
    } else if (section>=model.SKUAttributes.count) {
        
        return model.additions.count;
    } else {
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XNRProductInfo_model *infoModel = [self.goodsArray lastObject];
    if (infoModel.SKUAttributes.count>indexPath.section) {
        
        XNRPropertyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        
        XNRSKUAttributesModel *skuModel = infoModel.SKUAttributes[indexPath.section];
        [cell updateCellWithCellModel:skuModel.values[indexPath.item]];
                return cell;
    } else if (infoModel.SKUAttributes.count<=indexPath.section) {
        
        XNRPropertyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addtionCell" forIndexPath:indexPath];
        XNRAddtionsModel *addtionCellModel = infoModel.additions[indexPath.item];
        [cell updateCellWithCellModel:addtionCellModel];
        return cell;
    } else {
        
        return [[UICollectionViewCell alloc] init];
    }
}
#pragma mark - UICollectionViewDelegate
// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XNRProductInfo_model *infoModel = [self.goodsArray lastObject];
    if (indexPath.section < infoModel.SKUAttributes.count) {//选择attribute section 的分区
        
        XNRSKUAttributesModel *selectedSectionModel = infoModel.SKUAttributes[indexPath.section];
        // 0.先判断[点击]的cell 是否[可用]
        XNRSKUCellModel *selectedCellM = selectedSectionModel.values[indexPath.item];
        if (!selectedCellM.isEnable) {
            return;
        }
        // 1.然后确定当前要[选中]的是[section] 中的[哪个cell] 并且 如果[点击]了已经选中的 要[取消]选中
        for (int i = 0; i < selectedSectionModel.values.count; i++) {
            
            XNRSKUCellModel *cellModel = selectedSectionModel.values[i];
            if (cellModel.isSelected&&indexPath.item == i) {
                cellModel.isSelected = NO;
            } else {
                cellModel.isSelected = indexPath.item == i;
            }
        }
        
        // 2.遍历所有的section 所有的cell 如果有被选中的cell 需要添加到请求参数数组里面 以备网络请求使用
        NSMutableArray *attributesArray = [[NSMutableArray alloc] init];
        _recordeSelected = 0;
        for (XNRSKUAttributesModel *sectionModel in infoModel.SKUAttributes) {
            for (XNRSKUCellModel *cellM in sectionModel.values) {
                if (cellM.isSelected) {
                    NSDictionary *param = @{@"name":sectionModel.name,@"value":cellM.cellValue};
                    [attributesArray addObject:param];
                    _recordeSelected ++;
                    NSLog(@"_recordeSelected%tu",_recordeSelected);
                    [self.addtionsArray removeAllObjects];
                }
            }
        }
        // 3.生成请求参数
        NSDictionary *params = @{@"product":[NSString stringWithFormat:@"%@",_id],@"attributes":attributesArray,@"token":[DataCenter account].token?[DataCenter account].token:@"",@"user-agent":@"IOS-v2.0"};
        NSLog(@"【请求参数:】%@",params);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];// 申明请求的数据是json类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:KSkuquery parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"---------返回数据:---------%@",str);
            id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *resultDic;
            if ([resultObj isKindOfClass:[NSDictionary class]]) {
                resultDic = (NSDictionary *)resultObj;
            }
            if ([resultObj[@"code"] integerValue] == 1000) {
                NSDictionary *datas = resultObj[@"data"];
                NSDictionary *price = datas[@"price"];
                NSDictionary *marketPrice = datas[@"market_price"];
                // 市场价
                if (![KSHttpRequest isNULL:marketPrice[@"min"]] && ![KSHttpRequest isNULL:marketPrice[@"max"]] &&[marketPrice[@"min"] integerValue] != 0 ) {
                    if ([marketPrice[@"min"] floatValue] == [marketPrice[@"max"] floatValue]) {
                        _marketPrice = [NSString stringWithFormat:@"市场价¥ %@",marketPrice[@"min"]];
//                        if ([_marketPrice rangeOfString:@".00"].length == 3) {
//                            _marketPrice = [_marketPrice substringToIndex:_marketPrice.length-3];
//                        }
                        
                    }else{
                        NSString *minPrice = [NSString stringWithFormat:@"%@",marketPrice[@"min"]];
                        NSString *maxPrice = [NSString stringWithFormat:@"%.2f",[marketPrice[@"max"] doubleValue]];
//                        if ([minPrice rangeOfString:@".00"].length == 3) {
//                            minPrice = [minPrice substringToIndex:minPrice.length-3];
//                        }
                        if ([maxPrice rangeOfString:@".00"].length == 3) {
                            maxPrice = [maxPrice substringToIndex:maxPrice.length-3];
                        }
                        _marketPrice = [NSString stringWithFormat:@"市场价¥ %@ - %@",minPrice,maxPrice];
                        
                    }

                }else{
                    _marketPrice = @"";
                }
                // 价格区间改变
                if ([price[@"min"] floatValue] == [price[@"max"] floatValue]) {
                    // 判断是否是预售商品
                    if ([_presale integerValue] ==  1) {// 预售
                        self.priceLabel.text = @"即将上线";
                        self.priceLabel.textColor = R_G_B_16(0x909090);
                        
                    }else{
                        self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[price[@"min"] doubleValue]];
                        if ([self.priceLabel.text rangeOfString:@".00"].length == 3) {
                            self.priceLabel.text = [self.priceLabel.text substringToIndex:self.priceLabel.text.length-3];
                    }
                        if (_deposit != nil) {
                            if ([_deposit floatValue] == 0.00) {
                                _totalPrice = [[[self.priceLabel.text componentsSeparatedByString:@" "] lastObject] floatValue];
                            }else{
                                _totalPrice = [_deposit floatValue];
                                
                            }
                            
                        }else{
                            _totalPrice = [[[self.priceLabel.text componentsSeparatedByString:@" "] lastObject] floatValue];
                        }
                    }

                } else {
                    NSString *minPrice = [NSString stringWithFormat:@"%@",price[@"min"]];
                    NSString *maxPrice = [NSString stringWithFormat:@"%.2f",[price[@"max"] doubleValue]];
//                    if ([minPrice rangeOfString:@".00"].length == 3) {
//                        minPrice = [minPrice substringToIndex:minPrice.length-3];
//                    }
                    if ([maxPrice rangeOfString:@".00"].length == 3) {
                        maxPrice = [maxPrice substringToIndex:maxPrice.length-3];
                    }
                    // 判断是否是预售商品
                    if ([_presale integerValue] ==  1) {// 预售
                        self.priceLabel.text = @"即将上线";
                        self.priceLabel.textColor = R_G_B_16(0x909090);
                        
                    }else{
                        self.priceLabel.text = [NSString stringWithFormat:@"¥ %@ - %@",minPrice,maxPrice];

                    }

                    if (_deposit != nil) {
                        if ([_deposit floatValue] == 0.00) {
                            _totalPrice = [[[self.priceLabel.text componentsSeparatedByString:@" "] lastObject] floatValue];
                        }else{
                            _totalPrice = [_deposit floatValue];
                            
                        }
                        
                    }else{
                        _totalPrice = [[[self.priceLabel.text componentsSeparatedByString:@" "] lastObject] floatValue];
                    }


                }
                
                NSArray *attributes = datas[@"attributes"];
                NSDictionary *skuDict = datas[@"SKU"];
                NSArray *addtions = datas[@"additions"];
                NSDictionary *SKUprice = skuDict[@"price"];
                _SKUId = skuDict[@"_id"];
                
                // 添加到购物车模型里面，方便加入到数据库
                self.shopcarModel._id = skuDict[@"_id"];
                self.shopcarModel.product = skuDict[@"product"];

                XNRProductInfo_model *newInfoModel = [[XNRProductInfo_model alloc] init];
                newInfoModel.SKUAttributes = (NSMutableArray *)[XNRSKUAttributesModel objectArrayWithKeyValuesArray:attributes];
                newInfoModel.market_price = SKUprice[@"market_price"];
                newInfoModel.platform_price = SKUprice[@"platform_price"];
                newInfoModel._id = skuDict[@"_id"];
                
                _min = SKUprice[@"market_price"];
                NSLog(@"=+__++%@",_min);
                
                if (addtions.count>0) {
                    newInfoModel.additions = (NSMutableArray *)[XNRAddtionsModel objectArrayWithKeyValuesArray:addtions];
                }
                //4.遍历所有数据 和 新请求返回的数据  进行每个cell的比对 以确定哪一个cell是需要变成不可用状态的
                for (int i = 0; i < infoModel.SKUAttributes.count; i++) {
                    XNRSKUAttributesModel *skuModel = infoModel.SKUAttributes[i];
                    for (int j = 0; j < newInfoModel.SKUAttributes.count; j++) {
                        XNRSKUAttributesModel *newSkuModel  = newInfoModel.SKUAttributes[j];
                        if ([skuModel.name isEqualToString:newSkuModel.name]) {
                            NSLog(@"分区 %@ 和新分区 %@",skuModel.name,newSkuModel.name);
                            if (indexPath.section != i) {
                                NSLog(@"[选中的分区：%d,选中的item:%d]",(int)indexPath.section,(int)indexPath.item);
                                
                                for (XNRSKUCellModel *cellModel in skuModel.values) {
                                    cellModel.isEnable = NO;
                                }
                                
                                NSMutableSet *enabledSet = [NSMutableSet set];
                                for (int m = 0; m < skuModel.values.count; m++) {
                                    XNRSKUCellModel *cellModel = skuModel.values[m];
                                    for (int n = 0; n < newSkuModel.values.count; n++) {
                                        NSString *cellValue = newSkuModel.values[n];
                                        NSLog(@"[比较section：%d,item:%d的ALL元素：%@和新元素：%@]",i,m,cellModel.cellValue,cellValue);
                                        if ([cellValue isEqualToString:cellModel.cellValue]) {
                                            [enabledSet addObject:[NSNumber numberWithInt:m]];
                                        }
                                    }
                                }
                                
                                for (NSNumber *enableNum in enabledSet) {
                                    XNRSKUCellModel *cellModel = skuModel.values[enableNum.intValue];
                                    cellModel.isEnable = YES;
                                }
                                
                            } else {
                                
                            }
                        }
                        
                    }
                }
                
                //5. 添加辅助分区（选完所有的基本分区后添加 少于所有基本分区数量就取消辅助分区）
                if (attributesArray.count==infoModel.SKUAttributes.count) {
                    infoModel.additions = newInfoModel.additions;
                } else {
                    infoModel.additions = [NSMutableArray array];
                    [self.shopcarModel.additions removeAllObjects];
                }
                
                [self.collectionView reloadData];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"===%@",error);
            
        }];
    } else { // 选择了 addtion section（附加选项） 分区
        CGFloat currentPrice = [[[self.priceLabel.text componentsSeparatedByString:@" "] lastObject] floatValue];
        CGFloat currentMarketPrice = [[[_marketPrice componentsSeparatedByString:@" "] lastObject] floatValue];
        for (XNRAddtionsModel *addtionCellModel in infoModel.additions) {
            
            if (addtionCellModel.isSelected&&indexPath.item == [infoModel.additions indexOfObject:addtionCellModel]) {
                addtionCellModel.isSelected = NO;
            } else {
                if (!addtionCellModel.isSelected) {
                    addtionCellModel.isSelected = indexPath.item == [infoModel.additions indexOfObject:addtionCellModel];
                }
            }
            //计算价格和市场价的总价
            if (indexPath.item == [infoModel.additions indexOfObject:addtionCellModel]) {
                CGFloat addPrice = [addtionCellModel.price floatValue];
                if (_deposit != nil) {
                    if ([_deposit floatValue] == 0.00) {
                        _totalPrice = (currentPrice + addPrice);

                    }else{
                        _totalPrice = [_deposit floatValue];
                    }
                }else{
                    _totalPrice = (currentPrice + addPrice);

                }
                if (addtionCellModel.isSelected) {// 选中
                    // 价格
                  
                    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",currentPrice+addPrice];

                    if ([self.priceLabel.text rangeOfString:@".00"].length == 3) {
                        self.priceLabel.text = [self.priceLabel.text substringToIndex:self.priceLabel.text.length-3];
                    }
                    
                    // 市场价
                    if (currentMarketPrice == 0) {
                        _marketPrice = @"";
                        
                    }else{
                        _marketPrice = [NSString stringWithFormat:@"市场价¥ %.2f",currentMarketPrice+addPrice];
                    }
                    if ([_marketPrice rangeOfString:@".00"].length == 3) {
                        _marketPrice = [_marketPrice substringToIndex:_marketPrice.length-3];
                    }
                    
                    [self.addtionsArray addObject:[addtionCellModel keyValues]];
                    
//                    NSLog(@"9090eod--%tu--f",self.addtionsArray.count);
                    
                } else {
//                    NSLog(@"9090eod--%tu--s",self.addtionsArray.count);
                    
                    // 价格
                    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",currentPrice-addPrice];
                    if ([self.priceLabel.text rangeOfString:@".00"].length == 3) {
                        self.priceLabel.text = [self.priceLabel.text substringToIndex:self.priceLabel.text.length-3];
                    }
                    // 市场价
                    if (currentMarketPrice == 0) {
                        _marketPrice = @"";
                    }else{
                        _marketPrice = [NSString stringWithFormat:@"市场价¥ %.2f",currentMarketPrice-addPrice];
                    }
                    if ([_marketPrice rangeOfString:@".00"].length == 3) {
                        _marketPrice = [_marketPrice substringToIndex:_marketPrice.length-3];
                    }
                    
                    NSInteger wouldCancelIndex = -1;
                    for (NSDictionary *wouldCancelDic in self.addtionsArray) {
                        if ([[NSString stringWithFormat:@"%@",[wouldCancelDic objectForKey:@"name"]] isEqualToString:[NSString stringWithFormat:@"%@",addtionCellModel.name]]) {
                            wouldCancelIndex = [self.addtionsArray indexOfObject:wouldCancelDic];
                        }
                    }
                    if (wouldCancelIndex != -1) {
                        [self.addtionsArray removeObjectAtIndex:wouldCancelIndex];
                    }
                    
                    NSLog(@"--%tu--",self.addtionsArray.count);
                    
                }
            }
        }
        self.shopcarModel.additions = [NSMutableArray arrayWithArray:self.addtionsArray];
//        NSLog(@"self.shopcarModel.additions----%tu",self.shopcarModel.additions.count);
        [self.collectionView reloadData];
    }
}

#pragma mark  - UICollectionViewDelegateFlowLayout
//返回头部headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, PX_TO_PT(102));
}
// 返回尾部footView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    XNRProductInfo_model *infoModel;
    for (int i = 0; i<self.goodsArray.count; i++) {
        infoModel = self.goodsArray[i];
    }
    if (infoModel.additions.count>0) {
        if (section == infoModel.SKUAttributes.count) {
            
            return CGSizeMake(ScreenWidth, PX_TO_PT(140));
        } else {
            
            return CGSizeZero;
        }

    }else{
        if (section == infoModel.SKUAttributes.count - 1) {
            
            return CGSizeMake(ScreenWidth, PX_TO_PT(140));
        } else {
            
            return CGSizeZero;
        }
    }
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    XNRProductInfo_model *infoModel = [self.goodsArray lastObject];
    if (infoModel.SKUAttributes.count>indexPath.section) {
        XNRSKUAttributesModel *skuModel = infoModel.SKUAttributes[indexPath.section];
        XNRSKUCellModel *model = skuModel.values[indexPath.item];
        CGSize valueSize = [model.cellValue sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(28)]}];
        currentSize = CGSizeMake(valueSize.width + PX_TO_PT(10), valueSize.height+PX_TO_PT(10));

    }else if (infoModel.SKUAttributes.count<=indexPath.section){
        XNRAddtionsModel *addtionModel = infoModel.additions[indexPath.item];
        NSString *addtionStr = [NSString stringWithFormat:@"%@(+%@)",addtionModel.name,addtionModel.price];
        CGSize valueSize = [addtionStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(28)]}];
        currentSize = CGSizeMake(valueSize.width+ PX_TO_PT(10), valueSize.height+ PX_TO_PT(10));

    }else{
        currentSize = CGSizeMake(0, 0);
    
    }
    
    return currentSize;
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return coll_cell_margin;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return coll_cell_margin;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        XNRPropertyBrandView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId forIndexPath:indexPath];
        XNRProductInfo_model *infoModel;
        for (int i = 0; i<self.goodsArray.count; i++) {
            infoModel = self.goodsArray[i];
        }
        
        if (indexPath.section<infoModel.SKUAttributes.count) {
            XNRSKUAttributesModel *skuModel = infoModel.SKUAttributes[indexPath.section];
            if (infoModel.SKUAttributes.count>0) {
                headerView.selectTitleLabel.text = skuModel.name;
            }
        } else {
            if (infoModel.additions.count>0) {
                headerView.selectTitleLabel.text = @"附加选项";
            }
        }
        reusableview = headerView;
    } else {
        
        XNRProductInfo_model *model;
        for (int i = 0; i<self.goodsArray.count; i++) {
            model = self.goodsArray[i];
        }
        NSLog(@"++____%@",indexPath);
        if ([_presale integerValue] == 1) {
            XNRPropertyEmptyView *emptyView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:emptyViewId forIndexPath:indexPath];
            reusableview = emptyView;
        }else{
            XNRPropertyFootView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewId forIndexPath:indexPath];
            footView.com = ^(NSString *numTF){
                _numText = numTF;
                
            };
            reusableview = footView;
        }
    }
    return reusableview;
}

-(void)cancelBtnClick{
    
    [UIView animateWithDuration:.3 animations:^{
        self.attributesView.frame = CGRectMake(0, ScreenHeight+30, ScreenWidth, PX_TO_PT(980));
        // 把键盘退掉
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        [manager resignFirstResponder];
    } completion:^(BOOL finished) {
        [self pressAttributes];
        self.coverView.hidden = YES;
    }];
}
-(void)show:(XNRPropertyViewType)buyType{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hhh:) name:@"hhh" object:nil];
    _isForm = nil;
    _type = buyType;
    self.coverView.hidden = NO;
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [UIView animateWithDuration:.3 animations:^{
        self.attributesView.frame= CGRectMake(0, ScreenHeight-PX_TO_PT(980), ScreenWidth, PX_TO_PT(980));
        if (buyType == XNRBuyType ) {// 立即购买
            [self createSecondView];
        }else if (buyType == XNRAddCartType){// 加入购物车
            [self createSecondView];
        }else if(buyType == XNRisFormType){// 属性选择
            [self createFirstView];
        }
    }];
}

-(void)hhh:(NSNotification *)notification
{
    NSString* hh = [notification.userInfo valueForKey:@"hh"];
    _isForm = hh;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
