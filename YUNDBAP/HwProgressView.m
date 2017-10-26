//
//  HwProgressView.m
//  xxoo
//
//  Created by 9vs on 15/9/14.
//  Copyright (c) 2015年 9vs. All rights reserved.
//

#import "HwProgressView.h"

@interface HwProgressView ()
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, readwrite) CGFloat progress;
@property (strong, nonatomic) UIImageView *progressBackImgView;
@property (nonatomic,strong)UIActivityIndicatorView *prepLoadingActView;
@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@end


@implementation HwProgressView

+ (HwProgressView *)sharedView {
    static dispatch_once_t once;
    static HwProgressView *sharedView;
    dispatch_once(&once, ^ { sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}


+ (void)showProgress:(float)progress {
    [self sharedView];
    [[self sharedView] showProgress:progress];
}
+ (void)dismiss {
    [[self sharedView] dismiss];
}
- (void)dismiss {
    
   
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
    
    [self.progressBackImgView removeFromSuperview];
    self.overlayView = nil;
    
    [self removeFromSuperview];
    self.hidden = YES;
   
}

#pragma mark - Master show/dismiss methods

- (void)showProgress:(float)progress {
//    if(!self.overlayView.superview){
//
//        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
//        for (UIWindow *window in frontToBackWindows){
//            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
//            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
//            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
//            
//            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
//                [window addSubview:self.overlayView];
//                break;
//            }
//        }
//
//  
//    } else {
//       
//        [self.overlayView.superview bringSubviewToFront:self.overlayView];
//    }
//    
//    if(!self.superview)
//    [self.overlayView addSubview:self];
    

    self.hidden = NO;
    
    
    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    
    if (!self.overlayView.superview) {
        [self addSubview:self.overlayView];
    }
    

    CGRect wRect = [UIScreen mainScreen].bounds;
    wRect.origin.x = 10;
    wRect.origin.y = wRect.size.height - 140;
    wRect.size.width = wRect.size.width - 20;
    wRect.size.height = 130;
    self.progressBackImgView.frame = wRect;
    if (!self.progressBackImgView.superview) {
       [self addSubview:self.progressBackImgView];
    }
    
    
    
    self.progressView.frame = CGRectMake(20, 50, wRect.size.width-40, 0);
    [self.progressBackImgView addSubview:self.progressView];
    
    self.progressView.progress = progress;
    
//    self.prepLoadingActView.center = CGPointMake(80, 25);
    [self.progressBackImgView addSubview:self.prepLoadingActView];
    [self.prepLoadingActView startAnimating];
    

    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize textSize = [self.lab1.text boundingRectWithSize:CGSizeMake(300, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//    self.lab1.center = CGPointMake(wRect.size.width/2, 25);
//    self.lab1.bounds = CGRectMake(0, 0, 300, 30);
    self.lab1.frame = CGRectMake(wRect.size.width/2 - textSize.width/2, 15, 300, textSize.height);
    self.prepLoadingActView.center = CGPointMake(wRect.size.width/2 - textSize.width/2 - 20, 25);
    
//    self.lab1.frame = CGRectMake(110, 10, 200, 30);
    [self.progressBackImgView addSubview:self.lab1];
    
    self.lab2.center = CGPointMake(wRect.size.width/2, wRect.size.height-40);
    self.lab2.bounds = CGRectMake(0, 0, 100, 30);
    if (progress * 100.0 <= 100) {
       self.lab2.text = [NSString stringWithFormat:@"%.f%@",progress*100.0,@"%"];
    }else {
        self.lab2.text = @"100%";
    }
   
    [self.progressBackImgView addSubview:self.lab2];
}
+ (void)showProgress:(float)progress message:(NSString *)msg {
    [self sharedView];
    [[self sharedView] message:msg];
    [[self sharedView] showProgress:progress];
}
- (void)message:(NSString *)msg {
    self.lab1.text = msg;
}
#pragma mark - Getters
- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0.4;
//        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}

- (UIImageView *)progressBackImgView {
    if (!_progressBackImgView) {
        _progressBackImgView = [[UIImageView alloc] init];
        _progressBackImgView.backgroundColor = [UIColor whiteColor];
        _progressBackImgView.alpha = 0.9;
        _progressBackImgView.layer.cornerRadius = 7;
        _progressBackImgView.layer.masksToBounds = YES;
    }
    return _progressBackImgView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
//        _progressView.progressViewStyle = UIProgressViewStyleBar;
        _progressView.trackTintColor = [UIColor lightGrayColor];
        _progressView.progressTintColor = [UIColor blueColor];
        _progressView.progress = 0;
    }
    return _progressView;
}
- (UIActivityIndicatorView *)prepLoadingActView {
    if (!_prepLoadingActView) {
        _prepLoadingActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        _prepLoadingActView.hidesWhenStopped = YES;
    }
    return _prepLoadingActView;
}

- (UILabel *)lab1 {
    if (!_lab1) {
        _lab1 = [[UILabel alloc] init];
        _lab1.text = @"更新数据中，请稍候......";
        _lab1.textColor = [UIColor grayColor];
//        _lab1.font = [UIFont fontWithName:nil size:13];
    }
    return _lab1;
}
- (UILabel *)lab2 {
    if (!_lab2) {
        _lab2 = [[UILabel alloc] init];
        _lab2.textColor = [UIColor grayColor];
        _lab2.textAlignment = NSTextAlignmentCenter;
    }
    return _lab2;
}
@end
