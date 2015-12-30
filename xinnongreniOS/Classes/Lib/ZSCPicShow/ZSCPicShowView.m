//
//  ZSCPicShowView.m
//  ZSC图片放大
//
//  Created by ZSC on 15/5/8.
//  Copyright (c) 2015年 ZSC. All rights reserved.
//

#import "ZSCPicShowView.h"
#import "UIImageView+WebCache.h"

//屏幕宽高
#define  kWidth   [UIScreen mainScreen].bounds.size.width
#define  kHeight  [UIScreen mainScreen].bounds.size.height

#define kPicTag 1000
#define kSubScrTag 2000

@interface ZSCPicShowView ()<UIScrollViewDelegate>
{
    UIWindow *_window;
    NSMutableArray *_picInfoArr; //保存图片模型数组
    BOOL doubleClick;
}

@property (nonatomic,strong)UIScrollView *mainScrollView;

@end

@implementation ZSCPicShowView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

//多张图片
- (void)createUIWithPicInfoArr:(NSMutableArray *)marr andIndex:(NSInteger)index
{
    //获取当前显示的窗口
    _window = [UIApplication sharedApplication].keyWindow;
   
    //保存图片模型数组为全局的
    _picInfoArr = marr;
    
    //创建主滚动视图
    [self createMainScrollView];
    
    //创建主滚动视图内容
    [self createMainScrollViewContent];
    
    //根据index判断当前显示第几张图 通过设置主滚动视图偏移量得到
    [self.mainScrollView setContentOffset:CGPointMake(kWidth*index, 0) animated:NO];
    
    //把当前显示的图片位置设为原始frame 再通过动画展示出来
    [self createAnimationShowPicWithIndex:index];
}

#pragma mark - 创建主滚动视图
- (void)createMainScrollView
{
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.mainScrollView.contentSize = CGSizeMake(kWidth*_picInfoArr.count,kHeight);
    self.mainScrollView.bounces = YES;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.minimumZoomScale = 1.0;
    self.mainScrollView.maximumZoomScale = 2.0;
    self.mainScrollView.backgroundColor=[UIColor blackColor];
    self.mainScrollView.alpha=0;
    [_window addSubview:self.mainScrollView];
}

#pragma mark - 创建主滚动视图内容
- (void)createMainScrollViewContent
{
     doubleClick = YES;
    
    for (int i=0; i<_picInfoArr.count; i++) {
        UIScrollView *subScr = [[UIScrollView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight)];
        subScr.contentSize = CGSizeMake(kWidth,kHeight);
        subScr.bounces = YES;
        //subScr.pagingEnabled = YES; 子滚动视图不能开启分页否则会晃动
        subScr.showsHorizontalScrollIndicator = NO;
        subScr.showsVerticalScrollIndicator = NO;
        subScr.delegate = self;
        subScr.minimumZoomScale = 1.0;
        subScr.maximumZoomScale = 4.0;
        subScr.tag = kSubScrTag+i;
        [self.mainScrollView addSubview:subScr];
        
        PicInfo *info = _picInfoArr[i];
        
        UIImageView *picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        picImageView.tag = kPicTag+i;
        picImageView.userInteractionEnabled = YES;
        
        //使用默认图片，而且用block 在完成后做一些事情
//        [picImageView sd_setImageWithURL:[NSURL URLWithString:info.picUrlStr] placeholderImage:[UIImage imageNamed:@"zhanwei.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//            //NSLog(@"图片加载完成后做的事情");
//            
//        }];
        if (_isNetWork) {
            [picImageView sd_setImageWithURL:[NSURL URLWithString:info.picUrlStr] placeholderImage:[UIImage imageNamed:@"zhanwei.png"]];
        }else{
            picImageView.image = [UIImage imageNamed:info.picUrlStr];
        }
        picImageView.contentMode = UIViewContentModeScaleAspectFit;
        [subScr addSubview:picImageView];
        
        UITapGestureRecognizer *oneTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
        oneTap.numberOfTouchesRequired = 1;
        oneTap.numberOfTapsRequired = 1;
        [subScr addGestureRecognizer:oneTap];
        
        UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapBig:)];
        doubleTap.numberOfTapsRequired = 2;
        [picImageView addGestureRecognizer:doubleTap];
        //[A requireGestureRecognizerToFail:B]函数,它可以指定当A手势发生时,即便A已经滿足条件了,也不会立刻触发,会等到指定的手势B确定失败之后才触发。
        [oneTap requireGestureRecognizerToFail:doubleTap];
    }

}

#pragma mark - 把第一次进入的当前显示图片位置设为原始frame 再通过动画展示出来
- (void)createAnimationShowPicWithIndex:(NSInteger)index
{
    //取出当前显示的图片
    PicInfo *info = _picInfoArr[index];
    //原始frame
    CGRect oldframe = info.picOldFrame;
    UIImageView *currentShowPic = (UIImageView *)[self.mainScrollView viewWithTag:kPicTag+index];
    currentShowPic.frame = oldframe;
    currentShowPic.contentMode = UIViewContentModeScaleAspectFit;
    
    [UIView animateWithDuration:0.3 animations:^{
        currentShowPic.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.mainScrollView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 图片点击隐藏还原回原来位置
-(void)hideImage:(UITapGestureRecognizer*)tap{
    //获取第几张图片点击
    PicInfo *info = _picInfoArr[tap.view.tag-2000];
    UIImageView *imageView = (UIImageView *)[self.mainScrollView viewWithTag:tap.view.tag-1000];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=info.picOldFrame;
        self.mainScrollView.alpha=0;
    } completion:^(BOOL finished) {
        [self.mainScrollView removeFromSuperview];
    }];
}

#pragma mark - 双击放大
- (void)doubleTapBig:(UITapGestureRecognizer *)tap
{
    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self.mainScrollView viewWithTag:tap.view.tag+1000];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tap locationInView:tap.view] andScrollView:currentScrollView];
    
    if (doubleClick == YES)  {
        [currentScrollView zoomToRect:zoomRect animated:YES];
    }
    else {
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    doubleClick = !doubleClick;
}

- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
    
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageView = (UIImageView *)[self.mainScrollView viewWithTag:scrollView.tag-1000];
    return imageView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = self.mainScrollView.contentOffset;
    NSInteger page = offset.x / kWidth ;
    
    if (page != 0) {
        UIScrollView *scrollV_next = (UIScrollView *)[self.mainScrollView viewWithTag:page+kSubScrTag - 1]; //前一页
        if (scrollV_next.zoomScale != 1.0){
            
            scrollV_next.zoomScale = 1.0;
        }

    }
    if (page != _picInfoArr.count) {
        UIScrollView *scollV_pre = (UIScrollView *)[self.mainScrollView viewWithTag:page+kSubScrTag+1]; //后一页
        if (scollV_pre.zoomScale != 1.0){
            scollV_pre.zoomScale = 1.0;
        }
    }
    
    if (page == 0 ) {
        UIScrollView *scollV_pre = (UIScrollView *)[self.mainScrollView viewWithTag:page+kSubScrTag+1]; //后一页
        if (scollV_pre.zoomScale != 1.0){
            scollV_pre.zoomScale = 1.0;
        }
    }
    
    if (page == _picInfoArr.count) {
        UIScrollView *scrollV_next = (UIScrollView *)[self.mainScrollView viewWithTag:page+kSubScrTag - 1]; //前一页
        if (scrollV_next.zoomScale != 1.0){
            
            scrollV_next.zoomScale = 1.0;
        }
    }
    
}

@end
