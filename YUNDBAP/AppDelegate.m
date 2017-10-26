

#import "AppDelegate.h"
#import "HwOnePageViewController.h"
#import "CustomNavigationController.h"
#import "HwSideViewController.h"
#import "MMDrawerVisualState.h"
#import "GeTuiTool.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "CustomTabBarController.h"
#import "GGImageTabBarViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SVProgressHUD.h"
#import "UMMobClick/MobClick.h"
#import "CustomAKTabViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIWindow+YzdHUD.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "Umengtuis.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SPayClient.h"
#import "BeeCloud.h"
@implementation AppDelegate

- (void)settingIFlyVoice {

    [IFlySetting setLogFile:LVL_LOW]; 
    [IFlySetting showLogcat:NO];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
    [IFlySpeechUtility createUtility:initString];
}
- (void)settintBDMap {

    NSMutableDictionary *stringDic = [[StringsXML shareStringsXML] jiexiStringsXML:@"strings"];
    StringsXmlBase *stringBase = [StringsXmlBase modelObjectWithDictionary:stringDic];
    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:stringBase.gPSIOSAppKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else {
        NSLog(@"manager start success!");
    }

}

- (void)umengTrack {
    /*    [MobClick setCrashReportEnabled:NO];  如果不需要捕捉异常，注释掉此行 */
    /*[MobClick setLogEnabled:YES];   打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗*/
    [MobClick setAppVersion:XcodeAppVersion]; /*参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取*/
    StringsXmlBase *xmlBase = [StringsXML getStringXmlBase];
    if (xmlBase.umappkey.length > 0) {
        UMConfigInstance.appKey = xmlBase.umappkey;
        UMConfigInstance.channelId = @"App Store";
        [MobClick startWithConfigure:UMConfigInstance];
    }

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    NSHTTPCookieStorage *cook = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cook setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    /*初始化全局变量*/
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    self.wkPool = [[WKProcessPool alloc] init];
    [self settingIFlyVoice];
    [self settintBDMap];
    [self umengTrack];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

    StringsXmlBase *stringB = [StringsXML getStringXmlBase];
    if ([stringB.isClosePhoneState isEqualToString:@"0"]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    }else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    }
    
  
   
//    NSLog(@"%@",[ShareSDK version]);

    
//    self.viewDelegate = [[AGViewDelegate alloc] init];
    self.sModel = [[ShareModel alloc] init];
  
    [[HwTools shareTools] shareSdkInitializePlat];
    [[HwTools shareTools] initOther];
    
    [[GeTuiTool shareTool] initGeTui];
    
    
    [self showMainVC];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainVC) name:@"showMainVC" object:nil];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[HwTools shareTools] launchImageAd];
    [[HwTools shareTools] prepLoading];

    [[HwTools shareTools] checkTimeOut];
    
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    if (base.wxappid.length > 0 ) {
//        [WXApi registerApp:base.wxappid enableMTA:YES];
        [WXApi registerApp:base.wxappid];
    }
    if (base.WFTWXAPPID.length > 0 ) {
        //配置微付通微信APP支付
        SPayClientWechatConfigModel *wechatConfigModel = [[SPayClientWechatConfigModel alloc] init];
        wechatConfigModel.appScheme = base.WFTWXAPPID;
        wechatConfigModel.wechatAppid = base.WFTWXAPPID;
        [[SPayClient sharedInstance] wechatpPayConfig:wechatConfigModel];
        
        [[SPayClient sharedInstance] application:application
                   didFinishLaunchingWithOptions:launchOptions];
    }
    if (base.bcAppID.length > 0 ) {
        //BeeCloud支付
        [BeeCloud initWithAppID:base.bcAppID andAppSecret:base.bcAPPSecret];
        [BeeCloud initWeChatPay:base.bcwxAppID];
        
    }
    if (base.iosUmengAppkey.length>0) {

        [Umengtuis initRegit:base.iosUmengAppkey andlaunchOptins:launchOptions];
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
        for (NSString *str in userInfo) {
            if ([str isEqualToString:@"d"]) {
                [Umengtuis showCustomAlertViewWithUserInfo:userInfo];
            }
        }
        
    }

         
    }
    /*
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        
        _payloadStr = [remoteNotification objectForKey:@"payload"];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    }
     */
    
    self.animation = [NSArray arrayWithObjects:@"0",@"1", nil];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    self.isleftOrrightMenu = NO;
    return YES;
}

- (void)delayMethod{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tuisongWebUrl" object:nil userInfo:@{@"url":_payloadStr}];
}

//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
- (void)showMainVC {
     NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
    HwOnePageViewController *one = [[HwOnePageViewController alloc] init];
    for (NSDictionary *dic in array) {
        MyXmlBase *base = [MyXmlBase modelObjectWithDictionary:dic];
        one.currentUrlStr = [base.weburl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        one.refreshMenuStr = base.refreshMenu;
    }
    HwSideViewController *side = [[HwSideViewController alloc] init];
    
    self.currentVC = nil;
    if (array.count == 1) {
        self.currentVC = [[CustomNavigationController alloc] initWithRootViewController:one];
    }else {
        
        self.currentVC = [[CustomAKTabViewController alloc] init];
        
        
    }
   
    if (self.drawerController) {
        if (self.isleftOrrightMenu) {
            [self.drawerController setLeftDrawerViewController:side];
            [self.drawerController setRightDrawerViewController:nil];
        }else{
            [self.drawerController setRightDrawerViewController:side];
            [self.drawerController setLeftDrawerViewController:nil];
        }
        return;

    }
    
    if (self.isleftOrrightMenu) {
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:self.currentVC leftDrawerViewController:side];
        [self.drawerController setMaximumLeftDrawerWidth:240];
    }else{
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:self.currentVC rightDrawerViewController:side];
        [self.drawerController setMaximumRightDrawerWidth:240.0];
    }
    
    /*
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.currentVC leftDrawerViewController:side rightDrawerViewController:side];
    [self.drawerController setMaximumLeftDrawerWidth:240];
    [self.drawerController setMaximumRightDrawerWidth:240];
    */
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModeTapCenterView];
    
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    
    self.window.rootViewController = self.drawerController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[GeTuiTool shareTool] stopSdk];
    [[GeTuiTool shareTool] clearbadgeNumber];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

    [[GeTuiTool shareTool] startSdk];
    [[GeTuiTool shareTool] clearbadgeNumber];
    [FBSDKAppEvents activateApp];
    StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
    if ([stringBase.isBecomeActive isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didBecomeActive" object:nil userInfo:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}


#pragma mark - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0){
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }];
    }
    [WXApi handleOpenURL:url delegate:self] ||[TencentOAuth HandleOpenURL:url];
    return YES;
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    NSLog(@"%@",url);
    return [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url] || [[SPayClient sharedInstance] application:application handleOpenURL:url];
}
/*iOS 4.2+*/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    /*如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包*/
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }];
        return YES;
    }
    return[WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url]||[[FBSDKApplicationDelegate sharedInstance] application:application
                                                                                                                                                                    openURL:url
                                                                                                                                                          sourceApplication:sourceApplication
                                                                                                                                                                 annotation:annotation] || [[SPayClient sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
}
#pragma mark WXApiDelegate(optional)

-(void) onReq:(BaseReq*)req
{

}

-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *resps = (PayResp *)resp;
        switch (resps.errCode) {
            case WXSuccess:
                [SVProgressHUD showSuccessWithStatus:@"支付成功！" maskType:0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixindenglu" object:self];
                break;
            case WXErrCodeUserCancel:
                [SVProgressHUD showErrorWithStatus:@"支付取消！" maskType:0];
                if (_isWeixindenglu) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelPay" object:self];
                }
                break;
            default:
                [SVProgressHUD showErrorWithStatus:@"支付失败！" maskType:0];
                break;
        }
    }
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        if (temp.errCode == 0 ) {
            NSString *code = [NSString stringWithFormat:@"%@",temp.code];
            /**获取code秘钥**/
            StringsXmlBase *base = [StringsXML getStringXmlBase];
            NSString *appid = base.wxappid;
            NSString *sectect = base.wxsecrect;
            if (appid.length == 0 || sectect.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"缺少APPID或者APP秘钥。"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            NSLog(@"%@-----%@",appid,sectect);
            
            /**获取access_token和refresh_token **/
            NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",appid,sectect,code];
            NSURL *wxurl = [NSURL URLWithString:url];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:wxurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"----%@",content);
            
            NSString *refresh_token = content[@"refresh_token"];
            NSString *access_token = content[@"access_token"];
            NSString *unionid = content[@"unionid"];
            /**延迟有效时间  获取openid**/
            NSString *reurl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",appid,refresh_token];
            NSURL *rerurl = [NSURL URLWithString:reurl];
            NSMutableURLRequest *rerequest = [[NSMutableURLRequest alloc]initWithURL:rerurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            NSData *refresh = [NSURLConnection sendSynchronousRequest:rerequest returningResponse:nil error:nil];
            NSDictionary *openid = [NSJSONSerialization JSONObjectWithData:refresh options:NSJSONReadingMutableContainers error:nil];
            NSString *openID = openid[@"openid"];
            NSLog(@"%@,%@",openid,openID);
            /**在这里返回CODE，token值**/
            NSString *returntype = [HwTools UserDefaultsObjectForKey:@"returnDataType"];
            NSString *returnurl = [HwTools UserDefaultsObjectForKey:@"accessUrl"];
            if ([returntype isEqualToString:@"0"]) {
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
                
                NSString *singkey = [HwTools UserDefaultsObjectForKey:@"singkey"];
                NSString *jiami = [NSString stringWithFormat:@"openid=%@&token=%@%@",openID,access_token,singkey];
                
                
                NSString *returenstr= [WXUtil md5:jiami];
                [muDic setObject:access_token forKey:@"token"];
                [muDic setObject:openID forKey:@"openid"];
                [muDic setObject:returenstr forKey:@"sign"];
                NSLog(@"----returnurl:%@  userInfo:%@",returnurl,muDic);
                NSRange rangwenhao = [returnurl rangeOfString:@"?"];
                if (rangwenhao.location != NSNotFound) {
                    returnurl = [returnurl stringByAppendingFormat:@"&openid=%@&unionid=%@",openID,unionid];                    }else{
                        returnurl = [returnurl stringByAppendingFormat:@"?openid=%@&unionid=%@",openID,unionid];
                    }
                
                
                [manager POST:returnurl parameters:muDic constructingBodyWithBlock:^(id formData) {
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"pic----suc---%@----%@",responseObject,[responseObject class]);
                    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSLog(@"pic----succ---%@",aString);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"toTwoview" object:self userInfo:@{@"url":returnurl}];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"pic----fai---%@",error);
                    [SVProgressHUD showErrorWithStatus:@"登录失败！" maskType:0];
                }];
                return;
            }
            
            /**验证授权凭证access_toke是否有效**/
            NSString *accessUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@",access_token,openID];
            NSURL *accurl = [NSURL URLWithString:accessUrl];
            NSMutableURLRequest *accrequest = [[NSMutableURLRequest alloc]initWithURL:accurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            NSData *access = [NSURLConnection sendSynchronousRequest:accrequest returningResponse:nil error:nil];
            NSDictionary *accresult = [NSJSONSerialization JSONObjectWithData:access options:NSJSONReadingMutableLeaves error:nil];
            NSString *errcode = [NSString stringWithFormat:@"%@",accresult[@"errcode"]];
            NSLog(@"%@",errcode);
            if ([errcode isEqualToString:@"0"]) {
                /**get用户信息  **/
                NSString *infourl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openID];
                NSURL *userUrl = [NSURL URLWithString:infourl];
                NSMutableURLRequest *userRequest = [[NSMutableURLRequest alloc]initWithURL:userUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                NSData *userData = [NSURLConnection sendSynchronousRequest:userRequest returningResponse:nil error:nil];
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@\n",userInfo);
                NSLog(@"name:%@",userInfo[@"nickname"]);
                
                /**在这里返回josn值**/
                if ([returntype isEqualToString:@"1"]) {
                    
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
                    
                    NSString *singkey = [HwTools UserDefaultsObjectForKey:@"singkey"];
                    NSString *jiami = [NSString stringWithFormat:@"openid=%@&resault=%@&token=%@%@",openID,[self DataTOjsonString:content],[self DataTOjsonString:userInfo],singkey];
                    NSString *returenstr= [WXUtil md5:jiami];/**/
                    NSString *appid;
                    if (base.PigWxToken ==  nil || base.PigWxToken.length==0) {
                        appid = @"0";
                    }else{
                        appid = base.PigWxToken;
                        [muDic setObject:appid forKey:@"appid"];
                    }
                    
                    [muDic setObject:[self DataTOjsonString:userInfo] forKey:@"token"];
                    [muDic setObject:openID forKey:@"openid"];

                    [muDic setObject:[self DataTOjsonString:content] forKey:@"resault"];
                    [muDic setObject:returenstr forKey:@"sign"];
                    
                    NSRange rangwenhao = [returnurl rangeOfString:@"?"];
                    if (rangwenhao.location != NSNotFound) {
                        returnurl = [returnurl stringByAppendingFormat:@"&openid=%@&unionid=%@&appid=%@",openID,unionid,appid];
                        }else{
                            returnurl = [returnurl stringByAppendingFormat:@"?openid=%@&unionid=%@&appid=%@",openID,unionid,appid];
                        }
                    
                    [manager POST:returnurl parameters:muDic constructingBodyWithBlock:^(id formData) {
                        
                    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"pic----suc---%@----%@",responseObject,[responseObject class]);
                        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSLog(@"pic----succ---%@",aString);
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"toTwoview" object:self userInfo:@{@"url":returnurl}];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"pic----fai---%@",error);
                        [SVProgressHUD showErrorWithStatus:@"登录失败！" maskType:0];
                    }];
                }
            }
        }
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



#pragma mark - 推送相关

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken

{
    NSString *tokens =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    

    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];

    NSString *deviceTokenStr = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", deviceTokenStr);
    
    
    /* [3]:向个推服务器注册deviceToken*/
    [[GeTuiTool shareTool] registerDevice:deviceTokenStr];
    [[HwTools shareTools] installStatistics:deviceTokenStr];
    
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    if (base.iosUmengAppkey.length > 0) {
        [Umengtuis registerDeviceToken:deviceToken];
    }

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    /* [3-EXT]:如果APNS注册失败，通知个推服务器*/
  
    [[GeTuiTool shareTool] registerDevice:@""];
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{

    if (userinfo) {
            for (NSString *str in userinfo) {
                if ([str isEqualToString:@"d"]) {
                    [Umengtuis setAutoAlertView:NO];
                    [Umengtuis didReceiveRemoteNotification:userinfo];
                    [Umengtuis showCustomAlertViewWithUserInfo:userinfo];
                    return;
                }
           }
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    /* [4-EXT]:处理APN*/
    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    NSLog(@"=******=====%@",record);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
     if (userInfo) {
          NSLog(@"-----%@",userInfo);
          
          for (NSString *str in userInfo) {
               if ([str isEqualToString:@"d"]) {
                    [Umengtuis setAutoAlertView:NO];
                    [Umengtuis didReceiveRemoteNotification:userInfo];
                    [Umengtuis showCustomAlertViewWithUserInfo:userInfo];
                    return;
               }
          }
     }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    /* [4-EXT]:处理APN*/
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
     NSLog(@"=*&&&&&&&&&&&*=====%@",record);
    
//[[NSNotificationCenter defaultCenter] postNotificationName:@"tuisongWebUrl" object:nil userInfo:@{@"url":payloadMsg}];
    [[NSUserDefaults standardUserDefaults] setObject:payloadMsg forKey:@"APNS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
    if ([stringBase.isLandscape isEqualToString:@"0"]) {//竖屏
        return UIInterfaceOrientationMaskPortrait;
    }
    if ([stringBase.isLandscape isEqualToString:@"2"]) {//横屏
        
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    if ([stringBase.isLandscape isEqualToString:@"1"]) {//自适应
        
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}


@end
