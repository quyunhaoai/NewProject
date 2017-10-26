//
//  UIAlertController+Block.m
//  微信小程序
//
//  Created by hao on 17/3/15.
//  Copyright © 2017年 hao. All rights reserved.
//

#import "UIAlertController+Block.h"

@implementation UIAlertController (Block)
+(id)showAlertView:(NSString *)title message:(NSString *)message CancelTitle:(NSString *)cancel cancelColor:(NSString *)cancelColor sureTitle:(NSString *)sureTitle sureColor:(NSString *)sureColor isDisCancel:(BOOL)isshow and:(void (^)())cancle andDismissBlok:(void (^)())dismiss{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancel == nil || cancel.length == 0) {
        cancel = @"取消";
    }
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        cancle();
    }];
    [Cancel setValue:[self hexStringToColor:cancelColor] forKey:@"_titleTextColor"];
    if (isshow) {
        [alert addAction:Cancel];
    }else{
    }
    if (sureTitle !=nil && sureTitle.length >0) {
        
    }else{
        sureTitle = @"确定";
    }
   
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        dismiss();
    }];
    
    [sureAction setValue:[self hexStringToColor:sureColor] forKey:@"_titleTextColor"];
    
    [alert addAction:sureAction];

    return alert;
};
+(id)showActionsheet:(NSArray *)titles andColors:(NSArray *)itemColors and:(void(^)())cancle andDismissBlok:(void(^)(int index))dismiss{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
        for (int a = 0; a<titles.count; a ++) {
            
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[a] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@",action);
            NSLog(@"%d",a);
            dismiss(a);
        }];
        [action setValue:[self hexStringToColor: itemColors[a]] forKey:@"_titleTextColor"];
        [alertSheet addAction:action];
    }
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancle();

    
    }];
    [Cancel setValue:[self hexStringToColor:@"#000000"] forKey:@"_titleTextColor"];
    [alertSheet addAction:Cancel];
    
    
    return alertSheet;
}
#pragma mark -颜色转换-
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
