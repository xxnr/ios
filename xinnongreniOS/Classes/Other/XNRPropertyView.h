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

typedef void(^XNRPropertyViewBlock)(NSMutableArray *dataArray,CGFloat totalPrice,NSString *totalNum);

typedef void(^XNRPropertyViewValueBlock)(NSMutableArray *attributes,NSMutableArray *addtions,NSString *price,NSString *marketPrice);

typedef void(^XNRPropertyViewLoginBlock)();



@interface XNRPropertyView : UIView
//单例
+(id)sharedInstanceWithModel:(XNRShoppingCartModel *)shopcarModel;

-(void)show:(XNRPropertyViewType)buyType isRoot:(BOOL)isRoot;

-(instancetype)initWithFrame:(CGRect)frame model:(XNRShoppingCartModel *)shopcarModel;

@property (nonatomic, copy) XNRPropertyViewBlock com;

@property (nonatomic ,copy) XNRPropertyViewValueBlock valueBlock;

@property (nonatomic ,copy) XNRPropertyViewLoginBlock loginBlock;

@end
