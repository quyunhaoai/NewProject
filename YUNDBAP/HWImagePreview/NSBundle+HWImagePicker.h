//
//  NSBundle+HWImagePicker.h
//  HWImagePickerController
//
//  Created by 谭真 on 16/08/18.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (HWImagePicker)

+ (NSBundle *)HW_imagePickerBundle;

+ (NSString *)HW_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)HW_localizedStringForKey:(NSString *)key;

@end

