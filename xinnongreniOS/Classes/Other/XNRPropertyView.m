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
#import "XNRPropertyCollectionViewCell.h"
#import "XNRProductInfo_model.h"
#import "XNRProductPhotoModel.h"
#import "XNRSKUAttributesModel.h"
#import "XNRAddtionsModel.h"
#import "UIImageView+WebCache.h"

#import "XNRChangeAttributesModel.h"

#define coll_cell_margin 15
#define cellId @"selected_cell"
#define headerViewId @"selectedHeaderView"
#define footViewId @"selectedFootView"


@interface XNRPropertyView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    CGSize currentSize;
}

@property (nonatomic ,weak) UIView *coverView;

@property (nonatomic ,weak) UIView *attributesView;

@property (nonatomic ,weak) UICollectionView *collectionView;

@property (nonatomic ,weak) UIImageView *imageView;

@property (nonatomic ,weak) UILabel *nameLabel;

@property (nonatomic ,weak) UILabel *priceLabel;

@property (nonatomic ,strong) NSMutableArray *goodsArray;

@property (nonatomic ,copy) NSString *goodsId;


@end

@implementation XNRPropertyView


-(instancetype)initWithFrame:(CGRect)frame goodsId:(NSString *)goodsId
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.goodsId = goodsId;
        // 获得商品属性数据
        [self getData];
        _goodsArray = [NSMutableArray array];
        
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
        
        [self createView];
        
    }
    return self;

}

-(void)getData
{
    
    [KSHttpRequest post:KHomeGetAppProductDetails parameters:@{@"productId":self.goodsId?self.goodsId:@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dic =result[@"datas"];
            XNRProductInfo_model *model = [[XNRProductInfo_model alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            model.pictures = (NSMutableArray *)[XNRProductPhotoModel objectArrayWithKeyValuesArray:dic[@"pictures"]];
            
            model.SKUAttributes = (NSMutableArray *)[XNRSKUAttributesModel objectArrayWithKeyValuesArray:dic[@"SKUAttributes"]];
            
            model.additions = (NSMutableArray *)[XNRAddtionsModel objectArrayWithKeyValuesArray:dic[@"SKUAdditions"]];
            
            self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            NSLog(@"+++__%@++++%@",dic[@"referencePrice"][@"min"],dic[@"referencePrice"][@"max"]);
            if ([dic[@"referencePrice"][@"min"] floatValue] == [dic[@"referencePrice"][@"max"] floatValue]) {
                self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",dic[@"referencePrice"][@"min"]];
            }else{
                self.priceLabel.text = [NSString stringWithFormat:@"¥ %@ - ¥ %@",dic[@"referencePrice"][@"min"],dic[@"referencePrice"][@"max"]];
            }


            NSString *imageUrl=[HOST stringByAppendingString:dic[@"thumbnail"]];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_loading_wrong"]];
            
            [_goodsArray addObject:model];
            [self createCollectionView];
            
            [self.collectionView reloadData];
       }
        
    } failure:^(NSError *error) {
        
    }];

    
}

-(void)createView{
    
    UIView *bgTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PX_TO_PT(220))];
    bgTopView.backgroundColor = R_G_B_16(0xffffff);
    [self.attributesView addSubview:bgTopView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), -PX_TO_PT(30), PX_TO_PT(200), PX_TO_PT(200))];
    imageView.image = [UIImage imageNamed:@"icon_loading-wrong"];
    imageView.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    imageView.layer.borderWidth = 1.0;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;
    imageView.clipsToBounds = YES;
    self.imageView = imageView;
    [self.attributesView addSubview:imageView];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(PX_TO_PT(30), PX_TO_PT(220), ScreenWidth-PX_TO_PT(60), PX_TO_PT(1))];
//    lineView.backgroundColor = R_G_B_16(0xc7c7c7);
//    [self.attributesView addSubview:lineView];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-PX_TO_PT(54), PX_TO_PT(20), PX_TO_PT(34), PX_TO_PT(34))];
    [cancelBtn setImage:[UIImage imageNamed:@"details--close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.attributesView addSubview:cancelBtn];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + PX_TO_PT(20), 0, ScreenWidth-CGRectGetMaxX(imageView.frame)-PX_TO_PT(20)-PX_TO_PT(66), PX_TO_PT(100))];
    nameLabel.textColor = R_G_B_16(0x323232);
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.numberOfLines = 0;
    self.nameLabel = nameLabel;
    [self.attributesView addSubview:nameLabel];
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + PX_TO_PT(20), CGRectGetMaxY(nameLabel.frame), ScreenWidth-CGRectGetMaxX(imageView.frame)-PX_TO_PT(20)-PX_TO_PT(66), PX_TO_PT(34))];
    priceLabel.textColor = R_G_B_16(0xff4e00);
    priceLabel.font = [UIFont systemFontOfSize:20];
    self.priceLabel = priceLabel;
    [self.attributesView addSubview:priceLabel];

    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(980)-PX_TO_PT(80), ScreenWidth, PX_TO_PT(80))];
    bgView.backgroundColor=[UIColor whiteColor];
//    self.bgView = bgView;
    [self.attributesView addSubview:bgView];
    
    // 立即购买
    UIButton *buyBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, ScreenWidth/2, PX_TO_PT(80)) ImageName:nil Target:self Action:@selector(buyBtnClick) Title:@"立即购买"];
    buyBtn.backgroundColor = [UIColor whiteColor];
    [buyBtn setTitleColor:R_G_B_16(0xfe9b00) forState:UIControlStateNormal];
    buyBtn.titleLabel.font = XNRFont(16);
//    self.buyBtn = buyBtn;
    [bgView addSubview:buyBtn];
    
    //加入购物车
    UIButton *addBuyCarBtn=[MyControl createButtonWithFrame:CGRectMake(ScreenWidth/2, PX_TO_PT(2), ScreenWidth/2, PX_TO_PT(81)) ImageName:nil Target:self Action:@selector(addBuyCar) Title:@"加入购物车"];
    addBuyCarBtn.backgroundColor = R_G_B_16(0xfe9b00);
    [addBuyCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBuyCarBtn.titleLabel.font=XNRFont(16);
//    self.addBuyCarBtn = addBuyCarBtn;
    [bgView addSubview:addBuyCarBtn];
    
    //分割线
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,PX_TO_PT(1) )];
    line.backgroundColor=R_G_B_16(0xc7c7c7);
    [bgView addSubview:line];
}

-(void)buyBtnClick
{

}

#pragma mark-加入购物车

-(void)addBuyCar
{
    NSLog(@"加入购物车");
//    [self addShopCarOpeation];

    
//    if([self.numTextField.text isEqualToString:@"1"]||(self.numTextField.text.length != 0)){
//        self.addBuyCarBtn.enabled = YES;
//        [self addShopCarOpeation];
//    }else{
//        
//        [UILabel showMessage:@"请输入正确的商品数量"];
//    }
}

//#pragma mark-加入购物车
//-(void)addShopCarOpeation{
//    
//    NSLog(@"加入购物车");
//    //    [SVProgressHUD showWithStatus:@"加入购物车中..." maskType:SVProgressHUDMaskTypeClear];
//    [BMProgressView showCoverWithTarget:self color:nil isNavigation:YES];
//    if(IS_Login == YES) {
//        
//        [self synchShoppingCarDataWith:nil];
//        
//    } else {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            BOOL b;
//            
//            DatabaseManager *manager = [DatabaseManager sharedInstance];
//            //查询数据库是否有该商品
//            NSArray *modelArr = [manager queryGoodWithModel:self.model];
//            //数据库没有该商品(插入)
//            if (modelArr.count == 0) {
//                self.model.timeStamp = [CommonTool timeSp];  //时间戳
//                self.model.shoppingCarCount = [manager shoppingCarCount];
//                self.model.num=self.numTextField.text;
//                b = [manager insertShoppingCarWithModel:self.model];
//                NSLog(@"=====__=++%@",self.model);
//                self.model.num = @"0";
//            }
//            //数据库有该商品(更新)
//            else{
//                XNRShoppingCartModel *model = [modelArr firstObject];
//                model.num = [NSString stringWithFormat:@"%d",model.num.intValue+self.numTextField.text.intValue];
//                model.timeStamp = [CommonTool timeSp];  //时间戳
//                model.shoppingCarCount = [manager shoppingCarCount];
//                
//                b = [manager updateShoppingCarWithModel:model];
//            }
//            if (b) {
//                
//                [UILabel showMessage:@"加入购物车成功"];
//                [BMProgressView LoadViewDisappear:self.view];
//            }else{
//                
//                [UILabel showMessage:@"加入购物车失败"];
//                [BMProgressView LoadViewDisappear:self.view];
//                
//            }
//        });
//    }
//    
//    
//}


-(void)cancelBtnClick{
    
    [UIView animateWithDuration:.3 animations:^{
        self.attributesView.frame = CGRectMake(0, ScreenHeight+30, ScreenWidth, PX_TO_PT(980));
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;

    }];
}

-(void)show{
    self.coverView.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.attributesView.frame= CGRectMake(0, ScreenHeight-PX_TO_PT(980), ScreenWidth, PX_TO_PT(980));
    }];
}

-(void)createCollectionView
{
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(coll_cell_margin, PX_TO_PT(220), ScreenWidth-2*coll_cell_margin, PX_TO_PT(680)) collectionViewLayout:collectionViewLayout];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[XNRPropertyBrandView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId];
    [collectionView registerClass:[XNRPropertyFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewId];
    [collectionView registerClass:[XNRPropertyCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView = collectionView;
    self.collectionView.collectionViewLayout = collectionViewLayout;
    [self.attributesView addSubview:collectionView];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    XNRProductInfo_model *model;
    for (int i = 0; i<_goodsArray.count; i++) {
        model = _goodsArray[i];
    }
    return model.SKUAttributes.count;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    XNRProductInfo_model *model;
    for (int i = 0; i<_goodsArray.count; i++) {
        model = _goodsArray[i];
    }
    if (model.SKUAttributes.count>0) {
        XNRSKUAttributesModel *skuModel = model.SKUAttributes[section];
        return skuModel.values.count;
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XNRProductInfo_model *infoModel;
    for (int i = 0; i<_goodsArray.count; i++) {
        infoModel = _goodsArray[i];
    }
    if (infoModel.SKUAttributes.count>0) {
        XNRSKUAttributesModel *skuModel = infoModel.SKUAttributes[indexPath.section];
        XNRPropertyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        
        cell.itemTitleLabel.backgroundColor = skuModel.indexPath==indexPath?R_G_B_16(0xfe9b00):R_G_B_16(0xffffff);
        cell.itemTitleLabel.textColor = skuModel.indexPath==indexPath?R_G_B_16(0xffffff):R_G_B_16(0x646464);
        cell.itemTitleLabel.text = skuModel.values[indexPath.row];
        return cell;
    }else{
        return [[UICollectionViewCell alloc] init];
    }
}
#pragma mark - UICollectionViewDelegate
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XNRProductInfo_model *infoModel;
    for (int i = 0; i<_goodsArray.count; i++) {
        infoModel = _goodsArray[i];
    }
    XNRSKUAttributesModel *selectedModel = infoModel.SKUAttributes[indexPath.section];
    selectedModel.indexPath = indexPath;
    [self.collectionView reloadData];

    NSDictionary *param = @{@"name":selectedModel.name,@"value":selectedModel.values[indexPath.row]};
    NSLog(@"===%%%@+++%@",selectedModel.name,selectedModel.values[indexPath.row]);
    NSMutableArray *attributesArray = [[NSMutableArray alloc] init];
    [attributesArray addObject:param];
    NSDictionary *params = @{@"product":infoModel._id,@"attributes":attributesArray,@"user-agent":@"IOS-v2.0"};
    
//    [KSHttpRequest post:KSkuquery parameters:[params JSONString_Ext] success:^(id result) {
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"++——————%@",error);
//
//        
//    }];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:KSkuquery parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"---------返回数据:---------%@",str);
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic;
        if ([resultObj isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary *)resultObj;
        }
        if ([resultObj[@"code"] integerValue] == 1000) {
            NSDictionary *datas = resultObj[@"data"];
            XNRChangeAttributesModel *model = [[XNRChangeAttributesModel alloc] init];
            NSArray *attributes = datas[@"attributes"];
            for (NSDictionary *dict in attributes) {
                
            
            }

        }

        
        NSLog(@"------%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===%@",error);
        
    }];
}
//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark  - UICollectionViewDelegateFlowLayout
//返回头部headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 44.0);
}
// 返回尾部footView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    XNRProductInfo_model *infoModel;
    for (int i = 0; i<_goodsArray.count; i++) {
        infoModel = _goodsArray[i];
    }

    if (section == infoModel.SKUAttributes.count - 1) {
        return CGSizeMake(ScreenWidth, PX_TO_PT(100));
    } else {
        
        return CGSizeZero;
    }
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellW = (ScreenWidth-4*coll_cell_margin)/3;
    currentSize = CGSizeMake(cellW,cellW / 3);
    return currentSize;
}
////定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}
////每个section中不同的行之间的行间距
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
        for (int i = 0; i<_goodsArray.count; i++) {
            infoModel = _goodsArray[i];
        }
        XNRSKUAttributesModel *skuModel = infoModel.SKUAttributes[indexPath.section];
        if (infoModel.SKUAttributes.count>0) {
            headerView.selectTitleLabel.text = skuModel.name;
        }
        reusableview = headerView;
    }else{
        
        XNRProductInfo_model *model;
        for (int i = 0; i<_goodsArray.count; i++) {
            model = _goodsArray[i];
        }
        NSLog(@"++____%@",indexPath);
        
            XNRPropertyFootView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewId forIndexPath:indexPath];
            reusableview = footView;

    }
    return reusableview;
}


@end
