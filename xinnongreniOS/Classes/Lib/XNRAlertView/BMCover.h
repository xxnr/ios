//
//  BMCover.h
//  ibabyMap
//
//  Created by 柏杨 on 15/9/7.
//  Copyright (c) 2015年 柏杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMCover;
@protocol BMCoverDelegate <NSObject>

-(void)coverDidClicked:(BMCover *)cover;

@end


@interface BMCover : UIView
@property(nonatomic,assign)id<BMCoverDelegate>delegate;
+(BMCover *)coverShowWithView:(UIView *)view andTarget:(id)target;
+(BMCover *)coverShowWithView:(UIView *)view;
@end
