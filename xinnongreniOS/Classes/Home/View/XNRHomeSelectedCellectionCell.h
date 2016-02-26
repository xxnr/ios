//
//  XNRHomeSelectedCellectionCell.h
//  UIColectionView
//
//  Created by 董富强 on 15/12/9.
//  Copyright © 2015年 董富强. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XNRHomeSelectedBrandItem;
@interface XNRHomeSelectedCellectionCell : UICollectionViewCell

//@property (nonatomic, weak) UIImageView *itemImageView;
// 品牌名字
@property (nonatomic, weak) UILabel *itemTitleLabel;


- (void)updateCellStateAndDataWith:(XNRHomeSelectedBrandItem *)cellDataItem;
@end



#import "XNRHomeSelectBrandView.h"
@interface XNRHomeSelectedBrandItem : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *titleStr;   // 品牌名字
@property (nonatomic, copy) NSString *titleParam; // 过滤以后的参数

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *selectedImageName;

@property (nonatomic, assign) NSInteger category;//1 品牌 ， 2 价格
@property (nonatomic, assign) XNRType dataType;

/* 上传的参数 */
@property (nonatomic, copy) NSString *classId;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic ,copy) NSString *model;
@property (nonatomic, copy) NSString *reservePrice;


- (void)exchangeResModelToItemWith:(NSObject *)obj andIndexPath:(NSIndexPath *)indexPath;

@end




@interface XNRHomeSelectedBrandHeaderView : UICollectionReusableView

@property (nonatomic, weak) UILabel *selectTitleLabel;

@end