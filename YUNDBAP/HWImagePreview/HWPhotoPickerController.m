//
//  HWPhotoPickerController.m
//  HWImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "HWPhotoPickerController.h"
#import "HWImagePickerController.h"
#import "HWPhotoPreviewController.h"
#import "HWAssetCell.h"
#import "HWAssetModel.h"
#import "UIView+HWLayout.h"
#import "HWImageManager.h"
//#import "HWVideoPlayerController.h"
#import "HWGifPhotoPreviewController.h"
#import "HWLocationManager.h"

@interface HWPhotoPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate> {
    NSMutableArray *_models;
    
    UIView *_bottomToolBar;
    UIButton *_previewButton;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
    UIView *_divideLine;
    
    BOOL _shouldScrollToBottom;
    BOOL _showTakePhotoBtn;
    
    CGFloat _offsetItemCount;
}
@property CGRect previousPreheatRect;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) HWCollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@end

static CGSize AssetGridThumbnailSize;
static CGFloat itemMargin = 5;

@implementation HWPhotoPickerController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *HWBarItem, *BarItem;
        if (iOS9Later) {
            HWBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[HWImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            HWBarItem = [UIBarButtonItem appearanceWhenContainedIn:[HWImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [HWBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    _isSelectOriginalPhoto = HWImagePickerVc.isSelectOriginalPhoto;
    _shouldScrollToBottom = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _model.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:HWImagePickerVc.cancelBtnTitleStr style:UIBarButtonItemStylePlain target:HWImagePickerVc action:@selector(cancelButtonClick)];
    _showTakePhotoBtn = (([[HWImageManager manager] isCameraRollAlbum:_model.name]) && HWImagePickerVc.allowTakePicture);
    // [self resetCachedAssets];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)fetchAssetModels {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    if (_isFirstAppear) {
        [HWImagePickerVc showProgressHUD];
    }
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        if (!HWImagePickerVc.sortAscendingByModificationDate && _isFirstAppear && iOS8Later) {
            [[HWImageManager manager] getCameraRollAlbum:HWImagePickerVc.allowPickingVideo allowPickingImage:HWImagePickerVc.allowPickingImage completion:^(HWAlbumModel *model) {
                _model = model;
                _models = [NSMutableArray arrayWithArray:_model.models];
                [self initSubviews];
            }];
        } else {
            if (_showTakePhotoBtn || !iOS8Later || _isFirstAppear) {
                [[HWImageManager manager] getAssetsFromFetchResult:_model.result allowPickingVideo:HWImagePickerVc.allowPickingVideo allowPickingImage:HWImagePickerVc.allowPickingImage completion:^(NSArray<HWAssetModel *> *models) {
                    _models = [NSMutableArray arrayWithArray:models];
                    [self initSubviews];
                }];
            } else {
                _models = [NSMutableArray arrayWithArray:_model.models];
                [self initSubviews];
            }
        }
    });
}

- (void)initSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
        [HWImagePickerVc hideProgressHUD];
        
        [self checkSelectedModels];
        [self configCollectionView];
        [self configBottomToolBar];
        
        [self scrollCollectionViewToBottom];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    HWImagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configCollectionView {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[HWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin);
    
    if (_showTakePhotoBtn && HWImagePickerVc.allowTakePicture ) {
        _collectionView.contentSize = CGSizeMake(self.view.HW_width, ((_model.count + self.columnNumber) / self.columnNumber) * self.view.HW_width);
    } else {
        _collectionView.contentSize = CGSizeMake(self.view.HW_width, ((_model.count + self.columnNumber - 1) / self.columnNumber) * self.view.HW_width);
    }
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[HWAssetCell class] forCellWithReuseIdentifier:@"HWAssetCell"];
    [_collectionView registerClass:[HWAssetCameraCell class] forCellWithReuseIdentifier:@"HWAssetCameraCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = 2.0;
    if ([UIScreen mainScreen].bounds.size.width > 600) {
        scale = 1.0;
    }
    CGSize cellSize = ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    if (!_models) {
        [self fetchAssetModels];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (iOS8Later) {
        // [self updateCachedAssets];
    }
}

- (void)configBottomToolBar {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    if (!HWImagePickerVc.showSelectBtn) return;

    _bottomToolBar = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat rgb = 253 / 255.0;
    _bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];

    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_previewButton addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_previewButton setTitle:HWImagePickerVc.previewBtnTitleStr forState:UIControlStateNormal];
    [_previewButton setTitle:HWImagePickerVc.previewBtnTitleStr forState:UIControlStateDisabled];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.enabled = HWImagePickerVc.selectedModels.count;
    
    if (HWImagePickerVc.allowPickingOriginalPhoto) {
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_originalPhotoButton setTitle:HWImagePickerVc.fullImageBtnTitleStr forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:HWImagePickerVc.fullImageBtnTitleStr forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:HWImagePickerVc.photoOriginDefImageName] forState:UIControlStateNormal];
        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:HWImagePickerVc.photoOriginSelImageName] forState:UIControlStateSelected];
        _originalPhotoButton.selected = _isSelectOriginalPhoto;
        _originalPhotoButton.enabled = HWImagePickerVc.selectedModels.count > 0;
        
        _originalPhotoLabel = [[UILabel alloc] init];
        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLabel.font = [UIFont systemFontOfSize:16];
        _originalPhotoLabel.textColor = [UIColor blackColor];
        if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
    }
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:HWImagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitle:HWImagePickerVc.doneBtnTitleStr forState:UIControlStateDisabled];
    [_doneButton setTitleColor:HWImagePickerVc.oKButtonTitleColorNormal forState:UIControlStateNormal];
    [_doneButton setTitleColor:HWImagePickerVc.oKButtonTitleColorDisabled forState:UIControlStateDisabled];
    _doneButton.enabled = HWImagePickerVc.selectedModels.count || HWImagePickerVc.alwaysEnableDoneBtn;
    
    _numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedFromMyBundle:HWImagePickerVc.photoNumberIconImageName]];
    _numberImageView.hidden = HWImagePickerVc.selectedModels.count <= 0;
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",HWImagePickerVc.selectedModels.count];
    _numberLabel.hidden = HWImagePickerVc.selectedModels.count <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    _divideLine = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    _divideLine.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    
    [_bottomToolBar addSubview:_divideLine];
    [_bottomToolBar addSubview:_previewButton];
    [_bottomToolBar addSubview:_doneButton];
    [_bottomToolBar addSubview:_numberImageView];
    [_bottomToolBar addSubview:_numberLabel];
    [self.view addSubview:_bottomToolBar];
    [self.view addSubview:_originalPhotoButton];
    [_originalPhotoButton addSubview:_originalPhotoLabel];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    
    CGFloat top = 0;
    CGFloat collectionViewHeight = 0;
    CGFloat naviBarHeight = self.navigationController.navigationBar.HW_height;
    BOOL isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    if (self.navigationController.navigationBar.isTranslucent) {
        top = naviBarHeight;
        if (iOS7Later && !isStatusBarHidden) top += 20;
        collectionViewHeight = HWImagePickerVc.showSelectBtn ? self.view.HW_height - 50 - top : self.view.HW_height - top;;
    } else {
        collectionViewHeight = HWImagePickerVc.showSelectBtn ? self.view.HW_height - 50 : self.view.HW_height;
    }
    _collectionView.frame = CGRectMake(0, top, self.view.HW_width, collectionViewHeight);
    CGFloat itemWH = (self.view.HW_width - (self.columnNumber + 1) * itemMargin) / self.columnNumber;
    _layout.itemSize = CGSizeMake(itemWH, itemWH);
    _layout.minimumInteritemSpacing = itemMargin;
    _layout.minimumLineSpacing = itemMargin;
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetY = _offsetItemCount * (_layout.itemSize.height + _layout.minimumLineSpacing);
        [_collectionView setContentOffset:CGPointMake(0, offsetY)];
    }
    
    CGFloat yOffset = 0;
    if (!self.navigationController.navigationBar.isHidden) {
        yOffset = self.view.HW_height - 50;
    } else {
        CGFloat navigationHeight = naviBarHeight;
        if (iOS7Later) navigationHeight += 20;
        yOffset = self.view.HW_height - 50 - navigationHeight;
    }
    _bottomToolBar.frame = CGRectMake(0, yOffset, self.view.HW_width, 50);
    CGFloat previewWidth = [HWImagePickerVc.previewBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width + 2;
    if (!HWImagePickerVc.allowPreview) {
        previewWidth = 0.0;
    }
    _previewButton.frame = CGRectMake(10, 3, previewWidth, 44);
    _previewButton.HW_width = !HWImagePickerVc.showSelectBtn ? 0 : previewWidth;
    if (HWImagePickerVc.allowPickingOriginalPhoto) {
        CGFloat fullImageWidth = [HWImagePickerVc.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
        _originalPhotoButton.frame = CGRectMake(CGRectGetMaxX(_previewButton.frame), self.view.HW_height - 50, fullImageWidth + 56, 50);
        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 46, 0, 80, 50);
    }
    _doneButton.frame = CGRectMake(self.view.HW_width - 44 - 12, 3, 44, 44);
    _numberImageView.frame = CGRectMake(self.view.HW_width - 56 - 28, 10, 30, 30);
    _numberLabel.frame = _numberImageView.frame;
    _divideLine.frame = CGRectMake(0, 0, self.view.HW_width, 1);
    
    [HWImageManager manager].columnNumber = [HWImageManager manager].columnNumber;
    [self.collectionView reloadData];
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.y / (_layout.itemSize.height + _layout.minimumLineSpacing);
}

#pragma mark - Click Event

- (void)previewButtonClick {
    HWPhotoPreviewController *photoPreviewVc = [[HWPhotoPreviewController alloc] init];
    [self pushPhotoPrevireViewController:photoPreviewVc];
}

- (void)originalPhotoButtonClick {
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
}

- (void)doneButtonClick {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    // 1.6.8 判断是否满足最小必选张数的限制
    if (HWImagePickerVc.minImagesCount && HWImagePickerVc.selectedModels.count < HWImagePickerVc.minImagesCount) {
        NSString *title = [NSString stringWithFormat:[NSBundle HW_localizedStringForKey:@"Select a minimum of %zd photos"], HWImagePickerVc.minImagesCount];
        [HWImagePickerVc showAlertWithTitle:title];
        return;
    }
    
    [HWImagePickerVc showProgressHUD];
    NSMutableArray *photos = [NSMutableArray array];
    NSMutableArray *assets = [NSMutableArray array];
    NSMutableArray *infoArr = [NSMutableArray array];
    for (NSInteger i = 0; i < HWImagePickerVc.selectedModels.count; i++) { [photos addObject:@1];[assets addObject:@1];[infoArr addObject:@1]; }
    
    __block BOOL havenotShowAlert = YES;
    [HWImageManager manager].shouldFixOrientation = YES;
    __block id alertView;
    for (NSInteger i = 0; i < HWImagePickerVc.selectedModels.count; i++) {
        HWAssetModel *model = HWImagePickerVc.selectedModels[i];
        [[HWImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (isDegraded) return;
            if (photo) {
                photo = [self scaleImage:photo toSize:CGSizeMake(HWImagePickerVc.photoWidth, (int)(HWImagePickerVc.photoWidth * photo.size.height / photo.size.width))];
                [photos replaceObjectAtIndex:i withObject:photo];
            }
            if (info)  [infoArr replaceObjectAtIndex:i withObject:info];
            [assets replaceObjectAtIndex:i withObject:model.asset];
            
            for (id item in photos) { if ([item isKindOfClass:[NSNumber class]]) return; }
            
            if (havenotShowAlert) {
                [HWImagePickerVc hideAlertView:alertView];
                [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
            }
        } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            // 如果图片正在从iCloud同步中,提醒用户
            if (progress < 1 && havenotShowAlert && !alertView) {
                [HWImagePickerVc hideProgressHUD];
                alertView = [HWImagePickerVc showAlertWithTitle:[NSBundle HW_localizedStringForKey:@"Synchronizing photos from iCloud"]];
                havenotShowAlert = NO;
                return;
            }
            if (progress >= 1) {
                havenotShowAlert = YES;
            }
        } networkAccessAllowed:YES];
    }
    if (HWImagePickerVc.selectedModels.count <= 0) {
        [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
    }
}

- (void)didGetAllPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    [HWImagePickerVc hideProgressHUD];
    
    if (HWImagePickerVc.autoDismiss) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr];
        }];
    } else {
        [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr];
    }
}

- (void)callDelegateMethodWithPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    if ([HWImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
        [HWImagePickerVc.pickerDelegate imagePickerController:HWImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto];
    }
    if ([HWImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
        [HWImagePickerVc.pickerDelegate imagePickerController:HWImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto infos:infoArr];
    }
    if (HWImagePickerVc.didFinishPickingPhotosHandle) {
        HWImagePickerVc.didFinishPickingPhotosHandle(photos,assets,_isSelectOriginalPhoto);
    }
    if (HWImagePickerVc.didFinishPickingPhotosWithInfosHandle) {
        HWImagePickerVc.didFinishPickingPhotosWithInfosHandle(photos,assets,_isSelectOriginalPhoto,infoArr);
    }
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_showTakePhotoBtn) {
        HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
        if (HWImagePickerVc.allowPickingImage && HWImagePickerVc.allowTakePicture) {
            return _models.count + 1;
        }
    }
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // the cell lead to take a picture / 去拍照的cell
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    if (((HWImagePickerVc.sortAscendingByModificationDate && indexPath.row >= _models.count) || (!HWImagePickerVc.sortAscendingByModificationDate && indexPath.row == 0)) && _showTakePhotoBtn) {
        HWAssetCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWAssetCameraCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamedFromMyBundle:HWImagePickerVc.takePictureImageName];
        return cell;
    }
    // the cell dipaly photo or video / 展示照片或视频的cell
    HWAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWAssetCell" forIndexPath:indexPath];
    cell.allowPickingMultipleVideo = HWImagePickerVc.allowPickingMultipleVideo;
    cell.photoDefImageName = HWImagePickerVc.photoDefImageName;
    cell.photoSelImageName = HWImagePickerVc.photoSelImageName;
    HWAssetModel *model;
    if (HWImagePickerVc.sortAscendingByModificationDate || !_showTakePhotoBtn) {
        model = _models[indexPath.row];
    } else {
        model = _models[indexPath.row - 1];
    }
    cell.allowPickingGif = HWImagePickerVc.allowPickingGif;
    cell.model = model;
    cell.showSelectBtn = HWImagePickerVc.showSelectBtn;
    if (!HWImagePickerVc.allowPreview) {
        cell.selectPhotoButton.frame = cell.bounds;
    }
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    __weak typeof(_numberImageView.layer) weakLayer = _numberImageView.layer;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)weakSelf.navigationController;
        // 1. cancel select / 取消选择
        if (isSelected) {
            weakCell.selectPhotoButton.selected = NO;
            model.isSelected = NO;
            NSArray *selectedModels = [NSArray arrayWithArray:HWImagePickerVc.selectedModels];
            for (HWAssetModel *model_item in selectedModels) {
                if ([[[HWImageManager manager] getAssetIdentifier:model.asset] isEqualToString:[[HWImageManager manager] getAssetIdentifier:model_item.asset]]) {
                    [HWImagePickerVc.selectedModels removeObject:model_item];
                    break;
                }
            }
            [weakSelf refreshBottomToolBarStatus];
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            if (HWImagePickerVc.selectedModels.count < HWImagePickerVc.maxImagesCount) {
                weakCell.selectPhotoButton.selected = YES;
                model.isSelected = YES;
                [HWImagePickerVc.selectedModels addObject:model];
                [weakSelf refreshBottomToolBarStatus];
            } else {
                NSString *title = [NSString stringWithFormat:[NSBundle HW_localizedStringForKey:@"Select a maximum of %zd photos"], HWImagePickerVc.maxImagesCount];
                [HWImagePickerVc showAlertWithTitle:title];
            }
        }
        [UIView showOscillatoryAnimationWithLayer:weakLayer type:HWOscillatoryAnimationToSmaller];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // take a photo / 去拍照
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    if (((HWImagePickerVc.sortAscendingByModificationDate && indexPath.row >= _models.count) || (!HWImagePickerVc.sortAscendingByModificationDate && indexPath.row == 0)) && _showTakePhotoBtn)  {
        [self takePhoto]; return;
    }
    // preview phote or video / 预览照片或视频
    NSInteger index = indexPath.row;
    if (!HWImagePickerVc.sortAscendingByModificationDate && _showTakePhotoBtn) {
        index = indexPath.row - 1;
    }
    HWAssetModel *model = _models[index];
    if (model.type == HWAssetModelMediaTypeVideo && !HWImagePickerVc.allowPickingMultipleVideo) {
        if (HWImagePickerVc.selectedModels.count > 0) {
            HWImagePickerController *imagePickerVc = (HWImagePickerController *)self.navigationController;
            [imagePickerVc showAlertWithTitle:[NSBundle HW_localizedStringForKey:@"Can not choose both video and photo"]];
        } else {
//            HWVideoPlayerController *videoPlayerVc = [[HWVideoPlayerController alloc] init];
//            videoPlayerVc.model = model;
//            [self.navigationController pushViewController:videoPlayerVc animated:YES];
        }
    } else if (model.type == HWAssetModelMediaTypePhotoGif && HWImagePickerVc.allowPickingGif && !HWImagePickerVc.allowPickingMultipleVideo) {
        if (HWImagePickerVc.selectedModels.count > 0) {
            HWImagePickerController *imagePickerVc = (HWImagePickerController *)self.navigationController;
            [imagePickerVc showAlertWithTitle:[NSBundle HW_localizedStringForKey:@"Can not choose both photo and GIF"]];
        } else {
            HWGifPhotoPreviewController *gifPreviewVc = [[HWGifPhotoPreviewController alloc] init];
            gifPreviewVc.model = model;
            [self.navigationController pushViewController:gifPreviewVc animated:YES];
        }
    } else {
        
        NSMutableArray *amodels = [NSMutableArray arrayWithArray:_model.models];
        HWAssetModel *ni = [[HWAssetModel alloc] init];
        ni.imgUrl = @"http://upload-images.jianshu.io/upload_images/1295463-5e8b998e4291d836.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
        [amodels addObject:ni];
        
        HWAssetModel *ni2 = [[HWAssetModel alloc] init];
        ni.imgUrl = @"https://i.stack.imgur.com/MIO5U.png";
        [amodels addObject:ni2];
        
        
        HWPhotoPreviewController *photoPreviewVc = [[HWPhotoPreviewController alloc] init];
        photoPreviewVc.currentIndex = index;
        photoPreviewVc.models = amodels;
        [self pushPhotoPrevireViewController:photoPreviewVc];

    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (iOS8Later) {
        // [self updateCachedAssets];
    }
}

#pragma mark - Private Method

/// 拍照按钮点击事件
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) && iOS7Later) {
        // 无权限 做一个友好的提示
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        NSString *message = [NSString stringWithFormat:[NSBundle HW_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSBundle HW_localizedStringForKey:@"Can not use camera"] message:message delegate:self cancelButtonTitle:[NSBundle HW_localizedStringForKey:@"Cancel"] otherButtonTitles:[NSBundle HW_localizedStringForKey:@"Setting"], nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self pushImagePickerController];
                    });
                }
            }];
        } else {
            [self pushImagePickerController];
        }
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[HWLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)refreshBottomToolBarStatus {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    
    _previewButton.enabled = HWImagePickerVc.selectedModels.count > 0;
    _doneButton.enabled = HWImagePickerVc.selectedModels.count > 0 || HWImagePickerVc.alwaysEnableDoneBtn;
    
    _numberImageView.hidden = HWImagePickerVc.selectedModels.count <= 0;
    _numberLabel.hidden = HWImagePickerVc.selectedModels.count <= 0;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",HWImagePickerVc.selectedModels.count];
    
    _originalPhotoButton.enabled = HWImagePickerVc.selectedModels.count > 0;
    _originalPhotoButton.selected = (_isSelectOriginalPhoto && _originalPhotoButton.enabled);
    _originalPhotoLabel.hidden = (!_originalPhotoButton.isSelected);
    if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
}

- (void)pushPhotoPrevireViewController:(HWPhotoPreviewController *)photoPreviewVc {
    __weak typeof(self) weakSelf = self;
    photoPreviewVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    [photoPreviewVc setBackButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [weakSelf.collectionView reloadData];
        [weakSelf refreshBottomToolBarStatus];
    }];
    [photoPreviewVc setDoneButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [weakSelf doneButtonClick];
    }];
    [photoPreviewVc setDoneButtonClickBlockCropMode:^(UIImage *cropedImage, id asset) {
        [weakSelf didGetAllPhotos:@[cropedImage] assets:@[asset] infoArr:nil];
    }];
    [self.navigationController pushViewController:photoPreviewVc animated:YES];
}

- (void)getSelectedPhotoBytes {
    HWImagePickerController *imagePickerVc = (HWImagePickerController *)self.navigationController;
    [[HWImageManager manager] getPhotosBytesWithArray:imagePickerVc.selectedModels completion:^(NSString *totalBytes) {
        _originalPhotoLabel.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}

/// Scale image / 缩放图片
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width < size.width) {
        return image;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)scrollCollectionViewToBottom {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    if (_shouldScrollToBottom && _models.count > 0) {
        NSInteger item = 0;
        if (HWImagePickerVc.sortAscendingByModificationDate) {
            item = _models.count - 1;
            if (_showTakePhotoBtn) {
                HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
                if (HWImagePickerVc.allowPickingImage && HWImagePickerVc.allowTakePicture) {
                    item += 1;
                }
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            _shouldScrollToBottom = NO;
        });
    }
}

- (void)checkSelectedModels {
    for (HWAssetModel *model in _models) {
        model.isSelected = NO;
        NSMutableArray *selectedAssets = [NSMutableArray array];
        HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
        for (HWAssetModel *model in HWImagePickerVc.selectedModels) {
            [selectedAssets addObject:model.asset];
        }
        if ([[HWImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            model.isSelected = YES;
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        HWImagePickerController *imagePickerVc = (HWImagePickerController *)self.navigationController;
        [imagePickerVc showProgressHUD];
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            [[HWImageManager manager] savePhotoWithImage:photo location:self.location completion:^(NSError *error){
                if (!error) {
                    [self reloadPhotoArray];
                }
            }];
            self.location = nil;
        }
    }
}

- (void)reloadPhotoArray {
    HWImagePickerController *HWImagePickerVc = (HWImagePickerController *)self.navigationController;
    [[HWImageManager manager] getCameraRollAlbum:HWImagePickerVc.allowPickingVideo allowPickingImage:HWImagePickerVc.allowPickingImage completion:^(HWAlbumModel *model) {
        _model = model;
        [[HWImageManager manager] getAssetsFromFetchResult:_model.result allowPickingVideo:HWImagePickerVc.allowPickingVideo allowPickingImage:HWImagePickerVc.allowPickingImage completion:^(NSArray<HWAssetModel *> *models) {
            [HWImagePickerVc hideProgressHUD];
            
            HWAssetModel *assetModel;
            if (HWImagePickerVc.sortAscendingByModificationDate) {
                assetModel = [models lastObject];
                [_models addObject:assetModel];
            } else {
                assetModel = [models firstObject];
                [_models insertObject:assetModel atIndex:0];
            }
            
            if (HWImagePickerVc.maxImagesCount <= 1) {
                if (HWImagePickerVc.allowCrop) {
                    HWPhotoPreviewController *photoPreviewVc = [[HWPhotoPreviewController alloc] init];
                    if (HWImagePickerVc.sortAscendingByModificationDate) {
                        photoPreviewVc.currentIndex = _models.count - 1;
                    } else {
                        photoPreviewVc.currentIndex = 0;
                    }
                    photoPreviewVc.models = _models;
                    [self pushPhotoPrevireViewController:photoPreviewVc];
                } else {
                    [HWImagePickerVc.selectedModels addObject:assetModel];
                    [self doneButtonClick];
                }
                return;
            }
            
            if (HWImagePickerVc.selectedModels.count < HWImagePickerVc.maxImagesCount) {
                assetModel.isSelected = YES;
                [HWImagePickerVc.selectedModels addObject:assetModel];
                [self refreshBottomToolBarStatus];
            }
            [_collectionView reloadData];
            
            _shouldScrollToBottom = YES;
            [self scrollCollectionViewToBottom];
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [[HWImageManager manager].cachingImageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = _collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(_collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [[HWImageManager manager].cachingImageManager startCachingImagesForAssets:assetsToStartCaching
                                                                       targetSize:AssetGridThumbnailSize
                                                                      contentMode:PHImageContentModeAspectFill
                                                                          options:nil];
        [[HWImageManager manager].cachingImageManager stopCachingImagesForAssets:assetsToStopCaching
                                                                      targetSize:AssetGridThumbnailSize
                                                                     contentMode:PHImageContentModeAspectFill
                                                                         options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item < _models.count) {
            HWAssetModel *model = _models[indexPath.item];
            [assets addObject:model.asset];
        }
    }
    
    return assets;
}

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [_collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
#pragma clang diagnostic pop

@end



@implementation HWCollectionView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
