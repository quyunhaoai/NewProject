//
//  GetImage.h
//  UUMATCH
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 weiyajiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"
//#import "MBProgressHUD+Add.h"
#import "TZVideoPlayerController.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "PhassetMoth.h"
#import <MobileCoreServices/MobileCoreServices.h>
//#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Filemanager.h"

//把单例方法定义为宏，使用起来更方便
#define GETIMAGE [GetImage shareUploadImage]

//代理
@protocol GetImageDelegate <NSObject>

@optional
//选取的图片上传到服务器
-(void)getImageToActionWithImage:(UIImage *)image;
-(void)getimageInfoDiction:(NSDictionary *)info;
@end



@interface GetImage : NSObject<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
{
   UIViewController *_fatherViewController;
}
@property (nonatomic, strong) id <GetImageDelegate> uploadImageDelegate;
@property (nonatomic) NSUInteger count;
@property (nonatomic,strong)NSData *videoData;
@property (nonatomic,strong)NSString *filePath;
@property (nonatomic,copy) void (^resault)(NSDictionary* objct);
@property (nonatomic,copy) void (^resaultStr)(NSString* objct);
@property (nonatomic,copy) NSArray *sizeArray;
//单例方法
+ (GetImage *)shareUploadImage;
//弹出选项的方法
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC delegate:(id<GetImageDelegate>)aDelegate andCount:(NSUInteger)count;
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC delegate:(id<GetImageDelegate>)aDelegate andCount:(NSUInteger)count size:(NSArray *)size sourceType:(NSArray *)sourceType;
- (void)showActionSheetInVideoViewController:(UIViewController *)fatherVC delegate:(id<GetImageDelegate>)aDelegate sourceType:(NSArray *)sourceType camera:(NSArray *)camera maxDuration:(int)duration;

@end
