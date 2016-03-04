//
//  XNRPropertyView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/2/19.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XNRPropertyViewBlock)(NSString *value1,NSString *value2,NSString *value3);


@interface XNRPropertyView : UIView


-(void)show;

-(instancetype)initWithFrame:(CGRect)frame model:(XNRShoppingCartModel *)shopcarModel;

@property (nonatomic, assign) XNRPropertyViewBlock com;


@end
