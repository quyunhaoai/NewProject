//
//  HwOnePageViewController.h
//  CloudApp
//a
//  Created by 9vs on 15/1/14.
//
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UIViewController+ScrollingNavbar.h"
#import "WebViewAdditions.h"
#import "WkWebViewAdditions.h"
#import "UIViewController+MMDrawerController.h"
#import <StoreKit/StoreKit.h>
#import "AGPhotoBrowserView.h"
#import "DataModels.h"
#import "ClockView.h"
#import "HwReaderViewController.h"
#import "CustomNavigationController.h"
#import "HwTools.h"
#import <MapKit/MapKit.h>
#import "AKTabBarController.h"
#import "UIViewController+AKTabBarController.h"
#import "MLKMenuPopover.h"
#import "NJKWebViewProgress.h"
#import "MyWebViewAdditions.h"
#import <WebKit/WebKit.h>
#import "payRequsestHandler.h"
#import "WXApi.h"
#import "DLPanableWebView.h"
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)


@interface HwOnePageViewController : UIViewController <UIScrollViewDelegate,SKStoreProductViewControllerDelegate,AGPhotoBrowserDelegate,IFlyRecognizerViewDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate,AGPhotoBrowserDataSource,MLKMenuPopoverDelegate,NJKWebViewProgressDelegate,UIWebViewDelegate,WKScriptMessageHandler, WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) DLPanableWebView *webView;
@property (strong, nonatomic) NSString *currentUrlStr;
@property (strong, nonatomic) NSString *shareUrlStr;
@property (strong, nonatomic) NSString *imgStr;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) AGPhotoBrowserView *browserView;
@property (strong, nonatomic) NSString *saveImgUrl;
@property (strong, nonatomic) UIControl *reloadControl;

//带界面的听写识别对象
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) BMKLocationService *locService;

@property(nonatomic, strong) NSString *tabTitleStr;
@property(nonatomic, strong) NSString *tabImageNameStr;
@property(nonatomic, strong) NSString *activeTabImageNameStr;

@property(nonatomic,strong) MLKMenuPopover *menuPopover;
@property(nonatomic,assign) BOOL isShowJsCustomTitle;
@property (nonatomic,strong) NSString *jsCustomTitleStr;

@property (nonatomic,strong) NJKWebViewProgress *progressProxy;
@property (nonatomic,strong) WKWebView *wkWebView;

@property (nonatomic,assign) BOOL isWkWebViewFailLoad;
@property (nonatomic,assign) BOOL isWkWebViewBackForward;
@property (nonatomic,strong) NSString *refreshMenuStr;
@property (nonatomic,assign) NSInteger moreSelect;
- (void)create9vImgJavaScript;
- (void)hideAldClock;
- (void)updateLoadingStatus;
- (void)dismissMenuPop;
@end
