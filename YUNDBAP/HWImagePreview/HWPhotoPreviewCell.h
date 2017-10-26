//
//  HWPhotoPreviewCell.h
//  HWImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWAssetModel;
@interface HWAssetPreviewCell : UICollectionViewCell
@property (nonatomic, strong) HWAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)();

- (void)configSubviews;
- (void)photoPreviewCollectionViewDidScroll;

@end


@class HWAssetModel,HWProgressView,HWPhotoPreviewView;
@interface HWPhotoPreviewCell : HWAssetPreviewCell

@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

@property (nonatomic, strong) HWPhotoPreviewView *previewView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;


- (void)recoverSubviews;

@end


@interface HWPhotoPreviewView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) HWProgressView *progressView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

@property (nonatomic, strong) HWAssetModel *model;
@property (nonatomic, strong) id asset;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, copy) void (^singleTapGestureBlock)();
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

@property (nonatomic, assign) int32_t imageRequestID;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
- (void)recoverSubviews;
@end


@class AVPlayer, AVPlayerLayer;
@interface HWVideoPreviewCell : HWAssetPreviewCell
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIImage *cover;
- (void)pausePlayerAndShowNaviBar;
@end


@interface HWGifPreviewCell : HWAssetPreviewCell
@property (strong, nonatomic) HWPhotoPreviewView *previewView;
@end
