//
//  XNRPropertyFootView.h
//  xinnongreniOS
//
//  Created by xxnr on 16/2/23.
//  Copyright © 2016年 qxhiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XNRPropertyFootViewBlock)(NSString *numTF);

@interface XNRPropertyFootView : UICollectionReusableView

@property (nonatomic ,copy) XNRPropertyFootViewBlock com;

@end
