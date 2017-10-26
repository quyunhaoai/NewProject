//
//  GeTuiTool.m
//  CloudApp
//
//  Created by 9vs on 15/2/2.
//
//

#import "GeTuiTool.h"
#import "StringsXML.h"
#import "UIAlertView+Blocks.h"
#import "HwTwoPageViewController.h"
#import "AFHTTPRequestOperationManager.h"
#define kAppId           @"THezCHVjWx92F3PGH47YQ5"
#define kAppKey          @"jGjnaRQlSJ8skGddxTkJU4"
#define kAppSecret       @"XY4932G7abA4BdmBszNGU8"


@implementation GeTuiTool

+ (GeTuiTool *)shareTool {
    static GeTuiTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[GeTuiTool alloc] init];
    });
    return tool;
}

- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}
- (void)clearbadgeNumber {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)initGeTui {
    [self startSdk];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    StringsXmlBase *xBase = [StringsXML getStringXmlBase];
    NSArray* GTArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",xBase.appsid], nil];
    [self setTags:GTArray error:nil];
}

- (void)startSdk {
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    StringsXmlBase *sBase = [StringsXML getStringXmlBase];
    [self startSdkWith:sBase.appID appKey:sBase.appKey appSecret:sBase.appSecret];
//    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {
            
        } else {
            _sdkStatus = SdkStatusStarting;
        }
        
     
    }
}
- (void)registerDevice:(NSString *)deviceToken {
    if (_gexinPusher) {
        [self.gexinPusher registerDeviceToken:deviceToken];
    }
}


- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];

        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        

        _clientId = nil;
        
    }
    self.appBecome = NO;
}
- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Waring", nil) message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"submit", nil), nil];
        [alertView show];
        return NO;
    }
    return YES;
}
- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [_gexinPusher setTags:aTags];
}
- (void)bindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher unbindAlias:aAlias];
}
#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    _clientId = [clientId copy];
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"MYCLIENTID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NSTimer scheduledTimerWithTimeInterval:13.f target:self selector:@selector(appShowBecome) userInfo:nil repeats:NO];
    
    [self PushMsgConfig:@""];
    //    [self stopSdk];
}
- (void)PushMsgConfig:(NSString *)username

{
    NSLog(@"%@", username);
    BOOL isSubmit = [[NSUserDefaults standardUserDefaults] boolForKey:@"SubmitClient"];
    if (isSubmit) {
        return;
    }
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://pushios.ydbimg.com/rest/weblsq/1.0/EditGetuiUserRelationsInfo.aspx"];
    NSString *clientIdStr = nil;
   
    clientIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MYCLIENTID"];
    if (clientIdStr.length < 5) {
        return;
    }
    NSMutableDictionary *stringDic = [[StringsXML shareStringsXML] jiexiStringsXML:@"strings"];
    StringsXmlBase *base = [StringsXmlBase modelObjectWithDictionary:stringDic];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"clientid":clientIdStr,@"appid":base.appsid,@"themename":@"newcloudapp",@"username":username};
    
    [manager.requestSerializer setValue:@"basic d2VibHNxOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON--success: %@", responseObject);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SubmitClient"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON--error: %@", error);
    }];
    
    
}
- (void)appShowBecome {
    self.appBecome = YES;
}
- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息

    _payloadId = [payloadId copy];
    
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPayloadIndex, [NSDate date], payloadMsg];
    NSLog(@"====%@",record);
    
    
//    NSError* error = Nil;
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:[payloadMsg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//    NSDictionary *rootDic = [parser objectWithString:recordJosn error:&error];
    NSMutableArray *dict = [[NSMutableArray alloc] init];
    dict= [rootDic objectForKey: @"Data"];
    NSDictionary *dicc= [dict objectAtIndex:0];
    NSString *string=[NSString stringWithFormat:@"%@",[dicc objectForKey:@"AfterAction"]];
    NSString* titleStr = [NSString stringWithFormat:@"%@",[dicc objectForKey:@"NoticeTitle"]];
    NSString* contentStr = [NSString stringWithFormat:@"%@",[dicc objectForKey:@"NoticeContent"]];
    
    
    
    
   
    
    //    1.打开APP
    if ([string isEqualToString:@"StartApp"])
    {
        NSDictionary *message= [dicc objectForKey:@"Action"];
        if (message != nil)
        {
            
        }
    }

    //    2.打开超链
    else if ([string isEqualToString:@"OpenPage"])
    {
        NSDictionary *message= [dicc objectForKey:@"Action"];
        if (message != nil)
        {
            NSString* strType = [message objectForKey:@"OpenConfirm"];
            NSString *tuiSongStrWeb = [message objectForKey:@"WebAddress"];
            if ([strType isEqualToString:@"True"])
            {

                if (self.appBecome) {
                    [UIAlertView showAlertViewWithTitle:titleStr message:contentStr cancelButtonTitle:NSLocalizedString(@"ignore", nil) otherButtonTitles:@[NSLocalizedString(@"tapSee", nil)] onDismiss:^(int buttonIndex, UIAlertView *alertView) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"tuisongWebUrl" object:nil userInfo:@{@"url":tuiSongStrWeb}];
                        
                        
                    } onCancel:^{
                        
                    }];
                    return;
                }
                
                NSMutableArray *saveArray = (NSMutableArray *)[self loadFromFileUnarchiver:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/apnsRecord.plist"]]];
                if (saveArray == nil) {
                    saveArray = [NSMutableArray array];
                }
                
                 NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/apnsRecord.plist"]];
                
                
                NSDictionary *saveDic = [NSDictionary dictionaryWithObject:tuiSongStrWeb forKey:titleStr];
                [saveArray addObject:saveDic];
                [self saveToFileArchiver:saveArray path:savePath];
                
                
               
             
               
            }
        }
    }
    //    3.下载应用
    else if ([string isEqualToString:@"DownloadApp"])
    {
        NSDictionary *message= [dicc objectForKey:@"Action"];
        if (message != nil)
        {
            NSString* strURL = [message objectForKey:@"DownloadAddress"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strURL]]];
        }
    }
    
    NSMutableArray *saveArray = (NSMutableArray *)[self loadFromFileUnarchiver:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/apnsRecord.plist"]]];
    
    [saveArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSString *apnsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"APNS"];
        NSString *titleStr = [[obj allKeys] firstObject];
        if ([apnsStr isEqualToString:titleStr]) {
            NSString *webUrl = [obj objectForKey:apnsStr];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tuisongWebUrl" object:nil userInfo:@{@"url":webUrl}];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"APNS"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    
    
    
    
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
//    [_viewController logMsg:record];
    NSLog(@"-----====%@",record);
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
    NSLog(@"=个推发现错误====%@",[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}
- (BOOL)saveToFileArchiver:(id)obj path:(NSString *)path {
    [NSKeyedArchiver archiveRootObject:obj toFile:path];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    return [data writeToFile:path atomically:YES];
}
- (id)loadFromFileUnarchiver:(NSString *)path {
    
    
    id obj = nil;
    @try {
        NSData *data = [NSData dataWithContentsOfFile:path];
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        obj = nil;
        NSLog(@"Exception : %@", exception);
    }
    @finally {
        
    }
    return obj;
}
@end
