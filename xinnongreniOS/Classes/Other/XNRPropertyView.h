//
//  XNRPropertyView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/2/19.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    XNRFirstType,
    XNRSecondType,
} XNRPropertyViewType ;

typedef void(^XNRPropertyViewBlock)(NSMutableArray *dataArray,CGFloat totalPrice);

typedef void(^XNRPropertyViewValueBlock)(NSMutableArray *attributes,NSMutableArray *addtions);

typedef void(^XNRPropertyViewLoginBlock)();



@interface XNRPropertyView : UIView

-(void)show:(XNRPropertyViewType)buyType;

-(instancetype)initWithFrame:(CGRect)frame model:(XNRShoppingCartModel *)shopcarModel andType:(XNRPropertyViewType)type;

@property (nonatomic, copy) XNRPropertyViewBlock com;

@property (nonatomic ,copy) XNRPropertyViewValueBlock valueBlock;

@property (nonatomic ,copy) XNRPropertyViewLoginBlock loginBlock;

@end
