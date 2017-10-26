//
//  HWAssetCell.h
//  HWImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    HWAssetCellTypePhoto = 0,
    HWAssetCellTypeLivePhoto,
    HWAssetCellTypePhotoGif,
    HWAssetCellTypeVideo,
    HWAssetCellTypeAudio,
} HWAssetCellType;

@class HWAssetModel;
@interface HWAssetCell : UICollectionViewCell

@property (weak, nonatomic) UIButton *selectPhotoButton;
@property (nonatomic, strong) HWAssetModel *model;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, assign) HWAssetCellType type;
@property (nonatomic, assign) BOOL allowPickingGif;
@property (nonatomic, assign) BOOL allowPickingMultipleVideo;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

@property (nonatomic, copy) NSString *photoSelImageName;
@property (nonatomic, copy) NSString *photoDefImageName;

@property (nonatomic, assign) BOOL showSelectBtn;

@end


@class HWAlbumModel;

@interface HWAlbumCell : UITableViewCell

@property (nonatomic, strong) HWAlbumModel *model;
@property (weak, nonatomic) UIButton *selectedCountButton;

@end


@interface HWAssetCameraCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end
