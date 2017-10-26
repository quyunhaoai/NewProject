/*
 HwOnePageViewController.m
 CloudApp
 
 Created by 9vs on 15/1/14.
 a
 */

/*#import <HealthKit/HealthKit.h>*/
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "HwOnePageViewController.h"
#import "HwTwoPageViewController.h"
#import "AppDelegate.h"
#import "UnpreventableUILongPressGestureRecognizer.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "HwYDBPageViewController.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"
#import "UIWindow+YzdHUD.h"
#import "HwYDBPageViewController.h"
#import "UIImageView+WebCache.h"

#import "UIViewController+MMDrawerController.h"
#import "UMMobClick/MobClick.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UIImage+Additions.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "NJKWebViewProgressView.h"
#import "ThreeViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "HwThreeViewController.h"
#import "RongyunDev.h"
#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "RegExCategories.h"
#import "DeviceInfoObject.h"
#import "IsLocationGPS.h"
#import "AddressBookClass.h"
#import "AFSoundManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MapNavigationManager.h"
#import "Kble.h"
#import "lame.h"
#import "GiFHUD.h"
#import <cmbkeyboard/CMBWebKeyboard.h>
#import <cmbkeyboard/NSString+Additions.h>
#import "Base64String.h"
#import "HTMLParser.h"
#import "WKProgressHUD.h"
#import "HwReaderView.h"

#import "SPHTTPManager.h"
#import "XMLReader.h"
#import "SPRequestForm.h"
#import "SPHTTPManager.h"
#import "SPConst.h"
#import "SPayClient.h"
#import "NSString+SPayUtilsExtras.h"
#import "NSDictionary+SPayUtilsExtras.h"
#import "SPayClientPayStateModel.h"
#import "SPayClientPaySuccessDetailModel.h"
#import "BeeCloud.h"
#import "BDWalletSDKMainManager.h"
#import "FSActionSheet.h"
#import "GetImage.h"
#import "MBProgressHUD+Add.h"
#import "Filemanager.h"
#import "UIAlertController+Block.h"
#import "Wxrequest.h"
#import "HWPhotoPreviewController.h"
#import "QYHTool.h"
#import <Social/Social.h>
#define iOS7_OR_EARLY ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
static const NSTimeInterval KLongGestureInterval = 0.5f;
typedef NS_ENUM(NSInteger, WKSelectItem) {
    WKSelectItemSaveImage,
    WKSelectItemQRExtract
};

@interface HwOnePageViewController ()<EAIntroDelegate,UIActionSheetDelegate,AKTabBarControllerDelegate,UIImagePickerControllerDelegate,MJSecondPopupDelegate>
{
    BOOL isAnimating;
    BOOL _isShowMoreView;
    int _lastPosition;
    BOOL _isScrollUpOrDown; /*是否上下滑动隐藏菜单*/
    BOOL _currentShowTabbar; /*当前是否已经显示tabbar*/
    BOOL _isShowYzdHud;/*是否显示云加载。。。效果。。。*/
    
    
    float _oldY;
    
    BOOL _isTimeLoc;/*是否开启时时定位*/
    NSString *_locUserId;
    
    
    BOOL _authed;
    NSURLRequest *_authRequest;
    NSString *_homePage;
    NSString *accessUrl;
    NSString *orderNo;
    NSString *attach;
    NSString *jsstr;
    BOOL _isShowBackMenu;
    BOOL _isNewpage;
    BOOL _isOpenNewWindow;
    MPMoviePlayerController *moviePlayer;
    Kble *ble;
    BOOL weixinJSDK;
    NSString *weixinPayretrueUrl;
    NSString *filePath;
    NSMutableArray *mutableAarray;
    NSString *xiaozhuWXpayUrlStr;
    NSString *weiqingWxPayUrlStr;
    BOOL _is9vImg;
    BOOL _isCanWebviewBcak;
    BOOL _isHomePage;
    EAIntroView *intro;

}
@property (nonatomic ,strong) NSString *jsMethodNameStr;
@property (nonatomic, assign) BOOL isGetGPS;
@property (nonatomic, assign) BOOL isGetScan;
@property (nonatomic ,strong) UIButton *btn;
@property (nonatomic, strong) StringsXmlBase *ssBase;
@property (nonatomic, strong) NSTimer *localUpdateTimer;
@property (nonatomic, strong) NSTimer *serverUploadTimer;
@property (nonatomic, strong) NSMutableArray *locDataArray;
@property (nonatomic, strong) MyLocBase *locBase;
@property (nonatomic, strong) UIAlertView *timeoutAlertView;
@property (nonatomic, strong) NSTimer *timeOutTimer;
@property (nonatomic, strong) WKWebViewConfiguration * webConfig;
@property (nonatomic, strong) NSMutableArray *imageUploadPluginArray;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NSString *wkqrCodeString;
@property (nonatomic, strong) UIImage *wksaveimage;
@property (nonatomic, strong) NSArray *JsArray;
@property (nonatomic, strong)NSOperationQueue *queue;
@end

@implementation HwOnePageViewController
-(NSOperationQueue *)queue{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}
- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressBarHeight = 3.0f;
        CGRect mainBounds = CGRectZero;
        if (self.wkWebView) {
            mainBounds = self.wkWebView.bounds;
        }else {
            mainBounds = self.webView.bounds;
        }
        if (self.navigationController.navigationBarHidden && [self.ssBase.adaptIOS7Nav isEqualToString:@"1"] && [self.ssBase.isClosePhoneState isEqualToString:@"1"]) {
//            mainBounds.origin.y += 20;
        }
        CGRect barFrame = CGRectMake(0, mainBounds.origin.y, mainBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        StringsXmlBase *xBase = [StringsXML getStringXmlBase];
        _progressView.tinColor = [HwTools hexStringToColor:xBase.ProgressViewColor];
    }
    return _progressView;
}
- (NSMutableArray *)imageUploadPluginArray {
    if (!_imageUploadPluginArray) {
        _imageUploadPluginArray = [NSMutableArray array];
    }
    return _imageUploadPluginArray;
}
- (NSString *)tabTitle {
    return self.tabTitleStr;
}
- (NSString *)tabImageName
{
    return self.tabImageNameStr;
}

- (NSString *)activeTabImageName
{
    return self.activeTabImageNameStr;
}

/*启动轮播图*/
- (void)showIntroWithCustomPages {
    
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val =UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
    
    StringsXmlBase *sBase = [StringsXML getStringXmlBase];
    
    NSMutableArray *eaArray = [NSMutableArray array];
    
    if ([sBase.frontSliderImageCount isEqualToString:@"0"]) {
        sBase.frontSliderImageCount = @"1";
    }
    
    for (int i = 0; i < [sBase.frontSliderImageCount intValue]; i++) {
        EAIntroPage *page1 = [EAIntroPage page];
        
        page1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"firststartimg0%d",i + 1]]];
        [eaArray addObject:page1];
    }
    
    
    
    intro = [[EAIntroView alloc] initWithFrame:[UIScreen mainScreen].bounds andPages:eaArray];
    intro.swipeToExit = NO;
    intro.bgImage = [UIImage imageNamed:@"bg1"];
    intro.pageControlY = 30.f;
    intro.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:115/255 green:115/255 blue:115/255 alpha:1];
    if ([sBase.isShowPagecontrol isEqualToString:@"1"]) {
        intro.pageControl.hidden = YES;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"startDo"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 150, 50)];
    intro.skipButton = btn;
    intro.skipButtonY = 100.f;
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    self.btn = btn;
    self.btn.hidden = YES;
    
    [intro setDelegate:self];
    [intro showFullscreen];
    
    
    [self hideTabBar:YES];
    self.navigationController.navigationBarHidden = YES;
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    
}
NSUInteger currentPage;
- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex;
{
    StringsXmlBase *sBase = [StringsXML getStringXmlBase];
    if (pageIndex == sBase.frontSliderImageCount.intValue - 1) {
        if ([sBase.isShowPagecontrol isEqualToString:@"1"]) {
            self.btn.hidden = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removefirstView:) ];
            [introView addGestureRecognizer:tap];
        }else{
            self.btn.hidden = NO;
        }
    }else {
        self.btn.hidden = YES;
    }
    if ([sBase.frontSliderImageCount isEqualToString:@"0"]) {
        self.btn.hidden = NO;
    }
    currentPage = pageIndex;
}
-(void)removefirstView:(EAIntroView *)introView{
    StringsXmlBase *sBase = [StringsXML getStringXmlBase];
    if (currentPage == sBase.frontSliderImageCount.integerValue -1) {
        [intro hideWithFadeOutDuration:0.3];
    }
}
- (void)introDidFinish:(EAIntroView *)introView {
    
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:stringBase.appsid];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([stringBase.isLandscape isEqualToString:@"1"]) {
        appDelegate.isFull = YES;
    }else {
        appDelegate.isFull = NO;
    }
    [self hideTabBar:NO];
    [self refreshMyFrame];
    
    [self hideTabBar:NO];
    [self refreshMyFrame];
    
    
    
}

- (void)refreshMyFrame {
    StringsXmlBase *sBase = [StringsXML getStringXmlBase];
    if ([sBase.titleBarIsShow isEqualToString:@"0"]) {
        self.navigationController.navigationBarHidden = YES;
    }else {
        self.navigationController.navigationBarHidden = NO;
    }
    if ([sBase.rightMenuIsShow isEqualToString:@"0"]) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }else {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModeTapCenterView];
    }
    if ([sBase.frontSliderState isEqualToString:@"1"]) {
        
        /*轮播图*/
        
        StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:stringBase.appsid]) {
            
            [self showIntroWithCustomPages];
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnClick) name:@"tabBarBtnClick" object:nil];
    if (self.wkWebView) {
        if (self.wkWebView.URL.absoluteString.length == 0) {
            [self reloadOrStop];
        }
    }
    if (self.webView) {
        if (self.webView.url.absoluteString.length == 0) {
            [self reloadOrStop];
        }
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    if (self.webView.canGoBack || self.wkWebView.canGoBack) {
        self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    }
    
    
    
    [self dismissMenuPop];
    if ([[HwTools UserDefaultsObjectForKey:IS_SHOW_NAV] isEqualToString:@"YES"]) {
        self.navigationController.navigationBarHidden = NO;
    }
    if ([[HwTools UserDefaultsObjectForKey:IS_SHOW_NAV] isEqualToString:@"NO"]) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    [MobClick beginLogPageView:@"OneView"];
    
   
}

- (void)viewDidLayoutSubviews {
    
    
    if (self.navigationController.navigationBarHidden && [self.ssBase.adaptIOS7Nav isEqualToString:@"1"] && [self.ssBase.isClosePhoneState isEqualToString:@"1"]) {
        self.view.backgroundColor = [HwTools hexStringToColor:self.ssBase.statusbarBgColor];
        if (self.ssBase.statusbarBgColor.length == 0) {
            self.view.backgroundColor = [UIColor blackColor];
        }
        if (self.wkWebView) {
            CGRect webViewRect = self.wkWebView.frame;
            webViewRect.origin.y = 20;
            if (self.wkWebView.frame.origin.y != 20) {
                webViewRect.size.height -= 20;
                self.wkWebView.frame = webViewRect;
            }
        }else {
            CGRect webViewRect = self.webView.frame;
            webViewRect.origin.y = 20;
            if (self.webView.frame.origin.y != 20) {
                webViewRect.size.height -= 20;
                self.webView.frame = webViewRect;
            }
        }
        
    }
    
}
- (void)reloadStatusBar {
    if (self.navigationController.navigationBarHidden && [self.ssBase.adaptIOS7Nav isEqualToString:@"1"]) {
        self.view.backgroundColor = [HwTools hexStringToColor:self.ssBase.statusbarBgColor];
        if (self.ssBase.statusbarBgColor.length == 0) {
            self.view.backgroundColor = [UIColor blackColor];
        }
        int height = 0;
        int webheight = 0;
        if ([UIApplication sharedApplication].statusBarHidden) {
            height = 0;
            webheight = 20;
        }else {
            height = 20;
            webheight = -20;
        }
        if (self.wkWebView) {
            CGRect webViewRect = self.wkWebView.frame;
            webViewRect.origin.y = height;
            if (self.wkWebView.frame.origin.y != height) {
                webViewRect.size.height += webheight;
                self.wkWebView.frame = webViewRect;
            }
        }else {
            CGRect webViewRect = self.webView.frame;
            webViewRect.origin.y = height;
            if (self.webView.frame.origin.y != height) {
                webViewRect.size.height += webheight;
                self.webView.frame = webViewRect;
            }
        }
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.ssBase = [StringsXML getStringXmlBase];
    StringsXmlBase *xBase = [StringsXML getStringXmlBase];
    
    if ([xBase.loaderImageType isEqualToString:@"2"] && [xBase.isCloseLoad isEqualToString:@"1"]) {
        [self.view addSubview:self.progressView];
    }
    
    
    if (((NSString *)[HwTools UserDefaultsObjectForKey:BACKGROUNDCOLOR]).length > 0) {
        self.wkWebView.scrollView.backgroundColor = [HwTools hexStringToColor:[HwTools UserDefaultsObjectForKey:BACKGROUNDCOLOR]];
        self.webView.scrollView.backgroundColor = [HwTools hexStringToColor:[HwTools UserDefaultsObjectForKey:BACKGROUNDCOLOR]];
    }
    
    
    if ([[HwTools UserDefaultsObjectForKey:IS_ENABLE_DRAG_REFRESH] isEqualToString:@"YES"]) {
        if (self.wkWebView) {
            [self.wkWebView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
            self.wkWebView.scrollView.bounces = YES;
        }else {
            [self.webView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
            self.webView.scrollView.bounces = YES;
        }
        
    }
    if ([[HwTools UserDefaultsObjectForKey:IS_ENABLE_DRAG_REFRESH] isEqualToString:@"NO"]) {
        if (self.wkWebView) {
            [self.wkWebView.scrollView removeHeader];
            self.wkWebView.scrollView.bounces = NO;
        }else {
            [self.webView.scrollView removeHeader];
            self.webView.scrollView.bounces = NO;
        }
        
    }
    
    
    [self reloadPreviousPage];
    
    [self showNavBarAnimated:NO];
    /*终止识别*/
    [self.iflyRecognizerView cancel];
    [self.iflyRecognizerView setDelegate:self];
    self.locService.delegate = self;
    [self.timeOutTimer invalidate];
    self.timeOutTimer = nil;
    
    NSString *imgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",@"launchImage"]];
    /*    NSData *data = [NSData dataWithContentsOfFile:imgPath];*/
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
    if ([stringBase.isLandscape isEqualToString:@"1"] && [[NSUserDefaults standardUserDefaults] boolForKey:stringBase.appsid]) {
        appDelegate.isFull = YES;
    }else {
        appDelegate.isFull = NO;
    }
    if ([stringBase.frontSliderState isEqualToString:@"0"] && [stringBase.isLandscape isEqualToString:@"1"]) {
        appDelegate.isFull = YES;
    }
    
    if ([xBase.isClosePhoneState isEqualToString:@"0"]) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }else {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    
}
- (void)didBecoActive {
    [self reloadOrStop];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabBarBtnClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareCallBack) name:@"sharecallback" object:nil];
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull = NO;
    
    [self.timeOutTimer invalidate];
    self.timeOutTimer = nil;
    [self hideAldClock];
    [MobClick endLogPageView:@"OneView"];
    [self.iflyRecognizerView setDelegate:nil];
    self.locService.delegate = nil;  

    [self.progressView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstStart"];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    
    [self showNavbar];
    
    return YES;
}
- (void)tabBarMoreBtnClick
{
    NSLog(@"===tabbar更多点击");
    
    [self.menuPopover showInView:self.view];
}
- (void)tabBarBtnClick {
    //RefreshMenu 0（默认值）调回当前导航    1刷新当前页面    2不操作  3返回首页并每次都刷新
    NSLog(@"===tabbar被点击====%@",self.refreshMenuStr);
    if ([self.refreshMenuStr isEqualToString:@"2"]) {
        return;
    }
    if ([self.refreshMenuStr isEqualToString:@"1"]) {
        [self reloadOrStop];
        return;
    }
    if ([self.refreshMenuStr isEqualToString:@"3"]) {
        
        if (self.wkWebView.loading) {
            [self.wkWebView stopLoading];
        }
        if (self.webView.loading) {
            [self.webView stopLoading];
        }
        if (self.wkWebView) {
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_homePage]]];
        }else {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_homePage]]];
        }
        return;
        NSString *reloadWebStr = [NSString stringWithFormat:@"window.location.reload();"];
        if (self.wkWebView) {
            if (![self.wkWebView canGoBack]) {
                [self showAldClock];
                [self.wkWebView evaluateJavaScript:reloadWebStr completionHandler:nil];
                [self hideAldClock];
                return;
            }
        }else {
            if (![self.webView canGoBack]) {
                [self showAldClock];
                [self.webView stringByEvaluatingJavaScriptFromString:reloadWebStr];
                [self hideAldClock];
                return;
            }
        }
    }
    
    if ([self.refreshMenuStr isEqualToString:@"0"]) {
        NSString *historyWebStr = [NSString stringWithFormat:@"if(window.history.length > 1){window.history.go(-(window.history.length - 1));};"];
        if (self.wkWebView) {
            if ([self.wkWebView canGoBack]) {
                [self showAldClock];
                [self.wkWebView evaluateJavaScript:historyWebStr completionHandler:nil];
            }
        }else {
            if ([self.webView canGoBack]) {
                [self showAldClock];
                [self.webView stringByEvaluatingJavaScriptFromString:historyWebStr];
            }
        }
        [self hideAldClock];
    }
    
}
- (void)dismissMenuPop {
    
    [self.menuPopover dismissMenuPopover];
    
}


#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    
    
    NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
    NSDictionary *dic = array[selectedIndex + 4];
    MyXmlBase *base = [MyXmlBase modelObjectWithDictionary:dic];
    HwOnePageViewController* twoVC = [[HwOnePageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
    twoVC.currentUrlStr = [base.weburl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    twoVC.refreshMenuStr = base.refreshMenu;
    twoVC.moreSelect = selectedIndex + 100;
    if (self.moreSelect == selectedIndex + 100) {
        [self tabBarBtnClick];
        return;
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
    [self.navigationController pushViewController:twoVC animated:YES];
    
}
- (void)nenuPopVerIsShow:(BOOL)isShow {
    
}

#pragma mark 调用视频的通知方法

- (void)videoStarted:(NSNotification *)notification {/* 开始播放*/
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull = YES;
    
}
- (void)videoFinished:(NSNotification *)notification {/*完成播放*/
    /*
     AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
     
     appDelegate.isFull =NO;
     
     if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
     
     SEL selector = NSSelectorFromString(@"setOrientation:");
     
     NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
     
     [invocation setSelector:selector];
     
     [invocation setTarget:[UIDevice currentDevice]];
     
     int val =UIInterfaceOrientationPortrait;
     
     [invocation setArgument:&val atIndex:2];
     
     [invocation invoke];
     
     }
     */
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    AKTabBarController *akTab = [self akTabBarController];
    akTab.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(videoStarted:)
     
                                                 name:@"MPRemoteCommandTargetsDidChangeNotification"
     
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished:)
     
                                                 name:UIWindowDidBecomeHiddenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarMoreBtnClick) name:@"tabBarMoreBtnClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissMenuPop) name:@"tabBarMoreBtnDismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyFrame) name:@"refreshMyFrame" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tuisongWebUrl:) name:@"tuisongWebUrl" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnClick) name:@"tabBarBtnClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecoActive) name:@"didBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toTwoview:) name:@"toTwoview" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixindenglu) name:@"weixindenglu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackView) name:@"CancelPay" object:nil];
    
    self.ssBase = [StringsXML getStringXmlBase];
    
    self.wkWebView = nil;
    self.webView = nil;
    
    
    Class wkWebViewClass = NSClassFromString(@"WKWebView");
    

    if ([self.ssBase.oldVersionWebView isEqualToString:@"1"]) {
        wkWebViewClass = nil;
    }
    
    if(wkWebViewClass) {
        
        
        
        WKUserContentController *scriptHandle = [[WKUserContentController alloc]
                                                 init];
        [scriptHandle addScriptMessageHandler:self name:@"NewCloudApp"];
        
        WKPreferences *per = [[WKPreferences alloc] init];
        per.javaScriptEnabled = YES;
        per.javaScriptCanOpenWindowsAutomatically = YES;
        
        
        
        self.wkWebView = [[wkWebViewClass alloc] initWithFrame:self.view.bounds configuration:self.webConfig];
        self.wkWebView.UIDelegate = self;
        self.wkWebView.navigationDelegate = self;
        self.wkWebView.allowsBackForwardNavigationGestures = YES;
        self.wkWebView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.wkWebView];
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:nil];
        [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        self.topConstraint = [NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self.view addConstraint:self.topConstraint];
        
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    else {
        
        self.webView = [[DLPanableWebView alloc] init];
        self.webView.translatesAutoresizingMaskIntoConstraints = NO;
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
        
        self.topConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self.view addConstraint:self.topConstraint];
        
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    
    
    UIImage *logoimage=[UIImage imageNamed:@"logo"];
    UIImageView *logoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logoimage.size.width, (logoimage.size.height > 44 ? 44 : logoimage.size.height))];
    logoImageView.image = logoimage;
    self.navigationItem.titleView = logoImageView;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackBtnItem];
    [self addMenuBtnItem];
    
    
    
    [self refreshMyFrame];
    self.currentUrlStr = [self.currentUrlStr stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
    _homePage = self.currentUrlStr;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUrlStr]];
    if (self.currentUrlStr.length > 0) {
        if (self.wkWebView) {
            [self.wkWebView loadRequest:request];
        }else {
            [self.webView loadRequest:request];
        }
        
    }
    
    if (self.wkWebView) {
        self.wkWebView.scrollView.showsVerticalScrollIndicator=YES;
        self.wkWebView.scrollView.showsHorizontalScrollIndicator=NO;
        
        self.wkWebView.scrollView.delegate = self;
        if ([self.ssBase.isCloseRefresh isEqualToString:@"1"]) {
            [self.wkWebView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
            self.wkWebView.scrollView.bounces = YES;
        }else {
            self.wkWebView.scrollView.bounces = NO;
        }
        
        [self.wkWebView addSubview:self.reloadControl];
    }else {
        self.webView.scrollView.showsVerticalScrollIndicator=YES;
        self.webView.scrollView.showsHorizontalScrollIndicator=NO;
        self.webView.scalesPageToFit = YES;
        self.webView.scrollView.delegate = self;
        self.webView.mediaPlaybackRequiresUserAction = NO;
        if ([self.ssBase.isCloseRefresh isEqualToString:@"1"]) {
            [self.webView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
            self.webView.scrollView.bounces = YES;
        }else {
            self.webView.scrollView.bounces = NO;
        }
        
        [self.webView addSubview:self.reloadControl];
    }
    
    
    if (self.wkWebView) {
        self.wkWebView.scrollView.showsVerticalScrollIndicator=YES;
        self.wkWebView.scrollView.showsHorizontalScrollIndicator=NO;
        
        self.wkWebView.scrollView.delegate = self;
        self.wkWebView.scrollView.backgroundColor = [HwTools hexStringToColor:@"#ffffff"];
        
        [self.webView addSubview:self.reloadControl];
        self.reloadControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.wkWebView addConstraint:[NSLayoutConstraint constraintWithItem:self.reloadControl
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.wkWebView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:0]];
        [self.wkWebView addConstraint:[NSLayoutConstraint constraintWithItem:self.reloadControl
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.wkWebView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1.0
                                                                    constant:0]];
    }else {
        self.webView.scrollView.showsVerticalScrollIndicator=YES;
        self.webView.scrollView.showsHorizontalScrollIndicator=NO;
        self.webView.scalesPageToFit = YES;
        self.webView.scrollView.delegate = self;
        self.webView.scrollView.backgroundColor = [HwTools hexStringToColor:@"#ffffff"];
        
        [self.webView addSubview:self.reloadControl];
        self.reloadControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.reloadControl
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.webView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0]];
        [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.reloadControl
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.webView
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:0]];
    }
    
    self.progressProxy.progressDelegate = self;
    
    
    /*
    UnpreventableUILongPressGestureRecognizer *longPressRecognizer = [[UnpreventableUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.allowableMovement = 20;
    longPressRecognizer.minimumPressDuration = 1.0f;
    if (self.wkWebView) {
        [self.wkWebView addGestureRecognizer:longPressRecognizer];
    }else {
        [self.webView addGestureRecognizer:longPressRecognizer];
    }
     */
    
    self.wkWebView.scrollView.footerPullToRefreshText = NSLocalizedString(@"MJRefreshFooterPullToRefresh", nil);
    self.wkWebView.scrollView.footerReleaseToRefreshText = NSLocalizedString(@"MJRefreshFooterReleaseToRefresh", nil);
    self.wkWebView.scrollView.footerRefreshingText = NSLocalizedString(@"MJRefreshFooterRefreshing", nil);
    self.wkWebView.scrollView.headerPullToRefreshText = NSLocalizedString(@"MJRefreshHeaderPullToRefresh", nil);
    self.wkWebView.scrollView.headerReleaseToRefreshText = NSLocalizedString(@"MJRefreshHeaderReleaseToRefresh", nil);
    self.wkWebView.scrollView.headerRefreshingText = NSLocalizedString(@"MJRefreshHeaderRefreshing", nil);
    
    if (self.wkWebView) {
        if ([self.ssBase.webviewbg isEqualToString:@"0"]) {
            self.wkWebView.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"webViewBgImg"]];
        }else {
            self.wkWebView.scrollView.backgroundColor = [HwTools hexStringToColor:self.ssBase.webviewbg];
        }
    }else {
        if ([self.ssBase.webviewbg isEqualToString:@"0"]) {
            self.webView.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"webViewBgImg"]];
        }else {
            self.webView.scrollView.backgroundColor = [HwTools hexStringToColor:self.ssBase.webviewbg];
        }
    }
    
    if (self.webView) {
        UIPanGestureRecognizer *popGesture_ = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesturesa:)];
        popGesture_.delegate = self;
        [self.webView addGestureRecognizer:popGesture_];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(wkhandleLongPress:)];
    longPress.minimumPressDuration = KLongGestureInterval;
    longPress.allowableMovement = 20.f;
    longPress.delegate = self;
    [self.wkWebView addGestureRecognizer:longPress];
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)panGesturesa:(UIPanGestureRecognizer *)sender{
    if (sender.state ==UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self.webView];
        if (point.x > 25) {
            _isCanWebviewBcak = NO;
        }else {
            _isCanWebviewBcak = YES;
        }
    }
    if (_isCanWebviewBcak && !_isHomePage) {
        if (self.webView) {
            [self.webView panGesture:sender];
        }
    }
}
- (void)addBackBtnItem {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 8, 40, 40)];
    
    
    [button setImage:[UIImage imageNamed:@"icon_goback"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_goback"] forState:UIControlStateHighlighted];
    [button setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [button setTintColor:[UIColor whiteColor]];
    
    [button sizeToFit];
    
    [button addTarget:self action:@selector(goBackView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnItem;
    
}
- (void)addMenuBtnItem {

    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 8, 40, 40)];
    [button setImage:[UIImage imageNamed:@"ck"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(3, 0, 3, -30)];
    [button addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isleftOrrightMenu) {
        self.navigationItem.leftBarButtonItem = btnItem;
        [button setImageEdgeInsets:UIEdgeInsetsMake(3, -30, 3, 0)];
        self.navigationItem.leftBarButtonItem.customView.hidden = NO;
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }else{
        self.navigationItem.rightBarButtonItem = btnItem;
    }

    
}
- (void)showMenu {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isleftOrrightMenu) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
        
        }];
    }else{
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
    
    
        }];
    }

}
- (void)goBackView
{
    if (self.wkWebView) {
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        }
    }else {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }
    

}
- (void)updateLoadingStatus
{
    if (self.jsCustomTitleStr.length > 0) {
        self.navigationItem.titleView = nil;
        self.title = self.jsCustomTitleStr;
    }else {
        UIImage *logoimage=[UIImage imageNamed:@"logo"];
        UIImageView *logoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logoimage.size.width, (logoimage.size.height > 44 ? 44 : logoimage.size.height))];
        logoImageView.image = logoimage;
        self.navigationItem.titleView = logoImageView;
    }
    if (self.webView.canGoBack || self.wkWebView.canGoBack) {
        [self showBackMenu];
    }else {
        [self hideBackMenu];
        UIImage *logoimage=[UIImage imageNamed:@"logo"];
        UIImageView *logoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logoimage.size.width, (logoimage.size.height > 44 ? 44 : logoimage.size.height))];
        logoImageView.image = logoimage;
        self.navigationItem.titleView = logoImageView;
    }
    
    UIImageView *imagePayView = (UIImageView *)[self.view viewWithTag:1000];
    if (imagePayView) {
        [imagePayView removeFromSuperview];
    }
    
}
- (void)reloadOrStop {
    if (self.webView.request.URL.absoluteString.length > 0 || self.wkWebView.URL.absoluteString.length > 0) {
        
        if (self.wkWebView) {
            if (self.wkWebView.loading)
            {
                
            }
            else {
                [self.wkWebView stopLoading];
                [self.wkWebView reload];
            };
        }else {
            if (self.webView.loading)
            {
                
            }
            else {
                [self.webView stopLoading];
                [self.webView reload];
            };
        }
        
    }else {
        if (self.wkWebView) {
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUrlStr]]];
        }else {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUrlStr]]];
        }
        
        
    }
    
}
#pragma mark -webView-
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if (navigationType != UIWebViewNavigationTypeBackForward) {
        
    }
    StringsXmlBase *basesss= [StringsXML getStringXmlBase];
    if ([basesss.IsCopy isEqualToString:@"0"]) {
        // 禁用用户选择
        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
        
        // 禁用长按弹出框
        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
        
    }
    self.jsCustomTitleStr = @"";
    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"=========%@",urlString);

    NSRange urlRange = [urlString rangeOfString:@"http://"];
    NSRange urlhktv = [urlString rangeOfString:@"%25"];
    
    if (urlString.length != 0 && ![urlString isEqualToString:@"about:blank"] && urlRange.location!=NSNotFound && urlhktv.location == NSNotFound && [urlString rangeOfString:@"#"].location == NSNotFound) {
        self.shareUrlStr = urlString;
        self.currentUrlStr = urlString;
    }
    NSRange range=[urlString rangeOfString:@"tel:"];
    if(range.location!=NSNotFound){
        return YES;
    }
    /*招行一网通插件*/
    if ([request.URL.host isCaseInsensitiveEqualToString:@"cmbls"]) {
        CMBWebKeyboard *secKeyboard = [CMBWebKeyboard shareInstance];
        [secKeyboard showKeyboardWithRequest:request];
        secKeyboard.webView = _webView;
        UITapGestureRecognizer* myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.view addGestureRecognizer:myTap];
        myTap.delegate = self;
        myTap.cancelsTouchesInView = NO;
        return NO;
    }
    NSArray *urlComps = [urlString componentsSeparatedByString:@":%23%23//"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"app9vcom"])
        
    {
        float ydbPackageId = [[NSUserDefaults standardUserDefaults] floatForKey:@"YdbPackageID"];
        if (ydbPackageId <= 1) {
            return NO;
        }
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"/?"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        if(2 == [arrFucnameAndParameter count])
        {
            /*有参数的*/
            if([funcStr isEqualToString:@"PushMsgConfig"] && [arrFucnameAndParameter objectAtIndex:1])
            {
                /*调用本地函数*/
                [self PushMsgConfig:[arrFucnameAndParameter objectAtIndex:1]];
            }
            
            /*全局定义*/
            if ([funcStr isEqualToString:@"SetGlobal"]) {
                NSLog(@"===%@",[arrFucnameAndParameter objectAtIndex:1]);
                NSArray *globalArray = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@","];
                /*是否显示标题栏：0隐藏  1显示*/
                if ([globalArray[0] isEqualToString:@"0"]) {
                    
                    self.navigationController.navigationBarHidden = YES;
                    [HwTools UserDefaultsObj:@"NO" key:IS_SHOW_NAV];
                    /*标识为隐藏顶部导航的例外*/
                    NSRange range=[urlString rangeOfString:globalArray[2]];
                    if(range.location!=NSNotFound){
                        self.navigationController.navigationBarHidden = NO;
                    }
                    
                    
                    
                }else {
                    self.navigationController.navigationBarHidden = NO;
                    [HwTools UserDefaultsObj:@"YES" key:IS_SHOW_NAV];
                }
                /*是否开启下拉刷新：0关闭  1开启*/
                if ([globalArray[1] isEqualToString:@"0"]) {
                    [self.webView.scrollView removeHeader];
                    self.webView.scrollView.bounces = NO;
                    [HwTools UserDefaultsObj:@"NO" key:IS_ENABLE_DRAG_REFRESH];
                    /*下拉刷新例外*/
                    NSRange range=[urlString rangeOfString:globalArray[3]];
                    if(range.location!=NSNotFound){
                        [self.webView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
                        self.webView.scrollView.bounces = YES;
                    }
                }else {
                    [self.webView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
                    [HwTools UserDefaultsObj:@"YES" key:IS_ENABLE_DRAG_REFRESH];
                    self.webView.scrollView.bounces = YES;
                }
                NSLog(@"====%@",globalArray[2]);
                
                
                /*加载样式0云加载1黑框加载*/
                if ([globalArray[4] isEqualToString:@"0"]) {
                    
                    [HwTools UserDefaultsObj:@"NO" key:IS_ENABLE_CLOSE];
                }else {
                    
                    [HwTools UserDefaultsObj:@"YES" key:IS_ENABLE_CLOSE];
                }
                if (globalArray.count > 7) {
                    if (((NSString *)globalArray[7]).length > 0) {
                        [HwTools UserDefaultsObj:globalArray[7] key:BACKGROUNDCOLOR];
                        self.webView.scrollView.backgroundColor = [HwTools hexStringToColor:globalArray[7]];
                    }
                }
            }
            /*是否下拉刷新,0为关闭，1为开启*/
            if ([funcStr isEqualToString:@"SetDragRefresh"]) {
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"0"]) {
                    [self.webView.scrollView removeHeader];
                    self.webView.scrollView.bounces = NO;
                }else {
                    [self.webView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
                    self.webView.scrollView.bounces = YES;
                    
                }
                
            }
            /*隐藏顶部标题栏*/
            if ([funcStr isEqualToString:@"SetHeadBar"]) {
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"0"]) {
                    self.navigationController.navigationBarHidden = YES;
                }else {
                    self.navigationController.navigationBarHidden = NO;
                }
                
            }
            
            /*隐藏底部菜单栏*/
            if ([funcStr isEqualToString:@"SetMenuBar"]) {
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"0"]) {
                    
                    [self hideTabBar:YES];
                }else {
                    [self hideTabBar:NO];
                }
                
            }
            /*隐藏更多*/
            if ([funcStr isEqualToString:@"SetMoreButton"]) {
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"0"]) {
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                }else {
                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
                    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModeTapCenterView];
                }
                
            }
            /*显示右上角菜单*/
            if ([funcStr isEqualToString:@"ShowTopRightMenu"]) {
                [self showMenu];
                
            }
            
            /*导航菜单动态隐藏*/
            if ([funcStr isEqualToString:@"MenuBarAutoHide"]) {
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"0"]) {
                    [self stopFollowingScrollView];
                    _isScrollUpOrDown = NO;
                }else {
                    [self followScrollView:self.webView usingTopConstraint:self.topConstraint];
                    _isScrollUpOrDown = YES;
                }
                
            }
            /*返回前一页面*/
            if ([funcStr isEqualToString:@"GoBack"]) {
                [self goBackView];
                
            }
            /*返回顶级页面*/
            if ([funcStr isEqualToString:@"GoTop"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            
            /*扫一扫无返回值*/
            if ([funcStr isEqualToString:@"Scan"]) {
                [self scanOneScan:NO];
                
            }
            /*扫一扫有返回值*/
            if ([funcStr isEqualToString:@"GetScan"]) {
                
                if (arrFucnameAndParameter.count == 2) {
                    self.jsMethodNameStr = [arrFucnameAndParameter objectAtIndex:1];
                    [self scanOneScan:YES];
                }
            }
            if ([funcStr isEqualToString:@"GetHalfScan"]) {
                NSArray *globalArray = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@","];
                
                HwReaderView *rView = [[HwReaderView alloc] initWithFrame:CGRectMake(0, [globalArray[1] floatValue], [UIScreen mainScreen].bounds.size.width, [globalArray[2] floatValue])];
                rView.completionHandler = ^(NSString *itemStr) {
                    NSString *str = [NSString stringWithFormat:@"%@('%@')",globalArray[0],itemStr];
                    [rView removeFromSuperview];
                    [self.webView stringByEvaluatingJavaScriptFromString:str];
                };
                [self.view addSubview:rView];
                
            }
            if ([funcStr isEqualToString:@"CloseScan"]) {
                for (UIView *vi in self.view.subviews) {
                    if ([vi isKindOfClass:[HwReaderView class]]) {
                        [vi removeFromSuperview];
                    }
                }
            }
            /*图片预览*/
            if ([funcStr isEqualToString:@"ImageViewState"]) {
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"0"]) {
                    _is9vImg = YES;
                    [self is9vImgDelay];
                }
                
            }
            if ([funcStr isEqualToString:@"SetFontSize"]) {
                
                [self webviewFontSize];
            }
            if ([funcStr isEqualToString:@"SetBrightness"]) {
                [self screenBrightness:[arrFucnameAndParameter objectAtIndex:1]];
                
            }
            /*是否刷新前一页面*/
            if ([funcStr isEqualToString:@"IsReloadPreviousPage"]) {
                if (((NSString *)[arrFucnameAndParameter objectAtIndex:1]).length > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:[arrFucnameAndParameter objectAtIndex:1] forKey:@"IsReloadPreviousPage"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            /*是否刷新前一页面*/
            if ([funcStr isEqualToString:@"IsReloadNextPage"]) {
                if (((NSString *)[arrFucnameAndParameter objectAtIndex:1]).length > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:[arrFucnameAndParameter objectAtIndex:1] forKey:@"IsReloadNextPage"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            if ([funcStr isEqualToString:@"SingleShare"]) {
                
                NSArray *globalArray = [[arrFucnameAndParameter objectAtIndex:1]  componentsSeparatedByString:@","];
                
                ShareModel *model = [[ShareModel alloc] init];
                if (globalArray.count > 3) {
                    model.sTitle = [globalArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    model.sContent = [globalArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    model.sImage = [globalArray[2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    model.sUrl = [globalArray[3] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
                if (globalArray.count > 4  ) {
                    jsstr = [globalArray lastObject];
                    int platfrom = [globalArray[4] intValue];
                    UIView *vi = [[UIView alloc] init];
                    vi.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
                    vi.bounds = CGRectMake(0, 0, 0, 0);
                    [self.view addSubview:vi];
                    [[HwTools shareTools] danduFenxiang:platfrom fromView:vi shareModel:model];
                    [self shareCallBack];
                }
            }
            /*分享*/
            if ([funcStr isEqualToString:@"Share"]) {
                NSArray *globalArray = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@","];
                
                ShareModel *model = [[ShareModel alloc] init];
                model.sTitle = [globalArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                model.sContent = [globalArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                model.sImage = [globalArray[2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                model.sUrl = [globalArray[3] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                jsstr = [globalArray lastObject];
                [self shareToShare:model];
                [self shareCallBack];
                
            }
            /*清理缓存*/
            if ([funcStr isEqualToString:@"ClearCache"]) {
//                [self setNavbarTitleColor:nil];
//                [self clearCache];
                [self setLeftOrRightSideView];
                
            }
            /*支付宝*/
            if ([funcStr isEqualToString:@"SetAlipayInfo"]) {
                NSString *arrFucn = [[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSArray *globalArray = [arrFucn componentsSeparatedByString:@"[,]"];
                [self goalipay:@[globalArray[0],globalArray[1],globalArray[2],globalArray[3]]];
            }
            /*微信支付*/
            if ([funcStr isEqualToString:@"SetWxpayInfo"]) {
                NSString *arrFucn = [[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSArray *globalArray = [arrFucn componentsSeparatedByString:@"[,]"];
                [self sendPay_demo:@[[globalArray[0]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[globalArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[globalArray[2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[globalArray[3] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[globalArray[4] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            }
            /*微信支付*/
            if ([funcStr isEqualToString:@"CiticWxPay"]) {
                NSString *arrFucn = [[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSArray *globalArray = [arrFucn componentsSeparatedByString:@"[,]"];
                [self citicWxPay:globalArray];
            }
            if ([funcStr isEqualToString:@"WftWxpayInfo"]) {
                NSString *arrFucn = [[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSArray *globalArray = [arrFucn componentsSeparatedByString:@"[,]"];
                [self wftWxPay:globalArray];
            }
            if ([funcStr isEqualToString:@"BeeCloudPay"]) {
                NSString *arrFucn = [[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSArray *globalArray = [arrFucn componentsSeparatedByString:@"[,]"];
                [self doBCPay:globalArray];
            }
            /**微信登陆 **/
            if ([funcStr isEqualToString:@"WXLogin"]) {
                NSArray *globalArray = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@","];
                [self sendAuthRequest:@[globalArray[0],globalArray[1]]];
                if ([self.webView canGoBack]) {
                    [self.webView goBack];
                }
            }
            /*语音识别*/
            if ([funcStr isEqualToString:@"SpeechRecognition"]) {
                
                if (arrFucnameAndParameter.count == 2) {
                    self.jsMethodNameStr = [arrFucnameAndParameter objectAtIndex:1];
                    [self mscVoice];
                }
                
            }
            /*地理位置*/
            if ([funcStr isEqualToString:@"GetGPS"]) {
                [self startLoc];
                
                
                
                if (arrFucnameAndParameter.count == 2) {
                    self.jsMethodNameStr = [arrFucnameAndParameter objectAtIndex:1];
                    self.isGetGPS = YES;
                }
                
            }
            
            /*时时定位or地理位置*/
            if ([funcStr isEqualToString:@"OpenGPS"]) {
                _isTimeLoc = YES;
                if (arrFucnameAndParameter.count == 2) {
                    _locUserId = [arrFucnameAndParameter objectAtIndex:1];
                    if (_locUserId.length == 0) {
                        _locUserId = @"1";
                    }
                }
                [self startLoc];
            }
            /*关闭定位*/
            if ([funcStr isEqualToString:@"CloseGPS"]) {
                _isTimeLoc = NO;
                [self stopLoc];
            }
            if ([funcStr isEqualToString:@"SetBgColor"]) {
                self.webView.scrollView.backgroundColor = [HwTools hexStringToColor:[arrFucnameAndParameter objectAtIndex:1]];
            }
            /*获取设备信息*/
            if ([funcStr isEqualToString:@"GetDeviceInformation"]) {
                NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                NSString *str = [NSString stringWithFormat:@"%@('%@')",[arrFucnameAndParameter objectAtIndex:1],identifier];
                [self.webView stringByEvaluatingJavaScriptFromString:str];
            }
            /*获取WIFI信息*/
            if ([funcStr isEqualToString:@"GetWifiSsid"]) {
                NSString *str = [NSString stringWithFormat:@"%@('%@')",[arrFucnameAndParameter objectAtIndex:1],[self getDeviceSSID]];
                [self.webView stringByEvaluatingJavaScriptFromString:str];
            }
            /*获取指纹信息*/
            if ([funcStr isEqualToString:@"UseTouchID"]) {
                NSArray *golay = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@","];
                NSLog(@"%@",[arrFucnameAndParameter objectAtIndex:1]);
                [self setzhiwen:golay];
            }
            /*获取步数信息*/
            if ([funcStr isEqualToString:@"GetHealthStep"]) {
                jsstr =[NSString stringWithFormat:@"%@",[arrFucnameAndParameter objectAtIndex:1]
                        ];
                NSLog(@"%@",[arrFucnameAndParameter objectAtIndex:1]);
                [self queryHealthStepCount];
            }
            /*QQ登陆*/
            if ([funcStr isEqualToString:@"QQLogin"]) {
                NSString *url =[NSString stringWithFormat:@"%@",[arrFucnameAndParameter objectAtIndex:1]
                                ];
                NSLog(@"%@",[arrFucnameAndParameter objectAtIndex:1]);
                NSLog(@"-%@-",url);
                [HwTools UserDefaultsObj:url key:@"qqweburl"];
                [[HwTools shareTools] initQQloading];
                
                if ([self.webView canGoBack]) {
                    [self.webView goBack];
                }
            }
            /*显示隐藏返回*/
            if ([funcStr isEqualToString:@"SetReturnButtonMode"]) {
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"0"]) {
                    _isShowBackMenu = NO;
                    [self hideBackMenu];
                }else {
                    _isShowBackMenu = YES;
                    [self showBackMenu];
                }
            }
            if ([funcStr isEqualToString:@"SetStatusBarStyle"]) {
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"0"]) {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                    /*self.webView.enablePanGesture = NO;*/
                }else {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    /*self.webView.enablePanGesture = YES;*/
                }
            }
            /*上传图片*/
            if ([funcStr isEqualToString:@"UploadImage"]) {
                NSArray *globalArray = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@","];
                [self.imageUploadPluginArray removeAllObjects];
                [globalArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.imageUploadPluginArray addObject:obj];
                }];
                [self addImgBtnClick];
            }
            /*用浏览器打开*/
            if ([funcStr isEqualToString:@"OpenWithSafari"]) {
                [self openWithSafari:[arrFucnameAndParameter objectAtIndex:1]];
            }
            if ([funcStr isEqualToString:@"openWithUcBrower"]) {
                NSArray *globalArray = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@","];
                [self openWithUcBrower:globalArray];
            }
            if ([funcStr isEqualToString:@"copyPasteboardText"]) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [arrFucnameAndParameter objectAtIndex:1];
                
            }
            if ([funcStr isEqualToString:@"statusBarHidden"]) {
                if ([[arrFucnameAndParameter objectAtIndex:1] isEqualToString:@"0"]) {
                    [UIApplication sharedApplication].statusBarHidden = YES;
                }else {
                    [UIApplication sharedApplication].statusBarHidden = NO;
                }
                [self reloadStatusBar];
            }
            if ([funcStr isEqualToString:@"OpenNewWindow"]) {
                _isOpenNewWindow = YES;
            }
            /*获取个推cid*/
            if ([funcStr isEqualToString:@"GetClientIDOfGetui"]) {
                NSString *clientIdStr = nil;
                clientIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MYCLIENTID"];
                NSString *str = [NSString stringWithFormat:@"%@('%@')",[arrFucnameAndParameter objectAtIndex:1],clientIdStr];
                [self.webView stringByEvaluatingJavaScriptFromString:str];
            }
            /*融云*/
            if ([funcStr isEqualToString:@"RongyunLogin"]) {
                NSArray *globalArray = [[arrFucnameAndParameter objectAtIndex:1] componentsSeparatedByString:@","];
                [[RongyunDev sharedObject]requestToken:globalArray[0] andName:globalArray[1] andtoken:globalArray[2]andportaitUrl:globalArray[3]];
            }
            if ([funcStr isEqualToString:@"InitiateChat"]) {
                NSArray *globalArray = [[[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
                NSLog(@"---®%@",globalArray);
                ChatViewController *view = [[RongyunDev sharedObject]creatChat:globalArray[0] andChatName:globalArray[1]andheadurl:[globalArray lastObject]];
                self.navigationController.navigationBarHidden = NO;
                [self.navigationController pushViewController:view animated:YES];
                
            }
            if ([funcStr isEqualToString:@"SessionList"]) {
                ChatListViewController *listView = [[ChatListViewController alloc]init];
                self.navigationController.navigationBarHidden = NO;
                [self.navigationController pushViewController:listView animated:YES];
            }
            if ([funcStr isEqualToString:@"RefreshUserInfo"]) {
                NSArray *globalArray = [[[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
                [[RongyunDev sharedObject] setUserid:globalArray[0] andname:globalArray[1] andportraitUrl:globalArray[2]];
                
            }
            if ([funcStr isEqualToString:@"CreateDiscussGroup"]) {
                NSArray *globalArray = [[[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
                NSArray *userid = [globalArray[0] componentsSeparatedByString:@"|"];
                NSString *distargetID = globalArray[2];
                [[RCIMClient sharedRCIMClient] createDiscussion:globalArray[1] userIdList:userid success:^(RCDiscussion *discussion) {
                    RCDiscussion *dis = (RCDiscussion *)discussion;
                    NSString *discussionID = [NSString stringWithFormat:@"%@('%@')",distargetID,dis.discussionId];
                    [self.wkWebView evaluateJavaScript:discussionID completionHandler:^(id obj, NSError *  error) {
                        NSLog(@"---%@",error);
                    }];
                } error:^(RCErrorCode status) {
                    
                }];
                
            }
            if ([funcStr isEqualToString:@"OpenDiscussGroup"]) {
                NSArray *globalArray = [[[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
                ChatViewController *view = [[RongyunDev sharedObject] creatchatRoom:globalArray[0] andRoomName:globalArray[1]];
                self.navigationController.navigationBarHidden = NO;
                [self.navigationController pushViewController:view animated:YES];
            }
            if ([funcStr isEqualToString:@"AddDiscussGroup"]) {
                NSArray *globalArray = [[[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
                [[RongyunDev sharedObject] addDiscussion:globalArray andDiscussionName:globalArray[0]andheadurl:[globalArray lastObject]];
                
            }
            if ([funcStr isEqualToString:@"RemoveDiscussGroup"]) {
                NSArray *globalArray = [[[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
                [[RongyunDev sharedObject] remDiscussion:globalArray[1] andDiscussionName:globalArray[0]];
            }
            if ([funcStr isEqualToString:@"IntPortraitUri"]) {
                NSArray *globalArray = [[[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
                [[RongyunDev sharedObject] setUserid:globalArray[0] andname:globalArray[1] andportraitUrl:globalArray[2]];
            }
            /*气泡提醒*/
            /*
             气泡所处位置：（索引，从0开始，多个以逗号分隔）
             显示气泡数量：（显示数字，多个以逗号分隔）
             */
            if ([funcStr isEqualToString:@"PopUp"]) {
                
                NSString *arrFucnameAndParameterStr = [[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                /*0|1,0|1*/
                AKTabBarController *akTab = [self akTabBarController];
                
                NSArray *globalArray = [arrFucnameAndParameterStr componentsSeparatedByString:@","];
                
                
                NSRange range=[globalArray[0] rangeOfString:@"|"];
                if(range.location!=NSNotFound){
                    NSArray *indexArray = [[globalArray objectAtIndex:0] componentsSeparatedByString:@"|"];
                    NSArray *badgeArray = [[globalArray objectAtIndex:1] componentsSeparatedByString:@"|"];
                    if (indexArray.count == badgeArray.count) {
                        for (int i = 0; i < indexArray.count; i++) {
                            [akTab setBadgeValue:badgeArray[i] forItemAtIndex:[indexArray[i] intValue]];
                        }
                    }
                    
                    
                }else {
                    [akTab setBadgeValue:globalArray[1] forItemAtIndex:[globalArray[0] intValue]];
                }
                
                
                
                
                
                
                
                
                
            }
            
            
        }
        
        return NO;
        
    };
    NSRange wwebqq = [urlString rangeOfString:@"mqqwpa://im/chat"];
    if (wwebqq.location != NSNotFound) {
        [self.navigationController popViewControllerAnimated:NO];
        return YES;
    }
    
    
    NSArray *vImgUrlComps = [urlString componentsSeparatedByString:@":9vimg"];
    
    if([vImgUrlComps count] && [[vImgUrlComps objectAtIndex:0] isEqualToString:@"app9vcom"])
        
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[vImgUrlComps objectAtIndex:1] componentsSeparatedByString:@"$$"];
        if(2 == [arrFucnameAndParameter count])
        {
            
            [self picShow:[arrFucnameAndParameter objectAtIndex:0] current:[arrFucnameAndParameter objectAtIndex:1]];
            
        }
        return NO;
        
    };
    
    NSRange schemeRange=[[[request URL] scheme] rangeOfString:@"itms-apps"];
    if (schemeRange.location!=NSNotFound) {
        [webView stopLoading];
        NSArray *urlArray = [request.URL.absoluteString componentsSeparatedByString:@"/"];
        NSString *appid = nil;
        for (NSString *urlStr in urlArray) {
            NSRange appidRange=[urlStr rangeOfString:@"id"];
            if(appidRange.location!=NSNotFound){
                appid = [urlStr stringByReplacingOccurrencesOfString:@"id" withString:@""];
            }
        }
        appid = [[appid componentsSeparatedByString:@"?"] firstObject];
        SKStoreProductViewController *storeVC = [[SKStoreProductViewController alloc] init];
        storeVC.delegate = self;
        [storeVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appid}
                           completionBlock:^(BOOL result, NSError *error) {
                               
                           }];
        
        [self presentViewController:storeVC animated:YES completion:nil];
        
        return NO;
    }
    
    
    
    /*
     是否显示顶部导航   0隐藏1显示
     是否开启下拉刷新   0关闭1开启
     是否显示更多按钮
     气泡提醒
     www.yundabao.com/api/jssdkdemo/default.htm?YDBSetHeadBar=0&YDBSetDragRefresh=0&YDBSetMoreButton=0&YDBSetPopUp=0
     */
    NSRange headBarrange=[urlString rangeOfString:@"YDBSetHeadBar"];
    NSRange dragRefreshrange=[urlString rangeOfString:@"YDBSetDragRefresh"];
    NSRange moreButtonBarrange=[urlString rangeOfString:@"YDBSetMoreButton"];
    NSRange popUprange=[urlString rangeOfString:@"YDBSetPopUp"];
    NSRange ytitlerange=[urlString rangeOfString:@"YDBSetTitle"];
    if(headBarrange.location != NSNotFound || dragRefreshrange.location != NSNotFound || moreButtonBarrange.location != NSNotFound || popUprange.location != NSNotFound || ytitlerange.location != NSNotFound) {
        NSArray *ydbArray = [urlString componentsSeparatedByString:@"?"];
        NSArray *ydbStrArray = [[ydbArray lastObject] componentsSeparatedByString:@"&"];
        
        float ydbPackageId = [[NSUserDefaults standardUserDefaults] floatForKey:@"YdbPackageID"];
        if (ydbPackageId <= 1) {
            return NO;
        }
        
        
        NSString *ydbSetHeadBarStr = nil;
        NSString *ydbSetDragRefreshStr = nil;
        NSString *ydbSetMoreButtonStr = nil;
        NSString *ydbSetPopUpStr = nil;
        NSString *ydbSetTitleStr = nil;
        
        for (NSString *localStr in ydbStrArray) {
            
            
            NSRange lheadBarrange=[localStr rangeOfString:@"YDBSetHeadBar"];
            NSRange ldragRefreshrange=[localStr rangeOfString:@"YDBSetDragRefresh"];
            NSRange lmoreButtonBarrange=[localStr rangeOfString:@"YDBSetMoreButton"];
            NSRange lpopUprange=[localStr rangeOfString:@"YDBSetPopUp"];
            NSRange lTitelerange=[localStr rangeOfString:@"YDBSetTitle"];
            
            if(lheadBarrange.location != NSNotFound){
                ydbSetHeadBarStr = [localStr componentsSeparatedByString:@"="][1];
            }
            if(ldragRefreshrange.location != NSNotFound){
                ydbSetDragRefreshStr = [localStr componentsSeparatedByString:@"="][1];
            }
            if(lmoreButtonBarrange.location != NSNotFound){
                ydbSetMoreButtonStr = [localStr componentsSeparatedByString:@"="][1];
            }
            if(lpopUprange.location != NSNotFound){
                ydbSetPopUpStr = [localStr componentsSeparatedByString:@"="][1];
            }
            if(lTitelerange.location != NSNotFound){
                ydbSetTitleStr = [localStr componentsSeparatedByString:@"="][1];
            }
        }
        
        
        
        HwTwoPageViewController* twoVC = [[HwTwoPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
        twoVC.hidesBottomBarWhenPushed = YES;
        
        
        twoVC.urlStr = [[request.URL.absoluteString componentsSeparatedByString:@"?"] firstObject];
        twoVC.ydbSetPopUpStr = ydbSetPopUpStr;
        twoVC.ydbSetTitleStr = ydbSetTitleStr;
        twoVC.ydbSetHeadBarStr = ydbSetHeadBarStr;
        twoVC.ydbSetMoreButtonStr = ydbSetMoreButtonStr;
        twoVC.ydbSetDragRefreshStr = ydbSetDragRefreshStr;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            
        }
        [self.navigationController pushViewController:twoVC animated:NO];
        
        
        
        return NO;
    }
    
    /*
     NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
     if (array.count  == 1) {
     NSURL *urlNewTab = [request URL];
     if ([[urlNewTab scheme] isEqualToString:@"newtab"]) {
     
     
     NSLog(@"====%@===%@",urlNewTab,[urlNewTab scheme]);
     NSString *urlString = [[urlNewTab resourceSpecifier] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     urlNewTab = [NSURL URLWithString:urlString relativeToURL:[webView url]];
     
     NSLog(@"====%@",urlNewTab)    ;
     
     
     HwTwoPageViewController* twoVC = [[HwTwoPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
     twoVC.hidesBottomBarWhenPushed = YES;
     twoVC.urlStr = urlNewTab.absoluteString;
     if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
     self.navigationController.interactivePopGestureRecognizer.delegate = nil;
     
     }
     [self.navigationController pushViewController:twoVC animated:YES];
     
     
     return NO;
     }else {
     return YES;
     }
     }
     */
    /*
     if (self.navigationController.viewControllers.count == 2) {
     return YES;
     }
     
     
     if (navigationType == UIWebViewNavigationTypeLinkClicked) {
     
     HwTwoPageViewController* twoVC = [[HwTwoPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
     twoVC.hidesBottomBarWhenPushed = YES;
     twoVC.urlStr = request.URL.absoluteString;
     if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
     self.navigationController.interactivePopGestureRecognizer.delegate = nil;
     
     }
     [self.navigationController pushViewController:twoVC animated:YES];
     
     return NO;
     }
     */
    
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _isShowBackMenu = YES;
    [self updateLoadingStatus];
    self.reloadControl.hidden = YES;
    
    if (self.timeOutTimer && self.timeOutTimer.isValid) {
        [self.timeOutTimer invalidate];
        self.timeOutTimer = nil;
    }
    if ([self.ssBase.RemindState isEqualToString:@"1"]) {
        self.timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:self.ssBase.RemindTime.floatValue target:self selector:@selector(timeOutShowAlert) userInfo:nil repeats:NO];
    }
}
- (void)timeOutShowAlert {
    if (self.webView.scrollView.headerRefreshing || self.wkWebView.scrollView.headerRefreshing) {
        if (self.wkWebView) {
            [self.wkWebView.scrollView headerEndRefreshing];
        }else {
            [self.webView.scrollView headerEndRefreshing];
        }
        
    }
    [self.timeoutAlertView show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self reloadNextPage];
    
    
    [self.timeOutTimer invalidate];
    self.timeOutTimer = nil;
    [self updateLoadingStatus];
    self.reloadControl.hidden = YES;
    [self removeUnicomWo];
    
    self.shareUrlStr = [self.webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.sModel.sTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    delegate.sModel.sContent = NSLocalizedString(@"shareEnterContent", nil);
    delegate.sModel.sUrl = self.shareUrlStr;
    
    
    StringsXmlBase *basesss= [StringsXML getStringXmlBase];
    if ([basesss.IsCopy isEqualToString:@"0"]) {
        // 禁用用户选择
        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
        
        // 禁用长按弹出框
        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
        
    }
    if (![basesss.TaobaoJs isEqualToString:@"0"] && basesss.TaobaoJs.length > 0) {
        int ranNum1 = (int)(1 + (arc4random() % (10000000)));
        NSString *js1 = [NSString stringWithFormat:@""
                         "var myScript= document.createElement('SCRIPT');"
                         "myScript.type = 'text/javascript';"
                         "myScript.src='%@?t=q%d';"
                         "document.body.appendChild(myScript);",basesss.TaobaoJs,ranNum1];
        [webView stringByEvaluatingJavaScriptFromString:js1];
    }

    if (_is9vImg) {
        [self performSelector:@selector(is9vImgDelay) withObject:nil afterDelay:0.5f];
    }
    /*界面注入JS*/
    NSString *jsUrl = [NSString stringWithFormat:@"https://static.ydbimg.com/Scripts/SetDefaultStyles.js?IsCopy=%@&IsBorder=0&TranslucentBackground=%@&iOSOriginalStyle=%@",basesss.IsCopy,basesss.TranslucentBackground,basesss.iOSOriginalStyle];
    NSString *jsStr = [NSString stringWithFormat:@""
                       "var myScript= document.createElement('SCRIPT');"
                       "myScript.type = 'text/javascript';"
                       "myScript.src='%@';"
                       "document.body.appendChild(myScript);",jsUrl];
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    NSString *Homepage = [self URLDecodedString:basesss.HomePage];
    
    if ([self.webView canGoBack]) {
        if ([[webView.request.URL absoluteString] isEqualToString:Homepage]) {
            _isHomePage = YES;
            [self hideBackMenu];
        }else{
            _isHomePage = NO;
        }
    }
    return;
    NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
    if (array.count  == 1) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ModifyLinkTargets" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        [webView stringByEvaluatingJavaScriptFromString:jsCode];
        
        [webView stringByEvaluatingJavaScriptFromString:@"MyIPhoneApp_ModifyLinkTargets()"];
        [webView stringByEvaluatingJavaScriptFromString:@"MyIPhoneApp_ModifyWindowOpen()"];
    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.timeOutTimer invalidate];
    self.timeOutTimer = nil;
    [self hideAldClock];
    [self updateLoadingStatus];
    if (error.code == NSURLErrorCancelled) {
        
        return;
    }
    
    
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    self.reloadControl.hidden = NO;
}

- (void)is9vImgDelay {
    [self create9vImgJavaScript];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo
{
    
    NSLog(@"==didFinishPickingImage==");
    
    
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    NSLog(@"==progress===%f",progress);
    StringsXmlBase *xBase = [StringsXML getStringXmlBase];
    float wbProgress = 0.8;
    if (xBase.RemindPercent.floatValue > 0) {
        wbProgress = xBase.RemindPercent.floatValue/100;
    }
    if (progress == 0.0) {
        [self hideAldClock];
    }
    if (progress > 0.0 && progress < wbProgress) {
        [self showAldClock];
    }
    if (progress >= wbProgress) {
        [self hideAldClock];
        
        [self.timeOutTimer invalidate];
        self.timeOutTimer = nil;
    }
    [self.progressView setProgress:progress animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if (_isScrollUpOrDown) {
        static float newY = 0;
        
        newY = scrollView.contentOffset.y;
        if (newY != _oldY) {
            if (newY > _oldY && (newY - _oldY) > 100) {
                NSLog(@"Down");
                [self hideTabBar:YES];
                _oldY = newY;
            } else if (newY < _oldY && (_oldY - newY) > 100) {
                NSLog(@"Up");
                _oldY = newY;
                [self hideTabBar:NO];
            }
        }
    }
    
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -clockCloud-

- (void)showAldClock
{
    
    StringsXmlBase *basesss= [StringsXML getStringXmlBase];
    if ([basesss.isCloseLoad isEqualToString:@"0"]) {
        return;
    }
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.isHideHud) {
        return;
    }
    
    if (!self.webView && !self.wkWebView) {
        StringsXmlBase *stringBase = [StringsXML getStringXmlBase];
        if ([stringBase.loaderImageType isEqualToString:@"0"]) {
            [ClockView show];
            
        }
        if([self.ssBase.loaderImageType isEqualToString:@"1"]) {
            [[UIApplication sharedApplication].keyWindow showHUDWithText:NSLocalizedString(@"hudLoading", nil) Type:ShowLoading Enabled:YES];
        }
        if ([basesss.loaderImageType isEqualToString:@"3"]){
            
            NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:4];
            for (int i = 1; i < 5; i++) {
                [imgArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gifhuds0%d",i]]];
            }
            
            [GiFHUD setGifWithImages:imgArray];
            [GiFHUD dismiss];
            [GiFHUD show];
        }
    }
    
    if (self.wkWebView) {
        if (!self.wkWebView.scrollView.headerRefreshing) {
            
            if ([basesss.loaderImageType isEqualToString:@"0"]) {
                [ClockView show];
                
            }
            if ([basesss.loaderImageType isEqualToString:@"1"]){
                [WKProgressHUD showInView:[UIApplication sharedApplication].keyWindow withText:NSLocalizedString(@"hudLoading", nil) animated:YES];
            }
            if ([basesss.loaderImageType isEqualToString:@"3"]){
                
                NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:4];
                for (int i = 1; i < 5; i++) {
                    [imgArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gifhuds0%d",i]]];
                }
                
                [GiFHUD setGifWithImages:imgArray];
                [GiFHUD dismiss];
                [GiFHUD show];
            }
            
        }
    }
    if (self.webView) {
        if (!self.webView.scrollView.headerRefreshing) {
            
            if ([basesss.loaderImageType isEqualToString:@"0"]) {
                [ClockView show];
                
            }
            if ([basesss.loaderImageType isEqualToString:@"1"]) {
                [WKProgressHUD showInView:[UIApplication sharedApplication].keyWindow withText:NSLocalizedString(@"hudLoading", nil) animated:YES];
            }
            if ([basesss.loaderImageType isEqualToString:@"3"]){
                
                NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:4];
                for (int i = 1; i < 5; i++) {
                    [imgArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gifhuds0%d",i]]];
                }
                
                [GiFHUD setGifWithImages:imgArray];
                [GiFHUD dismiss];
                [GiFHUD show];
            }
            
        }
    }
    
}
- (void)hideAldClock
{
    
    if ([self.ssBase.loaderImageType isEqualToString:@"0"]) {
        [ClockView dismiss];
    }
    if ([self.ssBase.loaderImageType isEqualToString:@"1"]) {
        [WKProgressHUD dismissAll:YES];
    }
    if ([self.ssBase.loaderImageType isEqualToString:@"3"]) {
        [GiFHUD dismiss];
    }
    if (self.wkWebView) {
        [self.wkWebView.scrollView headerEndRefreshing];
    }else {
        [self.webView.scrollView headerEndRefreshing];
    }
    
    
    
}

#pragma mark -JS-



- (void)create9vImgJavaScript
{
    NSString *myUrl = @"javascript:(function(){"
    
    
    "var objs = document.getElementsByTagName(\"img\"); "
    "var mydata=\"{\\\"root\\\":[\";"
    "for(var j=0;j<objs.length;j++){"
    "if(objs[j].parentElement.tagName=='A'||objs[j].attributes['is9vimg']==undefined||objs[j].attributes['is9vimg'].nodeValue.toLowerCase()!='true') continue;"
    " mydata+=\"{\\\"title\\\":\\\"\"+objs[j].title+\"\\\",\\\"url\\\":\\\"\"+objs[j].src+\"\\\"},\";"
    "}"
    "var lastIndDot = mydata.lastIndexOf(',');"
    "if((lastIndDot+1)== mydata.length) mydata = mydata.substring(0,lastIndDot);"
    "mydata+=\"]}\";"
    "for(var i=0;i<objs.length;i++)  "
    "{"
    
    " if(objs[i].parentElement.tagName!='A'&&(objs[i].attributes['is9vimg']!=undefined&&objs[i].attributes['is9vimg'].nodeValue.toLowerCase()=='true'))"
    "{objs[i].onclick=function(){ window.location = 'App9vCom:9vimg'+mydata+'$$'+this.src;}"
    "} "
    
    
    
    
    
    
    
    "}"
    "})()";
    if (!self.wkWebView) {
        [self.webView stringByEvaluatingJavaScriptFromString:myUrl];
    }else {
        NSString* js9vimg = [self imageClickScriptToAddToDocument];
        [self.wkWebView evaluateJavaScript:js9vimg completionHandler:nil];
    }
    
}



- (void)PushMsgConfig:(NSString *)username

{
    NSLog(@"%@", username);
    
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://pushios.ydbimg.com/rest/weblsq/1.0/EditGetuiUserRelationsInfo.aspx"];
    NSString *clientIdStr = nil;
    
    clientIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MYCLIENTID"];
    
    if (clientIdStr.length == 0) {
        clientIdStr = @"1";
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON--error: %@", error);
    }];
    
    
}

- (void)picShow:(NSString *)mydataStr current:(NSString *)currentStr
{
    
    NSString *sss = [mydataStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"js调用*********%@----%@",sss,currentStr);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sss dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"====%@",dic);
    self.imgStr = currentStr;
    JWImgBrowserBase *base = [[JWImgBrowserBase alloc] initWithDictionary:dic];
    
    [self.dataArray removeAllObjects];
    for (JWImgBrowserRoot *root in base.root) {
        //        [self.dataArray addObject:root];
        HWAssetModel *tz = [[HWAssetModel alloc] init];
        tz.imgUrl = root.url;
        [self.dataArray addObject:tz];
        
    }
    __block int index;
    index = 0;
    [self.dataArray enumerateObjectsUsingBlock:^(HWAssetModel *obj, NSUInteger idx, BOOL *stop) {
        if ([currentStr isEqualToString:obj.imgUrl]) {
            index = (int)idx;
            *stop = YES;
        }
    }];
    
    HWPhotoPreviewController *photoPreviewVc = [[HWPhotoPreviewController alloc] init];
    photoPreviewVc.currentIndex = index;
    photoPreviewVc.models = self.dataArray;
    [self presentViewController:photoPreviewVc animated:NO completion:nil];
    
    //    [self.browserView showFromIndex:index];
}
/*扫一扫*/
- (void)scanOneScan:(BOOL)isGetScan {
    HwReaderViewController *readerVC = [[HwReaderViewController alloc] init];
    readerVC.isGetScan = isGetScan;
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:readerVC];
    if (isGetScan) {
        
        
        
        readerVC.completionHandler = ^(NSString *itemStr) {
            NSString *str = [NSString stringWithFormat:@"%@('%@')",self.jsMethodNameStr,itemStr];
            if (self.wkWebView) {
                [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
                    NSLog(@"----%@",error);
                }];
            }else {
                [self.webView stringByEvaluatingJavaScriptFromString:str];
            }
            
            
            
        };
    }
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
}
/*分享*/
- (void)shareToShare:(ShareModel *)model {
    UIView *vi = [[UIView alloc] init];
    vi.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    vi.bounds = CGRectMake(0, 0, 0, 0);
    [self.view addSubview:vi];
    [[HwTools shareTools] shareAllButtonClickHandler:vi shareModel:model];
}
/*清理缓存*/
- (void)clearCache {
    [[HwTools shareTools] clearCache:^{
        
    }];
    
}
/*语音识别*/
- (void)mscVoice {
    [self.iflyRecognizerView start];
}
#pragma mark IFlyRecognizerViewDelegate

/** 识别结果回调方法
 @param resultArray 结果列表
 @param isLast YES 表示最后一个，NO表示后面还有结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSString *str = [NSString stringWithFormat:@"%@('%@')",self.jsMethodNameStr,result];
    
    
    if (self.wkWebView) {
        [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
            NSLog(@"----%@",error);
        }];
    }else {
        [self.webView stringByEvaluatingJavaScriptFromString:str];
    }
    
    
    
    NSLog(@"====语音识别成功----->%@",[NSString stringWithFormat:@"%@",result]);
    
    [self.iflyRecognizerView cancel];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    
    
    NSLog(@"errorCode----->%d",[error errorCode]);
}
- (void)startLoc {
    [self.locationManager requestWhenInUseAuthorization];
    [self.locService startUserLocationService];
}
- (void)stopLoc {
    [self.locService stopUserLocationService];
}
- (void)willStartLocatingUser {
    NSLog(@"开始定位");
    if (_isTimeLoc) {
        self.localUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:[self.ssBase.gPSGrabInterval floatValue] target:self selector:@selector(uploadUserLoc) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.localUpdateTimer forMode:NSRunLoopCommonModes];
        
        self.serverUploadTimer = [NSTimer scheduledTimerWithTimeInterval:[self.ssBase.gPSPostInterval floatValue] target:self selector:@selector(uploadForServer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.serverUploadTimer forMode:NSRunLoopCommonModes];
        
    }
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    NSLog(@"didUpdateBMKUserLocation is %@",userLocation.heading);
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    NSString *str = [NSString stringWithFormat:@"lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
    NSLog(@"===%@",str);
    if (self.isGetGPS) {
        NSString *str = [NSString stringWithFormat:@"%@('%f','%f')",self.jsMethodNameStr,userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
        
        
        if (self.wkWebView) {
            [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
                NSLog(@"----%@",error);
            }];
        }else {
            [self.webView stringByEvaluatingJavaScriptFromString:str];
        }
        [self stopLoc];
        self.isGetGPS = NO;
    }
    
    
    
    
    if (_isTimeLoc) {
        self.locBase = [[MyLocBase alloc] init];
        
        self.locBase.locLon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
        self.locBase.locLat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    }
    
    
    
}

- (void)didStopLocatingUser {
    NSLog(@"停止定位");
    if (self.localUpdateTimer) {
        [self.localUpdateTimer invalidate];
        self.localUpdateTimer = nil;
    }
    if (self.serverUploadTimer) {
        [self.serverUploadTimer invalidate];
        self.serverUploadTimer = nil;
    }
    
}

- (void)uploadUserLoc {
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *datenowStr = [formatter stringFromDate:[NSDate date]];
    self.locBase.locTime = datenowStr;
    NSLog(@"====%@,%@,%@",self.locBase.locTime,self.locBase.locLon,self.locBase.locLat);
    
    if (self.locBase) {
        [self.locDataArray addObject:@{@"time":self.locBase.locTime,@"lon":self.locBase.locLon,@"lat":self.locBase.locLat,@"userid":_locUserId}];
    }
    
    
    
}


- (void)uploadForServer {
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    
    NSString *urlStr = self.ssBase.gpsPostUrl;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:@"basic d2VibHNxOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
    
    
    [manager.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    NSData *dataa = [NSJSONSerialization dataWithJSONObject:self.locDataArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:dataa encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:jsonString forKey:@"gps"];
    NSLog(@"====%@",dic);
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.locDataArray removeAllObjects];
        NSLog(@"JSON--success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"JSON---error: %@", error);
    }];
}
- (NSMutableArray *)locDataArray {
    if (!_locDataArray) {
        _locDataArray = [NSMutableArray array];
    }
    return _locDataArray;
}

#pragma mark -隐藏tabbar-
- (void)hideTabBar:(BOOL)hidden{
    AKTabBarController *akTab = [self akTabBarController];
    if (hidden) {
        [akTab hideTabBarAnimated:NO];
        _currentShowTabbar = NO;
    }else {
        if (!_currentShowTabbar) {
            [akTab showTabBarAnimated:NO];
            _currentShowTabbar = YES;
        }
        
    }
    
}


#pragma mark -getter-
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        if (IS_IOS8) {
            [UIApplication sharedApplication].idleTimerDisabled = TRUE;
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
        }
    }
    return _locationManager;
}

#pragma mark - AGPhotoBrowser datasource

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
    return self.dataArray.count;
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser URLStringForImageAtIndex:(NSInteger)index
{
    JWImgBrowserRoot *root = self.dataArray[index];
    return root.url;
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%d/%d",(int)index+1,(int)self.dataArray.count];
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
{
    return @"";
}

- (BOOL)photoBrowser:(AGPhotoBrowserView *)photoBrowser willDisplayActionButtonAtIndex:(NSInteger)index
{
    
    
    
    return YES;
}
#pragma mark - AGPhotoBrowser delegate

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
    
    NSLog(@"Dismiss the photo browser here");
    [self.browserView hideWithCompletion:^(BOOL finished){
        NSLog(@"Dismissed!");
    }];
    
    [[UIApplication sharedApplication].keyWindow showHUDWithText:nil Type:ShowDismiss Enabled:YES];
}

- (AGPhotoBrowserView *)browserView
{
    if (!_browserView) {
        _browserView = [[AGPhotoBrowserView alloc] initWithFrame:CGRectZero];
        _browserView.delegate = self;
        _browserView.dataSource = self;
    }
    
    return _browserView;
}
/*
#pragma mark -saveImg-
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint pt;
        CGSize viewSize;
        CGSize windowSize;
        if (self.wkWebView) {
            pt = [gestureRecognizer locationInView:self.wkWebView];
            viewSize = [self.wkWebView frame].size;
            windowSize = [self.wkWebView windowSize];
        }else {
            pt = [gestureRecognizer locationInView:self.webView];
            viewSize = [self.webView frame].size;
            windowSize = [self.webView windowSize];
        }
        
        
        
        CGFloat f = windowSize.width / viewSize.width;
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0) {
            pt.x = pt.x * f;
            pt.y = pt.y * f;
        } else {
            
            
            CGPoint offset;
            if (self.wkWebView) {
                offset = [self.wkWebView scrollOffset];
            }else {
                offset = [self.webView scrollOffset];
            }
            
            pt.x = pt.x * f + offset.x;
            pt.y = pt.y * f + offset.y;
        }
        
        [self openContextualMenuAt:pt];
    }
}

- (void)openContextualMenuAt:(CGPoint)pt
{
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTool" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if (self.wkWebView) {
        [self.wkWebView evaluateJavaScript:jsCode completionHandler:^(id obj, NSError *error) {
            NSLog(@"----%@",error);
        }];
    }else {
        [self.webView stringByEvaluatingJavaScriptFromString:jsCode];
    }
    
    
    
    
    
    
    
    NSString *tags = nil;
    if (self.wkWebView) {
        
        
        
    }else {
        tags = [NSString stringWithString:[self.webView stringByEvaluatingJavaScriptFromString:
                                           [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%d,%d);",(int)pt.x,(int)pt.y]]];
    }
    
    
    
    if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                             destructiveButtonTitle:nil otherButtonTitles:nil];
        [sheet addButtonWithTitle:NSLocalizedString(@"saveimg", nil)];
        if (self.wkWebView) {
            
        }else {
            self.saveImgUrl = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y]];
            [sheet showInView:self.webView];
        }
        
        
        
        
        
        
    }
    
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.saveImgUrl]];
        UIImage* image = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    lab.backgroundColor = [UIColor whiteColor];
    CGPoint point = self.view.center;
    point.x = point.x ;
    point.y = point.y ;
    lab.center = point;
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 10;
    lab.alpha = 0;
    
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
    [UIView animateWithDuration:1 animations:^{
        lab.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3 animations:^{
            lab.alpha = 0;
        }completion:^(BOOL finished) {
            [lab removeFromSuperview];
        }];
    }];
    if (error){
        lab.text = NSLocalizedString(@"savepictureerror", nil);
        
    }else {
        lab.text = NSLocalizedString(@"savepicturesuc", nil);
        
    }
}

- (void)contextualMenuAction:(NSNotification*)notification
{
    CGPoint pt;
    NSDictionary *coord = [notification object];
    pt.x = [[coord objectForKey:@"x"] floatValue];
    pt.y = [[coord objectForKey:@"y"] floatValue];
    
    
    if (self.wkWebView) {
        pt = [self.wkWebView convertPoint:pt fromView:nil];
    }else {
        pt = [self.webView convertPoint:pt fromView:nil];
    }
    
    
    
    CGPoint offset;
    CGSize viewSize;
    CGSize windowSize;
    if (self.wkWebView) {
        offset  = [self.wkWebView scrollOffset];
        viewSize = [self.wkWebView frame].size;
        windowSize = [self.wkWebView windowSize];
    }else {
        offset  = [self.webView scrollOffset];
        viewSize = [self.webView frame].size;
        windowSize = [self.webView windowSize];
    }
    
    
    CGFloat f = windowSize.width / viewSize.width;
    pt.x = pt.x * f + offset.x;
    pt.y = pt.y * f + offset.y;
    
    [self openContextualMenuAt:pt];
}
*/
#pragma mark -推送处理-
- (void)tuisongWebUrl:(NSNotification *)notification {
    HwTwoPageViewController* twoVC = [[HwTwoPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
    
    twoVC.urlStr = notification.userInfo[@"url"];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
    [self.navigationController pushViewController:twoVC animated:YES];
}
#pragma mark -隐藏显示返回菜单-
- (void)showBackMenu {
    if (!_isShowBackMenu) {
        return;
    }
    if (_isHomePage) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isleftOrrightMenu) {
        [self addBackBtnItem];
    };
    self.navigationItem.leftBarButtonItem.customView.hidden=NO;
    if (self.wkWebView) {
      /*  self.wkWebView.allowsBackForwardNavigationGestures = YES; */
    }else {
        /* self.webView.enablePanGesture = YES;*/
    }
}
- (void)hideBackMenu {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isleftOrrightMenu) {
        if (![self.wkWebView canGoBack]) {
            [self addMenuBtnItem];
        }
        if (![self.webView canGoBack]) {
            [self addMenuBtnItem];
        }
    }else{
        self.navigationItem.leftBarButtonItem.customView.hidden=YES;
    }
    if (self.wkWebView) {
      /* self.wkWebView.allowsBackForwardNavigationGestures = NO; */
    }else {
        
    }
}
#pragma mark -getter-

- (UIAlertView *)timeoutAlertView {
    if (!_timeoutAlertView) {
        _timeoutAlertView = [UIAlertView alertViewWithTitle:NSLocalizedString(@"goodInfo", nil) message:NSLocalizedString(@"loadingMoreTime", nil) cancelButtonTitle:NSLocalizedString(@"try_again", nil) otherButtonTitles:@[NSLocalizedString(@"continueWait", nil)] onDismiss:^(int buttonIndex, UIAlertView *alertView) {
            
        } onCancel:^{
            [self reloadOrStop];
        }];
    }
    return _timeoutAlertView;
}

- (MLKMenuPopover *)menuPopover {
    if (!_menuPopover) {
        
        NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
        NSMutableArray *itemsArray = [NSMutableArray array];
        float popViewHeight = 0;
        
        int diCount = 0;
        if (array.count <=5) {
            diCount = (int)array.count;
        }else {
            diCount = 4;
        }
        
        for (int i = diCount ;i < array.count; i++) {
            NSDictionary *dic = array[i];
            MyXmlBase *base = [MyXmlBase modelObjectWithDictionary:dic];
            [itemsArray addObject:base.name];
            popViewHeight += 44;
        }
        if (popViewHeight > 44 * 5) {
            popViewHeight = 44 * 5;
        }
        NSDictionary *dic = [array firstObject];
        MyXmlBase *bases = [MyXmlBase modelObjectWithDictionary:dic];
        float tabHeight = 0;
        if (bases.imgurl.length > 0 && bases.name.length > 0) {
            tabHeight = 50;
        }else {
            tabHeight = 40;
        }
        StringsXmlBase *sBase = [StringsXML getStringXmlBase];
        tabHeight = [sBase.bottomMenuBarHeight floatValue];
        
        
        _menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 10 - 145, [[UIScreen mainScreen] bounds].size.height  - popViewHeight - 15 - 50 - ([sBase.titleBarIsShow isEqualToString:@"1"] ? 64 : 0), 145, popViewHeight) menuItems:itemsArray];
        
        _menuPopover.menuPopoverDelegate = self;
    }
    return _menuPopover;
}

- (UIControl *)reloadControl
{
    if (!_reloadControl) {
        _reloadControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _reloadControl.backgroundColor = [UIColor colorWithWhite:0.917 alpha:1.000];
        [_reloadControl addTarget:self action:@selector(reloadOrStop) forControlEvents:UIControlEventTouchUpInside];
        _reloadControl.hidden = YES;
        _reloadControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        UIImage *tapReloadImage = [UIImage imageNamed:@"tap_reload"];
        UIImageView *reloadImgView = [[UIImageView alloc] initWithImage:tapReloadImage];
        reloadImgView.center = _reloadControl.center;
        reloadImgView.bounds = CGRectMake(0, 0, tapReloadImage.size.width, tapReloadImage.size.height);
        reloadImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_reloadControl addSubview:reloadImgView];
        
        
    }
    return _reloadControl;
}
- (NJKWebViewProgress *)progressProxy {
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _webView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        
    }
    return _progressProxy;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *img;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        for(UIView *subview in theView.subviews)
        {
            [subview drawViewHierarchyInRect:subview.bounds afterScreenUpdates:YES];
        }
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    else
    {
        CGContextSaveGState(context);
        [theView.layer renderInContext:context];
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, frame);
    UIImage *CGImg = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return CGImg;
}

#pragma mark -wkwebViewMethod-

-(WKWebViewConfiguration*)webConfig {
    
    if (!_webConfig) {
        
        _webConfig = [[WKWebViewConfiguration alloc]init];
        _webConfig.processPool = ((AppDelegate *)[UIApplication sharedApplication].delegate).wkPool;
        
        WKUserContentController* userController = [[WKUserContentController alloc]init];
        [userController addScriptMessageHandler:self name:@"MultiPicShare"];
        [userController addScriptMessageHandler:self name:@"GetAppInfo"];
        [userController addScriptMessageHandler:self name:@"buttonClicked"];
        [userController addScriptMessageHandler:self name:@"PushMsgConfig"];
        [userController addScriptMessageHandler:self name:@"SetGlobal"];
        [userController addScriptMessageHandler:self name:@"SetDragRefresh"];
        [userController addScriptMessageHandler:self name:@"SetHeadBar"];
        [userController addScriptMessageHandler:self name:@"SetMenuBar"];
        [userController addScriptMessageHandler:self name:@"SetMoreButton"];
        [userController addScriptMessageHandler:self name:@"MenuBarAutoHide"];
        [userController addScriptMessageHandler:self name:@"GoBack"];
        [userController addScriptMessageHandler:self name:@"GoTop"];
        [userController addScriptMessageHandler:self name:@"Scan"];
        [userController addScriptMessageHandler:self name:@"GetScan"];
        [userController addScriptMessageHandler:self name:@"ImageViewState"];
        [userController addScriptMessageHandler:self name:@"Share"];
        [userController addScriptMessageHandler:self name:@"ClearCache"];
        [userController addScriptMessageHandler:self name:@"SetAlipayInfo"];
        [userController addScriptMessageHandler:self name:@"SetWxpayInfo"];
        [userController addScriptMessageHandler:self name:@"WXLogin"];
        [userController addScriptMessageHandler:self name:@"SpeechRecognition"];
        [userController addScriptMessageHandler:self name:@"GetGPS"];
        [userController addScriptMessageHandler:self name:@"OpenGPS"];
        [userController addScriptMessageHandler:self name:@"CloseGPS"];
        [userController addScriptMessageHandler:self name:@"GetDeviceInformation"];
        [userController addScriptMessageHandler:self name:@"PopUp"];
        [userController addScriptMessageHandler:self name:@"ShowTopRightMenu"];
        [userController addScriptMessageHandler:self name:@"UploadImage"];
        [userController addScriptMessageHandler:self name:@"SetBgColor"];
        [userController addScriptMessageHandler:self name:@"GetWifiSsid"];
        [userController addScriptMessageHandler:self name:@"UseTouchID"];
        [userController addScriptMessageHandler:self name:@"GetHealthStep"];
        [userController addScriptMessageHandler:self name:@"QQLogin"];
        [userController addScriptMessageHandler:self name:@"SetReturnButtonMode"];
        [userController addScriptMessageHandler:self name:@"AnimationWay"];
        [userController addScriptMessageHandler:self name:@"OpenWithSafari"];
        [userController addScriptMessageHandler:self name:@"OpenNewWindow"];
        [userController addScriptMessageHandler:self name:@"GetClientIDOfGetui"];
        
        [userController addScriptMessageHandler:self name:@"RongyunLogin"];
        [userController addScriptMessageHandler:self name:@"InitiateChat"];
        [userController addScriptMessageHandler:self name:@"SessionList"];
        [userController addScriptMessageHandler:self name:@"OpenDiscussGroup"];
        [userController addScriptMessageHandler:self name:@"CreateDiscussGroup"];
        [userController addScriptMessageHandler:self name:@"AddDiscussGroup"];
        [userController addScriptMessageHandler:self name:@"RemoveDiscussGroup"];
        [userController addScriptMessageHandler:self name:@"RefreshUserInfo"];
        [userController addScriptMessageHandler:self name:@"IntPortraitUri"];
        [userController addScriptMessageHandler:self name:@"SetStatusBarStyle"];
        [userController addScriptMessageHandler:self name:@"isWXAppInstalled"];
        
        [userController addScriptMessageHandler:self name:@"GetBaseInfo"];
        [userController addScriptMessageHandler:self name:@"GpsState"];
        [userController addScriptMessageHandler:self name:@"ContactAll"];
        [userController addScriptMessageHandler:self name:@"ContactSelect"];
        [userController addScriptMessageHandler:self name:@"ContactAdd"];
        [userController addScriptMessageHandler:self name:@"ContactDelete"];
        [userController addScriptMessageHandler:self name:@"ContactUpdate"];
        
        [userController addScriptMessageHandler:self name:@"OpenVideo"];
        
        [userController addScriptMessageHandler:self name:@"StartVoice"];
        [userController addScriptMessageHandler:self name:@"PauseVoice"];
        [userController addScriptMessageHandler:self name:@"PlayVoice"];
        [userController addScriptMessageHandler:self name:@"StopVoice"];
        [userController addScriptMessageHandler:self name:@"VolumeVideo"];
        
        [userController addScriptMessageHandler:self name:@"NavigatorInfo"];
        [userController addScriptMessageHandler:self name:@"NavigatorBaidu"];
        [userController addScriptMessageHandler:self name:@"NavigatorGoogle"];
        [userController addScriptMessageHandler:self name:@"NavigatorGaode"];
        [userController addScriptMessageHandler:self name:@"NavigatorGaodePath"];
        [userController addScriptMessageHandler:self name:@"appleNavigation"];
        [userController addScriptMessageHandler:self name:@"NavigatorBaiduPath"];
        [userController addScriptMessageHandler:self name:@"IsReloadPreviousPage"];
        [userController addScriptMessageHandler:self name:@"IsReloadNextPage"];
        
        [userController addScriptMessageHandler:self name:@"BLinitManager"];
        [userController addScriptMessageHandler:self name:@"BLscan"];
        [userController addScriptMessageHandler:self name:@"BLgetPeripheral"];
        [userController addScriptMessageHandler:self name:@"BLisScanning"];
        [userController addScriptMessageHandler:self name:@"BLstopScan"];
        [userController addScriptMessageHandler:self name:@"BLconnect"];
        [userController addScriptMessageHandler:self name:@"BLdisconnect"];
        [userController addScriptMessageHandler:self name:@"BLisConnected"];
        [userController addScriptMessageHandler:self name:@"BLdiscoverService"];
        [userController addScriptMessageHandler:self name:@"BLdiscoverCharacteristics"];
        [userController addScriptMessageHandler:self name:@"BLdiscoverDescriptorsForCharacteristic"];
        [userController addScriptMessageHandler:self name:@"BLsetNotify"];
        [userController addScriptMessageHandler:self name:@"BLreadValueForCharacteristic"];
        [userController addScriptMessageHandler:self name:@"BLreadValueForDescriptor"];
        [userController addScriptMessageHandler:self name:@"BLwriteValueForCharacteristic"];
        [userController addScriptMessageHandler:self name:@"BLwriteValueForDescriptor"];
        [userController addScriptMessageHandler:self name:@"BLretrievePeripheral"];
        [userController addScriptMessageHandler:self name:@"BLretrieveConnectedPeripheral"];
        [userController addScriptMessageHandler:self name:@"iOSSystemShare"];
        [userController addScriptMessageHandler:self name:@"SetFontSize"];
        [userController addScriptMessageHandler:self name:@"SetBrightness"];
        [userController addScriptMessageHandler:self name:@"weixinjs"];
        [userController addScriptMessageHandler:self name:@"CiticWxPay"];
        [userController addScriptMessageHandler:self name:@"GetHalfScan"];
        [userController addScriptMessageHandler:self name:@"CloseScan"];
        [userController addScriptMessageHandler:self name:@"WftWxpayInfo"];
        [userController addScriptMessageHandler:self name:@"BeeCloudPay"];
        [userController addScriptMessageHandler:self name:@"openUCBrower"];
        [userController addScriptMessageHandler:self name:@"xcxjs"];
        [userController addScriptMessageHandler:self name:@"SingleShare"];
        [userController addScriptMessageHandler:self name:@"copyPasteboardText"];
        [userController addScriptMessageHandler:self name:@"statusBarHidden"];
        [userController addScriptMessageHandler:self name:@"screenOrientation"];
        [userController addScriptMessageHandler:self name:@"SetTitleColor"];
        [userController addScriptMessageHandler:self name:@"GetCacheSize"];
        [userController addScriptMessageHandler:self name:@"isRightMenu"];
        NSString* js = [self imageClickScriptToAddToDocument];
        
        
        WKUserScript* userScript = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        
        
        [userController addUserScript:userScript];
        
        
        _webConfig.userContentController = userController;
        _webConfig.mediaPlaybackRequiresUserAction = NO;
        _webConfig.allowsInlineMediaPlayback = YES;
    }
    return _webConfig;
    
}
- (NSString *)imageClickScriptToAddToDocument {
    NSString *myUrl = @""
    
    
    "var objs = document.getElementsByTagName(\"img\"); "
    
    "var mydata=\"{\\\"root\\\":[\";"
    "for(var j=0;j<objs.length;j++){"
    "if(objs[j].parentElement.tagName=='A'||objs[j].attributes['is9vimg']==undefined||objs[j].attributes['is9vimg'].nodeValue.toLowerCase()!='true') continue;"
    " mydata+=\"{\\\"title\\\":\\\"\"+objs[j].title+\"\\\",\\\"url\\\":\\\"\"+objs[j].src+\"\\\"},\";"
    "}"
    
    "var lastIndDot = mydata.lastIndexOf(',');"
    "if((lastIndDot+1)== mydata.length) mydata = mydata.substring(0,lastIndDot);"
    "mydata+=\"]}\";"
    
    "for(var i=0;i<objs.length;i++)  "
    "{"
    
    
    " if(objs[i].parentElement.tagName!='A'&&(objs[i].attributes['is9vimg']!=undefined&&objs[i].attributes['is9vimg'].nodeValue.toLowerCase()=='true'))"
    "{ "
    "objs[i].onclick=function(){"
    "window.webkit.messageHandlers.buttonClicked.postMessage(mydata+'$$'+this.src);"
    "} "
    "}"
    
    "}";
    return myUrl;
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([self.wkWebView canGoBack]) {
        NSString *HomePage = [self URLDecodedString:self.ssBase.HomePage];
        NSMutableArray *menue =  [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
        if ([navigationAction.request.URL.absoluteString isEqualToString:HomePage]&&menue.count == 1) {
            [self hideBackMenu];
            _isHomePage = YES;
            HwTwoPageViewController* twoVC = [[HwTwoPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
            twoVC.hidesBottomBarWhenPushed = YES;
            twoVC.urlStr = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            [self.navigationController pushViewController:twoVC animated:NO];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
            
        }else{
            _isHomePage = NO;
        }
    }
    [self timeoutRequest];
    self.isWkWebViewFailLoad = NO;
    self.isWkWebViewBackForward = NO;
    
    NSLog(@"-scheme--%@",[navigationAction.request.URL scheme]);
    
    NSURL *urll = navigationAction.request.URL;
    NSString *urllString = (urll) ? urll.absoluteString : @"";
    if (![urllString isMatch:[@"^https?:\\/\\/." toRxIgnoreCase:YES]]) {
        [[UIApplication sharedApplication] openURL:urll];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    NSRange kefu = [[navigationAction.request.URL absoluteString] rangeOfString:@"p.qiao.baidu.com"];
    if (kefu.location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:urll];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    /*招行一网通插件*/
    if ([navigationAction.request.URL.host isCaseInsensitiveEqualToString:@"cmbls"]) {        CMBWebKeyboard *secKeyboard = [CMBWebKeyboard shareInstance];
        [secKeyboard showKeyboardWithRequest:navigationAction.request];
        secKeyboard.webView = _webView;
        UITapGestureRecognizer* myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.view addGestureRecognizer:myTap];
        myTap.delegate = self;
        myTap.cancelsTouchesInView = NO;
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    NSRange weixin = [[navigationAction.request.URL absoluteString] rangeOfString:@"weixin://"];
    NSRange webqq2 = [[navigationAction.request.URL absoluteString] rangeOfString:@"mqqwpa://"];
    NSRange tims = [[navigationAction.request.URL absoluteString] rangeOfString:@"itms-services"];
    NSRange wpdQQ = [[navigationAction.request.URL absoluteString] rangeOfString:@"wpd.b.qq.com"];
    NSRange dwz = [[navigationAction.request.URL absoluteString] rangeOfString:@"dwz.cn"];
    
    if (!navigationAction.targetFrame || weixin.location != NSNotFound || tims.location != NSNotFound || wpdQQ.location != NSNotFound || dwz.location != NSNotFound||webqq2.location != NSNotFound || _isOpenNewWindow) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if (_isOpenNewWindow) {
            delegate.isNewPageView = YES;
                ThreeViewController *threeView = [[ThreeViewController alloc]init];
                CustomNavigationController *cusNav = [[CustomNavigationController alloc] initWithRootViewController:threeView];
                threeView.url = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
            int input = [delegate.animation[0] intValue];
                switch (input) {
                    case 0:
                    {
                        HwTwoPageViewController* twoVC = [[HwTwoPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
                        twoVC.hidesBottomBarWhenPushed = YES;
                        twoVC.urlStr = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
                        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                        }
                        [self.navigationController pushViewController:twoVC animated:YES];
                    }
                        break;
                    case 1:
                    {
                        HwThreeViewController* threeVC = [[HwThreeViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
                        threeVC.urlStr = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
                        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:threeVC];
                        [self presentViewController:nav animated:YES completion:nil];
                    }
                        break;
                    case 2:
                        [self presentPopupViewController:cusNav animationType:4];
                        
                        break;
                    case 3:
                        [self presentPopupViewController:cusNav animationType:1];
                        break;
                }
        }else{
            [webView loadRequest:[NSURLRequest requestWithURL:navigationAction.request.URL]];
        }
        
    }
    
    

    if (navigationAction.navigationType != WKNavigationTypeBackForward) {
        self.isWkWebViewBackForward = YES;
    }
    if (_isOpenNewWindow) {
        decisionHandler(WKNavigationActionPolicyCancel);
        _isOpenNewWindow = NO;
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    NSString *urlString = [navigationAction.request.URL absoluteString];
    NSRange appcomRange=[urlString rangeOfString:@"app9vcom:"];
    NSRange itmsServicesRange=[urlString rangeOfString:@"itms-services"];
    NSRange schemeRange=[urlString rangeOfString:@"itms"];
    NSRange blankRange=[urlString rangeOfString:@"about:blank"];
    NSRange telRange=[urlString rangeOfString:@"tel:"];
    if(appcomRange.location!=NSNotFound){
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if (telRange.location!=NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"%@",urlString];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        return;
    }else if (itmsServicesRange.location!=NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if (blankRange.location!=NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if (schemeRange.location!=NSNotFound) {
        [webView stopLoading];
        NSArray *urlArray = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"/"];
        NSString *appid = nil;
        for (NSString *urlStr in urlArray) {
            NSRange appidRange=[urlStr rangeOfString:@"id"];
            if(appidRange.location!=NSNotFound){
                appid = [urlStr stringByReplacingOccurrencesOfString:@"id" withString:@""];
            }
        }
        appid = [[appid componentsSeparatedByString:@"?"] firstObject];
        SKStoreProductViewController *storeVC = [[SKStoreProductViewController alloc] init];
        storeVC.delegate = self;
        [storeVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appid}
                           completionBlock:^(BOOL result, NSError *error) {
                               
                           }];
        
        [self presentViewController:storeVC animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else {
        
        
        
        NSRange headBarrange=[urlString rangeOfString:@"YDBSetHeadBar"];
        NSRange dragRefreshrange=[urlString rangeOfString:@"YDBSetDragRefresh"];
        NSRange moreButtonBarrange=[urlString rangeOfString:@"YDBSetMoreButton"];
        NSRange popUprange=[urlString rangeOfString:@"YDBSetPopUp"];
        NSRange ytitlerange=[urlString rangeOfString:@"YDBSetTitle"];
        if(headBarrange.location != NSNotFound || dragRefreshrange.location != NSNotFound || moreButtonBarrange.location != NSNotFound || popUprange.location != NSNotFound || ytitlerange.location != NSNotFound) {
            NSArray *ydbArray = [urlString componentsSeparatedByString:@"?"];
            NSArray *ydbStrArray = [[ydbArray lastObject] componentsSeparatedByString:@"&"];
            
            float ydbPackageId = [[NSUserDefaults standardUserDefaults] floatForKey:@"YdbPackageID"];
            if (ydbPackageId <= 1) {
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
            
            NSString *ydbSetDragRefreshStr = nil;
            
            NSString *ydbSetHeadBarStr = nil;
            NSString *ydbSetMoreButtonStr = nil;
            NSString *ydbSetPopUpStr = nil;
            NSString *ydbSetTitleStr = nil;
            
            for (NSString *localStr in ydbStrArray) {
                
                
                NSRange lheadBarrange=[localStr rangeOfString:@"YDBSetHeadBar"];
                NSRange ldragRefreshrange=[localStr rangeOfString:@"YDBSetDragRefresh"];
                NSRange lmoreButtonBarrange=[localStr rangeOfString:@"YDBSetMoreButton"];
                NSRange lpopUprange=[localStr rangeOfString:@"YDBSetPopUp"];
                NSRange lTitelerange=[localStr rangeOfString:@"YDBSetTitle"];
                
                if(lheadBarrange.location != NSNotFound){
                    ydbSetHeadBarStr = [localStr componentsSeparatedByString:@"="][1];
                }
                if(ldragRefreshrange.location != NSNotFound){
                    ydbSetDragRefreshStr = [localStr componentsSeparatedByString:@"="][1];
                }
                if(lmoreButtonBarrange.location != NSNotFound){
                    ydbSetMoreButtonStr = [localStr componentsSeparatedByString:@"="][1];
                }
                if(lpopUprange.location != NSNotFound){
                    ydbSetPopUpStr = [localStr componentsSeparatedByString:@"="][1];
                }
                if(lTitelerange.location != NSNotFound){
                    ydbSetTitleStr = [localStr componentsSeparatedByString:@"="][1];
                }
            }
            
            
            
            HwTwoPageViewController* twoVC = [[HwTwoPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
            twoVC.hidesBottomBarWhenPushed = YES;
            
            
            twoVC.urlStr = [[navigationAction.request.URL.absoluteString componentsSeparatedByString:@"?"] firstObject];
            twoVC.ydbSetPopUpStr = ydbSetPopUpStr;
            twoVC.ydbSetTitleStr = ydbSetTitleStr;
            twoVC.ydbSetHeadBarStr = ydbSetHeadBarStr;
            twoVC.ydbSetMoreButtonStr = ydbSetMoreButtonStr;
            twoVC.ydbSetDragRefreshStr = ydbSetDragRefreshStr;
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                
            }
            [self.navigationController pushViewController:twoVC animated:NO];
            decisionHandler(WKNavigationActionPolicyCancel);
            
            
            
        }
        
        
        
        
    }
    NSLog(@"===>>%@", navigationAction.request.URL);
    self.shareUrlStr = [navigationAction.request.URL absoluteString];
    /*微信兼容*/
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    if (![base.CmsSystem isEqualToString:@"0"] && base.PigWxToken.length != 0 && [urll.scheme isEqualToString:@"http"]) {
        NSRange opneWeixinLocading = [urllString rangeOfString:@"open.weixin.qq.com"];
        NSRange opneWeixinLocadings = [urllString rangeOfString:@"redirect_uri="];
        NSRange opneWeixinLocadingss = [urllString rangeOfString:@"wq.youliaode.cn"];
        NSRange opneWeixinLocadingsss = [urllString rangeOfString:@"wd.appe.cc"];
        NSString *webWeiXinAccessUrl;
        if ((opneWeixinLocading.location != NSNotFound && opneWeixinLocadings.location != NSNotFound) ||opneWeixinLocadingss.location != NSNotFound || opneWeixinLocadingsss.location != NSNotFound ) {
            
            NSString *accessURL = [self URLDecodedString:base.WeChatAccessUrl];
            if (accessURL.length == 0 || accessURL == nil) {
                if ([base.CmsSystem isEqualToString:@"2"]) {
                    accessURL =[[NSString alloc]initWithFormat:@"%@://%@/YdbGetUserInfo.php",urll.scheme, urll.host];
                }else{
                    accessURL =[[NSString alloc]initWithFormat:@"%@://%@/index.php?g=Wap&m=YdbPublic&a=YdbGetUserInfo",urll.scheme, urll.host];
                }
                
            }
            
            NSArray *array = [[NSArray alloc]initWithObjects:@"1",accessURL, nil];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (!delegate.isWeixindenglu) {
                [self sendAuthRequest:array];
                delegate.isWeixindenglu = YES;
                
                
            }
            NSArray *jiequ = [urllString componentsSeparatedByString:@"&"];
            for (NSString *urlString in jiequ) {
                if ([urlString hasPrefix:@"redirect_uri="]) {
                    webWeiXinAccessUrl = urlString;
                    webWeiXinAccessUrl = [webWeiXinAccessUrl stringByReplacingOccurrencesOfString:@"redirect_uri=" withString:@""];
                    int x = arc4random()%10000;
                    webWeiXinAccessUrl = [NSString stringWithFormat:@"%@/?code=%d&state=STATE",webWeiXinAccessUrl,x];
                    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webWeiXinAccessUrl]]];
                }
            }
            
            /*小猪Cms微信支付*/
            NSRange weixinPay = [urllString rangeOfString:@"g=Wap&m=Weixin&a=pay"];
            if (weixinPay.location != NSNotFound) {
                NSArray *UrlArray = [urllString componentsSeparatedByString:@"&"];
                NSMutableArray *mutableArray1 = 	[NSMutableArray array];
                NSMutableArray *mutableArray2 = 	[NSMutableArray array];
                for (NSString *string5 in UrlArray) {
                    NSArray *array = [string5 componentsSeparatedByString:@"="];
                    [mutableArray1 addObject:array[0]];
                    [mutableArray2 addObject:array[1]];
                }
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithObjects:mutableArray2 forKeys:mutableArray1];
                NSString *string6 = [[NSString alloc]initWithFormat:@"http://%@/index.php?g=Wap&m=%@&a=payReturn&nohandle=1&token=%@&wecha_id=%@&orderid=%@",urll.host,mutableDict[@"from"],mutableDict[@"token"],mutableDict[@"wecha_id"],mutableDict[@"single_orderid"]];
                weixinPayretrueUrl = [[NSString alloc]initWithString:string6];
                StringsXmlBase *xmlBase = [StringsXML getStringXmlBase];
                
                NSString * wxUrlStr  =[self URLDecodedString:xmlBase.wxreturnurl];
                /*如果后台配置了支付返回地址*/
                if (wxUrlStr.length>0 ) {
                    xiaozhuWXpayUrlStr =[wxUrlStr stringByAppendingFormat:@"&nohandle=1&token=%@&wecha_id=%@&orderid=%@",mutableDict[@"token"],mutableDict[@"wecha_id"],mutableDict[@"single_orderid"]];
                }
                NSString *not_url = [[NSString alloc]initWithFormat:@"%@://%@/wxpay/notice.php",urll.scheme,urll.host];
                NSArray* array = @[mutableDict[@"single_orderid"],mutableDict[@"single_orderid"],mutableDict[@"price"],mutableDict[@"single_orderid"],not_url];
                [self sendPay_demo:array];
                decisionHandler(WKNavigationActionPolicyCancel);
            }
            
        }
        /*微擎微信支付*/
        
        if (([urllString rangeOfString:@"c=entry"].location != NSNotFound)&&([urllString rangeOfString:@"&do=pay&m=ewei_shopping"].location != NSNotFound)) {
            NSError *error;
            mutableAarray = [NSMutableArray array];
            NSString *html = [[NSString alloc ]initWithContentsOfURL:urll encoding:NSUTF8StringEncoding error:nil];
            HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
            if (error) {
                NSLog(@"Error: %@", error);
                decisionHandler(WKNavigationActionPolicyCancel);
            }
            
            HTMLNode *bodyNode = [parser body];
            
            NSArray *spanNodes = [bodyNode findChildTags:@"span"];
            for (HTMLNode *spanNode in spanNodes) {
                if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"mui-pull-right mui-text-muted"]) {
                    NSLog(@"%@",[self filterHTML:[spanNode rawContents]]);
                    NSString *str = [self filterHTML:[spanNode rawContents]];
                    [mutableAarray addObject:str];
                }
                if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"mui-pull-right mui-text-success mui-big mui-rmb"]) {
                    NSLog(@"%@",[self filterHTML:[spanNode rawContents]]);
                    NSString *str = [self filterHTML:[spanNode rawContents]];
                    [mutableAarray addObject:str];
                }
            }
            
            
        }
        if ([urllString rangeOfString:@"ps="].location !=NSNotFound &&[urllString rangeOfString:@"i="].location != NSNotFound &&[urllString rangeOfString:@"&done=1"].location == NSNotFound ) {
            NSArray *array1 = [urllString componentsSeparatedByString:@"?"];
            NSArray *array2 = [[array1 lastObject] componentsSeparatedByString:@"&"];
            
            NSString *orderId;
            NSString *attch;
            for (NSString *str3 in array2) {
                if ([str3 rangeOfString:@"ps="].location != NSNotFound) {
                    orderId = [str3 stringByReplacingOccurrencesOfString:@"ps=" withString:@""];
                }
                if ([str3 rangeOfString:@"i="].location != NSNotFound) {
                    attch = [str3 stringByReplacingOccurrencesOfString:@"i=" withString:@""];
                }
            }
            
            NSData *data = [Base64String base64Decode:orderId];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"dict:%@",dict);
            if (dict == nil) return;
            orderId = dict[@"uniontid"];
            NSString *not_url = [[NSString alloc]initWithFormat:@"%@://%@/payment/wechat/notify.php",urll.scheme,urll.host];
            
            NSLog(@"--->%@",mutableAarray);
            
            NSArray *array = @[mutableAarray[0],mutableAarray[0],mutableAarray[3],orderId,attch,not_url];
            NSLog(@"--->%@",array);
            weixinPayretrueUrl = [[NSString alloc]initWithFormat:@"%@&done=1",urllString];
            StringsXmlBase *base = [StringsXML getStringXmlBase];
            /*如果配置了微信支付返回地址*/
            if ([base.CmsSystem isEqualToString:@"2"]&&base.wxreturnurl.length > 0) {
                NSArray *array = [urllString componentsSeparatedByString:@"?"];
                if ([urllString rangeOfString:@"?"].location != NSNotFound) {
                    weiqingWxPayUrlStr = [[self URLDecodedString:base.wxreturnurl]stringByAppendingFormat:@"?%@&done=1",[array lastObject]];
                }else{
                    weiqingWxPayUrlStr = [[self URLDecodedString:base.wxreturnurl ] stringByAppendingFormat:@"&%@&done=1",[array lastObject]];
                }
                
            }
            [self sendPay_demo:array];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSLog(@"==&&=>>%@", navigationResponse.response.URL);
    
    
    StringsXmlBase *basesss= [StringsXML getStringXmlBase];
    if ([basesss.IsCopy isEqualToString:@"0"]) {
        // 禁用用户选择
        [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:^(id obj, NSError * error) {
            
        }];
        // 禁用长按弹出框
        [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id obj, NSError *error) {
            
        }];
    }
    NSString *urlString = [navigationResponse.response.URL absoluteString];
    NSRange urlRange = [urlString rangeOfString:@"http"];
    if (urlString.length != 0 && ![urlString isEqualToString:@"about:blank"] && urlRange.location!=NSNotFound) {
        self.shareUrlStr = urlString;
        self.currentUrlStr = urlString;
    }
    NSRange range=[urlString rangeOfString:@"tel:"];
    if(range.location!=NSNotFound){
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
    NSRange appcomRange=[urlString rangeOfString:@"app9vcom:"];
    if(appcomRange.location!=NSNotFound){
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    _isShowBackMenu = YES;
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 禁用长按弹出框
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id obj, NSError *error) {
        
    }];
//    [self reloadPreviousPage];
    [self reloadNextPage];
    [self.timeOutTimer invalidate];
    self.timeOutTimer = nil;
    [self updateLoadingStatus];
    self.reloadControl.hidden = YES;
    [self removeUnicomWo];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.sModel.sUrl = [webView.URL absoluteString];
    
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    NSString *WeChatJSPath = base.WeChatJsPath;
    if (WeChatJSPath.length > 0) {
        
        
        int ranNum = (int)(1 + (arc4random() % (10000000)));
        NSString *js1 = [NSString stringWithFormat:@""
                         "var myScript= document.createElement('SCRIPT');"
                         "myScript.type = 'text/javascript';"
                         "myScript.src='http://www.yundabao.com/scripts/yunJssdk.js?t=q%d';"
                         "document.body.appendChild(myScript);",ranNum];
        [webView evaluateJavaScript:js1 completionHandler:^(id ddd, NSError *error) {
            if(error != nil){
                NSLog(@"--%@",error);
            }
        }];
        
        NSString *js2 = [NSString stringWithFormat:@""
                         "var myScript= document.createElement('SCRIPT');"
                         "myScript.type = 'text/javascript';"
                         "myScript.src='%@';"
                         "document.body.appendChild(myScript);",WeChatJSPath];
        [webView evaluateJavaScript:js2 completionHandler:^(id ddd, NSError *error) {
            if(error != nil){
                NSLog(@"--%@",error);
            }
        }];
        
        
    }
    
    if (![base.CmsSystem isEqualToString:@"0"] && base.PigWxToken.length != 0 ){
        NSString *jsToGetHTMLSource = @"document.documentElement.innerHTML";
        [self.wkWebView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id  string, NSError *  error) {
            NSArray *array = [string componentsSeparatedByString:@"<script>"];
            for (NSString *res  in array) {
                if ([res rangeOfString:@"wx.config"].location != NSNotFound) {
                    NSArray *arr = [res componentsSeparatedByString:@"</script>"];
                    for (NSString *str  in arr) {
                        if ([str rangeOfString:@"wx.config"].location != NSNotFound) {
                            [self analysisWebViewSourceCode:str];
                        }
                    }
                }
            }
        }];
    }    
    
    StringsXmlBase *basesss= [StringsXML getStringXmlBase];
    if ([basesss.IsCopy isEqualToString:@"0"]) {
        // 禁用用户选择
        [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:^(id obj, NSError * error) {
            
        }];
        // 禁用长按弹出框
        [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id obj, NSError *error) {
            
        }];
    }
    
    if (![basesss.TaobaoJs isEqualToString:@"0"] && basesss.TaobaoJs.length > 0) {
        int ranNum1 = (int)(1 + (arc4random() % (10000000)));
        NSString *js1 = [NSString stringWithFormat:@""
                         "var myScript= document.createElement('SCRIPT');"
                         "myScript.type = 'text/javascript';"
                         "myScript.src='%@?t=q%d';"
                         "document.body.appendChild(myScript);",basesss.TaobaoJs,ranNum1];
        [webView evaluateJavaScript:js1 completionHandler:^(id ddd, NSError *error) {
            if(error != nil){
                NSLog(@"--%@",error);
            }
        }];
    }
    if (_is9vImg) {
        [self performSelector:@selector(is9vImgDelay) withObject:nil afterDelay:0.5f];
    }
    NSString *createtime = [HwTools UserDefaultsObjectForKey:@"createTime"];
    NSString *jsUrl = [NSString stringWithFormat:@"https://static.ydbimg.com/Scripts/SetDefaultStyles.js?IsCopy=%@&IsBorder=0&TranslucentBackground=%@&iOSOriginalStyle=%@&appid=%@&createtime=%@&EnableCopy=%@",base.IsCopy,base.TranslucentBackground,base.iOSOriginalStyle,base.appsid,createtime,base.EnableCopy];
    
    NSString *jsStr = [NSString stringWithFormat:@""
                       "var myScript= document.createElement('SCRIPT');"
                       "myScript.type = 'text/javascript';"
                       "myScript.src='%@';"
                       "document.body.appendChild(myScript);",jsUrl];
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id string, NSError * error) {
        if (error != nil) {
            NSLog(@"---%@",error);
            
        }
    }];

}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s. Error %@",__func__,error);
    if (error.code == -1002 && [error.domain isEqual:@"NSURLErrorDomain"]) return;
    [self.timeOutTimer invalidate];
    self.timeOutTimer = nil;
    [self hideAldClock];
    [self updateLoadingStatus];
    if (error.code == NSURLErrorCancelled) return;
    
    
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    self.reloadControl.hidden = NO;
    self.isWkWebViewFailLoad = YES;
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s. Error %@",__func__,error);
    
    
}
- (void)reloadPreviousPage {
    NSString *IsReloadPreviousPage = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsReloadPreviousPage"];
    IsReloadPreviousPage = [IsReloadPreviousPage stringByReplacingOccurrencesOfString:@"javascript:" withString:@""];
    if (IsReloadPreviousPage.length == 0) {
        return;
    }
    if ([IsReloadPreviousPage isEqualToString:@"1"]) {
        [self reloadOrStop];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsReloadPreviousPage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        if (![IsReloadPreviousPage isEqualToString:@"0"] && IsReloadPreviousPage.length > 0) {
            if (self.wkWebView) {
                [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"%@",IsReloadPreviousPage] completionHandler:^(id obj, NSError *error) {
                    NSLog(@"----%@",error);
                    if (error == nil) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsReloadPreviousPage"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }];
            }else {
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@",IsReloadPreviousPage]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsReloadNextPage"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
        }
    }
}
- (void)reloadNextPage {
    NSString *IsReloadNextPage = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsReloadNextPage"];
    if (IsReloadNextPage.length == 0) {
        return;
    }
    if ([IsReloadNextPage isEqualToString:@"1"]) {
        [self reloadOrStop];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsReloadNextPage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        if (![IsReloadNextPage isEqualToString:@"0"] && IsReloadNextPage.length > 0) {
            
            if (self.wkWebView) {
                [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"%@",IsReloadNextPage] completionHandler:^(id obj, NSError *error) {
                    NSLog(@"----%@",error);
                    if (error == nil) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsReloadNextPage"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }];
            }else {
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@",IsReloadNextPage]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsReloadNextPage"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
           
            
        }
    }
}
#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        
        NSLog(@"-----%f",self.wkWebView.estimatedProgress);
        StringsXmlBase *xBase = [StringsXML getStringXmlBase];
        float wbProgress = 0.8;
        if (xBase.RemindPercent.floatValue > 0) {
            wbProgress = xBase.RemindPercent.floatValue/100;
        }
        
        
        if (self.wkWebView.estimatedProgress > 0.0 && self.wkWebView.estimatedProgress < wbProgress && self.isWkWebViewBackForward) {
            
            [self showAldClock];
            self.isWkWebViewBackForward = NO;
            if (self.timeOutTimer && self.timeOutTimer.isValid) {
                [self.timeOutTimer invalidate];
                self.timeOutTimer = nil;
            }
            if ([self.ssBase.RemindState isEqualToString:@"1"]) {
                self.timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:xBase.RemindTime.floatValue target:self selector:@selector(timeOutShowAlert) userInfo:nil repeats:NO];
            }
        }
        if (self.wkWebView.estimatedProgress >= wbProgress) {
            [self.timeOutTimer invalidate];
            self.timeOutTimer = nil;
            
            [self hideAldClock];
            if (!self.isWkWebViewFailLoad) {
                self.reloadControl.hidden = YES;
            }else {
                self.reloadControl.hidden = NO;
            }
            
        }
        if (self.wkWebView.estimatedProgress == 1.0) {
            [self updateLoadingStatus];
            [self.wkWebView evaluateJavaScript:@"window.location.href" completionHandler:^(id obj, NSError * error) {
                self.shareUrlStr = obj;
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.sModel.sTitle = self.wkWebView.title;
                delegate.sModel.sUrl = self.shareUrlStr;
                delegate.sModel.sContent = @"请输入分享内容";
                NSLog(@"+++++++++—————》》》》%@",obj);
            }];
        }
    }
    else if([keyPath isEqualToString:@"title"]) {
        
        self.jsCustomTitleStr = self.wkWebView.title;
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.sModel.sTitle = self.wkWebView.title;
        delegate.sModel.sUrl = self.shareUrlStr;
        delegate.sModel.sContent = @"请输入分享内容";
        NSLog(@"-----%@", delegate.sModel.sTitle);
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark -WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"----%@--%@",message.name,message.body);
    float ydbPackageId = [[NSUserDefaults standardUserDefaults] floatForKey:@"YdbPackageID"];
    if (ydbPackageId <= 1) {
        return;
    }
    NSString *messageName = message.name;
    id messageBody = message.body;
    if ([messageName isEqualToString:@"isRightMenu"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        BOOL isRightMenu = [messageBody boolValue];
        delegate.isleftOrrightMenu = isRightMenu;
        [delegate showMainVC];
    }
    if ([messageName isEqualToString:@"SetTitleColor"]) {
//        [HwTools UserDefaultsObj:messageBody key:@"NavBarTitleColor"];
////        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////        [delegate showMainVC];
        UIColor *color = [HwTools hexStringToColor:messageBody];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
    }
    if ([messageName isEqualToString:@"GetCacheSize"]) {
        [[HwTools shareTools]getCacheSizeCompletion:^(float size) {
            NSString *returnStr = [NSString stringWithFormat:@"%@(%f)",messageBody,size];
            NSLog(@"%@",returnStr);
            [self.wkWebView evaluateJavaScript:returnStr completionHandler:^(id obj, NSError * _Nullable error) {
                
            }];
        }];
    }
    if ([messageName isEqualToString:@"MultiPicShare"]) {
        NSArray *array = [messageBody componentsSeparatedByString:@","];
        NSMutableArray *mutableAarrays = [[NSMutableArray alloc]init];
        for (int i = 0; i < array.count; i++) {
            if ((i == 0 || i == array.count-1)&& i != 1) {
                continue;
            }
            [mutableAarrays addObject:array[i]];
        }
        NSString *conten = [array lastObject];
        int type = [[array firstObject] intValue];
        [self MultiPicShare:mutableAarrays andConten:conten andType:type];
    }
    if ([messageName isEqualToString:@"GetAppInfo"]) {
        StringsXmlBase *base = [StringsXML getStringXmlBase];
        int appid = [base.appsid intValue];
        NSString *time = [HwTools UserDefaultsObjectForKey:@"createTime"];
        NSDictionary *dict = @{@"appid":[NSNumber numberWithInt:appid],@"createtime":time};
        NSString *jsonStr = [NSString stringWithFormat:@"%@(%@)",messageBody,[self objectTostring:dict]];
        [self.wkWebView evaluateJavaScript:jsonStr completionHandler:^(id objc, NSError * error) {
            NSLog(@"%@",error);
        }];
    }
    if ([messageName isEqualToString:@"screenOrientation"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        int type = [globalArray[0] intValue];
        [self clickToRotate:type];
    }

    if ([messageName isEqualToString:@"SingleShare"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        
        ShareModel *model = [[ShareModel alloc] init];
        if (globalArray.count > 3) {
            model.sTitle = [globalArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            model.sContent = [globalArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            model.sImage = [globalArray[2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            model.sUrl = [globalArray[3] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        if (globalArray.count > 4  ) {
            jsstr = [globalArray lastObject];
            int platfrom = [globalArray[4] intValue];
            UIView *vi = [[UIView alloc] init];
            vi.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            vi.bounds = CGRectMake(0, 0, 0, 0);
            [self.view addSubview:vi];
            [[HwTools shareTools] danduFenxiang:platfrom fromView:vi shareModel:model];
            [self shareCallBack];
        }
    }
    if ([messageName isEqualToString:@"xcxjs"]) {
        NSLog(@"%@",[message.body class]);
        NSString *body =[messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *cusmontArray = [body componentsSeparatedByString:@"||"];
        int callbackID = [cusmontArray[1] intValue];
        [self weixApi:cusmontArray[0] ID:callbackID other:(id)cusmontArray[2]];
    }
    if ([messageName isEqualToString:@"SetGlobal"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        
        if ([globalArray[0] isEqualToString:@"0"]) {
            
            self.navigationController.navigationBarHidden = YES;
            [HwTools UserDefaultsObj:@"NO" key:IS_SHOW_NAV];
            
            NSRange range=[self.currentUrlStr rangeOfString:globalArray[2]];
            if(range.location!=NSNotFound){
                self.navigationController.navigationBarHidden = NO;
            }
            
            
            
        }else {
            self.navigationController.navigationBarHidden = NO;
            [HwTools UserDefaultsObj:@"YES" key:IS_SHOW_NAV];
        }
        
        if ([globalArray[1] isEqualToString:@"0"]) {
            [self.webView.scrollView removeHeader];
            self.webView.scrollView.bounces = NO;
            [HwTools UserDefaultsObj:@"NO" key:IS_ENABLE_DRAG_REFRESH];
            
            NSRange range=[self.currentUrlStr rangeOfString:globalArray[3]];
            if(range.location!=NSNotFound){
                [self.webView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
                self.webView.scrollView.bounces = YES;
            }
        }else {
            [self.webView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
            [HwTools UserDefaultsObj:@"YES" key:IS_ENABLE_DRAG_REFRESH];
            self.webView.scrollView.bounces = YES;
        }
        
        
        
        
        if ([globalArray[4] isEqualToString:@"0"]) {
            
            [HwTools UserDefaultsObj:@"NO" key:IS_ENABLE_CLOSE];
        }else {
            
            [HwTools UserDefaultsObj:@"YES" key:IS_ENABLE_CLOSE];
        }
        if (globalArray.count > 7) {
            if (((NSString *)globalArray[7]).length > 0) {
                [HwTools UserDefaultsObj:globalArray[7] key:BACKGROUNDCOLOR];
                self.wkWebView.scrollView.backgroundColor = [HwTools hexStringToColor:globalArray[7]];
            }
        }
    }
    if ([messageName isEqualToString:@"PushMsgConfig"]) {
        /*调用本地函数*/
        [self PushMsgConfig:messageBody];
    }
    if ([messageName isEqualToString:@"buttonClicked"]) {
        
        NSArray *arrFucnameAndParameter = [messageBody componentsSeparatedByString:@"$$"];
        if(2 == [arrFucnameAndParameter count])
        {
            
            [self picShow:[arrFucnameAndParameter objectAtIndex:0] current:[arrFucnameAndParameter objectAtIndex:1]];
            
        }
   
    }
    if ([messageName isEqualToString:@"SetDragRefresh"]) {
        
        if ([messageBody intValue] == 0) {
            [self.wkWebView.scrollView removeHeader];
            self.wkWebView.scrollView.bounces = NO;
        }else {
            [self.wkWebView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
            self.wkWebView.scrollView.bounces = YES;
            
        }
        
    }
    if ([messageName isEqualToString:@"SetHeadBar"]) {
        
        if ([messageBody intValue] == 0) {
            self.navigationController.navigationBarHidden = YES;
        }else {
            self.navigationController.navigationBarHidden = NO;
        }
    
    }
    if ([messageName isEqualToString:@"SetMenuBar"]) {
        
        if ([messageBody intValue] == 0) {
            
            [self hideTabBar:YES];
        }else {
            [self hideTabBar:NO];
        }
        
    }
    if ([messageName isEqualToString:@"SetFontSize"]) {
        
        [self webviewFontSize];
    }
    if ([messageName isEqualToString:@"SetBrightness"]) {
        
        [self screenBrightness:messageBody];
    }
    if ([messageName isEqualToString:@"SetMoreButton"]) {
        if ([messageBody intValue] == 0) {
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }else {
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
            [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModeTapCenterView];
        }
   
    }
    if ([messageName isEqualToString:@"MenuBarAutoHide"]) {
        if ([messageBody intValue] == 0) {
            [self stopFollowingScrollView];
            _isScrollUpOrDown = NO;
        }else {
            [self followScrollView:self.wkWebView usingTopConstraint:self.topConstraint];
            _isScrollUpOrDown = YES;
        }
    }
    if ([messageName isEqualToString:@"GoBack"]) {
        
        [self goBackView];
    }
    if ([messageName isEqualToString:@"GoTop"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if ([messageName isEqualToString:@"Scan"]) {
        
        [self scanOneScan:NO];
    }
    if ([messageName isEqualToString:@"GetScan"]) {
        self.jsMethodNameStr = messageBody;
        [self scanOneScan:YES];
    }
    if ([messageName isEqualToString:@"GetHalfScan"]) {
        NSArray *array = [messageBody componentsSeparatedByString:@","];
        HwReaderView *rView = [[HwReaderView alloc] initWithFrame:CGRectMake(0, [array[1] floatValue], [UIScreen mainScreen].bounds.size.width, [array[2] floatValue])];
        rView.completionHandler = ^(NSString *itemStr) {
            NSString *str = [NSString stringWithFormat:@"%@('%@')",array[0],itemStr];
            [rView removeFromSuperview];
            if (self.wkWebView) {
                [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
                    NSLog(@"----%@",error);
                }];
            }
        };
        [self.view addSubview:rView];
    }
    if ([messageName isEqualToString:@"CloseScan"]) {
        for (UIView *vi in self.view.subviews) {
            if ([vi isKindOfClass:[HwReaderView class]]) {
                [vi removeFromSuperview];
            }
        }
    }
    if ([messageName isEqualToString:@"IsReloadPreviousPage"]) {
        if (messageBody != nil) {
            [[NSUserDefaults standardUserDefaults] setObject:messageBody forKey:@"IsReloadPreviousPage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if ([messageName isEqualToString:@"IsReloadNextPage"]) {
        if (messageBody != nil) {
            [[NSUserDefaults standardUserDefaults] setObject:messageBody forKey:@"IsReloadNextPage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if ([messageName isEqualToString:@"ImageViewState"]) {
#warning 图片预览
        if ([messageBody intValue] == 1) {
            _is9vImg = YES;
            NSString* js9vimg = [self imageClickScriptToAddToDocument];
            [self.wkWebView evaluateJavaScript:js9vimg completionHandler:nil];
        }
    }
    if ([messageName isEqualToString:@"AnimationWay"]) {
        _isNewpage = YES;
        NSArray *array = [messageBody componentsSeparatedByString:@","];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.animation = [NSArray arrayWithArray:array];
    }
    if ([messageName isEqualToString:@"Share"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        
        ShareModel *model = [[ShareModel alloc] init];
        if (globalArray.count > 3) {
            model.sTitle = [globalArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            model.sContent = [globalArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            model.sImage = [globalArray[2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            model.sUrl = [globalArray[3] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        jsstr = [globalArray lastObject];
        [self shareToShare:model];
        [self shareCallBack];
    }
    if ([messageName isEqualToString:@"ClearCache"]) {
//        [self setNavbarTitleColor:nil];
        [self setLeftOrRightSideView];
//        [self clearCache];
    }
    if ([messageName isEqualToString:@"SetAlipayInfo"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@"[,]"];
        [self goalipay:@[globalArray[0],globalArray[1],globalArray[2],globalArray[3]]];
    }
    if ([messageName isEqualToString:@"SetWxpayInfo"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@"[,]"];
        [self sendPay_demo:@[globalArray[0],globalArray[1],globalArray[2],globalArray[3],globalArray[4]]];
    }
    if ([messageName isEqualToString:@"CiticWxPay"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@"[,]"];
        [self citicWxPay:globalArray];
    }
    if ([messageName isEqualToString:@"WftWxpayInfo"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@"[,]"];
        [self wftWxPay:globalArray];
    }
    if ([messageName isEqualToString:@"BeeCloudPay"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@"[,]"];
        [self doBCPay:globalArray];
    }
    if ([messageName isEqualToString:@"WXLogin"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        [self sendAuthRequest:@[globalArray[0],globalArray[1]]];
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        }
    }
    if ([messageName isEqualToString:@"QQLogin"]) {
        
        
        NSString *url = [NSString stringWithFormat:@"%@",message.body];
        NSLog(@"-%@-",url);
        [HwTools UserDefaultsObj:url key:@"qqweburl"];
        [[HwTools shareTools] initQQloading];
        
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        }
    }
    if ([messageName isEqualToString:@"SpeechRecognition"]) {
        
        
        self.jsMethodNameStr = messageBody;
        [self mscVoice];
        
    }
    if ([messageName isEqualToString:@"SetReturnButtonMode"]) {
        if ([messageBody intValue] == 0) {
            _isShowBackMenu = NO;
            [self hideBackMenu];
        }else {
            _isShowBackMenu = YES;
            [self showBackMenu];
        }
    }
    if ([messageName isEqualToString:@"SetStatusBarStyle"]) {
        if ([messageBody intValue] == 0) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }else {
           [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }
    if ([messageName isEqualToString:@"ShowTopRightMenu"]) {
        
        [self showMenu];
    }
    if ([messageName isEqualToString:@"GetGPS"]) {
        
        [self startLoc];
        
        
        self.jsMethodNameStr = messageBody;
        self.isGetGPS = YES;
    }
    if ([messageName isEqualToString:@"OpenGPS"]) {
        
        _isTimeLoc = YES;
        _locUserId = messageBody;
        if (_locUserId.length == 0) {
            _locUserId = @"1";
        }
        [self startLoc];
    }
    if ([messageName isEqualToString:@"CloseGPS"]) {
        
        _isTimeLoc = NO;
        [self stopLoc];
    }
    if ([messageName isEqualToString:@"GetDeviceInformation"]) {
        NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *str = [NSString stringWithFormat:@"%@('%@')",messageBody,identifier];
        [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
            NSLog(@"----%@",error);
        }];
    }
    if ([messageName isEqualToString:@"GetWifiSsid"]) {
        NSString *str = [NSString stringWithFormat:@"%@('%@')",messageBody,[self getDeviceSSID]];
        [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
            NSLog(@"----%@",error);
        }];
    }
    if ([messageName isEqualToString:@"GetHealthStep"]) {
        jsstr = messageBody;
        [self queryHealthStepCount];
    }
    if ([messageName isEqualToString:@"UseTouchID"]) {
        NSArray *globalarray = [messageBody componentsSeparatedByString:@","];
        [self setzhiwen:globalarray];
        NSLog(@"%@",messageBody);
    }
    if ([messageName isEqualToString:@"UploadImage"]) {
        
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        [self.imageUploadPluginArray removeAllObjects];
        [globalArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.imageUploadPluginArray addObject:obj];
        }];
        [self addImgBtnClick];
    }
    if ([messageName isEqualToString:@"OpenWithSafari"]) {
        
        [self openWithSafari:[message body]];
    }
    if ([messageName isEqualToString:@"openUCBrower"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        [self openWithUcBrower:globalArray];
    }
    if ([messageName isEqualToString:@"OpenNewWindow"]) {
        _isOpenNewWindow = YES;
       
    }
    if ([messageName isEqualToString:@"GetClientIDOfGetui"]) {
        NSString *clientIdStr = nil;
        clientIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MYCLIENTID"];
        NSString *str = [NSString stringWithFormat:@"%@('%@')",messageBody,clientIdStr];
        [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
            NSLog(@"----%@",error);
        }];
    }
    if ([messageName isEqualToString:@"SetBgColor"]) {
        self.wkWebView.scrollView.backgroundColor = [HwTools hexStringToColor:messageBody];
    }
    
    if ([messageName isEqualToString:@"PopUp"]) {
        
        NSString *arrFucnameAndParameterStr = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AKTabBarController *akTab = [self akTabBarController];
        
        NSArray *globalArray = [arrFucnameAndParameterStr componentsSeparatedByString:@","];
        
        
        NSRange range=[globalArray[0] rangeOfString:@"|"];
        if(range.location!=NSNotFound){
            NSArray *indexArray = [[globalArray objectAtIndex:0] componentsSeparatedByString:@"|"];
            NSArray *badgeArray = [[globalArray objectAtIndex:1] componentsSeparatedByString:@"|"];
            if (indexArray.count == badgeArray.count) {
                for (int i = 0; i < indexArray.count; i++) {
                    [akTab setBadgeValue:badgeArray[i] forItemAtIndex:[indexArray[i] intValue]];
                }
            }
            
            
        }else {
            [akTab setBadgeValue:globalArray[1] forItemAtIndex:[globalArray[0] intValue]];
        }
        
    }
    if ([messageName isEqualToString:@"RongyunLogin"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        [[RongyunDev sharedObject]requestToken:globalArray[0] andName:globalArray[1] andtoken:globalArray[2]andportaitUrl:globalArray[3]];
    }
    if ([messageName isEqualToString:@"InitiateChat"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"---®%@",globalArray);
        ChatViewController *view = [[RongyunDev sharedObject]creatChat:globalArray[0] andChatName:globalArray[1]andheadurl:[globalArray lastObject]];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:view animated:YES];
        
    }
    if ([messageName isEqualToString:@"SessionList"]) {
        ChatListViewController *listView = [[ChatListViewController alloc]init];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:listView animated:YES];
    }
    if ([messageName isEqualToString:@"RefreshUserInfo"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        [[RongyunDev sharedObject] setUserid:globalArray[0] andname:globalArray[1] andportraitUrl:globalArray[2]];
        
    }
    if ([messageName isEqualToString:@"CreateDiscussGroup"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSArray *userid = [globalArray[0] componentsSeparatedByString:@"|"];
        NSString *distargetID = globalArray[2];
        [[RCIMClient sharedRCIMClient] createDiscussion:globalArray[1] userIdList:userid success:^(RCDiscussion *discussion) {
            RCDiscussion *dis = (RCDiscussion *)discussion;
            NSString *discussionID = [NSString stringWithFormat:@"%@('%@')",distargetID,dis.discussionId];
            [self.wkWebView evaluateJavaScript:discussionID completionHandler:^(id obj, NSError *  error) {
                NSLog(@"---%@",error);
            }];
        } error:^(RCErrorCode status) {
            
        }];
        
    }
    if ([messageName isEqualToString:@"OpenDiscussGroup"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        ChatViewController *view = [[RongyunDev sharedObject] creatchatRoom:globalArray[0] andRoomName:globalArray[1]];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:view animated:YES];
    }
    if ([messageName isEqualToString:@"AddDiscussGroup"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        [[RongyunDev sharedObject] addDiscussion:globalArray andDiscussionName:globalArray[0]andheadurl:[globalArray lastObject]];
        
    }
    if ([messageName isEqualToString:@"RemoveDiscussGroup"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        [[RongyunDev sharedObject] remDiscussion:globalArray[1] andDiscussionName:globalArray[0]];
    }
    if ([messageName isEqualToString:@"IntPortraitUri"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        [[RongyunDev sharedObject] setUserid:globalArray[0] andname:globalArray[1] andportraitUrl:globalArray[2]];
    }
    if ([messageName isEqualToString:@"isWXAppInstalled"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSString *functionName = [globalArray objectAtIndex:0];
        BOOL isWxInstalled = [WXApi isWXAppInstalled];
        NSString *content = [NSString stringWithFormat:@"%@('%d')",functionName,isWxInstalled];
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *  error) {
            NSLog(@"---%@",error);
        }];
    }
    if ([messageName isEqualToString:@"GetBaseInfo"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSString *functionName = [globalArray objectAtIndex:0];
        NSString *info =[NSString stringWithFormat:@"%@", [[DeviceInfoObject sharedObject] retanDeviceInfo]];
        info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
        info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *content =[NSString stringWithFormat:@"%@('%@')",functionName,info];
        NSLog(@"设备信息：%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *  error) {
            NSLog(@"---%@",error);
        }];
    }
    if ([messageName isEqualToString:@"GpsState"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSString *functionName = [globalArray objectAtIndex:0];
        NSString *isopenGps = [[IsLocationGPS sharedObject] retanIsOpenGPS] ;
        isopenGps = [isopenGps stringByReplacingOccurrencesOfString:@" " withString:@""];
        isopenGps = [isopenGps stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *content = [NSString stringWithFormat:@"%@('%@')",functionName,isopenGps];
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *  error) {
            NSLog(@"---%@",error);
        }];
    }
    if ([messageName isEqualToString:@"ContactAll"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSString *functionName = [globalArray objectAtIndex:0];
        NSString *allphone =[NSString stringWithFormat:@"%@", [[AddressBookClass sharedObject] chackAllpeopleInfo]];
        
        allphone = [allphone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        allphone = [allphone stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        allphone = [allphone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        allphone = [allphone stringByReplacingOccurrencesOfString:@" "  withString:@""];
        NSString *content = [NSString stringWithFormat:@"%@('%@')",functionName,allphone];
        NSLog(@"---%@---",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *  error) {
            NSLog(@"---%@",error);
        }];
    }
    if ([messageName isEqualToString:@"ContactSelect"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        UIViewController *view =(UIViewController *)[[AddressBookClass sharedObject] selectPeople];
        [self presentViewController:view animated:YES completion:nil];
        [AddressBookClass sharedObject].complateString = ^(NSString* str) {
            NSLog(@"--@@@--%@",str);
            
            NSString *functionName = [globalArray lastObject];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *content = [NSString stringWithFormat:@"%@('%@')",functionName,str];
            NSLog(@"%@,-------%@",content,[content class]);
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *  error) {
                NSLog(@"---%@",error);
            }];
        };
        
    }
    if ([messageName isEqualToString:@"ContactAdd"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[AddressBookClass sharedObject] addperson:globalArray];
        [AddressBookClass sharedObject].complate = ^(BOOL result) {
            NSLog(@"--@@@--%d",result);
            
            NSString *functionName = [globalArray lastObject];
            NSString *content = [NSString stringWithFormat:@"%@('%d')",functionName,result];
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *  error) {
                NSLog(@"---%@",error);
            }];
        };

    }
    if ([messageName isEqualToString:@"ContactDelete"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        
        [[AddressBookClass sharedObject]deleteperson:globalArray];
        [AddressBookClass sharedObject].complate = ^(BOOL result) {
            NSLog(@"--@@@--%d",result);
            NSString *functionName = [globalArray lastObject];
            NSString *content = [NSString stringWithFormat:@"%@('%d')",functionName,result];
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *  error) {
                NSLog(@"---%@",error);
            }];
        };
        
    }
    if ([messageName isEqualToString:@"ContactUpdate"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[AddressBookClass sharedObject] updataperson:globalArray];
        [AddressBookClass sharedObject].complate = ^(BOOL result) {
            NSLog(@"--@@@--%d",result);
            NSString *functionName = [globalArray lastObject];
            NSString *content = [NSString stringWithFormat:@"%@('%d')",functionName,result];
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *  error) {
                NSLog(@"---%@",error);
            }];
        };
        
        
    }
    if ([messageName isEqualToString:@"StopVoice"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[AFSoundManager sharedManager]stop];
        
    }
    if ([messageName isEqualToString:@"PauseVoice"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[AFSoundManager sharedManager]pause];
        
    }
    if ([messageName isEqualToString:@"PlayVoice"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[AFSoundManager sharedManager]resume];
        
    }
    if ([messageName isEqualToString:@"VolumeVideo"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        /*
        NSLog(@"-----%@",globalArray);
        [[AFSoundManager sharedManager] changeVolumeToValue:[globalArray[0] floatValue]];
         */
        MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
        mpc.volume =[globalArray[0] floatValue];

    }
    if ([messageName isEqualToString:@"OpenVideo"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        
        NSString *urlstr = [globalArray[0]stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",urlstr);
        urlstr = [urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *movieUrl = [NSURL URLWithString:urlstr];
        NSLog(@"%@",urlstr);
        moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:movieUrl];
        
        moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
        
        moviePlayer.scalingMode =   MPMovieScalingModeAspectFit;
        
        [moviePlayer prepareToPlay];

        [moviePlayer.view setFrame:self.view.frame];
        
        moviePlayer.shouldAutoplay = YES;
        
        [self.view addSubview:moviePlayer.view];
        if (!moviePlayer.isFullscreen) {
            [moviePlayer setFullscreen:YES animated:YES];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    }
    
    if ([messageName isEqualToString:@"StartVoice"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[AFSoundManager sharedManager]startStreamingRemoteAudioFromURL:globalArray[0] andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
            
            if (!error) {
                
            } else {
                
                NSLog(@"There has been an error playing the remote file: %@", [error description]);
            }
            
        }];
    }
    if ([messageName isEqualToString:@"NavigatorInfo"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        NSString *result =  [[MapNavigationManager sharedObject] returnNavigationInfo];
        result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *functionName = [globalArray lastObject];
        NSString *content = [NSString stringWithFormat:@"%@('%@')",functionName,result];
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *  error) {
            NSLog(@"---%@",error);
        }];
        
    }
    if ([messageName isEqualToString:@"NavigatorBaidu"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[MapNavigationManager sharedObject] openBaiduMap];
        
    }
    if ([messageName isEqualToString:@"NavigatorGaode"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[MapNavigationManager sharedObject] openGaodeMap];
        
    }
    if ([messageName isEqualToString:@"NavigatorGoogle"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[MapNavigationManager sharedObject] openGoogleMap];
        
    }
    if ([messageName isEqualToString:@"NavigatorGaodePath"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[MapNavigationManager sharedObject]gaodeDaohang:globalArray];
        
    }
    if ([messageName isEqualToString:@"appleNavigation"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[MapNavigationManager sharedObject]iosMap:globalArray];
        
    }
    if ([messageName isEqualToString:@"NavigatorBaiduPath"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        [[MapNavigationManager sharedObject]baiduMap:globalArray];
    }
    if ([messageName isEqualToString:@"BLinitManager"]){
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        ble = [Kble sharedObject];
        NSString *info =[ble createManager];
        
        ble.StateString =^(NSString *state){
            NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",globalArray[0],state];
            NSLog(@"%@",content);
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
                NSLog(@"%@",error);
            }];
            
        };
    }
    if ([messageName isEqualToString:@"BLscan"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        ble = [Kble sharedObject];
        NSString *info = [ble scan:nil];
        NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",globalArray[0],info];
        NSLog(@"%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    if ([messageName isEqualToString:@"BLgetPeripheral"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        ble = [Kble sharedObject];
        NSString *info = [ble getPeripheral:nil];
        info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
        info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",globalArray[0],info];
        NSLog(@"%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    if ([messageName isEqualToString:@"BLisScanning"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        ble = [Kble sharedObject];
        NSString *info = [ble isScanning:nil];
        NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",globalArray[0],info];
        NSLog(@"%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    if ([messageName isEqualToString:@"BLstopScan"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        ble = [Kble sharedObject];
        NSString *info = [ble stopScan:nil];
        NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",globalArray[0],info];
        NSLog(@"%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    if ([messageName isEqualToString:@"BLconnect"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        ble = [Kble sharedObject];
        NSString *uuid = [globalArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *info = [ble connect:uuid];
        NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",[globalArray lastObject],info];
        NSLog(@"%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    if ([messageName isEqualToString:@"BLdisconnect"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        ble = [Kble sharedObject];
        NSString *info = [ble disconnect:[globalArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",[globalArray lastObject],info];
        NSLog(@"%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    if ([messageName isEqualToString:@"BLisConnected"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        NSLog(@"-----%@",globalArray);
        ble = [Kble sharedObject];
        NSString *info = [ble isConnected:[globalArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",[globalArray lastObject],info];
        NSLog(@"%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError * error) {
            NSLog(@"%@",error);
        }];
    }
    if ([messageName isEqualToString:@"BLretrievePeripheral"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"]" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSMutableArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        [globalArray removeLastObject];
        NSLog(@"-----%@",globalArray);
        ble = [Kble sharedObject];
        
        NSString *info = [ble retrievePeripheral:globalArray];
        info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
        info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,info];
        NSLog(@"%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    /*根据指定的服务，找到当前系统处于连接状态的蓝牙中包含这个服务的所有蓝牙外围设备信息*/
    if ([messageName isEqualToString:@"BLretrieveConnectedPeripheral"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"]" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        NSLog(@"-----%@",globalArray);
        ble = [Kble sharedObject];
        
        NSString *info = [ble retrieveConnectedPeripheral:globalArray];
        info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
        info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,info];
        NSLog(@"%@",content);
        [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    /*根据指定的外围设备 UUID 获取该外围设备的所有服务*/
    if ([messageName isEqualToString:@"BLdiscoverService"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        ble = [Kble sharedObject];
        [ble discoverService:[globalArray[0]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ble.complateString = ^(NSString *services){
            services = [services stringByReplacingOccurrencesOfString:@" " withString:@""];
            services = [services stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,services];
            NSLog(@"%@",content);
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
                NSLog(@"%@",error);
            }];
            
        };
    }
    /*根据指定的外围设备 UUID 及其服务 UUID 获取该外围设备的所有特征*/
    if ([messageName isEqualToString:@"BLdiscoverCharacteristics"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"]" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        ble = [Kble sharedObject];
        
        [ble discoverCharacteristics:globalArray];
        ble.CharacteristicString =^(NSString *info){
            info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
            info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,info];
            NSLog(@"%@",content);
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
                NSLog(@"%@",error);
            }];
        };
    }
    /*根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 获取该外围设备的所有描述符*/
    if ([messageName isEqualToString:@"BLdiscoverDescriptorsForCharacteristic"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"]" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        ble = [Kble sharedObject];
        
        [ble discoverDescriptorsForCharacteristic:globalArray];
        ble.DescriptorString =^(NSString *info){
            info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
            info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,info];
            NSLog(@"%@",content);
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
                NSLog(@"%@",error);
            }];
        };
    }
    /*根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 监听数据回发*/
    if ([messageName isEqualToString:@"BLsetNotify"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"]" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        ble = [Kble sharedObject];
        
        [ble setNotify:globalArray];
        ble.NotifyString =^(NSString *info){
            info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
            info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,info];
            NSLog(@"%@",content);
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
                NSLog(@"%@",error);
            }];
        };
    }
    
    /*根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 监听数据回发*/
    if ([messageName isEqualToString:@"BLreadValueForCharacteristic"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"]" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        ble = [Kble sharedObject];
        
        [ble readValueForCharacteristic:globalArray];
        ble.NotifyString =^(NSString *info){
            info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
            info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,info];
            NSLog(@"%@",content);
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
                NSLog(@"%@",error);
            }];
        };
    }
    /*根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 及其描述符获取数据*/
    if ([messageName isEqualToString:@"BLreadValueForDescriptor"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"]" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        ble = [Kble sharedObject];
        
        [ble readValueForDescriptor:globalArray];
        ble.readDescriptorString =^(NSString *info){
            info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
            info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,info];
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
                NSLog(@"%@",error);
            }];
        };
    }
    /*根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 写数据*/
    if ([messageName isEqualToString:@"BLwriteValueForCharacteristic"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"]" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        ble = [Kble sharedObject];
        
        [ble writeValueForCharacteristic:globalArray];
        ble.writeString =^(NSString *info){
            NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,info];
            NSLog(@"%@",content);
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj, NSError *error) {
            }];
        };
    }
    /*根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 写数据*/
    if ([messageName isEqualToString:@"BLwriteValueForDescriptor"]) {
        NSString *message = [messageBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        message = [message stringByReplacingOccurrencesOfString:@"[" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"]" withString:@""];
        message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *globalArray = [message componentsSeparatedByString:@","];
        NSString *back = [globalArray lastObject];
        ble = [Kble sharedObject];
        [ble writeValueForDescriptor:globalArray];
        ble.writeString =^(NSString *info){
            info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
            info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *content = [[NSString alloc]initWithFormat:@"%@('%@')",back,info];
            [self.wkWebView evaluateJavaScript:content completionHandler:^(id obj,  NSError *error) {
                NSLog(@"%@",error);
            }];
        };
    }
    if ([messageName isEqualToString:@"iOSSystemShare"]) {
        NSArray *globalArray = [messageBody componentsSeparatedByString:@","];
        StringsXmlBase *xBase = [StringsXML getStringXmlBase];
        NSString *imgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@%@",xBase.appsid,@"shareImage"]];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:globalArray[1]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            NSData *imgData = UIImagePNGRepresentation(image);
            [imgData writeToFile:imgPath atomically:YES];
            NSLog(@"下载完成");
            [self share:globalArray];
            
        }];
    }
    if ([messageName isEqualToString:@"copyPasteboardText"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = messageBody;
        
    }
    if ([messageName isEqualToString:@"statusBarHidden"]) {
        if ([messageBody intValue] == 0) {
            [UIApplication sharedApplication].statusBarHidden = YES;
        }else {
            [UIApplication sharedApplication].statusBarHidden = NO;
        }
        [self reloadStatusBar];
    }
}
-(void)playbackDidFinish{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [moviePlayer.view removeFromSuperview];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"goodInfo", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"submit", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
    completionHandler();
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"goodInfo", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"submit", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler {
    //    NSString *hostString = webView.URL.host;
    //    NSString *sender = [NSString stringWithFormat:@"%@からの表示", hostString];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"goodInfo", nil) message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
        [textField resignFirstResponder];
    }];
    [alertController.textFields.firstObject resignFirstResponder];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"submit", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}
- (void)timeoutRequest {
    
    return;
    NSMutableDictionary *stringDic = [[StringsXML shareStringsXML] jiexiStringsXML:@"strings"];
    StringsXmlBase *base = [StringsXmlBase modelObjectWithDictionary:stringDic];
    NSString *urlString = [NSString stringWithFormat:@"http://apiinfoios.ydbimg.com/Default.aspx?type=app&id=%@",base.appsid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"=responseObject=%@",responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"=error=%@",error);
        [self.wkWebView stopLoading];
        [self.timeOutTimer invalidate];
        self.timeOutTimer = nil;
        [self hideAldClock];
        [self updateLoadingStatus];
        self.reloadControl.hidden = NO;
        self.isWkWebViewFailLoad = YES;
    }];
}


- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount]== 0) {
        _authed = YES;
        /**NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。**/
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
    else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
    
    
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _authed = YES;
    if (self.wkWebView) {
        [self.wkWebView loadRequest:_authRequest];
    }else {
        [self.webView loadRequest:_authRequest];
    }
    
    
    [connection cancel];
}




- (void)addImgBtnClick
{
    
    NSLog(@"addImgBtnClick");
    NSArray *sourceType = @[@"拍照",@"相册"];
    if (self.imageUploadPluginArray.count == 8) {
        if ([self.imageUploadPluginArray[7] isEqualToString:@"0"]) {
            sourceType = @[@"拍照",@"相册"];
        }else if ([self.imageUploadPluginArray[7] isEqualToString:@"1"]) {
            sourceType = @[@"拍照"];
        }else if ([self.imageUploadPluginArray[7] isEqualToString:@"2"]) {
            sourceType = @[@"相册"];
        }
    }
    
    UIActionSheet *sheet = [UIActionSheet actionSheetWithStyle:UIActionSheetStyleDefault title:@"上传图片" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:sourceType completionBlock:^(UIActionSheet *actionSheet, NSInteger selectedButtonIndex) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setDelegate:self];
        
        
        if ([self.imageUploadPluginArray[4] isEqualToString:@"1"]) {
            imagePickerController.allowsEditing = YES;
        }
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage,kUTTypeMovie,nil];
        
        
        if (self.imageUploadPluginArray.count == 8) {
            if ([self.imageUploadPluginArray[7] isEqualToString:@"0"]) {
                if (selectedButtonIndex == 0) {
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                        
                    }
                    
                }
                if (selectedButtonIndex == 1) {
                    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                    
                    
                }
            }else if ([self.imageUploadPluginArray[7] isEqualToString:@"1"]) {
                if (selectedButtonIndex == 0) {
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                        
                    }
                    
                }
            }else if ([self.imageUploadPluginArray[7] isEqualToString:@"2"]) {
                if (selectedButtonIndex == 0) {
                    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                    
                }
            }
        }else {
            if (selectedButtonIndex == 0) {
                [self presentViewController:imagePickerController animated:YES completion:nil];
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                    
                }
                
            }
            if (selectedButtonIndex == 1) {
                [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [self presentViewController:imagePickerController animated:YES completion:nil];
                
                
            }
        }
        
        
    } cancelBlock:^{
        
    }];
    
    [sheet showInView:self.view];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        NSData *imageData;
        NSString *fileNmaeStr;
        
        if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
            UIImage *portraitImg = nil;
            if ([self.imageUploadPluginArray[4] isEqualToString:@"1"]) {
                
                portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
                portraitImg = [portraitImg scaleToSize:CGSizeMake([self.imageUploadPluginArray[5] floatValue], [self.imageUploadPluginArray[6] floatValue])];
                imageData = UIImageJPEGRepresentation(portraitImg, 1);
            }else {
                portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                portraitImg = [portraitImg fixOrientation:UIImageOrientationUp];
                imageData = UIImageJPEGRepresentation(portraitImg, 0.1);
            }
            
            fileNmaeStr = @"ydb.jpg";
        }
        
        if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"]) {
            NSString *mediaUrlStr = [info objectForKey:@"UIImagePickerControllerMediaURL"];
            
            
            
            imageData = [NSData dataWithContentsOfFile:mediaUrlStr];
            fileNmaeStr = @"ydb.mov";
        }
        
        
        
        NSString *urlStr = self.imageUploadPluginArray[0];
        
        
        [self showAldClock];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
        
        [muDic setObject:[[self.imageUploadPluginArray[2] componentsSeparatedByString:@":"] lastObject] forKey:[[self.imageUploadPluginArray[2] componentsSeparatedByString:@":"] firstObject]];
        [muDic setObject:[[self.imageUploadPluginArray[3] componentsSeparatedByString:@":"] lastObject] forKey:[[self.imageUploadPluginArray[3] componentsSeparatedByString:@":"] firstObject]];
        
        [manager POST:urlStr parameters:muDic constructingBodyWithBlock:^(id formData) {
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileNmaeStr mimeType:@"application/octet-stream"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"pic----suc---%@----%@",responseObject,[responseObject class]);
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"pic----succ---%@",aString);
            
            NSString *str = [NSString stringWithFormat:@"%@('%@')",self.imageUploadPluginArray[1],aString];
            if (self.wkWebView) {
                [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
                    NSLog(@"----%@",error);
                }];
            }else {
                [self.webView stringByEvaluatingJavaScriptFromString:str];
            }
            
            
            [self hideAldClock];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"pic----fai---%@",error);
            [self hideAldClock];
            
        }];
        
        
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

- (void)openWithSafari:(NSString *)urlStr {
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
- (void)openWithUcBrower:(NSArray *)ucArr {
    NSString *url1 = [[ucArr firstObject] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url2 = [[ucArr lastObject] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ucbrowser://"]]) {
        [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"ucbrowser://%@",url1]]];
        NSLog(@"open uc...");
    }else {
        [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:url2]];
        NSLog(@"没有安装UC");
    }
}
#pragma mark - BCPay 微信、支付宝、银联、百度钱包

- (void)doBCPay:(NSArray *)bcpay {
    //    BeeCloudPay(channel, bill_no, title, total_fee, optional, return_url)
    //    BeeCloudPay(渠道类型, 商户订单号, 订单标题, 订单总金额, 附加数据, 同步返回页面)
    
    if (bcpay.count != 6) {
        [SVProgressHUD showErrorWithStatus:@"支付配置有误,请检查"];
        return;
    }
    weixinPayretrueUrl = bcpay[5];
    orderNo = [NSString stringWithFormat:@"%@",bcpay[1]];
    NSInteger payChannel = 0;
    if ([bcpay[0] isEqualToString:@"WX_APP"]) {
        payChannel = PayChannelWxApp;
    }
    if ([bcpay[0] isEqualToString:@"ALI_APP"]) {
        payChannel = PayChannelAliApp;
    }
    if ([bcpay[0] isEqualToString:@"UN_APP"]) {
        payChannel = PayChannelUnApp;
    }
    if ([bcpay[0] isEqualToString:@"BD_APP"]) {
        payChannel = PayChannelBaiduApp;
    }
    NSString *optionalStr = bcpay[4];
    optionalStr = [optionalStr stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSData *optionalJsonData = [optionalStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *optionalDic = [NSJSONSerialization JSONObjectWithData:optionalJsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSString *totalFeeStr = bcpay[3];
    totalFeeStr = [NSString stringWithFormat:@"%.f",totalFeeStr.floatValue * 100];
    BCPayReq *payReq = [[BCPayReq alloc] init];
    /**
     *  支付渠道，PayChannelWxApp,PayChannelAliApp,PayChannelUnApp,PayChannelBaiduApp
     */
    payReq.channel = payChannel; //支付渠道
    payReq.title = bcpay[2];//订单标题
    payReq.totalFee = totalFeeStr;//订单价格; channel为BC_APP的时候最小值为100，即1元
    payReq.billNo = bcpay[1];//商户自定义订单号
    payReq.scheme = @"payDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.cardType = 0; //0 表示不区分卡类型；1 表示只支持借记卡；2 表示支持信用卡；默认为0
    payReq.optional = optionalDic;//商户业务扩展参数，会在webhook回调时返回
    [BeeCloud sendBCReq:payReq];
}

#pragma mark - BCPay回调

- (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
            // 支付请求响应
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                BCPayReq *payReq = (BCPayReq *)resp.request;
                //百度钱包比较特殊需要用户用获取到的orderInfo，调用百度钱包SDK发起支付
                if (payReq.channel == PayChannelBaiduApp && ![BeeCloud getCurrentMode]) {
                    [[BDWalletSDKMainManager getInstance] doPayWithOrderInfo:tempResp.paySource[@"orderInfo"] params:nil delegate:self];
                } else {
                    //微信、支付宝、银联支付成功
                    [self showAlertView:resp.resultMsg];
                }
            } else {
                //支付取消或者支付失败
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
            
        default:
        {
            if (resp.resultCode == 0) {
                [self showAlertView:resp.resultMsg];
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",resp.resultMsg, resp.errDetail]];
            }
        }
            break;
    }
}
- (void)showAlertView:(NSString *)msg {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - Baidu Delegate
- (void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString *)payDescs {
    NSString *status = @"";
    switch (statusCode) {
        case 0:
            status = @"支付成功";
            break;
        case 1:
            status = @"支付中";
            break;
        case 2:
            status = @"支付取消";
            break;
        default:
            break;
    }
    [self showAlertView:status];
}
#pragma mark ---微付通微信支付---
- (void)wftWxPay:(NSArray *)wxpay {
    StringsXmlBase *xbase = [StringsXML getStringXmlBase];
    NSString *service = @"unified.trade.pay";
    NSString *version = @"1.0";
    NSString *charset = @"UTF-8";
    NSString *sign_type = @"MD5";
    NSString *device_info = @"WP10000100001";
    
    
    NSString *mch_id = xbase.WFTWXMCH;
    NSString *out_trade_no = wxpay[3];
    
    NSString *body = wxpay[1];
    
    NSString *totalFeeStr = wxpay[2];
    NSInteger total_fee = [[NSString stringWithFormat:@"%.f",totalFeeStr.floatValue * 100] integerValue];
    
    NSString *mch_create_ip = @"127.0.0.1";
    NSString *notify_url = xbase.WFTWXNOTIFYURL;
    NSString *time_start;
    NSString *time_expire;
    NSString *nonce_str = [NSString spay_nonce_str];
    
    NSNumber *amount = [NSNumber numberWithInteger:total_fee];
    orderNo = [NSString stringWithFormat:@"%@",wxpay[3]];
    attach = [NSString stringWithFormat:@"%@",wxpay[4]];
    //生成提交表单
    NSDictionary *postInfo = [[SPRequestForm sharedInstance]
                              spay_pay_gateway:service
                              version:version
                              charset:charset
                              sign_type:sign_type
                              mch_id:mch_id
                              out_trade_no:out_trade_no
                              device_info:device_info
                              body:body
                              total_fee:total_fee
                              mch_create_ip:mch_create_ip
                              notify_url:notify_url
                              time_start:time_start
                              time_expire:time_expire
                              nonce_str:nonce_str];
    
    
    NSLog(@"%@",postInfo);
    
    //调用支付预下单接口
    [[SPHTTPManager sharedInstance] post:kSPconstWebApiInterface_spay_pay_gateway
                                paramter:postInfo
                                 success:^(id operation, id responseObject) {
                                     
                                     
                                     //返回的XML字符串,如果解析有问题可以打印该字符串
                                     //        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
                                     
                                     NSError *erro;
                                     //XML字符串 to 字典
                                     //!!!! XMLReader最后节点都会设置一个kXMLReaderTextNodeKey属性
                                     //如果要修改XMLReader的解析，请继承该类然后再去重写，因为SPaySDK也是调用该方法解析数据，如果修改了会导致解析失败
                                     NSDictionary *info = [XMLReader dictionaryForXMLData:(NSData *)responseObject error:&erro];
                                     
                                     NSLog(@"预下单接口返回数据-->>\n%@",info);
                                     
                                     
                                     //判断解析是否成功
                                     if (info && [info isKindOfClass:[NSDictionary class]]) {
                                         
                                         NSDictionary *xmlInfo = info[@"xml"];
                                         
                                         NSInteger status = [xmlInfo[@"status"][@"text"] integerValue];
                                         
                                         //判断SPay服务器返回的状态值是否是成功,如果成功则调起SPaySDK
                                         if (status == 0) {
                                             
                                             
                                             
                                             //获取SPaySDK需要的token_id
                                             NSString *token_id = xmlInfo[@"token_id"][@"text"];
                                             
                                             //获取SPaySDK需要的services
                                             NSString *services = xmlInfo[@"services"][@"text"];
                                             
                                             
                                             
                                             //调起SPaySDK支付
                                             [[SPayClient sharedInstance] pay:self
                                                                       amount:amount
                                                            spayTokenIDString:token_id
                                                            payServicesString:@"pay.weixin.app"
                                                                       finish:^(SPayClientPayStateModel *payStateModel,
                                                                                SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                                                           
                                                                           //更新订单号
#warning 暂时注释
                                                                           //                                                                               weakSelf.out_trade_noText.text = [NSString spay_out_trade_no];
                                                                           
                                                                           
                                                                           if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                                                               
                                                                               NSLog(@"支付成功");
                                                                               NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                                                           }else{
                                                                               NSLog(@"支付失败，错误号:%d",payStateModel.payState);
                                                                           }
                                                                           
                                                                       }];
                                             
                                             
                                             
                                             
                                         }else{
                                             [SVProgressHUD showErrorWithStatus:xmlInfo[@"message"][@"text"]];
                                             
                                         }
                                     }else{
                                         [SVProgressHUD showErrorWithStatus:@"预下单接口，解析数据失败"];
                                     }
                                     
                                     
                                 } failure:^(id operation, NSError *error) {
                                     [SVProgressHUD showErrorWithStatus:@"调用预下单接口失败"];
                                     
                                     NSLog(@"调用预下单接口失败-->>\n%@",error);
                                 }];
}
#pragma mark ---中信银行微信支付---
- (void)citicWxPay:(NSArray *)wxpay {
    //CiticWxPay(应用ID, 商户号, 预支付交易会话标识,随机字符串, 签名, 时间戳)
    //CiticWxPay(appid, partnerid,prepayid, noncestr, sign, timestamp)
    if (wxpay.count != 8) {
        [SVProgressHUD showErrorWithStatus:@"微信支付配置有误,请检查"];
        return;
    }
    orderNo = wxpay[6];
    attach = wxpay[7];
    NSString *timeStamp = wxpay[5];
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = wxpay[0];
    req.partnerId           = wxpay[1];
    req.prepayId            = wxpay[2];
    req.nonceStr            = wxpay[3];
    req.sign                = wxpay[4];
    req.timeStamp           = timeStamp.intValue;
    req.package             = @"Sign=WXPay";
    [WXApi sendReq:req];
}
#pragma mark ===微信支付
- (void)sendPay_demo:(NSArray *)wxpay
{
    NSLog(@"----%@",wxpay);
    for (NSString *str in wxpay) {
        NSLog(@"%@",str);
    }
    /**创建支付签名对象**/
    payRequsestHandler *req = [payRequsestHandler alloc] ;
    /**初始化支付签名对象**/
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    NSString *appid = base.wxappid;
    NSString *mchid = base.wxmchid;
    NSString *apikey = base.wxapikey;
    if (appid.length == 0 || mchid.length == 0 || apikey.length == 0) {
        [self alert:@"提示" msg:@"缺少AppID或商户ID或API秘钥"];
        return;
    }
    [req init:base.wxappid mch_id:base.wxmchid];
    /**设置密钥**/
    [req setKey:base.wxapikey];
    
    
    NSString *name =[NSString stringWithFormat:@"%@",[wxpay objectAtIndex:0]];
    NSString *totalFeeStr = wxpay[2];
    NSString *price = [NSString stringWithFormat:@"%.f",totalFeeStr.floatValue * 100];
    orderNo = [NSString stringWithFormat:@"%@",wxpay[3]];
    attach = [NSString stringWithFormat:@"%@",wxpay[4]];
    NSLog(@"%@,%@",name,price);
    /**    NSString *name;
     //    NSString *price;
     //获取到实际调起微信支付的参数后，在app端调起支付**/
    NSString *notifyURL =[self URLDecodedString:base.wxnotifyurl];
    if (notifyURL == nil ||notifyURL.length == 0|| notifyURL == NULL) {
        notifyURL = [wxpay lastObject];
    }
    
    NSMutableDictionary *dict = [req sendPay_demoWithName:name andPrice:price andOrderno:orderNo andnotifyURL:notifyURL andattach:attach];
    if(dict == nil){
        /*错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);**/
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        /**[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];**/
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        /**调起微信支付**/
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}
/**客户端提示信息**/
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}
-(void)weixindenglu
{
    /*微信支付成功返回页面*/
    StringsXmlBase *xmlBase = [StringsXML getStringXmlBase];
    
    NSString *wxUrlStr  = xmlBase.wxreturnurl ;
    
    wxUrlStr = [self URLDecodedString:wxUrlStr];
    
    if (wxUrlStr.length==0 ||wxUrlStr == nil || wxUrlStr == NULL) {
        wxUrlStr =weixinPayretrueUrl;
    }else{
        NSRange inwenhao=[ wxUrlStr rangeOfString:@"?"];
        if (inwenhao.location != NSNotFound) {
            wxUrlStr = [NSString stringWithFormat:@"%@&",wxUrlStr];
        }else{
            wxUrlStr = [NSString stringWithFormat:@"%@?",wxUrlStr];
        }
        
        if (orderNo.length>0) {
            if (attach.length>0) {
                wxUrlStr = [NSString stringWithFormat:@"%@outtradeno=%@&attach=%@",wxUrlStr,orderNo,attach];
            }else{
                wxUrlStr = [NSString stringWithFormat:@"%@outtradeno=%@",wxUrlStr,orderNo];
            }
        }else{
            if (attach.length>0) {
                wxUrlStr = [NSString stringWithFormat:@"%@attach=%@",wxUrlStr,attach];
            }else{
                
            }
            
        }
        if ([xmlBase.CmsSystem isEqualToString:@"1"]) {
            wxUrlStr = xiaozhuWXpayUrlStr;
        }
        if ([xmlBase.CmsSystem isEqualToString:@"2"]) {
            wxUrlStr = weiqingWxPayUrlStr;
        }
        
    }
    
    
    
    wxUrlStr = [wxUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        if (self.wkWebView) {
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wxUrlStr]]];
        }else {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wxUrlStr]]];
        }
        
    });


    
}

- (void)toTwoview:(NSNotification *)dic
{
    
    NSString *urlStr = dic.userInfo[@"url"];
    if (self.wkWebView) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }
    
    
}
#pragma mark 微信登录
-(void)sendAuthRequest:(NSArray *)array
{
    NSLog(@"---%@",array);
    NSString *returnDataType =[NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
    accessUrl=[NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
    
    
    
    [HwTools UserDefaultsObj:returnDataType key:@"returnDataType"];
    [HwTools UserDefaultsObj:accessUrl key:@"accessUrl"];
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    NSString *appid = base.wxappid;
    NSString *appkey = base.wxsecrect;
    if (appid.length == 0 || appkey.length == 0) {
        [self alert:@"提示" msg:@"缺少AppID或Appkey"];
        return;
    }
    
    /**构造SendAuthReq结构体**/
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    NSString *state =[NSString stringWithFormat:@"%d",arc4random_uniform(1000)+100 ];
    req.state = state;
    /**第三方向微信终端发送一个SendAuthReq消息结构**/
    [WXApi sendReq:req];
    
}

- (void)removeUnicomWo {
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    if ([base.isUnicom isEqualToString:@"1"]) {
        if (self.webView) {
            [self.webView stringByEvaluatingJavaScriptFromString:@"var div=document.getElementById('ever_toolbar');"
             "if(null!=div&&undefined!=div)"
             "div.parentNode.removeChild(div);"];
        }
        if (self.wkWebView) {
            [self.wkWebView evaluateJavaScript:@"var div=document.getElementById('ever_toolbar');"
             "if(null!=div&&undefined!=div)"
             "div.parentNode.removeChild(div);" completionHandler:^(id obj, NSError *error) {
                 NSLog(@"----%@",error);
             }];
        }
    }
}

- (IFlyRecognizerView *)iflyRecognizerView {
    if (!_iflyRecognizerView) {
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        
        UIView *view = _iflyRecognizerView.subviews[0];
        UILabel *label = view.subviews[1];
        label.text = @"说完了";
        label.font = [UIFont systemFontOfSize:18];
        _iflyRecognizerView.delegate = self;
        [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    }
    return _iflyRecognizerView;
}
- (BMKLocationService *)locService {
    if (!_locService) {
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [BMKLocationService setLocationDistanceFilter:100.f];
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    return _locService;
}
-(void)goalipay:(NSArray *)array
{
    StringsXmlBase *base = [StringsXML getStringXmlBase];
    NSString *partner = base.partner;
    NSString *seller = base.seller;
    NSString *privateKey = base.rsa_private;
    /*partner和seller获取失败,提示*/
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    /*
     *生成订单信息及签名
     */
    /*将商品信息赋予AlixPayOrder的成员变量*/
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = array[3];
    order.productName = array[0];
    order.productDescription =array[1];
    
    order.amount =[NSString stringWithFormat:@"%@",array[2]];
    
    order.notifyURL =[self URLDecodedString: base.notify_url];
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    /*应用注册scheme,在AlixPayDemo-Info.plist定义URL types*/
    NSString *appScheme = [[NSBundle mainBundle] bundleIdentifier];
    
    /*将商品信息拼接成字符串*/
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    /*获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode*/
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    /*将签名成功字符串格式化为订单字符串,请严格按照该格式*/
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {

            NSLog(@"reslut = %@",resultDic);
            NSString *error_code = resultDic[@"resultStatus"];
            NSString *succeed = @"9000";
            NSString *failure = @"4000";
            NSString *net_error = @"6002";
            
            if ([error_code isEqualToString:succeed]) {
                
                [SVProgressHUD showSuccessWithStatus:@"支付成功!"];
                StringsXmlBase *xmlBase = [StringsXML getStringXmlBase];
                NSString *result = resultDic[@"result"];
                NSString *urlStr = [self URLDecodedString:xmlBase.return_url];
                if ([urlStr rangeOfString:@"?"].location != NSNotFound) {
                    urlStr =[urlStr stringByAppendingFormat:@"&%@",result];
                }else{
                    urlStr =[urlStr stringByAppendingFormat:@"?%@",result];
                }
                urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    if (self.wkWebView) {
                        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
                    }else {
                        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
                    }
                    NSLog(@"url---%@",urlStr);
                    
                });
                
            }
            if ([error_code isEqualToString:failure]) {
                [SVProgressHUD showErrorWithStatus:@"支付失败!"];
            }
            if ([error_code isEqualToString:net_error]) {
                [SVProgressHUD showErrorWithStatus:@"链接失败!"];
            }
            if ([error_code isEqualToString:@"6001"]) {
                [SVProgressHUD showErrorWithStatus:@"支付取消!"];
            }
        }];
    }
    
}

- (NSString *) getDeviceSSID

{
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    
    for (NSString *ifnam in ifs) {
        
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            
            break;
            
        }
        
    }
    
    NSDictionary *dctySSID = (NSDictionary *)info;
    
    NSString *ssid = [dctySSID objectForKey:@"SSID"];
    
    return ssid;
    
}
-(void)setzhiwen:(NSArray *)array
{
    
    NSString *returnStr= array[0];
    NSString *AccessTitle;
    NSString *FallbackTitle;
    AccessTitle= [NSString stringWithFormat:@"%@",array[2]];
    if (array.count > 2) {
        FallbackTitle= [NSString stringWithFormat:@"%@",array[3]];
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue<8.0) {
        [self alert:@"提示" msg:@"不支持指纹识别"];
        
    }
    LAContext *ctx = [[LAContext alloc] init];
    ctx.localizedFallbackTitle = FallbackTitle;
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:AccessTitle reply:^(BOOL success, NSError *error) {
            NSLog(@"%d,%@",success,error);
            if (success) {
                if (self.webView) {
                    NSString *str = [NSString stringWithFormat:@"%@('%d')",returnStr,success];
                    [self.webView stringByEvaluatingJavaScriptFromString:str];
                    
                }else{
                    NSString *str = [NSString stringWithFormat:@"%@('%d')",returnStr,success];
                    [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
                        NSLog(@"----%@",error);
                    }];
                    
                }
            }else{
                if (error.code == kLAErrorUserFallback) {
                    NSLog(@"User tapped Enter Password");
                    
                    NSString *url = [NSString stringWithFormat:@"%@",array[1]];
                    if (url.length>0) {
                        if (self.wkWebView) {
                            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                        }else {
                            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                        }
                    }
                    
                } else if (error.code == kLAErrorUserCancel) {
                    NSLog(@"User tapped Cancel");
                } else {
                    NSLog(@"Authenticated failed.");
                    if (self.webView) {
                        NSString *str = [NSString stringWithFormat:@"%@('%d')",returnStr,success];
                        [self.webView stringByEvaluatingJavaScriptFromString:str];
                        
                    }else{
                        NSString *str = [NSString stringWithFormat:@"%@('%d')",returnStr,success];
                        [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
                            NSLog(@"----%@",error);
                        }];
                    }
                    
                }
                
            }
            
            
            
            
        }];
        
    }else{
        
    }
    
}
/*健康功能暂时隐藏*/
- (void)queryHealthStepCount {
    /*
     HKHealthStore *store = [[HKHealthStore alloc] init];
     
     NSSet *readObjectTypes  = [NSSet setWithObjects:
     [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount], nil];
     
     [store requestAuthorizationToShareTypes:nil readTypes:readObjectTypes completion:^(BOOL success, NSError *error) {
     
     if(!error) {
     
     NSDate *beginningOfToday = [self beginningOfToday];
     NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:beginningOfToday endDate:[NSDate date] options:HKQueryOptionStrictStartDate];
     
     
     HKQuantityType *stepsQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
     
     
     
     HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:stepsQuantityType predicate:predicate limit:500 sortDescriptors:nil resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
     if(!error) {
     
     double stepCount;
     
     for (id obj in results) {
     HKQuantitySample *sample = obj;
     stepCount += [sample.quantity doubleValueForUnit:[HKUnit countUnit]];
     NSLog(@"----%.f",[sample.quantity doubleValueForUnit:[HKUnit countUnit]]);
     }
     
     dispatch_async(dispatch_get_main_queue(), ^(){
     
     if (self.webView) {
     NSString *str = [NSString stringWithFormat:@"%@('%.f')",jsstr,stepCount];
     [self.webView stringByEvaluatingJavaScriptFromString:str];
     
     }else{
     NSString *str = [NSString stringWithFormat:@"%@('%.f')",jsstr,stepCount];
     [self.wkWebView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
     NSLog(@"----%@",error);
     }];
     }
     });
     
     }else {
     dispatch_async(dispatch_get_main_queue(), ^(){
     UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"查询失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alertView show];
     });
     }
     }];
     
     
     [store executeQuery:sampleQuery];
     }
     }];
     */
}

- (NSDate *)beginningOfToday {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    return [calendar dateFromComponents:components];
}
- (void)cancelButtonClicked:(NSString *)aSecondDetailViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isNewPageView = NO;
    int type = [aSecondDetailViewController intValue];
    switch (type) {
        case 0:
            [self dismissPopupViewControllerWithanimationType:6];
            
            break;
        case 1:
            [self dismissPopupViewControllerWithanimationType:7];
            break;
        case 2:
            [self dismissPopupViewControllerWithanimationType:4];
            break;
        case 3:
            [self dismissPopupViewControllerWithanimationType:1];
            break;
            
        default:
            [self dismissPopupViewControllerWithanimationType:7];
            break;
    }
}
-(void)share:(NSArray *)sModel{

    NSString *content = [sModel[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    StringsXmlBase *xBase = [StringsXML getStringXmlBase];
    NSString *imgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@%@",xBase.appsid,@"shareImage"]];
    NSURL *url = [NSURL URLWithString:sModel[2]];
    NSData *data = [NSData dataWithContentsOfFile:imgPath];
    UIImage *images = [UIImage imageWithData:data];
    NSArray *objectToShare = @[content,images,url];
    NSLog(@"--%@--",objectToShare);
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypePostToFacebook,
                                   UIActivityTypePostToTwitter,
                                   UIActivityTypePostToWeibo,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypeMessage,
                                   UIActivityTypeMail,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = nil;
    [self presentViewController:controller animated:YES completion:nil];
    
}
- (void)webviewFontSize {
    [UIAlertView showAlertViewWithTitle:@"设置字体大小" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"小号字",@"中号字",@"标准字",@"大号字",@"特大号字"] onDismiss:^(int buttonIndex, UIAlertView *alertView) {
        NSInteger fontSize;
        NSString *strFontSize = nil;
        switch (buttonIndex) {
            case 0:
                fontSize = 70;
                break;
            case 1:
                fontSize = 85;
                break;
            case 2:
                fontSize = 100;
                break;
            case 3:
                fontSize = 125;
                break;
            case 4:
                fontSize = 150;
                break;
            default:
                break;
        }
        strFontSize = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%@';",(long)fontSize,@"%"];
        if (self.webView) {
            [self.webView stringByEvaluatingJavaScriptFromString:strFontSize];
        }
        if (self.wkWebView) {
            [self.wkWebView evaluateJavaScript:strFontSize completionHandler:^(id obj, NSError *error) {
                NSLog(@"----%@",error);
            }];
        }
    } onCancel:^{
    }];
    
}

- (void)screenBrightness:(NSString *)str {
    float value = str.floatValue;
    [[UIScreen mainScreen] setBrightness:value];
}

#pragma mark - WeixinJs by  QU
- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}
- (void)handleCall:(NSString*)functionName callbackId:(int)callbackId args:(id)args
{
    
    NSLog(@"---%@---%d---%@--",functionName ,callbackId,args);
    
    /*weixinJS*/
    if ([functionName isEqualToString:@"checkJsApi"]) {
        NSDictionary *res =@{@"getNetworkType":@"ture",@"imagePreview":@"true"};
        NSDictionary *ret =@{@"errMsg":@"checkJsApi:ok",@"checkResult":res};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"onMenuShareTimeline"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.sModel.sTitle = [args objectForKey:@"title"];
        delegate.sModel.sUrl = [args objectForKey:@"link"];
        delegate.sModel.sImage = [args objectForKey:@"imgUrl"];
        [self shareToShare:delegate.sModel];
    }
    if ([functionName isEqualToString:@"onMenuShareAppMessage"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.sModel.sTitle = [args objectForKey:@"title"];
        delegate.sModel.sUrl = [args objectForKey:@"link"];
        delegate.sModel.sImage = [args objectForKey:@"imgUrl"];
        [self shareToShare:delegate.sModel];
    }
    if ([functionName isEqualToString:@"onMenuShareQQ"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.sModel.sTitle = [args objectForKey:@"title"];
        delegate.sModel.sUrl = [args objectForKey:@"link"];
        delegate.sModel.sImage = [args objectForKey:@"imgUrl"];
        [self shareToShare:delegate.sModel];
    }
    if ([functionName isEqualToString:@"onMenuShareWeibo"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.sModel.sTitle = [args objectForKey:@"title"];
        delegate.sModel.sUrl = [args objectForKey:@"link"];
        delegate.sModel.sImage = [args objectForKey:@"imgUrl"];
        [self shareToShare:delegate.sModel];
    }
    if ([functionName isEqualToString:@"onMenuShareQZone"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.sModel.sTitle = [args objectForKey:@"title"];
        delegate.sModel.sUrl = [args objectForKey:@"link"];
        delegate.sModel.sImage = [args objectForKey:@"imgUrl"];
        [self shareToShare:delegate.sModel];
    }
    if ([functionName isEqualToString:@"chooseImage"]) {
        /*选择图片*/
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            weixinJSDK = YES;
        }];
        
        NSArray *array = @[@"wxLocalResource://imageid123456789987654321",@"wxLocalResource://imageid987654321123456789"];
        NSDictionary *ret =@{@"errMsg":@"chooseImage:ok",@"localIds":array};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
        
    }
    if ([functionName isEqualToString:@"previewImage"]) {
        /*预览图片*/
        NSArray *array = [args objectForKey:@"urls"];
        NSString *title = @"";
        NSMutableArray *arrays = [NSMutableArray array];
        for (NSString *url in array) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:title forKey:@"title"];
            [dict setValue:url forKey:@"url"];
            [arrays addObject:dict];
        }
        NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
        [dicts setValue:arrays forKey:@"root"];
        
        NSLog(@"--%@--",dicts);
        NSData *data = [NSJSONSerialization dataWithJSONObject:dicts options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding ];
        [self picShow:string current:[args objectForKey:@"current"]];
        
        
        NSDictionary *ret =@{@"errMsg":@"imagePreview:ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"uploadImage"]) {
        /*上传图片*/
        NSDictionary *ret =@{@"errMsg":@"uploadImage:ok",@"serverId":@"1237378768e7q8e7r8qwesafdasdfasdfaxss111"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"downloadImage"]) {
        /*下载图片*/
        NSDictionary *ret =@{@"errMsg":@"downloadImage:ok",@"localId":@"wxLocalResource://1237378768e7q8e7r8qwe"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"startRecord"]) {
        /*开始录音*/
        [self.iflyRecognizerView start];
        [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        filePath = [docDir stringByAppendingPathComponent:@"asr.pcm"];
        [_iflyRecognizerView setParameter:filePath forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        NSLog(@"路径：%@",filePath);
        NSFileManager *mager = [NSFileManager defaultManager];
        
        
        NSDictionary *ret =@{@"errMsg":@"startRecord:ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
        
    }
    if ([functionName isEqualToString:@"stopRecord"]) {
        /*停止录音*/
        [self.iflyRecognizerView cancel];
        
        [self audio_PCMtoMP3];
        
        NSDictionary *ret =@{@"errMsg":@"stopRecord:ok",@"localId":@"wxLocalResource://voiceLocalId1234567890123"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"playVoice"]) {
        /*播放录音*/
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *mp3FilePath = [docDir stringByAppendingPathComponent:@"bbb.mp3"];
        [[AFSoundManager sharedManager]startPlayingLocalFileWithName:mp3FilePath andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
            
        }];
        
        
        
        NSDictionary *ret =@{@"errMsg":@"playVoice:ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
        
    }
    if ([functionName isEqualToString:@"pauseVoice"]) {
        /*暂停播放*/
        [[AFSoundManager sharedManager] pause];
        NSDictionary *ret =@{@"errMsg":@"pauseVoice:ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    
    if ([functionName isEqualToString:@"stopVoice"]) {
        /*停止播放*/
        [[AFSoundManager sharedManager] stop];
        NSDictionary *ret =@{@"errMsg":@"stopRecord:ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"uploadVoice"]) {
        /*上传录音*/
        NSDictionary *ret =@{@"errMsg":@"uploadVoice:ok",@"serverId":@"1237378768e7q8e7r8qwesafdasdfasdfaxss111"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"uploadVoice"]) {
        /*下载录音*/
        NSDictionary *ret =@{@"errMsg":@"downloadVoice:ok",@"localId":@"wxLocalResource://voiceLocalId1234567890123"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    
    if ([functionName isEqualToString:@"translateVoice"]) {
        /*语音识别*/
        NSDictionary *ret =@{@"errMsg":@"translateVoice:ok",@"translateResult":@"嗯，只是一个模拟调试的结果"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
        
    }
    if ([functionName isEqualToString:@"getNetworkType"]) {
        /*获取网络信息*/
        
        NSString *stateNet =[self getNetWorkStates];
        NSDictionary *ret =@{@"errMsg":@"getNetworkType:ok",@"networkType":stateNet};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"openLocation"]) {
        /*查看地理位置*/
        
        [[MapNavigationManager sharedObject] openBaiduMap];
        NSDictionary *ret =@{@"errMsg":@"openLocation:ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"getLocation"]) {
        /*获取地理位置*/
        [self startLoc];
        NSDictionary *ret =@{@"latitude":@"34.7466",@"longitude":@"113.625368",@"errMsg":@"getLocation:ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
        
    }
    if ([functionName isEqualToString:@"hideOptionMenu"]) {
        /*隐藏右上角*/
        
        NSDictionary *ret =@{@"errMsg":@"hideOptionMenu:ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
        
    }
    if ([functionName isEqualToString:@"showOptionMenu"]) {
        /*显示右上角*/
        
        NSDictionary *ret =@{@"errMsg":@"showOptionMenu:ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
        
    }
    if ([functionName isEqualToString:@"scanQRCode"]) {
        [self scanOneScan:NO];
        NSDictionary *ret =@{@"errMsg":@"",@"scanQRCode":@"ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
        /*微信扫一扫*/
    }
    if ([functionName isEqualToString:@"scanQRCode"]) {
        /*微信扫一扫带结果*/
        [self scanOneScan:YES];
        NSDictionary *ret =@{@"errMsg":@"",@"scanQRCode":@"ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
    if ([functionName isEqualToString:@"chooseWXPay"]) {
        /*微信支付*/
        NSArray *payData = @[args[@"product"],args[@"describe"],args[@"totalfee"],args[@"outtradeno"],args[@"notifyurl"]];
        weixinJSDK = YES;
        [self sendPay_demo:payData];
        
        NSDictionary *ret =@{@"errMsg":@"",@"chooseWXPay":@"ok"};
        [self returnResultToWeiXin:callbackId args:@[ret,[NSNull null]]];
    }
}
- (void)returnResultToWeiXin:(int)callbackId args:(id)arg;
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    [arg enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [resultArray addObject:obj];
    }];
    
    NSString *resultArrayString = [[NSString alloc] initWithData:[self toJSONData:resultArray]
                                                        encoding:NSUTF8StringEncoding];
    NSLog(@"回调：%@",[NSString stringWithFormat:@"wx.resultForCallback(%d,%@);",callbackId,resultArrayString]);
    
    if (self.wkWebView) {
        [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"wx.resultForCallback(%d,%@);",callbackId,resultArrayString] completionHandler:nil];
    }
    if (self.webView) {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"wx.resultForCallback(%d,%@);",callbackId,resultArrayString]];
    }
    
    
}
- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] != 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}
-(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = @"无网络";
    int netType = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"wifi";
                }
                    break;
                default:
                    break;
            }
        }
    }
    return state;
}
- (void)audio_PCMtoMP3
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *mp3FilePath = [docDir stringByAppendingPathComponent:@"bbb.mp3"];
    NSString *_recordFilePath = filePath;
    @try {
        int read, write;
        
        FILE *pcm = fopen([_recordFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;//8192
        const int MP3_SIZE = 8192;//8192
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 7500.0);//采样播音速度，值越大播报速度越快，反之。
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
            {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            }
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
    }
    
}
-(void)analysisWebViewSourceCode:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    str = [self getChineseStringWithString:str];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if (self.wkWebView) {
        
        [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"var myScriptS=document.createElement(\"script\");myScriptS.type=\"text/javascript\";myScriptS.text=%@;document.body.appendChild(myScriptS);",str] completionHandler:nil];
        
    }
    if (self.webView) {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var myScriptS=document.createElement(\"script\");myScriptS.type=\"text/javascript\";myScriptS.text=%@;document.body.appendChild(myScriptS);",str]];
    }
}
- (NSString *)getChineseStringWithString:(NSString *)string
{
    
    NSString *regex = @"//[\\s\\S]*?\\n";
    NSString *str =string;
    
    
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    
    NSArray *matches = [regular matchesInString:str
                                        options:0
                                          range:NSMakeRange(0, str.length)];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        NSString *mStr = [str substringWithRange:range];
        NSLog(@"%@", mStr);
        string = [string stringByReplacingOccurrencesOfString:mStr withString:@""];
        
    }
    return string;
    
}
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

//解码  URLDecodedString
-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

#pragma mark - FSActionSheetDelegate

- (void)FSActionSheet:(FSActionSheet *)actionSheet selectedIndex:(NSInteger)selectedIndex
{
    switch (selectedIndex) {
        case WKSelectItemSaveImage:
        {
            UIImageWriteToSavedPhotosAlbum(self.wksaveimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
        case WKSelectItemQRExtract:
        {
            NSURL *qrUrl = [NSURL URLWithString:self.wkqrCodeString];
            NSRange httpRange = [self.wkqrCodeString rangeOfString:@"http"];
            if (httpRange.location != NSNotFound) {
                [self.wkWebView loadRequest:[NSURLRequest requestWithURL:qrUrl]];
                
            }else {
                [UIAlertView showAlertViewWithTitle:NSLocalizedString(@"goodInfo", nil) message:self.wkqrCodeString cancelButtonTitle:NSLocalizedString(@"ensure", nil) otherButtonTitles:nil onDismiss:^(int buttonIndex, UIAlertView *alertView) {
                    
                } onCancel:^{
                    
                }];
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Save image callback

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存成功";
    
    if (error) {
        message = @"保存失败";
    }
    [SVProgressHUD showSuccessWithStatus:message];
    NSLog(@"save result :%@", message);
}

#pragma mark - Private methods

- (void)wkhandleLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [sender locationInView:self.wkWebView];
    // get image url where pressed.
    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    
    [self.wkWebView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imageUrl, NSError * _Nullable error) {
        
        if (imageUrl) {
//            imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            UIImage *image = [UIImage imageWithData:data];
            if (!image) {
                NSLog(@"read fail");
                return;
            }
            self.wksaveimage = image;
            
            FSActionSheet *actionSheet = nil;
            
            if ([self iswkAvailableQRcodeIn:image]) {
                
                actionSheet = [[FSActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            highlightedButtonTitle:nil
                                                 otherButtonTitles:@[@"保存图片", @"识别二维码"]];
                
            } else {
                
                actionSheet = [[FSActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            highlightedButtonTitle:nil
                                                 otherButtonTitles:@[@"保存图片"]];
            }
            [actionSheet show];
        }
    }];
}

- (BOOL)iswkAvailableQRcodeIn:(UIImage *)img
{
    if (iOS7_OR_EARLY) {
        return NO;
    }
    
    //Extract QR code by screenshot
    //UIImage *image = [self snapshot:self.view];
    
    UIImage *image = [self imageByInsetEdge:UIEdgeInsetsMake(-20, -20, -20, -20) withColor:[UIColor lightGrayColor] withImage:img];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{}];
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        
        self.wkqrCodeString = [feature.messageString copy];
        
        NSLog(@"QR result :%@", self.wkqrCodeString);
        
        return YES;
    } else {
        NSLog(@"No QR");
        return NO;
    }
}

// you can also implement by UIView category
- (UIImage *)wksnapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.window.screen.scale);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// you can also implement by UIImage category
- (UIImage *)imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color withImage:(UIImage *)image
{
    CGSize size = image.size;
    size.width -= insets.left + insets.right;
    size.height -= insets.top + insets.bottom;
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    CGRect rect = CGRectMake(-insets.left, -insets.top, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (color) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(context, path);
        CGContextEOFillPath(context);
        CGPathRelease(path);
    }
    [image drawInRect:rect];
    UIImage *insetEdgedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return insetEdgedImage;
}
#pragma mark weixinAPI
-(void)weixApi:(NSString *)name ID:(int)ID other:(id)dict{
    NSData *ServerData = [dict dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ServerData options:0 error:nil];
    NSString *URLstring = dic[@"url"];
    NSMutableDictionary *returnDict = [NSMutableDictionary dictionaryWithCapacity:10];
    NSMutableArray *JSArray = [NSMutableArray arrayWithCapacity:10];
    /*网络请求*/
    if ([name isEqualToString:@"request"]) {
        NSBlockOperation *operation1;
        NSBlockOperation *operation2;
        NSBlockOperation *operation3;
        switch (ID) {
            case 1:{
                operation1 = [NSBlockOperation blockOperationWithBlock:^{
                    NSLog(@"rulstring:%@",URLstring);
                    NSLog(@"执行第1次操作，线程：%@", [NSThread currentThread]);
                    /* 初始化请求的manager对象*/
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    /* 请求地址*/
                    NSString* url = [NSString stringWithFormat:@"%@", URLstring];
                    /*
                     * desc  : GET请求
                     * param : URLString - 请求的地址
                     *          parameters - 请求参数（GET请求，参数可以为nil 或者 可以提交一个时间戳）
                     *          success - 请求成功回调的block
                     *          failure - 请求失败回调的block
                     */
                    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSInteger state = operation.response.statusCode;
                        NSLog(@"%@",[responseObject class]);
                        
                        if ([responseObject isKindOfClass:[NSData class]]) {
                            id object = [self toArrayOrNSDictionary:responseObject];
                            NSLog(@"objectClassStr:%@", [object class]);
                            
                            if ([object isKindOfClass:[NSArray class]]) {
                                [object enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    [JSArray addObject:obj];
                                }];
                            }else if ([object isKindOfClass:[NSString class]]){
                                [JSArray addObject:responseObject];
                            }
                        }else if ([responseObject isKindOfClass:[NSArray class]]){
                            [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [JSArray addObject:obj];
                            }];
                        }
                        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
                        [returnDict setObject:JSArray forKey:@"data"];
                        [returnDict setObject:[NSNumber numberWithInteger:state] forKey:@"statusCode"];
                        [self.queue waitUntilAllOperationsAreFinished];
                        [self success:name CallID:ID json:returnDict];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
                    
                }];
                [self.queue addOperation:operation1];
            }
                break;
            case 2:{
                operation2 = [NSBlockOperation blockOperationWithBlock:^{
                    NSLog(@"rulstring:%@",URLstring);
                    NSLog(@"执行第2次操作，线程：%@", [NSThread currentThread]);
                    /* 初始化请求的manager对象*/
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    /* 请求地址*/
                    NSString* url = [NSString stringWithFormat:@"%@", URLstring];
                    /*
                     * desc  : GET请求
                     * param : URLString - 请求的地址
                     *          parameters - 请求参数（GET请求，参数可以为nil 或者 可以提交一个时间戳）
                     *          success - 请求成功回调的block
                     *          failure - 请求失败回调的block
                     */
                    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSInteger state = operation.response.statusCode;
                        if ([responseObject isKindOfClass:[NSData class]]) {
                            id object = [self toArrayOrNSDictionary:responseObject];
                            NSLog(@"objectClassStr:%@", [object class]);
                            
                            if ([object isKindOfClass:[NSArray class]]) {
                                [object enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    [JSArray addObject:obj];
                                }];
                            }else if ([object isKindOfClass:[NSString class]]){
                                [JSArray addObject:responseObject];
                            }
                        }else if ([responseObject isKindOfClass:[NSArray class]]){
                            [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [JSArray addObject:obj];
                            }];
                        }
                        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
                        [returnDict setObject:JSArray forKey:@"data"];
                        [returnDict setObject:[NSNumber numberWithInteger:state] forKey:@"statusCode"];
                        [self.queue waitUntilAllOperationsAreFinished];
                        [self success:name CallID:ID json:returnDict];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
                }];
                [self.queue addOperation:operation2];
            }
                break;
            default:{
                operation3 = [NSBlockOperation blockOperationWithBlock:^{
                    NSLog(@"rulstring:%@",URLstring);
                    NSLog(@"执行第3次操作，线程：%@", [NSThread currentThread]);
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    NSString* url = [NSString stringWithFormat:@"%@", URLstring];
                    /*
                     * desc  : GET请求
                     * param : URLString - 请求的地址
                     *          parameters - 请求参数（GET请求，参数可以为nil 或者 可以提交一个时间戳）
                     *          success - 请求成功回调的block
                     *          failure - 请求失败回调的block
                     */
                    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSInteger state = operation.response.statusCode;
                        if ([responseObject isKindOfClass:[NSData class]]) {
                            id object = [self toArrayOrNSDictionary:responseObject];
                            NSLog(@"objectClassStr:%@", [object class]);
                            
                            if ([object isKindOfClass:[NSArray class]]) {
                                [object enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    [JSArray addObject:obj];
                                }];
                            }else if ([object isKindOfClass:[NSString class]]){
                                [JSArray addObject:responseObject];
                            }
                        }else if ([responseObject isKindOfClass:[NSArray class]]){
                            [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [JSArray addObject:obj];
                            }];
                        }
                        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
                        [returnDict setObject:JSArray forKey:@"data"];
                        [returnDict setObject:[NSNumber numberWithInteger:state] forKey:@"statusCode"];
                        [self.queue waitUntilAllOperationsAreFinished];
                        [self success:name CallID:ID json:returnDict];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
                }];
                [self.queue addOperation:operation3];
            }
                break;
        }
        
        [self.queue waitUntilAllOperationsAreFinished];
    }
    if ([name isEqualToString:self.JsArray[1]]) {
        Wxrequest *request = [Wxrequest shareWxrequest];
        [request updata:URLstring andfilePath:dic[@"filePath"] name:dic[@"name"] header:nil formData:nil];/*上传文件*/
        request.successAndstate = ^(id data,NSInteger status){
            NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [returnDict setObject:json forKey:@"data"];
            [returnDict setObject:[NSNumber numberWithInteger:status] forKey:@"statusCode"];
            [self success:name CallID:ID json:returnDict];
        };
        request.failRequestAndStateBlock = ^(id data,NSInteger status){
            [returnDict setObject:[NSString stringWithFormat:@"%@:fail",name] forKey:@"errMsg"];
            [returnDict setObject:[NSNumber numberWithInteger:status] forKey:@"statusCode"];
            [self success:name CallID:ID json:dict];
        };
    }
    if ([name isEqualToString:self.JsArray[2]]) {
        Wxrequest *request = [Wxrequest shareWxrequest];
        [request downloadfile:URLstring header:URLstring];/*下载*/
        request.successAndstate = ^(id data,NSInteger status){
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [returnDict setObject:data forKey:@"tempFilePath"];
            [returnDict setObject:[NSNumber numberWithInteger:status] forKey:@"statusCode"];
            [self success:name CallID:ID json:returnDict];
        };
        request.failRequestAndStateBlock = ^(id data,NSInteger status){
            [returnDict setObject:[NSString stringWithFormat:@"%@:fail",name] forKey:@"errMsg"];
            [returnDict setObject:[NSNumber numberWithInteger:status] forKey:@"statusCode"];
            [self success:name CallID:ID json:returnDict];
        };
    }
    /*选择图片*/
    if ([name isEqualToString:self.JsArray[10]]) {
        NSInteger count = [dic[@"count"] integerValue];
        NSArray *size = dic[@"sizeType"];
        NSArray *sourceType = dic[@"sourceType"];
        GetImage *getimage = [GetImage shareUploadImage];
        [getimage showActionSheetInFatherViewController:self delegate:self andCount:count size:size sourceType:sourceType];
        getimage.resault = ^(NSDictionary* object){
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [returnDict setValuesForKeysWithDictionary:object];
            [self success:name CallID:ID json:returnDict];
        };
    }
    /*浏览图片*/
    if ([name isEqualToString:self.JsArray[11]]) {
        NSArray *array = dic[@"urls"];
        NSString *title = @"";
        NSMutableArray *arrays = [NSMutableArray array];
        for (NSString *url in array) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:title forKey:@"title"];
            [dict setValue:url forKey:@"url"];
            [arrays addObject:dict];
        }
        NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
        [dicts setValue:arrays forKey:@"root"];
        NSLog(@"--%@--",dicts);
        NSData *data = [NSJSONSerialization dataWithJSONObject:dicts options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding ];
        [self picShow:string current:dic[@"current"]];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*GET图片信息*/
    if ([name isEqualToString:self.JsArray[12]]) {
        UIImage *image;
        NSString *urlstr = dic[@"src"];
        NSRange inUrl = [urlstr rangeOfString:@"http:"];
        if (inUrl.location != NSNotFound) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"src"]]]];
        }else{
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://42.236.75.187:3001%@",dic[@"src"]]]]];
        }
        /* 本地沙盒目录*/
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        /* 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名*/
        NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage.jpg"];
        /* 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大*/
        BOOL success = [UIImageJPEGRepresentation(image, 0.5) writeToFile:imageFilePath  atomically:YES];
        if (success){
            NSLog(@"写入本地成功");
        }
        NSNumber *width =[[NSNumber alloc]initWithFloat:image.size.width];
        NSNumber *height =[[NSNumber alloc]initWithFloat:image.size.height];
        [returnDict setObject:width forKey:@"width"];
        [returnDict setObject:height forKey:@"height"];
        [returnDict setObject:imageFilePath forKey:@"path"];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*录音*/
    if ([name isEqualToString:self.JsArray[13]]) {
        NSString *filePath = [[AFSoundManager sharedManager] record:nil andstopsecond:15];
        [returnDict setObject:filePath forKey:@"tempFilePath"];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*stopRecord*/
    if ([name isEqualToString:self.JsArray[14]]) {
        [[AFSoundManager sharedManager] stopAndSaveRecording];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.playVoice*/
    if ([name isEqualToString:self.JsArray[15]]) {
        if ([dic[@"filePath"] rangeOfString:@"http://"].location !=NSNotFound ) {
            [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:dic[@"filePath"] andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
                if (finished) {
                    [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
                    [self success:name CallID:ID json:returnDict];
                }
            }];
        }else{
            [[AFSoundManager sharedManager] playRecord:dic[@"filePath"]];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        }
    }
    /*wx.pauseVoice*/
    if ([name isEqualToString:self.JsArray[16]]) {
        [[AFSoundManager sharedManager] pause];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.stopVoice*/
    if ([name isEqualToString:self.JsArray[17]]) {
        [[AFSoundManager sharedManager] stop];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.getBackgroundAudioPlayerState*/
    if ([name isEqualToString:self.JsArray[18]]) {
        NSDictionary *dict = [[AFSoundManager sharedManager] WxapiretrieveInfoForCurrentPlaying];
        [returnDict setValuesForKeysWithDictionary:dict];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.playBackgroundAudio*/
    if ([name isEqualToString:self.JsArray[19]]) {
        [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:dic[@"dataUrl"] andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
            if (finished) {
                [returnDict setObject:[NSString stringWithFormat:@"%@:fail",name] forKey:@"errMsg"];
                [self success:name CallID:ID json:returnDict];
            }
        }];
    }
    /*wx.pauseBackgroundAudio*/
    if ([name isEqualToString:self.JsArray[20]]) {
        [[AFSoundManager sharedManager] pause];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.seekBackgroundAudio*/
    if ([name isEqualToString:self.JsArray[21]]) {
        int time = [dic[@"position"] intValue];
        [[AFSoundManager sharedManager]moveToSecond:time];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.stopBackgroundAudio*/
    if ([name isEqualToString:self.JsArray[22]]) {
        [[AFSoundManager sharedManager] stop];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.chooseVideo*/
    if ([name isEqualToString:self.JsArray[27]]) {
        GetImage *video = [GetImage shareUploadImage];
        int d = [dic[@"maxDuration"] intValue];
        [video showActionSheetInVideoViewController:self delegate:self sourceType:dic[@"sourceType"] camera:dic[@"camera"] maxDuration:d];
        video.resault = ^(NSDictionary* object){
            [returnDict setValuesForKeysWithDictionary:object];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        };
    }
    /*wx.createVideoContext*/
    if ([name isEqualToString:self.JsArray[28]]) {
    }
    /*保存文件到本地*/
    if ([name isEqualToString:self.JsArray[29]]) {
        NSString *filePath = [[Filemanager shareFileManger] saveFile:dic[@"tempFilePath"]];
        [returnDict setValue:filePath forKey:@"temfilepath"];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.getSavedFileList*/
    if ([name isEqualToString:self.JsArray[30]]) {
        NSMutableArray *fileArray = [[Filemanager shareFileManger] getSaveFilelist];
        [returnDict setValue:fileArray forKey:@"fiellist"];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*获取本地文件的文件信息*/
    if ([name isEqualToString:self.JsArray[31]]) {
        NSDictionary *dict = [[Filemanager shareFileManger] getsaveFileInfo:nil];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [returnDict setValuesForKeysWithDictionary:dict];
        [self success:name CallID:ID json:returnDict];
    }
    /*删除本地存储的文件*/
    if ([name isEqualToString:self.JsArray[32]]) {
        BOOL isRemove = [[Filemanager shareFileManger] remoneSaveFile:nil];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*新开页面打开文档，支持格式：doc, xls, ppt, pdf, docx, xlsx, pptx*/
    if ([name isEqualToString:self.JsArray[33]]) {
        [[Filemanager shareFileManger] openDocument:dic[@"filePath"] andeVc:self];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.setStorage*/
    if ([name isEqualToString:self.JsArray[34]]) {
        [[Filemanager shareFileManger] setStorage:dic[@"key"] andData:dic[@"data"]];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[35]]) {
        [[Filemanager shareFileManger] setStorage:dic[@"key"] andData:dic[@"data"]];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*wx.getStorage*/
    if ([name isEqualToString:self.JsArray[36]]) {
        [[Filemanager shareFileManger] getStorage:dic[@"key"] block:^(NSData *data) {
            NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [returnDict setValue:json forKey:@"data"];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        }];
    }
    if ([name isEqualToString:self.JsArray[37]]) {
        [[Filemanager shareFileManger] getStorage:dict block:^(NSData *data) {
            NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [returnDict setValue:json forKey:@"data"];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        }];
    }
    /*wx.getStorageInfo*/
    if ([name isEqualToString:self.JsArray[38]]) {
        [[Filemanager shareFileManger] getStorageInfoblok:^(NSDictionary *dict) {
            [returnDict setValuesForKeysWithDictionary:dict];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        }];
    }
    if ([name isEqualToString:self.JsArray[39]]) {
        [[Filemanager shareFileManger] getStorageInfoblok:^(NSDictionary *dict) {
            [returnDict setValuesForKeysWithDictionary:dict];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        }];
    }
    if ([name isEqualToString:self.JsArray[40]]) {
        [[Filemanager shareFileManger] removeStorage:dic[@"key"]];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[41]]) {
        [[Filemanager shareFileManger] removeStorage:dict];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[42]]) {
        [[Filemanager shareFileManger] clearStorage];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[43]]) {
        [[Filemanager shareFileManger] clearStorage];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*位置*/
    if ([name isEqualToString:self.JsArray[44]]) {
        IsLocationGPS *location = [IsLocationGPS sharedObject];
        [location startLocation];
        location.location = ^(NSDictionary *location){
            [returnDict setValuesForKeysWithDictionary:location];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        };
    }
    if ([name isEqualToString:self.JsArray[45]]) {
    }
    if ([name isEqualToString:self.JsArray[46]]) {
        NSArray *globalArray = [dic allValues];
        [[MapNavigationManager sharedObject]baiduMap:globalArray];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /* 设备信息*/
    if ([name isEqualToString:self.JsArray[48]]) {
        NSDictionary *deviceINFO= [[DeviceInfoObject sharedObject] retanDeviceInfo];
        [returnDict setValuesForKeysWithDictionary:deviceINFO];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[49]]) {
        NSDictionary *deviceINFO= [[DeviceInfoObject sharedObject] retanDeviceInfo];
        [returnDict setValuesForKeysWithDictionary:deviceINFO];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /* 网络状态*/
    if ([name isEqualToString:self.JsArray[50]]) {
        NSString *NetINFO= [self getNetWorkStates];
        [returnDict setValue:NetINFO forKey:@"networkType"];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /* 重力感应*/
    if ([name isEqualToString:self.JsArray[51]]) {
        DeviceInfoObject *info = [DeviceInfoObject sharedObject];
        [info useAccelerometerPush];
        info.accXYZ = ^(NSDictionary *dict){
            [returnDict setValuesForKeysWithDictionary:dict];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        };
    }
    /* 罗盘*/
    if ([name isEqualToString:self.JsArray[52]]) {
        IsLocationGPS *loc = [IsLocationGPS sharedObject];
        [loc startLocationHead];
        loc.compassChange = ^(CGFloat string){
            [returnDict setValue:[NSNumber numberWithFloat:string] forKey:@"direction"];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        };
    }
    /*拨打电话*/
    if ([name isEqualToString:self.JsArray[53]]) {
        NSString *phoneNumber = dic[@"phoneNumber"];
        NSString *mobileUrl =[NSString stringWithFormat:@"tel://%@",phoneNumber];
        UIAlertController *mobileAlert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"拨号给%@?",phoneNumber] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"拨号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobileUrl]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [mobileAlert addAction:suerAction];
        [mobileAlert addAction:cancelAction];
        [self presentViewController:mobileAlert animated:YES completion:^{
        }];
    }
    /*扫一扫*/
    if ([name isEqualToString:self.JsArray[54]]) {
        HwReaderViewController *readerVC = [[HwReaderViewController alloc] init];
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:readerVC];
        readerVC.completionHandler = ^(NSString *itemStr) {
            [returnDict setObject:itemStr forKey:@"result"];
            [returnDict setObject:@"QR_CODE" forKey:@"scanType"];
            [returnDict setObject:@"utf-8" forKey:@"charSet"];
            [returnDict setObject:@"" forKey:@"path"];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        };
        [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    }
    if ([name isEqualToString:self.JsArray[55]]) {
        NSString *title = [NSString stringWithFormat:@"%@",dic[@"title"]];
        title = [self stringWhitNoSpaceString:title];
        [MBProgressHUD show:title icon:dic[@"icon"] view:self.view duration:[dic[@"duration"] floatValue] mask:NO];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[56]]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*提示框*/
    if ([name isEqualToString:self.JsArray[57]]) {
        UIAlertController *alerView;
        BOOL isShowCancel;
        NSString *cancel= nil;
        
        if ([[dic allKeys] containsObject:@"showCancel"]) {
            isShowCancel = [dic[@"showCancel"] boolValue];
        }else{
            isShowCancel = YES;
        }
        if ([[dic allKeys] containsObject:@"cancelText"]) {
            cancel= dic[@"cancelText"];
        }else{
            cancel = nil;
        }
        NSString *title = nil;
        NSString *content = nil;
        
        if ([[dic allKeys] containsObject:@"content"]) {
            if (![dic[@"content"]isKindOfClass:[NSString class]]) {
                
                content = [self objectTostring:dic[@"content"]];
            }else{
                content = [NSString stringWithFormat:@"%@",dic[@"content"]];
            }
        }
        if ([[dic allKeys] containsObject:@"title"]) {
            if (![dic[@"title"]isKindOfClass:[NSString class]]) {
                title = [self objectTostring:dic[@"title"]];
            }else{
                title = dic[@"title"];
            }
        }
        alerView = [UIAlertController showAlertView:title message:content CancelTitle:cancel cancelColor:dic[@"cancelColor"] sureTitle:dic[@"confirmText"] sureColor:dic[@"confirmColor"] isDisCancel:isShowCancel and:^{
            [self success:name CallID:ID json:@{@"errMsg":[NSString stringWithFormat:@"%@:ok",name],@"confirm":[NSNumber numberWithBool:0] ,@"cancel":[NSNumber numberWithBool:1]}];
        } andDismissBlok:^{
            [self success:name CallID:ID json:@{@"errMsg":[NSString stringWithFormat:@"%@:ok",name],@"confirm":[NSNumber numberWithBool:1],@"cancel":[NSNumber numberWithBool:0]}];
        }];
        [self presentViewController:alerView animated:YES completion:^{
        }];
    }
    if ([name isEqualToString:self.JsArray[58]]) {
        UIAlertController *sheetvc = [UIAlertController showActionsheet:dic[@"itemList"] andColors:nil and:^{
            NSLog(@"cancel!");
            [returnDict setObject:@"showActionSheet:fail cancel" forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        } andDismissBlok:^(int a) {
            [returnDict setObject:[NSNumber numberWithInt:a] forKey:@"tapIndex"];
            [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
            [self success:name CallID:ID json:returnDict];
        }];
        [self presentViewController:sheetvc animated:YES completion:^{
        }];
    }
    if ([name isEqualToString:self.JsArray[59]]) {
        self.navigationItem.titleView= nil;
        NSString *str = dic[@"title"];
        self.navigationItem.title = str;
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[60]]) {
    }
    if ([name isEqualToString:self.JsArray[61]]) {
    }
    if ([name isEqualToString:self.JsArray[62]]) {
        NSString *currUrlstr= self.currentUrlStr;
        NSArray *array = [URLstring componentsSeparatedByString:@"../"];
        NSLog(@"%@333%ld",array,array.count);
        NSArray *array2 = [currUrlstr componentsSeparatedByString:@"/"];
        for (int i = 0; i<array.count; i++) {
            currUrlstr = [currUrlstr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",[array2 objectAtIndex:array2.count-1-i]] withString:@""];
        }
        currUrlstr = [currUrlstr stringByAppendingString:[NSString stringWithFormat:@"/%@",[array lastObject]]];
        currUrlstr = [currUrlstr stringByReplacingOccurrencesOfString:@"app/" withString:@"#!"];
        HwTwoPageViewController* twoVC = [[HwTwoPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
        twoVC.hidesBottomBarWhenPushed = YES;
        twoVC.urlStr = currUrlstr;
        NSLog(@"--->%@",currUrlstr);
        
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationController pushViewController:twoVC animated:YES];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[63]]) {
        NSString *currUrlstr= self.currentUrlStr;
        NSArray *array = [URLstring componentsSeparatedByString:@"../"];
        NSLog(@"%@333%ld",array,array.count);
        NSArray *array2 = [currUrlstr componentsSeparatedByString:@"/"];
        for (int i = 0; i<array.count; i++) {
            currUrlstr = [currUrlstr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",[array2 objectAtIndex:array2.count-1-i]] withString:@""];
        }
        currUrlstr = [currUrlstr stringByAppendingString:[NSString stringWithFormat:@"/%@",[array lastObject]]];
        currUrlstr = [currUrlstr stringByReplacingOccurrencesOfString:@"app/" withString:@"#!"];
        
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currUrlstr]]];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[64]]) {
        NSString *currUrlstr= self.currentUrlStr;
        NSArray *array = [URLstring componentsSeparatedByString:@"../"];
        NSLog(@"%@333%ld",array,array.count);
        NSArray *array2 = [currUrlstr componentsSeparatedByString:@"/"];
        for (int i = 0; i<array.count; i++) {
            currUrlstr = [currUrlstr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",[array2 objectAtIndex:array2.count-1-i]] withString:@""];
        }
        currUrlstr = [currUrlstr stringByAppendingString:[NSString stringWithFormat:@"/%@",[array lastObject]]];
        currUrlstr = [currUrlstr stringByReplacingOccurrencesOfString:@"app/" withString:@"#!"];
        
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currUrlstr]]];
    }
    if ([name isEqualToString:self.JsArray[65]]) {
        if ([_wkWebView canGoBack]) {
            [_wkWebView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:self.JsArray[66]]) {
    }
    if ([name isEqualToString:self.JsArray[110]]) {
        [self.webView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
        self.webView.scrollView.bounces = YES;
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    /*停止刷新*/
    if ([name isEqualToString:self.JsArray[111]]) {
        [self.wkWebView.scrollView headerEndRefreshing];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
    if ([name isEqualToString:@"onShareAppMessage"]) {
        ShareModel *shareObject = [[ShareModel alloc]init];
        shareObject.sTitle = [NSString stringWithFormat:@"%@",dic[@"title"]];
        shareObject.sContent= [NSString stringWithFormat:@"%@",dic[@"desc"]];
        shareObject.sUrl = [NSString stringWithFormat:@"%@",dic[@"path"]];
        [self shareToShare:shareObject];
        [returnDict setObject:[NSString stringWithFormat:@"%@:ok",name] forKey:@"errMsg"];
        [self success:name CallID:ID json:returnDict];
    }
}
-(void)success:(NSString *)name CallID:(int)ID json:(id)json{
    NSLog(@"-->%@",json);
    if (json==nil||[json isKindOfClass:[NSNull class]]|| json == NULL) {
        return;
    }
    NSString *resultArrayString;
    NSMutableArray *jsArray = [NSMutableArray arrayWithCapacity:9];
    if ([json isKindOfClass:[NSMutableArray class]]) {
        [json enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [jsArray addObject:obj];
        }];
    }else{
        [jsArray addObject:json];
    }
    if ([NSJSONSerialization isValidJSONObject:jsArray]) {
        resultArrayString = [self objectTostring:jsArray];
    }else{
        resultArrayString = @"no jsonObject!";
    }
    resultArrayString = [self stringWhitNoSpaceString:resultArrayString];
    NSString *retureStr = [NSString stringWithFormat:@"window.frames['service'].wx.resultForCallback(%d,%@)",ID,resultArrayString];
    NSLog(@"ruture--%@",retureStr);
    [self.wkWebView evaluateJavaScript:retureStr completionHandler:^(id data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"--%@--",error);
        }
    }];
}
-(NSArray *)JsArray{
    if (_JsArray ==nil) {
        _JsArray = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"JSstrPlist" ofType:@"plist"]]];
    }
    return _JsArray;
}
-(NSString *)objectTostring:(id)object{
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    if (![NSJSONSerialization isValidJSONObject:object]) {
        return nil;
    }
    NSString *str;
    NSError  *__autoreleasing error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) {
        NSLog(@"error:%@",error);
    }else{
        str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n\t" withString:@""];
    }
    return str;
}
-(NSString *)stringWhitNoSpaceString:(NSString *)str{
    NSString *title = [NSString stringWithFormat:@"%@",str];
    title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    title = [title stringByReplacingOccurrencesOfString:@"\n\t" withString:@""];
    return title;
}
-(void)shareCallBack{
    HwTools *tools = [HwTools shareTools];
    tools.completion=^(NSString *state,NSString *type){
        NSDictionary *dict = @{@"platform":type,@"state":state};
        NSString *json = [self objectTostring:dict];
        if (self.wkWebView) {
            [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"%@(%@);",jsstr,json] completionHandler:nil];
        }
        if (self.webView) {
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@);",jsstr,json]];
        }
    };
}
#pragma mark --Orientation
- (void)clickToRotate:(int)type {
    
    CustomNavigationController *navigationController = (CustomNavigationController *)self.navigationController;
    switch (type) {
        case 0:
            navigationController.interfaceOrientation = UIInterfaceOrientationPortrait;
            navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
            //设置屏幕的转向为竖屏
            [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
            break;
        case 2:
            navigationController.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
            navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
            //设置屏幕的转向为横屏
            [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeRight) forKey:@"orientation"];
            break;
        case 1:
            navigationController.interfaceOrientation = UIInterfaceOrientationMaskAll;
            navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskAll;
            //设置屏幕的转向为自适应
            [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationMaskAll) forKey:@"orientation"];
//            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            delegate.screenOrientationStr =@"1";
            break;
            //        default:
            //            break;
    }
    
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}
NSString *const SystemSocialType_WeiXin=@"com.tencent.xin.sharetimeline";
NSString *const SystemSocialType_QQ=@"com.tencent.mqq.ShareExtension";
-(void)MultiPicShare:(NSArray *)picArray andConten:(NSString *)conten andType:(int )type
{
    
    // 2.1.添加分享的文字
    UIPasteboard *copy = [UIPasteboard generalPasteboard];
    copy.string = conten;
    /*
     UILabel *label = [[UILabel alloc]init];
     [label setText:[NSString stringWithFormat: @"分享内容已复制成功，去粘贴！"]];
     [label setFont:[UIFont systemFontOfSize:14]];
     [label setBackgroundColor:[UIColor lightGrayColor]];
     [label setTextAlignment:NSTextAlignmentCenter];
     [label setTextColor:[UIColor whiteColor]];
     
     label.layer.cornerRadius = 10;
     label.layer.masksToBounds = YES;
     label.frame = CGRectMake(0, 0, 230, 30);
     label.center = CGPointMake(self.view.bounds.size.width/2, 80);
     label.alpha = 1.0;
     [self.view addSubview:label];
     [UIView animateWithDuration:2.0 animations:^{
     label.alpha = 0.0;
     } completion:^(BOOL finished) {
     [label removeFromSuperview];
     }];
     */
    if (![SLComposeViewController isAvailableForServiceType:SystemSocialType_QQ]) {
        NSLog(@"到设置界面里面去设置自己的QQ账号");
        return;
    }
    
    SLComposeViewController *composeVc;
    if (type == 0 || type ==1) {
        composeVc = [self setComposeView:SystemSocialType_QQ];
    }else if (type ==2 || type == 3){
        composeVc = [self setComposeView:SystemSocialType_WeiXin];
    }else{
        [self MoreShare:picArray];
        return;
    }
    [composeVc setInitialText:@"梦想还是要有的,万一实现了呢!-----且行且珍惜_iOS"];
    // 2.2.添加分享的图片
    //    NSMutableArray *activityItems = [NSMutableArray array];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for(int i = 0;i<picArray.count;i++)
    {
        //文件名请自己处理
        NSString *filename = [NSString stringWithFormat:@"shared_%d.jpg", i];
        NSString *filestr = [NSString stringWithFormat:@"%@/%@", cachesDir, filename];
        if(![fileManager fileExistsAtPath:filestr])
        {
            //图片路径请处理成自己的
            UIImage * imageFromURL = [QYHTool getImageFromURL:[NSString stringWithFormat:@"%@",picArray[i]]];
            
            
            [QYHTool saveImage:imageFromURL withFileName:filestr ofType:@"jpg"];
        }
        [composeVc addImage:[UIImage imageWithContentsOfFile:filestr]];
        
    }
    // 2.3 添加分享的URL
    //    [composeVc addURL:[NSURL URLWithString:@"https://github.com/wslcmk"]];
    
    // 3.弹出控制器进行分享
    [self presentViewController:composeVc animated:YES completion:nil];
    
    // 4.设置监听发送结果
    composeVc.completionHandler = ^(SLComposeViewControllerResult reulst) {
        if (reulst == SLComposeViewControllerResultDone) {
            NSLog(@"用户发送成功");
        } else {
            NSLog(@"用户发送失败");
        }
    };
    
}
-(SLComposeViewController *)setComposeView:(NSString *)type{
    return [SLComposeViewController composeViewControllerForServiceType:type];
}
-(void)MoreShare:(NSArray *)picArray{
    NSMutableArray *activityItems = [NSMutableArray array];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for(int i = 0;i<picArray.count;i++)
    {
        //文件名请自己处理
        NSString *filename = [NSString stringWithFormat:@"shared_%d.jpg", i];
        NSString *filestr = [NSString stringWithFormat:@"%@/%@", cachesDir, filename];
        if(![fileManager fileExistsAtPath:filestr])
        {
            //图片路径请处理成自己的
            UIImage * imageFromURL = [QYHTool getImageFromURL:[NSString stringWithFormat:@"%@",picArray[i]]];
            
            
            [QYHTool saveImage:imageFromURL withFileName:filestr ofType:@"jpg"];
        }
        [activityItems addObject:[UIImage imageWithContentsOfFile:filestr]];
        
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //初始化回调方法
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionWithItemsHandler = myBlock;
    }else{
        
        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionHandler = myBlock;
    }
    
    NSArray *excludeActivities = @[UIActivityTypePostToFacebook,
                                   UIActivityTypePostToTwitter,
                                   UIActivityTypePostToWeibo,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypeMessage,
                                   UIActivityTypeMail,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToTencentWeibo];
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
-(void)setNavbarTitleColor:(NSString *)hexstring{
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                               NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    [HwTools UserDefaultsObj:@"#000000" key:@"NavBarTitleColor"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"#000000" forKey:@"color"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate showMainVC];
}
-(void)setLeftOrRightSideView{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL isnow;
    if (delegate.isleftOrrightMenu) {
        isnow = NO;
    }else{
        isnow = YES;
    }

//    BOOL isRightMenu = [messageBody boolValue];
    delegate.isleftOrrightMenu = isnow;
    [self hideBackMenu];
    [self addMenuBtnItem];
    [delegate showMainVC];
//    isnow = delegate.isleftOrrightMenu;
    
    [[HwTools shareTools]getCacheSizeCompletion:^(float size) {
        NSString *returnStr = [NSString stringWithFormat:@"(%f)",size];
        NSLog(@"%@",returnStr);
        [self.wkWebView evaluateJavaScript:returnStr completionHandler:^(id obj, NSError * _Nullable error) {
            
        }];
    }];
}
@end
