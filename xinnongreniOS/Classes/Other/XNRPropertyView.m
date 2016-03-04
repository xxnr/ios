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
#import "UIImageView+WebCache.h"


#define coll_cell_margin 15
#define cellId @"selected_cell"
#define headerViewId @"selectedHeaderView"
#define footViewId @"selectedFootView"


@interface XNRPropertyView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    CGSize currentSize;
    NSString *_id;
    NSString *_SKUId;
    NSString *_numText;
    NSString * _min;
    NSString * _max;
}

@property (nonatomic ,weak) UIView *coverView;

@property (nonatomic ,weak) UIView *attributesView;

@property (nonatomic ,weak) UICollectionView *collectionView;

@property (nonatomic ,weak) UIImageView *imageView;

@property (nonatomic ,weak) UILabel *nameLabel;

@property (nonatomic ,weak) UILabel *priceLabel;

@property (nonatomic ,strong) NSMutableArray *goodsArray;

//@property (nonatomic ,copy) NSString *goodsId;

@property (nonatomic ,strong) XNRShoppingCartModel *shopcarModel;

@property (nonatomic ,weak) UIButton *addBuyCarBtn;


@end

@implementation XNRPropertyView


-(instancetype)initWithFrame:(CGRect)frame model:(XNRShoppingCartModel *)shopcarModel
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.shopcarModel = shopcarModel;
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
#pragma mark - 数据请求
-(void)getData
{
    
    [KSHttpRequest post:KHomeGetAppProductDetails parameters:@{@"productId":self.shopcarModel.goodsId?self.shopcarModel.goodsId:@"",@"user-agent":@"IOS-v2.0"} success:^(id result) {
        
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dic =result[@"datas"];
            XNRProductInfo_model *model = [[XNRProductInfo_model alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            _id = dic[@"_id"];
            
            model.pictures = (NSMutableArray *)[XNRProductPhotoModel objectArrayWithKeyValuesArray:dic[@"pictures"]];
            model.SKUAttributes = (NSMutableArray *)[XNRSKUAttributesModel objectArrayWithKeyValuesArray:dic[@"SKUAttributes"]];
            for (XNRSKUAttributesModel *skuModel in model.SKUAttributes) {
                for (int i = 0; i < skuModel.values.count; i++) {
                    XNRSKUCellModel *cellModel = [[XNRSKUCellModel alloc] init];
                    cellModel.cellValue = [skuModel.values[i] copy];
                    cellModel.isEnable = YES;
                    [skuModel.values replaceObjectAtIndex:i withObject:cellModel];
                 }
            }
            
            self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            
            if ([dic[@"referencePrice"][@"min"] floatValue] == [dic[@"referencePrice"][@"max"] floatValue]) {
                self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[dic[@"referencePrice"][@"min"] floatValue]];
            }else{
                self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f - %.2f",[dic[@"referencePrice"][@"min"] floatValue],[dic[@"referencePrice"][@"max"] floatValue]];
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
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + PX_TO_PT(20), CGRectGetMaxY(nameLabel.frame), ScreenWidth-CGRectGetMaxX(imageView.frame)-PX_TO_PT(20), PX_TO_PT(34))];
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
    [self addShopCarOpeation];
}

#pragma mark-加入购物车
-(void)addShopCarOpeation{
    NSLog(@"加入购物车");
    XNRProductInfo_model *infoModel = [_goodsArray lastObject];
    if (infoModel.additions.count == 0) {
        [UILabel showMessage:@"请选择商品信息"];
    }else{
        // [SVProgressHUD showWithStatus:@"加入购物车中..." maskType:SVProgressHUDMaskTypeClear];
        [BMProgressView showCoverWithTarget:self color:nil isNavigation:YES];
        if(IS_Login == YES) {
            
            [self synchShoppingCarDataWith:nil];
            
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                BOOL b;
                
                DatabaseManager *manager = [DatabaseManager sharedInstance];
                // 查询数据库是否有该商品
                NSArray *modelArr = [manager queryGoodWithModel:self.shopcarModel];
                // 数据库没有该商品(插入)
                if (modelArr.count == 0) {
                    self.shopcarModel.timeStamp = [CommonTool timeSp];  //时间戳
                    self.shopcarModel.shoppingCarCount = [manager shoppingCarCount];
                    self.shopcarModel.num = _numText?_numText:@"1";
                    b = [manager insertShoppingCarWithModel:self.shopcarModel];
                    NSLog(@"=====__=++%@",self.shopcarModel);
                    self.shopcarModel.num = @"0";
                }
                //数据库有该商品(更新)
                else{
                    self.shopcarModel.num = [NSString stringWithFormat:@"%d",self.shopcarModel.num.intValue+_numText.intValue];
                    self.shopcarModel.timeStamp = [CommonTool timeSp];  //时间戳
                    self.shopcarModel.shoppingCarCount = [manager shoppingCarCount];
                    b = [manager updateShoppingCarWithModel:self.shopcarModel];
                }
                if (b) {
                    
                    [UILabel showMessage:@"加入购物车成功"];
                    [BMProgressView LoadViewDisappear:self];
                }else{
                    
                    [UILabel showMessage:@"加入购物车失败"];
                    [BMProgressView LoadViewDisappear:self];
                }
            });
        }

    
    }
}

- (void)synchShoppingCarDataWith:(XNRShoppingCartModel *)model
{
    XNRProductInfo_model *infoModel = [_goodsArray lastObject];
    NSMutableArray *addtionArray = [NSMutableArray array];
    for (XNRAddtionsModel *addtionModel in infoModel.additions) {
        
        if (addtionModel.isSelected) {
            [addtionArray addObject:addtionModel._id];
            NSLog(@"0-=9=90%@",addtionArray);
        }
    }
    NSDictionary *params = @{@"SKUId":self.shopcarModel._id?self.shopcarModel._id:@"",@"userId":[DataCenter account].userid,@"quantity":_numText?_numText:@"1",@"additions":addtionArray,@"update_by_add":@"true",@"user-agent":@"IOS-v2.0",@"token":[DataCenter account].token};
    NSLog(@"())__)%@",params);

    [KSHttpRequest post:KAddToCart parameters:params success:^(id result) {
        NSLog(@"%@",result);
        if([result[@"code"] integerValue] == 1000){
            [UILabel showMessage:@"加入购物车成功"];
            [BMProgressView LoadViewDisappear:self];
        }else {
            [UILabel showMessage:result[@"message"]];
            [BMProgressView LoadViewDisappear:self];
        }
    } failure:^(NSError *error) {
        NSLog(@"_____%@",error);
        
    }];
    
}

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
    [collectionView registerClass:[XNRPropertyCollectionViewCell class] forCellWithReuseIdentifier:@"addtionCell"];
    collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView = collectionView;
    self.collectionView.collectionViewLayout = collectionViewLayout;
    [self.attributesView addSubview:collectionView];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (_goodsArray.count>0) {
        
        XNRProductInfo_model *infoModel = [_goodsArray lastObject];
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
    
    XNRProductInfo_model *model = [_goodsArray lastObject];
    
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
    
    XNRProductInfo_model *infoModel = [_goodsArray lastObject];
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
    
    XNRProductInfo_model *infoModel = [_goodsArray lastObject];
    
    if (indexPath.section < infoModel.SKUAttributes.count) {//选择attribute section 的分区
        
        XNRSKUAttributesModel *selectedSectionModel = infoModel.SKUAttributes[indexPath.section];
        // 0.先判断[点击]的cell 是否[可用]
        XNRSKUCellModel *selectedCellM = selectedSectionModel.values[indexPath.item];
        if (!selectedCellM.isEnable) {
            [UILabel showMessage:@"没有该条件的货物啦！"];
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
        for (XNRSKUAttributesModel *sectionModel in infoModel.SKUAttributes) {
            for (XNRSKUCellModel *cellM in sectionModel.values) {
                if (cellM.isSelected) {
                    NSDictionary *param = @{@"name":sectionModel.name,@"value":cellM.cellValue};
                    [attributesArray addObject:param];
                }
            }
        }
        // 3.生成请求参数
        NSDictionary *params = @{@"product":[NSString stringWithFormat:@"%@",_id],@"attributes":attributesArray,@"user-agent":@"IOS-v2.0"};
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
                // 价格区间改变
                if ([price[@"min"] floatValue] == [price[@"max"] floatValue]) {
                    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[price[@"min"] floatValue]];
                }else{
                    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f - %.2f",[price[@"min"] floatValue],[price[@"max"] floatValue]];
                }
                
                NSArray *attributes = datas[@"attributes"];
                NSDictionary *skuDict = datas[@"SKU"];
                NSArray *addtions = skuDict[@"additions"];
                NSDictionary *SKUprice = skuDict[@"price"];
                _SKUId = skuDict[@"_id"];
                
                // 添加到购物车模型里面，方便加入到数据库
                self.shopcarModel._id = skuDict[@"_id"];
                
                
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
                }
                
                [self.collectionView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"===%@",error);
            
        }];
    } else { // 选择了 addtion section（附加选项） 分区
        
        for (XNRAddtionsModel *addtionCellModel in infoModel.additions) {
            if (addtionCellModel.isSelected&&indexPath.item == [infoModel.additions indexOfObject:addtionCellModel]) {
                addtionCellModel.isSelected = NO;
                if (addtionCellModel.isSelected == NO) {
                    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[_min floatValue]];
                }
            } else {
                if (!addtionCellModel.isSelected) {
                    addtionCellModel.isSelected = indexPath.item == [infoModel.additions indexOfObject:addtionCellModel];
                    
                    if (addtionCellModel.isSelected) {
                        self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[addtionCellModel.price floatValue] + [_min floatValue]];
                        NSMutableArray *addtionsArray = [NSMutableArray array];
                        [addtionsArray addObject:addtionCellModel];
                        NSLog(@"----=====%@---",addtionsArray);
                        self.shopcarModel.additions = (NSMutableArray *)[XNRAddtionsModel keyValuesArrayWithObjectArray:addtionsArray];
                        
                    }else{
                    
                    }

                    
                    }
                            }
        }
        [self.collectionView reloadData];
    }
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
    if (infoModel.additions.count>0) {
        if (section == infoModel.SKUAttributes.count) {
            
            return CGSizeMake(ScreenWidth, PX_TO_PT(100));
        } else {
            
            return CGSizeZero;
        }

    }else{
        if (section == infoModel.SKUAttributes.count - 1) {
            
            return CGSizeMake(ScreenWidth, PX_TO_PT(100));
        } else {
            
            return CGSizeZero;
        }

    
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
        for (int i = 0; i<_goodsArray.count; i++) {
            model = _goodsArray[i];
        }
        NSLog(@"++____%@",indexPath);
        
            XNRPropertyFootView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewId forIndexPath:indexPath];
        footView.com = ^(NSString *numTF){
            _numText = numTF;
        
        };
            reusableview = footView;

    }
    return reusableview;
}


@end
