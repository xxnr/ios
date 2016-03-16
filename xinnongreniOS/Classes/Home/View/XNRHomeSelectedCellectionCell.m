//
//  XNRHomeSelectedCellectionCell.m
//  UIColectionView
//
//  Created by 董富强 on 15/12/9.
//  Copyright © 2015年 董富强. All rights reserved.
//

#import "XNRHomeSelectedCellectionCell.h"
#import "XNBrandsModel.h"
@implementation XNRHomeSelectedCellectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    
    //    UIImageView *itemImageView = [[UIImageView alloc] init];
    //    self.itemImageView = itemImageView;
    //    [self.contentView addSubview:self.itemImageView];
    
    UILabel *itemTitleLabel = [[UILabel alloc] init];
    itemTitleLabel.frame = self.bounds;
    itemTitleLabel.layer.cornerRadius = PX_TO_PT(10);
    itemTitleLabel.layer.masksToBounds = YES;
    itemTitleLabel.textColor = R_G_B_16(0x646464);
    itemTitleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(24)];
    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
    itemTitleLabel.layer.borderColor = R_G_B_16(0xc7c7c7).CGColor;
    itemTitleLabel.layer.borderWidth = .5;
    self.itemTitleLabel = itemTitleLabel;
    [self.contentView addSubview:self.itemTitleLabel];
    
}
- (void)updateCellStateAndDataWith:(XNRHomeSelectedBrandItem *)cellDataItem {
    
    self.itemTitleLabel.text = cellDataItem.titleStr;
    self.itemTitleLabel.backgroundColor = cellDataItem.isSelected?R_G_B_16(0x00b38a):R_G_B_16(0xffffff);
    self.itemTitleLabel.textColor = cellDataItem.isSelected?R_G_B_16(0xffffff):R_G_B_16(0x646464);
}
@end


@interface XNRHomeSelectedBrandItem ()

@property (nonatomic, strong) NSMutableArray *itemsArr;
@property (nonatomic, strong) NSArray *section0Items;
@property (nonatomic, strong) NSArray *section1Items;

@property (nonatomic, strong) NSArray *section0Params;
@property (nonatomic, strong) NSArray *section1Params;

@property(nonatomic ,strong)  NSArray *section2Items;
@property (nonatomic ,strong) NSArray *section2Params;

@property(nonatomic, strong) NSArray *section3Items;
@property (nonatomic, strong)NSArray *section3Params;
@end

@implementation XNRHomeSelectedBrandItem

- (NSMutableArray *)itemsArr {
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
        [_itemsArr addObject:self.section0Items];
        [_itemsArr addObject:self.section1Items];
        [_itemsArr addObject:self.section2Items];

        [_itemsArr addObject:self.section3Items];
//        [_itemsArr addObject:self.section0Params];
//        [_itemsArr addObject:self.section1Params];
//        [_itemsArr addObject:self.section2Params];

    }
    return _itemsArr;
}

- (NSArray *)section0Items {
    if (!_section0Items) {
        _section0Items = [NSArray array];
        //        _section0Items = @[@"全部",@"好苗子",@"天南一家",@"施莱德",@"中化化肥",@"天智",@"磷联",@"个肥"];
    }
    return _section0Items;
}
- (NSArray *)section0Params {
    if (!_section0Params) {
        _section0Params = [NSArray array];
        //        _section0Params = @[[NSNull null],@"好苗子",@"天南一家",@"施莱德",@"中化化肥",@"天智",@"磷联",@"个肥"];
    }
    return _section0Params;
}


- (NSArray *)section1Items {

    if (!_section1Items) {
        _section1Items = [NSArray array];
    }
    return _section1Items;
}
-(NSArray *)section1Params
{
    if (!_section1Params) {
        _section1Params  = [NSArray array];
    }
    return _section1Params;
}
- (NSArray *)section2Items {
    if (!_section2Items) {
        _section2Items = [NSArray array];

    }
    return _section2Items;
}
- (NSArray *)section2Params {
    if (!_section2Params) {
        _section2Params = [NSArray array];
        
     }
    return _section2Params;
}

-(NSArray *)section3Items
{
    if (!_section3Items) {
        if (self.dataType == eXNRFerType) {
            _section3Items = @[@"0-1000元",@"1000-2000元",@"2000-3000元",@"3000元以上"];
        }else if (self.dataType == eXNRCarType){
            _section3Items = @[@"0-5万元",@"5-6万元",@"6-7万元",@"7万元以上"];
        }
    }
    return _section3Items;

}

-(NSArray *)section3Params
{
    if (!_section3Params) {
        if (self.dataType == eXNRFerType) {
            _section3Params = @[@"0,1000",@"1000,2000",@"2000,3000",@"3000,1000000"];
        }else if (self.dataType == eXNRCarType){
            _section3Params = @[@"0,50000",@"50000,60000",@"60000,70000",@"70000,1000000"];
        }
    }
    return _section3Params;

    
}


- (void)getItemDataValueWith:(NSIndexPath *)indexPath {
    
    self.titleStr = [self.itemsArr[indexPath.section] objectAtIndex:indexPath.item];
    if (indexPath.section == 0) {
        self.titleParam = [self.section0Params objectAtIndex:indexPath.item];
    }
    else if(indexPath.section == 1)
    {

        self.titleParam = [self.section1Params objectAtIndex:indexPath.item];
    }
    else if(indexPath.section == 2)
    {
        self.titleParam = [self.section2Params objectAtIndex:indexPath.item];
    }
    else {
        self.titleParam = [self.section3Params objectAtIndex:indexPath.item];
    }
    self.category = indexPath.section + 1;
    //    if (indexPath.item == 0) {
    //        self.isSelected = YES;
    //    }

}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
//    if (!(indexPath.row == 0 && indexPath.section == 0)) {
        [self getItemDataValueWith:indexPath];
//    }
}


- (void)exchangeResModelToItemWith:(NSObject *)obj andIndexPath:(NSIndexPath *)indexPath {

    if ([obj isKindOfClass:[XNRHomeSelectedBrandItem class]]) {
        XNRHomeSelectedBrandItem *model = (XNRHomeSelectedBrandItem *)obj;
        self.brandsId = model.brandsId;
        self.brandName = model.titleStr;
        self.titleStr = model.titleStr;
        self.titleParam = model.titleStr;
        self.isSelected = model.isSelected;
    }
    _indexPath = indexPath;
}
@end




@implementation XNRHomeSelectedBrandHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.font = [UIFont boldSystemFontOfSize:PX_TO_PT(26)];
        titleLabel.textColor = R_G_B_16(0x646464);
        titleLabel.backgroundColor = [UIColor clearColor];
        self.selectTitleLabel = titleLabel;
        [self addSubview:self.selectTitleLabel];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)-PX_TO_PT(20), ScreenWidth, PX_TO_PT(2))];
//        lineView.backgroundColor = R_G_B_16(0xc7c7c7);
//        [self addSubview:lineView];
    }
    return self;
}

@end