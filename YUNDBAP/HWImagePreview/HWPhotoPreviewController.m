//
//  HWPhotoPreviewController.m
//  HWImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "HWPhotoPreviewController.h"
#import "HWPhotoPreviewCell.h"
#import "HWAssetModel.h"
#import "UIView+HWLayout.h"
//#import "HWImagePickerController.h"
#import "HWImageManager.h"
//#import "HWImageCropManager.h"

@interface HWPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
    
    CGFloat _offsetItemCount;
}
@property (nonatomic, assign) BOOL isHideNaviBar;
@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;

@property (nonatomic, assign) double progress;
@property (strong, nonatomic) id alertView;
@end

@implementation HWPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HWImageManager manager].shouldFixOrientation = YES;
    __weak typeof(self) weakSelf = self;
//    HWImagePickerController *_HWImagePickerVc = (HWImagePickerController *)weakSelf.navigationController;
//    if (!self.models.count) {
//        self.models = [NSMutableArray arrayWithArray:_HWImagePickerVc.selectedModels];
//        _assetsTemp = [NSMutableArray arrayWithArray:_HWImagePickerVc.selectedAssets];
//        self.isSelectOriginalPhoto = _HWImagePickerVc.isSelectOriginalPhoto;
//    }
    [self configCollectionView];
//    [self configCustomNaviBar];
    [self configBottomToolBar];
    self.view.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    _photosTemp = [NSArray arrayWithArray:photos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    if (!HW_isGlobalHideStatusBar) {
//        if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
//    }
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.HW_width + 20) * _currentIndex, 0) animated:NO];
//    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if (!HW_isGlobalHideStatusBar) {
//        if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = NO;
//    }
    [HWImageManager manager].shouldFixOrientation = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
/*
- (void)configCustomNaviBar {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRecHWero];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRecHWero];
    [_backButton setImage:[UIImage imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRecHWero];
    [_selectButton setImage:[UIImage imageNamedFromMyBundle:HWImagePickerVc.photoDefImageName] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamedFromMyBundle:HWImagePickerVc.photoSelImageName] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = !HWImagePickerVc.showSelectBtn;
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}
 */

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    static CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
//    HWImagePickerController *_HWImagePickerVc = (HWImagePickerController *)self.navigationController;
//    if (_HWImagePickerVc.allowPickingOriginalPhoto) {
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _originalPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
        _originalPhotoButton.backgroundColor = [UIColor clearColor];
//        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        
        [_originalPhotoButton setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.currentIndex+1,self.models.count] forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.currentIndex+1,self.models.count] forState:UIControlStateSelected];
        
        
        
        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:_HWImagePickerVc.photoPreviewOriginDefImageName] forState:UIControlStateNormal];
//        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:_HWImagePickerVc.photoOriginSelImageName] forState:UIControlStateSelected];
        
        _originalPhotoLabel = [[UILabel alloc] init];
        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLabel.font = [UIFont systemFontOfSize:13];
        _originalPhotoLabel.textColor = [UIColor whiteColor];
        _originalPhotoLabel.backgroundColor = [UIColor clearColor];
//        if (_isSelectOriginalPhoto) [self showPhotoBytes];
//    }
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
//    _numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedFromMyBundle:_HWImagePickerVc.photoNumberIconImageName]];
//    _numberImageView.backgroundColor = [UIColor clearColor];
//    _numberImageView.hidden = _HWImagePickerVc.selectedModels.count <= 0;
    
//    _numberLabel = [[UILabel alloc] init];
//    _numberLabel.font = [UIFont systemFontOfSize:15];
//    _numberLabel.textColor = [UIColor whiteColor];
//    _numberLabel.textAlignment = NSTextAlignmentCenter;
//    _numberLabel.text = [NSString stringWithFormat:@"%zd",_HWImagePickerVc.selectedModels.count];
//    _numberLabel.hidden = _HWImagePickerVc.selectedModels.count <= 0;
//    _numberLabel.backgroundColor = [UIColor clearColor];
    
    [_originalPhotoButton addSubview:_originalPhotoLabel];
    [_toolBar addSubview:_doneButton];
    [_toolBar addSubview:_originalPhotoButton];
    [_toolBar addSubview:_numberImageView];
    [_toolBar addSubview:_numberLabel];
    [self.view addSubview:_toolBar];
}

- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.HW_width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[HWPhotoPreviewCell class] forCellWithReuseIdentifier:@"HWPhotoPreviewCell"];
    [_collectionView registerClass:[HWVideoPreviewCell class] forCellWithReuseIdentifier:@"HWVideoPreviewCell"];
    [_collectionView registerClass:[HWGifPreviewCell class] forCellWithReuseIdentifier:@"HWGifPreviewCell"];
}
/*
- (void)configCropView {
//    HWImagePickerController *_HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    if (!_HWImagePickerVc.showSelectBtn && _HWImagePickerVc.allowCrop) {
        [_cropView removeFromSuperview];
        [_cropBgView removeFromSuperview];
        
        _cropBgView = [UIView new];
        _cropBgView.userInteractionEnabled = NO;
        _cropBgView.frame = self.view.bounds;
        _cropBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_cropBgView];
//        [HWImageCropManager overlayClippingWithView:_cropBgView cropRect:_HWImagePickerVc.cropRect containerView:self.view needCircleCrop:_HWImagePickerVc.needCircleCrop];
        
        _cropView = [UIView new];
        _cropView.userInteractionEnabled = NO;
        _cropView.frame = _HWImagePickerVc.cropRect;
        _cropView.backgroundColor = [UIColor clearColor];
        _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropView.layer.borderWidth = 1.0;
        if (_HWImagePickerVc.needCircleCrop) {
            _cropView.layer.cornerRadius = _HWImagePickerVc.cropRect.size.width / 2;
            _cropView.clipsToBounds = YES;
        }
        [self.view addSubview:_cropView];
//        if (_HWImagePickerVc.cropViewSettingBlock) {
//            _HWImagePickerVc.cropViewSettingBlock(_cropView);
//        }
    }
}
*/
#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    HWImagePickerController *_HWImagePickerVc = (HWImagePickerController *)self.navigationController;

    _naviBar.frame = CGRectMake(0, 0, self.view.HW_width, 64);
    _backButton.frame = CGRectMake(10, 10, 44, 44);
    _selectButton.frame = CGRectMake(self.view.HW_width - 54, 10, 42, 42);
    
    _layout.itemSize = CGSizeMake(self.view.HW_width + 20, self.view.HW_height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.HW_width + 20, self.view.HW_height);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
//    if (_HWImagePickerVc.allowCrop) {
//        [_collectionView reloadData];
//    }
    
    _toolBar.frame = CGRectMake(0, self.view.HW_height - 44, self.view.HW_width, 44);
//    if (_HWImagePickerVc.allowPickingOriginalPhoto) {
        CGFloat fullImageWidth = [@"测试测试测试" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
        _originalPhotoButton.frame = CGRectMake(0, 0, fullImageWidth + 56, 44);
        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 42, 0, 80, 44);
//    }
    _doneButton.frame = CGRectMake(self.view.HW_width - 44 - 12, 0, 44, 44);
    _numberImageView.frame = CGRectMake(self.view.HW_width - 56 - 28, 7, 30, 30);
    _numberLabel.frame = _numberImageView.frame;
    
//    [self configCropView];
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - Click Event
/*
- (void)select:(UIButton *)selectButton {
    HWImagePickerController *_HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    HWAssetModel *model = _models[_currentIndex];
    if (!selectButton.isSelected) {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_HWImagePickerVc.selectedModels.count >= _HWImagePickerVc.maxImagesCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle HW_localizedStringForKey:@"Select a maximum of %zd photos"], _HWImagePickerVc.maxImagesCount];
            [_HWImagePickerVc showAlertWithTitle:title];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [_HWImagePickerVc.selectedModels addObject:model];
            if (self.photos) {
                [_HWImagePickerVc.selectedAssets addObject:_assetsTemp[_currentIndex]];
                [self.photos addObject:_photosTemp[_currentIndex]];
            }
            if (model.type == HWAssetModelMediaTypeVideo && !_HWImagePickerVc.allowPickingMultipleVideo) {
                [_HWImagePickerVc showAlertWithTitle:[NSBundle HW_localizedStringForKey:@"Select the video when in multi state, we will handle the video as a photo"]];
            }
        }
    } else {
        NSArray *selectedModels = [NSArray arrayWithArray:_HWImagePickerVc.selectedModels];
        for (HWAssetModel *model_item in selectedModels) {
            if ([[[HWImageManager manager] getAssetIdentifier:model.asset] isEqualToString:[[HWImageManager manager] getAssetIdentifier:model_item.asset]]) {
                // 1.6.7版本更新:防止有多个一样的model,一次性被移除了
                NSArray *selectedModelsTmp = [NSArray arrayWithArray:_HWImagePickerVc.selectedModels];
                for (NSInteger i = 0; i < selectedModelsTmp.count; i++) {
                    HWAssetModel *model = selectedModelsTmp[i];
                    if ([model isEqual:model_item]) {
                        [_HWImagePickerVc.selectedModels removeObjectAtIndex:i];
                        break;
                    }
                }
                // [_HWImagePickerVc.selectedModels removeObject:model_item];
                if (self.photos) {
                    // 1.6.7版本更新:防止有多个一样的asset,一次性被移除了
                    NSArray *selectedAssetsTmp = [NSArray arrayWithArray:_HWImagePickerVc.selectedAssets];
                    for (NSInteger i = 0; i < selectedAssetsTmp.count; i++) {
                        id asset = selectedAssetsTmp[i];
                        if ([asset isEqual:_assetsTemp[_currentIndex]]) {
                            [_HWImagePickerVc.selectedAssets removeObjectAtIndex:i];
                            break;
                        }
                    }
                    // [_HWImagePickerVc.selectedAssets removeObject:_assetsTemp[_currentIndex]];
                    [self.photos removeObject:_photosTemp[_currentIndex]];
                }
                break;
            }
        }
    }
    model.isSelected = !selectButton.isSelected;
    [self refreshNaviBarAndBottomBarState];
    if (model.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:HWOscillatoryAnimationToBigger];
    }
    [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:HWOscillatoryAnimationToSmaller];
}

- (void)backButtonClick {
    if (self.navigationController.childViewControllers.count < 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}
*/
- (void)doneButtonClick {
 [self dismissViewControllerAnimated:NO completion:nil];
    if (self.doneButtonClickBlock) {
        self.doneButtonClickBlock(YES);
        
    }
    
    
    /*
    HWImagePickerController *_HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    // 如果图片正在从iCloud同步中,提醒用户
    if (_progress > 0 && _progress < 1 && (_selectButton.isSelected || !_HWImagePickerVc.selectedModels.count )) {
        _alertView = [_HWImagePickerVc showAlertWithTitle:[NSBundle HW_localizedStringForKey:@"Synchronizing photos from iCloud"]];
        return;
    }
    
    // 如果没有选中过照片 点击确定时选中当前预览的照片
    if (_HWImagePickerVc.selectedModels.count == 0 && _HWImagePickerVc.minImagesCount <= 0) {
        HWAssetModel *model = _models[_currentIndex];
        [_HWImagePickerVc.selectedModels addObject:model];
    }
    if (_HWImagePickerVc.allowCrop) { // 裁剪状态
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        HWPhotoPreviewCell *cell = (HWPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        UIImage *cropedImage = [HWImageCropManager cropImageView:cell.previewView.imageView toRect:_HWImagePickerVc.cropRect zoomScale:cell.previewView.scrollView.zoomScale containerView:self.view];
        if (_HWImagePickerVc.needCircleCrop) {
            cropedImage = [HWImageCropManager circularClipImage:cropedImage];
        }
        if (self.doneButtonClickBlockCropMode) {
            HWAssetModel *model = _models[_currentIndex];
            self.doneButtonClickBlockCropMode(cropedImage,model.asset);
        }
    } else if (self.doneButtonClickBlock) { // 非裁剪状态
        self.doneButtonClickBlock(_isSelectOriginalPhoto);
    }
    if (self.doneButtonClickBlockWithPreviewType) {
        self.doneButtonClickBlockWithPreviewType(self.photos,_HWImagePickerVc.selectedAssets,self.isSelectOriginalPhoto);
    }
    */
}
/*
- (void)originalPhotoButtonClick {
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) {
        [self showPhotoBytes];
        if (!_selectButton.isSelected) {
            // 如果当前已选择照片张数 < 最大可选张数 && 最大可选张数大于1，就选中该张图
            HWImagePickerController *_HWImagePickerVc = (HWImagePickerController *)self.navigationController;
            if (_HWImagePickerVc.selectedModels.count < _HWImagePickerVc.maxImagesCount && _HWImagePickerVc.showSelectBtn) {
                [self select:_selectButton];
            }
        }
    }
}
*/
- (void)didTapPreviewCell {
    self.isHideNaviBar = !self.isHideNaviBar;
    _naviBar.hidden = self.isHideNaviBar;
    _toolBar.hidden = self.isHideNaviBar;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.HW_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.HW_width + 20);
    
    if (currentIndex < _models.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
//        [self refreshNaviBarAndBottomBarState];
    }
    [_originalPhotoButton setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)currentIndex+1,self.models.count] forState:UIControlStateNormal];
    [_originalPhotoButton setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)currentIndex+1,self.models.count] forState:UIControlStateSelected];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    HWImagePickerController *_HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    HWAssetModel *model = _models[indexPath.row];
    
    HWAssetPreviewCell *cell;
    __weak typeof(self) weakSelf = self;
  
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWPhotoPreviewCell" forIndexPath:indexPath];
        HWPhotoPreviewCell *photoPreviewCell = (HWPhotoPreviewCell *)cell;
//        photoPreviewCell.cropRect = _HWImagePickerVc.cropRect;
//        photoPreviewCell.allowCrop = _HWImagePickerVc.allowCrop;
//        __weak typeof(_HWImagePickerVc) weakHWImagePickerVc = _HWImagePickerVc;
        __weak typeof(_collectionView) weakCollectionView = _collectionView;
        __weak typeof(photoPreviewCell) weakCell = photoPreviewCell;
        [photoPreviewCell setImageProgressUpdateBlock:^(double progress) {
            weakSelf.progress = progress;
            if (progress >= 1) {
                if (weakSelf.alertView && [weakCollectionView.visibleCells containsObject:weakCell]) {
//                    [weakHWImagePickerVc hideAlertView:weakSelf.alertView];
                    weakSelf.alertView = nil;
                    [weakSelf doneButtonClick];
                }
            }
        }];
    
    
    cell.model = model;
    [cell setSingleTapGestureBlock:^{
        [weakSelf didTapPreviewCell];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[HWPhotoPreviewCell class]]) {
        [(HWPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[HWPhotoPreviewCell class]]) {
        [(HWPhotoPreviewCell *)cell recoverSubviews];
    } else if ([cell isKindOfClass:[HWVideoPreviewCell class]]) {
        [(HWVideoPreviewCell *)cell pausePlayerAndShowNaviBar];
    }
}

#pragma mark - Private Method

- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}
/*
- (void)refreshNaviBarAndBottomBarState {
    HWImagePickerController *_HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    HWAssetModel *model = _models[_currentIndex];
    _selectButton.selected = model.isSelected;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_HWImagePickerVc.selectedModels.count];
    _numberImageView.hidden = (_HWImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || _isCropImage);
    _numberLabel.hidden = (_HWImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || _isCropImage);
    
    _originalPhotoButton.selected = _isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
//    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (!_isHideNaviBar) {
        if (model.type == HWAssetModelMediaTypeVideo) {
            _originalPhotoButton.hidden = YES;
            _originalPhotoLabel.hidden = YES;
        } else {
            _originalPhotoButton.hidden = NO;
            if (_isSelectOriginalPhoto)  _originalPhotoLabel.hidden = NO;
        }
    }
    
    _doneButton.hidden = NO;
    _selectButton.hidden = !_HWImagePickerVc.showSelectBtn;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
    if (![[HWImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
        _numberLabel.hidden = YES;
        _numberImageView.hidden = YES;
        _selectButton.hidden = YES;
        _originalPhotoButton.hidden = YES;
        _originalPhotoLabel.hidden = YES;
        _doneButton.hidden = YES;
    }
}
 */
/*
- (void)showPhotoBytes {
    [[HWImageManager manager] getPhotosBytesWithArray:@[_models[_currentIndex]] completion:^(NSString *totalBytes) {
        _originalPhotoLabel.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}
*/
@end
