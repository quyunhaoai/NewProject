//
//  Umengtuis.h
//  Youmengmessage
//
//  Created by hao on 15/12/8.
//  Copyright © 2015年 hao. All rights reserved.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UMessage.h"
@interface Umengtuis : NSObject<UIAlertViewDelegate>
@property (strong, nonatomic) NSDictionary *userInfo;

+(Umengtuis *)shared;
+(void)initRegit:(NSString *)appkey andlaunchOptins:(NSDictionary *)launchOptions;
+(void)registerDeviceToken:(NSData *)deviceToken;
+(void)unregisterRemoteNotifications;
+(void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
+(void)setAutoAlertView:(BOOL)shouldShow;
+(void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo;



@end
