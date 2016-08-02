//
//  XNRTextView.h
//  xinnongreniOS
//
//  Created by 杨宁 on 16/8/1.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNRTextView : UITextView<UITextViewDelegate>

@property (nonatomic,copy)NSString *placehoder;
@property (nonatomic,strong)UIColor *placehoderColor;
@property (nonatomic,assign)BOOL isAutoHeight;

@end
