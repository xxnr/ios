//
//  XNRPayTypeAlertView.h
//  xinnongreniOS
//
//  Created by ZSC on 15/7/9.
//  Copyright (c) 2015年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

//科目类型
typedef enum{
    kFromTop = 0,     //从上边
    kFromBottom = 1,  //从下边
    kFromLeft = 2,    //从左边
    kFromRight = 3,   //从右边
}kDirection;          //方向

@interface XNRPayTypeAlertView : UIView

@property (nonatomic,copy) void (^deleteBlock)();

@property (nonatomic,assign) kDirection kDirection; //方向

- (void)createContentView;//创建内容

@end
