//
//  HWPhotoPickerController.h
//  HWImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWAlbumModel;
@interface HWPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) HWAlbumModel *model;

@end


@interface HWCollectionView : UICollectionView

@end
