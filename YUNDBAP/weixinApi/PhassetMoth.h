//
//  PhassetMoth.h
//  微信小程序
//
//  Created by hao on 17/3/27.
//  Copyright © 2017年 hao. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Foundation/Foundation.h>

@interface PhassetMoth : NSObject
typedef void(^Result)(NSData *fileData, NSString *fileName);
typedef void(^ResultPath)(NSString *filePath, NSString *fileName);
+ (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(Result)result;
@end
