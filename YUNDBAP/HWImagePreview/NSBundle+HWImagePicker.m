//
//  NSBundle+HWImagePicker.m
//  HWImagePickerController
//
//  Created by 谭真 on 16/08/18.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "NSBundle+HWImagePicker.h"
#import "HWImagePickerController.h"

@implementation NSBundle (HWImagePicker)

+ (NSBundle *)HW_imagePickerBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[HWImagePickerController class]];
    NSURL *url = [bundle URLForResource:@"HWImagePickerController" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

+ (NSString *)HW_localizedStringForKey:(NSString *)key {
    return [self HW_localizedStringForKey:key value:@""];
}

+ (NSString *)HW_localizedStringForKey:(NSString *)key value:(NSString *)value {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
            language = @"zh-Hans";
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle HW_imagePickerBundle] pathForResource:language ofType:@"lproj"]];
    }
    NSString *value1 = [bundle localizedStringForKey:key value:value table:nil];
    return value1;
}
@end
