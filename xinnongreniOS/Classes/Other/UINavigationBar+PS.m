//
//  UINavigationBar+PS.m
//  PSGenericClass
//
//  Created by Ryan_Man on 16/6/14.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "UINavigationBar+PS.h"
#import <objc/runtime.h>
//@interface UINavigationBar (PS)
//
//@property (nonatomic,weak)UIView *view;
//@end

@implementation UINavigationBar (PS)

static char overlayerkey;

- (UIView*)overlayer
{
    return objc_getAssociatedObject(self, &overlayerkey);
}

- (void)setOverlayer:(UIView*)overlayer
{
    objc_setAssociatedObject(self, &overlayerkey, overlayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark --
- (void)ps_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlayer)
    {
        [self setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
        
        self.overlayer = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlayer.userInteractionEnabled = NO;
        self.overlayer.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlayer atIndex:0];
    }
    self.overlayer.backgroundColor = backgroundColor;
}
- (void)ps_setBarLayer
{
//    [self.view removeFromSuperview];

//    for (UIView *view in self.subviews) {
//        if (![view isKindOfClass:[UIImageView class]]) {
//            [view removeFromSuperview];
//        }
//    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    UIColor *colorOne = [UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:0.4];
    UIColor *colorTwo = [UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = CGRectMake(0, -20, ScreenWidth, 60);
//    self.layer = headerLayer;
//    [self.layer insertSublayer:headerLayer atIndex:0];
    [view.layer addSublayer:headerLayer];
    
//    [self insertSubview:view atIndex:0];
    [self addSubview:view];
}

- (void)ps_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)ps_setTransformIdentity
{
    self.transform = CGAffineTransformIdentity;
    
}

- (void)ps_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)ps_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlayer removeFromSuperview];
     self.overlayer = nil;
}
@end
