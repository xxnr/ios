//
//  BMProgressView.m
//  ibabyMap
//
//  Created by 柏杨 on 15/10/21.
//  Copyright © 2015年 柏杨. All rights reserved.
//

#import "BMProgressView.h"
#import "DetailSize.h"
#import "UIView+Frame.h"
#define BYWindow [UIApplication sharedApplication].keyWindow
static CGRect oldframe;

@interface BMProgressView ()
@property(nonatomic,assign)BOOL isError;
@property(nonatomic,assign)double angle;
@property(nonatomic,weak)UIImageView *loadView;
@property(nonatomic,strong)NSTimer *timer;
@property (nonatomic ,weak) BMProgressView *bcView;
@end

@implementation BMProgressView
+(BMProgressView *)showCoverWithTarget:(UIView *)target color:(UIColor *)bcColor isNavigation:(BOOL)isNavigation
{
    
    BMProgressView *bcView = [[BMProgressView alloc]initWithTarget:target color:bcColor isNavigation:isNavigation];
    bcView.isError = NO;
    bcView.backgroundColor = bcColor;
    [target addSubview:bcView];

    
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    showView.center = CGPointMake(bcView.width/2, bcView.height/2);
    if (isNavigation) {
        showView.y -= 64;
    }
    showView.backgroundColor = [UIColor clearColor];
    showView.alpha = 0.35;
    showView.layer.cornerRadius = 5;
    [bcView addSubview:showView];


    
    UIImageView *loadView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xxnr_loading"]];
    loadView.center = showView.center;
    bcView.loadView = loadView;
    [bcView addSubview:loadView];
    
//    [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector:@selector(transformAction) userInfo: nil repeats: YES];
//    [bcView transformAction];
    
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:bcView selector:@selector(transformAction) userInfo:nil repeats:YES];

    return bcView;
}

-(instancetype)initWithTarget:(UIView *)target color:(UIColor *)bcColor isNavigation:(BOOL)isNavigation
{
    if (self = [super init]) {
        self.frame = target.bounds;
        self.backgroundColor = bcColor;
        self.isError = NO;
        [target addSubview:self];
        
        
        UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        showView.center = CGPointMake(self.width/2, self.height/2);
        if (isNavigation) {
            showView.y -= 64;
        }
        showView.backgroundColor = [UIColor clearColor];
        showView.alpha = 0.35;
        showView.layer.cornerRadius = 5;
        [self addSubview:showView];
        
        
        
        UIImageView *loadView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xxnr_loading"]];
        loadView.center = showView.center;
        self.loadView = loadView;
        [self addSubview:loadView];
        
        
       _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(transformAction) userInfo:nil repeats:YES];

    }
    return self;
}

-(void)transformAction {
    _angle += 0.1;//angle角度 double angle;
    if (_angle > 6.28) {//大于 M_PI*2(360度) 角度再次从0开始
        _angle = 0;
    }
//    [UIView animateWithDuration:0.1 animations:^{
        self.loadView.transform = CGAffineTransformMakeRotation(_angle);
//    }];
}

+(BMProgressView *)showErrorViewWtihTarget:(UIView *)target
{
    BMProgressView *errorView = [[BMProgressView alloc]initWithFrame:target.bounds];
    errorView.isError = YES;
    errorView.backgroundColor = GENBCColor;
    [target addSubview:errorView];
    
    UIImageView *error = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xxnr_loading"]];
    error.y = 107*(BYWindow.height/736.);
    error.center = CGPointMake(target.width/2, error.center.y);
    [errorView addSubview:error];
    return errorView;
    
}
+(BMProgressView *)showEmptyWithTarget:(UIView *)target
{
    BMProgressView *emptyView = [[BMProgressView alloc]initWithFrame:target.bounds];
    emptyView.isError = NO;
    emptyView.backgroundColor = GENBCColor;
    [target addSubview:emptyView];
    
    UIImageView *error = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xxnr_loading"]];
    error.y = 107*(BYWindow.height/736.);
    error.center = CGPointMake(target.width/2, error.center.y);
    [emptyView addSubview:error];
    return emptyView;

}

-(void)LoadViewDisappear
{
    [_timer invalidate];
    _timer = nil;
    [UIView animateWithDuration:2 animations:^{
        [self removeFromSuperview];

    }];
}

+(void)LoadViewDisappear
{
    BMProgressView *progressView = [[BMProgressView alloc] init];
    [progressView removeFromSuperview];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isError == YES) {
        self.block();
    }
}

+(UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    //M_PI, 0.0, 0.0, 1.0
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 0;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}



@end
