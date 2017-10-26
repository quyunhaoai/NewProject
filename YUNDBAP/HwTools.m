//
//  HwTools.m
//  CloudApp
//
//  Created by 9vs on 15/1/31.
//
//

#import "HwTools.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "UIAlertView+Blocks.h"
#import "ClockView.h"
#import "SVProgressHUD.h"
//#import <AGCommon/NSString+Common.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "UIWindow+YzdHUD.h"
#import "UpXRes.h"
#import "CustomDoneBtn.h"
#import "MBProgressHUD+Add.h"
@implementation ShareModel

@end


@interface HwTools ()
{
    NSString *concent;
    NSString *_upgradeRemindInfoStr;
    NSString *accesstoken;
    NSString *openid;
}
@property (nonatomic,strong)UIImageView *launchImgView;
@property (nonatomic,strong)UIImageView *prepLoadingImgView;
@property (nonatomic,strong)UIActivityIndicatorView *prepLoadingActView;
@property (nonatomic,strong)UIImageView *customPrepLoadingActView;
@end

@implementation HwTools


+ (HwTools *)shareTools {
    static HwTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[HwTools alloc] init];
    });
    return tools;
}
#pragma mark - qq登陆
-(void)initQQloading
{
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    NSString *appid = base.qqappid;
    NSLog(@"%@",appid);
    self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:appid andDelegate:self];
    
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            nil];
   [self.tencentOAuth authorize:permissions inSafari:NO];
}
-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"---%@----",response.jsonResponse);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:accesstoken forKey:@"token"];
    [muDic setObject:openid forKey:@"openid"];
    [muDic setObject:[self DataTOjsonString:response.jsonResponse]forKey:@"userinfo"];
    
    NSString *url = [HwTools UserDefaultsObjectForKey:@"qqweburl"];
    NSRange rangwenhao = [url rangeOfString:@"?"];
    if (rangwenhao.location != NSNotFound) {
        url = [url stringByAppendingFormat:@"&openid=%@",openid];//如果url包含问号在URL后面加&openid
    }else{
        url = [url stringByAppendingFormat:@"?openid=%@",openid];//如果url没有包含问号在url后面加?openid
    }
    [manager POST:url parameters:muDic constructingBodyWithBlock:^(id formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"pic----suc---%@----%@",responseObject,[responseObject class]);
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"pic----succ---%@",aString);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toTwoview" object:self userInfo:@{@"url":url}];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"pic----fai---%@",error);

    }];


}
-(void)tencentDidLogin
{
    NSLog(@"登录完成");
    BOOL issuccess = [self.tencentOAuth getUserInfo];
    NSLog(@"%d",issuccess);
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        accesstoken=  [self.tencentOAuth accessToken];
        openid = [self.tencentOAuth openId];

    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"登录不成功 没有获取accesstoken" maskType:0];
    }
    
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        [SVProgressHUD showErrorWithStatus:@"用户取消登录" maskType:0];

    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"登录失败" maskType:0];
    }
}
-(void)tencentDidNotNetWork
{
        [SVProgressHUD showErrorWithStatus:@"无网络连接，请设置网络" maskType:0];
}
- (void)checkTimeOut {
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    NSString *urlString = [NSString stringWithFormat:@"http://apiinfoios.ydbimg.com/Default.aspx?type=app&id=%@",base.appsid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"==%@",responseObject);
        
        
        AppInfoBase *base = [AppInfoBase modelObjectWithDictionary:responseObject];
        AppInfoTable *table = [base.table firstObject];
        [[UpXRes shareUpdateXML] checkXMlRes:table];
        [HwTools UserDefaultsObj:table.signKey key:@"singkey"];
        [HwTools UserDefaultsObj:table.isTimeOut key:@"isTimeOut"];
        [HwTools UserDefaultsObj:table.appState key:@"appState"];
        [HwTools UserDefaultsObj:[self findNumFromStr:table.createtime] key:@"createTime"];
        [[NSUserDefaults standardUserDefaults] setFloat:table.packageId forKey:@"YdbPackageID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self youxiaoqi:table.isTimeOut];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self youxiaoqi:[HwTools UserDefaultsObjectForKey:@"isTimeOut"]];
    }];
    
}
- (void)youxiaoqi:(NSString *)aStr
{
  if ([aStr isEqualToString:@"1"]){
        NSString *messageStr = [HwTools UserDefaultsObjectForKey:@"appState"];
        UIAlertView* NSAslert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"goodInfo", nil) message:messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [NSAslert show];
        
    }
}
-(int)intversion: (NSString *)stringOldversion
{
    NSArray *array = [stringOldversion componentsSeparatedByString:@"."];
    NSString *resultStr=@"";
    for (int a = 0; a<[array count]; a ++)
    {
        resultStr = [resultStr stringByAppendingString:[array objectAtIndex:a]];
    }
    int Aversion = [resultStr intValue];
    return Aversion;
}

#pragma mark - 缓存处理
- (void)getCacheSizeCompletion:(void(^)(float size))completion {
    __block float liang = 0.0;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *sqlFilePath = [docPath stringByAppendingPathComponent:@"Caches"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        liang = [self folderSizeAtPath:sqlFilePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(liang);
        });
    });
}
//遍历文件夹获得文件夹大小，返回多少M
- (float) folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)clearCache:(void(^)(void))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files)
        {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"clearSuc", nil)];
        });
    });
}
#pragma mark - 初始化其他
- (void)initOther {
    StringsXmlBase *xBase = [StringsXML getStringXmlBase];
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@" %@ CK 2.0",appVersion];
    int a = [xBase.UserAgentType intValue];
    NSString *Content= [NSString stringWithFormat:@"%@",xBase.UserAgentContent];
    switch (a) {
        case 0:
            customUserAgent = [userAgent stringByAppendingFormat:@" %@ CK 2.0",appVersion];
            break;
        case 1:
            customUserAgent = [userAgent stringByAppendingFormat:@" %@ CK 2.0MicroMessenger",appVersion];
            break;
        case 2:
            customUserAgent = [userAgent stringByAppendingFormat:@" %@ CK 2.0%@",appVersion,Content];
            break;
        default:
            break;
    }
    customUserAgent = [customUserAgent stringByAppendingFormat:@" wechatdevtools"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    [[NSUserDefaults standardUserDefaults] setObject:xBase.appsid forKey:@"myappsid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
#pragma mark - 启动动画
-(UIImageView *)launchImgView {
    if (!_launchImgView) {
//        _launchImgView = [[UIImageView alloc] init];
//        _launchImgView.frame = [[UIScreen mainScreen] bounds];
//        _launchImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        _launchImgView.userInteractionEnabled = NO;
    }
    return _launchImgView;
}
- (void)launchImageAd {
    StringsXmlBase *xBase = [StringsXML getStringXmlBase];
    NSString *imgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@%@",xBase.appsid,@"launchImage"]];
    NSData *data = [NSData dataWithContentsOfFile:imgPath];
    if (data.length > 0) {
        AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
        
        appDelegate.isHideHud = YES;
        UIImage *lImage = [UIImage imageWithData:data];
        _launchImgView = [[UIImageView alloc] init];
        _launchImgView.frame = [[UIScreen mainScreen] bounds];
        _launchImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _launchImgView.userInteractionEnabled = NO;
        self.launchImgView.image = lImage;
        self.launchImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAdLink)];
        [self.launchImgView addGestureRecognizer:tapGesturRecognizer];
        [[UIApplication sharedApplication].keyWindow addSubview:self.launchImgView];
        
       
        
        if ([xBase.PreloadState isEqualToString:@"0"]) {
            [self remarkBtn];
        }
        
    }
    [self loadLaunchImageFromServer];
}
- (void)remarkBtn {
    NSString *remarkStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"remark"];
    if (remarkStr.length > 0) {
        [self performSelector:@selector(launchImgViewRemove) withObject:self afterDelay:[remarkStr integerValue]];
    }else {
        [self performSelector:@selector(launchImgViewRemove) withObject:self afterDelay:3];
    }
    CustomDoneBtn *btn = [[CustomDoneBtn alloc] initWithFrame:CGRectMake(self.launchImgView.frame.size.width - 85, 20, 70, 35) time:[remarkStr intValue]];
    btn.completionHandler = ^(){
        [self launchImgViewRemove];
    };
    [self.launchImgView addSubview:btn];
}

- (void)loadLaunchImageFromServer {
  
    
    StringsXmlBase *xBase = [StringsXML getStringXmlBase];
    NSString *urlStr = [NSString stringWithFormat: @"http://apiadios.ydbimg.com/Default.aspx?type=image&apps_id=%@&icontype_id=12&page=1&pagesize=1",xBase.appsid];
    
    //路径
    NSString *imgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@%@",xBase.appsid,@"launchImage"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        LaunchImageBase *base = [LaunchImageBase modelObjectWithDictionary:responseObject];
        LaunchImageTable *table = base.table.firstObject;

        if (table.iconurl.length > 0) {
            if (table.remark.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:table.remark forKey:@"remark"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:table.iconurl] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                NSData *imgData = UIImagePNGRepresentation(image);
                [imgData writeToFile:imgPath atomically:YES];
                [[NSUserDefaults standardUserDefaults] setObject:table.iconlink forKey:[NSString stringWithFormat:@"%@iconlink",xBase.appsid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }else {
            [[NSData new] writeToFile:imgPath atomically:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        
    }];
    
}
- (void)launchImgViewRemove {
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate.isHideHud = NO;
    [self.launchImgView removeFromSuperview];
    if (self.prepLoadingImgView.superview != nil) {
        appDelegate.isHideHud = YES;
    }
    
    StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
    if ([stringBase.isLandscape isEqualToString:@"1"] && [[NSUserDefaults standardUserDefaults] boolForKey:stringBase.appsid]) {
        appDelegate.isFull = YES;
    }else {
        appDelegate.isFull = NO;
    }
}

- (void)openAdLink {
    StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@iconlink",stringBase.appsid]];
    if (urlStr.length == 0) {
        return;
    }
    [self launchImgViewRemove];
    self.launchImgView.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tuisongWebUrl" object:nil userInfo:@{@"url":urlStr}];
    
}

- (UIImageView *)prepLoadingImgView {
    if (!_prepLoadingImgView) {
//        _prepLoadingImgView = [[UIImageView alloc] init];
//        _prepLoadingImgView.frame = [[UIScreen mainScreen] bounds];
//        _prepLoadingImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _prepLoadingImgView;
}
- (void)prepLoading {
    
    
    StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
    if ([stringBase.PreloadState isEqualToString:@"0"]) {
        return;
    }
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isHideHud = YES;
    UIImage *lImage = [UIImage imageNamed:@"Default-2208"];
    _prepLoadingImgView = [[UIImageView alloc] init];
    _prepLoadingImgView.frame = [[UIScreen mainScreen] bounds];
    _prepLoadingImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.prepLoadingImgView.image = lImage;
    [[UIApplication sharedApplication].keyWindow addSubview:self.prepLoadingImgView];
    if ([stringBase.PreloadImg isEqualToString:@"0"]) {
        [self.prepLoadingImgView addSubview:self.prepLoadingActView];
        [self.prepLoadingActView startAnimating];
    }
    if ([stringBase.PreloadImg isEqualToString:@"1"]) {
        [self.prepLoadingActView startAnimating];
        [self startAnimation:0];
        [self.prepLoadingImgView addSubview:self.customPrepLoadingActView];
    }
    if ([stringBase.PreloadImg isEqualToString:@"2"]) {
        [self.prepLoadingActView startAnimating];
    }
    if (stringBase.PreloadTime.floatValue > 0) {
        [self performSelector:@selector(prepLoadingImgRemove) withObject:self afterDelay:stringBase.PreloadTime.floatValue];
    }else {
        [self performSelector:@selector(prepLoadingImgRemove) withObject:self afterDelay:5];
    }
}

- (void)startAnimation:(float)imageviewAngle
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(imageviewAngle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.customPrepLoadingActView.transform = endAngle;
    } completion:^(BOOL finished) {
        float angle = imageviewAngle;
        angle += 5;
        [self startAnimation:angle];
    }];
    
}
- (UIImageView *)customPrepLoadingActView {
    if (!_customPrepLoadingActView) {
        _customPrepLoadingActView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newviewpagerprogress"]];
        _customPrepLoadingActView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2+100);
        _customPrepLoadingActView.bounds = CGRectMake(0, 0, 25, 25);
    }
    return _customPrepLoadingActView;
}



- (void)prepLoadingImgRemove {
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(prepLoadingImgRemoveDone) userInfo:nil repeats:NO];
    /*
     [UIView animateWithDuration:3.0f animations:^{
     self.prepLoadingImgView.alpha = 0;
     } completion:^(BOOL finished) {
     AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     appDelegate.isHideHud = NO;
     }];
     */
    
}
- (void)prepLoadingImgRemoveDone {
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.prepLoadingImgView.superview) {
        [self.prepLoadingImgView removeFromSuperview];
        appDelegate.isHideHud = NO;
    }
    if (self.launchImgView.superview != nil) {
        appDelegate.isHideHud = YES;
    }
    if (!self.prepLoadingActView.isAnimating) {
        return;
    }
    StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
    if ([stringBase.PreloadState isEqualToString:@"1"]) {
        [self remarkBtn];
    }
    [self.prepLoadingActView stopAnimating];
    

}
- (UIActivityIndicatorView *)prepLoadingActView {
    if (!_prepLoadingActView) {
        _prepLoadingActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _prepLoadingActView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2+100);
        _prepLoadingActView.hidesWhenStopped = YES;
    }
    return _prepLoadingActView;
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

/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)installStatistics:(NSString *)deviceTokenStr {
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://pdeviceios.ydbimg.com/rest/weblsq/1.0/AddDeviceInfo.aspx"];
    
    //#warning 得到xml
    NSMutableDictionary *stringDic = [[StringsXML shareStringsXML] jiexiStringsXML:@"strings"];
    StringsXmlBase *base = [StringsXmlBase modelObjectWithDictionary:stringDic];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"appid":base.appsid,@"deviceid":deviceTokenStr,@"isappstore":@"1"};
    
    [manager.requestSerializer setValue:@"basic d2VibHNxOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON: %@", error);
    }];
}


+ (void)UserDefaultsObj:(id)obj key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)UserDefaultsObjectForKey:(NSString *)key {
    id obj = nil;
    obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return obj;
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
        
    }
    return jsonString;
}
#pragma mark - 分享
- (void)shareSdkInitializePlat {
    
    NSMutableArray *shareArray = [[UXml shareUxml] jiexiXML:@"ShareSDKDevInfor" two:@"share"];
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeSMS),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        ]
     
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             case SSDKPlatformTypeRenren:
                 //                 [ShareSDKConnector connectRenren:[RennClient class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:[[shareArray objectAtIndex:3] valueForKey:@"AppKey"]                                           appSecret:[[shareArray objectAtIndex:3] valueForKey:@"AppSecret"]
                                         redirectUri:[[shareArray objectAtIndex:3] valueForKey:@"RedirectUrl"]
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:[[shareArray objectAtIndex:1] valueForKey:@"AppId"]                                       appSecret:[[shareArray objectAtIndex:1] valueForKey:@"AppSecret"]];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:[[shareArray objectAtIndex:5] valueForKey:@"AppId"]                                      appKey:[[shareArray objectAtIndex:5] valueForKey:@"AppKey"]
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
    
}
#pragma mark - 弹出分享
#define IMAGE_NAME @"AppIcon-160x60@2x"
#define CONTENT @"png"
- (void)danduFenxiang:(int)type fromView:(UIView *)vi shareModel:(ShareModel *)sModel{
    if (sModel.sContent.length == 0 && sModel.sContent == nil) {
        sModel.sContent =NSLocalizedString(@"shareEnterContent", nil);
    }
    if (sModel.sTitle.length == 0 && sModel.sTitle == nil) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        sModel.sTitle = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    if ( sModel.sImage == nil) {
        sModel.sImage = [UIImage imageNamed:@"AppIcon-160x60"];
    }
    
    SSDKPlatformType typea = SSDKPlatformTypeSinaWeibo;
    NSString *typeString = @"Wechat";
    switch (type) {
        case 0:
            typea = SSDKPlatformSubTypeWechatSession;
            typeString = @"Wechat";
            break;
        case 1:
            typea = SSDKPlatformSubTypeWechatTimeline;
            typeString = @"WechatMoments";
            break;
        case 2:
            typea = SSDKPlatformTypeSinaWeibo;
            typeString = @"SinaWeibo";
            break;
        case 3:
            typea = SSDKPlatformSubTypeQQFriend;
            typeString = @"QQ";
            break;
        case 4:
            typea = SSDKPlatformSubTypeQZone;
            typeString = @"Qzone";
            break;
        case 5:
            typea = SSDKPlatformTypeSMS;
            typeString = @"ShortMessage";
        default:
            break;
    }
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:sModel.sContent
                                     images:sModel.sImage //传入要分享的图片
                                        url:[NSURL URLWithString:sModel.sUrl]
                                      title:sModel.sTitle
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:typea //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
         NSString *stateString = nil;
         if (state == SSDKResponseStateSuccess)
         {
             stateString = @"success";
             self.completion(stateString,typeString);
             NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
         }
         else if (state == SSDKResponseStateFail)
         {
             stateString = @"fail";
             self.completion(stateString,typeString);
         }else if (state == SSDKResponseStateCancel){
             stateString = @"cancel";
             self.completion(stateString,typeString);
         }
         
     }];
}

- (void)shareAllButtonClickHandler:(UIView *)vi shareModel:(ShareModel *)sModel;
{
    // [WXApi registerApp:@"wx1121a605cb236e1b"];
    [self showShareActionSheet:vi andModel:sModel];
    
}


#pragma mark 显示分享菜单

/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view andModel:(ShareModel *)sModel
{
    NSRange ranges = [sModel.sContent rangeOfString:NSLocalizedString(@"shareEnterContent", nil)];
    if (ranges.location != NSNotFound) {
        
    }
    if (sModel.sContent.length == 0 && sModel.sContent == nil) {
        sModel.sContent =NSLocalizedString(@"shareEnterContent", nil);
    }
    if (sModel.sTitle.length == 0 && sModel.sTitle == nil) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        sModel.sTitle = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    if ( sModel.sImage == nil) {
        sModel.sImage = [UIImage imageNamed:@"AppIcon-160x60"];
    }
    
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    //    __weak ViewController *theController = self;
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"];
    //    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
    //    NSArray* imageArray = @[@"http://ww4.sinaimg.cn/bmiddle/005Q8xv4gw1evlkov50xuj30go0a6mz3.jpg",[UIImage imageNamed:@"shareImg.png"]];
    [shareParams SSDKSetupShareParamsByText:sModel.sContent
                                     images:sModel.sImage
                                        url:[NSURL URLWithString:sModel.sUrl]
                                      title:sModel.sTitle
                                       type:SSDKContentTypeAuto];
    [shareParams SSDKSetupSMSParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@",sModel.sTitle, sModel.sContent,sModel.sUrl] title:sModel.sTitle images:sModel.sImage attachments:nil recipients:nil type:SSDKContentTypeText];
    [shareParams SSDKSetupCopyParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@",sModel.sTitle, sModel.sContent,sModel.sUrl] images:sModel.sUrl url:[NSURL URLWithString:sModel.sUrl] type:SSDKContentTypeText];
    /*
     //1.2、自定义分享平台（非必要）
     NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
     //添加一个自定义的平台（非必要）
     SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
     label:@"自定义"
     onClick:^{
     
     //自定义item被点击的处理逻辑
     NSLog(@"=== 自定义item被点击 ===");
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
     message:nil
     delegate:nil
     cancelButtonTitle:@"确定"
     otherButtonTitles:nil];
     [alertView show];
     }];
     [activePlatforms addObject:item];
     */
    //设置分享菜单栏样式（非必要）
    //        [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
    //        [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
    //        [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
    //        [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor whiteColor]];
    //        [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
    //        [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
    //        [SSUIShareActionSheetStyle setCurrentPageIndicatorTintColor:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]];
    //        [SSUIShareActionSheetStyle setPageIndicatorTintColor:[UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]];
    
    //2、分享
    NSMutableArray *shareList =[NSMutableArray arrayWithObjects:@(SSDKPlatformSubTypeWechatSession),
                                @(SSDKPlatformSubTypeWechatTimeline),
                                @(SSDKPlatformTypeSinaWeibo),
                                @(SSDKPlatformSubTypeQQFriend),
                                @(SSDKPlatformSubTypeQZone),
                                @(SSDKPlatformTypeSMS),
                                @(SSDKPlatformTypeCopy), nil];
    
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    NSString *str = base.pingtai;
    NSArray *pingtaiArray = [str componentsSeparatedByString:@","];
    NSMutableArray *mutablelist = [NSMutableArray arrayWithArray:shareList];
    if (pingtaiArray.count > 0) {
        if (![pingtaiArray containsObject:@"QQ"])[mutablelist removeObject:[NSNumber numberWithLong:24]];
        if (![pingtaiArray containsObject:@"QZone"]) [mutablelist removeObject:[NSNumber numberWithLong:6]] ;
        if (![pingtaiArray containsObject:@"Wechat"]) [mutablelist removeObject:[NSNumber numberWithLong:22]] ;
        if (![pingtaiArray containsObject:@"WechatMoments"]) [mutablelist removeObject:[NSNumber numberWithLong:23]] ;
        if (![pingtaiArray containsObject:@"SinaWeibo"]) [mutablelist removeObject:[NSNumber numberWithLong:1]] ;
        if (![pingtaiArray containsObject:@"ShortMessage"]) [mutablelist removeObject:[NSNumber numberWithLong:19]] ;
    }
    [ShareSDK showShareActionSheet:view
                             items: mutablelist
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   int tyep = (int)platformType;
                   NSString *typeString;
                   NSString *stateString;
                   switch (tyep) {
                       case 24:
                           typeString = @"QQ";
                           break;
                       case 6:
                           typeString = @"QZone";
                           break;
                       case 22:
                           typeString = @"Wechat";
                           break;
                       case 23:
                           typeString = @"WechatMoments";
                           break;
                       case 1:
                           typeString = @"SinaWeibo";
                           break;
                       case 19:
                           typeString = @"ShortMessage";
                           break;
                       case 999:
                           typeString = @"ShareTypeAny";
                           break;
                       case 21:
                           typeString = @"Copy";
                           break;
                       case 0:
                           typeString = @"shareTypeUnknow";
                           break;
                   }
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           //                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           stateString = @"success";
                           self.completion(stateString,typeString);
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           stateString = @"fail";
                           self.completion(stateString,typeString);
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
                               break;
                           }
                           else
                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           stateString = @"cancel";
                           if (self.completion){
                           self.completion(stateString,typeString);
                           }
                           
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           [MBProgressHUD show:@"分享已取消" icon:nil view:view duration:2.0 mask:NO];
                           
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin && state != SSDKResponseStateBeginUPLoad)
                   {
                       //                       [theController showLoadingView:NO];
                       //                       [theController.tableView reloadData];
                   }
                   
               }];
    //设置 消息编辑UI中 不显示显示其他平台Icon
    //    sheet.noShowOtherPlatformOnEditorView = YES;
    
    //另附：设置跳过分享编辑页面，直接分享的平台。
    //        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
    //                                                                         items:nil
    //                                                                   shareParams:shareParams
    //                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    //                                                           }];
    //
    //        //删除和添加平台示例
    //        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
    //        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    
}

-(NSString *)findNumFromStr:(NSString *)string
{
    NSString *originalString = string;
    //    NSLog(@"%@",[originalString class]);
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init] ;
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    // Result.
    //    int number = [numberString integerValue];
    
    return numberString;
}
@end



