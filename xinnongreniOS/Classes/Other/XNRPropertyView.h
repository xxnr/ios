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



@interface XNRPropertyView : UIView

-(void)show;

-(instancetype)initWithFrame:(CGRect)frame model:(XNRShoppingCartModel *)shopcarModel;

@property (nonatomic, copy) XNRPropertyViewBlock com;

@property (nonatomic ,copy) XNRPropertyViewValueBlock valueBlock;

@property (nonatomic ,assign) XNRPropertyViewType type;


@end
