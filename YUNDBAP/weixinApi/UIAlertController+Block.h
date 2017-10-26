//
//  UIAlertController+Block.h
//  微信小程序
//
//  Created by hao on 17/3/15.
//  Copyright © 2017年 hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Block)
+(id)showAlertView:(NSString *)title message:(NSString *)message CancelTitle:(NSString *)cancel cancelColor:(NSString *)cancelColor sureTitle:(NSString *)sureTitle sureColor:(NSString *)sureColor isDisCancel:(BOOL)isshow and:(void(^)())cancle andDismissBlok:(void(^)())dismiss;

+(id)showActionsheet:(NSArray *)titles andColors:(NSArray *)itemColors and:(void(^)())cancle andDismissBlok:(void(^)(int index))dismiss;
@end
