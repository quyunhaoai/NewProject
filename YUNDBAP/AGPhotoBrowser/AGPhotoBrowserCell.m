//
//  AGPhotoBrowserCell.m
//  AGPhotoBrowser
//
//  Created by Hellrider on 1/5/14.
//  Copyright (c) 2014 Andrea Giavatto. All rights reserved.
//

#import "AGPhotoBrowserCell.h"
#import "AGPhotoBrowserZoomableView.h"
#import "UIImageView+WebCache.h"

@interface AGPhotoBrowserCell () <AGPhotoBrowserZoomableViewDelegate>

@property (nonatomic, strong) AGPhotoBrowserZoomableView *zoomableView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation AGPhotoBrowserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self setupCell];
	}
	
	return self;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.center = self.zoomableView.imageView.center;//只能设置中心，不能设置大小
       
        [self.zoomableView addSubview:_activityIndicatorView];
//        _activityIndicatorView.color = [UIColor redColor]; // 改变圈圈的颜色为红色； iOS5引入
     
        [_activityIndicatorView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }
    return _activityIndicatorView;
    
}
- (void)updateConstraints
{
	[self.contentView removeConstraints:self.contentView.constraints];
	
	NSDictionary *constrainedViews = NSDictionaryOfVariableBindings(_zoomableView);
	
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_zoomableView]|"
																			 options:0
																			 metrics:@{}
																			   views:constrainedViews]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_zoomableView]|"
																			 options:0
																			 metrics:@{}
																			   views:constrainedViews]];
	
	[super updateConstraints];
}

- (void)setFrame:(CGRect)frame
{
    // -- Force the right frame
    CGRect correctFrame = frame;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation) || UIDeviceOrientationIsLandscape(orientation) || orientation == UIDeviceOrientationFaceUp) {
        if (UIDeviceOrientationIsPortrait(orientation) || orientation == UIDeviceOrientationFaceUp) {
            correctFrame.size.width = CGRectGetHeight([[UIScreen mainScreen] bounds]);
            correctFrame.size.height = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        } else {
            correctFrame.size.width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
            correctFrame.size.height = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        }
    }
    
    [super setFrame:correctFrame];
}


#pragma mark - Getters

- (AGPhotoBrowserZoomableView *)zoomableView
{
	if (!_zoomableView) {
		_zoomableView = [[AGPhotoBrowserZoomableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_zoomableView.userInteractionEnabled = YES;
        _zoomableView.zoomableDelegate = self;
		
		[_zoomableView addGestureRecognizer:self.panGesture];
        
		CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
		CGPoint origin = _zoomableView.frame.origin;
		_zoomableView.transform = transform;
        CGRect frame = _zoomableView.frame;
        frame.origin = origin;
        _zoomableView.frame = frame;
	}
	
	return _zoomableView;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_imageViewPanned:)];
		_panGesture.delegate = self;
		_panGesture.maximumNumberOfTouches = 1;
		_panGesture.minimumNumberOfTouches = 1;
    }
    
    return _panGesture;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGesture) {
        UIView *imageView = [gestureRecognizer view];
        CGPoint translation = [gestureRecognizer translationInView:[imageView superview]];
        
        // -- Check for horizontal gesture
        if (fabsf(translation.x) > fabsf(translation.y)) {
            return YES;
        }
    }
	
    return NO;
}


#pragma mark - Setters

- (void)setCellImage:(UIImage *)cellImage
{
	[self.zoomableView setImage:cellImage];
	
//	[self setNeedsUpdateConstraints];
}

- (void)setCellImageWithURL:(NSURL *)url
{
    self.zoomableView.imageView.image = nil;
//    [[UIApplication sharedApplication].keyWindow showHUDWithText:@"" Type:ShowLoading Enabled:YES];

    [self.activityIndicatorView startAnimating]; // 开始旋转
  

    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"---->%ld---%ld",receivedSize,expectedSize);
        
        if (receivedSize/expectedSize == 1) {
//            [[UIApplication sharedApplication].keyWindow showHUDWithText:nil Type:ShowDismiss Enabled:YES];
              [self.activityIndicatorView stopAnimating]; // 结束旋转
        }
     
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        self.zoomableView.imageView.image = image;
    }];
    
    
//    [self.zoomableView.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_supreq_view"]];
}

#pragma mark - Public methods

- (void)resetZoomScale
{
	[self.zoomableView setZoomScale:1.];
}


#pragma mark - Private methods

- (void)setupCell
{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:self.zoomableView];
}

- (void)p_imageViewPanned:(UIPanGestureRecognizer *)recognizer
{
	[self.delegate didPanOnZoomableViewForCell:self withRecognizer:recognizer];
}


#pragma mark - AGPhotoBrowserZoomableViewDelegate

- (void)didDoubleTapZoomableView:(AGPhotoBrowserZoomableView *)zoomableView
{
	[self.delegate didDoubleTapOnZoomableViewForCell:self];
}

@end
