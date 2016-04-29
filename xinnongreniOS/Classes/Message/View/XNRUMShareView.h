//
//  XNRUMShareView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/4/15.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    wechatbtn_type,
    wechatCirclebtn_type,
    qqbtn_type,
    qzonebtn_type,
} XNRUMShareViewType;

@protocol XNRUMShareViewDelegate <NSObject>

@optional;

-(void)XNRUMShareViewBtnClick:(XNRUMShareViewType)type;

@end

@interface XNRUMShareView : UIView

@property (nonatomic, assign) id<XNRUMShareViewDelegate>delegate;

-(void)show;

-(void)cancel;

@end


@interface XNRUMShareBtn : UIView

@property (nonatomic, weak) UIImageView *shareImage;

@property (nonatomic, weak) UILabel *shareLabel;

@end
