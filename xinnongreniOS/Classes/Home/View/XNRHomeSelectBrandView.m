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
#import "XNRCollectionViewFlowLayout.h"

#import "XNRSelectItemArrModel.h"
#define coll_cell_margin PX_TO_PT(35)
#define row_cell_margin PX_TO_PT(29)
#define cellId @"selected_cell"
#define headerViewId @"selectedHeaderView"
#define initialRect CGRectMake(0,  -[UIScreen mainScreen].bounds.size.height + PX_TO_PT(89) + 64, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64.0)
#define displayRect CGRectMake(0, PX_TO_PT(89) , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0 - PX_TO_PT(89))

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

@property (nonatomic, strong)NSMutableDictionary *categorys;//类型，汽车 or 化肥

@property (nonatomic ,strong)NSMutableArray *resArr;//品牌数组

@property (nonatomic, strong)NSMutableArray *gxArr;//共有属性数组

@property (nonatomic, strong)NSMutableArray *txArr;//特有属性数组

@property (nonatomic, strong)NSArray *param;//


@property (nonatomic, strong)NSMutableArray *kinds;

@property (nonatomic, strong)NSMutableDictionary *currentTx;

@property (nonatomic, strong)NSString *currentCategory;

@property (nonatomic,strong)NSMutableArray *isSel;

@property (nonatomic,strong)NSArray *getSel;

@property (nonatomic,assign)BOOL isfirst;

@property (nonatomic,assign)BOOL ItemDisEnabled;
@end

@implementation XNRHomeSelectBrandView

+ (void)showSelectedBrandViewWith:(brandViewBlock)com andTarget:(UIView *)target andType:(XNRType)type andParam:(NSArray *)param andShowTx:(NSArray *)txarr andkind:(NSString *)kind{
    
    UIWindow *kXNRWindow = [[[UIApplication sharedApplication] delegate] window];
    XNRHomeSelectBrandView *selectView = [kXNRWindow viewWithTag:10240];
    [selectView removeFromSuperview];
    
    XNRHomeSelectBrandView *selectedView = [[XNRHomeSelectBrandView alloc] initWithFrame:initialRect andType:type and:param and:txarr andkind:kind];
    selectedView.com = com;
    selectedView.tag = 10240;
    target.backgroundColor = [UIColor whiteColor];
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
- (instancetype)initWithFrame:(CGRect)frame andType:(XNRType)type and:(NSArray *)param and:(NSArray *)txarr andkind:(NSString *)kind{
    if (self == [super initWithFrame:frame]) {
        
        self.resArr = [NSMutableArray array];
        self.gxArr = [NSMutableArray array];
        self.txArr = [NSMutableArray array];
        [self.txArr setArray:txarr];
        self.kinds = [NSMutableArray arrayWithCapacity:2];
        
        [self.kinds addObject:@"型号"];
        [self.kinds addObject:@"车系"];
        
        self.isSel = [NSMutableArray array];
        self.getSel = [NSArray array];
        self.getSel = param;
        
        self.currentTx = [NSMutableDictionary dictionary];
        
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
    [_categorys removeAllObjects];
    [self.resArr removeAllObjects];
    [self.gxArr removeAllObjects];
    [self.txArr removeAllObjects];
    
    [KSHttpRequest get:KHomeCategories parameters:nil success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            _categorys = [[NSMutableDictionary alloc]initWithCapacity:2];
            for (NSDictionary *dic in result[@"categories"]) {

                [_categorys setObject:dic[@"id"] forKey:dic[@"name"]];
                
            }
            
            _param = [NSArray array];
            
            if ([XNRSelectItemArrModel defaultModel].XNRSelectItemArr.count > 0) {
                NSMutableArray* mutArr = [NSMutableArray arrayWithArray:[XNRSelectItemArrModel defaultModel].XNRSelectItemArr];
                
                _currentTx = [NSMutableDictionary dictionaryWithDictionary:[XNRSelectItemArrModel defaultModel].XNRSelectItemDict];
                
                _resArr = [NSMutableArray arrayWithArray:[mutArr objectAtIndex:0]];
                _gxArr = [NSMutableArray arrayWithArray:[mutArr objectAtIndex:1]];
                _txArr = [NSMutableArray arrayWithArray:[mutArr objectAtIndex:2]];
            }
            
            [self getDataWith:_param];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getDataWith:(NSArray *)params
{
    NSLog(@"-=-=-=-=-=-=-=%@",params);
    if (self.loadType == eXNRFerType) {
        
//        self.currentCategory = _categorys[1];
        self.currentCategory = [_categorys valueForKey:@"化肥"];
        
        // 获取化肥类别的属性
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:self.currentCategory forKey:@"category"];
        [param setObject:@"0" forKey:@"brand"];
        [KSHttpRequest get:KBrands parameters:param success:^(id result) {
            
            
            if ([result[@"code"] integerValue] == 1000) {
                
                
                NSArray *brands = result[@"brands"];
                int i = 0;
                for (NSDictionary *dicts in brands)
                {
                    i++;
                    XNRHomeSelectedBrandItem *model = [[XNRHomeSelectedBrandItem alloc] init];
                    model.brandsId = dicts[@"_id"];
                    model.titleStr = dicts[@"name"];
                    
                    BOOL b = false;
                    for (XNRHomeSelectedBrandItem* Bmodel in self.resArr) {
                        if ([Bmodel.brandsId isEqualToString:model.brandsId]) {
                            b = YES;
                        }
                    }
                    if (!b) {
                        [self.resArr addObject:model];
                    }
                    
                }
                
                //获取化肥类别的共有属性
                [KSHttpRequest get:KAttibutes parameters:param success:^(id result) {
                    if ([result[@"code"]integerValue] == 1000) {
                        NSArray *arr = result[@"attributes"];
                        
                        NSArray *values = arr[0][@"values"];
                        for (NSString *str in values) {
                            XNRHomeSelectedBrandItem *model = [[XNRHomeSelectedBrandItem alloc]init];
                            model.titleStr = str;
                            
                            BOOL b = false;
                            for (XNRHomeSelectedBrandItem* Bmodel in self.gxArr) {
                                if ([Bmodel.titleStr isEqualToString:model.titleStr]) {
                                    b = YES;
                                }
                            }
                            if (!b) {
                                [self.gxArr addObject:model];
                            }
                            
                        }
                        [self.kinds setObject:arr[0][@"_id"][@"name"] atIndexedSubscript:0];
                        
                        
                        //把各数组添加到self.selecteItemArr 数组中
                        for (int i = 0; i < 4; i++) {
                            NSMutableArray *sectionDataArr = [NSMutableArray array];
                            
                            NSInteger sectionCoutn;
                            if (i == 0) {
                                sectionCoutn = self.resArr.count;
                            }
                            else if (i == 1)
                            {
                                sectionCoutn = self.gxArr.count;
                            }
                            else if(i == 2)
                            {
                                sectionCoutn = self.txArr.count;
                                
                            }
                            else
                            {
                                sectionCoutn = 4;
                            }
                            for (int j = 0; j < sectionCoutn; j++) {
                                XNRHomeSelectedBrandItem *itemData = [[XNRHomeSelectedBrandItem alloc] init];
                                itemData.dataType = eXNRFerType;
                                
                                if (i==0) {
                                    //
                                    if (self.resArr.count > 0) {
                                        [itemData exchangeResModelToItemWith:[self.resArr objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
                                    }
                                }
                                else if (i == 1)
                                {
                                    //
                                    if (self.gxArr.count > 0)
                                    {
                                        [itemData exchangeResModelToItemWith:[self.gxArr objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
                                    }
                                }
                                else if (i == 2)
                                {
                                    
                                    if (self.txArr.count > 0) {
                                        [itemData exchangeResModelToItemWith:[self.txArr objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
                                    }
                                }
                                else if (i == 3)
                                {
                                    itemData.indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                    
                                    if ([XNRSelectItemArrModel defaultModel].XNRSelectItemArr.count > 0) {
                                        XNRHomeSelectedBrandItem* item =
                                        [[[XNRSelectItemArrModel defaultModel].XNRSelectItemArr objectAtIndex:3] objectAtIndex:j];
                                        
                                        itemData.isSelected = item.isSelected;
                                    }
                                    
                                }
                                [sectionDataArr addObject:itemData];
                            }
                            [self.selecteItemArr addObject:sectionDataArr];
                        }
                    }
                    [self configSearchAndSelectViewWith:params];
                    
                    [self.collectionView reloadData];
                    
                } failure:^(NSError *error) {
                    
                }];
                
                
                [self configSearchAndSelectViewWith:params];
                
                [self.collectionView reloadData];
            }
            
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
    else if(self.loadType == eXNRCarType){
        
//        self.currentCategory = _categorys[0];
        self.currentCategory = [_categorys valueForKey:@"汽车"];

        
        // 获取汽车类别的属性
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:self.currentCategory forKey:@"category"];
        [param setObject:@"0" forKey:@"brand"];
        [KSHttpRequest get:KBrands parameters:param success:^(id result) {
            
            
            if ([result[@"code"] integerValue] == 1000) {
                
                
                NSArray *brands = result[@"brands"];
                int i = 0;
                for (NSDictionary *dicts in brands)
                {
                    i++;
                    XNRHomeSelectedBrandItem *model = [[XNRHomeSelectedBrandItem alloc] init];
                    model.brandsId = dicts[@"_id"];
                    model.titleStr = dicts[@"name"];
                    
                    BOOL b = false;
                    for (XNRHomeSelectedBrandItem* Bmodel in self.resArr) {
                        if ([Bmodel.brandsId isEqualToString:model.brandsId]) {
                            b = YES;
                        }
                    }
                    if (!b) {
                        [self.resArr addObject:model];
                    }
                    
                    
                }
                
                //获取汽车类别的共有属性
                [KSHttpRequest get:KAttibutes parameters:param success:^(id result) {
                    if ([result[@"code"]integerValue] == 1000) {
                        NSArray *arr = result[@"attributes"];
                        
                        NSArray *values = arr[0][@"values"];
                        for (NSString *str in values) {
                            XNRHomeSelectedBrandItem *model = [[XNRHomeSelectedBrandItem alloc]init];
                            model.titleStr = str;
                            
                            BOOL b = false;
                            for (XNRHomeSelectedBrandItem* Bmodel in self.gxArr) {
                                if ([Bmodel.titleStr isEqualToString:model.titleStr]) {
                                    b = YES;
                                }
                            }
                            if (!b) {
                                [self.gxArr addObject:model];
                            }
                            
                            
                        }
                        [self.kinds setObject:arr[0][@"_id"][@"name"] atIndexedSubscript:0];
                        
                        //把品牌 车型 价格各数组添加到self.selecteItemArr 数组中
                        for (int i = 0; i < 4; i++) {
                            NSMutableArray *sectionDataArr = [NSMutableArray array];
                            
                            NSInteger sectionCoutn;
                            if (i == 0) {
                                sectionCoutn = self.resArr.count;
                            }
                            else if (i == 1)
                            {
                                sectionCoutn = self.gxArr.count;
                            }
                            else if(i == 2)
                            {
                                sectionCoutn = self.txArr.count;
                                
                            }
                            else
                            {
                                sectionCoutn = 4;
                            }
                            for (int j = 0; j < sectionCoutn; j++) {
                                XNRHomeSelectedBrandItem *itemData = [[XNRHomeSelectedBrandItem alloc] init];
                                itemData.dataType = eXNRCarType;
                                
                                if (i==0) {
                                    //
                                    if (self.resArr.count > 0) {
                                        [itemData exchangeResModelToItemWith:[self.resArr objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
                                    }
                                }
                                else if (i == 1)
                                {
                                    //
                                    if (self.gxArr.count > 0)
                                    {
                                        [itemData exchangeResModelToItemWith:[self.gxArr objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
                                    }
                                }
                                else if (i == 2)
                                {
                                    
                                    if (self.txArr.count > 0) {
                                        [itemData exchangeResModelToItemWith:[self.txArr objectAtIndex:j] andIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
                                    }
                                }
                                else if (i == 3)
                                {
                                    itemData.indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                    
                                    if ([XNRSelectItemArrModel defaultModel].XNRSelectItemArr.count > 0) {
                                        XNRHomeSelectedBrandItem* item =
                                        [[[XNRSelectItemArrModel defaultModel].XNRSelectItemArr objectAtIndex:3] objectAtIndex:j];
                                        
                                        itemData.isSelected = item.isSelected;
                                    }
                                    
                                }
                                [sectionDataArr addObject:itemData];
                            }
                            
                            [self.selecteItemArr addObject:sectionDataArr];
                        }
                        //                        [self tx];
                        
                    }
                    
                    [self configSearchAndSelectViewWith:params];
                    
                    [self.collectionView reloadData];
                    
                } failure:^(NSError *error) {
                    
                }];
                
                
                [self configSearchAndSelectViewWith:params];
                
                [self.collectionView reloadData];
            }
            
            //            [self tx];
            
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
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - PX_TO_PT(120)-PX_TO_PT(89)) collectionViewLayout:collectionViewLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[XNRHomeSelectedBrandHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId];
    [collectionView registerClass:[XNRHomeSelectedCellectionCell class] forCellWithReuseIdentifier:cellId];
    collectionView.backgroundColor = [UIColor clearColor];
    
    self.collectionView = collectionView;
    self.collectionView.collectionViewLayout = collectionViewLayout;
    
    [self addSubview:self.collectionView];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), ScreenWidth, PX_TO_PT(120))];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    resetBtn.frame = CGRectMake(PX_TO_PT(29),PX_TO_PT(29),PX_TO_PT(269),PX_TO_PT(61));
    
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    resetBtn.layer.borderColor = R_G_B_16(0x66d1b9).CGColor;
    
    resetBtn.layer.borderWidth = 1.0;
    resetBtn.layer.cornerRadius = 5.0;
    resetBtn.layer.masksToBounds = YES;
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:R_G_B_16(0x00b38a) forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [resetBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#FFFFFF"]] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#66d1b9"]] forState:UIControlStateHighlighted];
    [resetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.resetBtn = resetBtn;
    [view addSubview:resetBtn];
    
    UIButton *admireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    admireBtn.frame = CGRectMake(CGRectGetMaxX(self.resetBtn.frame) + PX_TO_PT(39), PX_TO_PT(29),PX_TO_PT(383) , PX_TO_PT(61));
    admireBtn.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(28)];
    admireBtn.layer.cornerRadius = 5.0;
    admireBtn.layer.masksToBounds = YES;
    [admireBtn setTitle:@"确定" forState:UIControlStateNormal];
    [admireBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#00B38A"]] forState:UIControlStateNormal];
    [admireBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor colorFromString_Ext:@"#66d1b9"]] forState:UIControlStateHighlighted];
    [admireBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.admireBtn = admireBtn;
    //    [self addSubview:admireBtn];
    [view addSubview:admireBtn];
}

-(void)btnClick:(UIButton *)button
{
    
    if (button == self.resetBtn) {
        if (_selecteItemArr.count > 0) {
            
            [self.selecteItemArr[2] removeAllObjects];
            
            [self.txArr removeAllObjects];
            [self.resArr removeAllObjects];
            [self.gxArr removeAllObjects];
            
            for (int i=0; i<_selecteItemArr.count;i++)
            {
                for (XNRHomeSelectedBrandItem *item in _selecteItemArr[i]) {
                    item.isSelected = NO;
                }
            }
        }
        
        [self.collectionView reloadData];
        
    }else if(button == self.admireBtn){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"x" object:nil];
        if (self.selecteItemArr.count > 0) {
            [self loadSeletedDataWith:nil];
        }
        [self cancel];
        
        if (_selecteItemArr) {
            
            
            [XNRSelectItemArrModel defaultModel].XNRSelectItemArr = [[NSMutableArray alloc]initWithArray:_selecteItemArr];
            
            [XNRSelectItemArrModel defaultModel].XNRSelectItemDict = [[NSMutableDictionary alloc] initWithDictionary:self.currentTx];
            
        }
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
//
//delegate
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _isfirst = YES;
    
    
    //    [self.currentTx setObject:self.txArr forKey:selectedItem.brandsId];
    
    XNRHomeSelectedBrandItem *selectedItem = [self.selecteItemArr[indexPath.section] objectAtIndex:indexPath.item];
    
    if (indexPath.section == 3) {
        NSArray *arr = self.selecteItemArr[indexPath.section];
        for (XNRHomeSelectedBrandItem *cellItem in arr) {
            if (cellItem.isSelected && cellItem != selectedItem) {
                cellItem.isSelected = NO;
            }
        }
    }
    
    if (selectedItem.isSelected == YES) {
        selectedItem.isSelected = NO;
    }
    else
    {
        selectedItem.isSelected = YES;
        
    }
    if (indexPath.section == 0 && selectedItem.isSelected == YES  && !_ItemDisEnabled) {
        
        _ItemDisEnabled = YES;
        
        //  获取特有属性
        [KSHttpRequest get:KAttibutes parameters:@{@"category":self.currentCategory,@"brand":selectedItem.brandsId} success:^(id result) {
            NSMutableArray *txs = [NSMutableArray array];
            if ([result[@"code"] integerValue] == 1000) {
                NSArray *arr = result[@"attributes"];
                
                if (arr.count == 0) {
                    return;
                }
                [self.kinds setObject:arr[0][@"_id"][@"name"] atIndexedSubscript:1];
                
                NSArray *values = arr[0][@"values"];
                int i=0;
                for (NSString *str in values) {
                    XNRHomeSelectedBrandItem *model = [[XNRHomeSelectedBrandItem alloc]init];
                    model.titleStr = str;
                    
                    [model exchangeResModelToItemWith:model andIndexPath:[NSIndexPath indexPathForItem:i+1 inSection:2]];
                    [self.txArr addObject:model];
                    [txs addObject:model];
                    i++;
                }
                [self.selecteItemArr setObject:self.txArr atIndexedSubscript:2];
                [self.currentTx setObject:txs forKey:selectedItem.titleParam];
                [self.collectionView reloadData];
                _ItemDisEnabled = NO;
                
            }
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    else if (indexPath.section == 0 && selectedItem.isSelected == NO)
    {
        NSArray *arr = [self.currentTx valueForKey:selectedItem.titleParam];
        NSMutableArray *removeArr = [[NSMutableArray alloc]init];
        for (XNRHomeSelectedBrandItem *txItem in self.txArr) {
            for (XNRHomeSelectedBrandItem *item in arr) {
                if ([txItem.titleStr isEqualToString:item.titleStr]) {
                    [removeArr addObject:txItem];
                }
            }
        }
        [self.txArr removeObjectsInArray:removeArr];
        
        [self.selecteItemArr setObject:self.txArr atIndexedSubscript:2];
        [self.collectionView reloadData];
        
    }
    [self.collectionView reloadData];
    
}


//UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellW = (self.bounds.size.width-4*coll_cell_margin)/3;
    currentSize = CGSizeMake(cellW-1,cellW / 3);
    return currentSize;
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, coll_cell_margin, 0, coll_cell_margin);//分别为上、左、下、右
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return row_cell_margin;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return coll_cell_margin;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        XNRHomeSelectedBrandHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.selectTitleLabel.text = @"品牌";
        }
        else if (indexPath.section == 1)
        {
            headerView.selectTitleLabel.text = self.kinds[0];
        }
        else if (indexPath.section == 2)
        {
            
            if (self.kinds[1]) {
                headerView.selectTitleLabel.text = self.kinds[1];
            }
        }
        else if (indexPath.section == 3)
        {
            headerView.selectTitleLabel.text = @"价格";
            
        }
        reusableview = headerView;
    }
    return reusableview;
}////返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSArray *arr = self.txArr;
    if (section == 2 && arr.count == 0) {
        return CGSizeMake(ScreenWidth, 0);
    }
    return CGSizeMake(self.bounds.size.width, PX_TO_PT(115));
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
    NSArray *arr1 = self.selecteItemArr[1];// 共性
    NSArray *arr2 = self.selecteItemArr[2];// 特性
    NSArray *arr3 = self.selecteItemArr[3];//价格
    
    
    NSMutableArray *brandsArr = [NSMutableArray array];
    NSMutableArray *gxArr = [NSMutableArray array];
    NSMutableArray *txArr = [NSMutableArray array];
    NSString *priceReq;
    
    NSMutableArray *indexPath1Arr = [NSMutableArray array];
    NSMutableArray *indexPath2Arr = [NSMutableArray array];
    NSMutableArray *indexPath3Arr = [NSMutableArray array];
    NSIndexPath *indexPath4;
    BOOL isYes = NO;
    //0.品牌
    for (XNRHomeSelectedBrandItem *item in arr0) {
        if (item.isSelected) {
            isYes = YES;
            [brandsArr addObject:item.brandsId];
            [indexPath1Arr addObject:item.indexPath];
        }
    }
    //1.
    for (XNRHomeSelectedBrandItem *item in arr1) {
        if (item.isSelected) {
            isYes = YES;
            [gxArr addObject:item.titleParam];
            [indexPath2Arr addObject:item.indexPath];
        }
    }
    
    for (XNRHomeSelectedBrandItem *item in arr2) {
        if (item.isSelected) {
            isYes = YES;
            [txArr addObject: item.titleParam];
            [indexPath3Arr addObject:item.indexPath];
        }
    }
    for (XNRHomeSelectedBrandItem *item in arr3) {
        if (item.isSelected) {
            isYes = YES;
            priceReq = item.titleParam;
            indexPath4 = item.indexPath;
        }
    }
    for (int i=0; i<_selecteItemArr.count; i++) {
        NSArray *Arr = _selecteItemArr[i];
        for (int j = 0; j<Arr.count; j++) {
            XNRHomeSelectedBrandItem *item = _selecteItemArr[i][j];
            if (item.isSelected == YES) {
                [self.isSel addObject:item.indexPath];
            }
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectBtnChange" object:nil];
    
    if (isYes == NO)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectBtnChangeblack" object:nil];
    }
    
    
    if (self.com) {
        self.com(brandsArr,gxArr,txArr,priceReq,self.kinds,self.isSel,arr2);
    };
    
    
    
}


@end
