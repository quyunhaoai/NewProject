//
//  Umengtuis.m
//  Youmengmessage
//
//  Created by hao on 15/12/8.
//  Copyright © 2015年 hao. All rights reserved.
//
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000
#import "Umengtuis.h"

@implementation Umengtuis
+(Umengtuis *)shared
{
    static Umengtuis *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,  ^{
        if (!sharedObject) {
            sharedObject = [[Umengtuis alloc]init];
            
        }
    });
    return sharedObject;
}
+(void)initRegit:(NSString *)appkey andlaunchOptins:(NSDictionary *)launchOptions
{
    //set AppKey and AppSecret
    
    [UMessage startWithAppkey:appkey launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
    //register remoteNotification types （iOS 8.0及其以上版本）
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"Accept";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"Reject";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    categorys.identifier = @"category1";//这组动作的唯一标示
    [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    
    UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                 categories:[NSSet setWithObject:categorys]];
    [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    
} else{
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
}
#else
//register remoteNotification types (iOS 8.0以下)
[UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
 |UIRemoteNotificationTypeSound
 |UIRemoteNotificationTypeAlert];

#endif
//for log
[UMessage setLogEnabled:YES];
}
+(void)registerDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}
+(void)unregisterRemoteNotifications
{
    [UMessage unregisterForRemoteNotifications];
}
+(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}
+(void)setAutoAlertView:(BOOL)shouldShow
{
    [UMessage setAutoAlert:shouldShow];
}
+(void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo
{
    [Umengtuis shared].userInfo = userInfo;

        dispatch_async(dispatch_get_main_queue(), ^{
            [UMessage setAutoAlert:NO];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                              message:userInfo[@"aps"][@"alert"]
                                                             delegate:[Umengtuis shared]
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
            [alertView show];
        });
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

        [UMessage sendClickReportForRemoteNotification:[Umengtuis shared].userInfo];
    for (NSString *str in [Umengtuis shared].userInfo) {
        if ([str isEqualToString:@"url"]) {
            NSDictionary *dict = [Umengtuis shared].userInfo;
            NSString *url = dict[@"url"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"tuisongWebUrl" object:nil userInfo:@{@"url":url}];
        }
    }
}

@end
