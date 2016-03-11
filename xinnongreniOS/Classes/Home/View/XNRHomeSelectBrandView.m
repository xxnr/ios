//
//  XNRHomeSelectBrandView.m
//  UIColectionView
//
//  Created by 董富强 on 15/12/9.
//  Copyright © 2015年 董富强. All rights reserved.
//

#import "XNRHomeSelectBrandView.h"
#import "XNRHomeSelectedCellectionCell.h"
#import "XNBrandsModel.h"

#define coll_cell_margin 20
#define cellId @"selected_cell"
#define headerViewId @"selectedHeaderView"

#define initialRect CGRectMake(0,  -[UIScreen mainScreen].bounds.size.height + 44+ 64, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64.0)
#define displayRect CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0-44)

@interface XNRHomeSelectBrandView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    CGSize currentSize;
}
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *selecteItemArr;

@property (nonatomic, weak) UIButton *resetBtn;//重置按钮

@property (nonatomic, weak) UIButton *admireBtn;//确定按钮

@property (nonatomic, copy) brandViewBlock com;

@property (nonatomic, assign)XNRType loadType;//类型

@property (nonatomic, strong)NSMutableArray *categorys;//类型，汽车 or 化肥

@property (nonatomic ,strong)NSMutableArray *resArr;//品牌数组

@property (nonatomic, strong)NSMutableArray *gxArr;//共有属性数组

@property (nonatomic, strong)NSMutableArray *txArr;//特有属性数组

@property (nonatomic, strong)NSArray *param;//
@end

@implementation XNRHomeSelectBrandView


+ (void)showSelectedBrandViewWith:(brandViewBlock)com andTarget:(UIView *)target andType:(XNRType)type andParam:(NSArray *)param {
    
    XNRHomeSelectBrandView *selectedView = [[XNRHomeSelectBrandView alloc] initWithFrame:initialRect andType:type and:param];
    selectedView.com = com;
    selectedView.tag = 10240;
    [target addSubview:selectedView];
    
    [UIView animateWithDuration:0.3 animations:^{
        selectedView.frame = displayRect;
        [selectedView.collectionView reloadData];
    }];
}
+(void)cancelSelectedBrandView {
    UIWindow *kXNRWindow = [[[UIApplication sharedApplication] delegate] window];
    XNRHomeSelectBrandView *selectedView = [[XNRHomeSelectBrandView alloc] initWithFrame:displayRect];
    selectedView = [kXNRWindow viewWithTag:10240];
    //    self.frame = displayRect;
    [UIView animateWithDuration:0.3 animations:^{
        selectedView.frame = initialRect;
        [selectedView.collectionView reloadData];
        
    }completion:^(BOOL finished) {
        [selectedView removeFromSuperview];
    }];
    
}

// 点击确定按钮，请求接口，然后再cancel
- (void)cancel {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = initialRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

- (NSMutableArray *)selecteItemArr {
    if (!_selecteItemArr) {
        _selecteItemArr = [NSMutableArray array];
    }
    return _selecteItemArr;
}
- (instancetype)initWithFrame:(CGRect)frame andType:(XNRType)type and:(NSArray *)param {
    if (self == [super initWithFrame:frame]) {
        
        self.resArr = [NSMutableArray array];
        self.gxArr = [NSMutableArray array];
        self.txArr = [NSMutableArray array];
        
        self.backgroundColor = R_G_B_16(0xf0f0f0);
        self.loadType = type;
        _param = param;
        [self createView];
        [self getCategorys];
        
    }
    return self;
}
-(void)getCategorys
{
    [KSHttpRequest get:KHomeCategories parameters:nil success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            _categorys = [[NSMutableArray alloc]initWithCapacity:2];
            for (NSDictionary *dic in result[@"categories"]) {
                [_categorys addObject:dic[@"id"]];
            }
            
            _param = [NSArray array];
            [self getDataWith:_param];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getDataWith:(NSArray *)params
{
    NSLog(@"-=-=-=-=-=-=-=%@",params);
    if (self.loadType == eXNRFerType) {
        NSString *url = [NSString stringWithFormat:@"%@/brands?category=%@",KHomeProducts,_categorys[1]];
        [KSHttpRequest get:url parameters:nil success:^(id result) {
            
            self.resArr = [NSMutableArray array];
            if ([result[@"code"] integerValue] == 1000) {
                NSArray *Farray = result[@"datas"];
                for (NSDictionary *dicts in Farray) {
                    XNRShoppingCartModel *model = [[XNRShoppingCartModel alloc] init];
                    [model setValuesForKeysWithDictionary:dicts];
                    
                    //                    NSString *brandId = model.brandId;
                    //                    [KSHttpRequest get:[NSString stringWithFormat:@"%@/brands?category=化肥&brand=%@",KHomeProducts,brandId] parameters:nil success:^(id result) {
                    //                        if ([result[@"code"] integerValue] == 1000) {
                    //                            NSArray *att = result[@"attributes"];
                    //
                    //                        }
                    //                    } failure:<#^(NSError *error)failure#>]
                    [self.resArr addObject:model];
                }
            }
            
            for (int i = 0; i < 2; i++) {
                NSMutableArray *sectionDataArr = [NSMutableArray array];
                if (i == 0)
                {
                    XNRHomeSelectedBrandItem *itemData = [[XNRHomeSelectedBrandItem alloc] init];
                    itemData.titleStr = @"全部";
                    itemData.isSelected = YES;
                    itemData.titleParam = @"";
                    itemData.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [sectionDataArr addObject:itemData];
                }
                
                int sectionCoutn = i == 0 ? (int)self.resArr.count : 5;
                for (int j = 0; j < sectionCoutn; j++) {
                    XNRHomeSelectedBrandItem *itemData = [[XNRHomeSelectedBrandItem alloc] init];
                    itemData.dataType = eXNRFerType;
                    
                    if (i==0) {
                        if (self.resArr.count > 0) {
                            [itemData exchangeResModelToItemWith:[self.resArr objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j+1 inSection:i]];
                        }
                    }
                    //                    else if( i == 1)
                    //                    {
                    //                        [KSHttpRequest get:[NSString stringWithFormat:@"%@/brands?category=化肥&brand=0",KHomeProducts] parameters:nil success:^(id result) {
                    //                            if ([result[@"code"] integerValue] == 1000) {
                    //                                NSArray *att = result[@"attributes"];
                    //                                NSDictionary *dic = att[0];
                    //                                NSString *name = dic[@"_id"][@"name"];
                    //                                NSArray *values = dic[@"values"];
                    //                                [itemData exchangeResModelToItemWith:[values objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j+1 inSection:i]];
                    //                            }
                    //                        } failure:^(NSError *error) {
                    //
                    //                        }];
                    //                    }
                    else
                    {
                        itemData.indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                    }
                    [sectionDataArr addObject:itemData];
                }
                [self.selecteItemArr addObject:sectionDataArr];
            }
            
            [self configSearchAndSelectViewWith:params];
            [self.collectionView reloadData];
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    
    else if(self.loadType == eXNRCarType){
        // 获取汽车类别的属性
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:_categorys[0] forKey:@"category"];
        [param setObject:@"0" forKey:@"brand"];
        [KSHttpRequest get:KBrands parameters:param success:^(id result) {
            
            
            if ([result[@"code"] integerValue] == 1000) {
                NSArray *brands = result[@"brands"];
                int i = 0;
                for (NSDictionary *dicts in brands)
                {
                    i++;
                    XNBrandsModel *model = [[XNBrandsModel alloc] init];
                    model.brandsId = dicts[@"_id"];
                    model.name = dicts[@"name"];
                    [self.resArr addObject:model];
                    
                }
                
                //获取汽车类别的共有属性
                [KSHttpRequest get:KAttibutes parameters:param success:^(id result) {
                    if ([result[@"code"]integerValue] == 1000) {
                        NSArray *arr = result[@"attributes"];
                        [self.gxArr setArray:arr[0][@"values"]];
                        
                        
                        //把品牌 车型 价格各数组添加到self.selecteItemArr 数组中
                        for (int i = 0; i < 3; i++) {
                            NSMutableArray *sectionDataArr = [NSMutableArray array];
                            //                if (i == 0) {
                            //                    XNRHomeSelectedBrandItem *itemData = [[XNRHomeSelectedBrandItem alloc] init];
                            //                    itemData.titleStr = @"全部";
                            //                    itemData.isSelected = YES;
                            //                    itemData.titleParam = @"";
                            //                    itemData.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                            //                    [sectionDataArr addObject:itemData];
                            //                }
                            NSInteger sectionCoutn;
                            if (i == 0) {
                                sectionCoutn = self.resArr.count;
                            }
                            else if (i == 1)
                            {
                                sectionCoutn = self.gxArr.count;
                            }
                            else if (i == 2)
                            {
                                sectionCoutn = 5;
                            }
                            for (int j = 0; j < sectionCoutn; j++) {
                                XNRHomeSelectedBrandItem *itemData = [[XNRHomeSelectedBrandItem alloc] init];
                                itemData.dataType = eXNRCarType;
                                
                                if (i==0) {
                                    //
                                    if (self.resArr.count > 0) {
                                        [itemData exchangeResModelToItemWith:[self.resArr objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j+1 inSection:i]];
                                    }
                                }
                                else if (i == 1)
                                {
                                    //
                                    if (self.resArr.count > 0)
                                    {
                                        [itemData exchangeResModelToItemWith:[self.gxArr objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j+1 inSection:i]];
                                    }
                                }
                                else if (i == 2)
                                {
                                    itemData.indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                }
                                [sectionDataArr addObject:itemData];
                            }
                            [self.selecteItemArr addObject:sectionDataArr];
                        }
                        
                    }
                } failure:^(NSError *error) {
                    
                }];
                
                //                //获取汽车品牌下的特有属性
                //                for (int i = 0; i < self.resArr.count; i++) {
                //                    XNBrandsModel *mod = self.resArr[i];
                //                    [param setObject:mod.brandsId forKey:@"brand"];
                //                    [KSHttpRequest get:KAttibutes parameters:param success:^(id result) {
                //                        if ([result[@"code"]integerValue] == 1000) {
                //                            NSArray *arr = result[@"attributes"];
                //                            [self.txArr addObject:arr[i][@"values"]];
                //
                //
                //                        }
                //                    } failure:^(NSError *error) {
                //
                //                    }];
                //
                [self configSearchAndSelectViewWith:params];
                
                [self.collectionView reloadData];
            }
            
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    
}
- (void)configSearchAndSelectViewWith:(NSArray *)params {
    
    if (params&&params.count==3) {
        for (int i = 0; i < 3; i++) {
            NSArray *arr = self.selecteItemArr[i];
            for (XNRHomeSelectedBrandItem *item in arr) {
                NSIndexPath *selectedIndexPath = params[i];
                item.isSelected = (item.indexPath.section==selectedIndexPath.section)&&(item.indexPath.row==selectedIndexPath.row);
                
            }
        }
    }
}


- (void)createView {
    
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(coll_cell_margin, 0, self.bounds.size.width-coll_cell_margin*2, self.bounds.size.height) collectionViewLayout:collectionViewLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[XNRHomeSelectedBrandHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId];
    [collectionView registerClass:[XNRHomeSelectedCellectionCell class] forCellWithReuseIdentifier:cellId];
    collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView = collectionView;
    self.collectionView.collectionViewLayout = collectionViewLayout;
    [self addSubview:self.collectionView];
    
    //TODO:加btn
    CGFloat w = (self.bounds.size.width-3*coll_cell_margin)/2;
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake(PX_TO_PT(32),PX_TO_PT(800),w,w/4);
    resetBtn.titleLabel.font = XNRFont(14);
    resetBtn.layer.borderColor = R_G_B_16(0x00b38a).CGColor;
    resetBtn.layer.borderWidth = 1.0;
    resetBtn.layer.cornerRadius = 5.0;
    resetBtn.layer.masksToBounds = YES;
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];
    [resetBtn setTitleColor:R_G_B_16(0xfbffff) forState:UIControlStateHighlighted];
    [resetBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#ffffff"]] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateHighlighted];
    [resetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.resetBtn = resetBtn;
    [self addSubview:resetBtn];
    
    UIButton *admireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    admireBtn.frame = CGRectMake(CGRectGetMaxX(self.resetBtn.frame) + coll_cell_margin, PX_TO_PT(800),w , w/4);
    admireBtn.titleLabel.font = XNRFont(14);
    admireBtn.layer.borderColor = R_G_B_16(0x00b38a).CGColor;
    admireBtn.layer.borderWidth = 1.0;
    admireBtn.layer.cornerRadius = 5.0;
    admireBtn.layer.masksToBounds = YES;
    [admireBtn setTitle:@"确定" forState:UIControlStateNormal];
    [admireBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];
    [admireBtn setTitleColor:R_G_B_16(0xfbffff) forState:UIControlStateHighlighted];
    [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#ffffff"]] forState:UIControlStateNormal];
    [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00b38a"]] forState:UIControlStateHighlighted];
    [admireBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.admireBtn = admireBtn;
    [self addSubview:admireBtn];
}

-(void)btnClick:(UIButton *)button
{
    if (button == self.resetBtn) {
        for (XNRHomeSelectedBrandItem *item in _selecteItemArr[0]) {
            item.isSelected = NO;
        }
        for (XNRHomeSelectedBrandItem *item in _selecteItemArr[1]) {
            item.isSelected = NO;
        }
        XNRHomeSelectedBrandItem *item1 = _selecteItemArr[0][0];
        XNRHomeSelectedBrandItem *item2 = _selecteItemArr[1][0];
        item1.isSelected = YES;
        item2.isSelected = YES;
        
        [self.collectionView reloadData];
        
    }else if(button == self.admireBtn){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectBtnChange" object:nil];
        [self loadSeletedDataWith:nil];
        [self cancel];
        
    }
    
    
}

//dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.selecteItemArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selecteItemArr.count > 0) {
        NSArray *sectionArr = self.selecteItemArr[section];
        return sectionArr.count;
    } else {
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selecteItemArr.count > 0) {
        XNRHomeSelectedBrandItem *itemData = [self.selecteItemArr[indexPath.section] objectAtIndex:indexPath.item];
        XNRHomeSelectedCellectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        [cell updateCellStateAndDataWith:itemData];
        return cell;
    } else {
        return [[UICollectionViewCell alloc] init];
    }
}

//delegate
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XNRHomeSelectedBrandItem *selectedItem = [self.selecteItemArr[indexPath.section] objectAtIndex:indexPath.item];
//    NSArray *arr = self.selecteItemArr[indexPath.section];
//    for (XNRHomeSelectedBrandItem *cellItem in arr) {
//        if (cellItem.isSelected) {
//            cellItem.isSelected = NO;
//        }
//    }
    if (selectedItem.isSelected == YES) {
        selectedItem.isSelected = NO;
    }
    else
    {
        selectedItem.isSelected = YES;
    }
    [self.collectionView reloadData];
}
//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor redColor]];
}


//UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellW = (self.bounds.size.width-4*coll_cell_margin)/3;
    currentSize = CGSizeMake(cellW,cellW / 3);
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
        XNRHomeSelectedBrandHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId forIndexPath:indexPath];
        if (self.loadType == eXNRFerType) {
            headerView.selectTitleLabel.text = indexPath.section==0?@"品牌":@"价格";
            
        }else if (self.loadType == eXNRCarType){
            headerView.selectTitleLabel.text = indexPath.section==0?@"车系":@"价格";
            
        }
        reusableview = headerView;
    }
    return reusableview;
}////返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.bounds.size.width, 44.0);
}


- (BOOL)isAllSelectedWith:(NSInteger)section {
    
    BOOL isAll = YES;
    BOOL isNotAll = NO;
    NSArray *arr = [self.selecteItemArr objectAtIndex:section];
    for (int i = 1; i < [arr count]; i++) {
        XNRHomeSelectedBrandItem *itemData = [arr objectAtIndex:i];
        isAll = isAll && itemData.isSelected;
        isNotAll = isNotAll || itemData.isSelected;
    }
    
    return isAll||!isNotAll;
}

#pragma mark - 请求筛选数据接口 -
- (void)loadSeletedDataWith:(id)parameObj {
    //TODO:上传要筛选的数据
    
    NSArray *arr0 = self.selecteItemArr[0];// 品牌
    NSArray *arr1 = self.selecteItemArr[1];// 价格
    
    NSString *brandReq= [[NSString alloc] init];
    NSString *priceReq;
    NSIndexPath *indexPaht1 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:1];
    
    //0.品牌
    for (XNRHomeSelectedBrandItem *item in arr0) {
        if (item.isSelected) {
            brandReq = item.titleParam;
            indexPaht1 = item.indexPath;
            
        }
    }
    
    //1.价格
    for (XNRHomeSelectedBrandItem *item in arr1) {
        if (item.isSelected) {
            priceReq = item.titleParam;
            indexPath2 = item.indexPath;
        }
    }
    NSLog(@"%@====%@",brandReq,priceReq);
    
    if (self.com) {
        self.com(brandReq,priceReq,@[indexPaht1,indexPath2]);
    };
    
    
    
}


@end
