//
//  GetImage.m
//  UUMATCH
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 weiyajiang. All rights reserved.
//

#import "GetImage.h"

static GetImage *getImage = nil;

@interface GetImage()
@property (nonatomic, assign) BOOL isIcon;
@property (nonatomic) int duration;
@end

@implementation GetImage
typedef void(^Results) (NSString *fileName);

//单例方法
+ (GetImage *)shareUploadImage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getImage = [[GetImage alloc] init];
    });
    return getImage;
}
//弹出选项的方法
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC delegate:(id<GetImageDelegate>)aDelegate andCount:(NSUInteger)count size:(NSArray *)size sourceType:(NSArray *)sourceType
{
//    if (_fatherViewController) {
//        [_fatherViewController dismissViewControllerAnimated:YES completion:nil];
//    }
    getImage.uploadImageDelegate = aDelegate;
    _fatherViewController = fatherVC;
    self.count = count;
    self.sizeArray = size;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        }];

    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotos];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    if ([sourceType containsObject:@"camera"]) {
    if ([sourceType[0] isEqualToString:@"camera"]||[sourceType[1] isEqualToString:@"camera"]) {
        [alert addAction:camera];
    }
    }
//    if ([sourceType containsObject:@"album"]) {
//    if ([sourceType[0] isEqualToString:@"album"]||[sourceType[1] isEqualToString:@"album"]) {
    [alert addAction:photos];
//    }
//    }

    [alert addAction:cancel];
    
    [fatherVC presentViewController:alert animated:YES completion:nil];
        
//    });

}
#pragma mark - 相机中选择
-(void)openCamera
{
             
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 已经开启授权，可继续
            UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
            imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePC.allowsEditing = YES;
            imagePC.delegate = [GetImage shareUploadImage];
            [_fatherViewController presentViewController:imagePC animated:YES completion:nil];
        } else {
//            [MBProgressHUD showError:@"没有相机" toView:nil];
        }
}

//图片库中查找图片
-(void)openPhotos
{
       if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
           TZImagePickerController *imageVc =[[TZImagePickerController alloc]initWithMaxImagesCount:_count delegate:self];
//           if ([self.sizeArray[0] isEqualToString:@"original"]||[self.sizeArray[1] isEqualToString:@"original"]) {
              imageVc.allowPickingOriginalPhoto = NO;
//           }else{
//               
//           }
           [self.sizeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               if ([obj isEqualToString:@"original"]) {
                   imageVc.allowPickingOriginalPhoto = YES;
               }
           }];
           imageVc.allowPreview = NO;
           imageVc.allowPickingVideo = NO;
           [imageVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSucces) {
               NSLog(@"%@%@%d",photos,assets,isSucces);
//               self.resault(assets);
           }];
           [imageVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *a, NSArray *b, BOOL isok, NSArray<NSDictionary *> *c) {
               NSLog(@"%@%@%@%d",a,b,c,isok);
               NSMutableDictionary *dict = [NSMutableDictionary dictionary];
               if (c.count == 1) {
                   NSURL *PhotofileUrl=c[0][@"PHImageFileURLKey"];
                   NSString *path = [PhotofileUrl path];
                   [dict setValue:path forKey:@"tempFilePaths"];
               }else if (c.count > 1){
                   NSMutableArray *files= [NSMutableArray arrayWithCapacity:9];
                   [c enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       [files addObject:[obj[@"PHImageFileURLKey"] path]];
                   }];
                   NSLog(@"%@",files);

                   [dict setValue:files forKey:@"tempFilePaths"];
               }
               self.resault(dict);

           }];
            [imageVc setDidFinishPickingGifImageHandle:^(UIImage *image, id data) {
               NSLog(@"%@---%@",image,data);
//               self.resault(data);
           }];

           [_fatherViewController presentViewController:imageVc animated:YES completion:^{
               NSLog(@"跳转图像选择器！");
               
           }];
    } else {
//        [MBProgressHUD showError:@"没有相机" toView:nil];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);

    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
         //如果是图片
        UIImageView *imageView;
        imageView.image = info[UIImagePickerControllerEditedImage];
         //压缩图片
         NSData *fileData = UIImageJPEGRepresentation(imageView.image, 1.0);
         //保存图片至相册
         UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
         //上传图片
//         [self uploadImageWithData:fileData];
        NSString *temPath = [[Filemanager shareFileManger] saveFile:@"photos.png"];
        BOOL issuccess = [fileData writeToFile:temPath atomically:YES];
        if (issuccess) {
            
        }
//        self.resaultStr(temPath);
    }else{

        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //播放视频
        //        _moviePlayer.contentURL = url;
        //        [_moviePlayer play];
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
//        [GetImage shareUploadImage].resaultStr(urlStr);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [self getVideoThumbnailWithFilePath:urlStr];

        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
//        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];

        NSUInteger duration =CMTimeGetSeconds(avAsset.duration);
        CGFloat size =videoData.length;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
        [dict setValue:urlStr forKey:@"tempFilePath"];
        [dict setValue:[NSNumber numberWithFloat:size] forKey:@"size"];
        [dict setValue:[NSNumber numberWithFloat:image.size.height] forKey:@"height"];
        [dict setValue:[NSNumber numberWithFloat:image.size.width] forKey:@"width"];
        [dict setValue:[NSNumber numberWithInteger:duration] forKey:@"duration"];
        NSLog(@"info:%@",dict);
        
        self.resault(dict);
    
        //视频上传

    }

}
- (UIImage *)getVideoThumbnailWithFilePath:(NSString *)filePath
{
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    moviePlayer.shouldAutoplay = NO;
    UIImage *image = [moviePlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    return image;
}
-(void)showActionSheetInVideoViewController:(UIViewController *)fatherVC delegate:(id<GetImageDelegate>)aDelegate sourceType:(NSArray *)sourceType camera:(NSArray *)camera maxDuration:(int)duration{
    _fatherViewController = fatherVC;
    self.uploadImageDelegate = aDelegate;
    _duration = duration;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotosVideo];
    }];
    UIAlertAction *cameras = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openVideo];
    }];
    if ([sourceType containsObject:@"camera"]) {
        if ([sourceType[0] isEqualToString:@"camera"]||[sourceType[1] isEqualToString:@"camera"]) {
            [alert addAction:cameras];
        }
    }
    if ([sourceType containsObject:@"album"]) {
        if ([sourceType[0] isEqualToString:@"album"]||[sourceType[1] isEqualToString:@"album"]) {
            [alert addAction:photos];
        }
    }

    [alert addAction:cancel];
    
    [fatherVC presentViewController:alert animated:YES completion:nil];
}
-(void)openPhotosVideo{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        TZImagePickerController *imageVc = [[TZImagePickerController alloc]initWithMaxImagesCount:_count delegate:self];
        imageVc.allowPickingOriginalPhoto = NO;
        imageVc.allowPreview = NO;
        imageVc.allowPickingImage = NO;
        [imageVc setDidFinishPickingVideoHandle:^(UIImage *image , id data) {
            PHAsset *asset = (PHAsset *)data;
            NSLog(@"%@---%@",image,data);
            [PhassetMoth getVideoFromPHAsset:asset Complete:^(NSData *fileData, NSString *fileName) {
                _videoData = fileData;
                _filePath = fileName;
            }];
            NSUInteger duration =asset.duration;
            CGFloat size =_videoData.length;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
            [dict setValue:_filePath forKey:@"tempFilePath"];
            [dict setValue:[NSNumber numberWithFloat:size] forKey:@"size"];
            [dict setValue:[NSNumber numberWithFloat:image.size.height] forKey:@"height"];
            [dict setValue:[NSNumber numberWithFloat:image.size.width] forKey:@"width"];
            [dict setValue:[NSNumber numberWithInteger:duration] forKey:@"duration"];
            NSLog(@"info:%@",dict);

            self.resault(dict);
        }];

        [_fatherViewController presentViewController:imageVc animated:YES completion:^{
            NSLog(@"跳转图像选择器！");
            
        }];
    }
}
-(void)openVideo{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 已经开启授权，可继续
        UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
        imagePC.videoMaximumDuration = _duration;
        imagePC.mediaTypes = @[(NSString *)kUTTypeMovie];
        imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePC.allowsEditing = YES;
        imagePC.delegate = [GetImage shareUploadImage];
        imagePC.videoQuality = UIImagePickerControllerQualityTypeHigh;
//        [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceRear];
        //设置摄像头模式（拍照，录制视频）为录像模式
        imagePC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        [_fatherViewController presentViewController:imagePC animated:YES completion:nil];
    } else {
//        [MBProgressHUD showError:@"没有相机" toView:nil];
    }
}
#pragma pickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消选择！");
   [picker dismissViewControllerAnimated:YES completion:^{
       
   }];
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    NSLog(@"图片保存成功%@",image);

}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功%@",videoPath);
        NSLog(@"%@",[videoPath class]);
        
//        NSDictionary *dict = @{videoPath:@"TemFilePath"};
//        NSLog(@"%@",dict);
//        NSString *json = [self DataTOjsonString:dict];
//        _resaultStr(json);
    }
}
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return jsonString;
}

@end
